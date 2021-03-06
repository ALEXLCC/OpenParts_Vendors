USE [Temco_PV]
GO
/****** Object:  StoredProcedure [dbo].[IsExistExpressBillCode]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[IsExistExpressBillCode] 
	-- Add the parameters for the stored procedure here
	@ExpressBillCode varchar(20),
   @BillTypeCode varchar(2)
AS
SELECT Count(*) From BillText
WHERE ExpressBillCode  = @ExpressBillCode and BillTypeCode = @BillTypeCode

GO
/****** Object:  StoredProcedure [dbo].[QueryExpressBill]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[QueryExpressBill] @BillTypeCode  varchar(2) AS
declare  @ControlId int
declare @strSql nvarchar(4000)
SET @strSql = N'SELECT '
DECLARE cur CURSOR for
    SELECT ControlId FROM BillTemplate Where BillTypeCode = @BillTypeCode
OPEN cur 
WHILE @@ERROR = 0
    BEGIN
       FETCH NEXT FROM cur 
       INTO @ControlId
       if @@FETCH_STATUS = 0
          if @strSql = 'SELECT '
             set @strSql = @strSql+ 'MAX(CASE ControlId WHEN  '+cast(@ControlId as varchar(10))+' THEN ControlText ELSE NULL END) as "'+cast(@ControlId as varchar(10))+'"'
          else
             set @strSql = @strSql+ ',MAX(CASE ControlId WHEN  '+cast(@ControlId as varchar(10))+' THEN ControlText ELSE NULL END) as "'+cast(@ControlId as varchar(10))+'"'
       else
          break
    END
set @strSql = @strSql+ ' FROM BillText Where BillTypeCode ='+@BillTypeCode+' GROUP BY ExpressBillCode'
EXEC sp_executesql   @strSql 
CLOSE cur
DEALLOCATE cur
GO
/****** Object:  StoredProcedure [dbo].[QueryForeignConstraint]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[QueryForeignConstraint]
@PrimaryTable varchar(50)
 AS
SELECT (SELECT Name
          FROM syscolumns
          WHERE colid = b.rkey AND id = b.rkeyid) AS primaryColumn, 
      OBJECT_NAME(b.fkeyid) AS foreignTable,
          (SELECT name
         FROM syscolumns
         WHERE colid = b.fkey AND id = b.fkeyid) AS foreignColumn
FROM sysobjects a INNER JOIN
      sysforeignkeys b ON a.id = b.constid INNER JOIN
      sysobjects c ON a.parent_obj = c.id
WHERE (a.xtype = 'f') AND (c.xtype = 'U') AND (OBJECT_NAME(b.rkeyid) = @PrimaryTable)
GO
/****** Object:  Table [dbo].[ACD]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACD](
	[ACDID] [int] IDENTITY(1,1) NOT NULL,
	[ACDIsAC] [bit] NOT NULL,
	[ACDText] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AL]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AL](
	[ALID] [int] IDENTITY(1,1) NOT NULL,
	[ALPNID] [int] NULL,
	[ALJOBID] [int] NULL,
	[ALTASKID] [int] NULL,
	[ALJOBNumber] [nvarchar](50) NULL,
	[ALJOBNumberLine] [nvarchar](50) NULL,
	[ALQty] [real] NULL,
	[ALQtyShort] [real] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BillTemplate]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BillTemplate](
	[ControlId] [int] IDENTITY(1,1) NOT NULL,
	[BillTypeCode] [varchar](2) NOT NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[Width] [int] NULL,
	[Height] [int] NULL,
	[IsFlag] [char](1) NULL,
	[ControlName] [varchar](20) NULL,
	[DefaultValue] [varchar](100) NULL,
	[TurnControlName] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BillText]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BillText](
	[NoteId] [int] IDENTITY(1,1) NOT NULL,
	[BillTypeCode] [varchar](2) NOT NULL,
	[ExpressBillCode] [varchar](20) NULL,
	[ControlId] [int] NOT NULL,
	[ControlText] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BillType]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BillType](
	[BillTypeCode] [varchar](2) NOT NULL,
	[BillTypeName] [varchar](20) NULL,
	[BillWidth] [int] NULL,
	[BillHeight] [int] NULL,
	[BillPicture] [image] NULL,
	[BillCodeLength] [int] NULL,
	[Remark] [text] NULL,
	[IsEnabled] [char](1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CNV]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CNV](
	[CNVSUPID] [int] IDENTITY(1,1) NOT NULL,
	[CNVLNKID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[COST]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COST](
	[COSTID] [int] NOT NULL,
	[COSTLNKID] [int] NOT NULL,
	[COSTAtQty] [real] NULL,
	[COSTLeadtime] [smallint] NULL,
	[COSTCost] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CU]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CU](
	[CUID] [int] IDENTITY(1,1) NOT NULL,
	[CUCustomer] [nvarchar](255) NULL,
	[CUAddress] [nvarchar](255) NULL,
	[CUShipAddress] [nvarchar](255) NULL,
	[CUPhone1] [nvarchar](20) NULL,
	[CUPhone2] [nvarchar](20) NULL,
	[CUContact1] [nvarchar](50) NULL,
	[CUContact2] [nvarchar](50) NULL,
	[CUFax] [nvarchar](20) NULL,
	[CUEmail1] [nvarchar](50) NULL,
	[CUEmail2] [nvarchar](50) NULL,
	[CUNotes] [nvarchar](max) NULL,
	[CUWeb] [nvarchar](100) NULL,
	[CUCode] [nvarchar](20) NULL,
	[CUAccount] [nvarchar](20) NULL,
	[CUTerms] [nvarchar](20) NULL,
	[CUFedTaxID] [nvarchar](20) NULL,
	[CUStateTaxID] [nvarchar](20) NULL,
	[CUNoPhonePrefix] [bit] NOT NULL,
	[CUSearchData] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CUR]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUR](
	[CURID] [int] IDENTITY(1,1) NOT NULL,
	[CURCurrencyName] [nvarchar](50) NULL,
	[CURExchangeRate] [float] NULL,
	[CURCurrencyChar] [nvarchar](4) NULL,
	[CURFormat] [nvarchar](35) NULL,
	[CURFormatExt] [nvarchar](35) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ECO]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ECO](
	[ECOID] [int] IDENTITY(1,1) NOT NULL,
	[ECONumber] [int] NULL,
	[ECOSubject] [nvarchar](255) NULL,
	[ECOAffects] [nvarchar](255) NULL,
	[ECOItemCount] [smallint] NULL,
	[ECODateCreated] [datetime] NULL,
	[ECODateSubmitted] [datetime] NULL,
	[ECODateIssued] [datetime] NULL,
	[ECODateApproved] [datetime] NULL,
	[ECODateToDrafting] [datetime] NULL,
	[ECODateChgsComplete] [datetime] NULL,
	[ECODateChecked] [datetime] NULL,
	[ECODateReleased] [datetime] NULL,
	[ECOCreatedBy] [nvarchar](20) NULL,
	[ECOSubmittedBy] [nvarchar](20) NULL,
	[ECOIssuedBy] [nvarchar](20) NULL,
	[ECOApprovedBy] [nvarchar](20) NULL,
	[ECOChgsCompletedBy] [nvarchar](20) NULL,
	[ECOCheckedBy] [nvarchar](20) NULL,
	[ECOReleasedBy] [nvarchar](20) NULL,
	[ECOSignoff] [bit] NOT NULL,
	[ECODept2] [datetime] NULL,
	[ECOUser2] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FIL]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FIL](
	[FILID] [int] IDENTITY(1,1) NOT NULL,
	[FILPNID] [int] NULL,
	[FILPNPartNumber] [nvarchar](50) NULL,
	[FILFilePath] [nvarchar](255) NULL,
	[FILFileName] [nvarchar](255) NULL,
	[FILView] [bit] NOT NULL,
	[FILNotes] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HIST]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HIST](
	[HISTID] [int] IDENTITY(1,1) NOT NULL,
	[HISTWho] [nvarchar](20) NULL,
	[HISTWhat] [nvarchar](255) NULL,
	[HISTWhen] [datetime] NOT NULL,
	[HISTWhy] [nvarchar](255) NULL,
	[HISTHowMany] [real] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HPREF]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HPREF](
	[GPREFID] [int] IDENTITY(1,1) NOT NULL,
	[GPREFKey] [nvarchar](50) NOT NULL,
	[GPREFText1] [nvarchar](50) NULL,
	[GPREFText2] [nvarchar](50) NULL,
	[GPREFText3] [nvarchar](50) NULL,
	[GPREFText4] [nvarchar](50) NULL,
	[GPREFText5] [nvarchar](50) NULL,
	[GPREFBool1] [bit] NOT NULL,
	[GPREFBool2] [bit] NOT NULL,
	[GPREFBool3] [bit] NOT NULL,
	[GPREFBool4] [bit] NOT NULL,
	[GPREFInt1] [smallint] NULL,
	[GPREFText6] [nvarchar](50) NULL,
	[GPREFText7] [nvarchar](50) NULL,
	[GPREFText8] [nvarchar](50) NULL,
	[GPREFText9] [nvarchar](50) NULL,
	[GPREFText10] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JOB]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOB](
	[JOBID] [int] IDENTITY(1,1) NOT NULL,
	[JOBNumber] [nvarchar](50) NULL,
	[JOBCUID] [int] NULL,
	[JOBCustomer] [nvarchar](255) NULL,
	[JOBDateCreated] [datetime] NULL,
	[JOBDatePromised] [datetime] NULL,
	[JOBDateCompleted] [datetime] NULL,
	[JOBAccount] [nvarchar](50) NULL,
	[JOBNotes] [nvarchar](max) NULL,
	[JOBAllocateStock] [bit] NULL,
	[JOBFOB] [nvarchar](50) NULL,
	[JOBTerms] [nvarchar](50) NULL,
	[JOBShipMethod] [nvarchar](50) NULL,
	[JOBAttnTo] [nvarchar](50) NULL,
	[JOBTaxRate] [real] NULL,
	[JOBTaxRate2] [real] NULL,
	[JOBTax2OnTax1] [bit] NULL,
	[JOBTotalCost] [float] NULL,
	[JOBSubTotalCost] [float] NULL,
	[JOBTotalPrice] [float] NULL,
	[JOBSubTotalPrice] [float] NULL,
	[JOBTax1] [float] NULL,
	[JOBTax2] [float] NULL,
	[JOBCustOrderNumber] [nvarchar](50) NULL,
	[JOBDateInvoiced] [datetime] NULL,
	[JOBDateShipped] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LIN]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LIN](
	[LINID] [int] IDENTITY(1,1) NOT NULL,
	[LINSUID] [int] NOT NULL,
	[LINMFRID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LNK]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LNK](
	[LNKID] [int] IDENTITY(1,1) NOT NULL,
	[LNKSUID] [int] NULL,
	[LNKMFRPNID] [int] NULL,
	[LNKMFRID] [int] NULL,
	[LNKUNID] [int] NULL,
	[LNKPNID] [int] NULL,
	[LNKToPNID] [int] NULL,
	[LNKUse] [bit] NOT NULL,
	[LNKLeadtime] [nvarchar](20) NULL,
	[LNKChoice] [smallint] NULL,
	[LNKVendorPN] [nvarchar](50) NULL,
	[LNKVendorDesc] [nvarchar](50) NULL,
	[LNKAtQty] [real] NULL,
	[LNKRFQDate] [datetime] NULL,
	[LNKMinIncrement] [real] NULL,
	[LNKCurrentCost] [float] NULL,
	[LNKSetupCost] [float] NULL,
	[LNKRoHS] [bit] NOT NULL,
	[LNKRoHSDoc] [nvarchar](50) NULL,
	[LNKRoHSNote] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MF]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MF](
	[MFID] [int] IDENTITY(1,1) NOT NULL,
	[MFPNIDParent] [int] NULL,
	[MFPNIDSub] [int] NULL,
	[MFQty] [real] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MFE]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MFE](
	[MFEID] [int] IDENTITY(1,1) NOT NULL,
	[MFEECOID] [int] NULL,
	[MFERHID] [int] NULL,
	[MFEEdited] [bit] NOT NULL,
	[MFID] [int] NULL,
	[MFPNIDParent] [int] NULL,
	[MFPNIDSub] [int] NULL,
	[MFQty] [real] NULL,
	[MFESubPartNumber] [nvarchar](50) NULL,
	[MFETitle] [nvarchar](255) NULL,
	[MFEDetail] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MFR]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MFR](
	[MFRID] [int] IDENTITY(1,1) NOT NULL,
	[MFRMfrName] [nvarchar](50) NOT NULL,
	[MFRAddress] [nvarchar](255) NULL,
	[MFRCountry] [nvarchar](50) NULL,
	[MFRContact1] [nvarchar](50) NULL,
	[MFRContact2] [nvarchar](50) NULL,
	[MFRPhone1] [nvarchar](20) NULL,
	[MFRPhone2] [nvarchar](20) NULL,
	[MFRFax] [nvarchar](20) NULL,
	[MFRWeb] [nvarchar](255) NULL,
	[MFRNotes] [nvarchar](max) NULL,
	[MFRCode] [nvarchar](20) NULL,
	[MFREMail1] [nvarchar](50) NULL,
	[MFREMail2] [nvarchar](50) NULL,
	[MFRNoPhonePrefix] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MFRPN]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MFRPN](
	[MFRPNID] [int] IDENTITY(1,1) NOT NULL,
	[MFRPNMFRID] [int] NULL,
	[MFRPNPart] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Operator]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Operator](
	[OperatorCode] [varchar](20) NOT NULL,
	[OperatorName] [varchar](8) NULL,
	[Password] [varchar](20) NULL,
	[IsFlag] [char](1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ORG]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORG](
	[ORGID] [int] IDENTITY(1,1) NOT NULL,
	[ORGKey] [nvarchar](20) NULL,
	[ORGName] [nvarchar](50) NULL,
	[ORGAddress] [nvarchar](255) NULL,
	[ORGPhone] [nvarchar](20) NULL,
	[ORGFaax] [nvarchar](20) NULL,
	[ORGPOUseShpgAddr] [bit] NOT NULL,
	[ORGRFQUseShpgAddr] [bit] NOT NULL,
	[ORGListOrder] [smallint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PL]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PL](
	[PLID] [int] IDENTITY(1,1) NOT NULL,
	[PLListID] [int] NOT NULL,
	[PLPartID] [int] NOT NULL,
	[PLItem] [smallint] NULL,
	[PLQty] [nvarchar](10) NULL,
	[PLRefMemo] [nvarchar](max) NULL,
	[PLRefText] [nvarchar](255) NULL,
	[PLAssyOrder] [real] NULL,
	[PLAssySpec] [nvarchar](255) NULL,
	[PLMFRPNID] [int] NULL,
	[PLMFRID] [int] NULL,
	[PLSUID] [int] NULL,
	[PLLNKID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PLE]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PLE](
	[PLEID] [int] IDENTITY(1,1) NOT NULL,
	[PLID] [int] NULL,
	[PLEECOID] [int] NULL,
	[PLERHID] [int] NULL,
	[PLEEdited] [bit] NOT NULL,
	[PLListID] [int] NULL,
	[PLEListNumber] [nvarchar](50) NULL,
	[PLPartID] [int] NULL,
	[PLEPartNumber] [nvarchar](50) NULL,
	[PLEType] [nvarchar](3) NULL,
	[PLETitle] [nvarchar](255) NULL,
	[PLEDetail] [nvarchar](255) NULL,
	[PLItem] [smallint] NULL,
	[PLQty] [nvarchar](10) NULL,
	[PLRefMemo] [nvarchar](max) NULL,
	[PLRefText] [nvarchar](255) NULL,
	[PLAssyOrder] [real] NULL,
	[PLAssySpec] [nvarchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PLL]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PLL](
	[PLLID] [int] IDENTITY(1,1) NOT NULL,
	[PLLParentListID] [int] NULL,
	[PLLSubListID] [int] NULL,
	[PLLQty] [real] NULL,
	[PLLLevel] [int] NULL,
	[PLLCost] [real] NULL,
	[PLLItemNumber] [smallint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PN]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PN](
	[PNID] [int] IDENTITY(1,1) NOT NULL,
	[PNIDToLNK] [int] NULL,
	[PNUNID] [int] NULL,
	[PNTabParentID] [int] NULL,
	[PNPrefix] [nvarchar](50) NULL,
	[PNPartNumber] [nvarchar](50) NOT NULL,
	[PNSuffix] [nvarchar](50) NULL,
	[PNType] [nvarchar](5) NULL,
	[PNRevision] [nvarchar](10) NULL,
	[PNTitle] [nvarchar](255) NULL,
	[PNDetail] [nvarchar](255) NULL,
	[PNStatus] [nvarchar](1) NULL,
	[PNReqBy] [nvarchar](10) NULL,
	[PNNotes] [nvarchar](max) NULL,
	[PNUser1] [nvarchar](100) NULL,
	[PNUser2] [nvarchar](100) NULL,
	[PNUser3] [nvarchar](100) NULL,
	[PNUser4] [nvarchar](100) NULL,
	[PNUser5] [nvarchar](100) NULL,
	[PNUser6] [nvarchar](100) NULL,
	[PNUser7] [nvarchar](100) NULL,
	[PNUser8] [nvarchar](100) NULL,
	[PNUser9] [nvarchar](100) NULL,
	[PNUser10] [nvarchar](100) NULL,
	[PNDate] [datetime] NULL,
	[PNTab] [bit] NOT NULL,
	[PNControlled] [bit] NOT NULL,
	[PNAux1] [nvarchar](50) NULL,
	[PNQty] [real] NULL,
	[PNQty2] [real] NULL,
	[PNCostChanged] [bit] NOT NULL,
	[PNParentCost] [bit] NOT NULL,
	[PNExpandList] [bit] NOT NULL,
	[PNAssyCostOption] [smallint] NULL,
	[PNInclAssyOnPurchList] [bit] NOT NULL,
	[PNMadeFrom] [bit] NOT NULL,
	[PNMinStockQty] [real] NULL,
	[PNOrderToMaintain] [bit] NOT NULL,
	[PNOnECO] [bit] NOT NULL,
	[PNOverKit] [bit] NOT NULL,
	[PNOverKitQty] [real] NULL,
	[PNOverKitBy] [smallint] NULL,
	[PNOverKitFor] [smallint] NULL,
	[PNCurrentCost] [float] NULL,
	[PNLastRollupCost] [float] NULL,
	[PNUSRID] [int] NULL,
	[PNUserLock] [bit] NOT NULL,
	[PNPictureName] [nvarchar](255) NULL,
	[SearchData] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PNE]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PNE](
	[PNID] [int] IDENTITY(1,1) NOT NULL,
	[PNECOID] [int] NULL,
	[PNERHID] [int] NULL,
	[PNEdited] [bit] NOT NULL,
	[PNUNID] [int] NULL,
	[PNTabParentID] [int] NULL,
	[PNPrefix] [nvarchar](50) NULL,
	[PNPartNumber] [nvarchar](50) NULL,
	[PNSuffix] [nvarchar](50) NULL,
	[PNType] [nvarchar](5) NULL,
	[PNRevision] [nvarchar](10) NULL,
	[PNTitle] [nvarchar](255) NULL,
	[PNDetail] [nvarchar](255) NULL,
	[PNStatus] [nvarchar](1) NULL,
	[PNReqBy] [nvarchar](10) NULL,
	[PNNotes] [nvarchar](max) NULL,
	[PNUser1] [nvarchar](100) NULL,
	[PNUser2] [nvarchar](100) NULL,
	[PNUser3] [nvarchar](100) NULL,
	[PNUser4] [nvarchar](100) NULL,
	[PNUser5] [nvarchar](100) NULL,
	[PNUser6] [nvarchar](100) NULL,
	[PNDate] [datetime] NULL,
	[PNTab] [bit] NOT NULL,
	[PNControlled] [bit] NOT NULL,
	[PNMadeFrom] [bit] NOT NULL,
	[PNOnECO] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PO]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PO](
	[POID] [int] IDENTITY(1,1) NOT NULL,
	[POPOMID] [int] NULL,
	[POLNKID] [int] NULL,
	[POItem] [smallint] NULL,
	[POPart] [nvarchar](50) NULL,
	[PORev] [nvarchar](10) NULL,
	[PODescription] [nvarchar](max) NULL,
	[POReceived] [bit] NOT NULL,
	[POPurchUnits] [nvarchar](20) NULL,
	[POUseUnits] [nvarchar](20) NULL,
	[POConvUnits] [real] NULL,
	[PORFQQty] [nvarchar](255) NULL,
	[POAcct] [nvarchar](20) NULL,
	[POIHPart] [nvarchar](50) NULL,
	[POSchedule] [nvarchar](255) NULL,
	[POTaxable] [bit] NOT NULL,
	[POTaxable2] [bit] NOT NULL,
	[POExtension] [float] NULL,
	[POExtPlusTax] [float] NULL,
	[POCost] [float] NULL,
	[POQty] [float] NULL,
	[POItemQtyEntry] [float] NULL,
	[POItemQtyReceived] [float] NULL,
	[POItemQtyBackordered] [float] NULL,
	[POTax1] [float] NULL,
	[POTax2] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[POD]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POD](
	[PODID] [int] IDENTITY(1,1) NOT NULL,
	[PODField] [nvarchar](50) NULL,
	[PODCaption] [nvarchar](50) NULL,
	[PODOrder] [smallint] NULL,
	[PODUse] [bit] NOT NULL,
	[PODNewLine] [bit] NOT NULL,
	[PODUseCaption] [bit] NOT NULL,
	[PODMode] [smallint] NULL,
	[PODOrderJOB] [smallint] NULL,
	[PODUseJOB] [bit] NOT NULL,
	[PODNewLineJOB] [bit] NOT NULL,
	[PODUseCaptionJOB] [bit] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[POM]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POM](
	[POMID] [int] IDENTITY(1,1) NOT NULL,
	[POMNumber] [nvarchar](20) NOT NULL,
	[POMDatePrinted] [datetime] NULL,
	[POMSupplier] [nvarchar](50) NOT NULL,
	[POMSUID] [int] NULL,
	[POMAccount] [nvarchar](20) NULL,
	[POMNotes] [nvarchar](max) NULL,
	[POMAttnTo] [nvarchar](50) NULL,
	[POMFromBuyer] [nvarchar](50) NULL,
	[POMEngrgContact] [nvarchar](50) NULL,
	[POMDateReq] [nvarchar](20) NULL,
	[POMDateClosed] [datetime] NULL,
	[POMFOB] [nvarchar](20) NULL,
	[POMTerms] [nvarchar](20) NULL,
	[POMInsurance] [bit] NOT NULL,
	[POMUseOurShpngAcct] [bit] NOT NULL,
	[POMShippingAcct] [nvarchar](25) NULL,
	[POMThisIsRFQ] [bit] NOT NULL,
	[POMPendingPrint] [bit] NOT NULL,
	[POMTaxRate] [real] NULL,
	[POMShipMethod] [nvarchar](20) NULL,
	[POMShipTo] [nvarchar](max) NULL,
	[POMTaxRate2] [real] NULL,
	[POMTaxTotal2] [real] NULL,
	[POMTax2OnTax1] [smallint] NULL,
	[POMTotalCost] [float] NULL,
	[POMTotalTax] [float] NULL,
	[POMSubTotal] [float] NULL,
	[POMCURID] [int] NULL,
	[POMCurName] [nvarchar](20) NULL,
	[POMCurExRate] [float] NULL,
	[POMDateReqDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RH]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RH](
	[RHID] [int] IDENTITY(1,1) NOT NULL,
	[RHECOID] [int] NULL,
	[RHPNID] [int] NULL,
	[RHPartNumber] [nvarchar](50) NULL,
	[RHType] [nvarchar](3) NULL,
	[RHMadeFrom] [bit] NOT NULL,
	[RHTitle] [nvarchar](255) NULL,
	[RHDetail] [nvarchar](255) NULL,
	[RHItem] [smallint] NULL,
	[RHInstructions] [nvarchar](max) NULL,
	[RHDispOnOrder] [nvarchar](50) NULL,
	[RHDispInStock] [nvarchar](50) NULL,
	[RHDispInKits] [nvarchar](50) NULL,
	[RHDispInAssys] [nvarchar](50) NULL,
	[RHDispInInv] [nvarchar](50) NULL,
	[RHDispInField] [nvarchar](50) NULL,
	[RHFromRev] [nvarchar](10) NULL,
	[RHToRev] [nvarchar](10) NULL,
	[RHFromStat] [nvarchar](1) NULL,
	[RHToStat] [nvarchar](1) NULL,
	[RHAction] [nvarchar](20) NULL,
	[RHEdit] [nvarchar](50) NULL,
	[RHComment] [nvarchar](max) NULL,
	[RHEdited] [bit] NOT NULL,
	[RHEdit2] [nvarchar](50) NULL,
	[RHEditList] [bit] NOT NULL,
	[RHIndicator] [nvarchar](3) NULL,
	[RHAssy] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RPX]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RPX](
	[RPXID] [int] IDENTITY(1,1) NOT NULL,
	[RPXGrid] [nvarchar](50) NOT NULL,
	[RPXName] [nvarchar](50) NULL,
	[RPXLayout] [nvarchar](max) NULL,
	[RPXLabel] [bit] NOT NULL,
	[RPXPrimary] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SHIP]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SHIP](
	[SHIPID] [int] IDENTITY(1,1) NOT NULL,
	[SHIPMethod] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SU]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SU](
	[SUID] [int] IDENTITY(1,1) NOT NULL,
	[SUSupplier] [nvarchar](50) NOT NULL,
	[SUAddress] [nvarchar](255) NULL,
	[SUCountry] [nvarchar](50) NULL,
	[SUPhone1] [nvarchar](20) NULL,
	[SUPhone2] [nvarchar](20) NULL,
	[SUFAX] [nvarchar](20) NULL,
	[SUWeb] [nvarchar](255) NULL,
	[SUContact1] [nvarchar](50) NULL,
	[SUContact2] [nvarchar](50) NULL,
	[SUDateLast] [datetime] NULL,
	[SUFollowup] [bit] NOT NULL,
	[SUNotes] [nvarchar](max) NULL,
	[SUCode] [nvarchar](20) NULL,
	[SUAccount] [nvarchar](20) NULL,
	[SUTerms] [nvarchar](20) NULL,
	[SUFedTaxID] [nvarchar](20) NULL,
	[SUStateTaxID] [nvarchar](20) NULL,
	[SUEMail1] [nvarchar](50) NULL,
	[SUEMail2] [nvarchar](50) NULL,
	[SUCurDedExRate] [bit] NOT NULL,
	[SUCurExRate] [float] NULL,
	[SUCURID] [int] NULL,
	[SUCurReverse] [bit] NOT NULL,
	[SUNoPhonePrefix] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TASK]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TASK](
	[TASKID] [int] IDENTITY(1,1) NOT NULL,
	[TASKJOBID] [int] NULL,
	[TASKPNID] [int] NULL,
	[TASKIHPartNumber] [nvarchar](255) NULL,
	[TASKPartNumber] [nvarchar](255) NULL,
	[TASKRevision] [nvarchar](10) NULL,
	[TASKDescription] [nvarchar](max) NULL,
	[TASKItem] [smallint] NULL,
	[TASKQty] [real] NULL,
	[TASKCost] [float] NULL,
	[TASKCostExt] [float] NULL,
	[TASKPrice] [float] NULL,
	[TASKPriceExt] [float] NULL,
	[TASKNotes] [nvarchar](max) NULL,
	[TASKShowOnQuote] [bit] NOT NULL,
	[TASKShowOnInvoice] [bit] NOT NULL,
	[TASKShowOnPackingList] [bit] NOT NULL,
	[TASKTaxable] [bit] NOT NULL,
	[TASKPriceExtPlusTax] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TYPE]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TYPE](
	[TYPEID] [int] NOT NULL,
	[TYPEType] [nvarchar](6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UN]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UN](
	[UNID] [int] IDENTITY(1,1) NOT NULL,
	[UNUseUnits] [nvarchar](20) NOT NULL,
	[UNPurchUnits] [nvarchar](20) NOT NULL,
	[UNConvUnits] [real] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[qryLinkedMFRInfo]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryLinkedMFRInfo]
AS
SELECT   MFRID, MFRMfrName, MFRAddress, MFRCountry, MFRContact1, MFRContact2, MFRPhone1, MFRPhone2, MFRFax, 
                MFRWeb, MFRNotes, MFRCode, MFREMail1, MFREMail2, MFRNoPhonePrefix
FROM      dbo.MFR

GO
/****** Object:  View [dbo].[qryLinkedMFRPNInfo]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryLinkedMFRPNInfo]
AS
SELECT   MFRPNID, MFRPNMFRID, MFRPNPart
FROM      dbo.MFRPN

GO
/****** Object:  View [dbo].[qryLinkedSUInfo]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryLinkedSUInfo]
AS
SELECT   SUID, SUSupplier, SUAddress, SUCountry, SUPhone1, SUPhone2, SUFAX, SUWeb, SUContact1, SUContact2, 
                SUDateLast, SUFollowup, SUNotes, SUCode, SUAccount, SUTerms, SUFedTaxID, SUStateTaxID, SUEMail1, SUEMail2, 
                SUCurDedExRate, SUCurExRate, SUCURID, SUCurReverse, SUNoPhonePrefix
FROM      dbo.SU

GO
/****** Object:  View [dbo].[qryLNKForPL]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryLNKForPL]
AS
SELECT   dbo.LNK.LNKID, dbo.LNK.LNKSUID, dbo.LNK.LNKMFRPNID, dbo.LNK.LNKMFRID, dbo.LNK.LNKUNID, dbo.LNK.LNKPNID, 
                dbo.LNK.LNKToPNID, dbo.LNK.LNKUse, dbo.LNK.LNKLeadtime, dbo.LNK.LNKChoice, dbo.LNK.LNKVendorPN, 
                dbo.LNK.LNKVendorDesc, dbo.LNK.LNKAtQty, dbo.LNK.LNKRFQDate, dbo.LNK.LNKMinIncrement, 
                dbo.LNK.LNKCurrentCost, dbo.LNK.LNKSetupCost, dbo.LNK.LNKRoHS, dbo.LNK.LNKRoHSDoc, dbo.LNK.LNKRoHSNote, 
                dbo.qryLinkedSUInfo.SUID, dbo.qryLinkedSUInfo.SUSupplier, dbo.qryLinkedMFRInfo.MFRID, 
                dbo.qryLinkedMFRInfo.MFRMfrName, dbo.qryLinkedMFRPNInfo.MFRPNID, dbo.qryLinkedMFRPNInfo.MFRPNMFRID, 
                dbo.qryLinkedMFRPNInfo.MFRPNPart
FROM      dbo.qryLinkedMFRInfo RIGHT OUTER JOIN
                dbo.qryLinkedMFRPNInfo RIGHT OUTER JOIN
                dbo.qryLinkedSUInfo RIGHT OUTER JOIN
                dbo.LNK ON dbo.qryLinkedSUInfo.SUID = dbo.LNK.LNKSUID ON 
                dbo.qryLinkedMFRPNInfo.MFRPNID = dbo.LNK.LNKMFRPNID ON 
                dbo.qryLinkedMFRInfo.MFRID = dbo.LNK.LNKMFRID
WHERE   (dbo.LNK.LNKUse = 1)

GO
/****** Object:  View [dbo].[qryLNKPlus]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryLNKPlus]
AS
SELECT   dbo.LNK.LNKID, dbo.LNK.LNKSUID, dbo.LNK.LNKMFRPNID, dbo.LNK.LNKMFRID, dbo.LNK.LNKUNID, dbo.LNK.LNKPNID, 
                dbo.LNK.LNKToPNID, dbo.LNK.LNKUse, dbo.LNK.LNKLeadtime, dbo.LNK.LNKChoice, dbo.LNK.LNKVendorPN, 
                dbo.LNK.LNKVendorDesc, dbo.LNK.LNKAtQty, dbo.LNK.LNKRFQDate, dbo.LNK.LNKMinIncrement, 
                dbo.LNK.LNKCurrentCost, dbo.LNK.LNKSetupCost, dbo.LNK.LNKRoHS, dbo.LNK.LNKRoHSDoc, dbo.LNK.LNKRoHSNote, 
                dbo.UN.UNID, dbo.UN.UNUseUnits, dbo.UN.UNPurchUnits, dbo.UN.UNConvUnits, dbo.qryLinkedSUInfo.SUSupplier, 
                dbo.qryLinkedMFRInfo.MFRMfrName, dbo.qryLinkedMFRPNInfo.MFRPNID, dbo.qryLinkedMFRPNInfo.MFRPNMFRID, 
                dbo.qryLinkedMFRPNInfo.MFRPNPart
FROM      dbo.UN RIGHT OUTER JOIN
                dbo.qryLinkedMFRInfo RIGHT OUTER JOIN
                dbo.qryLinkedMFRPNInfo RIGHT OUTER JOIN
                dbo.qryLinkedSUInfo RIGHT OUTER JOIN
                dbo.LNK ON dbo.qryLinkedSUInfo.SUID = dbo.LNK.LNKSUID ON 
                dbo.qryLinkedMFRPNInfo.MFRPNID = dbo.LNK.LNKMFRPNID ON 
                dbo.qryLinkedMFRInfo.MFRID = dbo.LNK.LNKMFRID ON dbo.UN.UNID = dbo.LNK.LNKUNID

GO
/****** Object:  View [dbo].[qryPN]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryPN]
AS
SELECT   PNID, PNIDToLNK, PNUNID, PNTabParentID, PNPrefix, PNPartNumber, PNSuffix, PNType, PNRevision, PNTitle, 
                PNDetail, PNStatus, PNReqBy, PNNotes, PNUser1, PNUser2, PNUser3, PNUser4, PNUser5, PNUser6, PNUser7, 
                PNUser8, PNUser9, PNUser10, PNDate, PNTab, PNControlled, PNAux1, PNQty, PNQty2, PNCostChanged, PNParentCost, 
                PNExpandList, PNAssyCostOption, PNInclAssyOnPurchList, PNMadeFrom, PNMinStockQty, PNOrderToMaintain, 
                PNOnECO, PNOverKit, PNOverKitQty, PNOverKitBy, PNOverKitFor, PNCurrentCost, PNLastRollupCost, PNUSRID, 
                PNUserLock, PNPictureName, SearchData
FROM      dbo.PN

GO
/****** Object:  View [dbo].[qryBOM]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryBOM]
AS
SELECT   dbo.PL.PLItem, dbo.PL.PLQty, dbo.qryPN.PNPartNumber, dbo.qryPN.PNType, dbo.qryPN.PNTitle, dbo.qryPN.PNDetail, 
                dbo.qryPN.PNRevision, dbo.qryPN.PNStatus, dbo.PL.PLPartID, dbo.PL.PLListID, dbo.qryLNKForPL.LNKVendorPN, 
                dbo.qryLNKForPL.LNKCurrentCost, dbo.qryPN.PNLastRollupCost, dbo.qryPN.PNCurrentCost, 
                dbo.qryLNKForPL.SUSupplier, dbo.qryLNKForPL.MFRID, dbo.qryLNKForPL.MFRMfrName, dbo.qryLNKForPL.MFRPNID, 
                dbo.qryLNKForPL.LNKVendorDesc, dbo.qryPN.PNQty, dbo.qryLNKForPL.LNKID, dbo.PL.PLID, 
                dbo.qryLNKForPL.LNKUNID AS BuyUnitID, dbo.qryPN.PNUNID AS UseUnitID, dbo.PL.PLRefMemo
FROM      dbo.PL LEFT OUTER JOIN
                dbo.qryLNKForPL ON dbo.PL.PLPartID = dbo.qryLNKForPL.LNKPNID INNER JOIN
                dbo.qryPN ON dbo.PL.PLPartID = dbo.qryPN.PNID

GO
/****** Object:  View [dbo].[qryItemsAndAnySources]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryItemsAndAnySources]
AS
SELECT   dbo.PN.PNID, dbo.PN.PNIDToLNK, dbo.PN.PNUNID, dbo.PN.PNTabParentID, dbo.PN.PNPrefix, dbo.PN.PNPartNumber, 
                dbo.PN.PNSuffix, dbo.PN.PNType, dbo.PN.PNRevision, dbo.PN.PNTitle, dbo.PN.PNDetail, dbo.PN.PNStatus, 
                dbo.PN.PNReqBy, dbo.PN.PNNotes, dbo.PN.PNUser1, dbo.PN.PNUser2, dbo.PN.PNUser3, dbo.PN.PNUser4, 
                dbo.PN.PNUser5, dbo.PN.PNUser6, dbo.PN.PNUser7, dbo.PN.PNUser8, dbo.PN.PNUser9, dbo.PN.PNUser10, 
                dbo.PN.PNDate, dbo.PN.PNTab, dbo.PN.PNControlled, dbo.PN.PNAux1, dbo.PN.PNQty, dbo.PN.PNQty2, 
                dbo.PN.PNCostChanged, dbo.PN.PNParentCost, dbo.PN.PNExpandList, dbo.PN.PNAssyCostOption, 
                dbo.PN.PNInclAssyOnPurchList, dbo.PN.PNMadeFrom, dbo.PN.PNMinStockQty, dbo.PN.PNOrderToMaintain, 
                dbo.PN.PNOnECO, dbo.PN.PNOverKit, dbo.PN.PNOverKitQty, dbo.PN.PNOverKitBy, dbo.PN.PNOverKitFor, 
                dbo.PN.PNCurrentCost, dbo.PN.PNLastRollupCost, dbo.PN.PNUSRID, dbo.PN.PNUserLock, dbo.PN.PNPictureName, 
                dbo.LNK.LNKID, dbo.LNK.LNKSUID, dbo.LNK.LNKMFRPNID, dbo.LNK.LNKMFRID, dbo.LNK.LNKUNID, dbo.LNK.LNKPNID, 
                dbo.LNK.LNKToPNID, dbo.LNK.LNKUse, dbo.LNK.LNKLeadtime, dbo.LNK.LNKChoice, dbo.LNK.LNKVendorPN, 
                dbo.LNK.LNKVendorDesc, dbo.LNK.LNKAtQty, dbo.LNK.LNKRFQDate, dbo.LNK.LNKMinIncrement, 
                dbo.LNK.LNKCurrentCost, dbo.LNK.LNKSetupCost, dbo.LNK.LNKRoHS, dbo.LNK.LNKRoHSDoc, dbo.LNK.LNKRoHSNote, 
                dbo.UN.UNID, dbo.UN.UNUseUnits, dbo.UN.UNPurchUnits, dbo.UN.UNConvUnits, dbo.qryLinkedSUInfo.SUID, 
                dbo.qryLinkedSUInfo.SUSupplier, dbo.qryLinkedMFRInfo.MFRID, dbo.qryLinkedMFRInfo.MFRMfrName, 
                dbo.qryLinkedMFRPNInfo.MFRPNID, dbo.qryLinkedMFRPNInfo.MFRPNMFRID, 
                dbo.qryLinkedMFRPNInfo.MFRPNPart
FROM      dbo.UN RIGHT OUTER JOIN
                dbo.PN LEFT OUTER JOIN
                dbo.qryLinkedMFRInfo RIGHT OUTER JOIN
                dbo.qryLinkedMFRPNInfo RIGHT OUTER JOIN
                dbo.qryLinkedSUInfo RIGHT OUTER JOIN
                dbo.LNK ON dbo.qryLinkedSUInfo.SUID = dbo.LNK.LNKSUID ON 
                dbo.qryLinkedMFRPNInfo.MFRPNID = dbo.LNK.LNKMFRPNID ON 
                dbo.qryLinkedMFRInfo.MFRID = dbo.LNK.LNKMFRID ON dbo.PN.PNID = dbo.LNK.LNKPNID ON 
                dbo.UN.UNID = dbo.LNK.LNKUNID

GO
/****** Object:  View [dbo].[qryLNKPrimaryPlus]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryLNKPrimaryPlus]
AS
SELECT   dbo.LNK.LNKID, dbo.LNK.LNKSUID, dbo.LNK.LNKMFRPNID, dbo.LNK.LNKMFRID, dbo.LNK.LNKUNID, dbo.LNK.LNKPNID, 
                dbo.LNK.LNKToPNID, dbo.LNK.LNKUse, dbo.LNK.LNKLeadtime, dbo.LNK.LNKChoice, dbo.LNK.LNKVendorPN, 
                dbo.LNK.LNKVendorDesc, dbo.LNK.LNKAtQty, dbo.LNK.LNKRFQDate, dbo.LNK.LNKMinIncrement, 
                dbo.LNK.LNKCurrentCost, dbo.LNK.LNKSetupCost, dbo.LNK.LNKRoHS, dbo.LNK.LNKRoHSDoc, dbo.LNK.LNKRoHSNote, 
                dbo.UN.UNID, dbo.UN.UNUseUnits, dbo.UN.UNPurchUnits, dbo.UN.UNConvUnits, dbo.qryLinkedSUInfo.SUSupplier, 
                dbo.qryLinkedMFRInfo.MFRMfrName, dbo.qryLinkedMFRPNInfo.MFRPNID, dbo.qryLinkedMFRPNInfo.MFRPNMFRID, 
                dbo.qryLinkedMFRPNInfo.MFRPNPart
FROM      dbo.UN RIGHT OUTER JOIN
                dbo.qryLinkedMFRInfo RIGHT OUTER JOIN
                dbo.qryLinkedMFRPNInfo RIGHT OUTER JOIN
                dbo.qryLinkedSUInfo RIGHT OUTER JOIN
                dbo.LNK ON dbo.qryLinkedSUInfo.SUID = dbo.LNK.LNKSUID ON 
                dbo.qryLinkedMFRPNInfo.MFRPNID = dbo.LNK.LNKMFRPNID ON 
                dbo.qryLinkedMFRInfo.MFRID = dbo.LNK.LNKMFRID ON dbo.UN.UNID = dbo.LNK.LNKUNID
WHERE   (dbo.LNK.LNKUse = 1)

GO
/****** Object:  View [dbo].[qryCUR]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryCUR]
AS
SELECT   CURID, CURCurrencyName, CURExchangeRate, CURCurrencyChar, CURFormat, CURFormatExt
FROM      dbo.CUR

GO
/****** Object:  View [dbo].[qryCustomer]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryCustomer]
AS
SELECT   dbo.CU.*
FROM      dbo.CU

GO
/****** Object:  View [dbo].[qryLNKSUP]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryLNKSUP]
AS
SELECT   dbo.LNK.LNKID, dbo.LNK.LNKSUID, dbo.LNK.LNKMFRPNID, dbo.LNK.LNKMFRID, dbo.LNK.LNKUNID, dbo.LNK.LNKPNID, 
                dbo.LNK.LNKToPNID, dbo.LNK.LNKUse, dbo.LNK.LNKLeadtime, dbo.LNK.LNKChoice, dbo.LNK.LNKVendorPN, 
                dbo.LNK.LNKVendorDesc, dbo.LNK.LNKAtQty, dbo.LNK.LNKRFQDate, dbo.LNK.LNKMinIncrement, 
                dbo.LNK.LNKCurrentCost, dbo.LNK.LNKSetupCost, dbo.LNK.LNKRoHS, dbo.LNK.LNKRoHSDoc, dbo.LNK.LNKRoHSNote, 
                dbo.SU.SUID, dbo.SU.SUSupplier, dbo.SU.SUPhone1, dbo.SU.SUPhone2, dbo.SU.SUFAX, dbo.SU.SUWeb, 
                dbo.SU.SUContact1, dbo.SU.SUContact2, dbo.SU.SUCode
FROM      dbo.SU RIGHT OUTER JOIN
                dbo.LNK ON dbo.SU.SUID = dbo.LNK.LNKSUID
WHERE   (dbo.LNK.LNKUse = 1)

GO
/****** Object:  View [dbo].[qryMF]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryMF]
AS
SELECT   MFID, MFPNIDParent, MFPNIDSub, MFQty
FROM      dbo.MF

GO
/****** Object:  View [dbo].[qryMFRPNToLNKToPN]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryMFRPNToLNKToPN]
AS
SELECT   dbo.PN.PNID, dbo.PN.PNIDToLNK, dbo.PN.PNUNID, dbo.PN.PNTabParentID, dbo.PN.PNPrefix, dbo.PN.PNPartNumber, 
                dbo.PN.PNSuffix, dbo.PN.PNType, dbo.PN.PNRevision, dbo.PN.PNTitle, dbo.PN.PNDetail, dbo.PN.PNStatus, 
                dbo.PN.PNReqBy, dbo.PN.PNNotes, dbo.PN.PNUser1, dbo.PN.PNUser2, dbo.PN.PNUser3, dbo.PN.PNUser4, 
                dbo.PN.PNUser5, dbo.PN.PNUser6, dbo.PN.PNUser7, dbo.PN.PNUser8, dbo.PN.PNUser9, dbo.PN.PNUser10, 
                dbo.PN.PNDate, dbo.PN.PNTab, dbo.PN.PNControlled, dbo.PN.PNAux1, dbo.PN.PNQty, dbo.PN.PNQty2, 
                dbo.PN.PNCostChanged, dbo.PN.PNParentCost, dbo.PN.PNExpandList, dbo.PN.PNAssyCostOption, 
                dbo.PN.PNInclAssyOnPurchList, dbo.PN.PNMadeFrom, dbo.PN.PNMinStockQty, dbo.PN.PNOrderToMaintain, 
                dbo.PN.PNOnECO, dbo.PN.PNOverKit, dbo.PN.PNOverKitQty, dbo.PN.PNOverKitBy, dbo.PN.PNOverKitFor, 
                dbo.PN.PNCurrentCost, dbo.PN.PNLastRollupCost, dbo.PN.PNUSRID, dbo.PN.PNUserLock, dbo.PN.PNPictureName, 
                dbo.LNK.LNKID, dbo.LNK.LNKSUID, dbo.LNK.LNKMFRPNID, dbo.LNK.LNKMFRID, dbo.LNK.LNKUNID, dbo.LNK.LNKPNID, 
                dbo.LNK.LNKToPNID, dbo.LNK.LNKUse, dbo.LNK.LNKLeadtime, dbo.LNK.LNKChoice, dbo.LNK.LNKVendorPN, 
                dbo.LNK.LNKVendorDesc, dbo.LNK.LNKAtQty, dbo.LNK.LNKRFQDate, dbo.LNK.LNKMinIncrement, 
                dbo.LNK.LNKCurrentCost, dbo.LNK.LNKSetupCost, dbo.LNK.LNKRoHS, dbo.LNK.LNKRoHSDoc, 
                dbo.LNK.LNKRoHSNote
FROM      dbo.PN INNER JOIN
                dbo.LNK ON dbo.PN.PNID = dbo.LNK.LNKPNID

GO
/****** Object:  View [dbo].[qryPO]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryPO]
AS
SELECT   dbo.POM.POMID, dbo.POM.POMNumber, dbo.POM.POMDatePrinted, dbo.POM.POMSupplier, dbo.POM.POMSUID, 
                dbo.POM.POMAccount, dbo.POM.POMNotes, dbo.POM.POMAttnTo, dbo.POM.POMFromBuyer, 
                dbo.POM.POMEngrgContact, dbo.POM.POMDateReq, dbo.POM.POMDateClosed, dbo.POM.POMFOB, 
                dbo.POM.POMTerms, dbo.POM.POMInsurance, dbo.POM.POMUseOurShpngAcct, dbo.POM.POMShippingAcct, 
                dbo.POM.POMThisIsRFQ, dbo.POM.POMPendingPrint, dbo.POM.POMTaxRate, dbo.POM.POMShipMethod, 
                dbo.POM.POMShipTo, dbo.POM.POMTaxRate2, dbo.POM.POMTaxTotal2, dbo.POM.POMTax2OnTax1, 
                dbo.POM.POMTotalCost, dbo.POM.POMTotalTax, dbo.POM.POMSubTotal, dbo.POM.POMCURID, 
                dbo.POM.POMCurName, dbo.POM.POMCurExRate, dbo.POM.POMDateReqDate, dbo.PO.POID, dbo.PO.POPOMID, 
                dbo.PO.POLNKID, dbo.PO.POItem, dbo.PO.POPart, dbo.PO.PORev, dbo.PO.PODescription, dbo.PO.POReceived, 
                dbo.PO.POPurchUnits, dbo.PO.POUseUnits, dbo.PO.POConvUnits, dbo.PO.PORFQQty, dbo.PO.POAcct, dbo.PO.POIHPart, 
                dbo.PO.POSchedule, dbo.PO.POTaxable, dbo.PO.POTaxable2, dbo.PO.POExtension, dbo.PO.POExtPlusTax, 
                dbo.PO.POCost, dbo.PO.POQty, dbo.PO.POItemQtyEntry, dbo.PO.POItemQtyReceived, dbo.PO.POItemQtyBackordered, 
                dbo.PO.POTax1, dbo.PO.POTax2, dbo.SU.SUID, dbo.SU.SUSupplier, dbo.SU.SUAddress, dbo.SU.SUCountry, 
                dbo.SU.SUPhone1, dbo.SU.SUPhone2, dbo.SU.SUFAX, dbo.SU.SUWeb, dbo.SU.SUContact1, dbo.SU.SUContact2, 
                dbo.SU.SUDateLast, dbo.SU.SUFollowup, dbo.SU.SUNotes, dbo.SU.SUCode, dbo.SU.SUAccount, dbo.SU.SUTerms, 
                dbo.SU.SUFedTaxID, dbo.SU.SUStateTaxID, dbo.SU.SUEMail1, dbo.SU.SUEMail2, dbo.SU.SUCurDedExRate, 
                dbo.SU.SUCurExRate, dbo.SU.SUCURID, dbo.SU.SUCurReverse, dbo.SU.SUNoPhonePrefix
FROM      dbo.POM INNER JOIN
                dbo.SU ON dbo.POM.POMSupplier = dbo.SU.SUSupplier INNER JOIN
                dbo.PO ON dbo.POM.POMID = dbo.PO.POPOMID

GO
/****** Object:  View [dbo].[qryPriLNKUN]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryPriLNKUN]
AS
SELECT   dbo.LNK.LNKID, dbo.LNK.LNKPNID, dbo.LNK.LNKCurrentCost, dbo.UN.UNConvUnits
FROM      dbo.UN INNER JOIN
                dbo.LNK ON dbo.UN.UNID = dbo.LNK.LNKUNID
WHERE   (dbo.LNK.LNKUse = 1)

GO
/****** Object:  View [dbo].[qrySU]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qrySU]
AS
SELECT   SUID, SUSupplier, SUAddress, SUCountry, SUPhone1, SUPhone2, SUFAX, SUWeb, SUContact1, SUContact2, 
                SUDateLast, SUFollowup, SUNotes, SUCode, SUAccount, SUTerms, SUFedTaxID, SUStateTaxID, SUEMail1, SUEMail2, 
                SUCurDedExRate, SUCurExRate, SUCURID, SUCurReverse, SUNoPhonePrefix
FROM      dbo.SU

GO
/****** Object:  View [dbo].[qryTotalsByJob]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryTotalsByJob]
AS
SELECT   POPOMID, POAcct, SUM(POExtension) AS SumOfPOExtension, SUM(POExtPlusTax) AS SumOfPOExtPlusTax
FROM      dbo.PO
GROUP BY POPOMID, POAcct

GO
/****** Object:  View [dbo].[qryUseAsQtyOnOrder]    Script Date: 2016/10/27 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qryUseAsQtyOnOrder]
AS
SELECT   Sum((IIf(([POQty] - [POItemQtyReceived]) < 0, 0, [POQty] - [POItemQtyReceived])) * [POConvUnits]) AS SumOfUseAs, 
                PO.POIHPart
FROM      POM INNER JOIN
                PO ON POM.POMID = PO.POPOMID
WHERE   (((POM.POMDatePrinted) IS NOT NULL) AND ((POM.POMDateClosed) IS NULL) AND ((POM.POMThisIsRFQ) = 0))
GROUP BY PO.POIHPart;

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PL"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 201
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLNKForPL"
            Begin Extent = 
               Top = 150
               Left = 38
               Bottom = 289
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryPN"
            Begin Extent = 
               Top = 294
               Left = 38
               Bottom = 433
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryBOM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryBOM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CUR"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryCUR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryCUR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CU"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryCustomer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryCustomer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "UN"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 207
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PN"
            Begin Extent = 
               Top = 150
               Left = 38
               Bottom = 289
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedMFRInfo"
            Begin Extent = 
               Top = 294
               Left = 38
               Bottom = 433
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedMFRPNInfo"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 558
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedSUInfo"
            Begin Extent = 
               Top = 558
               Left = 38
               Bottom = 697
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LNK"
            Begin Extent = 
               Top = 702
               Left = 38
               Bottom = 841
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryItemsAndAnySources'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'       Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryItemsAndAnySources'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryItemsAndAnySources'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MFR"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLinkedMFRInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLinkedMFRInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MFRPN"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLinkedMFRPNInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLinkedMFRPNInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SU"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLinkedSUInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLinkedSUInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[12] 4[21] 2[47] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "qryLinkedMFRInfo"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedMFRPNInfo"
            Begin Extent = 
               Top = 150
               Left = 38
               Bottom = 270
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedSUInfo"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 409
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LNK"
            Begin Extent = 
               Top = 414
               Left = 38
               Bottom = 553
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLNKForPL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLNKForPL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "UN"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 207
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedMFRInfo"
            Begin Extent = 
               Top = 150
               Left = 38
               Bottom = 289
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedMFRPNInfo"
            Begin Extent = 
               Top = 294
               Left = 38
               Bottom = 414
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedSUInfo"
            Begin Extent = 
               Top = 414
               Left = 38
               Bottom = 553
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LNK"
            Begin Extent = 
               Top = 558
               Left = 38
               Bottom = 697
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Ali' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLNKPlus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'as = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLNKPlus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLNKPlus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "UN"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 207
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedMFRInfo"
            Begin Extent = 
               Top = 150
               Left = 38
               Bottom = 289
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedMFRPNInfo"
            Begin Extent = 
               Top = 294
               Left = 38
               Bottom = 414
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryLinkedSUInfo"
            Begin Extent = 
               Top = 414
               Left = 38
               Bottom = 553
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LNK"
            Begin Extent = 
               Top = 558
               Left = 38
               Bottom = 697
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLNKPrimaryPlus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLNKPrimaryPlus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLNKPrimaryPlus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SU"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LNK"
            Begin Extent = 
               Top = 150
               Left = 38
               Bottom = 289
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLNKSUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryLNKSUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MF"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryMF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryMF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PN"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LNK"
            Begin Extent = 
               Top = 150
               Left = 38
               Bottom = 289
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryMFRPNToLNKToPN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryMFRPNToLNKToPN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PN"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 303
               Right = 427
            End
            DisplayFlags = 280
            TopColumn = 37
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryPN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryPN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "POM"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SU"
            Begin Extent = 
               Top = 150
               Left = 38
               Bottom = 289
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO"
            Begin Extent = 
               Top = 294
               Left = 38
               Bottom = 433
               Right = 266
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryPO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryPO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "UN"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 207
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LNK"
            Begin Extent = 
               Top = 150
               Left = 38
               Bottom = 289
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryPriLNKUN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryPriLNKUN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SU"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qrySU'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qrySU'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PO"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 282
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryTotalsByJob'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryTotalsByJob'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[13] 2[3] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 2460
         Width = 4350
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryUseAsQtyOnOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qryUseAsQtyOnOrder'
GO
