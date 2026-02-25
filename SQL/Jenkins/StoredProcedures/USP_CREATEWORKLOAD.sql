USE [Jenkins]
GO

/****** Object:  StoredProcedure [dbo].[USP_CREATEWORKLOAD]    Script Date: 12/10/2013 5:20:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[USP_CREATEWORKLOAD]   

AS     

/*
  Returns the list of build URLs that GrabXML.ps1 should process.

  Modern usage: pass this stored procedure name via the -WorkloadSP parameter of GrabXML.ps1
  so that the script reads URLs directly from the database without requiring a workload file:

      .\GrabXML.ps1 -Server <server> -Database Jenkins -User <user> -Password (Read-Host -AsSecureString) `
                    -WorkloadSP USP_CREATEWORKLOAD -JenkinsUser <user> -JenkinsToken <token>

  Legacy usage: The result set can still be exported to a flat file by the SQL Agent job
  using PowerShell's Invoke-Sqlcmd and Out-File if a workload file is required.
*/

EXEC USP_WORKLOAD

GO


