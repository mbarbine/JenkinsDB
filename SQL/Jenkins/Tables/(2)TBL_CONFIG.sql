USE [Jenkins]
GO

/****** Object:  Table [dbo].[tbl_config]    Script Date: 12/10/2013 5:10:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_config](
	[UUID] [int] IDENTITY(2,1) NOT NULL,
	[id] [int] NOT NULL,
	[parentid] [int] NULL,
	[nodetype] [int] NULL,
	[textid] [int] NULL,
	[prevnode] [nchar](10) NULL,
 CONSTRAINT [PK_tbl_config] PRIMARY KEY CLUSTERED 
(
	[UUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


