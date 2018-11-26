
alter view [vw.REPORT_STORE_WeeklyPacing_Social_SS]
as
SELECT a.[Date]
		,a.Campaign
		,a.[Campaign Type]
		,a.[Publisher]
		,a.[Placement]
		,a.[Country]
		,a.[Market]
		,a.[A13 Region]
		,a.[Country Name]
		,a.[CDS 17]
		,a.[Media Lead Region]
		,a.[Media Sync Group]
		,a.[Week Start]
		,a.[Week End]
		,a.[Week]
		,a.[Week Number]
		,a.[Month]
		,a.[Quarter]
		,a.[Channel]
		,a.[Tactic]
		,a.[Audience]
		,a.[Partner]
		,a.[Budget Source]
		,a.[Product Category]
		,sum(a.[Impressions])[Impressions]
		,sum([Spend])[Spend]
		,sum([Website Purchases - 7 Days After View])[Website Purchases - 7 Days After View]
		,sum([Website Purchases Conversion Value - 7 Days After View])[Website Purchases Conversion Value - 7 Days After View]
		,sum(distinct([45% View Purchases]))[45% View Purchases]
		,sum(distinct([45% View "Units"]))[45% View "Units"]
		,sum(distinct([45% View Revenue]))[45% View Revenue]
		,sum(distinct(isnull([Clicks],0)))[Clicks]
		,sum(distinct(isnull([Click-Through Conversions],0)))[Click-Through Conversions]
		,sum(distinct(isnull([USD View Revenue 45%],0)))[USD View Revenue 45%]
		,sum(distinct(isnull([USD Click Revenue],0)))[USD Click Revenue]
		,sum(distinct(isnull([View-Through Conversions 45%],0)))[View-Through Conversions 45%]
		,sum(distinct(isnull([Click Through Units],0)))[Click Through Units]
		,sum(distinct(isnull([View Through Units 45%],0)))[View Through Units 45%]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB6_SS] a
  left join [vw.STAGING_STORE_WeeklyPacing_SocialDCM8_SS] b
  on a.Date=b.Date
  and a.Placement = b.Placement
  group by a.[Date]
      ,a.[Placement]
	,a.Campaign
	,a.[Campaign Type]
      ,a.[Publisher]
      ,a.[Country]
      ,a.[Market]
      ,a.[A13 Region]
      ,a.[Country Name]
      ,a.[CDS 17]
      ,a.[Media Lead Region]
      ,a.[Media Sync Group]
      ,a.[Week Start]
      ,a.[Week End]
      ,a.[Week]
      ,a.[Week Number]
      ,a.[Month]
      ,a.[Quarter]
      ,a.[Channel]
      ,a.[Tactic]
      ,a.[Audience]
      ,a.[Partner]
      ,a.[Budget Source]
      ,a.[Product Category]
GO


------------------------------------------------------------------------------

alter view [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB6_SS]
as
SELECT [Date]
		,Campaign
		,case when Campaign like '%COM Intel' then 'Intel Co-Marketing' 
				when Campaign like '%COM Lenovo%' then 'Lenovo Co-Marketing'
				when Campaign like '%Back to School' then 'Back to School - Physical'
				when Campaign like '%Ultimate Games Sale' then 'Ultimate Games Sale - Digital'
				when Campaign like '%Deezer' then 'Deezer Digital Goods'
				else 'Evergreen' end [Campaign type]
	  ,[Publisher]
      ,[Placement]
      ,[Country]
      ,[Market]
      ,[A13 Region]
      ,[Country Name]
      ,[CDS 17]
      ,[Media Lead Region]
      ,[Media Sync Group]
      ,[Week Start]
      ,[Week End]
	  ,CONCAT('Week ',[Week Number],' (',[Week Start],'-',[Week End],')')[Week]
      ,[Week Number]
      ,[Month]
      ,[Quarter]
      ,[Channel]
      ,[Tactic]
      ,[Audience]
      ,[Partner]
      ,[Budget Source]
      ,[Product Category]
      ,sum([Impressions])[Impressions]
      ,sum([Spend])[Spend]
      ,sum(isnull([Website Purchases - 7 Days After View],0))[Website Purchases - 7 Days After View]
      ,sum(isnull([Website Purchases Conversion Value - 7 Days After View],0))[Website Purchases Conversion Value - 7 Days After View]
      ,sum(isnull([45% View Purchases],0))[45% View Purchases]
      ,sum(isnull([45% View "Units"],0))[45% View "Units"]
      ,sum(isnull([45% View Revenue],0))[45% View Revenue]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB5_SS]
  group by [Date]
		,[Placement]
		,campaign
	  ,[Publisher]
      ,[Placement]
      ,[Country]
      ,[Market]
      ,[A13 Region]
      ,[Country Name]
      ,[CDS 17]
      ,[Media Lead Region]
      ,[Media Sync Group]
      ,[Week Start]
      ,[Week End]
	  ,CONCAT('Week ',[Week Number],' (',[Week Start],'-',[Week End],')')
      ,[Week Number]
      ,[Month]
      ,[Quarter]
      ,[Channel]
      ,[Tactic]
      ,[Audience]
      ,[Partner]
      ,[Budget Source]
      ,[Product Category]
GO


-----------------------------------------------------------------

alter VIEW [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB5_SS]
AS
SELECT a.[Date]
		,a.Campaign
		,case when [Placement] like 'FACEBOOK%' then 'Facebook Inc'
			 when Placement like 'INSTAGRAM%' then 'Instagram' 
			 end [Publisher]
		,a.[Placement]
		,a.[Country]
		,[Market]
		,[A13 Region]
		,[Country Name]
		,[CDS 17]
		,[Media Lead Region]
		,[Media Sync Group]
		,replace((convert(varchar,(DATEADD(dd, -(DATEPART(dw, a.[Date])-1), a.[Date])),1)),'/','.') [Week Start]
	    ,replace((convert(varchar,(DATEADD(dd, 7-(DATEPART(dw, a.[Date])), a.[Date])),1)),'/','.')  [Week End]
		,right(([dbo].[FiscalWeek]('07',a.Date)),2) [Week Number]
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
				END	[Quarter]
		,'Social' Channel
		, case	when [Placement] like '%Graduation%' then 'Prospecting - Graduation'
				when [Placement] like '%Cross Sell%' then 'Cross Sell'
				when [Placement] like '%GA Video Retargeting%' or [Placement] like '%»PRO»%'  then 'Prospecting'
				when [Placement] like '%»LAL»%' or Placement like '%LAL%' then 'Lookalike'
				when [Placement] like '%»RT»%' then 'Retargeting'
				when [Placement] like '%Overlay%' then 'Retargeting'
 				end [Tactic]
		, case	when [Placement] like '%DBA%' then 'DBA'
				when [Placement] like '%DPA%' then 'DPA' 
				when [Placement] like '%»WCA Surface»%' then 'WCA Surface' 
				when [Placement] like '%»Video Retargeting»%' then 'Video Retargeting'
				--when [Placement] like '%»WCA Lookalike%' then 'WCA Lookalike'
				when [Placement] like '%»WCA Lookalike Xbox Past Purchasers»%' then 'WCA Lookalike XBox Past Purchasers'
				when [Placement] like '%»WCA Lookalike Lenovo Pages»%' then 'WCA Lookalike Lenovo Pages'
				when Placement like '%»WCA Lookalike PC & Tablet Pages»%' then 'WCA Lookalike PC & Tablet Pages'
				when Placement like '%»WCA Lookalike Student Pages»%' then 'WCA Lookalike Student Pages'
				when Placement like '%»WCA Lookalike Lenovo Pages»%' then 'WCA Lookalike Lenovo Pages'
				when Placement like '%»Surface Pages Lookalike»%' then 'Surface Pages Lookalike'

				when Placement like '%»Past Purchaser Lookalike»%' then 'Past Purchaser Lookalike'

				when Placement like '%»WCA LAL Xbox PDPs»%' then 'WCA LAL Xbox PDPs'

				when Placement like '%»WCA Surface Pages»%' then 'WCA Surface Pages'

				when Placement like '%»Surface Pages Lookalike»%' then 'Surface Pages Lookalike'
			
				when [Placement] like '%»Gamers»%' then 'Gamers'
				when [Placement] like '%»Parents»%' then 'Parents'
				when [Placement] like '%»Hispanic Parents»%' then 'Hispanic Parents'

				when [Placement] like '%»Students»%' then 'Students'
				when [Placement] like '%»Teachers»%' then 'Teachers'
				when [Placement] like '%»Hispanic Students»%' then 'Hispanic Students'

				when [Placement] like '%»CRM Hardcore»%' then 'CRM Hardcore'

				when [Placement] like '%»WCA Lenovo Pages»%' then 'WCA Lenovo Pages'
				when [Placement] like '%»WCA PC & Tablet Pages»%' then 'WCA PC & Tablet Pages'

				when [Placement] like '%»WCA Student Pages»%' then 'WCA Student Pages'

				when [Placement] like '%»Console Gamers + Music»%' then 'Console Gamers + Music'
				else 'Other'
				end Audience
		,'Facebook' [Partner]
		,case when Placement like '%Co-Marketing%' or Placement like '%Ultimate%' then 'Incremental' else 'TAC' end [Budget Source]
		,CASE	when Placement like '%XDL%' then 'Xbox Design Lab'
				when Placement like '%Minecraft%' then 'Minecraft'
				when Placement like '%Surface Accessories%' or Placement like '%Surface Devices%' or Placement like '%Surface%' then 'Surface'
				when Placement like '%xbox live gold%' then 'Xbox Live Gold'
				when Placement like '%xbox platform devices%' or Placement like '%xbox platform games%' then 'Xbox Platform'
				when Placement like '%»Windows»%' then 'Windows Software'
				when Placement like '%»Software»%' then 'Software'
				when Placement like '%Xbox Design Lab%' then 'Xbox Design Lab'
				when Placement like '%Hololens%' then 'Hololens'
				when Placement like '%Xbox games%' then 'Xbox Platform'
				when Placement like '%Xbox Devices%' then 'Xbox Platform'
				when Placement like '%Xbox accessories%' then 'Xbox Platform'
				when Placement like '%Xbox.com%' then 'Xbox Platform'
				when Placement like '%»HK»%' then 'Other'
				when Placement like '%Other%' then 'Other'
				when Placement like '%Gift Card%' then 'Other'
				when Placement like '%Xbox One X%' then 'Xbox Platform'
				when Placement like '%Graduation Xbox%' then 'Xbox Platform'
				when Placement like '%Xbox One S%' then 'Xbox Platform'
				when Placement like '% Prospecting Xbox%' then 'Xbox Platform'
				when Campaign like '%Games Sale' then 'XBox GamePass & Games'
				when Campaign like '%COM Intel' or Campaign like '%COM Lenovo' then 'Windows Devices'
				when Campaign like '%Back to School' then 'Surface'
				when Campaign like '%Deezer' then 'Other'
				END  [Product Category]
      ,sum((a.[Impressions])) [Impressions]
      ,sum((a.[Spend]))[Spend]
      ,sum((a.[Website Purchases - 7 Days After View]))[Website Purchases - 7 Days After View]
      ,sum((a.[Website Purchases Conversion Value - 7 Days After View]))[Website Purchases Conversion Value - 7 Days After View]
	  ,(0.45 * sum(([Website Purchases - 7 Days After View])))[45% View Purchases]
	  ,(0.45 * sum(([Website Purchases - 7 Days After View])))[45% View "Units"]
	  ,(0.45 * sum(([Website Purchases Conversion Value - 7 Days After View])))[45% View Revenue]
FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB4_SS] a
left join [dbo].[CurrencyConversions] b
on a.Country=b.[ISO 3-Letter Country Code]
group by a.[Date]
		,a.Campaign
		,a.[Placement]
		,a.[Country]
		,[Market]
		,[A13 Region]
		,[Country Name]
		,[CDS 17]
		,[Media Lead Region]
		,[Media Sync Group]
GO

----------------------------------------------------------

alter view [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB4_SS]
as
select	(t1.[date_start])Date
		,t1.[Campaign]
	--	,case when left(t1.Campaign,3)='MUL' then left(substring(t1.[Placement],charindex(' ',t1.[Placement])+4,3),3) else left(Campaign,3) 
		,case	when left(t1.Campaign,3) ='MUL' and t1.[Placement] like '%APAC%' then 'AUS'
					when left(t1.Campaign,3) ='MUL'  and t1.[Placement] like '%WE%' then left(substring(t1.[Placement],charindex(' ',t1.[Placement])+7,3),3) 
					when left(t1.Campaign,3) ='MUL' and (t1.[Placement] not like '%WE%' or t1.[Placement] not like '%APAC%') then left(substring(t1.[Placement],charindex(' ',t1.[Placement])+4,3),3) 
					else left(t1.Campaign,3) end [Country]
		,t1.[Placement]
		,sum((t1.Impressions))Impressions
		,sum((t1.Spend))Spend
		,sum((t2.[Website Purchases - 7 Days After View]))[Website Purchases - 7 Days After View]
		,sum((t2.[Website Purchases Conversion Value - 7 Days After View]))[Website Purchases Conversion Value - 7 Days After View]
from [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB1_SS] t1
full JOIN
[dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB3_SS] t2
ON  t1.[AdID] = t2.[AdID]
AND t1.date_start=t2.date_start
group by t1.date_start
		,t1.[Campaign]
		,t1.[Placement]
		
	go	
--------------------------------------------------------------------------------
alter VIEW [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB3_SS]
as
SELECT [AdID]
      ,[date_start]
      ,[CampaignID]
      ,sum([Website Purchases - 7 Days After View])[Website Purchases - 7 Days After View]
      ,sum([Website Purchases Conversion Value - 7 Days After View])[Website Purchases Conversion Value - 7 Days After View]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB2_SS]
  group by [AdID]
      ,[date_start]
      ,[CampaignID]
GO


--------------------------------------------------------------------------------

alter VIEW [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB2_SS]
AS
SELECT 
	[ad_id] AdID
	,[date_start] 
	,[actions]
	,[action_type][Action Type]
	,[action_value]
	,[campaign_id] CampaignID
	,(CASE WHEN [actions]= 'actions' THEN sum(([d7view])) ELSE 0 END) [Website Purchases - 7 Days After View]
	,(CASE WHEN [actions]= 'action_values' THEN sum(([d7view])) ELSE 0 END) [Website Purchases Conversion Value - 7 Days After View]
	from [Fact].[FacebookAdsInsightsActions]
	where [date_start] BETWEEN '7/1/2018' AND cast(DATEADD(day,-1 - (DATEPART(weekday, GETDATE()) + @@DATEFIRST - 2) % 6,GETDATE()) as date)-->=DATEADD(WEEK, -2, GETDATE())
	AND [action_type] like '%fb_pixel_purchase'
	AND ([campaign_id] like '238428317%' or [campaign_id] like '238429078%' or [campaign_id] like '238429117%' or [campaign_id] like '23843061%' or [campaign_id] like '23843075%' or 
	campaign_id in ('23842942687440444','23842971371610464','23842913049820464','23842913204950464','23842911732730444','23843086780150177'))
group by  [ad_id] 
	,[date_start] 
	,[campaign_id] 
	,[actions]
	,[action_type]
	,[action_value]
GO

--------------------------------------------------------------------------

alter VIEW [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB1_SS]
AS
SELECT [date_start] 
		,[ad_id] AdID
		,[ad_name] Placement
		--,[adset_name] Adset
	    ,[campaign_id] CampaignID
		,[campaign_name] Campaign
		,sum([impressions])[Impressions]
		,sum([spend])[Spend]
FROM [Fact].[FacebookAdsInsights] 
where  [date_start] BETWEEN '7/1/2018' AND cast(DATEADD(day,-1 - (DATEPART(weekday, GETDATE()) + @@DATEFIRST - 2) % 6,GETDATE()) as date)
and 
[campaign_name] in ('ITA_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads','DNK_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads',
							'ESP_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads','BEL_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads (NL)',
							'AUS_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads','CAN_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads',
							'USA_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads','GBR_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads',
							'JPN_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads',	'NLD_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads',
							'SGP_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads','FRA_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads',
							'CAN_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads (FR)','DEU_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads',
							'SWE_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads','BEL_gaPMG_STR_Surface_FY_19_Social - Surface Dynamic Ads (FR)',
							'MUL_gaPMG_STR_Surface_FY_19_Social - Surface New Promo Launch','BEL_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads (NL)',
							'KOR_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads','AUS_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads',
							'DEU_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads','DNK_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads',
							'CAN_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads','PHL_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads',
							'JPN_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads','SWE_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads',
							'MEX_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads','BEL_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads (FR)',
							'BRA_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads','ITA_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads',
							'BEL_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads (FR)','SWE_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads',
							'USA_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads','CAN_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads (FR)',
							'GBR_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads','ESP_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads',
							'ESP_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads','MEX_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads',
							'FRA_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads','ITA_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads',
							'KOR_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads','BEL_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads (NL)',
							'AUS_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads','DNK_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads',
							'CAN_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads','JPN_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads',
							'USA_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads','IND_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads',
							'NLD_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads','GBR_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads',
							'IND_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads','DEU_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads',
							'FRA_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads','CAN_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads (FR)',
							'NLD_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads','SGP_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads',
							'BRA_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads','PHL_gaPMG_STR_Software_FY_19_Social - Software Dynamic Ads',
							'SGP_gaPMG_STR_Windows_FY_19_Social - Windows Dynamic Ads','CAN_gaPMG_STR_StoresEvergreen_FY_19_Social - Gift Card Dynamic Ads',
							'USA_gaPMG_STR_StoresEvergreen_FY_19_Social - Gift Card Dynamic Ads','USA_gaPMG_STR_Hololens_FY_19_Social - Hololens Dynamic Ads',
							'GBR_gaPMG_STR_StoresEvergreen_FY_19_Social - Gift Card Dynamic Ads','AUS_gaPMG_STR_StoresEvergreen_FY_19_Social - Gift Card Dynamic Ads',
							'USA_gaPMG_STR_StoresEvergreen_FY_19_Social - HK Dynamic Ads','NLD_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads',
							'FRA_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads','ITA_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads',
							'CAN_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads','JPN_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads',
							'SWE_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads','USA_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads',
							'AUS_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads','SGP_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads',
							'CAN_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads (FR)','BEL_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads (FR)',
							'GBR_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads','DEU_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads',
							'BEL_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads (NL)','ESP_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads',
							'DNK_gaPMG_STR_XboxPlatform_FY_19_Social - Xbox Platform Dynamic Ads','CAN_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads (FR)',
							'CAN_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads','FRA_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads',
							'AUS_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads','JPN_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads',
							'USA_gaPMG_STR_XboxDesignLab_FY_19_Social - Xbox Design Lab Dynamic Ads','DEU_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads',
							'NLD_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads','SWE_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads',
							'USA_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads','BEL_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads (FR)',
							'GBR_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads','GBR_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads',
							'BRA_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads','ESP_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads',
							'ITA_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads','MEX_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads',
							'NLD_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads','DEU_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads',
							'FRA_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads','SGP_gaPMG_STR_Minecraft_FY_19_Social - Minecraft Dynamic Ads',
							'CAN_gaPMG_STR_XboxDesignLab_FY_19_Social - Xbox Design Lab Dynamic Ads','FRA_gaPMG_STR_XboxDesignLab_FY_19_Social - Xbox Design Lab Dynamic Ads',
							'GBR_gaPMG_STR_XboxDesignLab_FY_19_Social - Xbox Design Lab Dynamic Ads','DEU_gaPMG_STR_XboxDesignLab_FY_19_Social - Xbox Design Lab Dynamic Ads',
							'AUS_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads','BEL_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads (NL)',
							'DNK_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads','JPN_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads',
							'CAN_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads (FR)','CAN_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads',
							'SGP_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads','ITA_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads',
							'USA_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads'									--Incremental Campaigns:
							,'MUL_gaPMG_STR_Ultimate Game Sale_Q1_19_Social - Ultimate Games Sale','USA_gaPMG_STR_Surface_Q1_19_Social - Back to School',
							'USA_gaPMG_STR_Microsoft Store_Q1_19_Social - COM Intel','USA_gaPMG_STR_Microsoft Store_Q1_19_Social - COM Lenovo','USA_gaPMG_STR_Microsoft Store_H1_19_Social - Deezer')

group by [date_start] 
		,[ad_id] 
		,[ad_name] 
		,[adset_name] 
	    ,[campaign_id] 
		,[campaign_name] 
GO
--select distinct(month(date_start)) month,campaign,campaignid from [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB1_SS] where campaign in ('USA_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads'									--Incremental Campaigns:
--							,'MUL_gaPMG_STR_Ultimate Game Sale_Q1_19_Social - Ultimate Games Sale','USA_gaPMG_STR_Surface_Q1_19_Social - Back to School',
--							'USA_gaPMG_STR_Microsoft Store_Q1_19_Social - COM Intel','USA_gaPMG_STR_Microsoft Store_Q1_19_Social - COM Lenovo','USA_gaPMG_STR_Microsoft Store_H1_19_Social - Deezer')




--select distinct(campaign),campaignid from [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialFB1_SS] where campaign in ('USA_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads'									--Incremental Campaigns:
--							,'MUL_gaPMG_STR_Ultimate Game Sale_Q1_19_Social - Ultimate Games Sale','USA_gaPMG_STR_Surface_Q1_19_Social - Back to School',
--							'USA_gaPMG_STR_Microsoft Store_Q1_19_Social - COM Intel','USA_gaPMG_STR_Microsoft Store_Q1_19_Social - COM Lenovo','USA_gaPMG_STR_Microsoft Store_H1_19_Social - Deezer')
----------------------------------------------DCM--------------------------------------------------------------------------

alter view [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM8_SS]
as
SELECT ([Date])
		,Campaign
		,case when Campaign like '%COM Intel' then 'Intel Co-Marketing' 
				when Campaign like '%COM Lenovo%' then 'Lenovo Co-Marketing'
				when Campaign like '%Back to School' then 'Back to School - Physical'
				when Campaign like '%Ultimate Games Sale' then 'Ultimate Games Sale - Digital'
				when Campaign like '%Deezer' then 'Deezer Digital Goods'
				else 'Evergreen' end [Campaign type]
      ,[Placement]
      ,[Country]
      ,[Week Start]
      ,[Week End]
      ,[Week Number]
	  ,CONCAT('Week ',[Week Number],' (',[Week Start],'-',[Week End],')')[Week]
      ,[A13 Region]
   -- ,[ISO 3-Letter Country Code]
      ,[Country Name]
      ,[CDS 17]
      ,[Media Lead Region]
      ,[Media Sync Group]
      ,[Month]
      ,[Quarter]
      ,[Channel]
      ,[Tactic]
      ,[Audience]
      ,[Partner]
      ,[Budget Source]
      ,[Product Category]
      ,sum([Impressions])[Impressions]
      ,sum([Clicks])[Clicks]
      ,sum(isnull([ViewthroughConversions],0))[ViewthroughConversions]
      ,sum(isnull([ClickthroughRevenue],0))[ClickthroughRevenue]
      ,sum(isnull([ViewthroughRevenue],0))[ViewthroughRevenue]
      ,sum(isnull([Units],0))[Units]
      ,sum(isnull([Click-Through Conversions],0))[Click-Through Conversions]
      ,sum(isnull([USD View Revenue 45%],0))[USD View Revenue 45%]
      ,sum(isnull([USD Click Revenue],0))[USD Click Revenue]
      ,sum(isnull([View-Through Conversions 45%],0))[View-Through Conversions 45%]
	  ,case when (sum([View-Through Conversions]) + sum([USD View Revenue 45%]))>0 AND (sum([Click-Through Conversions])+sum([USD Click Revenue]))=0 then 0 else sum([Units]-[View-Through Conversions]) end [Click Through Units]
	  ,case when sum([View-Through Conversions])>0 then (sum([Units])-(sum([Click-Through Conversions]))*0.45) else 0 end [View Through Units 45%]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM7_SS]
  group by ([Date])
		,[Placement]
		,Campaign
      ,[Country]
      ,[Week Start]
      ,[Week End]
      ,[Week Number]
	  ,CONCAT('Week ',[Week Number],' (',[Week Start],'-',[Week End],')')
      ,[A13 Region]
   -- ,[ISO 3-Letter Country Code]
      ,[Country Name]
      ,[CDS 17]
      ,[Media Lead Region]
      ,[Media Sync Group]
      ,[Month]
      ,[Quarter]
      ,[Channel]
      ,[Tactic]
      ,[Audience]
      ,[Partner]
      ,[Budget Source]
      ,[Product Category]
GO

------------------------------------------------------------------
--select sum([Impressions]) [Impressions]
--			,sum([Clicks]) [Clicks]
--			,sum([Click-Through Conversions]) [Click-Through Conversions]
--			,sum([ViewthroughConversions]) [ViewthroughConversions]
--			,sum([ClickthroughRevenue]) [ClickthroughRevenue]
--			,sum([ViewthroughRevenue])[ViewthroughRevenue],sum([Click Through Units]),sum([USD Click Revenue]) from [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM7_SS]  where date ='10/10/2018'
--0	60591	70	0	11050557.719949	0 --duplicates

--0	13118	20574	0	1623858.729992	0--actual

alter VIEW [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM7_SS]
AS
SELECT ([Date]) 
		,Campaign
		--,left(substring(a.[Placement],charindex(' ',a.[Placement])+5,3),3) [Country]
		,a.[Placement]
		,a.[Country]
		,replace((convert(varchar,(DATEADD(dd, -(DATEPART(dw, [Date])-1), [Date])),1)),'/','.') [Week Start]
		,replace((convert(varchar,(DATEADD(dd, 7-(DATEPART(dw, [Date])), [Date])),1)),'/','.')  [Week End]
		,right(([dbo].[FiscalWeek]('07',a.Date)),2) [Week Number]
		,[A13 Region]
		,[ISO 3-Letter Country Code]
		,[Country Name]
		,[CDS 17]
		,[Media Lead Region]
		,[Media Sync Group]	
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
				END
			[Quarter]
	    ,'Social' Channel
		, case	when [Placement] like '%Graduataion%' then 'Prospecting - Graduation'
				when [Placement] like '%Cross Sell%' then 'Cross Sell'
				when [Placement] like '%GA Video Retargeting%' or [Placement] like '%»PRO»%' then 'Prospecting'
				when [Placement] like '%»LAL»%' then 'Lookalike'
				when [Placement] like '%»RT»%' then 'Retargeting'
				when [Placement] like '%Overlay%' then 'Retargeting'
			end [Tactic]
		, case	when [Placement] like '%DBA%' then 'DBA'
				when [Placement] like '%DPA%' then 'DPA' 
				when [Placement] like '%»WCA Surface»%' then 'WCA Surface' 
				when [Placement] like '%»Video Retargeting»%' then 'Video Retargeting'
				--when [Placement] like '%»WCA Lookalike%' then 'WCA Lookalike'
				when [Placement] like '%»WCA Lookalike Xbox Past Purchasers»%' then 'WCA Lookalike XBox Past Purchasers'
				when [Placement] like '%»WCA Lookalike Lenovo Pages»%' then 'WCA Lookalike Lenovo Pages'
				when Placement like '%»WCA Lookalike PC & Tablet Pages»%' then 'WCA Lookalike PC & Tablet Pages'
				when Placement like '%»WCA Lookalike Student Pages»%' then 'WCA Lookalike Student Pages'
				when Placement like '%»WCA Lookalike Lenovo Pages»%' then 'WCA Lookalike Lenovo Pages'
				when Placement like '%»Surface Pages Lookalike»%' then 'Surface Pages Lookalike'
				when Placement like '%»Past Purchaser Lookalike»%' then 'Past Purchaser Lookalike'
				when Placement like '%»WCA LAL Xbox PDPs»%' then 'WCA LAL Xbox PDPs'
				when Placement like '%»WCA Surface Pages»%' then 'WCA Surface Pages'
				when Placement like '%»Surface Pages Lookalike»%' then 'Surface Pages Lookalike'
				when [Placement] like '%Gamers%' then 'Gamers'
				when [Placement] like '%»Parents»%' then 'Parents'
				when [Placement] like '%»Hispanic Parents»%' then 'Hispanic Parents'
				when [Placement] like '%»Students»%' then 'Students'
				when [Placement] like '%»Teachers»%' then 'Teachers'
				when [Placement] like '%»Hispanic Students»%' then 'Hispanic Students'
				when [Placement] like '%»CRM Hardcore»%' then 'CRM Hardcore'
				when [Placement] like '%»WCA Lenovo Pages»%' then 'WCA Lenovo Pages'
				when [Placement] like '%»WCA PC & Tablet Pages»%' then 'WCA PC & Tablet Pages'
				when [Placement] like '%»WCA Student Pages»%' then 'WCA Student Pages'
				when [Placement] like '%»Console Gamers + Music»%' then 'Console Gamers + Music'
				else 'Other'
				end Audience
		,'Facebook' [Partner]
		,case when Placement like '%Co-Marketing%' or Placement like '%Ultimate%' then 'Incremental' else 'TAC' end [Budget Source]
		,CASE	when Placement like '%XDL%' then 'Xbox Design Lab'
				when Placement like '%Minecraft%' then 'Minecraft'
				when Placement like '%Surface Accessories%' or Placement like '%Surface Devices%' or Placement like '%Surface%' then 'Surface'
				when Placement like '%xbox live gold%' then 'Xbox Live Gold'
				when Placement like '%xbox platform devices%' or Placement like '%xbox platform games%' then 'Xbox Platform'
				when Placement like '%windows software%' then 'Windows Software'
				when Placement like '%Windows devices%' then 'Windows Devices'
				when Placement like '%»Windows»%' then 'Windows Software'
				when Placement like '%»Software»%' then 'Software'
				when Placement like '%Xbox Design Lab%' then 'Xbox Design Lab'
				when Placement like '%Hololens%' then 'Hololens'
				when Placement like '%Xbox games%' then 'Xbox Platform'
				when Placement like '%Xbox Devices%' then 'Xbox Platform'
				when Placement like '%Xbox accessories%' then 'Xbox Platform'
				when Placement like '%Xbox.com%' then 'Xbox Platform'
				when Placement like '%»HK»%' then 'Other'
				when Placement like '%Other%' then 'Other'
				when Placement like '%Gift Card%' then 'Other'
				when Placement like '%Xbox One X%' then 'Xbox Platform'
				when Placement like '%Graduation Xbox%' then 'Xbox Platform'
				when Placement like '%Xbox One S%' then 'Xbox Platform'
				when Placement like '% Prospecting Xbox%' then 'Xbox Platform'
				when Campaign like '%Games Sale' then 'XBox GamePass & Games'
				when Campaign like '%COM Intel' or Campaign like '%COM Lenovo' then 'Windows Devices'
				when Campaign like '%Back to School' then 'Surface'
				when Campaign like '%Deezer' then 'Other'
				END  [Product Category]
		,sum((a.[Impressions])) [Impressions]
		,sum((a.[Clicks]))[Clicks]
		,sum((a.[ViewthroughConversions]))[ViewthroughConversions]
		,sum((a.[ClickthroughRevenue]))[ClickthroughRevenue]
		,sum((a.[ViewthroughRevenue]))[ViewthroughRevenue]
		,sum((a.[Units]))[Units]
		,sum(([CurrencyPerUSD]))[CurrencyPerUSD]
		,sum(([Click-Through Conversions]))[Click-Through Conversions]
		,sum(([View-Through Conversions]))[View-Through Conversions]
		,sum(([View-Through Revenue]))[View-Through Revenue]
		,0.45*(sum(([View-Through Revenue]))/sum(([CurrencyPerUSD])))[USD View Revenue 45%]
		,(sum(([Units]))-sum(([View-Through Conversions]))) [Click Through Units]
 		,(sum(([Click-Through Revenue]))/sum(([CurrencyPerUSD])))[USD Click Revenue]
		,(sum(([View-Through Conversions]))*0.45) [View-Through Conversions 45%]
		FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM6_SS] a
left join [dbo].[CurrencyConversions]b
on a.[Country] =b.[ISO 3-Letter Country Code]
group by  [Date]
		,Campaign
		,[Placement]
		,Country
		,[A13 Region]
		,[ISO 3-Letter Country Code]
		,[Country Name]
		,[CDS 17]
		,[Media Lead Region]
		,[Media Sync Group]
go
-------------------------------------------------------------------------

alter VIEW [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM6_SS]
AS
SELECT (a.[Date])
		,a.[Campaign]
		,a.[Placement]
		,case	when a.Campaign like 'MUL%' and a.[Placement] like '%APAC%' then 'AUS'
				when a.Campaign like 'MUL%' and a.[Placement] like '%WE%' then left(substring(a.[Placement],charindex(' ',a.[Placement])+7,3),3) 
				when a.Campaign like 'MUL%' and (a.[Placement] not like '%WE%' or a.[Placement] not like '%APAC%') then left(substring(a.[Placement],charindex(' ',a.[Placement])+4,3),3) 
				else left(a.Campaign,3) end [Country]
 		,sum((a.[Impressions]))[Impressions]
		,sum((a.[Clicks]))[Clicks]
		,sum((a.[ViewthroughConversions]))[ViewthroughConversions]
		,sum((a.[ClickthroughRevenue]))[ClickthroughRevenue]
		,sum((a.[ViewthroughRevenue]))[ViewthroughRevenue]
		,(sum(([Store-Other Sales: Click Through Conversions]))+sum(([Surface Sales: Click Through Conversions]))+sum(([XBoxDesignLab Sales: Click Through Conversions]))+
		sum(([Software Sales: Click Through Conversions]))+sum(([XBoxPlatform Sales: Click Through Conversions]))+sum(([Minecraft Sales: Click Through Conversions]))
		+sum(([Hololens Sales: Click Through Conversions]))+sum(([WindowsSoftware Sales: Click Through Conversions]))+sum(([Xbox Live Gold: Click Through Conversions]))) [Click-Through Conversions]
 	 
		,(sum(([Store-Other Sales: Click Through Revenue]))+sum(([Surface Sales: Click Through Revenue]))+sum(([XBoxDesignLab Sales: Click Through Revenue]))+
		sum(([Software Sales: Click Through Revenue]))+sum(([XBoxPlatform Sales: Click Through Revenue]))+sum(([Minecraft Sales: Click Through Revenue]))
		+sum(([Hololens Sales: Click Through Revenue]))+sum(([WindowsSoftware Sales: Click Through Revenue]))+sum(([Xbox Live Gold: Click Through Revenue]))) [Click-Through Revenue]
 
 		,(sum(([Store-Other Sales: View Through Conversions]))+sum(([Surface Sales: View Through Conversions]))+sum(([XBoxDesignLab Sales: View Through Conversions]))+
		sum(([Software Sales: View Through Conversions]))+sum(([XBoxPlatform Sales: View Through Conversions]))+sum(([Minecraft Sales: View Through Conversions]))
		+sum(([Hololens Sales: View Through Conversions]))+sum(([WindowsSoftware Sales: View Through Conversions]))+sum(([Xbox Live Gold: View Through Conversions]))) [View-Through Conversions]
  
		,(sum(([Store-Other Sales: View Through Revenue]))+sum(([Surface Sales: View Through Revenue]))+sum(([XBoxDesignLab Sales: View Through Revenue]))+
		sum(([Software Sales: View Through Revenue]))+sum(([XBoxPlatform Sales: View Through Revenue]))+sum(([Minecraft Sales: View Through Revenue]))
		+sum(([Hololens Sales: View Through Revenue]))+sum(([WindowsSoftware Sales: View Through Revenue]))+sum(([Xbox Live Gold: View Through Revenue]))) [View-Through Revenue]
 
		,(sum(([Store-Other Sales: Units]))+sum(([Surface Sales: Units]))+sum(([XBoxDesignLab Sales: Units]))+
		sum(([Software Sales: Units]))+sum(([XBoxPlatform Sales: Units]))+sum(([Minecraft Sales: Units]))
		+sum(([Hololens Sales: Units]))+sum(([WindowsSoftware Sales: Units]))+sum(([Xbox Live Gold: Units]))) [Units]
 
	FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM5_SS] a
	left join [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM2_SS]b
	on a.[Date] = b.[Date]
	AND a.PlacementID = b.PlacementID
	GROUP BY a.[Date]
		,a.[Campaign]
		,a.[Placement]
go	
----------------------------------------------------------------------
alter view [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM5_SS]
as
SELECT [Date]
      ,[Campaign]
      ,[Placement]
      ,[PlacementID]
      ,sum([Store-Other Sales: Click Through Conversions])[Store-Other Sales: Click Through Conversions]
      ,sum([Store-Other Sales: View Through Conversions])[Store-Other Sales: View Through Conversions]
      ,sum([Store-Other Sales: View Through Revenue])[Store-Other Sales: View Through Revenue]
      ,sum([Store-Other Sales: Click Through Revenue])[Store-Other Sales: Click Through Revenue]
      ,sum([Surface Sales: Click Through Conversions])[Surface Sales: Click Through Conversions]
      ,sum([Surface Sales: View Through Conversions])[Surface Sales: View Through Conversions]
      ,sum([Surface Sales: View Through Revenue])[Surface Sales: View Through Revenue]
      ,sum([Surface Sales: Click Through Revenue])[Surface Sales: Click Through Revenue]
      ,sum([XBoxDesignLab Sales: Click Through Conversions])[XBoxDesignLab Sales: Click Through Conversions]
      ,sum([XBoxDesignLab Sales: View Through Conversions])[XBoxDesignLab Sales: View Through Conversions]
      ,Sum([XBoxDesignLab Sales: View Through Revenue])[XBoxDesignLab Sales: View Through Revenue]
      ,Sum([XBoxDesignLab Sales: Click Through Revenue])[XBoxDesignLab Sales: Click Through Revenue]
      ,Sum([Software Sales: Click Through Conversions])[Software Sales: Click Through Conversions]
      ,Sum([Software Sales: View Through Conversions])[Software Sales: View Through Conversions]
      ,Sum([Software Sales: View Through Revenue])[Software Sales: View Through Revenue]
      ,Sum([Software Sales: Click Through Revenue])[Software Sales: Click Through Revenue]
      ,Sum([XBoxPlatform Sales: Click Through Conversions])[XBoxPlatform Sales: Click Through Conversions]
      ,Sum([XBoxPlatform Sales: View Through Conversions])[XBoxPlatform Sales: View Through Conversions]
      ,Sum([XBoxPlatform Sales: View Through Revenue])[XBoxPlatform Sales: View Through Revenue]
      ,Sum([XBoxPlatform Sales: Click Through Revenue])[XBoxPlatform Sales: Click Through Revenue]
      ,Sum([Minecraft Sales: Click Through Conversions])[Minecraft Sales: Click Through Conversions]
      ,Sum([Minecraft Sales: View Through Conversions])[Minecraft Sales: View Through Conversions]
      ,Sum([Minecraft Sales: View Through Revenue])[Minecraft Sales: View Through Revenue]
      ,Sum([Minecraft Sales: Click Through Revenue])[Minecraft Sales: Click Through Revenue]
      ,Sum([Hololens Sales: Click Through Conversions])[Hololens Sales: Click Through Conversions]
      ,Sum([Hololens Sales: View Through Conversions])[Hololens Sales: View Through Conversions]
      ,Sum([Hololens Sales: View Through Revenue])[Hololens Sales: View Through Revenue]
      ,Sum([Hololens Sales: Click Through Revenue])[Hololens Sales: Click Through Revenue]
      ,Sum([WindowsSoftware Sales: Click Through Conversions])[WindowsSoftware Sales: Click Through Conversions]
      ,Sum([WindowsSoftware Sales: View Through Conversions])[WindowsSoftware Sales: View Through Conversions]
      ,Sum([WindowsSoftware Sales: View Through Revenue])[WindowsSoftware Sales: View Through Revenue]
      ,Sum([WindowsSoftware Sales: Click Through Revenue])[WindowsSoftware Sales: Click Through Revenue]
      ,Sum([Xbox Live Gold: Click Through Conversions])[Xbox Live Gold: Click Through Conversions]
      ,Sum([Xbox Live Gold: View Through Conversions])[Xbox Live Gold: View Through Conversions]
      ,Sum([Xbox Live Gold: View Through Revenue])[Xbox Live Gold: View Through Revenue]
      ,Sum([Xbox Live Gold: Click Through Revenue])[Xbox Live Gold: Click Through Revenue]
      ,Sum([Impressions])[Impressions]
      ,Sum([Clicks])[Clicks]
      ,Sum([ClickthroughConversions])[ClickthroughConversions]
      ,Sum([ViewthroughConversions])[ViewthroughConversions]
      ,Sum([ClickthroughRevenue])[ClickthroughRevenue]
      ,Sum([ViewthroughRevenue])[ViewthroughRevenue]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM4_SS]
  group by [Date]
      ,[Placement]
      ,[Campaign]
      ,[PlacementID]
GO



----------------------------------------------------------------------
--select sum([Impressions]) [Impressions]
--			,sum([Clicks]) [Clicks]
--			,sum([ClickthroughConversions]) [ClickthroughConversions]
--			,sum([ViewthroughConversions]) [ViewthroughConversions]
--			,sum([ClickthroughRevenue]) [ClickthroughRevenue]
--			,sum([ViewthroughRevenue])[ViewthroughRevenue] from [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM4_SS]  where date ='10/10/2018'
--0	13118	20574	0	1623858.729992	0

alter View [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM4_SS] 
as
SELECT [Date]
      ,[Campaign]
      ,[Activity]
      ,[Placement]
      ,[PlacementID]
      		,CASE WHEN [Activity] = 'Store-Other_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughConversions]) ELSE 0 END [Store-Other Sales: Click Through Conversions]
			, CASE WHEN [Activity] = 'Store-Other_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughConversions]) ELSE 0 END [Store-Other Sales: View Through Conversions]
			, CASE WHEN [Activity] = 'Store-Other_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughRevenue]) ELSE 0 END [Store-Other Sales: View Through Revenue]
			, CASE WHEN [Activity] = 'Store-Other_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughRevenue]) ELSE 0 END [Store-Other Sales: Click Through Revenue]
		
			, CASE WHEN [Activity] = 'Surface_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughConversions]) ELSE 0 END [Surface Sales: Click Through Conversions]
			, CASE WHEN [Activity] = 'Surface_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughConversions]) ELSE 0 END [Surface Sales: View Through Conversions]
			, CASE WHEN [Activity] = 'Surface_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughRevenue]) ELSE 0 END [Surface Sales: View Through Revenue]
			, CASE WHEN [Activity] = 'Surface_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughRevenue]) ELSE 0 END [Surface Sales: Click Through Revenue]

			, CASE WHEN [Activity] = 'XboxDesignLab_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughConversions]) ELSE 0 END [XBoxDesignLab Sales: Click Through Conversions]
			, CASE WHEN [Activity] = 'XboxDesignLab_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughConversions]) ELSE 0 END [XBoxDesignLab Sales: View Through Conversions]
			, CASE WHEN [Activity] = 'XboxDesignLab_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughRevenue]) ELSE 0 END [XBoxDesignLab Sales: View Through Revenue]
			, CASE WHEN [Activity] = 'XboxDesignLab_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughRevenue]) ELSE 0 END [XBoxDesignLab Sales: Click Through Revenue]

			, CASE WHEN [Activity] = 'Software_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughConversions]) ELSE 0 END [Software Sales: Click Through Conversions]
			, CASE WHEN [Activity] = 'Software_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughConversions]) ELSE 0 END [Software Sales: View Through Conversions]
			, CASE WHEN [Activity] = 'Software_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughRevenue]) ELSE 0 END [Software Sales: View Through Revenue]
			, CASE WHEN [Activity] = 'Software_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughRevenue]) ELSE 0 END [Software Sales: Click Through Revenue]

			, CASE WHEN [Activity] = 'XboxPlatform_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughConversions]) ELSE 0 END [XBoxPlatform Sales: Click Through Conversions]
			, CASE WHEN [Activity] = 'XboxPlatform_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughConversions]) ELSE 0 END [XBoxPlatform Sales: View Through Conversions]
			, CASE WHEN [Activity] = 'XboxPlatform_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughRevenue]) ELSE 0 END [XBoxPlatform Sales: View Through Revenue]
			, CASE WHEN [Activity] = 'XboxPlatform_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughRevenue]) ELSE 0 END [XBoxPlatform Sales: Click Through Revenue]

			, CASE WHEN [Activity] = 'Minecraft_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughConversions]) ELSE 0 END [Minecraft Sales: Click Through Conversions]
			, CASE WHEN [Activity] = 'Minecraft_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughConversions]) ELSE 0 END [Minecraft Sales: View Through Conversions]
			, CASE WHEN [Activity] = 'Minecraft_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughRevenue]) ELSE 0 END [Minecraft Sales: View Through Revenue]
			, CASE WHEN [Activity] = 'Minecraft_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughRevenue]) ELSE 0 END [Minecraft Sales: Click Through Revenue]

			, CASE WHEN [Activity] = 'Hololens_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughConversions]) ELSE 0 END [Hololens Sales: Click Through Conversions]
			, CASE WHEN [Activity] = 'Hololens_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughConversions]) ELSE 0 END [Hololens Sales: View Through Conversions]
			, CASE WHEN [Activity] = 'Hololens_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughRevenue]) ELSE 0 END [Hololens Sales: View Through Revenue]
			, CASE WHEN [Activity] = 'Hololens_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughRevenue]) ELSE 0 END [Hololens Sales: Click Through Revenue]

			, CASE WHEN [Activity] = 'WindowsSoftware_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughConversions]) ELSE 0 END [WindowsSoftware Sales: Click Through Conversions]
			, CASE WHEN [Activity] = 'WindowsSoftware_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughConversions]) ELSE 0 END [WindowsSoftware Sales: View Through Conversions]
			, CASE WHEN [Activity] = 'WindowsSoftware_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughRevenue]) ELSE 0 END [WindowsSoftware Sales: View Through Revenue]
			, CASE WHEN [Activity] = 'WindowsSoftware_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughRevenue]) ELSE 0 END [WindowsSoftware Sales: Click Through Revenue]

			, CASE WHEN [Activity] = 'XboxLiveGold_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughConversions]) ELSE 0 END [Xbox Live Gold: Click Through Conversions]
			, CASE WHEN [Activity] = 'XboxLiveGold_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughConversions]) ELSE 0 END [Xbox Live Gold: View Through Conversions]	
			, CASE WHEN [Activity] = 'XboxLiveGold_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ViewthroughRevenue]) ELSE 0 END [Xbox Live Gold: View Through Revenue]	
			, CASE WHEN [Activity] = 'XboxLiveGold_GBL_PchComplete_Transaction_PhysicalStore' THEN sum([ClickthroughRevenue]) ELSE 0 END [Xbox Live Gold: Click Through Revenue]
		,sum([Impressions]) [Impressions]
		,sum([Clicks]) [Clicks]
		,sum([ClickthroughConversions]) [ClickthroughConversions]
		,sum([ViewthroughConversions]) [ViewthroughConversions]
		,sum([ClickthroughRevenue]) [ClickthroughRevenue]
		,sum([ViewthroughRevenue])[ViewthroughRevenue] 
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM3_SS]
 group by  [Date]
      ,[Campaign]
      ,[Activity]
      ,[Placement]
      ,[PlacementID]
GO


----------------------------------------------------------------------
--select distinct(campaign) from [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM3_SS]  where campaign in ('CAN_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads','CAN_gaPMG_STR_XboxLiveGold_FY_19_Social - Xbox Live Gold Dynamic Ads (FR)')

alter View [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM3_SS] 
as
select  ([dataDate]) [Date]
			,Campaign
			,[Activity]
			,[Placement]
			,[PlacementID]
			,sum([Impressions]) [Impressions]
			,sum([Clicks]) [Clicks]
			,sum([ClickthroughConversions]) [ClickthroughConversions]
			,sum([ViewthroughConversions]) [ViewthroughConversions]
			,sum([ClickthroughRevenue]) [ClickthroughRevenue]
			,sum([ViewthroughRevenue])[ViewthroughRevenue]
from [Fact].[dcmStandardRawData]
where [CampaignID] in ('20900386','20941313','20909862','20930589','21358970','20911337','20911672','20909990','20930081','21375303','21375300','20905415','20945502','20956600',
							'20952465','20911874','20897425','20917062','20879302','20930781','20996370','21358967','20900716','20911892','20898355','20917662','20886313','21375294','20911277','21375003',
							'20881504','20943494','20910011','20911490','20931830','20903833','20911925','20925282','20886082','20898262','20955091','20882023','20904185','20919782','20931833','20890699',
							'20897323','20907205','20881159','20936427','20897326','20925522','20930051','20950494','21335638','20938881','20901067','21335635','20938884','20901070','21375600','20881501',
							'20938887','20942360','20890861','20949102','21361946','20945390','20930496','20953362','20900311','20951517','20942675','20949117','20925387','20904208','20941160','21375597',
							'20906161','20929071','20944923','20949714','20921913','20942408','20904196','20952379','20953564','20920398','21361031','21314749','21325477','21358946','21358052','21359949',
							'21360813','21352097','21361020','21375570','21335641','21039046','21375276','21358634','21360816','21354078','21375297','21343874','21352094','21358343','21359952','21351755',
							'21358637','21359955','21325471','21358346','21316486','21358964','21360390','21361037','21324382','21360761','21351752','21358349','21342203','21358370','21361017','21358055',
							'21358073','20916030','21358352','21354081','21374997','21344324','21374673','21359946','21343871','21358058','21335614','21358955','21316483','21374994','21325468','21360737',
							'21375573','21314743','21374991','21362442','21374973','21314746','21344318','20948838','21361931','21360810','21360755','21352091','20985734','20922888','20910562','20949756',
							'20911301','21020461','20886115','20880895','21337162','21377742','21377697','21364946','21337144','20953561','21378027','21373830','21363197','21364682','21363161','21363158',
							'21378024','21337171','21337141','21337138','21362876','21337159','21364967','21339043','21377724','21335437','21363179','21364940','21377721','21378003','21364964','21378000',
							'21364937','21364961','21364934','21378021','21377454','21335410','21362903','21018697','20882110','21377715','21364979','21365231','21337165','21377448','21364943','20905229',
							'20906269','21399560','20911063','20936897','20898232','20931800','20928516','20945562','20943752','20943497','20942678'
							--Q2 Incremental Campaigns
							,'21592888','21469148','21759866','21476240','21600060',
							'21901858','21900818','21895030','21881940','21895027','21885192') --Launched in Q2(10/26/2018 or later)
AND  [dataDate] between '7/1/2018' and cast(DATEADD(day,-1 - (DATEPART(weekday, GETDATE()) + @@DATEFIRST - 2) % 6,GETDATE()) as date)
group by ([dataDate]) 
			,Campaign
			,[Activity]
			,[Placement]
			,[PlacementID]

go
-------------------------------------------------------------------------------------
alter VIEW [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM2_SS]
AS
SELECT [Date]
      ,[PlacementID]
      ,[Campaign]
      ,[Placement]
      ,sum([Store-Other Sales: Units])[Store-Other Sales: Units]
      ,sum([Surface Sales: Units])[Surface Sales: Units]
      ,sum([XBoxDesignLab Sales: Units])[XBoxDesignLab Sales: Units]
      ,sum([Software Sales: Units])[Software Sales: Units]
      ,sum([XBoxPlatform Sales: Units])[XBoxPlatform Sales: Units]
      ,sum([Minecraft Sales: Units])[Minecraft Sales: Units]
      ,sum([Hololens Sales: Units])[Hololens Sales: Units]
      ,sum([WindowsSoftware Sales: Units])[WindowsSoftware Sales: Units]
      ,sum([Xbox Live Gold: Units])[Xbox Live Gold: Units]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM1_SS]
  group by [Date]
      ,[Placement]
      ,[PlacementID]
      ,[Campaign]
      
GO


-------------------------------------------------------------------------------------

alter VIEW [dbo].[vw.STAGING_STORE_WeeklyPacing_SocialDCM1_SS]
AS
select	r.[dataDate] [Date]
				,r.Activity
				,r.[PlacementID]
				,r.[Campaign]
				,r.campaignid
				,r.[Placement]
				, CASE WHEN r.Activity = 'Store-Other_GBL_PchComplete_Transaction_PhysicalStore' THEN sum((cast(u.Unitsstring as numeric (3,0)))) ELSE 0 END [Store-Other Sales: Units]
				, CASE WHEN r.Activity = 'Surface_GBL_PchComplete_Transaction_PhysicalStore' THEN (sum((cast(u.Unitsstring as numeric (3,0))))) ELSE 0 END [Surface Sales: Units]
				, CASE WHEN r.Activity = 'XboxDesignLab_GBL_PchComplete_Transaction_PhysicalStore' THEN (sum((cast(u.Unitsstring as numeric (3,0))))) ELSE 0 END [XBoxDesignLab Sales: Units]
				, CASE WHEN r.Activity = 'Software_GBL_PchComplete_Transaction_PhysicalStore' THEN (sum((cast(u.Unitsstring as numeric (3,0))))) ELSE 0 END [Software Sales: Units]
				, CASE WHEN r.Activity = 'XboxPlatform_GBL_PchComplete_Transaction_PhysicalStore' THEN (sum((cast(u.Unitsstring as numeric (3,0))))) ELSE 0 END [XBoxPlatform Sales: Units]
				, CASE WHEN r.Activity = 'Minecraft_GBL_PchComplete_Transaction_PhysicalStore' THEN (sum((cast(u.Unitsstring as numeric (3,0))))) ELSE 0 END [Minecraft Sales: Units]
				, CASE WHEN r.Activity = 'Hololens_GBL_PchComplete_Transaction_PhysicalStore' THEN (sum((cast(u.Unitsstring as numeric (3,0))))) ELSE 0 END [Hololens Sales: Units]
				, CASE WHEN r.Activity = 'WindowsSoftware_GBL_PchComplete_Transaction_PhysicalStore' THEN (sum((cast(u.Unitsstring as numeric (3,0))))) ELSE 0 END [WindowsSoftware Sales: Units]
				, CASE WHEN r.Activity = 'XboxLiveGold_GBL_PchComplete_Transaction_PhysicalStore' THEN (sum((cast(u.Unitsstring as numeric (3,0))))) ELSE 0 END [Xbox Live Gold: Units]
				--	,sum((cast(u.Unitsstring as numeric (3,0)))) Units
from [Fact].[dcmFloodlightRawData] r
right join [Fact].[dcmFloodlightUVariables] u
				on r.[ActivityID] = u.[ActivityID]
				and r.[CampaignID] = u.[CampaignID]
				and r.[PlacementID] = u.[PlacementID]
				and r.[CreativeID] = u.[CreativeID]
				and r.[AdvertiserID]=u.AdvertiserID
				and r.[SiteIDDCM]=u.SiteIDDCM
				and r.AdID = u.AdID
			   and r.[ActivityDateTime] = u.[ActivityDateTime]
where  u.[dataDate] between '7/1/2018' AND cast(DATEADD(day,-1 - (DATEPART(weekday, GETDATE()) + @@DATEFIRST - 2) % 6,GETDATE()) as date)
 and 
r.campaignid in 		
 			 ('20900386','20941313','20909862','20930589','21358970','20911337','20911672','20909990','20930081','21375303','21375300','20905415','20945502','20956600',
			'20952465','20911874','20897425','20917062','20879302','20930781','20996370','21358967','20900716','20911892','20898355','20917662','20886313','21375294','20911277','21375003',
			'20881504','20943494','20910011','20911490','20931830','20903833','20911925','20925282','20886082','20898262','20955091','20882023','20904185','20919782','20931833','20890699',
			'20897323','20907205','20881159','20936427','20897326','20925522','20930051','20950494','21335638','20938881','20901067','21335635','20938884','20901070','21375600','20881501',
			'20938887','20942360','20890861','20949102','21361946','20945390','20930496','20953362','20900311','20951517','20942675','20949117','20925387','20904208','20941160','21375597',
			'20906161','20929071','20944923','20949714','20921913','20942408','20904196','20952379','20953564','20920398','21361031','21314749','21325477','21358946','21358052','21359949',
			'21360813','21352097','21361020','21375570','21335641','21039046','21375276','21358634','21360816','21354078','21375297','21343874','21352094','21358343','21359952','21351755',
			'21358637','21359955','21325471','21358346','21316486','21358964','21360390','21361037','21324382','21360761','21351752','21358349','21342203','21358370','21361017','21358055',
			'21358073','20916030','21358352','21354081','21374997','21344324','21374673','21359946','21343871','21358058','21335614','21358955','21316483','21374994','21325468','21360737',
			'21375573','21314743','21374991','21362442','21374973','21314746','21344318','20948838','21361931','21360810','21360755','21352091','20985734','20922888','20910562','20949756',
			'20911301','21020461','20886115','20880895','21337162','21377742','21377697','21364946','21337144','20953561','21378027','21373830','21363197','21364682','21363161','21363158',
			'21378024','21337171','21337141','21337138','21362876','21337159','21364967','21339043','21377724','21335437','21363179','21364940','21377721','21378003','21364964','21378000',
			'21364937','21364961','21364934','21378021','21377454','21335410','21362903','21018697','20882110','21377715','21364979','21365231','21337165','21377448','21364943','20905229',
			'20906269','21399560','20911063','20936897','20898232','20931800','20928516','20945562','20943752','20943497','20942678',
			'21592888','21469148','21759866','21476240','21600060',			--Q2 Incremental Campaigns
			'21901858','21900818','21895030','21881940','21895027','21885192')	--Launched in Q2(10/26/2018 or later) 
group by  r.[dataDate] 
		,r.[PlacementID]
		,r.[Campaign]
		,r.campaignid
		,r.[Placement]
	   	,r.Activity

go 
