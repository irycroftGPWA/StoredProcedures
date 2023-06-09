USE [36611_202212_ChoiceHW]
GO
/****** Object:  StoredProcedure [dbo].[sp_07_CREATE_GPWClaims]    Script Date: 5/18/2023 11:03:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_07_CREATE_GPWClaims] AS

--Test change for 2022
--test commit #2
DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWClaims')
	DROP TABLE GPWClaims
	
CREATE TABLE [GPWClaims] (
	
	--from Claims_Unique
	[Amount Authorized] [float] NULL,
	[Claim #] [nvarchar](255) NULL,
	[Claim Date] [datetime] NULL,
	[Contract Type] [nvarchar](255) NULL,
	[Contract Start] [datetime] NULL,
	[Contract End] [datetime] NULL,
	[Contract Term] [nvarchar](255) NULL,
	[Plan] [nvarchar](255) NULL,
	[Customer ID] [nvarchar](255) NULL,
	[AmountPaid] [float] NULL,
	[ibnr] [float] NULL

	--GPW fields
	,[GPWPlan] nvarchar(255) --12/31/2019 AJD added
	,[GPWClaimDate] date
	,[GPWClaimQuarter] nvarchar(255)
	,[GPWClaimQtr#] int
	,[GPWRelativeClaimQtr] int
	,[GPWActiveClaimCount] int
	,[GPWCancelClaimCount] int
	,[GPWClaimCount] int
	,[GPWActiveClaims] float
	,[GPWCancelClaims] float 
	,[GPWClaims] float
	,[GPWAuthorized] float
	,[GPWPaid] float
	
	--from GPWContracts
	,[GPWCoverage1] nvarchar(255)
	,[GPWCoverage2] nvarchar(255)
	,[GPW N/U/P] nvarchar(255)
	,[GPW Channel] NVARCHAR(255)
	,[GPWEffectiveDate] date
	,[TermMonths] float
	,[GPWTermMonths] float
	,[GPWCancelDate] date
	,[GPWEffectiveQuarter] nvarchar(255)
	,[GPWEffectiveQtr#] int NULL
	,[GPWEffectiveYear] int NULL
	,[GPWExpireDate] date NULL
	,[GPWCancelQuarter] nvarchar(255)
	,[GPWCancelQtr#] int NULL
	,[GPWRelativeCancelQtr] int NULL
	,[GPWFlatCancel] nvarchar(255)
	,[GPWContractCount] int
	,[GPWCancelCount] int
	,[GPWActiveReserve] float
	,[GPWCancelReserve] float
	,[GPWGrossReserve] float
	,[GPWContractType] varchar(255)
	,[GPWRenewalFlag] varchar(255)

)

INSERT INTO GPWClaims(
	[Amount Authorized],
	[Claim #],
	[Claim Date],
	[Contract Type],
	[Contract Start],
	[Contract End],
	[Contract Term],
	[Plan],
	[Customer ID],
	[AmountPaid],
	[ibnr]
	,[GPWPlan]
	,[GPWClaimDate]
	,[GPWClaimQuarter]
	,[GPWClaimQtr#]
	,[GPWRelativeClaimQtr]
	,[GPWActiveClaimCount]
	,[GPWCancelClaimCount]
	,[GPWClaimCount]
	,[GPWActiveClaims]
	,[GPWCancelClaims]
	,[GPWClaims]
	,[GPWAuthorized]
	,[GPWPaid]

	,[GPWCoverage1]
	,[GPWCoverage2]
	,[GPW N/U/P]
	,[GPW Channel]
	,[GPWEffectiveDate]
	,[TermMonths]
	,[GPWTermMonths]
	,[GPWCancelDate]
	,[GPWEffectiveQuarter]
	,[GPWEffectiveQtr#]
	,[GPWEffectiveYear]
	,[GPWExpireDate]
	,[GPWCancelQuarter]
	,[GPWCancelQtr#]
	,[GPWRelativeCancelQtr]
	,[GPWFlatCancel]
	,[GPWContractCount]
	,[GPWCancelCount]
	,[GPWActiveReserve]
	,[GPWCancelReserve]
	,[GPWGrossReserve]
	,[GPWContractType]
	,[GPWRenewalFlag]
	
)

SELECT
	 [Amount Authorized],
	[Claim #],
	[Claim Date],
	[Contract Type],
	[Contract Start],--not provided 12/31/2019
	[Contract End],--not provided 12/31/2019
	[Contract Term],
	[Plan],
	[Customer ID],
	[AmountPaid],
	[ibnr]
	,NULL as [GPWPlan] --12/31/2019 AJD
	,[Claim Date] AS GPWClaimDate
	,'' AS [GPWClaimQuarter]
	,0 AS [GPWClaimQtr#]
	,0 AS [GPWRelativeClaimQtr]
	,0 AS [GPWActiveClaimCount] 
	,0 AS [GPWCancelClaimCount]
	,0 AS [GPWClaimCount] 
	,0 AS [GPWActiveClaims] 
	,0 AS [GPWCancelClaims] 
	,0 AS [GPWClaims]
	,[Amount Authorized] as [GPWAuthorized]
	,[AmountPaid] as [GPWPaid]

	,null  --[GPWCoverage1] nvarchar(255)
	,null  --[GPWCoverage2] nvarchar(255)
	,null  --[GPW N/U/P] nvarchar(255)
	,null  --[GPW Channel] nvarchar(255),
	,null  --[GPWEffectiveDate] date
	,null  --[TermMonths] float
	,null  --[GPWTermMonths] float
	,null  --[GPWCancelDate] date
	,null  --[GPWEffectiveQuarter] nvarchar(255)
	,null  --[GPWEffectiveQtr#] int NULL
	,null  --[GPWEffectiveYear] int NULL
	,null  --[GPWExpireDate] date NULL
	,null  --[GPWCancelQuarter] nvarchar(255)
	,null  --[GPWCancelQtr#] int NULL
	,null  --[GPWRelativeCancelQtr] int NULL
	,null  --[GPWFlatCancel] nvarchar(255)
	,null  --[GPWContractCount] int
	,null  --[GPWCancelCount] int
	,null  --[GPWActiveReserve] float
	,null  --[GPWCancelReserve] float
	,null  --[GPWGrossReserve] float,
	,null --[GPWContractType] varchar
	,null --[GPWRenewalFlag] nvarchar

FROM Claims_Unique

--**********************
--Update YEARLY--
--**********************

Update GPWClaims
	Set [GPWCoverage1]=CO.[GPWCoverage1]
	,[GPWCoverage2]=CO.[GPWCoverage2]
	,[GPW N/U/P]=CO.[GPW N/U/P]
	,[GPW Channel] = CO.[GPW Channel]
	,[GPWPlan] = CO.GPWPlan		--12/31/2019 AJD
	,[GPWEffectiveDate]=CO.[GPWEffectiveDate]
	,[TermMonths]=CO.[TermMonths]
	,[GPWTermMonths]=CO.[GPWTermMonths]
	,[GPWCancelDate]=CO.[GPWCancelDate]
	,[GPWEffectiveQuarter]=CO.[GPWEffectiveQuarter]
	,[GPWEffectiveQtr#]=CO.[GPWEffectiveQtr#]
	,[GPWEffectiveYear]=CO.[GPWEffectiveYear]
	,[GPWExpireDate]=CO.[GPWExpireDate]
	,[GPWCancelQuarter]=CO.[GPWCancelQuarter]
	,[GPWCancelQtr#]=CO.[GPWCancelQtr#]
	,[GPWRelativeCancelQtr]=CO.[GPWRelativeCancelQtr]
	,[GPWFlatCancel]=CO.[GPWFlatCancel]
	,[GPWContractCount]=CO.[GPWContractCount]
	,[GPWCancelCount]=CO.[GPWCancelCount]
	,[GPWActiveReserve]=CO.[GPWActiveReserve]
	,[GPWCancelReserve]=CO.[GPWCancelReserve]
	,[GPWGrossReserve]=CO.[GPWGrossReserve]
	,[GPWContractType] = CO.[GPWContractType] --12/31/2019 AJD
	,[GPWRenewalFlag] = CO.[GPWRenewalFlag] --12/31/2019 AJD
FROM GPWClaims CL 
	LEFT JOIN GPWContracts CO ON
	CL.[Customer ID] = CO.Cust
	and CL.[Claim Date] between CO.GPWEffectiveDate and CO.GPWExpireDate
	--and CL.[Contract Start]=CO.[Start Date]
--WHERE CL.[Contract Type]='Yearly'  --not provided 12/31/2019




--SCRATCH
--There are claims that fall into two effective date windows (1460)
/*
select 
CL.[Claim #], count(*)
FROM GPWClaims CL 
	LEFT JOIN GPWContracts CO ON
	CL.[Customer ID] = CO.Cust
	and CL.[Claim Date] <= CO.GPWExpireDate
	and CL.[Claim Date] >= CO.GPWEffectiveDate
group by CL.[Claim #]
having count(*) > 1

--approx 71,174 claims / 15,872 customer id's / ~$9.2M in paid claims do not join on customer id
select 
count(distinct CL.[Claim #])
FROM GPWClaims CL 
	LEFT JOIN GPWContracts CO ON
	CL.[Customer ID] = CO.Cust
where CO.Cust is NULL and year(CL.[Claim Date]) < 2020
group by CL.[Customer ID]

select 
count(*)
FROM GPWClaims CL 
	LEFT JOIN GPWContracts CO ON
	CL.[Customer ID] = CO.Cust
where CO.Cust is NULL and year(CL.[Claim Date]) < 2020


select sum(Cl.AmountPaid)
FROM GPWClaims CL 
	LEFT JOIN GPWContracts CO ON
	CL.[Customer ID] = CO.Cust
where CO.Cust is NULL and year(CL.[Claim Date]) < 2020


--Most are from old monthly contracts prior to 2014 but 12,892 / ~$1.72M are still unable to join to a contract
select year(RawData_ContractsMonthly.[Start Date]) as ContractStartYear, sum(AmountPaid) as [AmountPaid], count(*) as [claimCount]
FROM GPWClaims CL 
	left JOIN GPWContracts CO ON
	CL.[Customer ID] = CO.Cust
	left join RawData_ContractsMonthly
	on CL.[Customer ID] = RawData_ContractsMonthly.Cust
	where CO.Cust is null and year(CL.[Claim Date]) < 2020 --and RawData_ContractsMonthly.Cust is not null
	group by year(RawData_ContractsMonthly.[Start Date])
	order by year(RawData_ContractsMonthly.[Start Date])


select year(CL.[Claim Date]), count(*)
FROM GPWClaims CL 
	left JOIN GPWContracts CO ON
	CL.[Customer ID] = CO.Cust
	left join RawData_ContractsMonthly
	on CL.[Customer ID] = RawData_ContractsMonthly.Cust
	where CO.Cust is null and RawData_ContractsMonthly.Cust is null and year(CL.[Claim Date]) < 2020
	group by year(CL.[Claim Date])
*/
--END SCRATCH

--CHECK
/*
select year([contract start]), count(*), sum([amount authorized])
from GPWClaims	
where gpweffectivedate is null and [Contract Type]='Yearly'
group by year([contract start])
order by year([contract start])
*/
--**
--Mostly 2012 & Prior and 2018 where there is no match
--**



--**********************
--Update MONTHLY--12/31/2019 AJD updating all at once
--**********************

--Update GPWClaims
--	Set [GPWCoverage1]=CO.[GPWCoverage1]
--	,[GPWCoverage2]=CO.[GPWCoverage2]
--	,[GPW N/U/P]=CO.[GPW N/U/P]
--	,[GPW Channel] = CO.[GPW Channel]
--	,[GPWEffectiveDate]=CO.[GPWEffectiveDate]
--	,[TermMonths]=CO.[TermMonths]
--	,[GPWTermMonths]=CO.[GPWTermMonths]
--	,[GPWCancelDate]=CO.[GPWCancelDate]
--	,[GPWEffectiveQuarter]=CO.[GPWEffectiveQuarter]
--	,[GPWEffectiveQtr#]=CO.[GPWEffectiveQtr#]
--	,[GPWEffectiveYear]=CO.[GPWEffectiveYear]
--	,[GPWExpireDate]=CO.[GPWExpireDate]
--	,[GPWCancelQuarter]=CO.[GPWCancelQuarter]
--	,[GPWCancelQtr#]=CO.[GPWCancelQtr#]
--	,[GPWRelativeCancelQtr]=CO.[GPWRelativeCancelQtr]
--	,[GPWFlatCancel]=CO.[GPWFlatCancel]
--	,[GPWContractCount]=CO.[GPWContractCount]
--	,[GPWCancelCount]=CO.[GPWCancelCount]
--	,[GPWActiveReserve]=CO.[GPWActiveReserve]
--	,[GPWCancelReserve]=CO.[GPWCancelReserve]
--	,[GPWGrossReserve]=CO.[GPWGrossReserve]
--FROM GPWClaims CL 
--	LEFT JOIN GPWContracts CO ON
--	CL.[Customer ID] = CO.Cust
--	and CL.GPWClaimDate between CO.GPWEffectiveDate and CO.GPWExpireDate
--WHERE CL.[Contract Type]='Monthly'


/*CHECK FOR TOTALS
select count(*), sum([gpwauthorized]), sum([gpwpaid])
from gpwclaims

select count(*), sum([amount authorized]), sum([amountpaid])
from claims_unique
 

 */

 --**********************
--Update BLANKS as much as possible
--**********************

Update GPWClaims
	Set
	[GPW N/U/P]=case when [Contract Type] = 'Monthly' then [Contract Type]
		else 'Original' end  -- set all Yearly claims to original
	,[GPWEffectiveDate]= case when [Contract Type] = 'Monthly' and [Contract Start]>='1/1/2014' then cast([Claim Date] as date) else cast([Contract Start] as date) end  --ACL added for monthly with no match
	,[GPWExpireDate]= cast([Contract End] as date)
	,[GPWFlatCancel]=''
	,[TermMonths]=case when [Contract Type] = 'Monthly' then 1
		else datediff(m,[Contract Start],[Contract End]) end
FROM GPWClaims 
WHERE GPWEffectiveDate is null 

--ACL: added per Victor, monthly contracts with sale date < 1/1/2014 do not have correct cancellation dates
--1 contract had a sale date in 2017, but was a 2011-2012 contract -- want to filter out as well.

UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '1.' + Cast(Year([GPWEffectiveDate]) AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=1
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '1.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=2
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '1.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=3
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '2.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=4
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '2.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=5
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '2.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=6
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '3.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=7
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '3.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=8
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '3.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=9	
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '4.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=10
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '4.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=11
UPDATE GPWClaims 
SET GPWClaims.GPWEffectiveQuarter = '4.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=12

UPDATE GPWClaims
SET GPWClaims.GPWEffectiveYear = Year([GPWEffectiveDate])


--   UPDATE GPWEffectiveQtr# Column
UPDATE GPWClaims
SET GPWEffectiveQtr# = (YEAR(GPWEffectiveDate) - YEAR(@valDate))*4 + CEILING(Cast((MONTH(GPWEffectiveDate) - MONTH(@valDate)) as float)/3) + 40


UPDATE GPWClaims
	SET GPWTermMonths = 
		  Case when [Contract Type] = 'Monthly' then 1
				when [TermMonths] <= 9 then 6
				when [TermMonths] <= 20 then 12
				when [TermMonths] <= 32 then 28
				when [TermMonths] <= 48 then 42
				when [TermMonths] <= 64 then 60
				when [TermMonths] <= 80 then 72
				else 84 
		  end
	FROM GPWClaims
	where GPWTermMonths is null

--12/31/2019 this will do nothing as Plan is not in Claims data
UPDATE GPWClaims
set [GPW Channel] = case when GPWClaims.[GPWPlan] in ('Choice Plan','Choice Plus','Choice Plan','Choice Ultimate','Seller Plan') 
	then 'Real Estate' 
		else 'DTC' end
GO
