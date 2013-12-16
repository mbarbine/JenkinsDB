USE [Jenkins]
GO

/****** Object:  View [dbo].[qry_TodaysBuilds]    Script Date: 12/10/2013 5:18:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qry_TodaysBuilds]
AS
SELECT DISTINCT 
                         TOP (20) dbo.tbl_job.ProjectName AS Jobs, dbo.tbl_projects.webUrl + CONVERT(varchar, dbo.tbl_job.Buildnbr) AS webUrl, CONVERT(DATETIME, 
                         LEFT(LEFT(dbo.tbl_projects.LastBuildDT, 10) + ' ' + RIGHT(dbo.tbl_projects.LastBuildDT, 9), 19)) AS CompletionTime, dbo.tbl_job.Buildnbr AS LastBuild, 
                         dbo.tbl_job.BuildDT AS LastBuildDT, dbo.tbl_job.Result AS LastBuildSts, dbo.tbl_job.CreateDT, dbo.tbl_projects.PrevLastBuild, 
                         dbo.tbl_projects.LastBuild - dbo.tbl_projects.PrevLastBuild AS Loopcount
FROM            dbo.tbl_job INNER JOIN
                         dbo.tbl_projects ON dbo.tbl_job.ProjectName = dbo.tbl_projects.ProjectName
WHERE        (dbo.tbl_job.ProjectName <> 'git-logger-linux') AND (NOT (dbo.tbl_job.ProjectName = N'slave-runner-linux')) AND (NOT (dbo.tbl_job.ProjectName LIKE 'slave-runner')) 
                         AND (NOT (dbo.tbl_job.ProjectName LIKE '%single-%')) AND (NOT (dbo.tbl_job.ProjectName LIKE 'slave-reverter')) AND 
                         (NOT (dbo.tbl_job.ProjectName LIKE N'slave-reverter-linux')) AND (NOT (dbo.tbl_job.ProjectName LIKE 'slave-runner-%')) AND 
                         (NOT (dbo.tbl_job.ProjectName LIKE N'whitelist_service-%')) AND (NOT (dbo.tbl_job.ProjectName LIKE N'slave-reverter-%')) AND 
                         (NOT (dbo.tbl_job.ProjectName LIKE N'parent_satori_%')) AND (NOT (dbo.tbl_job.ProjectName LIKE N'MAP-Elsa-%'))
ORDER BY dbo.tbl_job.CreateDT DESC

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "tbl_job"
            Begin Extent = 
               Top = 6
               Left = 251
               Bottom = 135
               Right = 429
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbl_projects"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 213
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
      Begin ColumnWidths = 11
         Width = 284
         Width = 3540
         Width = 7695
         Width = 2430
         Width = 3315
         Width = 1500
         Width = 3105
         Width = 3045
         Width = 6750
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 11100
         Alias = 3510
         Table = 3735
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 4185
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qry_TodaysBuilds'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qry_TodaysBuilds'
GO


