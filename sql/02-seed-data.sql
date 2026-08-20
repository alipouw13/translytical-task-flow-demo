/* ---------------------------------------------------------------------------
   02-seed-data.sql
   Sample data for the translytical task flow demo.
   Run AFTER 01-create-tables.sql and after the AdventureWorksLT sample data
   has been loaded (SalesLT.Product supplies the ProductID values used below).
   --------------------------------------------------------------------------- */

SET NOCOUNT ON;

/* Employees -------------------------------------------------------------- */
DELETE FROM dbo.employees;
SET IDENTITY_INSERT dbo.employees ON;
INSERT INTO dbo.employees (employee_ID, FirstName, LastName, JobTitle) VALUES
  (1, 'Syed', 'Abbas', 'Pacific Sales Manager'),
  (2, 'Kim', 'Abercrombie', 'Production Technician - WC60'),
  (3, 'Hazem', 'Abolrous', 'Quality Assurance Manager'),
  (4, 'Pilar', 'Ackerman', 'Shipping and Receiving Supervisor'),
  (5, 'Jay', 'Adams', 'Production Technician - WC60'),
  (6, 'François', 'Ajenstat', 'Database Administrator'),
  (7, 'Amy', 'Alberts', 'European Sales Manager'),
  (8, 'Greg', 'Alderson', 'Production Technician - WC45'),
  (9, 'Sean', 'Alexander', 'Quality Assurance Technician'),
  (10, 'Gary', 'Altman', 'Facilities Manager'),
  (11, 'Nancy', 'Anderson', 'Production Technician - WC60'),
  (12, 'Pamela', 'Ansman-Wolfe', 'Sales Representative'),
  (13, 'Zainal', 'Arifin', 'Document Control Manager'),
  (14, 'Dan', 'Bacon', 'Application Specialist'),
  (15, 'Bryan', 'Baker', 'Production Technician - WC60'),
  (16, 'Mary', 'Baker', 'Production Technician - WC10'),
  (17, 'Angela', 'Barbariol', 'Production Technician - WC50'),
  (18, 'David', 'Barber', 'Assistant to the Chief Financial Officer'),
  (19, 'Paula', 'Barreto de Mattos', 'Human Resources Manager'),
  (20, 'Wanida', 'Benshoof', 'Marketing Assistant');
SET IDENTITY_INSERT dbo.employees OFF;

/* Product reviews -------------------------------------------------------- */
DELETE FROM dbo.product_reviews;
SET IDENTITY_INSERT dbo.product_reviews ON;
INSERT INTO dbo.product_reviews (ReviewID, ProductID, ReviewText, SentimentLabel, CreatedAt) VALUES
  (1, 717, 'Absolutely love this product! Great quality and performance.', 'Positive', '2026-04-02T14:13:57.283'),
  (2, 723, 'Absolutely love this product! Great quality and performance.', 'Positive', '2026-04-02T14:13:57.283'),
  (3, 962, 'Absolutely love this product! Great quality and performance.', 'Positive', '2026-04-02T14:13:57.283'),
  (4, 720, 'Absolutely love this product! Great quality and performance.', 'Positive', '2026-04-02T14:13:57.283'),
  (5, 857, 'Absolutely love this product! Great quality and performance.', 'Positive', '2026-04-02T14:13:57.283'),
  (6, 922, 'Exceeded my expectations. Highly recommend to others!', 'Positive', '2026-04-02T14:13:57.290'),
  (7, 963, 'Exceeded my expectations. Highly recommend to others!', 'Positive', '2026-04-02T14:13:57.290'),
  (8, 759, 'Exceeded my expectations. Highly recommend to others!', 'Positive', '2026-04-02T14:13:57.290'),
  (9, 906, 'Exceeded my expectations. Highly recommend to others!', 'Positive', '2026-04-02T14:13:57.290'),
  (10, 842, 'Exceeded my expectations. Highly recommend to others!', 'Positive', '2026-04-02T14:13:57.290'),
  (11, 836, 'It works as expected. Nothing more, nothing less.', 'Neutral', '2026-04-02T14:13:57.297'),
  (12, 766, 'It works as expected. Nothing more, nothing less.', 'Neutral', '2026-04-02T14:13:57.297'),
  (13, 965, 'It works as expected. Nothing more, nothing less.', 'Neutral', '2026-04-02T14:13:57.297'),
  (14, 935, 'It works as expected. Nothing more, nothing less.', 'Neutral', '2026-04-02T14:13:57.297'),
  (15, 878, 'It works as expected. Nothing more, nothing less.', 'Neutral', '2026-04-02T14:13:57.297'),
  (16, 990, 'Average product. Decent value for the price.', 'Neutral', '2026-04-02T14:13:57.303'),
  (17, 788, 'Average product. Decent value for the price.', 'Neutral', '2026-04-02T14:13:57.303'),
  (18, 903, 'Average product. Decent value for the price.', 'Neutral', '2026-04-02T14:13:57.303'),
  (19, 987, 'Average product. Decent value for the price.', 'Neutral', '2026-04-02T14:13:57.303'),
  (20, 949, 'Average product. Decent value for the price.', 'Neutral', '2026-04-02T14:13:57.303'),
  (21, 774, 'Disappointed with the quality. Would not buy again.', 'Negative', '2026-04-02T14:13:57.310'),
  (22, 831, 'Disappointed with the quality. Would not buy again.', 'Negative', '2026-04-02T14:13:57.310'),
  (23, 827, 'Disappointed with the quality. Would not buy again.', 'Negative', '2026-04-02T14:13:57.310'),
  (24, 888, 'Disappointed with the quality. Would not buy again.', 'Negative', '2026-04-02T14:13:57.310'),
  (25, 852, 'Disappointed with the quality. Would not buy again.', 'Negative', '2026-04-02T14:13:57.310'),
  (26, 860, 'Had issues from day one. Poor customer experience.', 'Negative', '2026-04-02T14:13:57.313'),
  (27, 988, 'Had issues from day one. Poor customer experience.', 'Negative', '2026-04-02T14:13:57.313'),
  (28, 878, 'Had issues from day one. Poor customer experience.', 'Negative', '2026-04-02T14:13:57.313'),
  (29, 861, 'Had issues from day one. Poor customer experience.', 'Negative', '2026-04-02T14:13:57.313'),
  (30, 709, 'Had issues from day one. Poor customer experience.', 'Negative', '2026-04-02T14:13:57.313');
SET IDENTITY_INSERT dbo.product_reviews OFF;

/* Writeback target --------------------------------------------------------
   One row per review. employee_comments starts NULL - the user data function
   fills it in from the Power BI report.                                     */
DELETE FROM dbo.product_review_feedback;
INSERT INTO dbo.product_review_feedback (ProductID, ReviewID, employee_ID, employee_comments, resolution, created_date, updated_date) VALUES
  (717, 1, 13, NULL, NULL, '2026-04-02T19:40:36.783', NULL),
  (723, 2, 19, NULL, NULL, '2026-04-02T19:40:37.580', NULL),
  (962, 3, 18, NULL, NULL, '2026-04-02T19:40:38.103', NULL),
  (720, 4, 16, NULL, NULL, '2026-04-02T19:40:38.580', NULL),
  (857, 5, 13, NULL, NULL, '2026-04-02T19:40:40.620', NULL),
  (922, 6, 18, NULL, NULL, '2026-04-02T19:40:42.407', NULL),
  (963, 7, 19, NULL, NULL, '2026-04-02T19:40:42.927', NULL),
  (759, 8, 15, NULL, NULL, '2026-04-02T19:40:43.540', NULL),
  (906, 9, 2, NULL, NULL, '2026-04-02T19:40:44.397', NULL),
  (842, 10, 18, NULL, NULL, '2026-04-02T19:40:46.147', NULL),
  (836, 11, 12, NULL, NULL, '2026-04-02T19:40:47.920', NULL),
  (766, 12, 2, NULL, NULL, '2026-04-02T19:40:48.387', NULL),
  (965, 13, 1, NULL, NULL, '2026-04-02T19:40:48.923', NULL),
  (935, 14, 11, NULL, NULL, '2026-04-02T19:40:49.370', NULL),
  (878, 15, 14, NULL, NULL, '2026-04-02T19:40:50.180', NULL),
  (990, 16, 6, NULL, NULL, '2026-04-02T19:40:50.743', NULL),
  (788, 17, 4, NULL, NULL, '2026-04-02T19:40:51.467', NULL),
  (903, 18, 19, NULL, NULL, '2026-04-02T19:40:53.073', NULL),
  (987, 19, 3, NULL, NULL, '2026-04-02T19:40:53.967', NULL),
  (949, 20, 5, NULL, NULL, '2026-04-02T19:40:54.490', NULL),
  (774, 21, 10, NULL, NULL, '2026-04-02T19:40:56.060', NULL),
  (831, 22, 7, NULL, NULL, '2026-04-02T19:40:56.787', NULL),
  (827, 23, 3, NULL, NULL, '2026-04-02T19:40:57.563', NULL),
  (888, 24, 4, NULL, NULL, '2026-04-02T19:40:59.297', NULL),
  (852, 25, 8, NULL, NULL, '2026-04-02T19:41:00.070', NULL),
  (860, 26, 16, NULL, NULL, '2026-04-02T19:41:00.647', NULL),
  (988, 27, 4, NULL, NULL, '2026-04-02T19:41:01.150', NULL),
  (878, 28, 14, NULL, NULL, '2026-04-02T19:41:01.823', NULL),
  (861, 29, 17, NULL, NULL, '2026-04-02T19:41:02.320', NULL),
  (709, 30, 5, NULL, NULL, '2026-04-02T19:41:03.010', NULL);

/* Employee -> product ownership ------------------------------------------ */
DELETE FROM dbo.Employee_Assigned_Products;
INSERT INTO dbo.Employee_Assigned_Products (employee_ID, ProductID) VALUES
  (1, 680), (2, 706), (3, 707), (4, 708), (5, 709), (6, 710), (7, 711), (8, 712),
  (9, 713), (10, 714), (11, 715), (12, 716), (13, 717), (14, 718), (15, 719), (16, 720),
  (17, 721), (18, 722), (19, 723), (20, 724), (1, 725), (2, 726), (3, 727), (4, 728),
  (5, 729), (6, 730), (7, 731), (8, 732), (9, 733), (10, 734), (11, 735), (12, 736),
  (13, 737), (14, 738), (15, 739), (16, 740), (17, 741), (18, 742), (19, 743), (20, 744),
  (1, 745), (2, 746), (3, 747), (4, 748), (5, 749), (6, 750), (7, 751), (8, 752),
  (9, 753), (10, 754), (11, 755), (12, 756), (13, 757), (14, 758), (15, 759), (16, 760),
  (17, 761), (18, 762), (19, 763), (20, 764), (1, 765), (2, 766), (3, 767), (4, 768),
  (5, 769), (6, 770), (7, 771), (8, 772), (9, 773), (10, 774), (11, 775), (12, 776),
  (13, 777), (14, 778), (15, 779), (16, 780), (17, 781), (18, 782), (19, 783), (20, 784),
  (1, 785), (2, 786), (3, 787), (4, 788), (5, 789), (6, 790), (7, 791), (8, 792),
  (9, 793), (10, 794), (11, 795), (12, 796), (13, 797), (14, 798), (15, 799), (16, 800),
  (17, 801), (18, 802), (19, 803), (20, 804), (1, 805), (2, 806), (3, 807), (4, 808),
  (5, 809), (6, 810), (7, 811), (8, 812), (9, 813), (10, 814), (11, 815), (12, 816),
  (13, 817), (14, 818), (15, 819), (16, 820), (17, 821), (18, 822), (19, 823), (20, 824),
  (1, 825), (2, 826), (3, 827), (4, 828), (5, 829), (6, 830), (7, 831), (8, 832),
  (9, 833), (10, 834), (11, 835), (12, 836), (13, 837), (14, 838), (15, 839), (16, 840),
  (17, 841), (18, 842), (19, 843), (20, 844), (1, 845), (2, 846), (3, 847), (4, 848),
  (5, 849), (6, 850), (7, 851), (8, 852), (9, 853), (10, 854), (11, 855), (12, 856),
  (13, 857), (14, 858), (15, 859), (16, 860), (17, 861), (18, 862), (19, 863), (20, 864),
  (1, 865), (2, 866), (3, 867), (4, 868), (5, 869), (6, 870), (7, 871), (8, 872),
  (9, 873), (10, 874), (11, 875), (12, 876), (13, 877), (14, 878), (15, 879), (16, 880),
  (17, 881), (18, 882), (19, 883), (20, 884), (1, 885), (2, 886), (3, 887), (4, 888),
  (5, 889), (6, 890), (7, 891), (8, 892), (9, 893), (10, 894), (11, 895), (12, 896),
  (13, 897), (14, 898), (15, 899), (16, 900), (17, 901), (18, 902), (19, 903), (20, 904),
  (1, 905), (2, 906), (3, 907), (4, 908), (5, 909), (6, 910), (7, 911), (8, 912),
  (9, 913), (10, 914), (11, 915), (12, 916), (13, 917), (14, 918), (15, 919), (16, 920),
  (17, 921), (18, 922), (19, 923), (20, 924), (1, 925), (2, 926), (3, 927), (4, 928),
  (5, 929), (6, 930), (7, 931), (8, 932), (9, 933), (10, 934), (11, 935), (12, 936),
  (13, 937), (14, 938), (15, 939), (16, 940), (17, 941), (18, 942), (19, 943), (20, 944),
  (1, 945), (2, 946), (3, 947), (4, 948), (5, 949), (6, 950), (7, 951), (8, 952),
  (9, 953), (10, 954), (11, 955), (12, 956), (13, 957), (14, 958), (15, 959), (16, 960),
  (17, 961), (18, 962), (19, 963), (20, 964), (1, 965), (2, 966), (3, 967), (4, 968),
  (5, 969), (6, 970), (7, 971), (8, 972), (9, 973), (10, 974), (11, 975), (12, 976),
  (13, 977), (14, 978), (15, 979), (16, 980), (17, 981), (18, 982), (19, 983), (20, 984),
  (1, 985), (2, 986), (3, 987), (4, 988), (5, 989), (6, 990), (7, 991), (8, 992),
  (9, 993), (10, 994), (11, 995), (12, 996), (13, 997), (14, 998), (15, 999);

GO
PRINT 'Seed data loaded.';
