USE [Jenkins]
GO

/****** Object:  StoredProcedure [dbo].[USP_JENKINS_XML_REVIEW]    Script Date: 12/10/2013 5:23:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[USP_JENKINS_XML_REVIEW]   

AS     

  BEGIN     

        SET NOCOUNT ON     
		               

        DECLARE @HANDLE INT     
        DECLARE @SQUERY VARCHAR(1000)
        DECLARE @XMLDOC XML 
		DECLARE @SERVERNAME VARCHAR(255) 
		DECLARE @BuildNbrLen int
		DECLARE @BuildNumber INT
		DECLARE @ProjectName VARCHAR(255) 
		SET @SERVERNAME = 'http://<ServerName>/job/' 
		
		
	
        SET @XMLDOC = (SELECT *  FROM OPENROWSET 
                      (BULK 'E:\xml\builds\xmlreview.xml', SINGLE_CLOB) AS XMLDATA) 


  
        EXEC SP_XML_PREPAREDOCUMENT  @HANDLE OUTPUT,@XMLDOC   

	
	 SELECT *
      FROM OPENXML(@HANDLE, 'freeStyleBuild', 20)  


		END

GO


