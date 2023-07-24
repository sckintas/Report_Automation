use ...


--Run this on the remote computer to allow OPENDATASOURCE remote connections
--EXEC sp_addlinkedsrvlogin '...', '...', '...', '...', '...'

-- Also run this on the remote computer
--sp_configure '...', 1;
--GO
--RECONFIGURE;
--GO
--sp_configure '...', 1;
--GO
--RECONFIGURE;
--GO

declare 
@filename nvarchar(max),
@CurrentUTCDATE datetime2,
@CurrentMessage int,
@NextMessage varchar(max),
@NextDateUTCDATE datetime2,
@uniqid int = 0,
@Closeuniqid int = 0,
@Olduniqid int = -1,
@count_TEMP_TRACKHISTORY int,
@count_TEMP_IO int,
@valuetype varchar(max),
@value int,
@CurrentID varchar(12),
@NextID varchar(12),
@folder_exists	int,
@cmd	varchar(8000),
@rowset nvarchar(max),
@StartTime nvarchar(max),
@EndTime nvarchar(max),
@IOEvent nvarchar(MAX),
@PourCount int,
@TimeBetwArrives datetime,
@PouredId nvarchar(MAX),
@PoureOffdId nvarchar(MAX),
@PouredIdEvent nvarchar(MAX),
@TimeBetwArrives_C nvarchar(MAX),
@TimeBetwArriveLeave_C nvarchar(MAX),
@ReportstartTime datetime,
@nReads int,
@mReads int,
@nAReads int,
@MAReads int

declare @TimeAdded int = -6
declare @iDefinedRFIDLen int
declare @NoRFID nvarchar(MAX)



set @ReportstartTime = getdate()
print 'start'+ cast(@ReportstartTime as nvarchar)
print 'Start report: '+ cast(datediff (minute, getdate(), @ReportstartTime ) as nvarchar(max))

set @StartTime	= ''
set @EndTime	= ''

set @iDefinedRFIDLen = 4

DECLARE @TEMPDATA_PC table ( 
	UNIQID		int Identity(1,1),
	[LOGNO]		int,
	[ID]		[nvarchar](max) NULL,
	[UTCDATE]	[datetime],
	[POSCODE]	int NULL,
	[READER]	int NULL,
	[ANTENNA]	int NULL,
	[VALID]		int NULL,
	[LOCKED]	int NULL,
	[POURCOUNT]	int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)

DECLARE @TEMPDATA_... table (
	THISUNIQID  int Identity(1,1), 
	[UNIQID]  int,
	[UTCDATE] [nvarchar](max) NULL,
	[PCTYPE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL,
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [nvarchar](max) NULL,
	[VALUETYPE] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[PCSTATE] [nvarchar](max) NOT NULL,
	[POURCOUNT]  int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)
	
	DECLARE @TEMPDATA_... table ( 
	THISUNIQID  int Identity(1,1), 
	[UNIQID]  int,
	[UTCDATE] [nvarchar](max) NULL,
	[PCTYPE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL,
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [nvarchar](max) NULL,
	[VALUETYPE] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[PCSTATE] [nvarchar](max) NOT NULL,
	[POURCOUNT]  int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)

	DECLARE @TEMPDATA_CORE_S_EXTRALINE table ( 
	THISUNIQID  int Identity(1,1), 
	[UNIQID]  int,
	[UTCDATE] [nvarchar](max) NULL,
	[PCTYPE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL,
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [nvarchar](max) NULL,
	[VALUETYPE] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[PCSTATE] [nvarchar](max) NOT NULL,
	[POURCOUNT]  int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)

	DECLARE @TEMPDATA... table ( 
	THISUNIQID  int Identity(1,1), 
	[UNIQID]  int,
	[UTCDATE] [nvarchar](max) NULL,
	[LOCALTIME]	[nvarchar](max) NULL,
	[DAYNAME]	[nvarchar](max) NULL,
	[PCTYPE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL,
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [nvarchar](max) NULL,
	[VALUETYPE] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[PCSTATE] [nvarchar](max) NOT NULL,
	[POURCOUNT]  int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)

	DECLARE @TEMPDATA... table ( 
	THISUNIQID  int Identity(1,1), 
	[UNIQID]  int,
	[UTCDATE] [nvarchar](max) NULL,
	[LOCALTIME]	[nvarchar](max) NULL,
	[DAYNAME]	[nvarchar](max) NULL,
	[PCTYPE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL,
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [nvarchar](max) NULL,
	[VALUETYPE] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[PCSTATE] [nvarchar](max) NOT NULL,
	[POURCOUNT]  int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)

	DECLARE @TEMPDATA... table ( 
	THISUNIQID  int Identity(1,1), 
	[UNIQID]  int,
	[UTCDATE] [nvarchar](max) NULL,
	[LOCALTIME]	[nvarchar](max) NULL,
	[DAYNAME]	[nvarchar](max) NULL,
	[PCTYPE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL,
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [nvarchar](max) NULL,
	[VALUETYPE] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[PCSTATE] [nvarchar](max) NOT NULL,
	[POURCOUNT]  int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)

	DECLARE @TEMPDATA... table ( 
	THISUNIQID  int Identity(1,1), 
	[UNIQID]  int,
	[UTCDATE] [nvarchar](max) NULL,
	[LOCALTIME]	[nvarchar](max) NULL,
	[DAYNAME]	[nvarchar](max) NULL,
	[PCTYPE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL,
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [nvarchar](max) NULL,
	[VALUETYPE] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[PCSTATE] [nvarchar](max) NOT NULL,
	[POURCOUNT]  int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)
		
	DECLARE @TEMPDATA... table ( 
	THISUNIQID  int Identity(1,1), 
	[UNIQID]  int,
	[UTCDATE] [nvarchar](max) NULL,
	[LOCALTIME]	[nvarchar](max) NULL,
	[DAYNAME]	[nvarchar](max) NULL,
	[PCTYPE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL,
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [nvarchar](max) NULL,
	[VALUETYPE] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[PCSTATE] [nvarchar](max) NOT NULL,
	[POURCOUNT]  int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)
	
	DECLARE @TEMPDATA... table ( 
	THISUNIQID  int Identity(1,1), 
	[UNIQID]  int,
	[UTCDATE] [nvarchar](max) NULL,
	[LOCALTIME]	[nvarchar](max) NULL,
	[DAYNAME]	[nvarchar](max) NULL,
	[PCTYPE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL,
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [nvarchar](max) NULL,
	[VALUETYPE] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[PCSTATE] [nvarchar](max) NOT NULL,
	[POURCOUNT]  int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)

	DECLARE @TEMPDATA... table ( 
	THISUNIQID  int Identity(1,1), 
	[UNIQID]  int,
	[UTCDATE] [nvarchar](max) NULL,
	[LOCALTIME]	[nvarchar](max) NULL,
	[DAYNAME]	[nvarchar](max) NULL,
	[PCTYPE] [nvarchar](max) NOT NULL,
	[ID] [nvarchar](max) NOT NULL,
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [nvarchar](max) NULL,
	[VALUETYPE] [nvarchar](max) NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[PCSTATE] [nvarchar](max) NOT NULL,
	[POURCOUNT]  int,
	[TIMEDIFF]  [nvarchar](max) NULL,
	[NREADS]	int NULL,
    [MREADS]	int NULL)
	
	DECLARE @TEMPDATA_...  table(
	UNIQID  int Identity(1,1),
	[UTCDATE] [datetime],
	[EVENT] [nvarchar](max) NOT NULL,
	[MESSAGE] [int] NOT NULL,
	[VALUE] [int])

	------------------------------------Get data into temp tables-----------------------------------------------------------------

	
declare @sql varchar(8000) ,
@filepath	varchar(500),
@datasource	varchar(500),
@datadirectory	nvarchar(4000),
@header	varchar(max)
--SET @header = 'THISUNIQID	UNIQID	UTCDATE	PCTYPE	ID	EVENT	MESSAGE	VALUETYPE	VALUE	PCSTATE	POURCOUNT	TIMEDIFF'

set @datadirectory = '' -- Must be the same as in configuration.ini in sql section
SET @filepath = '"'+@datadirectory+''
set @datasource = @datadirectory+''
SET @sql = 'COPY ' +@datasource + ' ' + @filepath;  
EXEC master.dbo.xp_cmdshell @sql; 


declare @loopcountings int
while(@loopcountings < 10)
begin
	WAITFOR DELAY '00:00:01'
	set @loopcountings = @loopcountings +1
end


	INSERT INTO @TEMPDATA_PC SELECT 
	   [LOGNO]
      ,[ID]
      ,[UTCDATE]
      ,[POSCODE]
      ,[READER]
      ,[ANTENNA]
      ,[VALID]
      ,[LOCKED]
	  ,[POURCOUNT] = 0
	  ,[TIMEDIFF] = 0
	  ,[NREADS]
      ,[MREADS]
	  FROM OPENDATASOURCE('SQLNCLI','Data Source=...;user id=...;password=...').[...].dbo....
	  --FROM OPENDATASOURCE('SQLNCLI','Data Source=...,...;user id=...;password=...').[...].dbo....
	  --FROM [...].[...].[...]
	  where UTCDATE BETWEEN @StartTime AND @EndTime
	  order by UTCDATE asc

	INSERT INTO @TEMPDATA_IO SELECT 
		[UTCDATE] 
	   ,[EVENT] 
	   ,[MESSAGE]
	   ,[VALUE]
	   --FROM [...].[...].[...]
	   FROM OPENDATASOURCE('SQLNCLI','Data Source=...;user id=...;password=...').[...].dbo....
	   --FROM OPENDATASOURCE('SQLNCLI','Data Source=...;user id=...;password=...').[...].dbo....
	   where UTCDATE BETWEEN @StartTime AND @EndTime	  
	   order by UTCDATE asc

	   --select * from @TEMPDATA_PC where POSCODE = '...'
	   --select * from @TEMPDATA_IO
	------------------------------------Get data into temp tables END-----------------------------------------------------------------

  print 'Insert Done! Minutes:'+ cast(datediff (minute, @ReportstartTime, getdate()) as nvarchar(max))
  SELECT @count_TEMP_TRACKHISTORY = COUNT(*) FROM @TEMPDATA_PC
  SELECT @count_TEMP_IO = COUNT(*) FROM @TEMPDATA_IO

   --------------------------GetIO---------------------------
 set @uniqid = 0

  while(@uniqid <= @count_TEMP_IO and @Olduniqid<>@uniqid)
  BEGIN
	  SELECT	@CurrentUTCDATE = [UTCDATE], 
				@IOEvent = [EVENT] ,
				@uniqid = [UNIQID],
				@CurrentMessage = [MESSAGE], 
				@value = [VALUE] 
				FROM @TEMPDATA_IO where UNIQID = @uniqid
				set @Olduniqid = @uniqid

		print 'IO @CurrentUTCDATE          ' + Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)) +'   @uniqid:'+cast(@uniqid as nvarchar(max))

	  
	  
		if((@CurrentMessage = ... OR @CurrentMessage = ... or @CurrentMessage = ... OR @CurrentMessage = ...) AND @IOEvent = 'Input' AND @value = 1)
		Begin
		Select top 1	@NextDateUTCDATE = [UTCDATE], 
						@Closeuniqid = UNIQID
						FROM @TEMPDATA_IO 
						where [UTCDATE] >= @CurrentUTCDATE and [EVENT] = 'Input' and [MESSAGE] = @CurrentMessage and [VALUE] = 0
						order by [UTCDATE] ASC

		IF @@ROWCOUNT = 0  
		PRINT 'Warning: No rows were updated';  


		-------Declaretions for the Count to find Arrived ID to pour in
		declare @ArriveTime datetime
		declare  @IDCount int
		declare  @LoopUniqId int 
		declare  @PourOffUniqId int 
		declare  @OldLoopUniqId int 
		declare @messageOffset int
		declare @PrevuosPouredId nvarchar(MAX)
		declare @PrePrevuosPouredId nvarchar(MAX)
		declare @PrePrePrevuosPouredId nvarchar(MAX)
		set @OldLoopUniqId = 0
		set @ArriveTime =  @CurrentUTCDATE
				
		if(@CurrentMessage = ... OR @CurrentMessage = ...)
		Begin
			set @messageOffset = 200
		end
		else if(@CurrentMessage = ... OR @CurrentMessage = ...)
		Begin
			set @messageOffset = 400			
		end
				
		if(@CurrentMessage = ... OR @CurrentMessage = ...)
		Begin
			Select top 1 @PouredId = [ID], @ArriveTime = UTCDATE, @LoopUniqId = UNIQID FROM @TEMPDATA_PC where (CHARINDEX('_', [ID]) > 0) and [VALID] = 1 and [UTCDATE] <= @CurrentUTCDATE and [POSCODE] = @CurrentMessage-@messageOffset order by [UTCDATE] desc
			SELECT @IDCount = COUNT(*) FROM @TEMPDATA_PC where [ID] = @PouredId and ([VALID] = 1 or [VALID] = 0) and UTCDATE BETWEEN @ArriveTime and @CurrentUTCDATE and [POSCODE] = @CurrentMessage-@messageOffset
			set @PrevuosPouredId = @PouredId
			set @PrePrevuosPouredId = @PouredId

			------This one can take long time----
			while(@IDCount % 2 = 0 and @OldLoopUniqId <> @LoopUniqId) -- AND DATEDIFF(day, @ArriveTime, @CurrentUTCDATE) < 3)
			begin
				set @OldLoopUniqId = @LoopUniqId
				Select top 1 @PouredId = [ID], @ArriveTime = UTCDATE, @LoopUniqId = UNIQID  FROM @TEMPDATA_PC where [ID] <> @PouredId and [ID] <> @PrevuosPouredId and [ID] <> @PrePrevuosPouredId and [ID] <> @PrePrePrevuosPouredId and (CHARINDEX('_', [ID]) > 0) and [VALID] = 1 and [UTCDATE] < @ArriveTime and [POSCODE] = @CurrentMessage-@messageOffset order by [UTCDATE] desc
				SELECT @IDCount = COUNT(*) FROM @TEMPDATA_PC where [ID] = @PouredId and ([VALID] = 1 or [VALID] = 0) and UTCDATE BETWEEN @ArriveTime and @CurrentUTCDATE and [POSCODE] = @CurrentMessage-@messageOffset
				set @PrePrePrevuosPouredId = @PrePrevuosPouredId
				set @PrePrevuosPouredId = @PrevuosPouredId
				set @PrevuosPouredId = @PouredId
				--print cast(@LoopUniqId as varchar) +' @IDCount: '+ cast(@IDCount as varchar) + ' ID: '+  cast(@PouredId as varchar)  
			end

			--if(DATEDIFF(day, @ArriveTime, @CurrentUTCDATE) >= 3)
			--begin
			--	print 'DATEDIFF > 3 '
			--end

			set @PoureOffdId = @PouredId
			set @PoureOffdId = '-'
			set @PourOffUniqId = '-'
			if (@OldLoopUniqId = @LoopUniqId)
			Begin
				set @PouredId = 'Unknown'
				set @PoureOffdId = 'Unknown'
				set @LoopUniqId = 0
				Select top 1 @PoureOffdId = [ID], @PourOffUniqId = UNIQID FROM @TEMPDATA_PC where(CHARINDEX('_', [ID]) > 0) and [VALID] = 1 and [UTCDATE] between @CurrentUTCDATE and @NextDateUTCDATE and [POSCODE] = @CurrentMessage-@messageOffset order by [UTCDATE] desc
			End
		end
		else -- ... or ...
		begin 			
			set @PouredId = 'Unknown'
			set @ArriveTime = ''
			set @LoopUniqId = 0
			set @PoureOffdId = 'Unknown'			
			set @PourOffUniqId = '-'
		end
		
		if(@CurrentMessage = ... and @IOEvent = 'Input')
			begin			
				INSERT INTO @TEMPDATAPOUR1 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', '-', 'PourOn', @PouredId, 'UniqID:'+CAST(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATAPOUR1 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', '-', 'PourOff', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'PourTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
				
				INSERT INTO @TEMPDATA_POUR1_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'PourOff', @PouredId, 'UniqID:'+CAST(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				INSERT INTO @TEMPDATA_POUR1_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'PourOn', @PouredId, 'UniqID:'+CAST(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATA_POUR1_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'PourOn', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'PourTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATA_POUR1_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'PourOff', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'PourTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
			end
		else if(@CurrentMessage = ... and @IOEvent = 'Input')
			begin
				INSERT INTO @TEMPDATAPOUR2 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)),'-', '-', 'PourOn', @PouredId, 'UniqID:'+cast(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATAPOUR2 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', '-', 'PourOff', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'PourTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
				
				INSERT INTO @TEMPDATA_POUR2_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'PourOff', @PouredId, 'UniqID:'+cast(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				INSERT INTO @TEMPDATA_POUR2_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'PourOn', @PouredId, 'UniqID:'+cast(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATA_POUR2_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'PourOn', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'PourTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATA_POUR2_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'PourOff', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'PourTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
			end
		else if(@CurrentMessage = ... and @IOEvent = 'Input')
			begin		
				
				INSERT INTO @TEMPDATAPOUR1 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)),cast(@CurrentMessage as varchar), '-', 'ProximityOn', @PouredId, 'UniqID:'+CAST(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATAPOUR1 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), cast(@CurrentMessage as varchar), '-', 'ProximityOff', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'ProximityTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
				
				INSERT INTO @TEMPDATA_POUR1_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), cast(@CurrentMessage as varchar), '-', 'ProximityOff', @PouredId, 'UniqID:'+CAST(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				INSERT INTO @TEMPDATA_POUR1_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), cast(@CurrentMessage as varchar), '-', 'ProximityOn', @PouredId, 'UniqID:'+CAST(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATA_POUR1_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), cast(@CurrentMessage as varchar), '-', 'ProximityOn', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'ProximityTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATA_POUR1_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), cast(@CurrentMessage as varchar), '-', 'ProximityOff', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'ProximityTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
			end
		else if(@CurrentMessage = ... and @IOEvent = 'Input')
			begin

				INSERT INTO @TEMPDATAPOUR2 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), cast(@CurrentMessage as varchar), '-', 'ProximityOn', @PouredId, 'UniqID:'+cast(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATAPOUR2 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), cast(@CurrentMessage as varchar), '-', 'ProximityOff', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'ProximityTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
				
				INSERT INTO @TEMPDATA_POUR2_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), cast(@CurrentMessage as varchar), '-', 'ProximityOff', @PouredId, 'UniqID:'+cast(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				INSERT INTO @TEMPDATA_POUR2_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), cast(@CurrentMessage as varchar), '-', 'ProximityOn', @PouredId, 'UniqID:'+cast(@LoopUniqId as nvarchar(max)), '-', '-', 0, 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATA_POUR2_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), cast(@CurrentMessage as varchar), '-', 'ProximityOn', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'ProximityTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
				if(@Closeuniqid <> 0)
					INSERT INTO @TEMPDATA_POUR2_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), cast(@CurrentMessage as varchar), '-', 'ProximityOff', @PoureOffdId, 'UniqID:'+CAST(@PourOffUniqId as nvarchar(max)), 'ProximityTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0 );
			end
	  End
	   
	  if(@CurrentMessage = ... AND @IOEvent = 'Lock' AND @value = 1)
	  Begin
		Select top 1	@NextDateUTCDATE = [UTCDATE], 
						@Closeuniqid = UNIQID
						FROM @TEMPDATA_IO 
						where [UTCDATE] >= @CurrentUTCDATE and [EVENT] = 'Lock' and [MESSAGE] = @CurrentMessage and [VALUE] = '0'
						order by [UTCDATE] ASC

		if(@CurrentMessage = ... and @IOEvent = 'Lock')
		begin 
		
			declare @Merged nvarchar(MAX)
			declare @iMerged int
			set @NoRFID = ''
			SELECT @iMerged = COUNT(DISTINCT ID) FROM @TEMPDATA_PC where UTCDATE between @CurrentUTCDATE and @NextDateUTCDATE and [POSCODE] = 4430
			if(	@iMerged = 3)
			begin
				set @Merged = 'Fully merged'
			end
			else
			begin
				set @Merged = 'Not merged'
				SELECT @iMerged = COUNT(DISTINCT ID) FROM @TEMPDATA_PC where UTCDATE between @CurrentUTCDATE and @NextDateUTCDATE and [POSCODE] = 4430 and len(ID) < @iDefinedRFIDLen
				if(	@iMerged = 0)
				begin
					set @Merged = 'Not merged No RFID' 
				end
			end

			print 'iMerged' + cast(@iMerged as nvarchar(max))
				
			INSERT INTO @TEMPDATA4430		([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid,      Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)),  Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)),'-', '-', 'LockOn', '-', '-', '-', '-', 0, 0 );
			if(@Closeuniqid <> 0)
				INSERT INTO @TEMPDATA4430	([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', '-', 'LockOff', @Merged, cast(@iMerged as nvarchar(max)), 'LockTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0);
			
			INSERT INTO @TEMPDATA_CORE_S_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid,       Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'LockOff', 'EXTRALINE', @Merged, '-', '-', 0, 0 );
			INSERT INTO @TEMPDATA_CORE_S_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@uniqid,       Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'LockOn', '-', '-', '-', '-', 0, 0 );
			if(@Closeuniqid <> 0)
				INSERT INTO @TEMPDATA_CORE_S_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'LockOn', 'EXTRALINE', '-', 'LockTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0);
			if(@Closeuniqid <> 0)
				INSERT INTO @TEMPDATA_CORE_S_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'LockOff', @Merged, cast(@iMerged as nvarchar(max)), 'LockTime:', CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3),'', 0);
		end	
	End
	
	set @PouredId = '--' 
	set @ArriveTime = NULL 
	set @LoopUniqId = 0 
	set @IDCount = 0
	set @NextDateUTCDATE = NULL 						
	set @CurrentUTCDATE = NULL 
	set @IOEvent = '--'
	set @CurrentMessage = 0 
	set @value = 0

	set @Closeuniqid = 0
	set @uniqid = @uniqid + 1
 END
 ------------------------GetIO END------------------------
 set @uniqid = 0

  while(@uniqid <= @count_TEMP_TRACKHISTORY and @Olduniqid<>@uniqid)
  BEGIN
	  SELECT	@CurrentUTCDATE = [UTCDATE], 
				@uniqid = UNIQID, 
				@CurrentID = [ID],
				@CurrentMessage = [VALID], 
				@value = [POSCODE],
				@nAReads = [NREADS],
				@mAReads = [MREADS]
				FROM @TEMPDATA_PC where UNIQID = @uniqid
	  set @Olduniqid = @uniqid

	print 'Tracking @CurrentUTCDATE          ' + Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)) +'   @uniqid:'+cast(@uniqid as nvarchar(max))

	
	  if(@CurrentMessage = 1 AND (@value = ... OR @value = ... OR @value = ... OR @value = ... OR @value = ... OR @value = ... OR @value = ...))
		Begin --2
		Select top 1	@NextDateUTCDATE = [UTCDATE], 
						@Closeuniqid = UNIQID,
						@NextID = [ID],
						@nReads = [NREADS],
						@mReads = [MREADS]
						FROM @TEMPDATA_PC 
						where [UTCDATE] >= @CurrentUTCDATE and [VALID] = 0 and [POSCODE] = @value and [ID] = @CurrentID
						order by [UTCDATE] asc

-------------------------------Get nb of pours or if we have a melt or lock at Core Setting--------------
			 set @PourCount = 0
			 if(CHARINDEX('_', @CurrentID) <> 0)
			 Begin
			 if(@value = ...)
			   begin
					SELECT @PourCount = COUNT(*) FROM @TEMPDATAPOUR1 where [EVENT] = 'PourOn' and UTCDATE BETWEEN @CurrentUTCDATE and @NextDateUTCDATE
				 end
			 else if(@value = ...)
				 begin
					SELECT @PourCount = COUNT(*) FROM @TEMPDATAPOUR2 where [EVENT] = 'PourOn' and UTCDATE BETWEEN @CurrentUTCDATE and @NextDateUTCDATE
				 end
			 else if(@value = ...) --Will not happen
				begin
					SELECT @PourCount = COUNT(*) FROM @TEMPDATA4430 where [EVENT] = 'LockOn' and UTCDATE BETWEEN @CurrentUTCDATE and @NextDateUTCDATE
				end
			 End


-----------------------------Get Time between arrives--------------------------
			Select top 1	@TimeBetwArrives = [UTCDATE]
									FROM @TEMPDATA_PC
									where [UTCDATE] < @CurrentUTCDATE and [VALID] = 1 and [POSCODE] = @value
									order by [UTCDATE] desc


-------------------------------Get time diff at pos --------------------------
			set @TimeBetwArrives_C = CAST (DATEDIFF(MILLISECOND, @TimeBetwArrives, @CurrentUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @TimeBetwArrives, @CurrentUTCDATE) % 1000) AS nvarchar(4)), 3)
			set @TimeBetwArriveLeave_C = CAST (DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE)/1000 AS nvarchar(3)) + N'.' + RIGHT('000' + CAST((DATEDIFF(MILLISECOND, @CurrentUTCDATE, @NextDateUTCDATE) % 1000) AS nvarchar(4)), 3)


-----------------------------Insert the corresponding closing event --------------------------
			if( @value = ...)
				 begin
					 INSERT INTO @TEMPDATA4410  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS])       VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)),'-', @CurrentID, 'Tracker', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					 if(@Closeuniqid = 0)
						begin
							INSERT INTO @TEMPDATA4410 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES ('-', Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @NextDateUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @NextDateUTCDATE)), '-', '-', '-', '-', '-', '-', '-', 0,'', @nReads, @MReads);
						end
					else
						begin						
							INSERT INTO @TEMPDATA4410  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', @NextID, 'Tracker', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads);
						end
					UPDATE @TEMPDATA4410  SET [TIMEDIFF] = @TimeBetwArrives_C WHERE [UNIQID] LIKE @uniqid;  
					UPDATE @TEMPDATA4410  SET [TIMEDIFF] = @TimeBetwArriveLeave_C WHERE [UNIQID] LIKE @Closeuniqid;  --Leave
				end
			else if( @value = ...)
				 begin
					 INSERT INTO @TEMPDATA4420  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)),'-', @CurrentID, 'Tracker', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					 if(@Closeuniqid = 0)
						begin
							INSERT INTO @TEMPDATA4420 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES ('-', Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @NextDateUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @NextDateUTCDATE)), '-', '-', '-', '-', '-', '-', '-', 0,'', @nReads, @MReads);
						end
					else
						begin						
							INSERT INTO @TEMPDATA4420  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', @NextID, 'Tracker', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads);
						end
					UPDATE @TEMPDATA4420  SET [TIMEDIFF] = @TimeBetwArrives_C WHERE [UNIQID] LIKE @uniqid;  
					UPDATE @TEMPDATA4420  SET [TIMEDIFF] = @TimeBetwArriveLeave_C WHERE [UNIQID] LIKE @Closeuniqid;  --Leave
				end
			else if( @value = ...)
				 begin
					 INSERT INTO @TEMPDATA4450  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)),'-', @CurrentID, 'Tracker', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					 if(@Closeuniqid = 0)
						begin
							INSERT INTO @TEMPDATA4450 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES ('-', Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @NextDateUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @NextDateUTCDATE)), '-', '-', '-', '-', '-', '-', '-', 0,'', @nReads, @MReads );
						end
					else
						begin						
							INSERT INTO @TEMPDATA4450  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', @NextID, 'Tracker', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0 , @nReads, @MReads);
						end
					UPDATE @TEMPDATA4450  SET [TIMEDIFF] = @TimeBetwArrives_C WHERE [UNIQID] LIKE @uniqid;  
					UPDATE @TEMPDATA4450  SET [TIMEDIFF] = @TimeBetwArriveLeave_C WHERE [UNIQID] LIKE @Closeuniqid;  --Leave
				end
			else if( @value = ...)
				 begin
					 INSERT INTO @TEMPDATA4469  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)),'-', @CurrentID, 'Tracker', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					 if(@Closeuniqid = 0)
						begin
							INSERT INTO @TEMPDATA4469 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES ('-', Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @NextDateUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @NextDateUTCDATE)), '-', '-', '-', '-', '-', '-', '-', 0,'',@nReads, @MReads );
						end
					else
						begin						
							INSERT INTO @TEMPDATA4469  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', @NextID, 'Tracker', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );
						end
					UPDATE @TEMPDATA4469  SET [TIMEDIFF] = @TimeBetwArrives_C WHERE [UNIQID] LIKE @uniqid;  
					UPDATE @TEMPDATA4469  SET [TIMEDIFF] = @TimeBetwArriveLeave_C WHERE [UNIQID] LIKE @Closeuniqid;  --Leave
				end
			else if( @value = ...)
				 begin
					 INSERT INTO @TEMPDATAPOUR1  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)),'-', @CurrentID, 'Tracker', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads );
					 INSERT INTO @TEMPDATA_POUR1_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', @CurrentID, 'EXTRALINE', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					 INSERT INTO @TEMPDATA_POUR1_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', @CurrentID, 'Tracker', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					 if(@Closeuniqid = 0)
						begin
							INSERT INTO @TEMPDATAPOUR1 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @NextDateUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @NextDateUTCDATE)), '-', '-', '-', '-', '-', '-', '-', 0,'', @nReads, @MReads );
							INSERT INTO @TEMPDATA_POUR1_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'EXTRALINE', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );
							INSERT INTO @TEMPDATA_POUR1_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES ('-', Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', '-', '-', '-', '-', '-', 0,'', @nReads, @MReads );
						end
					else
						begin						
							INSERT INTO @TEMPDATAPOUR1  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', @NextID, 'Tracker', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );
					  		INSERT INTO @TEMPDATA_POUR1_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', @NextID, 'EXTRALINE', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );
							INSERT INTO @TEMPDATA_POUR1_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', @NextID, 'Tracker', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );
						end
					if (@uniqid <> 0 and @Closeuniqid <> 0)
					begin
						UPDATE @TEMPDATAPOUR1  SET [POURCOUNT] = @PourCount WHERE [UNIQID] LIKE @Closeuniqid;  
						UPDATE @TEMPDATAPOUR1  SET [TIMEDIFF] = @TimeBetwArrives_C WHERE [UNIQID] LIKE @uniqid;  
						UPDATE @TEMPDATAPOUR1  SET [TIMEDIFF] = @TimeBetwArriveLeave_C WHERE [UNIQID] LIKE @Closeuniqid;  --Leave
						UPDATE @TEMPDATA_POUR1_EXTRALINE  SET [POURCOUNT] = @PourCount WHERE [UNIQID] LIKE @Closeuniqid;  
						UPDATE @TEMPDATA_POUR1_EXTRALINE  SET [TIMEDIFF] = @TimeBetwArrives_C WHERE [UNIQID] LIKE @uniqid;  
						UPDATE @TEMPDATA_POUR1_EXTRALINE  SET [TIMEDIFF] = @TimeBetwArriveLeave_C WHERE [UNIQID] LIKE @Closeuniqid;  --Leave
					end
				end
			else if( @value = ...)
				begin
					INSERT INTO @TEMPDATAPOUR2  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)),'-', @CurrentID, 'Tracker', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					INSERT INTO @TEMPDATA_POUR2_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', @CurrentID, 'EXTRALINE', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0 , @nAReads, @MAReads);
					INSERT INTO @TEMPDATA_POUR2_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', @CurrentID, 'Tracker', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					if(@Closeuniqid = 0)
						begin
							INSERT INTO @TEMPDATAPOUR2 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @NextDateUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @NextDateUTCDATE)), '-', '-', '-', '-', '-', '-', '-', 0,'', @nReads, @MReads );
							INSERT INTO @TEMPDATA_POUR2_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'EXTRALINE', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );
							INSERT INTO @TEMPDATA_POUR2_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES ('-', Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', '-', '-', '-', '-', '-', 0,'', @nReads, @MReads );
						end
					else
						begin
							INSERT INTO @TEMPDATAPOUR2  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', @NextID, 'Tracker', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );	 	 
							INSERT INTO @TEMPDATA_POUR2_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', @NextID, 'EXTRALINE', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );
							INSERT INTO @TEMPDATA_POUR2_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', @NextID, 'Tracker', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );	 	 
						end
					if (@uniqid <> 0 and @Closeuniqid <> 0)
					begin
						UPDATE @TEMPDATAPOUR2  SET [POURCOUNT] = @PourCount WHERE [UNIQID] LIKE @Closeuniqid;  
						UPDATE @TEMPDATAPOUR2  SET [TIMEDIFF] = @TimeBetwArrives_C WHERE [UNIQID] LIKE @uniqid;  
						UPDATE @TEMPDATAPOUR2  SET [TIMEDIFF] = @TimeBetwArriveLeave_C WHERE [UNIQID] LIKE @Closeuniqid;  --Leave
						UPDATE @TEMPDATA_POUR2_EXTRALINE  SET [POURCOUNT] = @PourCount WHERE [UNIQID] LIKE @Closeuniqid;  
						UPDATE @TEMPDATA_POUR2_EXTRALINE  SET [TIMEDIFF] = @TimeBetwArrives_C WHERE [UNIQID] LIKE @uniqid;  
						UPDATE @TEMPDATA_POUR2_EXTRALINE  SET [TIMEDIFF] = @TimeBetwArriveLeave_C WHERE [UNIQID] LIKE @Closeuniqid;  --Leave
					end
				end
			else --...
				begin
					INSERT INTO @TEMPDATA4430  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)),'-', @CurrentID, 'Tracker', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					INSERT INTO @TEMPDATA_CORE_S_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', @CurrentID, 'EXTRALINE', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					INSERT INTO @TEMPDATA_CORE_S_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@CurrentUTCDATE as datetime2(3)) as nvarchar(max)), '-', @CurrentID, 'Tracker', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nAReads, @MAReads);
					if(@Closeuniqid = 0)
						begin
							INSERT INTO @TEMPDATA4430 ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@uniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @NextDateUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @NextDateUTCDATE)), '-', '-', '-', '-', '-', '-', '-', 0,'', @nReads, @MReads );
							INSERT INTO @TEMPDATA_CORE_S_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', 'EXTRALINE', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );
							INSERT INTO @TEMPDATA_CORE_S_EXTRALINE ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES ('-', Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', '-', '-', '-', '-', '-', '-', 0,'', @nReads, @MReads );
						end
					else
						begin
							INSERT INTO @TEMPDATA4430  ([UNIQID], [UTCDATE], [LOCALTIME], [DAYNAME], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), Cast(cast(DATEADD(hour, @TimeAdded, @CurrentUTCDATE) as datetime2(3)) as nvarchar(max)), DATENAME(dw, DATEADD(hour, @TimeAdded, @CurrentUTCDATE)), '-', @NextID, 'Tracker', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );
							INSERT INTO @TEMPDATA_CORE_S_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', @NextID, 'EXTRALINE', 'ARRIVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );
							INSERT INTO @TEMPDATA_CORE_S_EXTRALINE  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', @NextID, 'Tracker', 'LEAVE', 'POS', cast(@value as varchar), '-', 0, 0, @nReads, @MReads );



							------------ check if we have a lock signal high -- CurrentDate = Arrive
							declare @thelockValue int
							SELECT @iMerged = COUNT( [MESSAGE]) FROM @TEMPDATA_IO where (UTCDATE between @CurrentUTCDATE and @NextDateUTCDATE) and [MESSAGE] = 4930 and [VALUE] = 1
							if(	@iMerged = 0)
							begin
								SELECT top 1 @thelockValue = [VALUE] FROM @TEMPDATA_IO where UTCDATE <= @CurrentUTCDATE and [MESSAGE] = 4930 order by UTCDATE desc
								if(	@thelockValue = 0)
								begin 
									INSERT INTO @TEMPDATA4430  ([UNIQID], [UTCDATE], [PCTYPE], [ID], [EVENT], [MESSAGE], [VALUETYPE], [VALUE], [PCSTATE], [POURCOUNT], [TIMEDIFF], [NREADS], [MREADS]) VALUES (@Closeuniqid, Cast(cast(@NextDateUTCDATE as datetime2(3)) as nvarchar(max)), '-', @NextID, 'Warning', 'No lock signal', 'POS', cast(@value as varchar), '-', 0, 0, 0, 0 );
								end
							end
							-------------
						end
					if (@uniqid <> 0 and @Closeuniqid <> 0)
					begin
						UPDATE @TEMPDATA4430  SET [POURCOUNT] = @PourCount WHERE [UNIQID] LIKE @Closeuniqid;  
						UPDATE @TEMPDATA4430  SET [TIMEDIFF] = @TimeBetwArrives_C WHERE [UNIQID] LIKE @uniqid;  
						UPDATE @TEMPDATA4430  SET [TIMEDIFF] = @TimeBetwArriveLeave_C WHERE [UNIQID] LIKE @Closeuniqid;  --Leave		
						UPDATE @TEMPDATA_CORE_S_EXTRALINE  SET [POURCOUNT] = @PourCount WHERE [UNIQID] LIKE @Closeuniqid;  
						UPDATE @TEMPDATA_CORE_S_EXTRALINE  SET [TIMEDIFF] = @TimeBetwArrives_C WHERE [UNIQID] LIKE @uniqid;  
						UPDATE @TEMPDATA_CORE_S_EXTRALINE  SET [TIMEDIFF] = @TimeBetwArriveLeave_C WHERE [UNIQID] LIKE @Closeuniqid;  --Leave					
					end
				end
		End --2

	set @TimeBetwArrives = NULL
	set @PourCount = 0
	set @NextDateUTCDATE = NULL 
	set @Closeuniqid = 0
	set @NextID = '--'
	set @nReads = 0
	set @mReads = 0
	set @CurrentUTCDATE = NULL
	set @CurrentID = '--'
	set @CurrentMessage = 0 
	set @value = 0
	set @nAReads = 0
	set @mAReads = 0
	set @uniqid = @uniqid + 1
 END

 
 print 'ReportTime: '+ cast(datediff (minute, @ReportstartTime, getdate()) as nvarchar(max))

 
 
 --select * from @TEMPDATAPOUR1 order by UTCDATE asc
 --select * from @TEMPDATAPOUR2 order by UTCDATE asc
  --select * from @TEMPDATA_IO  order by UTCDATE asc
  --select * from @TEMPDATA_PC  order by UTCDATE asc
 --select * from @TEMPDATA_CORE_S_EXTRALINE order by UTCDATE asc
 
 --select * from @TEMPDATA_POUR1_EXTRALINE where CHARINDEX('M', [ID]) <> 0 AND [MESSAGE] = 'LEAVE' order by UTCDATE asc
 --select * from @TEMPDATA_POUR2_EXTRALINE where CHARINDEX('M', [ID]) <> 0 AND [MESSAGE] = 'LEAVE' order by UTCDATE asc

 
insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [...$]') 
select * from @TEMPDATA4410 order by UTCDATE asc

insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [...$]') 
select * from @TEMPDATA4420 order by UTCDATE asc

insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [...$]') 
select * from @TEMPDATA4430 order by UTCDATE asc

insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [...$]') 
select * from @TEMPDATA4450 order by UTCDATE asc

insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [...$]') 
select * from @TEMPDATA4469 order by UTCDATE asc

insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [...$]') 
select * from @TEMPDATAPOUR1 order by UTCDATE asc

insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [Melts@...$]') 
select * from @TEMPDATAPOUR1 where CHARINDEX('_', [ID]) <> 0 AND [MESSAGE] = 'LEAVE' order by UTCDATE asc

insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [4472$]') 
select * from @TEMPDATAPOUR2 order by UTCDATE asc

insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [Melts@...$]') 
select * from @TEMPDATAPOUR2 where CHARINDEX('_', [ID]) <> 0 AND [MESSAGE] = 'LEAVE' order by UTCDATE asc

----EXTRALINE----
 insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [EXTRALINE_...$]') 
select * from @TEMPDATA_POUR1_EXTRALINE order by UTCDATE, THISUNIQID asc

insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [EXTRALINE_...$]') 
select * from @TEMPDATA_POUR2_EXTRALINE order by UTCDATE, THISUNIQID asc

insert into OPENROWSET(
'Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=...', 
'SELECT * FROM [EXTRALINE_...$]') 
select * from @TEMPDATA_CORE_S_EXTRALINE order by UTCDATE, THISUNIQID asc


set @loopcountings = 0
while(@loopcountings < 10)
begin
	WAITFOR DELAY '00:00:01'
	set @loopcountings = @loopcountings +1
	print cast (@loopcountings as nvarchar(max))
end

set @StartTime	= replace(substring(@StartTime,0,20),':','')
set @EndTime	= replace(substring(@EndTime,0,20),':','')
declare @NewFilename	varchar(500)
select @NewFilename='"..._'+cast(datediff (minute, @ReportstartTime, getdate()) as nvarchar(max))+'_'+ @StartTime + ' to '+ @EndTime +'  '+ replace(substring(cast(convert(datetime2, cast(getdate()as datetime), 113)  as nvarchar(max)), 0, 20), ':', '') + '.xlsm"'
print @NewFilename

SET @sql = 'COPY ' +@filepath + ' ' + @NewFilename;  
EXEC master.dbo.xp_cmdshell @sql; 
print @sql

