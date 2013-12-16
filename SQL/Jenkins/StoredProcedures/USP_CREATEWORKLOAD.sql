USE [Jenkins]
GO

/****** Object:  StoredProcedure [dbo].[USP_CREATEWORKLOAD]    Script Date: 12/10/2013 5:20:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[USP_CREATEWORKLOAD]   

AS     

EXEC xp_cmdshell 'bcp "Execute jenkins.dbo.usp_workload" queryout "E:\XML\BUilds\workload.txt" -T -c -t,' 
GO


