"""
Translytical task flow - writeback function.

Called from a Power BI data function button. Writes the comment an employee
types in the report back into the Fabric SQL database. Because the semantic
model is DirectQuery over the same database, the report reflects the new value
without a refresh.

Contract notes:
  * A data function must return `str` to be selectable from a Power BI button.
  * Every parameter below is required, so the button stays disabled until the
    report supplies all of them (a selected review + a typed comment).
  * The three key parameters come from SELECTEDVALUE measures on the writeback
    table, so they always resolve to the exact row being updated. See the repo
    README for why binding them to dimension columns instead is fragile.
"""

import fabric.functions as fn

udf = fn.UserDataFunctions()

MAX_COMMENT_LENGTH = 20000


# `alias` must match the connection alias in definition.json.
@udf.connection(argName="sqlDB", alias="SQLDemo2026")
@udf.function()
def write_emp_info_on_product_Review(
    sqlDB: fn.FabricSqlConnection,
    productid: int,
    ReviewID: int,
    EmployeeID: int,
    employeeComments: str,
) -> str:

    # ---- input validation: surfaces a friendly message inside the report ----
    if employeeComments is None or not employeeComments.strip():
        raise fn.UserThrownError("Please enter a comment before submitting.", {})

    if len(employeeComments) > MAX_COMMENT_LENGTH:
        raise fn.UserThrownError(
            f"Comments have a {MAX_COMMENT_LENGTH} character limit. Please shorten your response.",
            {"length": len(employeeComments)},
        )

    connection = None
    cursor = None
    try:
        connection = sqlDB.connect()
        cursor = connection.cursor()

        update_query = """
            UPDATE dbo.product_review_feedback
            SET employee_comments = ?,
                updated_date      = GETDATE()
            WHERE ProductID   = ?
              AND ReviewID    = ?
              AND employee_ID = ?
        """
        cursor.execute(update_query, (employeeComments, productid, ReviewID, EmployeeID))

        # ---- IMPORTANT ------------------------------------------------------
        # Without this check the function commits and returns "success" even
        # when the WHERE clause matched nothing - so a broken report binding
        # looks exactly like a working save. Always verify rowcount.
        if cursor.rowcount == 0:
            connection.rollback()
            raise fn.UserThrownError(
                "No matching review was found, so nothing was saved. "
                "Select a review row in the table and try again.",
                {"ProductID": productid, "ReviewID": ReviewID, "EmployeeID": EmployeeID},
            )

        connection.commit()
        return f"Response saved for review {ReviewID}."

    except fn.UserThrownError:
        raise
    except Exception as exc:  # database offline / unreachable / permissions
        if connection is not None:
            try:
                connection.rollback()
            except Exception:
                pass
        raise fn.UserThrownError(
            "Could not save your response because the database is unreachable. "
            "Please try again in a moment.",
            {"detail": str(exc)},
        )
    finally:
        if cursor is not None:
            try:
                cursor.close()
            except Exception:
                pass
        if connection is not None:
            try:
                connection.close()
            except Exception:
                pass
