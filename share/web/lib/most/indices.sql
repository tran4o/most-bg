USE [SmartEDI]

GO

CREATE NONCLUSTERED INDEX [invoic_InvoiceDate] ON [dbo].[invoic]
(
	[InvoiceDate] DESC
)
INCLUDE ( 	[MsgType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, 
	DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

CREATE NONCLUSTERED INDEX [idx_ModifiedDate-desc] ON [dbo].[NancyProducts]
(
	[UpdatedDateTimeStamp] DESC
)
INCLUDE ( 	[product_base_no]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


CREATE TABLE [dbo].[selinv3](
	[InvoiceNo] [varchar](32) NULL,
	[ProductNo] [varchar](32) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


CREATE CLUSTERED INDEX [ClusteredIndex-20151102-210743] ON [dbo].[selinv3]
(
	[InvoiceNo] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_DiscountMode-opg] ON [dbo].[opg]
(
	[DiscountMode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_DealID-opg] ON [dbo].[opg]
(
	[DealID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ProductNo_extras] ON [dbo].[NancyProducts]
(
	[product_base_no] ASC
)
INCLUDE ( 	[UpdatedDateTimeStamp],
	[CompanyIdentifier],
	[long_desc],
	[short_desc],
	[product_line]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
