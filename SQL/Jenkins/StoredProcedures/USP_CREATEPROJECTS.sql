USE [Jenkins]
GO

/****** Object:  StoredProcedure [dbo].[USP_CREATEPROJECTS]    Script Date: 12/10/2013 5:20:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[USP_CREATEPROJECTS]   

AS     

/* Insert Last Build Information into Temp Table */ 
/* Insert Last Build Information into Temp Table */ 
/* Insert Last Build Information into Temp Table */ 
/* Insert Last Build Information into Temp Table */ 

IF OBJECT_ID('#PrevBuilds', 'U') IS NOT NULL
  DROP TABLE #PrevBuilds

CREATE TABLE #PrevBuilds 
	([id] [int] IDENTITY(1,1) NOT NULL,
	[PrevLastBuildNbr] [varchar](1000) NULL,
	[PrevLastBuildSts] [varchar](255) NULL,
	[PrevLastBuildDT] [varchar](255) NULL) 

	INSERT INTO #PrevBuilds
	([PrevLastBuildNbr], 
	[PrevLastBuildSts],
	[PrevLastBuildDT])
	SELECT  LastBuild, LastBuildSts, LastBuildDT 
	FROM            dbo.tbl_projects
	
	SeLECT * from #PrevBuilds



/* Create TEMP Project Table */ 
/* Create TEMP Project Table */ 
/* Create TEMP Project Table */ 
/* Create TEMP Project Table */ 

 IF OBJECT_ID('dbo.tmp_tbl_projects', 'U') IS NOT NULL
	DROP TABLE dbo.tmp_tbl_projects

CREATE TABLE [dbo].[tmp_tbl_projects](
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
 CONSTRAINT [PK_tmp_tbl_projects] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]



  BEGIN     

        SET NOCOUNT ON               
        DECLARE @HANDLE INT     
        DECLARE @SQUERY nVARCHAR(1000)
        DECLARE @XMLDOC XML 

        SET @XMLDOC = (SELECT *  FROM OPENROWSET 
                      (BULK 'E:\xml\builds\cc.xml', SINGLE_CLOB) AS XMLDATA) 
	  
        EXEC SP_XML_PREPAREDOCUMENT  @HANDLE OUTPUT,@XMLDOC   
		  
        SELECT * FROM OPENXML(@HANDLE, 'Projects', 50)   
		WHERE text is not null	

	 INSERT INTO [dbo].[tmp_tbl_projects]
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
      FROM OPENXML(@HANDLE, 'Projects', 50)  
	  WHERE text is not null

/* Create Project Data Table */ 
/* Create Project Data Table */ 
/* Create Project Data Table */ 
/* Create Project Data Table */ 

 IF OBJECT_ID('dbo.tbl_projects', 'U') IS NOT NULL
 DROP TABLE dbo.tbl_projects

 CREATE TABLE [dbo].[tbl_projects](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectUID] [int] NULL,
	[CreateDT] [Datetime] NULL, 
	[ProjectName] [varchar](255) NULL,
	[ProjectActivity] [varchar](255) NULL,
	[LastBuild] [int] NULL,
	[LastBuildSts] [varchar](50) NULL,
	[LastBuildDT] [varchar](50) NULL,
	[webUrl] [varchar](255) NULL,
	[PrevLastBuild] [int] NULL,
	[PrevLastBuildSts] [varchar](50) NULL,
	[PrevLastBuildDT] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_projects] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SELECT * FROM tbl_projects

SELECT * from tmp_tbl_projects


/* ProjectURL */ 
/* ProjectURL */ 
/* ProjectURL */ 
/* ProjectURL */ 
/* ProjectURL */ 

IF OBJECT_ID('#ProjectUrl', 'U') IS NOT NULL
  DROP TABLE #ProjectUrl

CREATE TABLE #ProjectURL
	([id] [int] IDENTITY(1,1) NOT NULL,
	[url] [varchar](1000) NULL)

	INSERT INTO #ProjectURL
	([url]) 
SELECT        TOP (100) PERCENT text
FROM            dbo.tmp_tbl_projects
WHERE        (UUID % 6 = 1)

INSERT INTO dbo.tbl_projects
	([webUrl]) 
SELECT        TOP (100) PERCENT url
FROM            #ProjectURL


/* ProjectName */ 
/* ProjectName */ 
/* ProjectName */ 
/* ProjectName */ 

IF OBJECT_ID('#ProjectName', 'U') IS NOT NULL
  DROP TABLE #ProjectName

CREATE TABLE #ProjectName
	([id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](1000) NULL)

	INSERT INTO #ProjectName
	([name]) 
SELECT        TOP (100) PERCENT text
FROM            dbo.tmp_tbl_projects
WHERE        (UUID % 6 = 2)


UPDATE [dbo].[tbl_projects]
   SET [ProjectName] = (SELECT name 
   FROM #ProjectName
   WHERE #ProjectName.id = dbo.tbl_projects.ID)
 WHERE EXISTS (SELECT #ProjectName.id 
 FROM #ProjectName 
 WHERE #ProjectName.id = dbo.tbl_projects.ID)

 SELECT * FROM #ProjectName

 DROP TABLE #ProjectName

/* Build NBR */ 
/* Build NBR */ 
/* Build NBR */ 
/* Build NBR */ 

IF OBJECT_ID('#BuildNBR', 'U') IS NOT NULL
  DROP TABLE #BuildNBR

CREATE TABLE #BuildNBR
	([id] [int] IDENTITY(1,1) NOT NULL,
	[BuildNBR] [varchar](1000) NULL)

	INSERT INTO #BuildNBR
	([BuildNBR]) 
SELECT        TOP (100) PERCENT text
FROM            dbo.tmp_tbl_projects
WHERE        (UUID % 6 = 3)


UPDATE [dbo].[tbl_projects]
   SET [LastBuild] = (SELECT BuildNBR
   FROM #BuildNBR
   WHERE #BuildNBR.id = dbo.tbl_projects.ID)
 WHERE EXISTS (SELECT #BuildNBR.id 
 FROM #BuildNBR
 WHERE #BuildNBR.id = dbo.tbl_projects.ID)

 SELECT * From #BuildNBR
 
 DROP TABLE #BuildNBR

 

UPDATE [dbo].[tbl_projects]
   SET PrevLastBuild = (SELECT PrevLastBuildNbr
   FROM #PrevBuilds
   WHERE #PrevBuilds.id = dbo.tbl_projects.ID)
 WHERE EXISTS (SELECT #PrevBuilds.id 
 FROM #PrevBuilds 
 WHERE #PrevBuilds.id = dbo.tbl_projects.ID)

 UPDATE [dbo].[tbl_projects]
   SET PrevLastBuildDT = (SELECT PrevLastBuildDT
   FROM #PrevBuilds
   WHERE #PrevBuilds.id = dbo.tbl_projects.ID)
 WHERE EXISTS (SELECT #PrevBuilds.id 
 FROM #PrevBuilds 
 WHERE #PrevBuilds.id = dbo.tbl_projects.ID)

 UPDATE [dbo].[tbl_projects]
   SET PrevLastBuildSts = (SELECT PrevLastBuildSts
   FROM #PrevBuilds
   WHERE #PrevBuilds.id = dbo.tbl_projects.ID)
 WHERE EXISTS (SELECT #PrevBuilds.id 
 FROM #PrevBuilds 
 WHERE #PrevBuilds.id = dbo.tbl_projects.ID)

  UPDATE [dbo].[tbl_projects]
 SET CreateDT = GETDATE()	
 FROM dbo.tbl_projects
 WHERE CreateDT is NULL	


Select * from #PrevBuilds

DROP Table #PrevBuilds


Select * from #ProjectURL


 /* Current Activity */ 
 /* Current Activity */ 
 /* Current Activity */ 
 /* Current Activity */ 

IF OBJECT_ID('#CurrentActivity', 'U') IS NOT NULL
  DROP TABLE #CurrentActivity

CREATE TABLE #CurrentActivity
	([id] [int] IDENTITY(1,1) NOT NULL,
	[CurrentActivity] [varchar](1000) NULL)

	INSERT INTO #CurrentActivity
	([CurrentActivity]) 
SELECT        TOP (100) PERCENT text
FROM            dbo.tmp_tbl_projects
WHERE        (UUID % 6 = 0)


UPDATE [dbo].[tbl_projects]
   SET [ProjectActivity] = (SELECT CurrentActivity
   FROM #CurrentActivity
   WHERE #CurrentActivity.id = dbo.tbl_projects.ID)
 WHERE EXISTS (SELECT #CurrentActivity.id 
 FROM #CurrentActivity
 WHERE #CurrentActivity.id = dbo.tbl_projects.ID)

 Select * from #CurrentActivity

 DROP TABLE #CurrentActivity

 /* LastBuildDT */ 
 /* LastBuildDT */ 
 /* LastBuildDT */ 
 /* LastBuildDT */ 

 IF OBJECT_ID('#LastBuildDT', 'U') IS NOT NULL
  DROP TABLE #LastBuildDT

CREATE TABLE #LastBuildDT
	([id] [int] IDENTITY(1,1) NOT NULL,
	[LastBuildDT] [varchar](1000) NULL)

	INSERT INTO #LastBuildDT
	([LastBuildDT]) 
SELECT        TOP (100) PERCENT text
FROM            dbo.tmp_tbl_projects
WHERE        (UUID % 6 = 4)


UPDATE [dbo].[tbl_projects]
   SET [LastBuildDT] = (SELECT LastBuildDT
   FROM #LastBuildDT
   WHERE #LastBuildDT.id = dbo.tbl_projects.ID)
 WHERE EXISTS (SELECT #LastBuildDT.id 
 FROM #LastBuildDT
 WHERE #LastBuildDT.id = dbo.tbl_projects.ID)

 select * from #LastBuildDT

 DROP TABLE #LastBuildDT

 /* Last Build Status */ 
 /* Last Build Status */ 
 /* Last Build Status */ 
 /* Last Build Status */ 

 
 IF OBJECT_ID('#LastBuildSts', 'U') IS NOT NULL
  DROP TABLE #LastBuildSts

CREATE TABLE #LastBuildSts
	([id] [int] IDENTITY(1,1) NOT NULL,
	[LastBuildSts] [varchar](50) NULL)

	INSERT INTO #LastBuildSts
	([LastBuildSts]) 
SELECT        TOP (100) PERCENT text
FROM            dbo.tmp_tbl_projects
WHERE        (UUID % 6 = 5)

Select * from #LastBuildSts

UPDATE [dbo].[tbl_projects]
   SET [LastBuildSts] = (SELECT LastBuildSts
   FROM #LastBuildSts
   WHERE #LastBuildSts.id = dbo.tbl_projects.ID)
 WHERE EXISTS (SELECT #LastBuildSts.id 
 FROM #LastBuildSts
 WHERE #LastBuildSts.id = dbo.tbl_projects.ID)

 DROP TABLE #LastBuildSts

 DROP TABLE dbo.tmp_tbl_projects
 SELECT * from #ProjectURL
 SELECT * FROM tbl_projects


 END

GO


