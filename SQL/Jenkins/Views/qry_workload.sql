USE [Jenkins]
GO

/****** Object:  View [dbo].[qry_WorkLoad]    Script Date: 12/10/2013 5:18:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qry_WorkLoad]
AS
SELECT DISTINCT webUrl, ProjectName AS Jobs, LastBuild - PrevLastBuild AS LoopCount, LastBuild, LastBuildDT, ProjectActivity
FROM            dbo.tbl_projects
WHERE        (ProjectName = 'MIR-packaging-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'Clifford-Packaging-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'Redline-Packaging-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'mir-weekly') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'app processor-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'MIR-core-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'MIR-libraries-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'SuperGlue Weekly mir 3.x') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'CliffordUI-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'felistener-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'ioc matcher-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'Litmus-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'Mea-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'panlistener-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'SfAgent-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'sfServer-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'sfTasker-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'sfTaskerNode-master') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping') OR
                         (ProjectName = 'weekly-Clifford') AND (LastBuild - PrevLastBuild > 0) AND (LastBuild - PrevLastBuild < 20) AND (ProjectActivity = 'Sleeping')

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tbl_projects"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 347
               Right = 558
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 17
         Width = 284
         Width = 7065
         Width = 3210
         Width = 3000
         Width = 3825
         Width = 1500
         Width = 2145
         Width = 1500
         Width = 3570
         Width = 1905
         Width = 1500
         Width = 1500
         Width = 1260
         Width = 75
         Width = 1455
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 30
         Column = 3765
         Alias = 1785
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 4845
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1770
         Or = 1350
         Or = 1815
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1965
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 2415
         Or = 2505
         Or = 2250
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qry_WorkLoad'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qry_WorkLoad'
GO

