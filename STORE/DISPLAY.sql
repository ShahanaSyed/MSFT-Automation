


ALTER VIEW [dbo].[vw.REPORT_STORE_WeeklyPacing_Display_SS]
AS
SELECT [Date]
			,[Campaign]
			,case	when Placement like '%Dell Co-Marketing BTS%' then 'Dell Back to School'
					when Placement like '%_Xbox Platform_Ultimate Games Sales_In-Market for Electronics Targeting_%' or Placement like '%_Ultimate Games Sales_Gaming and Tech Contextual Keyword Targeting_%' or Placement like '%_Ultimate Games Sales_Xbox Devices Purchaser Look-a-like Targeting_%' or placement like '%_Gaming and Tech Contextual Targeting_%' or Placement like '%_Ultimate Games Sales_Gaming Sitelist_%' then  'Ultimate Games Sale - Physical'
					when Placement like '%_Dell Computer Purchasers_%' or Placement like '%_Dell PC In-Market_%'or Placement like '%_Dell_Cart Abandoner_%' or placement like '%_PC Product Page Visitors_%' or Placement like '%_Dell_Contextual KW Targeting_%' then 'Dell Brand Awareness Co-Marketing'
					when Placement like '%_Intel Co-Marketing_%' then 'Intel Co-Marketing'
					when Placement like '%FUSION MEDIA GROUP»Store PRO_Xbox Games Pass_Ultimate Games Sales_%' or Placement like '%REDDIT»Store PRO_Xbox Games Pass_Ultimate Games Sales_%' then 'Ultimate Games Sale - Digital'
					when Placement like '%_Dell PC In-Market_%' then 'Dell PC In-Market'
				else 'Evergreen' end [Campaign type]			
			,[Placement]
			,[Channel]
			,[Week Start]
			,[Week End]
			,[Week Number]
			,CONCAT('Week ',[Week Number],' (',[Week Start],'-',[Week End],')')[Week]
			,[Month]
			,[Quarter]
			,[Tactic]
			,[Audience]
			,[Budget Source]
			,[Partner]
			,[Product Category]
			--,case	when Audience = 'Cart Abandoner' then 'Abandon Cart'
			--		when Audience = 'Cart Abandoner - Additional Dell BTS SKUs' then 'Abandon Cart - Additional Dell BTS SKUs'
   			,[A13 Region]
			,[Country]
			,[Market]
			,[Country Name]
			,[CDS 17]
			,[Media Lead Region]
			,[Media Sync Group]
	 ,sum(([Impressions]))[Impressions]
      ,sum(([Clicks]))[Clicks]
      ,isnull(sum([ClickthroughConversions]),0)[ClickthroughConversions]
      ,isnull(sum([ViewthroughConversions]),0)[ViewthroughConversions]
      ,isnull(sum([ClickthroughRevenue]),0)[ClickthroughRevenue]
      ,isnull(sum([ViewthroughRevenue]),0)[ViewthroughRevenue]
	  ,isnull(sum([Units]),0)[Units]
	  ,isnull(sum([ViewthroughConversions 45%]),0)[ViewthroughConversions 45%]
	  ,isnull(sum([USD ClickthroughRevenue]),0)[USD ClickthroughRevenue]
	  ,isnull(sum([USD ViewthroughRevenue 45%]),0)[USD ViewthroughRevenue 45%]
	  ,isnull(sum([View Through Units 45%]),0)[View Through Units 45%]
	  ,isnull(sum([Click Through Units]),0)[Click Through Units]
FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM6_SS]a
left join [dbo].[CurrencyConversions] b
on a.[Country] =b.[ISO 3-Letter Country Code]
group by	[Date]
			,[Campaign]
			,[Placement]
			,[Channel]
			,[Week Start]
			,[Week End]
			,[Week Number]
			,[Month]
			,[Quarter]
			,[Tactic]
			,[Budget Source]
			,[Partner]
			,[Product Category]
			,[Audience]
   			,[A13 Region]
			,[Country]
			,[Market]
			,[Country Name]
			,[CDS 17]
			,[Media Lead Region]
			,[Media Sync Group]


go


-------------------------------------------------------------------------------------


ALTER view [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM6_SS]
as
	SELECT a.[Date]
		,a.Campaign
		,a.[Placement]
		,a.Country
		,'Display'[Channel]
	
		,replace((convert(varchar,(DATEADD(dd, -(DATEPART(dw, a.[Date])-1), a.[Date])),1)),'/','.') [Week Start]
		,replace((convert(varchar,(DateADD(dd, 7-(DatePART(dw, a.[Date])), a.[Date])),1)),'/','.')  [Week End]
		,right(([dbo].[FiscalWeek]('07',a.[Date])),2) [Week Number]
		,case when month(a.[Date]) = 1 then 'Jan'
			when month(a.[Date]) = 2 then 'Feb'
			when month(a.[Date]) = 3 then 'Mar'
			when month(a.[Date]) = 4 then 'Apr'
			when month(a.[Date]) = 5 then 'May'
			when month(a.[Date]) = 6 then 'Jun'
			when month(a.[Date]) = 7 then 'Jul'
			when month(a.[Date]) = 8 then 'Aug'
			when month(a.[Date]) = 9 then 'Sep'
			when month(a.[Date]) = 10 then 'Oct'
			when month(a.[Date]) = 11 then 'Nov'
			when month(a.[Date]) = 12 then 'Dec'
			end [Month]
		,case	when month(a.[Date]) = 7 OR month(a.[Date]) = 8 OR month(a.[Date]) = 9 then 'Q1'
				when month(a.[Date]) = 10 OR month(a.[Date]) = 11 OR month(a.[Date]) = 12 then 'Q2'
				when month(a.[Date]) = 1 OR month(a.[Date]) = 2 OR month(a.[Date]) = 3 then 'Q3'
				when month(a.[Date]) = 4 OR month(a.[Date]) = 5 OR month(a.[Date]) = 6 then 'Q4'
				END [Quarter]
		, case	when a.[Placement] like '%»RT»%' then 'Retargeting'
				when a.[Placement] like '%»PRO»%' AND a.[Placement] like '%- E3 -%' then 'Prospecting-E3'
				when a.[Placement] like '%»PRO»%' AND a.[Placement] not like '%E3%' AND a.[Placement] not like '%Graduation%' then 'Prospecting'
				when a.[Placement] like '%»PRO»%' AND a.[Placement] like '%Graduation%' then 'Prospecting-Graduation'
				when a.[Placement] like '%Overlay%' then 'Retargeting'
				when a.[Placement] like '%»LAL»%' then 'Lookalike'
			--	when a.Placement like '%Contextual Keyword Targeting%' then 'Dell and PC Contextual Keyword Targeting_Dell13_'
				when a.Placement like '%Contextual Targeting%' or a.Placement like '%»CTX»%' then 'Contextual Targeting'
			--	when a.[Placement] like '%Purchaser LAL Targeting%' or a.[Placement] like '%Purchaser Look-a-like Targeting%' then 'Purchaser LAL Targeting'
				end [Tactic]
		,CASE  	WHEN a.[Placement] like 'AMOBEE%' THEN 'Amobee'
				WHEN a.[Placement] like 'AMNET-AAC%' THEN 'Adobe'
				WHEN a.Placement like 'MSFT Programmatic%' or a.[Placement] like '%DBM%' THEN 'DV360'
				when a.Placement like 'FUSION MEDIA GROUP%' then 'FMG'
				when a.Placement like 'REDDIT%' then 'REDDIT'
				END	[Partner]
		,case	when a.[Placement] like '%In-Market for Electronic Targeting%' then 'Xbox Platform'
				when a.[Placement] like '%Gaming%' then 'Xbox Platform'
				when a.[Placement] like '%Gaming and Tech CTX Keyword Targeting%' then 'Xbox Platform'
				when a.[Placement] like '%XDL%' then 'Xbox Design Lab'
				when a.[Placement] like '%Minecraft%' then 'Minecraft'
				when a.Placement like '%Surface Accessories%' or a.Placement like '%Surface Devices%' or a.Placement like '%Surface%' then 'Surface'
				when a.[Placement] like '%XboxLiveGold_%' then 'Xbox Live Gold'
				when a.[Placement] like '%xbox live gold%' then 'Xbox Live Gold'
				when a.Placement like '%xbox platform devices%' or a.Placement like '%xbox platform games%' then 'Xbox Platform'
				when a.[Placement] like '%_Windows Software_%' then 'Windows Software'
				when a.[Placement] like '%_Software_%' then 'Software'
				when a.[Placement] like '%Xbox Design Lab%' then 'Xbox Design Lab'
				when a.[Placement] like '%Hololens%' then 'Hololens'
				--when a.[Placement] like '%Xbox games%' then 'Xbox Platform'
				when a.[Placement] like '%Xbox Devices%' then 'Xbox Platform'
				when a.[Placement] like '%Xbox accessories%' then 'Xbox Platform'
				when a.[Placement] like '%Xbox.com%' then 'Xbox Platform'
				when a.[Placement] like '%XboxPlatform%' or a.[Placement] like '%Xbox Platform%'then 'Xbox Platform'
				when a.[Placement] like '%»HK»%' then 'Other'
				when a.[Placement] like '%_Other%' then 'Other'
				when a.[Placement] like '%Xbox Graduation%' then 'Xbox Platform'
				when a.[Placement] like '%Xbox One X%' or a.[Placement] like '%Xbox General%' or a.[Placement] like '%Xbox One S%' or a.Campaign like '%XboxPlatform%' then 'Xbox Platform' 
				when a.Campaign like '%XboxDesignLab%' then 'Xbox Design Lab'
				when a.[Placement] like '%_Windows Devices_%' then 'Windows Devices'
				when a.Placement like '%_Xbox Games Pass_%' then 'Xbox GamePass & Games'
				else 'Other'
				end [Product Category]
		,case		when a.Placement like '%overlay%' then 'Overlay' --good
					when a.Placement like '%_Cart Abandoner_USA%' then 'Abandon Cart'

					when a.Placement like '%Cart Abandoner - Additional Dell BTS SKUs%' then 'Abandon Cart - Additional Dell BTS SKUs'
					
					when a.Placement like '%_PC and Tech Contextual Targeting_Dell13%' then 'PC and Gaming Contextual Targeting_Dell13'
					when a.Placement like '%_PC and Gaming Contextual Targeting_Dell15%' then 'PC and Gaming Contextual Targeting_Dell15'
					when a.Placement like '%_PC and Gaming Contextual Targeting_XPS13%' then 'PC and Gaming Contextual Targeting_XPS13'
			
					when a.Placement like '%_Dell PC Purchaser LAL Targeting_Dell13_%' then 'Dell PC Purchaser LAL Targeting_Dell13'
					when a.Placement like '%_Dell PC Purchaser LAL Targeting_Dell15_%' then 'Dell PC Purchaser LAL Targeting_Dell15'
					when a.Placement like '%_Dell PC Purchaser LAL Targeting_XPS13_%' then 'Dell PC Purchaser LAL Targeting_XPS13'		

					when a.Placement like '%_Cart Abandoner_Dell13_%' then 'Abandon Cart_Dell 13'
					when a.Placement like '%_Cart Abandoner_Dell15_%' then 'Abandon Cart_Dell 15'
					when a.Placement like '%_Cart Abandoner_XPS13_%' then 'Abandon Cart_XPS13'	

					when a.Placement like '%_In-Market for Dell PC Targeting_Dell13_%' then 'In-Market for Dell PC Targeting_Dell13'
					when a.Placement like '%_In-Market for Dell PC Targeting_Dell15_%' then 'In-Market for Dell PC Targeting_Dell15'
					when a.Placement like '%_In-Market for Dell PC Targeting_XPS13_%' then 'In-Market for Dell PC Targeting_XPS13'

					when a.Placement like '%_Custom Intent_Dell13_%' then 'Custom Intent_Dell13'
					when a.Placement like '%_Custom Intent_Dell15_%' then 'Custom Intent_Dell15'
					when a.Placement like '%_Custom Intent_XPS13%' then 'Custom Intent XPS 13'
					
					when a.Placement like '%_Product Page - Additional Dell BTS SKUs_Dell13_%' then 'Product Page - Additional Dell BTS SKUs_Dell13'
					when a.Placement like '%_Product Page - Additional Dell BTS SKUs_Dell15_%' then 'Product Page - Additional Dell BTS SKUs_Dell15'
					when a.Placement like '%_Product Page - Additional Dell BTS SKUs_XPS13_%' then 'Product Page - Additional Dell BTS SKUs_XPS13'

					when a.Placement like '%_Dell Product Page Retargeting_Dell13_%' then 'Dell Product Page Retargeting_Dell13'
					when a.Placement like '%_Dell Product Page Retargeting_Dell15_%' then 'Dell Product Page Retargeting_Dell15'
					when a.Placement like '%_Dell Product Page Retargeting_XPS13_%' then 'Dell Product Page Retargeting_XPS13'
												
					when a.Placement like '%In-Market for Electonics%' then 'In-Market for Electronics'
					when a.Placement like '%STORE PRO -%' and a.Placement like '%In-Market:%' then 'In-Market: Computer Device Purchase Intenders'
										
					when a.Placement like '%Store RTG_%'and a.Placement like '%[_]%[_]%[_]%[_]%'  then substring(a.Placement,(charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1))+1,
																					charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1)+1)-
																					(charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1))-1)--good
					when a.Placement like '%Store RTG%' and a.Placement like '%[-]%[-]%[-]%[-]%'  then  substring(a.Placement,(charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1))+1,
										charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1)+1)-
										(charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1))-1)--good
					
					
					when a.Placement like '%STORE CTX_%'and a.Placement like '%[_]%[_]%[_]%[_]%'  then substring(a.Placement,(charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1))+1,
																					charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1)+1)-
																					(charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1))-1)--good
				
					
					when a.Placement like '%STORE RT -%' and a.Placement not like '%- Other -%' and a.Placement like '%[-]%[-]%[-]%[-]%[-]%'  then substring(a.Placement,(charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1))+1,
						charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1)+1)-
						(charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1))-1) --good

					when a.Placement like '%STORE RT -%' and a.Placement like '%- Other -%' and a.Placement like '%[-]%[-]%[-]%[-]%[-]%[-]%'  then  substring(a.Placement,(charindex('-',a.Placement,charindex('-',a.Placement,
												charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1)+1))+1,charindex('-',a.Placement,charindex('-',a.Placement,
												charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1)+1)+1)-
												(charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1)+1))-1)--good

					when a.Placement like '%STORE LAL_%' and a.Placement like '%[_]%[_]%[_]%[_]%' then substring(a.Placement,(charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1))+1,
						charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1)+1)-
						(charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1))-1) --good

					when a.Placement like '%Store PRO -%' and a.Placement like '%In-Market For Electronics%' then 'In-Market for Electronics'
					when a.Placement like '%Store PRO -%' and a.Placement like 'AMNET-DBM»Store PRO - Xbox - E3 - In-Market for Electronic Targeting%' then 'In-Market for Electronic Targeting'
					when a.Placement like '%Store PRO -%' and a.Placement like '%In-Market:%' then 'In-Market: Computer Device Purchase Intenders' --good
					when a.Placement like '%Store PRO -%' and a.Placement like '%[-]%[-]%[-]%[-]%[-]%' then  substring(a.Placement,(charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1))+1,
												charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1)+1)-
												(charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1))-1) --good
					when a.Placement like '%Store PRO -%' and a.Placement like '%[-]%[-]%[-]%[-]%' then  substring(a.Placement,(charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1))+1,
												charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)+1)-
												(charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1))-1)--good
					when a.Placement like 'AMOBEE»Store PRO -%' and a.Placement like '%[-]%[-]%[-]%' then substring(a.Placement,(charindex('-',a.Placement,charindex('-',a.Placement)+1))+1,
												charindex('-',a.Placement,charindex('-',a.Placement,charindex('-',a.Placement)+1)+1)-
												(charindex('-',a.Placement,charindex('-',a.Placement)+1))-1)--good
					when a.placement like '%STORE PRO_%'and a.Placement like '%[_]%[_]%[_]%[_]%' then  substring(a.Placement,(charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1))+1,
												charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1)+1)-
												(charindex('_',a.Placement,charindex('_',a.Placement,charindex('_',a.Placement)+1)+1))-1)--good
					else ''
					end Audience
		,case when a.Placement like '%Co-Marketing%' or a.Placement like '%Ultimate%' or a.campaign like '%Display WindowsDevices- CoMarketing%' or a.campaign like '%Display - PLM INC%' then 'Incremental' else 'TAC' end [Budget Source]
	  ,sum(distinct(a.[Impressions])) [Impressions]
      ,sum(distinct(a.[Clicks])) [Clicks]
      ,sum(distinct(b.[ClickthroughConversions])) [ClickthroughConversions]
      ,sum(distinct(b.[ViewthroughConversions])) [ViewthroughConversions]
      ,sum(distinct(b.[ClickthroughRevenue])) [ClickthroughRevenue]
      ,sum(distinct(b.[ViewthroughRevenue])) [ViewthroughRevenue]
	  ,sum(distinct(b.[Units])) [Units]
	  ,sum(distinct(b.[ViewthroughConversions 45%])) [ViewthroughConversions 45%]
	  ,sum(distinct(b.[USD ClickthroughRevenue])) [USD ClickthroughRevenue]
	  ,sum(distinct(b.[USD ViewthroughRevenue 45%])) [USD ViewthroughRevenue 45%]
	  ,sum(distinct(b.[View Through Units 45%])) [View Through Units 45%]
	  ,sum(distinct(b.[Click Through Units])) [Click Through Units]
  FROM  [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM5_SS] a
  left join  [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM3_SS] b
on a.[Date] = b.[Date]
AND a.PlacementID = b.PlacementID
GROUP BY a.[Date]
		,a.Campaign
        ,a.[Placement]
		,a.Country
		
GO

------------------------------------------------------------------------------------------------------------------------

alter view [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM5_SS]
as
SELECT [Date]
      ,[Campaign]
      ,[Placement]
      ,[PlacementID]
     ,case	when Placement like '%Overlay%' and right(Placement,6) = 'PPLJ9X' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVN9' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVNP' then 'USA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVR8' then 'FRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVSY' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVT3' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVTH' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVTR' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVVK' then 'USA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVW5' then 'USA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVXW' then 'USA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLVY5' then 'FRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLW1B' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLW1K' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLW1M' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLW1R' then 'USA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLW20' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLW27' then 'BRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLW3Y' then 'ARG'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLW43' then 'CHL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLW4B' then 'COL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJ8R' then 'ITA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJB4' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJBM' then 'PRT'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJBS' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJBY' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJC6' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJD2' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJD8' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJDK' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJDW' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJF0' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJF7' then 'DNK'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJFC' then 'NOR'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJJ0' then 'SWE'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJJJ' then 'FIN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJJV' then 'FRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJK2' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJK4' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPLJK5' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYW3' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYWH' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYWL' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYXW' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYZ1' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYZ5' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYZC' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSZ3Q' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSZ4H' then ''
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYY3' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYXP' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYXS' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYXY' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSZ4V' then 'DEU'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSZ56' then 'AUT'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY1W' then 'POL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSYYW' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY23' then 'USA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBX9R' then 'ITA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY1S' then 'MEX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PPSZ40' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBX9W' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQP39V' then 'KOR'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBX9Y' then 'DNK'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBXB0' then 'FIN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBXB2' then 'NOR'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBXB4' then 'SWE'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBX9X' then 'PRT'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBX9N' then 'FRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBXB6' then 'BRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBXBC' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY2N' then 'ITA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBXBF' then 'CHN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY33' then 'USA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY35' then 'MEX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY3C' then 'BRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY3F' then 'ARG'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY3H' then 'COL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY3J' then 'CHL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY3T' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQWF95' then 'MEX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQWF9H' then 'BRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQWFBH' then 'ARG'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQWFBM' then 'COL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQWFBQ' then 'CHL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY42' then 'CHN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY47' then 'CHN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBY4M' then 'CHN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBXBH' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBXBK' then 'PRT'
				when Placement like '%Overlay%' and right(Placement,6) = 'PQBXBN' then 'ITA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR8MGJ' then 'USA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR9189' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR918C' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR918K' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR919L' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR919Q' then 'NOR'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR919T' then 'SWE'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR918S' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR918Y' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR919N' then 'FIN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR91PC' then 'CAN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR919M' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR91NR' then 'USA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR91PD' then 'CAN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR91PG' then 'NOR'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR91PZ' then 'JPN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PRSQ4D' then 'PRT'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR95K8' then 'FRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR95KD' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR91PR' then 'JPN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR91Q8' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR91QF' then 'FIN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR91QJ' then 'POL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PRSPZC' then 'PRT'
				when Placement like '%Overlay%' and right(Placement,6) = 'PRSQ4Y' then 'ITA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR91PM' then 'SWE'
				when Placement like '%Overlay%' and right(Placement,6) = 'PRSQ5G' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PRSQ5M' then 'PRT'
				when Placement like '%Overlay%' and right(Placement,6) = 'PRSQ5Q' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GMR' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR953N' then 'ARG'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR953Q' then 'COL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR954C' then 'CHL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR954G' then 'BRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR953J' then 'MEX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PRSQ5C' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PRSQ5W' then 'DNK'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GK9' then 'NOR'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GKF' then 'SWE'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GKG' then 'FIN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GKQ' then 'GBR'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GKY' then 'DEU'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GL6' then 'AUS'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GM0' then 'IRL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GM5' then 'SGP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GMC' then 'NZL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GNH' then 'DNK'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GNV' then 'NOR'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GNY' then 'SWE'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GP0' then 'FIN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GP2' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GP5' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GP9' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GT3' then 'POL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GN5' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3X' then 'NOR'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3Z' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3P' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GT6' then 'ITA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GN8' then 'PRT'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR95SZ' then 'FRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3Z' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3R' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR92SL' then 'CAN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR955J' then 'COL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GT4' then 'CHN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR955T' then 'CHL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3Q' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR954J' then 'BRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3Y' then 'FIN'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P42' then 'FRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PSHSTD' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PSHSV6' then 'LUX'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3M' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3V' then 'DNK'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3M' then 'BEL'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GT2' then 'NLD'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GN5' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3L' then 'BEL'

				when Placement like '%Overlay%' and right(Placement,6) = 'PR95M7' then 'FRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR95SZ' then 'FRA'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR95T4' then 'ESP'
				when Placement like '%Overlay%' and right(Placement,6) = 'PR95T8' then 'PRT'

				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P44' then 'FRA' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GN5' then 'EST' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GN8' then 'PRT' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GN5' then 'EST' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PS1GN8' then 'PRT' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3K' then 'FRA' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P3L' then 'NLD' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PR92SR' then 'USA' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PR95M7' then 'USA' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PR95SZ' then 'JPN' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PSHSTD' then 'NLD' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PSHSTZ' then 'FRA' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PSHSV6' then 'DEU' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PR95T4' then 'EST' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PR95T8' then 'PRT' 
				when Placement like '%Overlay%' and right(Placement,6) = 'PS8P42' then 'FRA' 

				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PS8P3N'  then 'BEL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PS8P3W'  then 'SWE'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PS8P3N'  then 'BEL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PS8P3W'  then 'SWE'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PS8P40'  then 'PRT'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PR9555'  then 'ARG'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PR9551'  then 'MEX'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PR92SD'  then 'USA'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PR95L0'  then 'MEX'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PR92SD'  then 'MEX'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PS1GMR'  then 'LUX'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PS8P41'  then 'FRA'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PS8P40'  then 'PRT'

				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PS1GMR' then 'LUX'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PS8P45' then 'BEL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSV9' then 'SGP'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSWC' then 'NLD'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSWG' then 'BEL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSWL' then 'BEL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSWW' then 'ESP'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSX5' then 'PRT'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSXD' then 'DNK'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSXH' then 'NOR'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSXM' then 'SWE'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSXR' then 'FIN'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSXS' then 'ITA'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSXY' then 'USA'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSY2' then 'CAN'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSY8' then 'CAN'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HJ' then 'AUS'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HL' then 'NZL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HN' then 'JPN'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HQ' then 'GBR'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HS' then 'DEU'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HV' then 'AUT'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HX' then 'IRL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1J0' then 'CHN'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1J1' then 'CHN'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1J2' then 'ESP'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1J3' then 'PRT'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PR95TY' then 'ITA'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PT9QMH' then 'SGP'

				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSYC' then 'CAN'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HK' then 'AUS'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HM' then 'NZL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HP' then 'JPN'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HR' then 'GBR'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HT' then 'DEU'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HW' then 'AUT'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HY' then 'IRL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSY0' then 'USA'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSY4' then 'CAN'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1HZ' then 'FRA'

				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PTX1J5' then 'FRA'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PSHSW3' then 'SGP'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PT9QMW' then 'NLD'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PT9QN6' then 'BEL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PT9QP4' then 'BEL'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PT9QPN' then 'FRA'
				when Placement like '%Overlay%' and RIGHT(Placement,6) = 'PT9QPW' then 'GBR'

				when Placement like '%ARE%' collate SQL_Latin1_General_CP1_CS_AS  then 'ARE'
				when Placement like '%ARG%' collate SQL_Latin1_General_CP1_CS_AS  then 'ARG'
				when Placement like '%AUS%' collate SQL_Latin1_General_CP1_CS_AS then 'AUS'
				when Placement like '%AUT%' collate SQL_Latin1_General_CP1_CS_AS then 'AUT'
				when Placement like '%BEL%' collate SQL_Latin1_General_CP1_CS_AS then 'BEL'
				when Placement like '%BRA%' collate SQL_Latin1_General_CP1_CS_AS then 'BRA'
				when Placement like '%CAN%' collate SQL_Latin1_General_CP1_CS_AS then 'CAN'
				when Placement like '%EGY%' collate SQL_Latin1_General_CP1_CS_AS then 'EGY'
				when Placement like '%CHE%' collate SQL_Latin1_General_CP1_CS_AS then 'CHE'
				when Placement like '%CHL%' collate SQL_Latin1_General_CP1_CS_AS then 'CHL'
				when Placement like '%COL%' collate SQL_Latin1_General_CP1_CS_AS then 'COL'
				when Placement like '%CRI%' collate SQL_Latin1_General_CP1_CS_AS then 'CRI'
				when Placement like '%CZE%' collate SQL_Latin1_General_CP1_CS_AS then 'CZE'
				when Placement like '%DEU%' collate SQL_Latin1_General_CP1_CS_AS then 'DEU'
				when Placement like '%DNK%' collate SQL_Latin1_General_CP1_CS_AS then 'DNK'
				when Placement like '%ESP%' collate SQL_Latin1_General_CP1_CS_AS then 'ESP'
				when Placement like '%EST%' collate SQL_Latin1_General_CP1_CS_AS then 'EST'
				when Placement like '%FIN%' collate SQL_Latin1_General_CP1_CS_AS then 'FIN'
				when Placement like '%FRA%' collate SQL_Latin1_General_CP1_CS_AS then 'FRA'
				when Placement like '%GBR%' collate SQL_Latin1_General_CP1_CS_AS then 'GBR'
				when Placement like '%GRC%' collate SQL_Latin1_General_CP1_CS_AS then 'GRC'
				when Placement like '%HKG%' collate SQL_Latin1_General_CP1_CS_AS then 'HKG'
				when Placement like '%HUN%' collate SQL_Latin1_General_CP1_CS_AS then 'HUN'
				when Placement like '%IDN%' collate SQL_Latin1_General_CP1_CS_AS then 'IDN'
				when Placement like '%IND%' collate SQL_Latin1_General_CP1_CS_AS then 'IND'
				when Placement like '%IRL%' collate SQL_Latin1_General_CP1_CS_AS then 'IRL'
				when Placement like '%ISR%' collate SQL_Latin1_General_CP1_CS_AS then 'ISR'
				when Placement like '%ITA%' collate SQL_Latin1_General_CP1_CS_AS then 'ITA'
				when Placement like '%JPN%' collate SQL_Latin1_General_CP1_CS_AS then 'JPN'
				when Placement like '%KOR%' collate SQL_Latin1_General_CP1_CS_AS then 'KOR'
				when Placement like '%KWT%' collate SQL_Latin1_General_CP1_CS_AS then 'KWT'
				when Placement like '%LUX%' collate SQL_Latin1_General_CP1_CS_AS then 'LUX'
				when Placement like '%MEX%' collate SQL_Latin1_General_CP1_CS_AS then 'MEX'
				when Placement like '%MYS%' collate SQL_Latin1_General_CP1_CS_AS then 'MYS'
				when Placement like '%NLD%' collate SQL_Latin1_General_CP1_CS_AS then 'NLD'
				when Placement like '%NOR%' collate SQL_Latin1_General_CP1_CS_AS then 'NOR'
				when Placement like '%NZL%' collate SQL_Latin1_General_CP1_CS_AS then 'NZL'
				when Placement like '%PER%' collate SQL_Latin1_General_CP1_CS_AS then 'PER'
				when Placement like '%PHL%' collate SQL_Latin1_General_CP1_CS_AS then 'PHL'
				when Placement like '%POL%' collate SQL_Latin1_General_CP1_CS_AS then 'POL'
				when Placement like '%PRT%' collate SQL_Latin1_General_CP1_CS_AS then 'PRT'
				when Placement like '%SAU%' collate SQL_Latin1_General_CP1_CS_AS then 'SAU'
				when Placement like '%SGP%' collate SQL_Latin1_General_CP1_CS_AS then 'SGP'
				when Placement like '%SVK%' collate SQL_Latin1_General_CP1_CS_AS then 'SVK'
				when Placement like '%SWE%' collate SQL_Latin1_General_CP1_CS_AS then 'SWE'
				when Placement like '%THA%' collate SQL_Latin1_General_CP1_CS_AS then 'THA'
				when Placement like '%TUR%' collate SQL_Latin1_General_CP1_CS_AS then 'TUR'
				when Placement like '%China%'collate SQL_Latin1_General_CP1_CS_AS then 'CHN'
				when Placement like '%CHN%'collate SQL_Latin1_General_CP1_CS_AS then 'CHN'
				when Placement like '%TWN%' collate SQL_Latin1_General_CP1_CS_AS then 'TWN'
				when Placement like '%USA%' collate SQL_Latin1_General_CP1_CS_AS then 'USA'
				when Placement like '%ZAF%' collate SQL_Latin1_General_CP1_CS_AS then 'ZAF'
				when Placement like '%CHE - DE%' collate SQL_Latin1_General_CP1_CS_AS then 'CHE'
				when Placement like '%HKG - EN%' collate SQL_Latin1_General_CP1_CS_AS then 'HKG'
				when Placement like '%IND - EN%' collate SQL_Latin1_General_CP1_CS_AS then 'IND' 
				end [Country]
      ,sum([Impressions])[Impressions]
      ,sum([Clicks])[Clicks]
 FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM4_SS]
 group by  [Date]
		,[Placement]
      ,[Campaign]
      ,[PlacementID]
    --  ,[Country]
GO

------------------------------------------------------------------------------------------------------------------------

ALTER View [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM4_SS] as
select  [dataDate] [Date]
		,Campaign
		,[Placement]
		,[PlacementID]
		,sum(([Impressions])) [Impressions]
		,sum(([Clicks])) [Clicks]
from [Fact].[dcmStandardRawData] a
where [CampaignID] in ('20928945','20917605','20920935','20943437','20885623','21313210','21306787','21314527','21336890','20931926','21353571','21337088','21337688','21314506','21353829','20938011'
						--Q2 Incremental Campaigns
						,'21421518','21469142','21460877')
		and ([Activity] like '%_PhysicalStore' OR [Activity] = '(not set)') 
		and right(Placement,6) not in ('PT9QP4')
		AND  [dataDate] between '7/1/2018' and cast(DATEADD(day,-1 - (DATEPART(weekday, GETDATE()) + @@DATEFIRST - 2) % 6,GETDATE()) as date)
group by [dataDate]
		,Placement
		,[Campaign]
		,[PlacementID] 
	--	,Market
GO

--select sum(impressions), sum(clicks) from [dbo].[vw.STAGING_STORE_WeeklyPacing_DCMStandard_SS] where date ='10/10/2018'
--SELECT SERVERPROPERTY ('Collation')


------------------------------------------------------------------------------------



alter view [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM3_SS]
as
SELECT [Date]
      ,[Campaign]
      ,[PlacementID]
      ,[Placement]
	  ,[ISO 3-Letter Country Code]
	  ,sum(isnull([Units],0))[Units]
      ,sum(isnull([ClickthroughConversions],0))[ClickthroughConversions]
      ,sum(isnull([ViewthroughConversions],0))[ViewthroughConversions]
      ,sum(isnull([ClickthroughRevenue],0))[ClickthroughRevenue]
      ,sum(isnull([ViewthroughRevenue],0))[ViewthroughRevenue]
	  ,sum(isnull([ViewthroughConversions 45%],0))[ViewthroughConversions 45%]
	  ,sum(isnull([USD ClickthroughRevenue],0))[USD ClickthroughRevenue]
      ,sum(isnull([USD ViewthroughRevenue 45%],0))[USD ViewthroughRevenue 45%]
	  ,case when (sum([ViewthroughConversions]) + sum([USD ViewthroughRevenue 45%]))>0 AND (sum([ClickthroughConversions])+sum([USD ClickthroughRevenue]))=0 
	  then 0 else sum([Units])-sum([ViewthroughConversions]) end [Click Through Units]
	  ,case when sum([ViewthroughConversions])>0 then (sum([Units])-sum([ClickthroughConversions]))*0.45 else 0 end [View Through Units 45%]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM2_SS]
  group by [Date]
      ,[Placement]
      ,[PlacementID]
      ,[campaign]
	  ,[ISO 3-Letter Country Code]
GO
     
--------------------------------------------------------------


ALTER view [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM2_SS]
AS
SELECT [Date]
      ,[Campaign]
      ,[PlacementID]
      ,[Placement]
	  ,[ISO 3-Letter Country Code]
	  ,sum(([Units])) [Units]
      ,sum(([ClickthroughConversions])) [ClickthroughConversions]
      ,sum(([ViewthroughConversions])) [ViewthroughConversions]
	  ,sum(([ClickthroughRevenue])) [ClickthroughRevenue]
	  ,sum(([ViewthroughRevenue])) [ViewthroughRevenue]
	  ,0.45*sum([ViewthroughConversions]) [ViewthroughConversions 45%]
      ,(sum([ClickthroughRevenue])/sum([CurrencyPerUSD])) [USD ClickthroughRevenue]
      ,0.45*(sum([ViewthroughRevenue])/sum([CurrencyPerUSD])) [USD ViewthroughRevenue 45%]
  FROM [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM1_SS] a
  left join [dbo].[CurrencyConversions] b
  on a.[CurrencyCodestring] = b.[Currency Code]
	and a.[Marketstring] = b.[Market]
  group by [Date]
      ,[Campaign]
      ,[PlacementID]
      ,[Placement]
	  ,[ISO 3-Letter Country Code]
GO



-------------------------------------------------------------------------------------

ALTER VIEW [dbo].[vw.STAGING_STORE_WeeklyPacing_DisplayDCM1_SS]
AS
select (r.[dataDate]) [Date]
		,r.Campaign
		,r.CampaignID
        ,r.[PlacementID]
       ,r.[Placement]
	   ,u.[Marketstring]
	   ,u.[CurrencyCodestring]
	   ,sum((cast(u.Unitsstring as numeric (3,0)))) Units
		,sum((r.[ClickthroughConversions])) [ClickthroughConversions]
		,sum((r.[ViewthroughConversions])) [ViewthroughConversions]
		,sum((r.[ClickthroughRevenue])) [ClickthroughRevenue]
		,sum((r.[ViewthroughRevenue])) [ViewthroughRevenue]
	   from [Fact].[dcmFloodlightRawData] r
right join [Fact].[dcmFloodlightUVariables] u
       on r.activityid = u.activityid
	   and r.[CampaignID] = u.[CampaignID]
       and r.[PlacementID] = u.[PlacementID]
      and r.[CreativeID] = u.[CreativeID]
	   and r.[AdvertiserID]=u.AdvertiserID
	   and r.[SiteIDDCM]=u.SiteIDDCM
	   and r.AdID = u.AdID
       and r.[ActivityDateTime] = u.[ActivityDateTime]

where r.activity in ('Store-Other_GBL_PchComplete_Transaction_PhysicalStore','Minecraft_GBL_PchComplete_Transaction_PhysicalStore',
					'Surface_GBL_PchComplete_Transaction_PhysicalStore','WindowsSoftware_GBL_PchComplete_Transaction_PhysicalStore','Software_GBL_PchComplete_Transaction_PhysicalStore',
					'XboxLiveGold_GBL_PchComplete_Transaction_PhysicalStore','XboxPlatform_GBL_PchComplete_Transaction_PhysicalStore','Hololens_GBL_PchComplete_Transaction_PhysicalStore',
					'XboxDesignLab_GBL_PchComplete_Transaction_PhysicalStore','Software_GBL_PchComplete_Transaction_PhysicalStore','WindowsDevices_GBL_PchComplete_Transaction_PhysicalStore')
				or [Activity] = '(not set)' 
		and right(Placement,6) not in ('PT9QP4')
and r.[CampaignID] in ('20885623','21314527','21313210','20959347','20917605','21360816','20882023','21337088','20929071','21360810',
						'20920935','21358370','21374997','21336890','20928945','20931926','20914075','20943437','21351752','21353829',
						'20925387','21352091','21306787','20942408','21353571','21325477','21325468','21343874','21360390','20904185',
						'20921913','20938011','21314749','20911874','21342203','21360755','21324382','21377448','21361017','21364682',
						'21335635','20905229','21359946','21316483','21337144','21314506','20930496','21354078','20911892','21359952',
						'20911925','20901067','21337688','21337165','21365231','21314743','21314746','21352094','21362442','21316486',
						'21354081','21364979','21363197','21375297','21358964','21377697','21364937','21364934','20925522','21377715',
						'21344324','21337171','21375600','21364967','21378027','21355750','21325471','21344318','21399560','21363179',
						'21359955','21378021','21335641','21378003','21391386','21374991','21375597',
						--Q2 Incremental Campaigns
						'21421518','21469142','21460877')
        and u.[dataDate] BETWEEN '7/1/2018' AND cast(DATEADD(day,-1 - (DATEPART(weekday, GETDATE()) + @@DATEFIRST - 2) % 6,GETDATE()) as date)
group by  r.[dataDate] 
			,r.[PlacementID]
		  ,r.[Placement]
		  ,r.Campaign
			,r.campaignID
		  ,u.[Marketstring]
		  ,u.[CurrencyCodestring]
GO







