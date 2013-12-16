USE [Jenkins]
GO

/****** Object:  StoredProcedure [dbo].[USP_WORKLOAD]    Script Date: 12/10/2013 5:19:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[USP_WORKLOAD]   

AS     

WITH
 expanded 
AS
(
  SELECT weburl, jobs, LastBuild, loopcount  FROM qry_Workload

UNION ALL


  SELECT  webUrl, jobs, LastBuild -1 , loopcount - 1 FROM expanded WHERE loopcount > 1 
)



SELECT DISTINCT	
(weburl + convert(varchar, lastbuild) + '/api/xml') as url
FROM
  expanded
ORDER BY
url
option (maxrecursion 0)


GO


