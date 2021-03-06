USE [WfDB]
GO
/****** Object:  StoredProcedure [dbo].[pr_com_QuerySQLPaged]    Script Date: 07/26/2017 20:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure

create PROCEDURE  [dbo].[pr_com_QuerySQLPaged]      
     @Query nvarchar(MAX), --SQL语句    
     @PageSize int, --每页大小   
     @CurrentPage  int ,  --当前页码   
     @Field nvarchar(40)='', --排序字段   
     @Order nvarchar(10) = 'asc ' --排序顺序   
AS    
    declare @PageCount int,
	        @TempSize int,    
			@TempNum int,  
			@strSQL varchar(max),
			@strField varchar(40),   
			@strFielddesc varchar(40),
			@Tempindex int 

    --0,1都做第一页处理
	if (@currentPage = 0)
		set @currentPage = 1

    set @TempNum = @CurrentPage * @PageSize    
	set @strField = ''
	set @strFielddesc = ''

	--计算总页数
	declare @strCountSQL nvarchar(MAX)
	set @strCountSQL = 'SELECT @total=COUNT(1) FROM (' + @Query + ')T'

	--总记录数
	DECLARE @rowsCount int
	DECLARE @params nvarchar(500)
	SET @params = '@total int OUTPUT'
	EXEC sp_executesql @strCountSQL, @params, @total=@rowsCount OUTPUT

	--根据总记录数，计算页数
	SET @PageCount = ceiling(convert(float, @rowsCount) / convert(float, @PageSize))

	--超过最后一页，显示尾页
    if(@CurrentPage>=@PageCount)    
        set @TempSize=@rowsCount-(@PageCount-1)*@PageSize    
    else  
        set @TempSize=@PageSize  

	SET @Tempindex=Charindex('projcode',@Query,0)
    if( @Tempindex>0 and @Tempindex<Charindex('from',@Query,0))
	begin
		if(@Field<>'' and @Field<>'projcode')
		begin
			set @strField = ',projcode ';
			set	@strFielddesc =',projcode desc ';
		end 
	end 

	--分页SQL
    if(@Order='desc')    
    begin    
      set @strSQL = '
            select *   
            from (   
                    select top '+CONVERT(varchar(10),@TempSize)+' *   
                    from (  
                            select top '+CONVERT(varchar(10),@TempNum)+' *   
                            from ('+@Query+') as t0   
                            order by '+@Field+' desc '+@strField+'  
                    ) as t1   
                    order by '+@Field+@strFielddesc+' 
            ) as t2   
            order by '+@Field+' desc' +@strField   
    end    
    else    
    begin    
      set @strSQL = '
            select *   
            from (  
                    select top '+CONVERT(varchar(10),@TempSize)+' *   
                    from (  
                            select top '+ CONVERT(varchar(10), @TempNum ) + ' *   
                            from ('+@Query+') as t0  
                            order by '+@Field+' asc '+@strField +'
                    ) as t1   
                    order by '+@Field+' desc  '+@strFielddesc+' 
            ) as t2   
            order by '+@Field +@strField  
    end  
    exec(@strSQL)
GO
/****** Object:  Table [dbo].[ManProductOrder]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ManProductOrder](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderCode] [varchar](30) NULL,
	[Status] [smallint] NULL,
	[ProductName] [nvarchar](100) NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[TotalPrice] [decimal](18, 2) NULL,
	[CreatedTime] [datetime] NULL,
	[CustomerName] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Mobile] [varchar](30) NULL,
	[Remark] [nvarchar](1000) NULL,
	[LastUpdatedTime] [datetime] NULL,
 CONSTRAINT [PK_MADPRODUCTORDER] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[ManProductOrder] ON
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (675, N'TB324384', 8, N'遥控灯D型', 5, CAST(1000.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(0x0000A72900F8491F AS DateTime), N'BBC', N'英国伦敦', N'739538', N'C店', CAST(0x0000A72901008DCD AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (676, N'TB377329', 3, N'遥控灯D型', 7, CAST(1000.00 AS Decimal(18, 2)), CAST(7000.00 AS Decimal(18, 2)), CAST(0x0000A79000C4C367 AS DateTime), N'阿里巴巴', N'杭州西湖区', N'802382', N'B店', CAST(0x0000A79000CD1AA9 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (677, N'TB730548', 1, N'智能玩具C型', 6, CAST(1000.00 AS Decimal(18, 2)), CAST(6000.00 AS Decimal(18, 2)), CAST(0x0000A79100A22D8A AS DateTime), N'汇丰银行', N'上海人民广场', N'338600', N'F店', NULL)
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (678, N'TB574787', 3, N'智能玩具C型', 7, CAST(1000.00 AS Decimal(18, 2)), CAST(7000.00 AS Decimal(18, 2)), CAST(0x0000A7B8009E3C10 AS DateTime), N'汇丰银行', N'上海人民广场', N'553578', N'C店', CAST(0x0000A7B8009E525E AS DateTime))
SET IDENTITY_INSERT [dbo].[ManProductOrder] OFF
/****** Object:  Table [dbo].[HrsLeaveOpinion]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HrsLeaveOpinion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ActivityID] [varchar](50) NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[Remark] [nvarchar](1000) NULL,
	[ChangedTime] [datetime] NOT NULL,
	[ChangedUserID] [int] NOT NULL,
	[ChangedUserName] [nvarchar](50) NULL,
 CONSTRAINT [PK_HRSLEAVEOPINION] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[HrsLeaveOpinion] ON
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (1, N'34', N'00000000-0000-0000-0000-000000000000', N'流程发起', N'申请人:6-路天明', CAST(0x0000A7BC013216A4 AS DateTime), 6, N'路天明')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (2, N'34', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', N'张恒丰(ID:5) agree', CAST(0x0000A7BC01326448 AS DateTime), 5, N'张恒丰')
SET IDENTITY_INSERT [dbo].[HrsLeaveOpinion] OFF
/****** Object:  Table [dbo].[HrsLeave]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HrsLeave](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LeaveType] [smallint] NOT NULL,
	[Days] [decimal](18, 1) NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[CurrentActivityText] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[CreatedUserID] [int] NOT NULL,
	[CreatedUserName] [nvarchar](50) NOT NULL,
	[CreatedDate] [date] NOT NULL,
	[DepManagerRemark] [nvarchar](50) NULL,
	[DirectorRemark] [nvarchar](50) NULL,
	[DeputyGeneralRemark] [nvarchar](50) NULL,
	[GeneralManagerRemark] [nvarchar](50) NULL,
 CONSTRAINT [PK_HRLEAVE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'请假天数' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'Days'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'请假开始时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'FromDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'请假结束时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'ToDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'正在办理的节点' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CurrentActivityText'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' /// <summary>
           /// 未启动，流程记录为空
           /// </summary>
           NotStart = 0,
   
           /// <summary>
           /// 准备状态
           /// </summary>
           Ready = 1,
   
           /// <summary>
           /// 运行状态
           /// </summary>
           Running = 2,
   
           /// <summary>
           /// 完成
           /// </summary>
           Completed = 4,
   
           /// <summary>
           /// 挂起
           /// </summary>
           Suspended = 5,
   
           /// <summary>
           /// 取消
           /// </summary>
           Canceled = 6,
   
           /// <summary>
           /// 终止
           /// </summary>
           Discarded = 7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'请假人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CreatedUserID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'请假人名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CreatedUserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'申请日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
SET IDENTITY_INSERT [dbo].[HrsLeave] ON
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (12, 2, CAST(1.0 AS Decimal(18, 1)), CAST(0x843C0B00 AS Date), CAST(0x853C0B00 AS Date), N'人事经理审批', 0, 6, N'路天明', CAST(0x843C0B00 AS Date), N'同意', N'', N'', N'')
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (13, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x913C0B00 AS Date), CAST(0x933C0B00 AS Date), N'人事经理审批', 0, 6, N'路天明', CAST(0x913C0B00 AS Date), N'AGREE', N'', N'', N'')
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (14, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x093D0B00 AS Date), CAST(0x0B3D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x093D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (15, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x093D0B00 AS Date), CAST(0x0B3D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x093D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (16, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (17, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (18, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (19, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (20, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (21, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (22, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (23, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (24, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (25, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (26, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (27, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (28, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (29, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (30, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (31, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (32, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'部门经理审批', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), N'同意', N'', N'', N'')
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (33, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x133D0B00 AS Date), CAST(0x153D0B00 AS Date), N'', 0, 6, N'路天明', CAST(0x133D0B00 AS Date), NULL, NULL, NULL, NULL)
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (34, 2, CAST(3.0 AS Decimal(18, 1)), CAST(0x173D0B00 AS Date), CAST(0x1A3D0B00 AS Date), N'部门经理审批', 0, 6, N'路天明', CAST(0x173D0B00 AS Date), N'agree', N'', N'', N'')
SET IDENTITY_INSERT [dbo].[HrsLeave] OFF
/****** Object:  Table [dbo].[BizAppFlow]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BizAppFlow](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[AppInstanceCode] [varchar](50) NULL,
	[Status] [varchar](10) NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[Remark] [nvarchar](1000) NULL,
	[ChangedTime] [datetime] NOT NULL,
	[ChangedUserID] [varchar](50) NOT NULL,
	[ChangedUserName] [nvarchar](50) NULL,
 CONSTRAINT [PK_SALWALLWAORDERFLOW] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[BizAppFlow] ON
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (113, N'流程发起', N'3', NULL, NULL, N'流程发起', N'mssqlserver申请人:6-普通员工-小明', CAST(0x0000A4F500DC22C7 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (114, N'生产订单', N'624', N'TB300427', NULL, N'派单', N'完成派单', CAST(0x0000A4F5010C6DBA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (115, N'生产订单', N'625', N'TB906432', NULL, N'派单', N'完成派单', CAST(0x0000A4F5010C92A0 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (116, N'生产订单', N'626', N'TB338322', NULL, N'派单', N'完成派单', CAST(0x0000A4F5010CA251 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (117, N'生产订单', N'627', N'TB612344', NULL, N'派单', N'完成派单', CAST(0x0000A4F5014DA236 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (118, N'生产订单', N'628', N'TB683061', NULL, N'派单', N'完成派单', CAST(0x0000A4F5014DAB96 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (119, N'生产订单', N'628', N'TB683061', NULL, N'打样', N'完成打样', CAST(0x0000A4F5014DC627 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (120, N'生产订单', N'627', N'TB612344', NULL, N'打样', N'完成打样', CAST(0x0000A4F5014DCFC6 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (121, N'生产订单', N'627', N'TB612344', NULL, N'生产', N'完成生产', CAST(0x0000A4F700D56961 AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (122, N'生产订单', N'631', N'TB490683', NULL, N'派单', N'完成派单', CAST(0x0000A4F900FBE434 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (123, N'生产订单', N'630', N'TB351094', NULL, N'派单', N'完成派单', CAST(0x0000A4FC016B0F5F AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (124, N'生产订单', N'632', N'TB366615', NULL, N'派单', N'完成派单', CAST(0x0000A4FF00F6BDB6 AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (125, N'生产订单', N'634', N'TB969829', NULL, N'派单', N'完成派单', CAST(0x0000A4FF00F6C6CD AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (126, N'生产订单', N'633', N'TB751853', NULL, N'派单', N'完成派单', CAST(0x0000A4FF0181C823 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (127, N'生产订单', N'639', N'TB792242', NULL, N'派单', N'完成派单', CAST(0x0000A5000117A5C8 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (128, N'生产订单', N'639', N'TB792242', NULL, N'打样', N'完成打样', CAST(0x0000A501008BED22 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (129, N'生产订单', N'640', N'TB429545', NULL, N'派单', N'完成派单', CAST(0x0000A50A010D8B79 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (130, N'生产订单', N'641', N'TB817384', NULL, N'派单', N'完成派单', CAST(0x0000A50B00B381FA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (131, N'生产订单', N'644', N'TB348804', NULL, N'派单', N'完成派单', CAST(0x0000A50B00DCCBEB AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (132, N'生产订单', N'643', N'TB351670', NULL, N'派单', N'完成派单', CAST(0x0000A50B00DCD1CD AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (133, N'生产订单', N'646', N'TB992099', NULL, N'派单', N'完成派单', CAST(0x0000A50B00E44F16 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (134, N'生产订单', N'648', N'TB588606', NULL, N'派单', N'完成派单', CAST(0x0000A50B00EAF847 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (135, N'生产订单', N'642', N'TB434232', NULL, N'派单', N'完成派单', CAST(0x0000A50C0120B5EA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (136, N'生产订单', N'647', N'TB285386', NULL, N'派单', N'完成派单', CAST(0x0000A50F00A2DEAE AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (137, N'生产订单', N'652', N'TB991726', NULL, N'派单', N'完成派单', CAST(0x0000A51001628464 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (138, N'生产订单', N'652', N'TB991726', NULL, N'打样', N'完成打样', CAST(0x0000A5100162D19D AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (139, N'生产订单', N'652', N'TB991726', NULL, N'生产', N'完成生产', CAST(0x0000A510016319E3 AS DateTime), N'10', N'跟单员-李杰')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (140, N'生产订单', N'651', N'TB728743', NULL, N'派单', N'完成派单', CAST(0x0000A513010AF607 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (141, N'生产订单', N'650', N'TB328175', NULL, N'派单', N'完成派单', CAST(0x0000A513010AFA75 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (142, N'流程发起', N'4', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A52B012C1E90 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (143, N'流程发起', N'5', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A52C0091FF62 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (144, N'流程发起', N'6', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A52C010A2086 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (145, N'请假流程', N'6', NULL, NULL, N'部门经理审批', N'部门经理-张(ID:5) 同意', CAST(0x0000A52C01153273 AS DateTime), N'5', N'部门经理-张')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (146, N'生产订单', N'659', N'TB710707', NULL, N'派单', N'完成派单', CAST(0x0000A578013DAC71 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (147, N'生产订单', N'658', N'TB575859', NULL, N'派单', N'完成派单', CAST(0x0000A57801501892 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (148, N'生产订单', N'659', N'TB710707', NULL, N'打样', N'完成打样', CAST(0x0000A57801503093 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (149, N'生产订单', N'657', N'TB358232', NULL, N'派单', N'完成派单', CAST(0x0000A5780167A1AD AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (150, N'生产订单', N'656', N'TB779780', NULL, N'派单', N'完成派单', CAST(0x0000A57A01211907 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (151, N'生产订单', N'655', N'TB322602', NULL, N'派单', N'完成派单', CAST(0x0000A57C014BF2A2 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (152, N'生产订单', N'654', N'TB271916', NULL, N'派单', N'完成派单', CAST(0x0000A57C014D273A AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (153, N'生产订单', N'654', N'TB271916', NULL, N'打样', N'完成打样', CAST(0x0000A57C014D8A62 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (154, N'生产订单', N'653', N'TB559248', NULL, N'派单', N'完成派单', CAST(0x0000A57D012BCA76 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (155, N'生产订单', N'649', N'TB771229', NULL, N'派单', N'完成派单', CAST(0x0000A57D014D0D3C AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (158, N'生产订单', N'645', N'TB642095', NULL, N'派单', N'完成派单', CAST(0x0000A57D016233C7 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (159, N'生产订单', N'660', N'TB967961', NULL, N'派单', N'完成派单', CAST(0x0000A57D0162ECB4 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (160, N'生产订单', N'661', N'TB751700', NULL, N'派单', N'完成派单', CAST(0x0000A57D01648298 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (161, N'生产订单', N'661', N'TB751700', NULL, N'打样', N'完成打样', CAST(0x0000A57D01649AEE AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (162, N'生产订单', N'661', N'TB751700', NULL, N'生产', N'完成生产', CAST(0x0000A57D0164B2E1 AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (163, N'生产订单', N'661', N'TB751700', NULL, N'质检', N'完成质检', CAST(0x0000A57D0164C7F0 AS DateTime), N'13', N'质检员-杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (164, N'生产订单', N'661', N'TB751700', NULL, N'称重', N'完成称重', CAST(0x0000A57D01657E79 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (165, N'生产订单', N'661', N'TB751700', NULL, N'发货', N'完成发货', CAST(0x0000A57D016593FC AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (166, N'生产订单', N'652', N'TB991726', NULL, N'派单', N'完成派单', CAST(0x0000A57E014A4DF8 AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (167, N'生产订单', N'662', N'TB647767', NULL, N'派单', N'完成派单', CAST(0x0000A57E0169A99B AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (168, N'生产订单', N'638', N'TB561443', NULL, N'派单', N'完成派单', CAST(0x0000A57F013BE354 AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (169, N'生产订单', N'663', N'TB809544', NULL, N'派单', N'完成派单', CAST(0x0000A57F013C7377 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (170, N'生产订单', N'664', N'TB914891', NULL, N'派单', N'完成派单', CAST(0x0000A57F013CE48D AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (171, N'生产订单', N'665', N'TB929075', NULL, N'派单', N'完成派单', CAST(0x0000A57F014515AA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (172, N'生产订单', N'666', N'TB225725', NULL, N'派单', N'完成派单', CAST(0x0000A57F0146F53B AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (173, N'生产订单', N'667', N'TB164370', NULL, N'派单', N'完成派单', CAST(0x0000A57F014779F2 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (174, N'生产订单', N'667', N'TB164370', NULL, N'打样', N'完成打样', CAST(0x0000A57F0147D7EC AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (175, N'生产订单', N'667', N'TB164370', NULL, N'生产', N'完成生产', CAST(0x0000A57F0147EF54 AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (176, N'生产订单', N'667', N'TB164370', NULL, N'质检', N'完成质检', CAST(0x0000A57F0148008F AS DateTime), N'13', N'质检员-杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (177, N'生产订单', N'667', N'TB164370', NULL, N'称重', N'完成称重', CAST(0x0000A57F01481487 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (178, N'生产订单', N'667', N'TB164370', NULL, N'发货', N'完成发货', CAST(0x0000A57F01483D30 AS DateTime), N'16', N'包装员-小威')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (179, N'流程发起', N'7', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5B700B21B49 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (180, N'请假流程', N'7', NULL, NULL, N'部门经理审批', N'部门经理-张(ID:5) 同意', CAST(0x0000A5B700B252AE AS DateTime), N'5', N'部门经理-张')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (181, N'请假流程', N'7', NULL, NULL, N'总经理审批', N'总经理-陈(ID:1) 同意', CAST(0x0000A5B700B27226 AS DateTime), N'1', N'总经理-陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (182, N'请假流程', N'7', NULL, NULL, N'人事经理审批', N'人事经理-李小姐(ID:4) ', CAST(0x0000A5B700B28A14 AS DateTime), N'4', N'人事经理-李小姐')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (183, N'流程发起', N'8', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5B700B38A15 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (184, N'请假流程', N'8', NULL, NULL, N'部门经理审批', N'部门经理-张(ID:5) 同意', CAST(0x0000A5B700B3AAF1 AS DateTime), N'5', N'部门经理-张')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (185, N'生产订单', N'669', N'TB747473', NULL, N'派单', N'完成派单', CAST(0x0000A5B700B3E831 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (186, N'生产订单', N'669', N'TB747473', NULL, N'打样', N'完成打样', CAST(0x0000A5B700B3FCE9 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (187, N'生产订单', N'670', N'TB630627', NULL, N'派单', N'完成派单', CAST(0x0000A5B700B44E62 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (188, N'生产订单', N'670', N'TB630627', NULL, N'打样', N'完成打样', CAST(0x0000A5B700B46695 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (189, N'生产订单', N'670', N'TB630627', NULL, N'生产', N'完成生产', CAST(0x0000A5B700B47ECE AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (190, N'生产订单', N'670', N'TB630627', NULL, N'质检', N'完成质检', CAST(0x0000A5B700B493A5 AS DateTime), N'13', N'质检员-杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (191, N'生产订单', N'670', N'TB630627', NULL, N'称重', N'完成称重', CAST(0x0000A5B700B4A808 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (192, N'生产订单', N'670', N'TB630627', NULL, N'发货', N'完成发货', CAST(0x0000A5B700B4C4D8 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (193, N'生产订单', N'671', N'TB165916', NULL, N'派单', N'完成派单', CAST(0x0000A5C5009C0E1E AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (194, N'流程发起', N'9', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5C500A0D72F AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (195, N'流程发起', N'10', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5C500B43CBB AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (196, N'流程发起', N'11', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5C500FE9389 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (197, N'生产订单', N'673', N'TB508950', NULL, N'派单', N'完成派单', CAST(0x0000A61300EE9CA7 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (198, N'生产订单', N'673', N'TB508950', NULL, N'打样', N'完成打样', CAST(0x0000A61300EEB976 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (199, N'生产订单', N'673', N'TB508950', NULL, N'生产', N'完成生产', CAST(0x0000A61300EED70C AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (200, N'生产订单', N'674', N'TB760538', NULL, N'派单', N'完成派单', CAST(0x0000A6320100EBD7 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (201, N'生产订单', N'674', N'TB760538', NULL, N'生产', N'完成生产', CAST(0x0000A6320112805C AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (202, N'生产订单', N'672', N'TB247595', NULL, N'派单', N'完成派单', CAST(0x0000A67D015B8A25 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (203, N'生产订单', N'668', N'TB885696', NULL, N'派单', N'完成派单', CAST(0x0000A72900F7E12C AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (204, N'生产订单', N'675', N'TB324384', NULL, N'派单', N'完成派单', CAST(0x0000A72900F8541C AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (205, N'生产订单', N'675', N'TB324384', NULL, N'打样', N'完成打样', CAST(0x0000A72900FEA7FD AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (206, N'生产订单', N'675', N'TB324384', NULL, N'生产', N'完成生产', CAST(0x0000A729010052AD AS DateTime), N'9', N'张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (207, N'生产订单', N'675', N'TB324384', NULL, N'质检', N'完成质检', CAST(0x0000A72901006C05 AS DateTime), N'13', N'杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (208, N'生产订单', N'675', N'TB324384', NULL, N'称重', N'完成称重', CAST(0x0000A72901007EE5 AS DateTime), N'15', N'大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (209, N'生产订单', N'675', N'TB324384', NULL, N'发货', N'完成发货', CAST(0x0000A72901008DCD AS DateTime), N'15', N'大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (210, N'流程发起', N'12', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A7290103EC77 AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (211, N'请假流程', N'12', NULL, NULL, N'部门经理审批', N'张恒丰(ID:5) 同意', CAST(0x0000A72901040C66 AS DateTime), N'5', N'张恒丰')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (212, N'请假流程', N'12', NULL, NULL, N'人事经理审批', N'李颖(ID:4) ', CAST(0x0000A72901043923 AS DateTime), N'4', N'李颖')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (213, N'流程发起', N'13', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A73600E34BD1 AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (214, N'请假流程', N'13', NULL, NULL, N'部门经理审批', N'张恒丰(ID:5) AGREE', CAST(0x0000A73600E3664D AS DateTime), N'5', N'张恒丰')
GO
print 'Processed 100 total records'
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (215, N'请假流程', N'13', NULL, NULL, N'人事经理审批', N'李颖(ID:4) ', CAST(0x0000A73600E378AA AS DateTime), N'4', N'李颖')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (216, N'生产订单', N'676', N'TB377329', NULL, N'派单', N'完成派单', CAST(0x0000A79000CD1AA5 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (217, N'流程发起', N'32', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A7B8009703E0 AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (218, N'请假流程', N'32', NULL, NULL, N'部门经理审批', N'张恒丰(ID:5) 同意', CAST(0x0000A7B80097B401 AS DateTime), N'5', N'张恒丰')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (219, N'流程发起', N'33', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A7B8009BF515 AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (220, N'生产订单', N'678', N'TB574787', NULL, N'派单', N'完成派单', CAST(0x0000A7B8009E525B AS DateTime), N'7', N'陈盖茨')
SET IDENTITY_INSERT [dbo].[BizAppFlow] OFF
/****** Object:  Table [dbo].[WfTransitionInstance]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfTransitionInstance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TransitionGUID] [varchar](100) NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ProcessInstanceID] [int] NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[TransitionType] [tinyint] NOT NULL,
	[FlyingType] [tinyint] NOT NULL,
	[FromActivityInstanceID] [int] NOT NULL,
	[FromActivityGUID] [varchar](100) NOT NULL,
	[FromActivityType] [smallint] NOT NULL,
	[FromActivityName] [nvarchar](50) NOT NULL,
	[ToActivityInstanceID] [int] NOT NULL,
	[ToActivityGUID] [varchar](100) NOT NULL,
	[ToActivityType] [smallint] NOT NULL,
	[ToActivityName] [nvarchar](50) NOT NULL,
	[ConditionParseResult] [tinyint] NOT NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfTransitionInstance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfTransitionInstance] ON
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1413, N'9cf01621-2dd5-474a-8889-cdbe53a0b72e', N'SamplePrice', N'100', 967, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2502, N'9b78486d-5b8f-4be4-948e-522356e84e79', 1, N'开始', 2503, N'3c438212-4863-4ff8-efc9-a9096c4a8230', 4, N'业务员提交', 1, N'10', N'Long', CAST(0x0000A78D00FE240B AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1414, N'5432de95-cbcd-4349-9cf0-7e67904c52aa', N'SamplePrice', N'100', 967, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2503, N'3c438212-4863-4ff8-efc9-a9096c4a8230', 4, N'业务员提交', 2504, N'eb833577-abb5-4239-875a-5f2e2fcb6d57', 4, N'板房签字', 1, N'10', N'Long', CAST(0x0000A78D00FF65ED AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1415, N'e8851141-e3f5-46d7-a317-b7860e32592e', N'生产订单', N'676', 968, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', 1, 0, 2505, N'e357fe9e-dc33-4075-bd34-6f7425bb7671', 1, N'开始', 2506, N'aad747dd-2b75-449c-a8a6-391b8a426e83', 4, N'派单', 1, N'7', N'陈盖茨', CAST(0x0000A79000CD1A7A AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1416, N'e4d3c553-ba29-4965-dd3e-d098895a10e7', N'生产订单', N'676', 968, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', 1, 0, 2506, N'aad747dd-2b75-449c-a8a6-391b8a426e83', 4, N'派单', 2507, N'890d4971-3d5d-4800-bdf3-a355fd4a6317', 8, N'Or分支节点', 1, N'7', N'陈盖茨', CAST(0x0000A79000CD1AA5 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1417, N'dabaa65d-905b-42c4-f5f7-e599334c03c9', N'生产订单', N'676', 968, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', 1, 0, 2507, N'890d4971-3d5d-4800-bdf3-a355fd4a6317', 8, N'Or分支节点', 2508, N'fc8c71c5-8786-450e-af27-9f6a9de8560f', 4, N'打样', 1, N'7', N'陈盖茨', CAST(0x0000A79000CD1AA5 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1418, N'7af6085c-d40e-4687-ec75-748b7ef18e3d', N'请假流程', N'32', 969, N'2acffb20-6bd1-4891-98c9-c76d022d1445', 1, 0, 2509, N'bb6c9787-0e1c-4de1-ddbc-593992724ca5', 1, N'开始', 2510, N'3242c597-e889-4768-f6db-cafc3d675370', 4, N'员工提交', 1, N'6', N'路天明', CAST(0x0000A7B800970421 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1419, N'92f5a2a2-e89e-4b3e-8ff9-6a72d3a2d946', N'请假流程', N'32', 969, N'2acffb20-6bd1-4891-98c9-c76d022d1445', 1, 0, 2510, N'3242c597-e889-4768-f6db-cafc3d675370', 4, N'员工提交', 2511, N'c437c27a-8351-4805-fd4f-4e270084320a', 4, N'部门经理审批', 1, N'6', N'路天明', CAST(0x0000A7B80097043E AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1420, N'8c1922c3-6d16-452e-a9a0-0b7ba0453347', N'请假流程', N'32', 969, N'2acffb20-6bd1-4891-98c9-c76d022d1445', 1, 0, 2511, N'c437c27a-8351-4805-fd4f-4e270084320a', 4, N'部门经理审批', 2512, N'c05bc40f-579b-49cb-cd12-30c2cba4db1e', 8, N'Gateway', 1, N'5', N'张恒丰', CAST(0x0000A7B80097B406 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1421, N'89c490d0-7a4f-4465-fb4f-0e6914ad703c', N'请假流程', N'32', 969, N'2acffb20-6bd1-4891-98c9-c76d022d1445', 1, 0, 2512, N'c05bc40f-579b-49cb-cd12-30c2cba4db1e', 8, N'Gateway', 2513, N'da9f744b-3f97-40c9-c4f8-67d5a60a2485', 4, N'人事经理审批', 1, N'5', N'张恒丰', CAST(0x0000A7B80097B406 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1422, N'7af6085c-d40e-4687-ec75-748b7ef18e3d', N'请假流程', N'33', 970, N'2acffb20-6bd1-4891-98c9-c76d022d1445', 1, 0, 2514, N'bb6c9787-0e1c-4de1-ddbc-593992724ca5', 1, N'开始', 2515, N'3242c597-e889-4768-f6db-cafc3d675370', 4, N'员工提交', 1, N'6', N'路天明', CAST(0x0000A7B8009BF557 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1423, N'92f5a2a2-e89e-4b3e-8ff9-6a72d3a2d946', N'请假流程', N'33', 970, N'2acffb20-6bd1-4891-98c9-c76d022d1445', 1, 0, 2515, N'3242c597-e889-4768-f6db-cafc3d675370', 4, N'员工提交', 2516, N'c437c27a-8351-4805-fd4f-4e270084320a', 4, N'部门经理审批', 1, N'6', N'路天明', CAST(0x0000A7B8009BF56E AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1424, N'e8851141-e3f5-46d7-a317-b7860e32592e', N'生产订单', N'678', 971, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', 1, 0, 2517, N'e357fe9e-dc33-4075-bd34-6f7425bb7671', 1, N'开始', 2518, N'aad747dd-2b75-449c-a8a6-391b8a426e83', 4, N'派单', 1, N'7', N'陈盖茨', CAST(0x0000A7B8009E5237 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1425, N'e4d3c553-ba29-4965-dd3e-d098895a10e7', N'生产订单', N'678', 971, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', 1, 0, 2518, N'aad747dd-2b75-449c-a8a6-391b8a426e83', 4, N'派单', 2519, N'890d4971-3d5d-4800-bdf3-a355fd4a6317', 8, N'Or分支节点', 1, N'7', N'陈盖茨', CAST(0x0000A7B8009E5259 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1426, N'dabaa65d-905b-42c4-f5f7-e599334c03c9', N'生产订单', N'678', 971, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', 1, 0, 2519, N'890d4971-3d5d-4800-bdf3-a355fd4a6317', 8, N'Or分支节点', 2520, N'fc8c71c5-8786-450e-af27-9f6a9de8560f', 4, N'打样', 1, N'7', N'陈盖茨', CAST(0x0000A7B8009E525A AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1427, N'7af6085c-d40e-4687-ec75-748b7ef18e3d', N'请假流程', N'34', 972, N'2acffb20-6bd1-4891-98c9-c76d022d1445', 1, 0, 2521, N'bb6c9787-0e1c-4de1-ddbc-593992724ca5', 1, N'开始', 2522, N'3242c597-e889-4768-f6db-cafc3d675370', 4, N'员工提交', 1, N'6', N'路天明', CAST(0x0000A7BC01321686 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1428, N'92f5a2a2-e89e-4b3e-8ff9-6a72d3a2d946', N'请假流程', N'34', 972, N'2acffb20-6bd1-4891-98c9-c76d022d1445', 1, 0, 2522, N'3242c597-e889-4768-f6db-cafc3d675370', 4, N'员工提交', 2523, N'c437c27a-8351-4805-fd4f-4e270084320a', 4, N'部门经理审批', 1, N'6', N'路天明', CAST(0x0000A7BC013216A3 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1429, N'8c1922c3-6d16-452e-a9a0-0b7ba0453347', N'请假流程', N'34', 972, N'2acffb20-6bd1-4891-98c9-c76d022d1445', 1, 0, 2523, N'c437c27a-8351-4805-fd4f-4e270084320a', 4, N'部门经理审批', 2524, N'c05bc40f-579b-49cb-cd12-30c2cba4db1e', 8, N'Gateway', 1, N'5', N'张恒丰', CAST(0x0000A7BC01326446 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1430, N'89c490d0-7a4f-4465-fb4f-0e6914ad703c', N'请假流程', N'34', 972, N'2acffb20-6bd1-4891-98c9-c76d022d1445', 1, 0, 2524, N'c05bc40f-579b-49cb-cd12-30c2cba4db1e', 8, N'Gateway', 2525, N'da9f744b-3f97-40c9-c4f8-67d5a60a2485', 4, N'人事经理审批', 1, N'5', N'张恒丰', CAST(0x0000A7BC01326448 AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[WfTransitionInstance] OFF
/****** Object:  Table [dbo].[WfProcessInstance]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfProcessInstance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ProcessName] [nvarchar](50) NOT NULL,
	[Version] [nvarchar](20) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceCode] [nvarchar](50) NULL,
	[ProcessState] [smallint] NOT NULL,
	[ParentProcessInstanceID] [int] NULL,
	[ParentProcessGUID] [varchar](100) NULL,
	[InvokedActivityInstanceID] [int] NULL,
	[InvokedActivityGUID] [varchar](100) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[OverdueDateTime] [datetime] NULL,
	[OverdueTreatedDateTime] [datetime] NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[LastUpdatedByUserID] [varchar](50) NULL,
	[LastUpdatedByUserName] [nvarchar](50) NULL,
	[EndedDateTime] [datetime] NULL,
	[EndedByUserID] [varchar](50) NULL,
	[EndedByUserName] [nvarchar](50) NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfProcessInstance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfProcessInstance] ON
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (967, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'报价流程(SequenceTest)', N'1', N'100', N'SamplePrice', NULL, 8, NULL, NULL, 0, NULL, CAST(0x0000A78D00FE2389 AS DateTime), N'10', N'Long', CAST(0x0000A79A009DB0F1 AS DateTime), CAST(0x0000A79A00B05976 AS DateTime), CAST(0x0000A78D00FE2389 AS DateTime), N'10', N'Long', CAST(0x0000A79A00B05976 AS DateTime), N'ADMIN-1001', N'JOB-ADMINISTRATOR', 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (968, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'订单流程(MvcDemo)', N'1', N'676', N'生产订单', NULL, 8, NULL, NULL, 0, NULL, CAST(0x0000A79000CD1A4C AS DateTime), N'7', N'陈盖茨', CAST(0x0000A79A009DB0F1 AS DateTime), CAST(0x0000A79A00B05976 AS DateTime), CAST(0x0000A79000CD1A4C AS DateTime), N'7', N'陈盖茨', CAST(0x0000A79A00B05976 AS DateTime), N'ADMIN-1001', N'JOB-ADMINISTRATOR', 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (969, N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'请假流程(WebDemo)', N'1', N'32', N'请假流程', NULL, 2, NULL, NULL, 0, NULL, CAST(0x0000A7B8009703ED AS DateTime), N'6', N'路天明', NULL, NULL, CAST(0x0000A7B8009703ED AS DateTime), N'6', N'路天明', NULL, NULL, NULL, 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (970, N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'请假流程(WebDemo)', N'1', N'33', N'请假流程', NULL, 2, NULL, NULL, 0, NULL, CAST(0x0000A7B8009BF523 AS DateTime), N'6', N'路天明', NULL, NULL, CAST(0x0000A7B8009BF523 AS DateTime), N'6', N'路天明', NULL, NULL, NULL, 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (971, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'订单流程(MvcDemo)', N'1', N'678', N'生产订单', NULL, 2, NULL, NULL, 0, NULL, CAST(0x0000A7B8009E5217 AS DateTime), N'7', N'陈盖茨', NULL, NULL, CAST(0x0000A7B8009E5217 AS DateTime), N'7', N'陈盖茨', NULL, NULL, NULL, 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (972, N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'请假流程(WebDemo)', N'1', N'34', N'请假流程', NULL, 2, NULL, NULL, 0, NULL, CAST(0x0000A7BC0132163E AS DateTime), N'6', N'路天明', NULL, NULL, CAST(0x0000A7BC0132163E AS DateTime), N'6', N'路天明', NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[WfProcessInstance] OFF
/****** Object:  Table [dbo].[WfProcess]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfProcess](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ProcessName] [nvarchar](50) NOT NULL,
	[Version] [nvarchar](20) NOT NULL,
	[IsUsing] [tinyint] NOT NULL,
	[AppType] [varchar](20) NULL,
	[PageUrl] [nvarchar](100) NULL,
	[XmlFileName] [nvarchar](50) NULL,
	[XmlFilePath] [nvarchar](50) NULL,
	[XmlContent] [nvarchar](max) NULL,
	[Description] [nvarchar](1000) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfProcess] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfProcess] ON
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (3, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'报价流程(SequenceTest)', N'1', 1, NULL, NULL, NULL, N'price\price.xml', N'<?xml version="1.0" encoding="utf-8" ?>
<Package>
  <Participants>
    <Participant type="Role" id="60c8a694-632a-4ded-9155-f666e461b078" name="业务员(Sales)" code="salesmate" outerId="9" />
    <Participant type="Role" id="7f9be0fb-7ffa-4b57-8c88-26734fbe3cf6" name="打样员(Tech)" code="techmate" outerId="10" />
  </Participants>
  <WorkflowProcesses>
    <Process name="打样申请流程" id="072af8c3-482a-4b1c-890b-685ce2fcc75d">
      <Activities>
        <Activity name="开始" id="9b78486d-5b8f-4be4-948e-522356e84e79" code="">
          <ActivityType type="StartNode" />
          <Geography>
            <Widget left="36" top="118" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="结束" id="b53eb9ab-3af6-41ad-d722-bed946d19792" code="">
          <ActivityType type="EndNode" />
          <Geography>
            <Widget left="825" top="118" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="业务员提交" id="3c438212-4863-4ff8-efc9-a9096c4a8230" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="60c8a694-632a-4ded-9155-f666e461b078" />
          </Performers>
          <Geography>
            <Widget left="202" top="118" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="板房签字" id="eb833577-abb5-4239-875a-5f2e2fcb6d57" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="7f9be0fb-7ffa-4b57-8c88-26734fbe3cf6" />
          </Performers>
          <Geography>
            <Widget left="430" top="118" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="业务员确认" id="cab57060-f433-422a-a66f-4a5ecfafd54e" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="60c8a694-632a-4ded-9155-f666e461b078" />
          </Performers>
          <Geography>
            <Widget left="618" top="118" width="67.2" height="27.2" />
          </Geography>
        </Activity>
      </Activities>
      <Transitions>
        <Transition id="5432de95-cbcd-4349-9cf0-7e67904c52aa" from="3c438212-4863-4ff8-efc9-a9096c4a8230" to="eb833577-abb5-4239-875a-5f2e2fcb6d57">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT3c438212-4863-4ff8-efc9-a9096c4a8230" targetId="ACTeb833577-abb5-4239-875a-5f2e2fcb6d57" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="ac609b39-b6eb-4506-c36f-670c5ed53f5c" from="eb833577-abb5-4239-875a-5f2e2fcb6d57" to="cab57060-f433-422a-a66f-4a5ecfafd54e">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTeb833577-abb5-4239-875a-5f2e2fcb6d57" targetId="ACTcab57060-f433-422a-a66f-4a5ecfafd54e" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="2d5c0e7b-1303-48cb-c22b-3cd2b45701e3" from="cab57060-f433-422a-a66f-4a5ecfafd54e" to="b53eb9ab-3af6-41ad-d722-bed946d19792">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTcab57060-f433-422a-a66f-4a5ecfafd54e" targetId="ACTb53eb9ab-3af6-41ad-d722-bed946d19792" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="9cf01621-2dd5-474a-8889-cdbe53a0b72e" from="9b78486d-5b8f-4be4-948e-522356e84e79" to="3c438212-4863-4ff8-efc9-a9096c4a8230">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT9b78486d-5b8f-4be4-948e-522356e84e79" targetId="ACT3c438212-4863-4ff8-efc9-a9096c4a8230" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
      </Transitions>
    </Process>
  </WorkflowProcesses>
</Package>', N'', CAST(0x0000A3F900E418AE AS DateTime), CAST(0x0000A72700FA7FED AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (24, N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'请假流程(WebDemo)', N'1', 1, NULL, NULL, NULL, N'QINGJIA\HrsLeave1.xml', N'<?xml version="1.0" encoding="utf-8" ?>
<Package>
  <Participants>
    <Participant type="Role" id="3c7aeaed-8b58-46a6-be39-7b850e6ed8e0" name="普通员工" code="employees" outerId="1" />
    <Participant type="Role" id="c9e054eb-7e4f-47c3-a2b9-61e0ff8748d4" name="部门经理" code="depmanager" outerId="2" />
    <Participant type="Role" id="6200799d-ffd2-4ae6-d28f-294a0cd3435a" name="总经理" code="generalmanager" outerId="8" />
    <Participant type="Role" id="a0c8c361-87e1-4106-a7c9-c0b589123c9c" name="人事经理" code="hrmanager" outerId="3" />
  </Participants>
  <WorkflowProcesses>
    <Process name="请假流程(WebDemo)" id="2acffb20-6bd1-4891-98c9-c76d022d1445">
      <Description>null</Description>
      <Layout>
        <Swimlanes />
      </Layout>
      <Activities>
        <Activity id="bb6c9787-0e1c-4de1-ddbc-593992724ca5" name="开始" code="">
          <Description></Description>
          <ActivityType type="StartNode" />
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
            <Widget left="48" top="182" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity id="5eb84b81-0f04-476d-cc82-b42a65464880" name="结束" code="">
          <Description></Description>
          <ActivityType type="EndNode" />
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
            <Widget left="810" top="175" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity id="3242c597-e889-4768-f6db-cafc3d675370" name="员工提交" code="">
          <Description></Description>
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="3c7aeaed-8b58-46a6-be39-7b850e6ed8e0" />
          </Performers>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined">
            <Widget left="180" top="180" width="67" height="27" />
          </Geography>
        </Activity>
        <Activity id="c437c27a-8351-4805-fd4f-4e270084320a" name="部门经理审批" code="">
          <Description></Description>
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="c9e054eb-7e4f-47c3-a2b9-61e0ff8748d4" />
          </Performers>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined">
            <Widget left="360" top="180" width="67" height="27" />
          </Geography>
        </Activity>
        <Activity id="c05bc40f-579b-49cb-cd12-30c2cba4db1e" name="Gateway" code="">
          <Description></Description>
          <ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" />
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
            <Widget left="510" top="186" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity id="a6a8e554-d73e-4a77-8d16-08edf5905e1f" name="总经理审批" code="">
          <Description></Description>
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="6200799d-ffd2-4ae6-d28f-294a0cd3435a" />
          </Performers>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined">
            <Widget left="634" top="120" width="67" height="27" />
          </Geography>
        </Activity>
        <Activity id="da9f744b-3f97-40c9-c4f8-67d5a60a2485" name="人事经理审批" code="">
          <Description></Description>
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="a0c8c361-87e1-4106-a7c9-c0b589123c9c" />
          </Performers>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined">
            <Widget left="634" top="250" width="67" height="27" />
          </Geography>
        </Activity>
      </Activities>
      <Transitions>
        <Transition id="7af6085c-d40e-4687-ec75-748b7ef18e3d" from="bb6c9787-0e1c-4de1-ddbc-593992724ca5" to="3242c597-e889-4768-f6db-cafc3d675370">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined" />
        </Transition>
        <Transition id="92f5a2a2-e89e-4b3e-8ff9-6a72d3a2d946" from="3242c597-e889-4768-f6db-cafc3d675370" to="c437c27a-8351-4805-fd4f-4e270084320a">
          <Description></Description>
          <Receiver />
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined" />
        </Transition>
        <Transition id="8c1922c3-6d16-452e-a9a0-0b7ba0453347" from="c437c27a-8351-4805-fd4f-4e270084320a" to="c05bc40f-579b-49cb-cd12-30c2cba4db1e">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined" />
        </Transition>
        <Transition id="a158f3af-61b2-4169-f131-d0876c20063b" from="c05bc40f-579b-49cb-cd12-30c2cba4db1e" to="a6a8e554-d73e-4a77-8d16-08edf5905e1f">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[days>3]]></ConditionText>
          </Condition>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined" />
        </Transition>
        <Transition id="2333ad8b-f958-4ca3-9e72-678d809de2ca" from="da9f744b-3f97-40c9-c4f8-67d5a60a2485" to="5eb84b81-0f04-476d-cc82-b42a65464880">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined" />
        </Transition>
        <Transition id="efc696f7-83c4-4741-a6f5-e00f9631dda4" from="a6a8e554-d73e-4a77-8d16-08edf5905e1f" to="da9f744b-3f97-40c9-c4f8-67d5a60a2485">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined" />
        </Transition>
        <Transition id="89c490d0-7a4f-4465-fb4f-0e6914ad703c" from="c05bc40f-579b-49cb-cd12-30c2cba4db1e" to="da9f744b-3f97-40c9-c4f8-67d5a60a2485">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[days<=3]]></ConditionText>
          </Condition>
          <Geography parent="badac2c8-1f41-4fa6-be7f-88f16cb20bb2" style="undefined" />
        </Transition>
      </Transitions>
    </Process>
  </WorkflowProcesses>
</Package>', N'', CAST(0x0000A4210179DC78 AS DateTime), CAST(0x0000A797014DFA90 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (33, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'订单流程(MvcDemo)', N'1', 1, NULL, NULL, NULL, N'price\order.jump.tmp.xml', N'<?xml version="1.0" encoding="utf-8" ?>
<Package>
  <Participants>
    <Participant type="Role" id="6398503c-25da-4c49-9530-41d3573c860c" name="业务员" code="salesmate" outerId="9" />
    <Participant type="Role" id="cfb8d004-b27e-40a1-9bc7-55323de0b59b" name="打样员" code="techmate" outerId="10" />
    <Participant type="Role" id="3c80b85c-73a9-4f52-a21f-1df2a9f37cf7" name="跟单员" code="merchandiser" outerId="11" />
    <Participant type="Role" id="eae5fb4f-62d8-4024-81db-4ad8b48e611e" name="质检员" code="qcmate" outerId="12" />
    <Participant type="Role" id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b" name="包装员" code="expressmate" outerId="13" />
  </Participants>
  <WorkflowProcesses>
    <Process name="订单流程(MvcDemo)" id="5c5041fc-ab7f-46c0-85a5-6250c3aea375">
      <Description>null</Description>
      <Activities>
        <Activity id="e357fe9e-dc33-4075-bd34-6f7425bb7671" name="开始" code="undefined">
          <Description></Description>
          <ActivityType type="StartNode" />
          <Geography>
            <Widget left="30" top="92" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity id="aad747dd-2b75-449c-a8a6-391b8a426e83" name="派单" code="Dispatching">
          <Description></Description>
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="6398503c-25da-4c49-9530-41d3573c860c" />
          </Performers>
          <Geography>
            <Widget left="160" top="98" width="67" height="27" />
          </Geography>
        </Activity>
        <Activity id="890d4971-3d5d-4800-bdf3-a355fd4a6317" name="Or分支节点" code="undefined">
          <Description></Description>
          <ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" />
          <Geography>
            <Widget left="317" top="93" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity id="fc8c71c5-8786-450e-af27-9f6a9de8560f" name="打样" code="Sampling">
          <Description></Description>
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="cfb8d004-b27e-40a1-9bc7-55323de0b59b" />
          </Performers>
          <Geography>
            <Widget left="303" top="269" width="67" height="27" />
          </Geography>
        </Activity>
        <Activity id="bf5d8fbe-43bb-4e63-bdac-3c0ee1266803" name="生产" code="Manufacturing">
          <Description></Description>
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="3c80b85c-73a9-4f52-a21f-1df2a9f37cf7" />
            <Performer id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b" />
          </Performers>
          <Geography>
            <Widget left="413" top="269" width="67" height="27" />
          </Geography>
        </Activity>
        <Activity id="39c71004-d822-4c15-9ff2-94ca1068d745" name="质检" code="QCChecking">
          <Description></Description>
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="eae5fb4f-62d8-4024-81db-4ad8b48e611e" />
          </Performers>
          <Geography>
            <Widget left="547" top="268" width="67" height="27" />
          </Geography>
        </Activity>
        <Activity id="422e5354-14f7-4a0a-ae69-c169fee96e50" name="称重" code="Weighting">
          <Description></Description>
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b" />
          </Performers>
          <Geography>
            <Widget left="660" top="179" width="67" height="27" />
          </Geography>
        </Activity>
        <Activity id="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d" name="打印发货单" code="Delivering">
          <Description></Description>
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b" />
          </Performers>
          <Geography>
            <Widget left="650" top="60" width="67" height="27" />
          </Geography>
        </Activity>
        <Activity id="b70e717a-08da-419f-b2eb-7a3d71f054de" name="结束" code="undefined">
          <Description></Description>
          <ActivityType type="EndNode" />
          <Geography>
            <Widget left="867" top="107" width="38" height="38" />
          </Geography>
        </Activity>
      </Activities>
      <Transitions>
        <Transition id="e8851141-e3f5-46d7-a317-b7860e32592e" from="e357fe9e-dc33-4075-bd34-6f7425bb7671" to="aad747dd-2b75-449c-a8a6-391b8a426e83">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
        </Transition>
        <Transition id="e4d3c553-ba29-4965-dd3e-d098895a10e7" from="aad747dd-2b75-449c-a8a6-391b8a426e83" to="890d4971-3d5d-4800-bdf3-a355fd4a6317">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
        </Transition>
        <Transition id="dabaa65d-905b-42c4-f5f7-e599334c03c9" from="890d4971-3d5d-4800-bdf3-a355fd4a6317" to="fc8c71c5-8786-450e-af27-9f6a9de8560f">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[CanUseStock == "false" && IsHavingWeight == "false"]]></ConditionText>
          </Condition>
        </Transition>
        <Transition id="8eb5ee28-4d72-4361-fc4a-44ea46cbd639" from="890d4971-3d5d-4800-bdf3-a355fd4a6317" to="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[CanUseStock == "true" && IsHavingWeight == "true"]]></ConditionText>
          </Condition>
        </Transition>
        <Transition id="bea1aa54-2167-4438-a9bf-1a2cbc5f43c9" from="fc8c71c5-8786-450e-af27-9f6a9de8560f" to="bf5d8fbe-43bb-4e63-bdac-3c0ee1266803">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
        </Transition>
        <Transition id="7a1dac3c-4f8c-46b2-bcb9-2ea36df29e27" from="bf5d8fbe-43bb-4e63-bdac-3c0ee1266803" to="39c71004-d822-4c15-9ff2-94ca1068d745">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
        </Transition>
        <Transition id="9da96321-6bad-4673-829a-0bda31c3e3e1" from="39c71004-d822-4c15-9ff2-94ca1068d745" to="422e5354-14f7-4a0a-ae69-c169fee96e50">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
        </Transition>
        <Transition id="67a3fe0e-06d3-4a01-e0c1-1a731166c905" from="422e5354-14f7-4a0a-ae69-c169fee96e50" to="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
        </Transition>
        <Transition id="75f0eb1d-1933-4a0a-a953-76a755744336" from="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d" to="b70e717a-08da-419f-b2eb-7a3d71f054de">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[]]></ConditionText>
          </Condition>
        </Transition>
        <Transition id="95098c43-7acc-48f9-fd5f-6b27b445137b" from="890d4971-3d5d-4800-bdf3-a355fd4a6317" to="422e5354-14f7-4a0a-ae69-c169fee96e50">
          <Description></Description>
          <Condition type="Expression">
            <ConditionText><![CDATA[CanUseStock == "true" && IsHavingWeight == "false"]]></ConditionText>
          </Condition>
        </Transition>
      </Transitions>
    </Process>
  </WorkflowProcesses>
</Package>', N'', CAST(0x0000A4D2011D084F AS DateTime), CAST(0x0000A779011407FB AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (51, N'ec794d6d-4543-4938-b5f5-cdd97cf939d6', N'财务报销', N'1', 1, N'baoxiao', NULL, N'baoxiao.xml', N'baoxiao\baoxiao.xml', N'<?xml version="1.0" encoding="utf-8" ?>
<Package>
  <Participants>
    <Participant type="Role" id="6e3e7793-638f-4a48-d787-2a1016711602" name="普通员工" code="employees" outerId="1" />
    <Participant type="Role" id="8ad2131e-a98e-4523-acba-88e4404ce0a9" name="部门经理" code="depmanager" outerId="2" />
    <Participant type="Role" id="77858784-3ec7-4849-c9c2-15e5e6dead0d" name="财务经理" code="finacemanager" outerId="14" />
    <Participant type="Role" id="0501e326-8541-4d13-8159-d510d57ce1f5" name="总经理" code="generalmanager" outerId="8" />
    <Participant type="Role" id="23d1c029-ec6e-4212-c9a5-1b82472d4747" name="主管总监" code="director" outerId="4" />
  </Participants>
  <WorkflowProcesses>
    <Process name="财务报销" id="ec794d6d-4543-4938-b5f5-cdd97cf939d6">
      <Activities>
        <Activity name="开始" id="fe775212-6351-4c9b-ea02-f54a8b95d63b" code="">
          <ActivityType type="StartNode" />
          <Geography>
            <Widget left="59" top="160" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="结束" id="77124224-0de9-4407-9d61-4405c8131c48" code="">
          <ActivityType type="EndNode" />
          <Geography>
            <Widget left="925" top="219" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="填写报销单据" id="7230bb34-3c35-4f44-8f2e-0933cb85aa35" code="appform">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="6e3e7793-638f-4a48-d787-2a1016711602" />
          </Performers>
          <Geography>
            <Widget left="198" top="159" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="财务审批" id="889aa813-3eab-4515-89af-cbd133cf030b" code="accountaduit">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="77858784-3ec7-4849-c9c2-15e5e6dead0d" />
          </Performers>
          <Geography>
            <Widget left="354" top="153" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="Gateway" id="548e2052-1eab-43b0-a55c-020582b0b1c8" code="">
          <ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" />
          <Geography>
            <Widget left="532" top="167" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="总经理审批" id="c36fa3c0-3b68-4bf6-dc31-1ea939815cfd" code="ceoaudit">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="0501e326-8541-4d13-8159-d510d57ce1f5" />
          </Performers>
          <Geography>
            <Widget left="629" top="116" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="主管总监查阅" id="77129a09-6b2c-43aa-af77-ba5ced57a174" code="cooaudit">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="23d1c029-ec6e-4212-c9a5-1b82472d4747" />
          </Performers>
          <Geography>
            <Widget left="618" top="246" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="Gateway" id="db2df810-7edd-4242-bc64-bac796d78844" code="">
          <Description>总经理审批路由</Description>
          <ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" />
          <Geography>
            <Widget left="816" top="190" width="38" height="38" />
          </Geography>
        </Activity>
      </Activities>
      <Transitions>
        <Transition id="1ef510bb-e317-4df1-9f32-0b17601bb275" from="fe775212-6351-4c9b-ea02-f54a8b95d63b" to="7230bb34-3c35-4f44-8f2e-0933cb85aa35">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTfe775212-6351-4c9b-ea02-f54a8b95d63b" targetId="ACT7230bb34-3c35-4f44-8f2e-0933cb85aa35" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="61b60f12-9193-4134-af1f-8d974d354dfa" from="7230bb34-3c35-4f44-8f2e-0933cb85aa35" to="889aa813-3eab-4515-89af-cbd133cf030b">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT7230bb34-3c35-4f44-8f2e-0933cb85aa35" targetId="ACT889aa813-3eab-4515-89af-cbd133cf030b" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="5c8d1beb-5aef-4cc3-9e08-6fa6e153925d" from="889aa813-3eab-4515-89af-cbd133cf030b" to="548e2052-1eab-43b0-a55c-020582b0b1c8">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT889aa813-3eab-4515-89af-cbd133cf030b" targetId="ACT548e2052-1eab-43b0-a55c-020582b0b1c8" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="96d291c4-3d7e-43e6-f820-dd695daa1fcc" from="548e2052-1eab-43b0-a55c-020582b0b1c8" to="c36fa3c0-3b68-4bf6-dc31-1ea939815cfd">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT548e2052-1eab-43b0-a55c-020582b0b1c8" targetId="ACTc36fa3c0-3b68-4bf6-dc31-1ea939815cfd" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="1a1560ce-1258-46f1-f56e-9d1fb2e6142c" from="548e2052-1eab-43b0-a55c-020582b0b1c8" to="77129a09-6b2c-43aa-af77-ba5ced57a174">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT548e2052-1eab-43b0-a55c-020582b0b1c8" targetId="ACT77129a09-6b2c-43aa-af77-ba5ced57a174" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="c405e021-cacf-412e-ce37-82817953c7ec" from="77129a09-6b2c-43aa-af77-ba5ced57a174" to="db2df810-7edd-4242-bc64-bac796d78844">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT77129a09-6b2c-43aa-af77-ba5ced57a174" targetId="ACTdb2df810-7edd-4242-bc64-bac796d78844" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="60d69b10-ba70-46a4-948c-09d5be318397" from="c36fa3c0-3b68-4bf6-dc31-1ea939815cfd" to="db2df810-7edd-4242-bc64-bac796d78844">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTc36fa3c0-3b68-4bf6-dc31-1ea939815cfd" targetId="ACTdb2df810-7edd-4242-bc64-bac796d78844" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="32c2860a-3b66-4b77-a8f8-0f9578440d6d" from="db2df810-7edd-4242-bc64-bac796d78844" to="77124224-0de9-4407-9d61-4405c8131c48">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTdb2df810-7edd-4242-bc64-bac796d78844" targetId="ACT77124224-0de9-4407-9d61-4405c8131c48" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
      </Transitions>
    </Process>
  </WorkflowProcesses>
</Package>', N'', CAST(0x0000A55A0132BC96 AS DateTime), CAST(0x0000A72900E20DD4 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (71, N'9fb4bca4-5674-4181-a010-f0e730e166dd', N'报价会签(SignTogetherTest)', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8" ?>
<Package>
  <Participants>
    <Participant type="Role" id="28e71769-f197-4fe0-fd9f-63474956dc60" name="业务员(Sales)" code="salesmate" outerId="9" />
    <Participant type="Role" id="24b1a282-d4d4-4461-febb-2f28eb31f48f" name="打样员(Tech)" code="techmate" outerId="10" />
  </Participants>
  <WorkflowProcesses>
    <Process name="报价会签流程" id="9fb4bca4-5674-4181-a010-f0e730e166dd">
      <Activities>
        <Activity name="开始" id="1f303f19-71aa-4879-c501-f4d0f448f0a2" code="">
          <ActivityType type="StartNode" />
          <Geography>
            <Widget left="165" top="120" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="结束" id="7462aae9-da1c-43f0-d741-a4586879de77" code="">
          <ActivityType type="EndNode" />
          <Geography>
            <Widget left="768" top="124" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="业务员提交" id="791d9d3a-882d-4796-cffc-84d9fca76afd" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="28e71769-f197-4fe0-fd9f-63474956dc60" />
          </Performers>
          <Geography>
            <Widget left="303" top="121" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="业务员确认" id="23017d0c-08ca-4a59-9649-c6912b819001" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="28e71769-f197-4fe0-fd9f-63474956dc60" />
          </Performers>
          <Geography>
            <Widget left="621" top="123" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="板房会签" id="36cf2479-e8ec-4936-8bcd-b38101e4664a" code="">
          <ActivityType type="MultipleInstanceNode" complexType="SignTogether" mergeType="Sequence" compareType="Count" completeOrder="3" />
          <Performers>
            <Performer id="24b1a282-d4d4-4461-febb-2f28eb31f48f" />
          </Performers>
          <Geography>
            <Widget left="472" top="119" width="67.2" height="27.2" />
          </Geography>
        </Activity>
      </Activities>
      <Transitions>
        <Transition id="50f7acb2-99d0-4877-e116-5bf19433bb89" from="1f303f19-71aa-4879-c501-f4d0f448f0a2" to="791d9d3a-882d-4796-cffc-84d9fca76afd">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT1f303f19-71aa-4879-c501-f4d0f448f0a2" targetId="ACT791d9d3a-882d-4796-cffc-84d9fca76afd" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="87651a0d-81e5-4d6f-9ef3-ed0be0011c8f" from="791d9d3a-882d-4796-cffc-84d9fca76afd" to="36cf2479-e8ec-4936-8bcd-b38101e4664a">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT791d9d3a-882d-4796-cffc-84d9fca76afd" targetId="ACT36cf2479-e8ec-4936-8bcd-b38101e4664a" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="63031ecf-2116-47a3-a0d8-f920dc5bee11" from="36cf2479-e8ec-4936-8bcd-b38101e4664a" to="23017d0c-08ca-4a59-9649-c6912b819001">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT36cf2479-e8ec-4936-8bcd-b38101e4664a" targetId="ACT23017d0c-08ca-4a59-9649-c6912b819001" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="3d06aebb-2fb3-4995-e0c7-99d488f8312d" from="23017d0c-08ca-4a59-9649-c6912b819001" to="7462aae9-da1c-43f0-d741-a4586879de77">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT23017d0c-08ca-4a59-9649-c6912b819001" targetId="ACT7462aae9-da1c-43f0-d741-a4586879de77" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
      </Transitions>
    </Process>
  </WorkflowProcesses>
</Package>', N'', CAST(0x0000A5D80104157F AS DateTime), CAST(0x0000A7320154D442 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (73, N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'办公用品(SplitJoinTest)', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8" ?>
<Package>
  <Participants>
    <Participant type="Role" id="114e7e8d-574c-42c2-eb1c-3d7160516ba3" name="普通员工" code="employees" outerId="1" />
    <Participant type="Role" id="595410fc-2f24-4708-bacd-0eb38b17e7fc" name="人事经理" code="hrmanager" outerId="3" />
    <Participant type="Role" id="c9694802-fcb1-4cad-ad9e-aae9894305a6" name="总经理" code="generalmanager" outerId="8" />
    <Participant type="Role" id="db7031ac-c0b4-4691-d6e0-195e66be6fe1" name="财务经理" code="finacemanager" outerId="14" />
  </Participants>
  <WorkflowProcesses>
    <Process name="办公用品申领流程" id="3a8ce214-fd18-4fac-95c0-e7958bc1b2f8">
      <Activities>
        <Activity name="开始" id="e52d0836-9f98-4b70-d485-6b01b8cc277e" code="">
          <ActivityType type="StartNode" />
          <Geography>
            <Widget left="92" top="147" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="结束" id="30929bbb-c76e-4604-c956-f26feb4aa22e" code="">
          <ActivityType type="EndNode" />
          <Geography>
            <Widget left="838" top="153" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="仓库签字" id="4db4a153-c8fc-45df-b067-9d188ae19a41" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="114e7e8d-574c-42c2-eb1c-3d7160516ba3" />
          </Performers>
          <Geography>
            <Widget left="245" top="146" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="Gateway" id="eb492ba8-075a-46e4-b95f-ac071dd3a43d" code="">
          <ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" />
          <Geography>
            <Widget left="414" top="147" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="行政部签字" id="c3cbb3cc-fa60-42ad-9a10-4ec2638aff49" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="595410fc-2f24-4708-bacd-0eb38b17e7fc" />
          </Performers>
          <Geography>
            <Widget left="553" top="26" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="总经理签字" id="12c6c0d2-1d23-4ed1-8d58-ddc4268f3149" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="c9694802-fcb1-4cad-ad9e-aae9894305a6" />
          </Performers>
          <Geography>
            <Widget left="544" top="296" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="财务签字" id="9414c43c-0c8c-4c0b-b65d-16203288c7ca" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="db7031ac-c0b4-4691-d6e0-195e66be6fe1" />
          </Performers>
          <Geography>
            <Widget left="555" top="151" width="67.2" height="27.2" />
          </Geography>
        </Activity>
      </Activities>
      <Transitions>
        <Transition id="81fdf756-ecd5-43c0-e2b3-25770aab5dee" from="e52d0836-9f98-4b70-d485-6b01b8cc277e" to="4db4a153-c8fc-45df-b067-9d188ae19a41">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTe52d0836-9f98-4b70-d485-6b01b8cc277e" targetId="ACT4db4a153-c8fc-45df-b067-9d188ae19a41" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="69c1ba54-acb0-4b4e-ff03-3f6cf572e98a" from="4db4a153-c8fc-45df-b067-9d188ae19a41" to="eb492ba8-075a-46e4-b95f-ac071dd3a43d">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT4db4a153-c8fc-45df-b067-9d188ae19a41" targetId="ACTeb492ba8-075a-46e4-b95f-ac071dd3a43d" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="8d776249-f3c6-4397-817f-44880b34a451" from="eb492ba8-075a-46e4-b95f-ac071dd3a43d" to="c3cbb3cc-fa60-42ad-9a10-4ec2638aff49">
          <Description>正常</Description>
          <Receiver />
          <Condition type="Expression">
            <ConditionText><![CDATA[surplus = "normal"]]></ConditionText>
          </Condition>
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTeb492ba8-075a-46e4-b95f-ac071dd3a43d" targetId="ACTc3cbb3cc-fa60-42ad-9a10-4ec2638aff49" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="e40270aa-834a-455d-ffd6-b3f72feeeadc" from="eb492ba8-075a-46e4-b95f-ac071dd3a43d" to="12c6c0d2-1d23-4ed1-8d58-ddc4268f3149">
          <Description>超量</Description>
          <Receiver />
          <Condition type="Expression">
            <ConditionText><![CDATA[surplus = "overamount"]]></ConditionText>
          </Condition>
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTeb492ba8-075a-46e4-b95f-ac071dd3a43d" targetId="ACT12c6c0d2-1d23-4ed1-8d58-ddc4268f3149" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="952b3594-fe40-427f-a27a-f2650226aeca" from="c3cbb3cc-fa60-42ad-9a10-4ec2638aff49" to="30929bbb-c76e-4604-c956-f26feb4aa22e">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTc3cbb3cc-fa60-42ad-9a10-4ec2638aff49" targetId="ACT30929bbb-c76e-4604-c956-f26feb4aa22e" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="fd39de26-d9e9-425e-c952-dd8c37d329d6" from="12c6c0d2-1d23-4ed1-8d58-ddc4268f3149" to="30929bbb-c76e-4604-c956-f26feb4aa22e">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT12c6c0d2-1d23-4ed1-8d58-ddc4268f3149" targetId="ACT30929bbb-c76e-4604-c956-f26feb4aa22e" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="6af8936c-a467-470a-f389-d0a3dcc3739b" from="eb492ba8-075a-46e4-b95f-ac071dd3a43d" to="9414c43c-0c8c-4c0b-b65d-16203288c7ca">
          <Description>正常</Description>
          <Receiver />
          <Condition type="Expression">
            <ConditionText><![CDATA[surplus = "normal"]]></ConditionText>
          </Condition>
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTeb492ba8-075a-46e4-b95f-ac071dd3a43d" targetId="ACT9414c43c-0c8c-4c0b-b65d-16203288c7ca" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="ec4b9497-c187-40a0-af21-1bc3401eb2cf" from="9414c43c-0c8c-4c0b-b65d-16203288c7ca" to="30929bbb-c76e-4604-c956-f26feb4aa22e">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT9414c43c-0c8c-4c0b-b65d-16203288c7ca" targetId="ACT30929bbb-c76e-4604-c956-f26feb4aa22e" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
      </Transitions>
    </Process>
  </WorkflowProcesses>
</Package>', N'', CAST(0x0000A60100F7C975 AS DateTime), CAST(0x0000A74400E090A9 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (104, N'b2a18777-43f1-4d4d-b9d5-f92aa655a93f', N'Ask for leave', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8" ?>
<Package>
  <Participants>
    <Participant type="Role" id="c3057cbe-72fb-46d5-f8d1-bedbc41ee5c4" name="testrole" code="testcode" outerId="21" />
    <Participant type="Role" id="565f2976-3dee-4796-9dbd-e7691705bfd6" name="部门经理" code="depmanager" outerId="2" />
    <Participant type="Role" id="075d956b-fbaa-41da-8b2a-be24e7df7b2c" name="人事经理" code="hrmanager" outerId="3" />
  </Participants>
  <WorkflowProcesses>
    <Process name="Ask for leave" id="b2a18777-43f1-4d4d-b9d5-f92aa655a93f">
      <Activities>
        <Activity name="Start" id="849b95d4-6461-402a-f9f1-f443ced9b31a" code="">
          <ActivityType type="StartNode" />
          <Geography>
            <Widget left="171" top="138" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="End" id="73a34903-b489-4dd5-9b28-a074a32f844b" code="">
          <ActivityType type="EndNode" />
          <Geography>
            <Widget left="818" top="142" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="Submit Request" id="b8d61c50-edfa-4edc-e890-7f0e84afa521" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="c3057cbe-72fb-46d5-f8d1-bedbc41ee5c4" />
          </Performers>
          <Geography>
            <Widget left="312" top="138" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="" id="0b41c280-b2dd-47eb-a074-73d56cb83e5b" code="">
          <ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" />
          <Geography>
            <Widget left="498" top="138" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="Dept Manager Approve" id="6bd98004-cd04-4f3a-bf21-ca232dcd0533" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="565f2976-3dee-4796-9dbd-e7691705bfd6" />
          </Performers>
          <Geography>
            <Widget left="632" top="65" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="HR Manager Approve" id="6dbedb92-b128-4ae7-a9c8-3d8826d4c481" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="075d956b-fbaa-41da-8b2a-be24e7df7b2c" />
          </Performers>
          <Geography>
            <Widget left="633" top="203" width="67.2" height="27.2" />
          </Geography>
        </Activity>
      </Activities>
      <Transitions>
        <Transition id="7529e098-6a9f-4755-8d2a-12e69dc46068" from="849b95d4-6461-402a-f9f1-f443ced9b31a" to="b8d61c50-edfa-4edc-e890-7f0e84afa521">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT849b95d4-6461-402a-f9f1-f443ced9b31a" targetId="ACTb8d61c50-edfa-4edc-e890-7f0e84afa521" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="8050dd82-3a34-42c7-a994-15a3fe9b4a2d" from="b8d61c50-edfa-4edc-e890-7f0e84afa521" to="0b41c280-b2dd-47eb-a074-73d56cb83e5b">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTb8d61c50-edfa-4edc-e890-7f0e84afa521" targetId="ACT0b41c280-b2dd-47eb-a074-73d56cb83e5b" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="09abe631-68b9-4cfb-f3e9-d43692817c14" from="0b41c280-b2dd-47eb-a074-73d56cb83e5b" to="6bd98004-cd04-4f3a-bf21-ca232dcd0533">
          <Description>days &lt;= 3</Description>
          <Receiver type="Superior" />
          <Condition type="Expression">
            <ConditionText><![CDATA[days <= 3]]></ConditionText>
          </Condition>
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT0b41c280-b2dd-47eb-a074-73d56cb83e5b" targetId="ACT6bd98004-cd04-4f3a-bf21-ca232dcd0533" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="33be7303-e246-48a1-ba83-ac038f1a06f5" from="0b41c280-b2dd-47eb-a074-73d56cb83e5b" to="6dbedb92-b128-4ae7-a9c8-3d8826d4c481">
          <Description>days &gt; 3</Description>
          <Receiver />
          <Condition type="Expression">
            <ConditionText><![CDATA[days > 3]]></ConditionText>
          </Condition>
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT0b41c280-b2dd-47eb-a074-73d56cb83e5b" targetId="ACT6dbedb92-b128-4ae7-a9c8-3d8826d4c481" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="c7dc0035-5230-4b38-e625-506ea9cfb117" from="6bd98004-cd04-4f3a-bf21-ca232dcd0533" to="73a34903-b489-4dd5-9b28-a074a32f844b">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT6bd98004-cd04-4f3a-bf21-ca232dcd0533" targetId="ACT73a34903-b489-4dd5-9b28-a074a32f844b" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="7dcd8bc6-99d9-4081-fdc6-f94c36f01907" from="6dbedb92-b128-4ae7-a9c8-3d8826d4c481" to="73a34903-b489-4dd5-9b28-a074a32f844b">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT6dbedb92-b128-4ae7-a9c8-3d8826d4c481" targetId="ACT73a34903-b489-4dd5-9b28-a074a32f844b" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
      </Transitions>
    </Process>
  </WorkflowProcesses>
</Package>', N'', CAST(0x0000A6EC00F3F9FB AS DateTime), CAST(0x0000A73201303812 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (109, N'1bc22da3-47e3-4a0a-be81-6d7297ad3aca', N'报价加签(SignForwardTest)', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8" ?>
<Package>
  <Participants>
    <Participant type="Role" id="28e71769-f197-4fe0-fd9f-63474956dc60" name="业务员(Sales)" code="salesmate" outerId="9" />
    <Participant type="Role" id="24b1a282-d4d4-4461-febb-2f28eb31f48f" name="打样员(Tech)" code="techmate" outerId="10" />
  </Participants>
  <WorkflowProcesses>
    <Process name="报价会签流程" id="1bc22da3-47e3-4a0a-be81-6d7297ad3aca">
      <Activities>
        <Activity name="开始" id="1f303f19-71aa-4879-c501-f4d0f448f0a2" code="">
          <ActivityType type="StartNode" />
          <Geography>
            <Widget left="165" top="120" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="结束" id="7462aae9-da1c-43f0-d741-a4586879de77" code="">
          <ActivityType type="EndNode" />
          <Geography>
            <Widget left="768" top="124" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="业务员提交" id="791d9d3a-882d-4796-cffc-84d9fca76afd" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="28e71769-f197-4fe0-fd9f-63474956dc60" />
          </Performers>
          <Geography>
            <Widget left="303" top="121" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="业务员确认" id="23017d0c-08ca-4a59-9649-c6912b819001" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="28e71769-f197-4fe0-fd9f-63474956dc60" />
          </Performers>
          <Geography>
            <Widget left="621" top="123" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="板房加签" id="36cf2479-e8ec-4936-8bcd-b38101e4664a" code="">
          <ActivityType type="MultipleInstanceNode" complexType="SignForward" mergeType="Parallel" compareType="Percentage" completeOrder="60" />
          <Performers>
            <Performer id="24b1a282-d4d4-4461-febb-2f28eb31f48f" />
          </Performers>
          <Geography>
            <Widget left="472" top="119" width="67.2" height="27.2" />
          </Geography>
        </Activity>
      </Activities>
      <Transitions>
        <Transition id="50f7acb2-99d0-4877-e116-5bf19433bb89" from="1f303f19-71aa-4879-c501-f4d0f448f0a2" to="791d9d3a-882d-4796-cffc-84d9fca76afd">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT1f303f19-71aa-4879-c501-f4d0f448f0a2" targetId="ACT791d9d3a-882d-4796-cffc-84d9fca76afd" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="87651a0d-81e5-4d6f-9ef3-ed0be0011c8f" from="791d9d3a-882d-4796-cffc-84d9fca76afd" to="36cf2479-e8ec-4936-8bcd-b38101e4664a">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT791d9d3a-882d-4796-cffc-84d9fca76afd" targetId="ACT36cf2479-e8ec-4936-8bcd-b38101e4664a" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="63031ecf-2116-47a3-a0d8-f920dc5bee11" from="36cf2479-e8ec-4936-8bcd-b38101e4664a" to="23017d0c-08ca-4a59-9649-c6912b819001">
          <Receiver />
          <Condition type="Expression" />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT36cf2479-e8ec-4936-8bcd-b38101e4664a" targetId="ACT23017d0c-08ca-4a59-9649-c6912b819001" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="3d06aebb-2fb3-4995-e0c7-99d488f8312d" from="23017d0c-08ca-4a59-9649-c6912b819001" to="7462aae9-da1c-43f0-d741-a4586879de77">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT23017d0c-08ca-4a59-9649-c6912b819001" targetId="ACT7462aae9-da1c-43f0-d741-a4586879de77" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
      </Transitions>
    </Process>
  </WorkflowProcesses>
</Package>', N'', CAST(0x0000A73500B6998A AS DateTime), CAST(0x0000A73500EEF5B6 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (120, N'b4fe856b-9cf6-4a8e-af4e-b897ad00fc63', N'维养计划审批', N'1', 1, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8" ?>
<Package>
  <Participants>
    <Participant type="Role" id="559afb98-a1d0-4d6c-af32-5fedd132db6b" name="科长级（村级负责岗）" code="300" outerId="300" />
    <Participant type="Role" id="7080f30f-ebfb-47ed-e5a2-0fd27cffbf70" name="分管领导（乡镇级）" code="200" outerId="200" />
    <Participant type="Role" id="1110a011-147a-43f5-a5fa-b1e2a6b67a86" name="局长级（县级负责岗）" code="100" outerId="100" />
  </Participants>
  <WorkflowProcesses>
    <Process name="维养计划审批" id="b4fe856b-9cf6-4a8e-af4e-b897ad00fc63">
      <Activities>
        <Activity name="开始" id="eb87bf37-8280-4d99-ee9e-617399fcc813" code="">
          <ActivityType type="StartNode" />
          <Geography>
            <Widget left="50" top="76" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="部门（村）提交审批" id="d70a473f-1a46-464d-94f7-691cb22661c0" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="559afb98-a1d0-4d6c-af32-5fedd132db6b" />
          </Performers>
          <Geography>
            <Widget left="182" top="76" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="分管领导（乡）初审" id="7c3ee03e-91ca-4e84-ebc3-f705b7db7724" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="7080f30f-ebfb-47ed-e5a2-0fd27cffbf70" />
          </Performers>
          <Geography>
            <Widget left="344" top="76" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="" id="995d69bc-2793-4ebb-a417-2fa508803452" code="">
          <ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" />
          <Geography>
            <Widget left="532" top="227" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="单位负责人（县）审批" id="7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb" code="">
          <ActivityType type="TaskNode" />
          <Performers>
            <Performer id="1110a011-147a-43f5-a5fa-b1e2a6b67a86" />
          </Performers>
          <Geography>
            <Widget left="683" top="228" width="67.2" height="27.2" />
          </Geography>
        </Activity>
        <Activity name="" id="a36ae24f-d74b-4d5b-cb5c-87566213ec5e" code="">
          <ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" />
          <Geography>
            <Widget left="787" top="20" width="38" height="38" />
          </Geography>
        </Activity>
        <Activity name="结束" id="05845a9d-536f-4be2-db7c-d82282f13b45" code="">
          <ActivityType type="EndNode" />
          <Geography>
            <Widget left="964" top="20" width="38" height="38" />
          </Geography>
        </Activity>
      </Activities>
      <Transitions>
        <Transition id="9ad0a94c-302f-496d-ceca-fa1638b84e12" from="eb87bf37-8280-4d99-ee9e-617399fcc813" to="d70a473f-1a46-464d-94f7-691cb22661c0">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTeb87bf37-8280-4d99-ee9e-617399fcc813" targetId="ACTd70a473f-1a46-464d-94f7-691cb22661c0" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="947680d4-fffc-419c-9175-583920ed92d2" from="d70a473f-1a46-464d-94f7-691cb22661c0" to="7c3ee03e-91ca-4e84-ebc3-f705b7db7724">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTd70a473f-1a46-464d-94f7-691cb22661c0" targetId="ACT7c3ee03e-91ca-4e84-ebc3-f705b7db7724" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="e8be4c2d-d104-41ae-eb6a-7952d005995b" from="7c3ee03e-91ca-4e84-ebc3-f705b7db7724" to="995d69bc-2793-4ebb-a417-2fa508803452">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT7c3ee03e-91ca-4e84-ebc3-f705b7db7724" targetId="ACT995d69bc-2793-4ebb-a417-2fa508803452" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="2fc94cd1-2e10-457f-f670-639a551b6aff" from="995d69bc-2793-4ebb-a417-2fa508803452" to="7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb">
          <Description>审批通过</Description>
          <Receiver />
          <Condition type="Expression">
            <ConditionText><![CDATA[xtype=="通过"  ||   xtype=="同意"]]></ConditionText>
          </Condition>
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT995d69bc-2793-4ebb-a417-2fa508803452" targetId="ACT7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="fd9ebf90-ad90-419b-f0b8-b15615114269" from="7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb" to="a36ae24f-d74b-4d5b-cb5c-87566213ec5e">
          <Receiver />
          <Condition />
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb" targetId="ACTa36ae24f-d74b-4d5b-cb5c-87566213ec5e" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="6b5194f2-57ee-4f11-87de-e8d29be3009e" from="a36ae24f-d74b-4d5b-cb5c-87566213ec5e" to="05845a9d-536f-4be2-db7c-d82282f13b45">
          <Description>审批通过</Description>
          <Receiver />
          <Condition type="Expression">
            <ConditionText><![CDATA[xtype=="通过"  ||  xtype=="同意"]]></ConditionText>
          </Condition>
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTa36ae24f-d74b-4d5b-cb5c-87566213ec5e" targetId="ACT05845a9d-536f-4be2-db7c-d82282f13b45" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="cfa49cfe-067c-49a4-90ca-bc8bcec1fc9c" from="995d69bc-2793-4ebb-a417-2fa508803452" to="7c3ee03e-91ca-4e84-ebc3-f705b7db7724">
          <Description>审批不通过</Description>
          <Receiver />
          <Condition type="Expression">
            <ConditionText><![CDATA[xtype=="不通过"  || xtype=="不同意"  ||  xtype=="退回"]]></ConditionText>
          </Condition>
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACT995d69bc-2793-4ebb-a417-2fa508803452" targetId="ACT7c3ee03e-91ca-4e84-ebc3-f705b7db7724" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
        <Transition id="aa210284-a1f7-4e96-a623-2289aeca6d83" from="a36ae24f-d74b-4d5b-cb5c-87566213ec5e" to="7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb">
          <Description>审批不通过</Description>
          <Receiver />
          <Condition type="Expression">
            <ConditionText><![CDATA[xtype=="不通过"  ||  xtype=="不同意"  || xtype=="退回"]]></ConditionText>
          </Condition>
          <Geography>
            <Line anchors="[[1,0.5,1,0,0,0],[0,0.5,-1,0,0,0]]" sourceId="ACTa36ae24f-d74b-4d5b-cb5c-87566213ec5e" targetId="ACT7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb" fromConnector="1" toConnector="1" />
          </Geography>
        </Transition>
      </Transitions>
    </Process>
  </WorkflowProcesses>
</Package>', NULL, CAST(0x0000A74D01168A9C AS DateTime), CAST(0x0000A75100EC2525 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (173, N'7cc65e86-443f-42b9-87b0-3b8beb8866a1', N'k490', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?> <Package><Participants><Participant type="Role" id="6c606900-3da1-40ae-de68-baeed8eb18e4" name="testrole" code="testcode" outerId="21"/><Participant type="Role" id="cb272dd9-2d3a-4658-a2b5-a83867cfcb7b" name="财务经理" code="finacemanager" outerId="14"/><Participant type="Role" id="2d743488-5612-49b2-83fb-260503947cf6" name="打样员(Tech)" code="techmate" outerId="10"/></Participants><WorkflowProcesses><Process name="k490" id="7cc65e86-443f-42b9-87b0-3b8beb8866a1"><Description>null</Description><Activities><Activity id="1c5075f5-6718-43fa-e600-76c15a506778" name="开始" code=""><Description></Description><ActivityType type="StartNode"/><Geography parent="882761c9-dda5-4557-96c0-190f3597315b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="178" top="144" width="32" height="32"/></Geography></Activity><Activity id="822b2829-7aad-4547-9c93-e7c4922c1ee2" name="Task" code=""><Description></Description><ActivityType type="TaskNode"/><Performers><Performer id="6c606900-3da1-40ae-de68-baeed8eb18e4"/><Performer id="cb272dd9-2d3a-4658-a2b5-a83867cfcb7b"/></Performers><Actions><Action type="ExternalMethod" name="name" assembly="assembly" interface="interface" method="method"/></Actions><Geography parent="882761c9-dda5-4557-96c0-190f3597315b" style="undefined"><Widget left="300" top="160" width="72" height="32"/></Geography></Activity><Activity id="dcc03b32-f3ca-48f2-b4b4-268d52b7e76e" name="gateway-split" code=""><Description></Description><ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit"/><Actions><Action type="null" name="null" assembly="null" interface="null" method="null"/></Actions><Geography parent="882761c9-dda5-4557-96c0-190f3597315b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png"><Widget left="440" top="160" width="72" height="32"/></Geography></Activity><Activity id="273de495-7ed8-4f20-d0d4-2190f16e7e08" name="Task" code=""><Description></Description><ActivityType type="TaskNode"/><Performers><Performer id="6c606900-3da1-40ae-de68-baeed8eb18e4"/><Performer id="2d743488-5612-49b2-83fb-260503947cf6"/></Performers><Actions><Action type="ExternalMethod" name="" assembly="" interface="" method=""/></Actions><Geography parent="882761c9-dda5-4557-96c0-190f3597315b" style="undefined"><Widget left="560" top="120" width="72" height="32"/></Geography></Activity><Activity id="9c0e71ce-0d5d-4e3f-c08a-af1978e577c4" name="Subprocess" code=""><Description></Description><ActivityType type="SubProcessNode" subId="1bc22da3-47e3-4a0a-be81-6d7297ad3aca"/><Actions><Action type="null" name="null" assembly="null" interface="null" method="null"/></Actions><Geography parent="882761c9-dda5-4557-96c0-190f3597315b" style="rounded"><Widget left="590" top="220" width="72" height="32"/></Geography></Activity></Activities><Transitions><Transition id="b14d02b4-16ad-4add-caaf-50869369e135" from="1c5075f5-6718-43fa-e600-76c15a506778" to="822b2829-7aad-4547-9c93-e7c4922c1ee2"><Description></Description><Receiver/><Condition type="null"><ConditionText></ConditionText></Condition><Geography parent="882761c9-dda5-4557-96c0-190f3597315b" style="undefined"/></Transition><Transition id="abb7e533-6d83-469f-de6f-ea312f3a3d49" from="822b2829-7aad-4547-9c93-e7c4922c1ee2" to="dcc03b32-f3ca-48f2-b4b4-268d52b7e76e"><Description></Description><Receiver/><Condition type="null"><ConditionText></ConditionText></Condition><Geography parent="882761c9-dda5-4557-96c0-190f3597315b" style="undefined"/></Transition><Transition id="7e6ea7cb-8426-4bb2-f884-40554c61d075" from="dcc03b32-f3ca-48f2-b4b4-268d52b7e76e" to="273de495-7ed8-4f20-d0d4-2190f16e7e08"><Description></Description><Receiver type="Compeer"/><Condition type="Expression"><ConditionText>days&gt;3</ConditionText></Condition><Geography parent="882761c9-dda5-4557-96c0-190f3597315b" style="undefined"/></Transition><Transition id="2e7159d5-19c4-47c0-f775-f1f4e7adcd86" from="dcc03b32-f3ca-48f2-b4b4-268d52b7e76e" to="9c0e71ce-0d5d-4e3f-c08a-af1978e577c4"><Description></Description><Receiver type="Superior"/><Condition type="Expression"><ConditionText>days&lt;=3</ConditionText></Condition><Geography parent="882761c9-dda5-4557-96c0-190f3597315b" style="undefined"/></Transition></Transitions></Process></WorkflowProcesses><Layout><Swimlanes/></Layout></Package>', N'', CAST(0x0000A79F0101DD30 AS DateTime), CAST(0x0000A7A000F85E89 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (179, N'52420e12-d07a-485d-9ca0-0105b84f1e33', N'test40000', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?> <Package><Participants/><WorkflowProcesses><Process name="test40000" id="52420e12-d07a-485d-9ca0-0105b84f1e33"><Description>null</Description><Activities><Activity id="9911ae51-74eb-4a1a-8ad0-87a1e7faf18d" name="结束" code=""><Description></Description><ActivityType type="EndNode"/><Geography parent="c972cd90-6af6-420d-99f8-410a2fe01776" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="550" top="270" width="38" height="38"/></Geography></Activity><Activity id="7d741966-6459-4fdf-8748-f1dd97f0ceee" name="Task" code=""><Description></Description><ActivityType type="TaskNode"/><Geography parent="c972cd90-6af6-420d-99f8-410a2fe01776" style="undefined"><Widget left="360" top="238" width="72" height="32"/></Geography></Activity></Activities><Transitions><Transition id="a8e9ec97-96c9-46a8-8d9c-fb60f0b6c1b3" from="7d741966-6459-4fdf-8748-f1dd97f0ceee" to="9911ae51-74eb-4a1a-8ad0-87a1e7faf18d"><Description></Description><Receiver/><Condition type="null"><ConditionText></ConditionText></Condition><Geography parent="c972cd90-6af6-420d-99f8-410a2fe01776" style="undefined"/></Transition></Transitions></Process></WorkflowProcesses><Layout><Swimlanes/></Layout></Package>', N'', CAST(0x0000A7A00156D6C7 AS DateTime), CAST(0x0000A7A600B3073A AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (180, N'524d1922-4c27-47b8-ade6-bcb6a7234d11', N'test22222', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?> <Package><Participants/><WorkflowProcesses><Process name="test22222" id="524d1922-4c27-47b8-ade6-bcb6a7234d11"><Description></Description><Activities><Activity id="2bfd861e-c69a-4f6b-b68a-99f91e89df81" name="Task" code=""><Description></Description><ActivityType type="TaskNode"/><Geography parent="95d7a324-b560-4371-fb5c-a31582298647" style="undefined"><Widget left="290" top="220" width="72" height="32"/></Geography></Activity><Activity id="a1ca9073-705d-4509-e50e-a0a2399fc89c" name="Subprocess" code=""><Description></Description><ActivityType type="SubProcessNode" subId=""/><Geography parent="95d7a324-b560-4371-fb5c-a31582298647" style="rounded"><Widget left="470" top="250" width="72" height="32"/></Geography></Activity><Activity id="fc5c5f80-6975-49c2-d387-74c3484e14f6" name="开始" code=""><Description></Description><ActivityType type="StartNode"/><Geography parent="95d7a324-b560-4371-fb5c-a31582298647" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="130" top="220" width="32" height="32"/></Geography></Activity></Activities><Transitions><Transition id="10789984-fca2-4e91-f162-1acb159dced6" from="2bfd861e-c69a-4f6b-b68a-99f91e89df81" to="a1ca9073-705d-4509-e50e-a0a2399fc89c"><Description></Description><Receiver/><Condition/><Geography parent="95d7a324-b560-4371-fb5c-a31582298647" style="null"/></Transition><Transition id="0b639ed5-7a00-424f-a801-41c71071bbe5" from="fc5c5f80-6975-49c2-d387-74c3484e14f6" to="2bfd861e-c69a-4f6b-b68a-99f91e89df81"><Description></Description><Receiver/><Condition/><Geography parent="95d7a324-b560-4371-fb5c-a31582298647" style="null"/></Transition></Transitions></Process></WorkflowProcesses><Layout><Swimlanes/></Layout></Package>', N'', CAST(0x0000A7A600C35B23 AS DateTime), CAST(0x0000A7A600C37865 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (181, N'cea4987e-e25a-4a3f-a4b5-fb9894d21cfb', N'test5000', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?> <Package><Participants/><WorkflowProcesses><Process name="test5000" id="cea4987e-e25a-4a3f-a4b5-fb9894d21cfb"><Description></Description><Activities><Activity id="9e7d8ce6-1b7c-4555-995e-1c4e43dc82a6" name="Task" code=""><Description></Description><ActivityType type="TaskNode"/><Geography parent="2100d6af-ac05-41bd-8beb-0dc7aabba91f" style="undefined"><Widget left="70" top="170" width="72" height="32"/></Geography></Activity><Activity id="80c67e6b-6d08-4bce-937f-d0ea62d9d9ab" name="Subprocess" code=""><Description></Description><ActivityType type="SubProcessNode" subId=""/><Geography parent="2100d6af-ac05-41bd-8beb-0dc7aabba91f" style="rounded"><Widget left="260" top="170" width="72" height="32"/></Geography></Activity></Activities><Transitions><Transition id="9b7f8d40-848f-4dd2-f0d6-52e19c460c4d" from="9e7d8ce6-1b7c-4555-995e-1c4e43dc82a6" to="80c67e6b-6d08-4bce-937f-d0ea62d9d9ab"><Description></Description><Receiver/><Condition/><Geography parent="2100d6af-ac05-41bd-8beb-0dc7aabba91f" style="null"/></Transition></Transitions></Process></WorkflowProcesses><Layout><Swimlanes/></Layout></Package>', N'', CAST(0x0000A7A600C44335 AS DateTime), CAST(0x0000A7A600C45733 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (182, N'604511e4-efce-4f2d-9b28-29d5eda144cd', N'test40000', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="test40000" id="604511e4-efce-4f2d-9b28-29d5eda144cd">
			<Description>null</Description>
			<Activities>
				<Activity id="0c5ed813-ac9a-4e8a-cdae-fa02935be679" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode"/>
					<Geography parent="82fd0fa9-7505-49d6-a4b3-7162fddda747" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="320" top="340" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="184562ee-dc5e-4df9-a29d-689d98e18688" name="Task" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="82fd0fa9-7505-49d6-a4b3-7162fddda747" style="undefined">
						<Widget left="480" top="350" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e0252134-94bf-46f7-f7e7-370c69d87b75" name="gateway-split" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection=""/>
					<Geography parent="82fd0fa9-7505-49d6-a4b3-7162fddda747" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="630" top="350" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="617d43f9-5075-490e-d5b5-2700ab273b4c" name="Task" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="82fd0fa9-7505-49d6-a4b3-7162fddda747" style="undefined">
						<Widget left="780" top="300" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="27c21240-ae05-4031-d8b6-b5096a653d0d" from="0c5ed813-ac9a-4e8a-cdae-fa02935be679" to="184562ee-dc5e-4df9-a29d-689d98e18688">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="82fd0fa9-7505-49d6-a4b3-7162fddda747" style="undefined"/>
				</Transition>
				<Transition id="ba61dbe0-4e75-4b2e-a323-836e3936cb3b" from="e0252134-94bf-46f7-f7e7-370c69d87b75" to="617d43f9-5075-490e-d5b5-2700ab273b4c">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days >= 3]]>
						</ConditionText>
					</Condition>
					<Geography parent="82fd0fa9-7505-49d6-a4b3-7162fddda747" style="undefined"/>
				</Transition>
				<Transition id="56bfabf1-9203-4640-fdac-b4551423a3d3" from="184562ee-dc5e-4df9-a29d-689d98e18688" to="e0252134-94bf-46f7-f7e7-370c69d87b75">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="82fd0fa9-7505-49d6-a4b3-7162fddda747" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'dasf', CAST(0x0000A7AF011D3A89 AS DateTime), CAST(0x0000A7AF01444155 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (183, N'1e9dc19d-e97d-4657-93e2-733677349276', N'test1000', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="74a49eb6-200e-40d5-c161-a94ea7df9e70" name="testrole" code="testcode" outerId="21"/>
		<Participant type="Role" id="8b32d2ba-2c40-4e62-ee0f-5b54f467d306" name="部门经理" code="depmanager" outerId="2"/>
		<Participant type="Role" id="e2518d0c-de00-44eb-a717-118e7be6c05f" name="打样员(Tech)" code="techmate" outerId="10"/>
		<Participant type="Role" id="dfff9d1f-4e1b-42c1-ee8d-bab440aaa94c" name="包装员(Express)" code="expressmate" outerId="13"/>
		<Participant type="Role" id="5191ef61-16dc-4ef0-f9f6-e698a12f8c62" name="财务经理" code="finacemanager" outerId="14"/>
		<Participant type="Role" id="85521a9c-b9d7-4269-a623-5b483232b3a7" name="跟单员(Made)" code="merchandiser" outerId="11"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="test1000" id="1e9dc19d-e97d-4657-93e2-733677349276">
			<Description>null</Description>
			<Activities>
				<Activity id="14861d02-e0f4-4bf6-f5f6-6332100d6e91" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode"/>
					<Geography parent="8f85abe8-73a7-4129-def0-c60c94ca31c6" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="250" top="170" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="288a2103-7f48-4fbd-c6b3-59c8ed82bcf6" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode"/>
					<Geography parent="8f85abe8-73a7-4129-def0-c60c94ca31c6" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="580" top="200" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="582a23e0-8da2-488f-fb6c-88223c325194" name="Task" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="74a49eb6-200e-40d5-c161-a94ea7df9e70"/>
						<Performer id="e2518d0c-de00-44eb-a717-118e7be6c05f"/>
						<Performer id="85521a9c-b9d7-4269-a623-5b483232b3a7"/>
						<Performer id="5191ef61-16dc-4ef0-f9f6-e698a12f8c62"/>
					</Performers>
					<Geography parent="8f85abe8-73a7-4129-def0-c60c94ca31c6" style="undefined">
						<Widget left="350" top="180" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="821a5d87-3391-4527-fbb0-79bbf3e05c1c" from="14861d02-e0f4-4bf6-f5f6-6332100d6e91" to="582a23e0-8da2-488f-fb6c-88223c325194">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8f85abe8-73a7-4129-def0-c60c94ca31c6" style="undefined"/>
				</Transition>
				<Transition id="7bcd8fbb-f98e-4b65-9d5d-bf15a4eecb05" from="582a23e0-8da2-488f-fb6c-88223c325194" to="288a2103-7f48-4fbd-c6b3-59c8ed82bcf6">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[a > 3]]>
						</ConditionText>
					</Condition>
					<Geography parent="8f85abe8-73a7-4129-def0-c60c94ca31c6" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'', CAST(0x0000A7B7007D7321 AS DateTime), CAST(0x0000A7BB00B26679 AS DateTime))
SET IDENTITY_INSERT [dbo].[WfProcess] OFF
/****** Object:  Table [dbo].[WfLog]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WfLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EventTypeID] [int] NOT NULL,
	[Priority] [int] NOT NULL,
	[Severity] [nvarchar](50) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Message] [nvarchar](500) NULL,
	[StackTrace] [nvarchar](4000) NULL,
	[InnerStackTrace] [nvarchar](4000) NULL,
	[RequestData] [nvarchar](2000) NULL,
	[Timestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[WfLog] ON
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (430, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"14","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7AE00996FE8 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (431, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"14","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7AE0099703D AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (432, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"15","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7AE0099A5C1 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (433, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"15","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7AE0099A5C1 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (434, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"16","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008AFCAC AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (435, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"16","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008AFCDA AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (436, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"17","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008B97D1 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (437, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"17","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008B97D1 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (438, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"18","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008C6599 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (439, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"18","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008C6599 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (440, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"19","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008C7725 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (441, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"19","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008C7725 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (442, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"20","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008CE308 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (443, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"20","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008CE308 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (444, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"21","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008D9642 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (445, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"21","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008D9642 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (446, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"22","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008E76DB AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (447, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"22","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008E76DB AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (448, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"23","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008E8F00 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (449, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"23","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008E8F00 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (450, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"24","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008EB7AA AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (451, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"24","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008EB7AA AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (452, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"25","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008F3EB9 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (453, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"25","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008F3EBA AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (454, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"26","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008F48AA AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (455, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"26","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008F48AA AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (456, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"27","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008F71C5 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (457, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"27","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008F71C5 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (458, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"28","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008FC6B9 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (459, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"28","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8008FC6B9 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (460, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"29","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8009129AF AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (461, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"29","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B8009129AF AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (462, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"30","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B800955883 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (463, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"30","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B800955883 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (464, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 112', NULL, N'{"AppName":"请假流程","AppInstanceID":"31","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B800960156 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (465, 2, 1, N'HIGH', N'流程流转异常', N'列名 ''IsDeliveried'' 无效。', N'   在 System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   在 System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   在 System.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)
   在 System.Data.SqlClient.SqlDataReader.TryConsumeMetaData()
   在 System.Data.SqlClient.SqlDataReader.get_MetaData()
   在 System.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReaderTds(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, Boolean async, Int32 timeout, Task& task, Boolean asyncWrite, SqlDataReader ds, Boolean describeParameterEncryptionRequest)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method, TaskCompletionSource`1 completion, Int32 timeout, Task& task, Boolean asyncWrite)
   在 System.Data.SqlClient.SqlCommand.RunExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream, String method)
   在 System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior, String method)
   在 Dapper.SqlMapper.<QueryImpl>d__62`1.MoveNext() 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\SqlMapper.cs:行号 1619
   在 System.Collections.Generic.List`1..ctor(IEnumerable`1 collection)
   在 System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)
   在 DapperExtensions.DapperImplementor.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperImplementor.cs:行号 90
   在 DapperExtensions.DapperExtensions.Insert[T](IDbConnection connection, T entity, IDbTransaction transaction, Nullable`1 commandTimeout) 位置 D:\Cloud365\GitHome\Slickflow\Source\Dapper\Extensions\DapperExtensions.cs:行号 159
   在 Slickflow.Data.Repository.Insert[T](IDbConnection conn, T entity, IDbTransaction transaction) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Data\Repository.cs:行号 596
   在 Slickflow.Engine.Business.Manager.ProcessInstanceManager.Insert(IDbConnection conn, ProcessInstanceEntity entity, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Business\Manager\ProcessInstanceManager.cs:行号 234
   在 Slickflow.Engine.Core.Pattern.NodeMediatorStart.ExecuteWorkItem() 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\Pattern\NodeMediatorStart.cs:行号 77
   在 Slickflow.Engine.Core.WfRuntimeManagerStartup.ExecuteInstanceImp(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManagerStartup.cs:行号 70
   在 Slickflow.Engine.Core.WfRuntimeManager.Execute(IDbSession session) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Core\WfRuntimeManager.cs:行号 122
   在 Slickflow.Engine.Service.WorkflowService.StartProcess(IDbConnection conn, WfAppRunner starter, IDbTransaction trans) 位置 D:\Cloud365\GitHome\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 625', NULL, N'{"AppName":"请假流程","AppInstanceID":"31","ProcessGUID":"2acffb20-6bd1-4891-98c9-c76d022d1445","UserID":"6","UserName":"路天明","NextActivityPerformers":{"3242c597-e889-4768-f6db-cafc3d675370":[{"UserID":"6","UserName":"路天明"}]},"Conditions":{"RoleID":"1","days":"2"}}', CAST(0x0000A7B80096016E AS DateTime))
SET IDENTITY_INSERT [dbo].[WfLog] OFF
/****** Object:  Table [dbo].[SysUserResource]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysUserResource](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ResourceID] [int] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysUserResource] ON
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (1, 7, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (2, 7, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (3, 7, 4)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (4, 7, 5)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (5, 8, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (6, 8, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (7, 8, 4)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (8, 8, 5)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (9, 11, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (10, 11, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (11, 11, 6)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (12, 12, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (13, 12, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (14, 12, 6)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (15, 9, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (16, 9, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (17, 9, 7)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (18, 10, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (19, 10, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (20, 10, 7)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (21, 13, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (22, 13, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (23, 13, 8)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (24, 14, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (25, 14, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (26, 14, 8)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (27, 15, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (28, 15, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (29, 15, 9)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (30, 15, 10)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (31, 16, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (32, 16, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (33, 16, 9)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (34, 16, 10)
SET IDENTITY_INSERT [dbo].[SysUserResource] OFF
/****** Object:  Table [dbo].[SysUser]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysUser](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysUser] ON
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (1, N'陈小星')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (2, N'hugfuy')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (3, N'测试')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (4, N'李颖')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (5, N'张恒丰')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (6, N'路天明')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (7, N'陈盖茨')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (8, N'白菲特')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (9, N'张明')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (10, N'李杰')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (11, N'飞羽')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (12, N'雪莉')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (13, N'杰米')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (14, N'旺财')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (15, N'大汉')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (16, N'小威')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (17, N'崔红')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (18, N'金兰')
SET IDENTITY_INSERT [dbo].[SysUser] OFF
/****** Object:  Table [dbo].[SysRoleUser]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysRoleUser](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[UserID] [int] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysRoleUser] ON
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (1, 8, 1)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (2, 7, 2)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (3, 4, 3)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (4, 3, 4)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (5, 2, 5)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (6, 1, 6)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (7, 9, 7)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (8, 9, 8)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (9, 10, 11)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (10, 10, 12)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (11, 11, 9)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (12, 11, 10)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (13, 12, 13)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (14, 12, 14)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (15, 13, 15)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (16, 13, 16)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (17, 14, 17)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (19, 2, 17)
SET IDENTITY_INSERT [dbo].[SysRoleUser] OFF
/****** Object:  Table [dbo].[SysRoleGroupResource]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysRoleGroupResource](
	[ID] [int] NOT NULL,
	[RgType] [smallint] NOT NULL,
	[RgID] [int] NOT NULL,
	[ResourceID] [int] NOT NULL,
	[PermissionType] [smallint] NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (1, 1, 9, 1, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (2, 1, 9, 2, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (3, 1, 9, 4, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (4, 1, 9, 5, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (5, 1, 10, 1, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (6, 1, 10, 2, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (7, 1, 10, 6, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (8, 1, 11, 7, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (9, 1, 12, 8, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (10, 1, 13, 9, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (11, 1, 13, 10, 1)
/****** Object:  Table [dbo].[SysRole]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysRole](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleCode] [varchar](50) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysRole] ON
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (1, N'employees', N'普通员工')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (2, N'depmanager', N'部门经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (3, N'hrmanager', N'人事经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (4, N'director', N'主管总监')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (7, N'deputygeneralmanager', N'副总经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (8, N'generalmanager', N'总经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (9, N'salesmate', N'业务员(Sales)')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (10, N'techmate', N'打样员(Tech)')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (11, N'merchandiser', N'跟单员(Made)')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (12, N'qcmate', N'质检员(QC)')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (13, N'expressmate', N'包装员(Express)')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (14, N'finacemanager', N'财务经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (21, N'testcode', N'testrole')
SET IDENTITY_INSERT [dbo].[SysRole] OFF
/****** Object:  Table [dbo].[SysResource]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysResource](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ResourceType] [smallint] NOT NULL,
	[ParentResourceID] [int] NOT NULL,
	[ResourceName] [nvarchar](50) NOT NULL,
	[ResourceCode] [varchar](100) NOT NULL,
	[OrderNo] [smallint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysResource] ON
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (1, 1, 0, N'生产订单系统', N'SfDemo.Made', 1)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (2, 2, 1, N'生产订单流程', N'SfDemo.Made.POrder', 1)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (4, 5, 2, N'同步订单', N'SfDemo.Made.POrder.SyncOrder', 1)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (5, 5, 2, N'分派订单', N'SfDemo.Made.POrder.Dispatch', 2)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (6, 5, 2, N'打样', N'SfDemo.Made.POrder.Sample', 3)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (7, 5, 2, N'生产', N'SfDemo.Made.POrder.Manufacture', 4)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (8, 5, 2, N'质检', N'SfDemo.Made.POrder.QCCheck', 5)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (9, 5, 2, N'称重', N'SfDemo.Made.POrder.Weight', 6)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (10, 5, 2, N'发货', N'SfDemo.Made.POrder.Delivery', 7)
SET IDENTITY_INSERT [dbo].[SysResource] OFF
/****** Object:  Table [dbo].[SysEmployeeManager]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysEmployeeManager](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[EmpUserID] [int] NOT NULL,
	[ManagerID] [int] NOT NULL,
	[MgrUserID] [int] NOT NULL,
 CONSTRAINT [PK_SysEmployeeManager] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysEmployeeManager] ON
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (1, 1, 6, 2, 5)
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (2, 4, 10, 5, 17)
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (4, 6, 9, 3, 5)
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (5, 4, 10, 7, 18)
SET IDENTITY_INSERT [dbo].[SysEmployeeManager] OFF
/****** Object:  Table [dbo].[SysEmployee]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysEmployee](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DeptID] [int] NOT NULL,
	[EmpCode] [varchar](50) NOT NULL,
	[EmpName] [nvarchar](50) NOT NULL,
	[UserID] [int] NULL,
	[Mobile] [varchar](20) NULL,
	[EMail] [varchar](100) NULL,
	[Remark] [nvarchar](500) NULL,
 CONSTRAINT [PK_SYSEMPLOYEE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysEmployee] ON
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (1, 2, N'0001', N'路天明', 6, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (2, 2, N'0002', N'张经理', 5, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (3, 3, N'0003', N'金经理', 18, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (4, 4, N'0004', N'阿杰', 10, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (5, 4, N'0005', N'崔经理', 17, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (6, 2, N'0010', N'张明', 9, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (7, 4, N'0030', N'金兰', 18, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[SysEmployee] OFF
/****** Object:  Table [dbo].[SysDepartment]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysDepartment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DeptCode] [varchar](50) NOT NULL,
	[DeptName] [nvarchar](100) NOT NULL,
	[ParentID] [int] NOT NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_SYSDEPARTMENT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysDepartment] ON
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (1, N'CP', N'SlickOne科技', 0, NULL)
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (2, N'TH', N'技术部', 1, NULL)
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (3, N'HR', N'人事部', 1, NULL)
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (4, N'FN', N'财务部', 1, NULL)
SET IDENTITY_INSERT [dbo].[SysDepartment] OFF
/****** Object:  StoredProcedure [dbo].[pr_sys_UserSave]    Script Date: 07/26/2017 20:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_UserSave]
   @userID			int,
   @userName		varchar(100)

AS

BEGIN

	SET NOCOUNT ON
	-- 检查条件
	IF EXISTS(SELECT 1 
			  FROM SysUser 
			  WHERE ID<>@userID 
				AND (UserName=@userName)
			  )
		RAISERROR ('插入或编辑用户数据失败: 有重复的名称已经存在!', 16, 1)

    --插入或者编辑				
	BEGIN TRY
		IF (@userID>0)
			UPDATE SysUser
			SET UserName=@userName
			WHERE ID=@userID
		ELSE
		    INSERT INTO SysUser(UserName)
		    VALUES(@userName)
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('插入或编辑用户数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_UserDelete]    Script Date: 07/26/2017 20:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_UserDelete]
   @userID			int

AS

BEGIN

	SET NOCOUNT ON
    --删除操作				
	BEGIN TRY
		DELETE FROM SysRoleUser WHERE UserID=@userID
		DELETE FROM SysUser WHERE ID=@userID
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除用户数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_RoleUserDelete]    Script Date: 07/26/2017 20:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_RoleUserDelete]
   @userID			int,
   @roleID			int

AS

BEGIN

	SET NOCOUNT ON
    --删除操作				
	BEGIN TRY
		IF (@userID = -1)
			DELETE FROM SysRoleUser WHERE RoleID=@roleID
		ELSE
			DELETE FROM SysRoleUser WHERE UserID=@userID AND RoleID=@roleID
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除角色下的用户数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_RoleSave]    Script Date: 07/26/2017 20:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_RoleSave]
   @roleID			int,
   @roleCode		varchar(50),
   @roleName		nvarchar(100)

AS

BEGIN

	SET NOCOUNT ON
	-- 检查条件
	IF EXISTS(SELECT 1 
			  FROM SysRole 
			  WHERE ID<>@roleID 
				AND (RoleCode=@roleCode OR RoleName=@roleName)
			  )
		RAISERROR ('插入或编辑角色数据失败: 有重复的名称或者编码已经存在!', 16, 1)

    --插入或者编辑				
	BEGIN TRY
		IF (@roleID>0)
			UPDATE SysRole
			SET RoleCode=@roleCode, RoleName=@roleName
			WHERE ID=@roleID
		ELSE
		    INSERT INTO SysRole(RoleCode, RoleName)
		    VALUES(@roleCode, @roleName)
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('插入或编辑角色数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_RoleDelete]    Script Date: 07/26/2017 20:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_RoleDelete]
   @roleID			int

AS

BEGIN

	SET NOCOUNT ON
    --删除操作				
	BEGIN TRY
		DELETE FROM SysRoleUser WHERE RoleID=@roleID
		DELETE FROM SysRole WHERE ID=@roleID
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除角色数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  Table [dbo].[WfActivityInstance]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfActivityInstance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessInstanceID] [int] NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ActivityGUID] [varchar](100) NOT NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[ActivityType] [smallint] NOT NULL,
	[ActivityState] [smallint] NOT NULL,
	[WorkItemType] [smallint] NOT NULL,
	[AssignedToUserIDs] [nvarchar](1000) NULL,
	[AssignedToUserNames] [nvarchar](2000) NULL,
	[BackwardType] [smallint] NULL,
	[BackSrcActivityInstanceID] [int] NULL,
	[GatewayDirectionTypeID] [smallint] NULL,
	[CanRenewInstance] [tinyint] NOT NULL,
	[TokensRequired] [int] NOT NULL,
	[TokensHad] [int] NOT NULL,
	[ComplexType] [smallint] NULL,
	[MergeType] [smallint] NULL,
	[MIHostActivityInstanceID] [int] NULL,
	[CompareType] [smallint] NULL,
	[CompleteOrder] [float] NULL,
	[SignForwardType] [smallint] NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedByUserID] [varchar](50) NULL,
	[LastUpdatedByUserName] [nvarchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[EndedDateTime] [datetime] NULL,
	[EndedByUserID] [varchar](50) NULL,
	[EndedByUserName] [nvarchar](50) NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfActivityInstance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfActivityInstance] ON
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2502, 967, N'SamplePrice', N'100', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'9b78486d-5b8f-4be4-948e-522356e84e79', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A78D00FE23CE AS DateTime), N'10', N'Long', CAST(0x0000A78D00FE23EF AS DateTime), CAST(0x0000A78D00FE23EF AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2503, 967, N'SamplePrice', N'100', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'3c438212-4863-4ff8-efc9-a9096c4a8230', N'业务员提交', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A78D00FE2401 AS DateTime), N'10', N'Long', CAST(0x0000A78D00FF65ED AS DateTime), CAST(0x0000A78D00FF65ED AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2504, 967, N'SamplePrice', N'100', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'eb833577-abb5-4239-875a-5f2e2fcb6d57', N'板房签字', 4, 1, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A78D00FF65ED AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2505, 968, N'生产订单', N'676', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'e357fe9e-dc33-4075-bd34-6f7425bb7671', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'7', N'陈盖茨', CAST(0x0000A79000CD1A55 AS DateTime), N'7', N'陈盖茨', CAST(0x0000A79000CD1A63 AS DateTime), CAST(0x0000A79000CD1A63 AS DateTime), N'7', N'陈盖茨', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2506, 968, N'生产订单', N'676', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'aad747dd-2b75-449c-a8a6-391b8a426e83', N'派单', 4, 4, 1, N'7', N'陈盖茨', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'7', N'陈盖茨', CAST(0x0000A79000CD1A71 AS DateTime), N'7', N'陈盖茨', CAST(0x0000A79000CD1AA0 AS DateTime), CAST(0x0000A79000CD1AA0 AS DateTime), N'7', N'陈盖茨', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2507, 968, N'生产订单', N'676', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'890d4971-3d5d-4800-bdf3-a355fd4a6317', N'Or分支节点', 8, 4, 0, NULL, NULL, 0, NULL, 1, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'7', N'陈盖茨', CAST(0x0000A79000CD1AA5 AS DateTime), N'7', N'陈盖茨', CAST(0x0000A79000CD1AA5 AS DateTime), CAST(0x0000A79000CD1AA5 AS DateTime), N'7', N'陈盖茨', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2508, 968, N'生产订单', N'676', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'fc8c71c5-8786-450e-af27-9f6a9de8560f', N'打样', 4, 1, 1, N'11,12', N'飞羽,雪莉', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'7', N'陈盖茨', CAST(0x0000A79000CD1AA5 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2509, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'bb6c9787-0e1c-4de1-ddbc-593992724ca5', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7B800970403 AS DateTime), N'6', N'路天明', CAST(0x0000A7B800970414 AS DateTime), CAST(0x0000A7B800970414 AS DateTime), N'6', N'路天明', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2510, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'3242c597-e889-4768-f6db-cafc3d675370', N'员工提交', 4, 4, 1, N'6', N'路天明', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7B80097041A AS DateTime), N'6', N'路天明', CAST(0x0000A7B80097043C AS DateTime), CAST(0x0000A7B80097043C AS DateTime), N'6', N'路天明', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2511, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 4, 4, 1, N'0,5,17', N'张恒丰,崔红', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7B80097043D AS DateTime), N'5', N'张恒丰', CAST(0x0000A7B80097B402 AS DateTime), CAST(0x0000A7B80097B402 AS DateTime), N'5', N'张恒丰', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2512, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c05bc40f-579b-49cb-cd12-30c2cba4db1e', N'Gateway', 8, 4, 0, NULL, NULL, 0, NULL, 1, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'5', N'张恒丰', CAST(0x0000A7B80097B404 AS DateTime), N'5', N'张恒丰', CAST(0x0000A7B80097B405 AS DateTime), CAST(0x0000A7B80097B405 AS DateTime), N'5', N'张恒丰', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2513, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'da9f744b-3f97-40c9-c4f8-67d5a60a2485', N'人事经理审批', 4, 1, 1, N'0,4', N'李颖', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'5', N'张恒丰', CAST(0x0000A7B80097B406 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2514, 970, N'请假流程', N'33', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'bb6c9787-0e1c-4de1-ddbc-593992724ca5', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7B8009BF53B AS DateTime), N'6', N'路天明', CAST(0x0000A7B8009BF549 AS DateTime), CAST(0x0000A7B8009BF549 AS DateTime), N'6', N'路天明', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2515, 970, N'请假流程', N'33', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'3242c597-e889-4768-f6db-cafc3d675370', N'员工提交', 4, 4, 1, N'6', N'路天明', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7B8009BF54D AS DateTime), N'6', N'路天明', CAST(0x0000A7B8009BF56E AS DateTime), CAST(0x0000A7B8009BF56E AS DateTime), N'6', N'路天明', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2516, 970, N'请假流程', N'33', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 4, 1, 1, N'0,5,17', N'张恒丰,崔红', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7B8009BF56E AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2517, 971, N'生产订单', N'678', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'e357fe9e-dc33-4075-bd34-6f7425bb7671', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'7', N'陈盖茨', CAST(0x0000A7B8009E521D AS DateTime), N'7', N'陈盖茨', CAST(0x0000A7B8009E5229 AS DateTime), CAST(0x0000A7B8009E5229 AS DateTime), N'7', N'陈盖茨', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2518, 971, N'生产订单', N'678', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'aad747dd-2b75-449c-a8a6-391b8a426e83', N'派单', 4, 4, 1, N'7', N'陈盖茨', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'7', N'陈盖茨', CAST(0x0000A7B8009E5231 AS DateTime), N'7', N'陈盖茨', CAST(0x0000A7B8009E5257 AS DateTime), CAST(0x0000A7B8009E5257 AS DateTime), N'7', N'陈盖茨', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2519, 971, N'生产订单', N'678', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'890d4971-3d5d-4800-bdf3-a355fd4a6317', N'Or分支节点', 8, 4, 0, NULL, NULL, 0, NULL, 1, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'7', N'陈盖茨', CAST(0x0000A7B8009E5259 AS DateTime), N'7', N'陈盖茨', CAST(0x0000A7B8009E5259 AS DateTime), CAST(0x0000A7B8009E5259 AS DateTime), N'7', N'陈盖茨', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2520, 971, N'生产订单', N'678', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'fc8c71c5-8786-450e-af27-9f6a9de8560f', N'打样', 4, 1, 1, N'11,12', N'飞羽,雪莉', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'7', N'陈盖茨', CAST(0x0000A7B8009E525A AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2521, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'bb6c9787-0e1c-4de1-ddbc-593992724ca5', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7BC01321665 AS DateTime), N'6', N'路天明', CAST(0x0000A7BC01321678 AS DateTime), CAST(0x0000A7BC01321678 AS DateTime), N'6', N'路天明', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2522, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'3242c597-e889-4768-f6db-cafc3d675370', N'员工提交', 4, 4, 1, N'6', N'路天明', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7BC01321680 AS DateTime), N'6', N'路天明', CAST(0x0000A7BC013216A3 AS DateTime), CAST(0x0000A7BC013216A3 AS DateTime), N'6', N'路天明', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2523, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 4, 4, 1, N'0,5,17', N'张恒丰,崔红', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7BC013216A3 AS DateTime), N'5', N'张恒丰', CAST(0x0000A7BC01326444 AS DateTime), CAST(0x0000A7BC01326444 AS DateTime), N'5', N'张恒丰', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2524, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c05bc40f-579b-49cb-cd12-30c2cba4db1e', N'Gateway', 8, 4, 0, NULL, NULL, 0, NULL, 1, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'5', N'张恒丰', CAST(0x0000A7BC01326446 AS DateTime), N'5', N'张恒丰', CAST(0x0000A7BC01326446 AS DateTime), CAST(0x0000A7BC01326446 AS DateTime), N'5', N'张恒丰', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2525, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'da9f744b-3f97-40c9-c4f8-67d5a60a2485', N'人事经理审批', 4, 1, 1, N'0,4', N'李颖', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'5', N'张恒丰', CAST(0x0000A7BC01326447 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[WfActivityInstance] OFF
/****** Object:  View [dbo].[vw_SysRoleUserView]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SysRoleUserView]
AS
SELECT  dbo.SysRoleUser.ID,
    dbo.SysRole.ID as RoleID, 
	dbo.SysRole.RoleName, 
	dbo.SysRole.RoleCode, 
	dbo.SysUser.ID as UserID,
	dbo.SysUser.UserName
FROM         dbo.SysRole LEFT JOIN
             dbo.SysRoleUser ON dbo.SysRole.ID = dbo.SysRoleUser.RoleID LEFT JOIN
             dbo.SysUser ON dbo.SysRoleUser.UserID = dbo.SysUser.ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[24] 2[17] 3) )"
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
         Begin Table = "SysRole"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 110
               Right = 180
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysRoleUser"
            Begin Extent = 
               Top = 4
               Left = 313
               Bottom = 108
               Right = 455
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysUser"
            Begin Extent = 
               Top = 165
               Left = 175
               Bottom = 254
               Right = 317
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SysRoleUserView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SysRoleUserView'
GO
/****** Object:  Table [dbo].[WfTasks]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfTasks](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ActivityInstanceID] [int] NOT NULL,
	[ProcessInstanceID] [int] NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ActivityGUID] [varchar](100) NOT NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[TaskType] [smallint] NOT NULL,
	[TaskState] [smallint] NOT NULL,
	[EntrustedTaskID] [int] NULL,
	[AssignedToUserID] [varchar](50) NOT NULL,
	[AssignedToUserName] [nvarchar](50) NOT NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[LastUpdatedByUserID] [varchar](50) NULL,
	[LastUpdatedByUserName] [nvarchar](50) NULL,
	[EndedByUserID] [varchar](50) NULL,
	[EndedByUserName] [nvarchar](50) NULL,
	[EndedDateTime] [datetime] NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_SSIP_WfTasks] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfTasks] ON
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1671, 2503, 967, N'SamplePrice', N'100', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'3c438212-4863-4ff8-efc9-a9096c4a8230', N'业务员提交', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A78D00FE2402 AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A78D00FF65DE AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1672, 2504, 967, N'SamplePrice', N'100', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'eb833577-abb5-4239-875a-5f2e2fcb6d57', N'板房签字', 1, 1, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A78D00FF65ED AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1673, 2506, 968, N'生产订单', N'676', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'aad747dd-2b75-449c-a8a6-391b8a426e83', N'派单', 1, 4, NULL, N'7', N'陈盖茨', N'7', N'陈盖茨', CAST(0x0000A79000CD1A73 AS DateTime), NULL, NULL, NULL, N'7', N'陈盖茨', CAST(0x0000A79000CD1AA0 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1674, 2508, 968, N'生产订单', N'676', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'fc8c71c5-8786-450e-af27-9f6a9de8560f', N'打样', 1, 1, NULL, N'11', N'飞羽', N'7', N'陈盖茨', CAST(0x0000A79000CD1AA5 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1675, 2508, 968, N'生产订单', N'676', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'fc8c71c5-8786-450e-af27-9f6a9de8560f', N'打样', 1, 1, NULL, N'12', N'雪莉', N'7', N'陈盖茨', CAST(0x0000A79000CD1AA5 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1676, 2510, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'3242c597-e889-4768-f6db-cafc3d675370', N'员工提交', 1, 4, NULL, N'6', N'路天明', N'6', N'路天明', CAST(0x0000A7B80097041C AS DateTime), NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7B80097043A AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1677, 2511, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 1, 1, NULL, N'0', N'', N'6', N'路天明', CAST(0x0000A7B80097043D AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1678, 2511, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 1, 4, NULL, N'5', N'张恒丰', N'6', N'路天明', CAST(0x0000A7B80097043E AS DateTime), NULL, NULL, NULL, N'5', N'张恒丰', CAST(0x0000A7B80097B402 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1679, 2511, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 1, 1, NULL, N'17', N'崔红', N'6', N'路天明', CAST(0x0000A7B80097043E AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1680, 2513, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'da9f744b-3f97-40c9-c4f8-67d5a60a2485', N'人事经理审批', 1, 1, NULL, N'0', N'', N'5', N'张恒丰', CAST(0x0000A7B80097B406 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1681, 2513, 969, N'请假流程', N'32', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'da9f744b-3f97-40c9-c4f8-67d5a60a2485', N'人事经理审批', 1, 1, NULL, N'4', N'李颖', N'5', N'张恒丰', CAST(0x0000A7B80097B406 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1682, 2515, 970, N'请假流程', N'33', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'3242c597-e889-4768-f6db-cafc3d675370', N'员工提交', 1, 4, NULL, N'6', N'路天明', N'6', N'路天明', CAST(0x0000A7B8009BF552 AS DateTime), NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7B8009BF56E AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1683, 2516, 970, N'请假流程', N'33', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 1, 1, NULL, N'0', N'', N'6', N'路天明', CAST(0x0000A7B8009BF56E AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1684, 2516, 970, N'请假流程', N'33', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 1, 1, NULL, N'5', N'张恒丰', N'6', N'路天明', CAST(0x0000A7B8009BF56E AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1685, 2516, 970, N'请假流程', N'33', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 1, 1, NULL, N'17', N'崔红', N'6', N'路天明', CAST(0x0000A7B8009BF56E AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1686, 2518, 971, N'生产订单', N'678', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'aad747dd-2b75-449c-a8a6-391b8a426e83', N'派单', 1, 4, NULL, N'7', N'陈盖茨', N'7', N'陈盖茨', CAST(0x0000A7B8009E5232 AS DateTime), NULL, NULL, NULL, N'7', N'陈盖茨', CAST(0x0000A7B8009E5255 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1687, 2520, 971, N'生产订单', N'678', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'fc8c71c5-8786-450e-af27-9f6a9de8560f', N'打样', 1, 1, NULL, N'11', N'飞羽', N'7', N'陈盖茨', CAST(0x0000A7B8009E525A AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1688, 2520, 971, N'生产订单', N'678', N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'fc8c71c5-8786-450e-af27-9f6a9de8560f', N'打样', 1, 1, NULL, N'12', N'雪莉', N'7', N'陈盖茨', CAST(0x0000A7B8009E525A AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1689, 2522, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'3242c597-e889-4768-f6db-cafc3d675370', N'员工提交', 1, 4, NULL, N'6', N'路天明', N'6', N'路天明', CAST(0x0000A7BC01321681 AS DateTime), NULL, NULL, NULL, N'6', N'路天明', CAST(0x0000A7BC013216A0 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1690, 2523, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 1, 1, NULL, N'0', N'', N'6', N'路天明', CAST(0x0000A7BC013216A3 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1691, 2523, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 1, 4, NULL, N'5', N'张恒丰', N'6', N'路天明', CAST(0x0000A7BC013216A3 AS DateTime), NULL, NULL, NULL, N'5', N'张恒丰', CAST(0x0000A7BC01326443 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1692, 2523, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', 1, 1, NULL, N'17', N'崔红', N'6', N'路天明', CAST(0x0000A7BC013216A3 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1693, 2525, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'da9f744b-3f97-40c9-c4f8-67d5a60a2485', N'人事经理审批', 1, 1, NULL, N'0', N'', N'5', N'张恒丰', CAST(0x0000A7BC01326447 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1694, 2525, 972, N'请假流程', N'34', N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'da9f744b-3f97-40c9-c4f8-67d5a60a2485', N'人事经理审批', 1, 1, NULL, N'4', N'李颖', N'5', N'张恒丰', CAST(0x0000A7BC01326447 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[WfTasks] OFF
/****** Object:  View [dbo].[vwWfActivityInstanceTasks]    Script Date: 07/26/2017 20:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwWfActivityInstanceTasks]
AS
SELECT     dbo.WfTasks.ID AS TaskID, dbo.WfActivityInstance.AppName, dbo.WfActivityInstance.AppInstanceID, dbo.WfActivityInstance.ProcessGUID, 
                      dbo.WfProcessInstance.Version, dbo.WfTasks.ProcessInstanceID, dbo.WfActivityInstance.ActivityGUID, dbo.WfTasks.ActivityInstanceID, 
                      dbo.WfActivityInstance.ActivityName, dbo.WfActivityInstance.ActivityType, dbo.WfActivityInstance.WorkItemType, 
                      dbo.WfActivityInstance.CreatedByUserID AS PreviousUserID, dbo.WfActivityInstance.CreatedByUserName AS PreviousUserName, 
                      dbo.WfActivityInstance.CreatedDateTime AS PreviousDateTime, dbo.WfTasks.TaskType, dbo.WfTasks.EntrustedTaskID, dbo.WfTasks.AssignedToUserID, 
                      dbo.WfTasks.AssignedToUserName, dbo.WfTasks.CreatedDateTime, dbo.WfTasks.LastUpdatedDateTime, dbo.WfTasks.EndedDateTime, 
                      dbo.WfTasks.EndedByUserID, dbo.WfTasks.EndedByUserName, dbo.WfTasks.TaskState, dbo.WfActivityInstance.ActivityState, dbo.WfTasks.RecordStatusInvalid, 
                      dbo.WfProcessInstance.ProcessState, dbo.WfActivityInstance.ComplexType, dbo.WfActivityInstance.MIHostActivityInstanceID, 
                      dbo.WfProcessInstance.AppInstanceCode, dbo.WfProcessInstance.ProcessName, dbo.WfProcessInstance.CreatedByUserName, 
                      dbo.WfProcessInstance.CreatedDateTime AS PCreatedDateTime, CASE WHEN MIHostActivityInstanceID IS NULL THEN ActivityState ELSE
                          (SELECT     ActivityState
                            FROM          dbo.WfActivityInstance a
                            WHERE      a.ID = dbo.WfActivityInstance.MIHostActivityInstanceID) END AS MiHostState
FROM         dbo.WfActivityInstance INNER JOIN
                      dbo.WfTasks ON dbo.WfActivityInstance.ID = dbo.WfTasks.ActivityInstanceID INNER JOIN
                      dbo.WfProcessInstance ON dbo.WfActivityInstance.ProcessInstanceID = dbo.WfProcessInstance.ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[23] 4[53] 2[13] 3) )"
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
         Begin Table = "WfActivityInstance"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "WfTasks"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 249
            End
            DisplayFlags = 280
            TopColumn = 13
         End
         Begin Table = "WfProcessInstance"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 10
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
         Column = 3930
         Alias = 2145
         Table = 2595
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwWfActivityInstanceTasks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwWfActivityInstanceTasks'
GO
/****** Object:  Default [DF__HrsLeave__LeaveT__1BFD2C07]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[HrsLeave] ADD  DEFAULT ((0)) FOR [LeaveType]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_State]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_State]  DEFAULT ((0)) FOR [ActivityState]
GO
/****** Object:  Default [DF_WfActivityInstance_WorkItemType]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_WfActivityInstance_WorkItemType]  DEFAULT ((0)) FOR [WorkItemType]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_CanInvokeNextActivity]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_CanInvokeNextActivity]  DEFAULT ((0)) FOR [CanRenewInstance]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_TokensRequired]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_TokensRequired]  DEFAULT ((1)) FOR [TokensRequired]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_CreatedDateTime]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_RecordStatusInvalid]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_RecordStatusInvalid]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  Default [DF_WfProcess_Version]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_WfProcess_Version]  DEFAULT ((1)) FOR [Version]
GO
/****** Object:  Default [DF_WfProcess_IsUsing]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_WfProcess_IsUsing]  DEFAULT ((0)) FOR [IsUsing]
GO
/****** Object:  Default [DF_SSIP-WfPROCESS_CreatedDateTime]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_SSIP-WfPROCESS_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_WfProcessInstance_Version]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_WfProcessInstance_Version]  DEFAULT ((1)) FOR [Version]
GO
/****** Object:  Default [DF_SSIP_WfProcessInstance_State]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_SSIP_WfProcessInstance_State]  DEFAULT ((0)) FOR [ProcessState]
GO
/****** Object:  Default [DF_WfProcessInstance_ParentProcessInstanceID]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_WfProcessInstance_ParentProcessInstanceID]  DEFAULT ((0)) FOR [ParentProcessInstanceID]
GO
/****** Object:  Default [DF_WfProcessInstance_InvokedActivityInstanceID]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_WfProcessInstance_InvokedActivityInstanceID]  DEFAULT ((0)) FOR [InvokedActivityInstanceID]
GO
/****** Object:  Default [DF_SSIP_WfProcessInstance_CreatedDateTime]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_SSIP_WfProcessInstance_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfProcessInstance_RecordStatus]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_SSIP_WfProcessInstance_RecordStatus]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  Default [DF_SSIP_WfTasks_IsCompleted]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfTasks] ADD  CONSTRAINT [DF_SSIP_WfTasks_IsCompleted]  DEFAULT ((0)) FOR [TaskState]
GO
/****** Object:  Default [DF_SSIP_WfTasks_CreatedDateTime]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfTasks] ADD  CONSTRAINT [DF_SSIP_WfTasks_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfTasks_RecordStatusInvalid]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfTasks] ADD  CONSTRAINT [DF_SSIP_WfTasks_RecordStatusInvalid]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  Default [DF_WfTransitionInstance_IsBackwardFlying]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_WfTransitionInstance_IsBackwardFlying]  DEFAULT ((0)) FOR [FlyingType]
GO
/****** Object:  Default [DF_SSIP_WfTransitionInstance_ConditionParseResult]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_SSIP_WfTransitionInstance_ConditionParseResult]  DEFAULT ((0)) FOR [ConditionParseResult]
GO
/****** Object:  Default [DF_SSIP_WfTransitionInstance_CreatedDateTime]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_SSIP_WfTransitionInstance_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfTransitionInstance_RecordStatusInvalid]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_SSIP_WfTransitionInstance_RecordStatusInvalid]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  ForeignKey [FK_WfActivityInstance_ProcessInstanceID]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfActivityInstance]  WITH NOCHECK ADD  CONSTRAINT [FK_WfActivityInstance_ProcessInstanceID] FOREIGN KEY([ProcessInstanceID])
REFERENCES [dbo].[WfProcessInstance] ([ID])
GO
ALTER TABLE [dbo].[WfActivityInstance] CHECK CONSTRAINT [FK_WfActivityInstance_ProcessInstanceID]
GO
/****** Object:  ForeignKey [FK_WfTasks_ActivityInstanceID]    Script Date: 07/26/2017 20:34:41 ******/
ALTER TABLE [dbo].[WfTasks]  WITH NOCHECK ADD  CONSTRAINT [FK_WfTasks_ActivityInstanceID] FOREIGN KEY([ActivityInstanceID])
REFERENCES [dbo].[WfActivityInstance] ([ID])
GO
ALTER TABLE [dbo].[WfTasks] CHECK CONSTRAINT [FK_WfTasks_ActivityInstanceID]
GO
