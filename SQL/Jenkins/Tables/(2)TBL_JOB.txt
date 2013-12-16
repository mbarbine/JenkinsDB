USE [Jenkins]
GO

/****** Object:  Table [dbo].[tbl_job]    Script Date: 12/10/2013 5:11:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tbl_job](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UUID] [nvarchar](255) NULL,
	[CreateDT] [datetime] NULL,
	[ProjectName] [nvarchar](255) NULL,
	[Buildnbr] [int] NULL,
	[BuildURL] [nvarchar](100) NULL,
	[FullDisplayName] [nvarchar](255) NULL,
	[upstreamProject] [varchar](100) NULL,
	[upstreamBuild] [varchar](100) NULL,
	[upstreamURL] [varchar](100) NULL,
	[BuildDT] [nvarchar](100) NULL,
	[duration] [nvarchar](100) NULL,
	[EstDuration] [nvarchar](100) NULL,
	[Keeplog] [varchar](25) NULL,
	[Result] [varchar](30) NULL,
	[ResultDT] [nvarchar](100) NULL,
	[giturl] [nvarchar](255) NULL,
	[CommitID] [nvarchar](100) NULL,
	[CommitDT] [int] NULL,
	[UserName] [varchar](100) NULL,
	[UserURL] [nvarchar](100) NULL,
	[Comment] [nvarchar](255) NULL,
	[commentType] [varchar](50) NULL,
	[buildType] [varchar](100) NULL,
	[Component] [varchar](100) NULL,
	[ComponentVer] [nvarchar](50) NULL,
	[ParentBuildNumber] [nvarchar](50) NULL,
	[ProductName] [varchar](100) NULL,
	[BuildSource] [varchar](100) NULL,
	[TPVersion] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_job] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


