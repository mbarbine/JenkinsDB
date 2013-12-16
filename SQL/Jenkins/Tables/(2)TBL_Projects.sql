USE [Jenkins]
GO

/****** Object:  Table [dbo].[tbl_projects]    Script Date: 12/10/2013 5:13:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tbl_projects](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectUID] [int] NULL,
	[CreateDT] [datetime] NULL,
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

GO

SET ANSI_PADDING OFF
GO


