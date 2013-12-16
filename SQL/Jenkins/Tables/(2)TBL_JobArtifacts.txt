USE [Jenkins]
GO

/****** Object:  Table [dbo].[tbl_jobartifacts]    Script Date: 12/10/2013 5:12:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_jobartifacts](
	[ID] [int] IDENTITY(1,2) NOT NULL,
	[UUID] [nvarchar](255) NULL,
	[ProjectName] [nvarchar](255) NULL,
	[Buildnbr] [int] NULL,
	[CreateDT] [datetime] NULL,
	[ArtifactName] [nvarchar](255) NULL,
	[RelativePath] [nvarchar](255) NULL,
 CONSTRAINT [PK_tbl_jobartifacts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


