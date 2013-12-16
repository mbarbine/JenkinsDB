USE [Jenkins]
GO
/****** Object:  StoredProcedure [dbo].[USP_CREATE_JOB_DATA]    Script Date: 12/10/2013 5:20:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[USP_CREATE_JOB_DATA]   

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
		
		SET @SERVERNAME = 'http://<Servername>:8079/job/'
	    SET @XMLDOC = (SELECT *  FROM OPENROWSET 
                      (BULK 'E:\xml\builds\BuildData.xml', SINGLE_CLOB) AS XMLDATA) 


  
        EXEC SP_XML_PREPAREDOCUMENT  @HANDLE OUTPUT,@XMLDOC   
		
IF OBJECT_ID('#tmp_tbl_artifacts', 'U') IS NOT NULL		
DROP TABLE #tmp_tbl_artifacts
IF OBJECT_ID('#tmp_tbl_artifacttext', 'U') IS NOT NULL
DROP TABLE #tmp_tbl_artifacttext
IF OBJECT_ID('#tmp_tbl_artifactdata', 'U') IS NOT NULL
DROP TABLE #tmp_tbl_artifactdata
IF OBJECT_ID('#ArtifactName', 'U') IS NOT NULL
DROP TABLE #ArtifactName
IF OBJECT_ID('#tmp_tbl_jobartifacts', 'U') IS NOT NULL
DROP TABLE #tmp_tbl_jobartifacts
IF OBJECT_ID('##UUID', 'U') IS NOT NULL
DROP TABLE ##UUID
IF OBJECT_ID('#tmp_tbl_artifactUUID', 'U') IS NOT NULL
DROP TABLE #tmp_tbl_artifactUUID


/* CREATE TABLE TMP_TBL_JOB */
/* CREATE TABLE TMP_TBL_JOB */
/* CREATE TABLE TMP_TBL_JOB */
/* CREATE TABLE TMP_TBL_JOB */


IF OBJECT_ID('#tmp_tbl_job', 'U') IS NOT NULL
  DROP TABLE dbo.tmp_tbl_job

  CREATE TABLE #tmp_tbl_job(
	[UUID] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NOT NULL,
	[parentid] [int] NULL,
	[nodetype] [int] NULL,
	[localname] [nvarchar](255) NULL,
	[prefix] [nvarchar](255) NULL,
	[namespaceuri] [nvarchar](255) NULL,
	[datatype] [nvarchar](255) NULL,
	[prev] [nvarchar](255) NULL,
	[text] [nvarchar](max) NULL,
 CONSTRAINT [PK_tmp_tbl_job] PRIMARY KEY CLUSTERED 
(
	[id] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


	 INSERT INTO #tmp_tbl_job
           ([id]
		   ,[parentid]
           ,[nodetype]
           ,[localname]
           ,[prefix]
           ,[namespaceuri]
           ,[datatype]
           ,[prev]
		    ,[text])   
	  SELECT 
			[id]
		   ,[parentid]
           ,[nodetype]
           ,[localname]
           ,[prefix]
           ,[namespaceuri]
           ,[datatype]
           ,[prev]
		   ,[text] 
      FROM OPENXML(@HANDLE, 'freeStyleBuild', 20)  


	SELECT * FROM #tmp_tbl_job

/* CREATE TMP_TBL_JOBTEXT */ 
/* CREATE TMP_TBL_JOBTEXT */ 
/* CREATE TMP_TBL_JOBTEXT */ 
/* CREATE TMP_TBL_JOBTEXT */ 

			
IF OBJECT_ID('#tmp_tbl_jobtext', 'U') IS NOT NULL
  DROP TABLE dbo.tmp_tbl_jobtext

  CREATE TABLE #tmp_tbl_jobtext(
	[UUID] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NOT NULL,
	[parentid] [int] NULL,
	[localname] [nvarchar](255) NULL,
	[text] [nvarchar](max) NULL,
 CONSTRAINT [PK_tmp_tbl_jobtext] PRIMARY KEY CLUSTERED 
(
	[uuid] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	 INSERT INTO #tmp_tbl_jobtext
           ([id]
		   ,[parentid]
           ,[localname]
    	   ,[text])   
	  SELECT 
	      [id]
		   ,[parentid]
           ,[localname]
    	   ,[text]
      FROM #tmp_tbl_job 
	  WHERE text is not null 

	SELECT * FROM #tmp_tbl_jobtext


/* CREATE TMP_TBL_JOBDATA */ 
/* CREATE TMP_TBL_JOBDATA */ 
/* CREATE TMP_TBL_JOBDATA */ 
/* CREATE TMP_TBL_JOBDATA */ 


IF OBJECT_ID('#tmp_tbl_jobdata', 'U') IS NOT NULL
  DROP TABLE dbo.tmp_tbl_jobdata

  CREATE TABLE #tmp_tbl_jobdata(
	[UUID] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NOT NULL,
	[parentid] [int] NULL,
	[localname] [nvarchar](255) NULL,
	[text] [nvarchar](max) NULL,
 CONSTRAINT [PK_tmp_tbl_jobdata] PRIMARY KEY CLUSTERED 
(
	[UUID] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]



/* THIS IS WHERE YOU SPECIFY THE COLUMNS YOU WANT */ 
/* THIS IS WHERE YOU SPECIFY THE COLUMNS YOU WANT */ 
/* THIS IS WHERE YOU SPECIFY THE COLUMNS YOU WANT */ 
/* THIS IS WHERE YOU SPECIFY THE COLUMNS YOU WANT */ 
/* THIS IS WHERE YOU SPECIFY THE COLUMNS YOU WANT */ 
/* THIS IS WHERE YOU SPECIFY THE COLUMNS YOU WANT */ 



	 INSERT INTO #tmp_tbl_jobdata
           ([id]
		   ,[parentid]
           ,[localname]
    	   ,[text])  
	  SELECT  #tmp_tbl_job.id, #tmp_tbl_job.parentid, #tmp_tbl_job.localname, #tmp_tbl_jobtext.text
  	 FROM   #tmp_tbl_jobtext LEFT OUTER JOIN
                        #tmp_tbl_job ON [#tmp_tbl_job].id = #tmp_tbl_jobtext.parentid
WHERE        ([#tmp_tbl_job].localname = N'shortdescription') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'SHA1') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'fullName') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'absoluteUrl') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'kind') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'comment') OR
                         (CONVERT(nvarchar, [#tmp_tbl_job].localname) = N'commitId') OR
                         (CONVERT(nvarchar, [#tmp_tbl_job].localname) = N'timestamp') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'url') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'result') OR
                         (CONVERT(nvarchar, [#tmp_tbl_job].localname) = N'number') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'keepLog') OR
                         (CONVERT(nvarchar, [#tmp_tbl_job].localname) = N'fullDisplayName') OR
                         (CONVERT(nvarchar, [#tmp_tbl_job].localname) = N'estimatedDuration') OR
                         (CONVERT(nvarchar, [#tmp_tbl_job].localname) = N'duration') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'building') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'remoteUrl') OR
                         (CONVERT(varchar, [#tmp_tbl_job].localname) = N'id') OR
						 (CONVERT(varchar, [#tmp_tbl_job].localname) = N'upstreamBuild') OR 
						 (CONVERT(varchar, [#tmp_tbl_job].localname) = N'upstreamProject') OR 
						 (CONVERT(varchar, [#tmp_tbl_job].localname) = N'upstreamUrl') OR
						 (CONVERT(varchar, [#tmp_tbl_job].localname) = N'buildType') OR 
						 (CONVERT(varchar, [#tmp_tbl_job].localname) = N'Component') OR 
						 (CONVERT(varchar, [#tmp_tbl_job].localname) = N'componentVersion') OR 
						 (CONVERT(varchar, [#tmp_tbl_job].localname) = N'parentBuildNumber') OR 
						 (CONVERT(varchar, [#tmp_tbl_job].localname) = N'projectName') OR 
						 (CONVERT(varchar, [#tmp_tbl_job].localname) = N'srcInfo') OR
						 (CONVERT(varchar, [#tmp_tbl_job].localname) = N'tpVersion') 




Select * from #tmp_tbl_jobdata

/* INSERT job URL INTO TBL_JOB */ 
/* INSERT job URL INTO TBL_JOB */ 
/* INSERT job URL INTO TBL_JOB */ 

INSERT INTO [dbo].[tbl_job] 
			([BuildURL])  	
	SELECT   [text] 
	FROM       #tmp_tbl_jobdata 
	WHERE  #tmp_tbl_jobdata.localname = 'url' 



/* CREATE A UNIQUE IDENTIFIER BY PARSING OUT PROJECT NAME FROM URL AND BUILD NUMER AND THE TWO STRINGS INTO SEPERATE LOCAL VARIABLES */
/* CREATE A UNIQUE IDENTIFIER BY PARSING OUT PROJECT NAME FROM URL AND BUILD NUMER AND THE TWO STRINGS INTO SEPERATE LOCAL VARIABLES */
/* CREATE A UNIQUE IDENTIFIER BY PARSING OUT PROJECT NAME FROM URL AND BUILD NUMER AND THE TWO STRINGS INTO SEPERATE LOCAL VARIABLES */
/* CREATE A UNIQUE IDENTIFIER BY PARSING OUT PROJECT NAME FROM URL AND BUILD NUMER AND THE TWO STRINGS INTO SEPERATE LOCAL VARIABLES */



IF OBJECT_ID('#ProjectURL', 'U') IS NOT NULL
  DROP TABLE #ProjectURL

CREATE TABLE #ProjectURL
	([id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectURL] [varchar](1000) NULL)
	
INSERT INTO #ProjectURL 
			([ProjectURL])  	
	SELECT   [text] 
	FROM       #tmp_tbl_jobdata 
	WHERE  #tmp_tbl_jobdata.localname = 'url' 

IF OBJECT_ID('#ProjectName', 'U') IS NOT NULL
  DROP TABLE #ProjectName

CREATE TABLE #ProjectName
	([id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [varchar](1000) NULL)
	
INSERT INTO #ProjectName
			([ProjectName])  	
	SELECT   [text] 
	FROM       #tmp_tbl_jobdata 
	WHERE  #tmp_tbl_jobdata.localname = 'url' 

	
IF OBJECT_ID('#BuildnbrLen', 'U') IS NOT NULL
  DROP TABLE #BuildnbrLen

	
CREATE TABLE #BuildnbrLen
	([id] [int] IDENTITY(1,1) NOT NULL,
	[BuildnbrLen] [nvarchar](10) NULL)
	
INSERT INTO #BuildnbrLen
			([buildnbrLen])  	
	SELECT   LEN([text]) 
	FROM       #tmp_tbl_jobdata
	WHERE  #tmp_tbl_jobdata.localname = 'number' 

	SELECT * from #BuildnbrLen

UPDATE [dbo].[tbl_job]
   SET [Buildnbr] = (SELECT [text]
   FROM #tmp_tbl_jobdata
  WHERE #tmp_tbl_jobdata.localname = 'number') 
  WHERE dbo.tbl_job.Buildnbr is null
    
UPDATE #ProjectName
   SET [ProjectName] = (SELECT REPLACE(#ProjectURL.[ProjectURL], @SERVERNAME, '') 
   FROM #ProjectURL)   

UPDATE #ProjectName
   SET [ProjectName] = RTRIM(LEFT(ProjectName, LEN(ProjectName)-2))
   FROM #ProjectName

 SET @BuildNbrLen = '' 
SELECT @BuildNbrLen = @BuildNbrLen + #BuildnbrLen.BuildnbrLen FROM #BuildnbrLen

UPDATE #ProjectName
   SET [ProjectName] =  LTRIM(LEFT(ProjectName, LEN(ProjectName)-@BuildNbrLen))
   FROM #ProjectName

UPDATE [dbo].[tbl_job]
   SET [ProjectName] = #ProjectName.Projectname
   FROM #ProjectName
  WHERE tbl_job.ProjectName is null 
   
   SELECT * from #ProjectName
 
CREATE TABLE #Buildnbr
	([id] [int] IDENTITY(1,1) NOT NULL,
	[Buildnbr] INT)
	
INSERT INTO #Buildnbr
			([Buildnbr])  	
	SELECT   [text] 
	FROM       #tmp_tbl_jobdata 
	WHERE  #tmp_tbl_jobdata.localname = 'number' 

SELECT * FROM #Buildnbr

SET @BuildNumber = '' 
SELECT @BuildNumber = @BuildNumber + #Buildnbr.Buildnbr from #Buildnbr

SET @ProjectName = ''
SELECT @ProjectName = @ProjectName + #ProjectName.ProjectName from #ProjectName

IF OBJECT_ID('##UUID', 'U') IS NOT NULL
  DROP TABLE ##UUID

CREATE TABLE ##UUID
	([id] [int] IDENTITY(1,1) NOT NULL,
	[UUID] VARCHAR(255))
	
INSERT INTO ##UUID
			([UUID])  	
	SELECT DISTINCT tbl_job.ProjectName + Convert(varchar, tbl_job.buildnbr, 50)
	FROM      tbl_job
	WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber)
 
 SELECT DISTINCT UUID FROM ##UUID 
 


/* UPDATE FIELDS IN JOB DATA NOW THAT A UUID IS CREATED (UUID is Projectname + BuildNBR) */
/* UPDATE FIELDS IN JOB DATA NOW THAT A UUID IS CREATED (UUID is Projectname + BuildNBR) */
/* UPDATE FIELDS IN JOB DATA NOW THAT A UUID IS CREATED (UUID is Projectname + BuildNBR) */
/* UPDATE FIELDS IN JOB DATA NOW THAT A UUID IS CREATED (UUID is Projectname + BuildNBR) */



UPDATE [dbo].[tbl_job]
   SET [UUID] = ##UUID.UUID
   FROM ##UUID
  WHERE tbl_job.UUID is null  

UPDATE [dbo].[tbl_job]
  SET [CreateDT] = GETDATE()
  FROM ##UUID
  WHERE (tbl_job.UUID = ##UUID.UUID)  


/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 
/* ADD ANY NEW FIELDS FROM XML FILES HERE */ 



UPDATE [dbo].[tbl_job]
   SET [BuildDT] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'id' 

UPDATE [dbo].[tbl_job]
   SET [giturl] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'remoteUrl' 

UPDATE [dbo].[tbl_job]
   SET [duration] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'duration' 

UPDATE [dbo].[tbl_job]
   SET [EstDuration] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'EstimatedDuration'

UPDATE [dbo].[tbl_job]
   SET [FullDisplayName] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'fullDisplayName'

UPDATE [dbo].[tbl_job]
   SET [Keeplog] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'keepLog'

UPDATE [dbo].[tbl_job]
   SET [Result] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'result'

UPDATE [dbo].[tbl_job]
   SET [ResultDT] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'timestamp'

UPDATE [dbo].[tbl_job]
   SET [CommitID] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'commitId'

UPDATE [dbo].[tbl_job]
   SET [commitDT] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'timestamp'

UPDATE [dbo].[tbl_job]
   SET [UserName] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'fullName'

UPDATE [dbo].[tbl_job]
   SET [UserURL] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'absoluteUrl'

UPDATE [dbo].[tbl_job]
   SET [Comment] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'comment'

UPDATE [dbo].[tbl_job]
   SET [commentType] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'kind'

UPDATE [dbo].[tbl_job]
   SET [upstreamBuild] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'upstreamBuild'


UPDATE [dbo].[tbl_job]
   SET [upstreamProject] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'upstreamProject'


UPDATE [dbo].[tbl_job]
   SET [upstreamUrl] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'upstreamUrl'


UPDATE [dbo].[tbl_job]
   SET [buildType] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'buildType'

UPDATE [dbo].[tbl_job]
   SET [component] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'Component'

UPDATE [dbo].[tbl_job]
   SET [ComponentVer] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'ComponentVersion'

UPDATE [dbo].[tbl_job]
   SET [ParentBuildNumber] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'ParentBuildNumber'

UPDATE [dbo].[tbl_job]
   SET [ProductName] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'ProjectName'

UPDATE [dbo].[tbl_job]
   SET [BuildSource] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'srcInfo'

UPDATE [dbo].[tbl_job]
   SET [TPVersion] = #tmp_tbl_jobdata.[text]
   FROM #tmp_tbl_jobdata
WHERE (tbl_job.ProjectName = @ProjectName and tbl_job.Buildnbr = @BuildNumber) and  #tmp_tbl_jobdata.localname = 'tpVersion'


/* STOP ADDING NEW FIELDS  */ 
/* STOP ADDING NEW FIELDS  */ 
/* STOP ADDING NEW FIELDS  */ 
/* STOP ADDING NEW FIELDS  */ 
/* STOP ADDING NEW FIELDS  */ 




/* CLEAN UP TIME!!!!! */ 
/* CLEAN UP TIME!!!!! */
/* CLEAN UP TIME!!!!! */
/* CLEAN UP TIME!!!!! */

 DROP TABLE #BuildnbrLen 
 DROP TABLE #tmp_tbl_jobtext
 DROP TABLE #ProjectURL



/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ /* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 
/* TIME FOR ARTIFACT PROCESSING */ 


		DECLARE @ARTIFACTCHECK VARCHAR(1000)  
		DECLARE @COUNTER INT 
	
  



		SET @ARTIFACTCHECK = 'Select #tmp_tbl_artifacts.id = count(*) From #tmp_tbl_artifacts' 
		SET @COUNTER = 40 
		SET @XMLDOC = (SELECT *  FROM OPENROWSET 
                      (BULK 'E:\xml\builds\BuildData.xml', SINGLE_CLOB) AS XMLDATA) 


          EXEC SP_XML_PREPAREDOCUMENT  @HANDLE OUTPUT,@XMLDOC   
	
		
IF OBJECT_ID('#tmp_tbl_artifacts', 'U') IS NOT NULL
  DROP TABLE #tmp_tbl_artifacts

  CREATE TABLE #tmp_tbl_artifacts(
	[UUID] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NOT NULL,
	[parentid] [int] NULL,
	[nodetype] [int] NULL,
	[localname] [nvarchar](255) NULL,
	[prefix] [nvarchar](255) NULL,
	[namespaceuri] [nvarchar](255) NULL,
	[datatype] [nvarchar](255) NULL,
	[prev] [nvarchar](255) NULL,
	[text] [nvarchar](max) NULL,
 CONSTRAINT [PK_tmp_tbl_artifacts] PRIMARY KEY CLUSTERED 
(
	[id] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


	 INSERT INTO #tmp_tbl_artifacts
           ([id]
		   ,[parentid]
           ,[nodetype]
           ,[localname]
           ,[prefix]
           ,[namespaceuri]
           ,[datatype]
           ,[prev]
		    ,[text])   
	  SELECT 
			[id]
		   ,[parentid]
           ,[nodetype]
           ,[localname]
           ,[prefix]
           ,[namespaceuri]
           ,[datatype]
           ,[prev]
		   ,[text] 
      FROM OPENXML(@HANDLE, 'freeStyleBuild', 20)  

	SELECT * FROM #tmp_tbl_artifacts
	
IF OBJECT_ID('#tmp_tbl_jobartifacts', 'U') IS NOT NULL
  DROP TABLE #tmp_tbl_jobartifacts

CREATE TABLE #tmp_tbl_jobartifacts(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UUID] [nvarchar](255) NULL,
	[ProjectName] [nvarchar](255) NULL,
	[Buildnbr] [int] NULL,
	[CreateDT] [datetime] NULL,
	[ArtifactName] [nvarchar](255) NULL,
	[RelativePath] [nvarchar](255) NULL,
 CONSTRAINT [PK_tmp_tbl_jobartifacts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



		
IF OBJECT_ID('#tmp_tbl_artifacttext', 'U') IS NOT NULL
  DROP TABLE #tmp_tbl_artifacttext

  CREATE TABLE #tmp_tbl_artifacttext(
	[UUID] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NOT NULL,
	[parentid] [int] NULL,
	[localname] [nvarchar](255) NULL,
	[text] [nvarchar](max) NULL,
 CONSTRAINT [PK_tmp_tbl_jobtext] PRIMARY KEY CLUSTERED 
(
	[uuid] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	 INSERT INTO #tmp_tbl_artifacttext
           ([id]
		   ,[parentid]
           ,[localname]
    	   ,[text])   
	  SELECT 
	      [id]
		   ,[parentid]
           ,[localname]
    	   ,[text]
      FROM #tmp_tbl_artifacts
	  WHERE text is not null 
	SELECT * FROM #tmp_tbl_artifacttext



	
IF OBJECT_ID('#tmp_tbl_artifactUUID', 'U') IS NOT NULL
  DROP TABLE #tmp_tbl_artifactUUID

  CREATE TABLE #tmp_tbl_artifactUUID(
	[UUID] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NOT NULL,
	[parentid] [int] NULL,
	[localname] [nvarchar](255) NULL,
	[text] [nvarchar](max) NULL,
 CONSTRAINT [PK_tmp_tbl_artifactUUID] PRIMARY KEY CLUSTERED 
(
	[UUID] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	 INSERT INTO #tmp_tbl_artifactUUID
           ([id]
		   ,[parentid]
           ,[localname]
    	   ,[text])  
	  SELECT  DISTINCT #tmp_tbl_artifacts.id, #tmp_tbl_artifacts.parentid, #tmp_tbl_artifacts.localname, #tmp_tbl_artifacttext.[text]
  	 FROM   #tmp_tbl_artifacttext LEFT OUTER JOIN
                        #tmp_tbl_artifacts ON [#tmp_tbl_artifacts].id = #tmp_tbl_artifacttext.parentid
WHERE       ([#tmp_tbl_artifacts].localname) = N'url' OR
                         (CONVERT(nvarchar, [#tmp_tbl_artifacts].localname) = N'number')


SELECT * from #tmp_tbl_artifactUUID

			
IF OBJECT_ID('#tmp_tbl_artifactdata', 'U') IS NOT NULL
  DROP TABLE dbo.tbl_artifactdata

  CREATE TABLE #tmp_tbl_artifactdata(
	[UUID] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NOT NULL,
	[parentid] [int] NULL,
	[localname] [nvarchar](255) NULL,
	[text] [nvarchar](max) NULL,
 CONSTRAINT [PK_tmp_tbl_artifactdata] PRIMARY KEY CLUSTERED 
(
	[UUID] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	 INSERT INTO #tmp_tbl_artifactdata
           ([id]
		   ,[parentid]
           ,[localname]
    	   ,[text])  
	  SELECT  #tmp_tbl_artifacts.id, #tmp_tbl_artifacts.parentid, #tmp_tbl_artifacts.localname, #tmp_tbl_artifacttext.[text]
  	 FROM   #tmp_tbl_artifacttext LEFT OUTER JOIN
                        #tmp_tbl_artifacts ON [#tmp_tbl_artifacts].id = #tmp_tbl_artifacttext.parentid
WHERE        ([#tmp_tbl_artifacts].localname = N'fileName') OR
                         (CONVERT(varchar, [#tmp_tbl_artifacts].localname) = N'relativePath')                      

SELECT * FROM #tmp_tbl_artifactdata



SELECT        TOP (100) PERCENT text
FROM            #tmp_tbl_artifactdata
WHERE        (UUID % 2 = 0)

SELECT        TOP (100) PERCENT text
FROM            #tmp_tbl_artifactdata
WHERE        (UUID % 2 = 1)


INSERT INTO #tmp_tbl_jobartifacts
	([RelativePath]) 
SELECT        TOP (100) PERCENT text
FROM            #tmp_tbl_artifactdata
WHERE        (UUID % 2 = 0)

SELECT * FROM #tmp_tbl_jobartifacts

CREATE TABLE #ArtifactName
	([id] [int] IDENTITY(1,1) NOT NULL,
	[ArtifactName] [varchar](1000) NULL)

INSERT INTO #ArtifactName
	([ArtifactName]) 
SELECT        TOP (100) PERCENT text
FROM            #tmp_tbl_artifactdata
WHERE        (UUID % 2 = 1)

SELECT * FROM #ArtifactName

UPDATE #tmp_tbl_jobartifacts
   SET [ArtifactName] = (SELECT [ArtifactName] 
   FROM #ArtifactName
   WHERE #ArtifactName.id = #tmp_tbl_jobartifacts.ID)

SELECT * FROM #tmp_tbl_jobartifacts

UPDATE #tmp_tbl_jobartifacts
   SET [UUID] = ##UUID.UUID
   FROM ##UUID
WHERE #tmp_tbl_jobartifacts.UUID is NULL
    
UPDATE #tmp_tbl_jobartifacts
SET [ProjectName] = #ProjectName.ProjectName
FROM #ProjectName
WHERE #tmp_tbl_jobartifacts.ProjectName is NULL

UPDATE #tmp_tbl_jobartifacts
SET [Buildnbr] = #Buildnbr.Buildnbr 
FROM #Buildnbr
WHERE #tmp_tbl_jobartifacts.Buildnbr is null
    
UPDATE #tmp_tbl_jobartifacts
   SET [CreateDT] = GETDATE()
   FROM dbo.tbl_job
where #tmp_tbl_jobartifacts.CreateDT is NULL

SELECT * FROM #tmp_tbl_jobartifacts

SELECT DISTINCT * from #tmp_tbl_jobartifacts


INSERT INTO dbo.tbl_jobartifacts
	([UUID], 
	[ProjectName],
	[Buildnbr],
	[CreateDT],
	[ArtifactName],
	[RelativePath])
SELECT     UUID, ProjectName, Buildnbr, CreateDT, ArtifactName, RelativePath
FROM            #tmp_tbl_jobartifacts



/* CLEAN UP TIME */ 
/* CLEAN UP TIME */ 
/* CLEAN UP TIME */ 
/* CLEAN UP TIME */ 
/* CLEAN UP TIME */ 
/* CLEAN UP TIME */ 


DROP TABLE #tmp_tbl_artifacts
DROP TABLE #tmp_tbl_artifacttext
DROP TABLE #tmp_tbl_artifactdata
DROP TABLE #ArtifactName
DROP TABLE #tmp_tbl_jobartifacts
DROP TABLE #tmp_tbl_jobdata
DROP TABLE #tmp_tbl_job 
DROP TABLE #Buildnbr 
DROP TABLE #ProjectName 
DROP TABLE ##UUID
DROP TABLE #tmp_tbl_artifactUUID


/* 

 The E&D Game  
 The E&D Game  
 The E&D Game  
 The E&D Game  
 The E&D Game  
 
*/ 


END 
