USE [Jenkins]
GO

/****** Object:  Table [dbo].[tbl_systemstatus]    Script Date: 12/10/2013 5:13:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tbl_systemstatus](
	[UUID] [nchar](10) NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[JobID] [int] NULL,
	[Service] [varchar](50) NULL,
	[Status] [int] NULL,
	[Date] [date] NULL,
	[time] [time](7) NULL,
	[Version] [int] NULL,
 CONSTRAINT [PK_tbl_systemstatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


