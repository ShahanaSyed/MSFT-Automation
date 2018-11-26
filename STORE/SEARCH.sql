
alter view [dbo].[vw.REPORT_STORE_WeeklyPacing_Search_SS]
as 
SELECT [Date]
		,[Campaign]
		,[Campaign Type]
      ,[A13 Region]
      ,[Country Name]
      ,[Product Category]
      ,[Budget Source]
      ,[Category]
      ,[Week Start]
      ,[Week End]
      ,[Week]
      ,[Month]
      ,[Quarter]
      ,[Channel]
      ,[Tactic]
      ,[Country]
      ,[CDS 17]
      ,[Media Lead Region]
      ,[Media Sync Group]
      ,[Search Engine][Partner]
	  ,[Audience]
       ,[View Units]
      ,[View Revenue]
      ,[View Orders]
      ,[Click Units]
      
	  ,[Impressions]
      ,[Clicks]
      ,[USD Spend]Spend

	  ,''[Click-Through Conversions]
	  ,''[View Through Conversions]

	  ,''[Adjusted Click Rev]

      ,[Total AMO Orders]
      ,[Total AMO Revenue]
FROM [dbo].[vw.REPORT_STORE_WeeklyPacing_AMO_SS]
union all
SELECT [Date]
		,[Campaign]
		,[Campaign Type]
		,[A13 Region]
		,[Country Name]
		,[Product Category]
		,[Budget Source]
		,[Category]
		,[Week Start]
		,[Week End]
		,[Week]
		,[Month]
		,[Quarter]
		,[Channel]
		,[Tactic]
		,[Country]
		,[CDS 17]
		,[Media Lead Region]
		,[Media Sync Group]
		,[Partner]
		,[Audience]
		,[View Units]
		,[ViewthroughRevenue][View Revenue]
		,''[View Orders]
		,[Adjusted Click Units][Click Units]

		,[Impressions]
		,[Clicks]
		,[Cost]Spend

		,[Adjusted Click Conversions][Click-Through Conversions]
		,[ViewthroughConversions][View Through Conversions]

		,[Adjusted Click Rev]
		,''[Total AMO Orders]
		,''[Total AMO Revenue]
  FROM [dbo].[vw.REPORT_STORE_WeeklyPacing_DCMSearch_SS]
GO

---------------------------------------------------------------------------
--select   sum([Units])[Units]
--      ,sum([ClickthroughConversions])[ClickthroughConversions]
--      ,sum([ViewthroughConversions])[ViewthroughConversions]
--      ,sum([ClickthroughRevenue])[ClickthroughRevenue]
--      ,sum([ViewthroughRevenue])[ViewthroughRevenue] from [dbo].[vw.REPORT_STORE_WeeklyPacing_DCMSearch_SS] where date ='8/5/2018'
--12193	293718	49806	33176019	218439566.82


alter view [dbo].[vw.REPORT_STORE_WeeklyPacing_DCMSearch_SS]
as
SELECT ([Date])
      ,[Campaign]
	  ,case when Campaign like '%_ASUS_%' then 'ASUS Co-Marketing' 
			when Campaign like '%_Dell_%' then 'Dell Co-Marketing' 
			when Campaign like '%_HP_%' then 'HP Co-Marketing' 
			when Campaign like '%_Huawei_%' then 'Huawei Co-Marketing'
			when Campaign like '%_Lenovo_%' then 'Lenovo Co-Marketing'  
			when Campaign like '%Incremental%' then 'Incremental'
			when campaign like '%_WINDOWS DEVICES_%' then 'Incremental'
			else 'Evergreen' end [Campaign type]
      ,[Publisher]
      ,[A13 Region]
      ,[Country]
	  ,Market
      ,[Country Name]
      ,[CDS 17]
      ,[Media Lead Region]
      ,[Media Sync Group]
      ,[Product Category]
	  ,Category
      ,[Budget Source]
	  ,[Week Start]
	  ,[Week End]
	  ,[Week Number]
	  ,CONCAT('Week ',[Week Number],' (',[Week Start],'-',[Week End],')')[Week]
      ,[Month]
      ,[Quarter]
      ,[Channel]
      ,[Tactic]
      ,[Partner]
	  ,[Audience]
      ,sum([CurrencyPerUSD])[CurrencyPerUSD]
      ,'0'[View Units]
      ,'0'[Impressions]
      ,'0'[Clicks]
	  ,'0'[Cost]
      ,sum([ClickthroughConversions])[ClickthroughConversions]
      ,sum([ViewthroughConversions])[ViewthroughConversions]
      ,sum([ClickthroughRevenue])[ClickthroughRevenue]
      ,sum([ViewthroughRevenue])[ViewthroughRevenue]
      ,sum([Units])[Units]
      ,sum([USD Click Revenue])[USD Click Revenue]
      ,sum([Units Temp Fix])[Units Temp Fix]
	  ,CASE WHEN [Product Category] = 'Surface' AND [Country Name]='United States' THEN 0.87*sum([ClickthroughConversions]) ELSE sum([ClickthroughConversions]) END [Adjusted Click Conversions]  
	  ,CASE WHEN [Product Category] = 'Surface' AND [Country Name]='United States' THEN 0.87*sum([Units Temp Fix]) ELSE sum([Units Temp Fix]) END [Adjusted Click Units]
	  ,CASE WHEN [Product Category] = 'Surface' AND [Country Name]='United States' THEN 0.87*sum([USD Click Revenue]) ELSE sum([USD Click Revenue]) END [Adjusted Click Rev]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_DCMSearch3_SS]
  group by ([Date])
      ,[Campaign]
      ,[Publisher]
      ,[A13 Region]
      ,[Country]
	  ,Market
      ,[Country Name]
      ,[CDS 17]
      ,[Media Lead Region]
      ,[Media Sync Group]
      ,[Product Category]
	  ,category
      ,[Budget Source]
	  ,[Week Start]
	  ,[Week End]
	  ,[Week Number]
      ,[Month]
      ,[Quarter]
      ,[Channel]
      ,[Tactic]
      ,[Partner]
	  ,Audience
GO


--select sum([Units Temp Fix]),sum([Adjusted Click Conversions]),sum([Adjusted Click Units]),sum([Adjusted Click Rev]) from [vw.REPORT_STORE_WeeklyPacing_DCMSearch_SS] where [Date] ='7/15/2018'
--1452 895.46  1411.57  278265.933

----------------------------------------------------
--select   sum([Units])[Units]
--      ,sum([ClickthroughConversions])[ClickthroughConversions]
--      ,sum([ViewthroughConversions])[ViewthroughConversions]
--      ,sum([ClickthroughRevenue])[ClickthroughRevenue]
--      ,sum([ViewthroughRevenue])[ViewthroughRevenue] from [dbo].[vw.STAGING_STORE_WeeklyPacing_DCMSearch3_SS] where date ='8/5/2018'
--12193	293718	49806	33176019	218439566.82

alter view [dbo].[vw.STAGING_STORE_WeeklyPacing_DCMSearch3_SS]
AS
SELECT ([Date])
      ,[Campaign]
      ,[Publisher]
      ,a.[Market]
	  ,[A13 Region]
	  ,[ISO 3-Letter Country Code]Country
	  ,[Country Name]
	  ,[CDS 17]
	  ,[Media Lead Region]
	  ,[Media Sync Group]
	  , CASE WHEN a.[Campaign] like '%BRAND%' THEN 'Brand'
				WHEN a.[Campaign] = 'DAN_STORE_MUL_MUL_HARMAN KARDON_SEARCH' THEN 'Other'
				when a.Campaign like '%WINDOWS SOFTWARE%' then 'Windows Software'
				WHEN a.[Campaign] like '%SURFACE%' THEN 'Surface'
				WHEN a.[Campaign] like '%WINDOWS DEVICES%' THEN 'Windows Devices'
				WHEN a.[Campaign] like '%XBOX DESIGN%' THEN 'XBox Design Lab'
				WHEN a.[Campaign] like '%LIVEGOLD%' THEN 'Xbox Live Gold'
				WHEN a.[Campaign] like '%PLATFORM%' THEN 'Xbox Platform'
				END [Product Category]
		,CASE	WHEN a.campaign like '%_BRAND_%' THEN 'Brand'
				WHEN a.campaign = 'HoloLens' THEN 'HoloLens'
				WHEN a.campaign like 'Office%' THEN 'Office'
				WHEN a.campaign like 'Harman Kardon%' or a.campaign like '%_HARMAN KARDON_%' THEN 'Other'
				WHEN a.campaign like '%_SOFTWARE_%' THEN 'Software'
				WHEN a.campaign like '%_SURFACE_%' THEN 'Surface'
				WHEN a.campaign like '%_WINDOWS SOFTWARE_%' THEN 'Windows Software'
				WHEN a.campaign like '%_XBOX LIVEGOLD_%' THEN 'Xbox Live Gold'
				WHEN a.campaign like '%_XBOX DESIGN LAB_%' THEN 'Xbox Design Lab'
			--	when Portfolio = 'Co-Op PLACEHOLDER' then 'Windows Devices'
				WHEN a.campaign like '%_XBOX PLATFORM %' THEN 'Xbox Platform'
		END [Category]
		,''Audience
		,case when a.Campaign like '%_ASUS_%' or a.Campaign like '%_Dell_%' or Campaign like '%_HP_%' or Campaign like '%_Huawei_%' or Campaign like '%_Lenovo_%' or Campaign like '%Incremental%' or campaign like '%Windows Devices%' then 'Incremental'
				else 'TAC' end [Budget Source]
		,replace((convert(varchar,(DATEADD(dd, -(DATEPART(dw, [Date])-1), [Date])),1)),'/','.') [Week Start]
		,replace((convert(varchar,(DATEADD(dd, 7-(DATEPART(dw, [Date])), [Date])),1)),'/','.')  [Week End]
		--	  ,((DATEPART("ww",[Date]) - DATEPART("ww",DATEADD("d", -DAY([Date]) + 1, [Date]))) + 1) [Week Number]
		,right(([dbo].[FiscalWeek]('07',[Date])),2) [Week Number]
		,case when month([Date]) = 1 then 'Jan'
					when month([Date]) = 2 then 'Feb'
					when month([Date]) = 3 then 'Mar'
					when month([Date]) = 4 then 'Apr'
					when month([Date]) = 5 then 'May'
					when month([Date]) = 6 then 'Jun'
					when month([Date]) = 7 then 'Jul'
					when month([Date]) = 8 then 'Aug'
					when month([Date]) = 9 then 'Sep'
					when month([Date]) = 10 then 'Oct'
					when month([Date]) = 11 then 'Nov'
					when month([Date]) = 12 then 'Dec'
					end [Month]
		,case	when month([Date]) = 7 OR month([Date]) = 8 OR month([Date]) = 9 then 'Q1'
					when month([Date]) = 10 OR month([Date]) = 11 OR month([Date]) = 12 then 'Q2'
					when month([Date]) = 1 OR month([Date]) = 2 OR month([Date]) = 3 then 'Q3'
					when month([Date]) = 4 OR month([Date]) = 5 OR month([Date]) = 6 then 'Q4'
					END[Quarter]
		, CASE WHEN RIGHT(a.[Campaign],3)='PLA' THEN 'PLA'
				WHEN a.[Campaign] like '%SEARCH%' AND a.[Campaign] not like '%SEARCH PLA%' THEN 'SEM'
				END [Channel]
		, CASE WHEN RIGHT(a.[Campaign],3)='PLA' THEN 'PLA'
				WHEN a.[Campaign] like '%SEARCH%' AND a.[Campaign] not like '%SEARCH PLA%' THEN 'SEM'
				else 'SEM'
				END [Tactic]
		, CASE  WHEN right(a.[Campaign],5) = 'BAIDU' THEN 'Baidu'
				WHEN right(a.[Campaign],3) = '360' THEN 'C360'
				WHEN right(a.[Campaign],5) = 'SOGOU' THEN 'Sogou'
				WHEN right(a.[Campaign],5) like '%Baidu%' THEN 'Baidu'
				--else 'Other'
				END [Partner]
	  ,sum(([CurrencyPerUSD]))[CurrencyPerUSD]
      ,sum(([ClickthroughConversions]))[ClickthroughConversions]
      ,sum(([ViewthroughConversions]))[ViewthroughConversions]
      ,sum(([ClickthroughRevenue]))[ClickthroughRevenue]
      ,sum(([ViewthroughRevenue]))[ViewthroughRevenue]
      ,sum(([Units]))[Units]
	  ,(sum([ClickthroughRevenue])/sum([CurrencyPerUSD]))[USD Click Revenue]
 		,CASE WHEN (a.[Market]='HK' OR a.[Market]='CN') AND [Date]<[Date] THEN sum([ClickthroughConversions]) ELSE sum([Units]) END [Units Temp Fix]
	FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_DCMSearch2_SS] a
	left join(select * from [dbo].[CurrencyConversions] where [Market] is not null) b
	on a.[Market]=b.[Market]
--	and a.currencycode=b.[ISO 3-Letter Country Code] 
	group by ([Date])
		,[Campaign]
		,a.[Market]
		,[Publisher]
		,[A13 Region]
		,[ISO 3-Letter Country Code]
		,[Country Name]
		,[CDS 17]
		,[Media Lead Region]
		,[Media Sync Group]


GO
-------------------------------------------------------------------------
alter view [dbo].[vw.STAGING_STORE_WeeklyPacing_DCMSearch2_SS]
as
SELECT [Date]
      ,[Campaign]
      ,[CampaignID]
      ,[Publisher]
      ,[PlacementID]
      ,[Placement]
      ,[Market]
      ,[CurrencyCode]
      ,sum([Units])[Units]
      ,sum([ClickthroughConversions])[ClickthroughConversions]
      ,sum([ViewthroughConversions])[ViewthroughConversions]
      ,sum([ClickthroughRevenue])[ClickthroughRevenue]
      ,sum([ViewthroughRevenue])[ViewthroughRevenue]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_DCMSearch1_SS]
  group by [Placement]
		,[Date]
        ,[Campaign]
		,[CampaignID]
		,[Publisher]
		,[PlacementID]
		,[Placement]
		,[Market]
		,[CurrencyCode]
GO

--select   sum([Units])[Units]
--      ,sum([ClickthroughConversions])[ClickthroughConversions]
--      ,sum([ViewthroughConversions])[ViewthroughConversions]
--      ,sum([ClickthroughRevenue])[ClickthroughRevenue]
--      ,sum([ViewthroughRevenue])[ViewthroughRevenue] from [dbo].[vw.STAGING_STORE_WeeklyPacing_DCMSearch2_SS] where date ='8/5/2018'
--12193	293718	49806	33176019	218439566.82

----------------------------------------------------


alter VIEW [dbo].[vw.STAGING_STORE_WeeklyPacing_DCMSearch1_SS]
as
select r.[dataDate] Date
		,r.[Activity]
		,r.[ActivityID]
       ,r.[Campaign]
       ,r.[CampaignID]
       ,r.[SiteDCM]Publisher
	   ,r.[PlacementID]
       ,r.[Placement]
	   ,u.[Marketstring] [Market]
	   ,u.[CurrencyCodestring] CurrencyCode
	--   ,'0'[View Units]
	  	,sum(cast(u.Unitsstring as numeric (3,0))) Units
		,sum(r.[ClickthroughConversions]) [ClickthroughConversions]
		,sum(r.[ViewthroughConversions]) [ViewthroughConversions]
		,sum(r.[ClickthroughRevenue]) [ClickthroughRevenue]
		,sum(r.[ViewthroughRevenue]) [ViewthroughRevenue]
	   from [Fact].[dcmFloodlightRawData] r
right join [Fact].[dcmFloodlightUVariables] u
       on r.[ActivityID] = u.[ActivityID]
       and r.[CampaignID] = u.[CampaignID]
       and r.[PlacementID] = u.[PlacementID]
     -- and r.[CreativeID] = u.[CreativeID]
	   and r.[AdvertiserID]=u.AdvertiserID
	   and r.[SiteIDDCM]=u.SiteIDDCM
	   and r.AdID = u.AdID
       and r.[ActivityDateTime] = u.[ActivityDateTime]
where r.Activity in ('Surface_GBL_PchComplete_Transaction_PhysicalStore','Surface_GBL_PchComplete_Transaction_PhysicalStore',
			'XboxLiveGold_GBL_PchComplete_Transaction_PhysicalStore','Software_GBL_PchComplete_Transaction_PhysicalStore',
			'Store-Other_GBL_PchComplete_Transaction_PhysicalStore','XboxPlatform_GBL_PchComplete_Transaction_PhysicalStore',
			'WindowsSoftware_GBL_PchComplete_Transaction_PhysicalStore','XboxDesignLab_GBL_PchComplete_Transaction_PhysicalStore','WindowsDevices_GBL_PchComplete_Transaction_PhysicalStore')
		AND r.[CampaignID] in ('20945190','20891688','20889960','20945190','20895061','20850745','20877587','20891139','20886605',
			'20943620','20890831','20943662','20937312','20964507','20889963','20885750','20885687','20891115','20885726','20944211',
			'20947506','20888430') 
        and u.[dataDate] between '7/1/2018' AND cast(DATEADD(day,-1 - (DATEPART(weekday, GETDATE()) + @@DATEFIRST - 2) % 6,GETDATE()) as date)
group by r.[dataDate] 
		,r.[Activity]
		,r.[ActivityID]
		,r.[Campaign]
		,r.[CampaignID]
		,r.[SiteDCM]
		,r.[PlacementID]
		,r.[Placement]
		,u.[Marketstring] 
		,u.[CurrencyCodestring] 
go



--------------AMO---------------------------AMO--------------------------------AMO--------------------------------------
--	

--select sum(impressions),sum(clicks),sum([avg position]),sum([AA Revenue (MSFTEnterpriseStoreProd) (CT+VT)]),sum([AA Orders (MSFTEnterpriseStoreProd) (CT+VT)]),
--sum([SeaHkOrders]), sum([NaCaClvRevenue]),sum([NaCaOrders]),sum([NaUsClvRevenue]),sum(nausorders) from [dbo].[vw.STAGING_STORE_WeeklyPacing_AMO3_SS] where [date]='7/15/2018'
--2253416	137311	14726.5	424824.409999999	3927	0.000000	33870.04	97.000000	210691.89	1381
--SET DATEFIRST 7

alter view [dbo].[vw.REPORT_STORE_WeeklyPacing_AMO_SS]
as
SELECT ([Start Date]) [Date]
      ,a.[A13 Region]
      ,a.[Country] [Country Name]
	  ,[Product Category]
	  ,case when a.Campaign like '%_ASUS_%' or a.Campaign like '%_Dell_%' or Campaign like '%_HP_%' or Campaign like '%_Huawei_%' or Campaign like '%_Lenovo_%' or Campaign like '%Incremental%' then 'Incremental'
		else 'TAC' end [Budget Source]
	  ,CASE	WHEN [Portfolio] like 'Brand%' THEN 'Brand'
			WHEN [Portfolio] = 'HoloLens' THEN 'HoloLens'
			WHEN [Portfolio] like 'Office%' THEN 'Office'
			WHEN [Portfolio] like 'Harman Kardon%' or a.campaign like '%_HARMAN KARDON_%' THEN 'Other'
			WHEN [Portfolio] like 'Software%' THEN 'Software'
			WHEN [Portfolio] like 'Surface%' THEN 'Surface'
			WHEN [Portfolio] like 'Windows%' THEN 'Windows Software'
			WHEN [Portfolio] like 'Xbox Live%' THEN 'Xbox Live Gold'
			WHEN [Product Category] = 'XDL' THEN 'Xbox Design Lab'
			when Portfolio = 'Co-Op PLACEHOLDER' then 'Windows Devices'
			WHEN [Portfolio] like 'Xbox Games%' OR [Portfolio] like 'Xbox Consoles%' OR [Portfolio] like 'Xbox (%' THEN 'Xbox Platform'

			END [Category]
		,case	when [Campaign] like '%_RLSA%' then 'Remarketing Lists for Search Ads'
				else 'Standard Search Ads'
				end Audience
		,[Week Start]
		,[Week End]
	    ,CONCAT('Week ',[Week Number],' (',[Week Start],'-',[Week End],')')[Week]
		,case		when month([Start Date]) = 1 then 'Jan'
					when month([Start Date]) = 2 then 'Feb'
					when month([Start Date]) = 3 then 'Mar'
					when month([Start Date]) = 4 then 'Apr'
					when month([Start Date]) = 5 then 'May'
					when month([Start Date]) = 6 then 'Jun'
					when month([Start Date]) = 7 then 'Jul'
					when month([Start Date]) = 8 then 'Aug'
					when month([Start Date]) = 9 then 'Sep'
					when month([Start Date]) = 10 then 'Oct'
					when month([Start Date]) = 11 then 'Nov'
					when month([Start Date]) = 12 then 'Dec'
					end [Month]
			,case	when month([Start Date]) = 7 OR month([Start Date]) = 8 OR month([Start Date]) = 9 then 'Q1'
					when month([Start Date]) = 10 OR month([Start Date]) = 11 OR month([Start Date]) = 12 then 'Q2'
					when month([Start Date]) = 1 OR month([Start Date]) = 2 OR month([Start Date]) = 3 then 'Q3'
					when month([Start Date]) = 4 OR month([Start Date]) = 5 OR month([Start Date]) = 6 then 'Q4'
					END[Quarter]
			, CASE	WHEN Campaign like '%_PLA_%' THEN 'PLA'
					WHEN Campaign like '%_SEM_%'  or Portfolio like 'Brand%' or [DCM Label] like '%SEM' THEN 'SEM'
				END [Channel]
			, CASE	WHEN Campaign like '%_PLA_%'  THEN 'PLA' else 'SEM'
				--	WHEN Campaign like '%_SEM_%'  or Portfolio like 'Brand%'or [DCM Label] like '%SEM' THEN 'SEM'
				--else 'SEM'
				END [Tactic]
		  ,[ISO 3-Letter Country Code] [Country]
	      ,[CDS 17]
	      ,[Media Lead Region]
	      ,[Media Sync Group]
          ,[Portfolio]
          ,[Campaign]
		  ,case --when Campaign like '%_ASUS_%' then 'ASUS Co-Marketing' 
				when Campaign like '%_ASUS_%' then 'Intel Co-Marketing: ASUS' --new changes 11/9/2018
				when Campaign like '%_Dell_%' then 'Intel Co-Marketing: Dell' 
				when Campaign like '%_HP_%' then 'Intel Co-Marketing: HP' 
				when Campaign like '%_Huawei_%' then 'Intel Co-Marketing: Huawei'
				when Campaign like '%_Lenovo_%' then 'Intel Co-Marketing: Lenovo'  
				when Campaign like '%Incremental%' then 'Incremental'
				else 'Evergreen' end [Campaign type]
          ,[Search Engine]
          ,[DCM Label]
	      ,'0'[View Units]
		  ,'0'[View Revenue]
		  ,'0'[View Orders]
		  ,'0'[Click Units]
		  ,CASE  WHEN [Portfolio] like '%YJP%' THEN [Cost]/108.95 
					WHEN [Portfolio] like '%Naver%' THEN [Cost]/1124.11 
						ELSE [Cost] END [USD Spend]
		  ,sum(([Impressions]))[Impressions]
		  ,sum(([Clicks]))[Clicks]
		  ,sum(([Cost]))[Cost]
		  ,sum(([Avg Position]))[Avg Position]
		  ,sum(([AA Revenue (MSFTEnterpriseStoreProd) (CT+VT)]))[AA Revenue (MSFTEnterpriseStoreProd) (CT+VT)]
		  ,sum(([AA Orders (MSFTEnterpriseStoreProd) (CT+VT)]))[AA Orders (MSFTEnterpriseStoreProd) (CT+VT)]
		  ,sum(([SeaHkOrders]))[SeaHkOrders]
		  ,sum(([WeUkClvRevenue]))[WeUkClvRevenue]
		  ,sum(([WeUkOrders]))[WeUkOrders]
		  ,sum(([NaCaClvRevenue]))[NaCaClvRevenue]
		  ,sum(([NaCaOrders]))[NaCaOrders]
		  ,sum(([NaUsClvRevenue]))[NaUsClvRevenue]
		  ,sum(([NaUsOrders]))[NaUsOrders]
		 ,CASE  WHEN [Portfolio] like '%XDL%' THEN ([WeUkOrders]+[NaCaOrders]+[NaUsOrders]) 
				WHEN [Portfolio] not like '%XDL%' and [Product Category] = 'Surface' AND [ISO 3-Letter Country Code]='USA' THEN [AA Orders (MSFTEnterpriseStoreProd) (CT+VT)]*0.87 
				ELSE [AA Orders (MSFTEnterpriseStoreProd) (CT+VT)]
				END [Total AMO Orders]
		 ,CASE  WHEN [Portfolio] like '%XDL%' THEN ([NaUsClvRevenue]+[NaCaClvRevenue]/1.33+[WeUkClvRevenue]/0.78125) 
				WHEN [Portfolio] not like '%XDL%' and [Product Category] = 'Surface' AND [ISO 3-Letter Country Code]='USA' THEN  [AA Revenue (MSFTEnterpriseStoreProd) (CT+VT)]*0.87 
				ELSE [AA Revenue (MSFTEnterpriseStoreProd) (CT+VT)]
				END [Total AMO Revenue]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_AMO2_SS]a
 left join [dbo].[CurrencyConversions] b
  on a.[Country]=b.[Country Name]
group by [Portfolio]
		,[Channel]
		,[Campaign]
		,[Search Engine]
		,[DCM Label]
		,[Country]
		,a.[A13 Region]
		,[Product Category]
		,[Start Date]
		,[Week Start]
		,[Week End]
		,[Week Number]
		,[ISO 3-Letter Country Code]
		,[CDS 17]
		,[Media Lead Region]
		,[Media Sync Group]
	  --  ,[Device]
	,CASE  WHEN [Portfolio] like '%YJP%' THEN [Cost]/108.95 
			WHEN [Portfolio] like '%Naver%' THEN [Cost]/1124.11 
			ELSE [Cost] END 
	,CASE  WHEN [Portfolio] like '%XDL%' THEN ([WeUkOrders]+[NaCaOrders]+[NaUsOrders]) 
			WHEN [Portfolio] not like '%XDL%' and [Product Category] = 'Surface' AND [ISO 3-Letter Country Code]='USA' THEN [AA Orders (MSFTEnterpriseStoreProd) (CT+VT)]*0.87 
			ELSE [AA Orders (MSFTEnterpriseStoreProd) (CT+VT)]
			END 
 	,CASE  WHEN [Portfolio] like '%XDL%' THEN ([NaUsClvRevenue]+[NaCaClvRevenue]/1.33+[WeUkClvRevenue]/0.78125) 
			WHEN [Portfolio] not like '%XDL%' and [Product Category] = 'Surface' AND [ISO 3-Letter Country Code]='USA' THEN  [AA Revenue (MSFTEnterpriseStoreProd) (CT+VT)]*0.87 
			ELSE [AA Revenue (MSFTEnterpriseStoreProd) (CT+VT)]
			END
	GO
--select sum(clicks),sum([Impressions]),sum(Cost),sum([USD Spend]),sum([Total AMO Orders]),sum([Total AMO Revenue]) from  [dbo].[vw.QA_STORE_WeeklyPacing_AMO_SS]  where [Date] = '10/1/2018'
------------------------------------------------------------------------------------
alter view [dbo].[vw.STAGING_STORE_WeeklyPacing_AMO2_SS] 
as
SELECT [Campaign]
      ,[Search Engine]
      ,[Start Date]
      ,[Channel]
      ,[A13 Region]
      ,[Country]
      ,[Portfolio]
      ,[Week Start]
      ,[Week End]
      ,[Week Number]
      ,[DCM Label]
      ,[Product Category]
      ,[Impressions]
      ,[Clicks]
      ,[Cost]
      ,[Avg Position]
      ,[AA Revenue (MSFTEnterpriseStoreProd) (CT+VT)]
      ,[AA Orders (MSFTEnterpriseStoreProd) (CT+VT)]
      ,[SeaHkOrders]
      ,[WeUkClvRevenue]
      ,[WeUkOrders]
      ,[NaCaClvRevenue]
      ,[NaCaOrders]
      ,[NaUsClvRevenue]
      ,[NaUsOrders]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_AMO1_SS]
GO


--------------------------------------------------------------------

alter view [dbo].[vw.STAGING_STORE_WeeklyPacing_AMO1_SS] 
as
select distinct(Campaign)
				,[SearchEngine] [Search Engine]
				,([StartDate]) [Start Date] 
				,[Channel]
				,iif([Market] is null, 'US',[Market]) [A13 Region]
				,iif([Country] is null, 'United States',[Country]) [Country]
				,[Portfolio]
				,replace((convert(varchar,(DATEADD(dd, -(DATEPART(dw, [StartDate])-1), [StartDate])),1)),'/','.') [Week Start]
				,replace((convert(varchar,(DATEADD(dd, 7-(DATEPART(dw, [StartDate])), [StartDate])),1)),'/','.')  [Week End]
			--	,((DATEPART("ww",[StartDate]) - DATEPART("ww",DATEADD("d", -DAY([StartDate]) + 1, [StartDate]))) + 1) [Week Number]
				,right(([dbo].[FiscalWeek]('07',[StartDate])),2) [Week Number]
				,[DCMLabel] [DCM Label]
				,iif([ProductCategory] is null,'Other',[ProductCategory])[Product Category]
				,sum(([Impressions]))[Impressions]
				,sum(([Clicks]))[Clicks]
				,sum(([Cost]))[Cost]
				,sum(([AvgPosition])) [Avg Position]
				,sum(([AARevenueMSFTEnterpriseStoreProdCTPlusVT]))[AA Revenue (MSFTEnterpriseStoreProd) (CT+VT)]
				,sum(([AAOrdersMSFTEnterpriseStoreProdCTPlusVT]))[AA Orders (MSFTEnterpriseStoreProd) (CT+VT)]
				,sum((cast([SeaHkOrders] as numeric(8,6)))) [SeaHkOrders]
				,sum(CAST(REPLACE([WeUkClvRevenue],',','') as Float)) [WeUkClvRevenue]
				,sum(cast([WeUkOrders] as numeric(4,0))) [WeUkOrders]
			    ,sum(CAST(REPLACE([NaCaClvRevenue],',','') as Float)) [NaCaClvRevenue]
				,sum(cast([NaCaOrders] as numeric(8,6))) [NaCaOrders]
			    ,sum(CAST(REPLACE([NaUsClvRevenue],',','') as Float)) [NaUsClvRevenue]
				,sum(cast([NaUsOrders] as numeric(4,0))) [NaUsOrders]
				from [Fact].[AMORawData] 
				where [StartDate] between '7/1/2018' AND cast(DATEADD(day,-1 - (DATEPART(weekday, GETDATE()) + @@DATEFIRST - 2) % 6,GETDATE()) as date)
									and Portfolio not like 'Office%'
									and Portfolio is not null
									and [Campaign] not in ('CAN_gaPMG_STR_SEM_PCs_B_English_Dell_Incremental_STD_Exact_NA_Google_ALL'
															,'CAN_gaPMG_STR_SEM_PCs_B_French_Dell_Incremental_STD_Exact_NA_Google_ALL','USA_ngaRBTL_STR_SEM_Razer_B_OEM_Blade_Product_BMM_NA_Google_ALL'
															,'USA_ngaRBTL_STR_SEM_Razer_B_OEM_Blade_Product_Exact_NA_Bing_ALL','USA_ngaRBTL_STR_SEM_Razer_B_OEM_Blade_Product_Exact_NA_Google_ALL')
									and Campaign not like '%Razer%' 
									and Campaign not like '%Samsung%'
									and campaign not like '%_Age of Empires_%'
									and campaign not like '%_Countdown to 2018_%'
				group by [Country] 
						,[SearchEngine]
						,[Campaign]
						,[Portfolio]
						,[ProductCategory] 
						,[DCMLabel] 
						,[Channel]
						,[Market] 
						,[StartDate]
go    

