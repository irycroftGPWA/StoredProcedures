--From Scott Van Pelt email 6/24/2019
-- Only the first digit matters.  See below.
--Plans
--1 - Basic
--2 – Total
--5 – Choice Ultimate
--6 – Choice Plus
--7 - Choice Plan
--8 - Sellers
-- 3 and 4 don’t really exist but they were 3, Appliance Plan, 4. “Basic Systems Plan” – no clue…


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWContracts')
	DROP TABLE GPWContracts

CREATE TABLE [GPWContracts] (
	--from Contracts
	[Source] nvarchar(255) NULL,
	[GPWContractType] [nvarchar](255) NULL,
	[Order Date] [datetime] NULL,
	[Sale Date] [datetime] NULL,
	[Cust] [float] NULL,
	[Start Date] [datetime] NULL,
	[End Date] [datetime] NULL,
	[Total] [float] NULL,
	[Refund Amount] [float] NULL,
	[Claims Paid] [float] NULL,
	[Claims Authorized] [float] NULL,
	[Term] [nvarchar](255) NULL,
	[Renewal] [nvarchar](255) NULL,
	[Plan] [nvarchar](255) NULL,
	[GPW_CustValue] [float] NULL,
	[GPW_RenewalCount] [float] NULL,
	[Renew_SaleDate] [datetime] NULL,
	[CustidCount] [float] NULL,
	[GPWEffectiveDate] [date] NULL,
	[GPWExpireDate] [date] NULL,
	[Monthly Price] [money] NULL,
	[Total Paid] [money] NULL,
	[Months] [float] NULL,
	[StartMonth] [float] NULL,
	[StartYear] [float] NULL,
	[MonthCount] [int] NULL,

	--from Cancels
	[GPWMaxCancelDate] [date] NULL,
	--[custid] [float] NULL,  --needed in join
	--[accttype] [nvarchar](255) NULL,  --needed in join
	[CancelRefund] [float] NULL
	
	--GPW fields
	,[GPWCoverage1] nvarchar(255)
	,[GPWCoverage2] nvarchar(255)
	,[GPW N/U/P] nvarchar(255)
	,GPWRenewalFlag nvarchar(255)
	,[GPWPlan] varchar(255) --12/31/2019 AJD added
	,[GPW Channel] nvarchar(255)
	,TermMonths float
	,[GPWTermMonths] float
	,[GPWEffectiveQuarter] nvarchar(255)
	,[GPWEffectiveQtr#] int
	,[GPWEffectiveYear] int
	,[GPWCancelDate] date
	,[GPWCancelQuarter] nvarchar(255)
	,[GPWCancelQtr#] int
	,[GPWRelativeCancelQtr] int
	,[GPWFlatCancel] nvarchar(255)
	,[GPWContractCount] int
	,[GPWCancelCount] int
	,[GPWGrossReserve] float
	,[GPWActiveReserve] float
	,[GPWCancelReserve] float
	,[GPWClaimCount] int
	,[GPWClaims] float 
	,[GPWLag] int  --added 20190604 for earning curves
	,[GPWEarnTermMonths] int --added 20190604 for earning curves
	,[GPWPercEarned] float --added 20190604 for earning curves
	,[GPWEarnedReserves] float --added 20190604 for earning curves
	,[GPWUpFrontAdj] float --added 20190604 for earning curves
	,[GPWAdjEarnedReserves] float  --added 20190604 for earning curves

) 

INSERT INTO GPWContracts(
	--from Contracts
	[Source],
	[GPWContractType]
      ,[Order Date]
      ,[Sale Date]
      ,[Cust]
      ,[Start Date]
      ,[End Date]
      ,[Total]
      ,[Refund Amount]
      ,[Claims Paid]
      ,[Claims Authorized]
      ,[Term]
      ,[Renewal]
      ,[Plan]
      ,[GPW_CustValue]
      ,[GPW_RenewalCount]
	  ,[Renew_SaleDate]
	  ,[CustidCount]
      ,[GPWEffectiveDate]
	  ,[GPWExpireDate]
      ,[Monthly Price]
      ,[Total Paid]
      ,[Months]
      ,[StartMonth]
      ,[StartYear]
      ,[MonthCount]

	--from RawData_Cancels
	  ,[GPWMaxCancelDate]
	  ,[CancelRefund]

	--GPW fields
	,[GPWCoverage1]
	,[GPWCoverage2]
	,[GPW N/U/P]
	,GPWRenewalFlag
	,[GPWPlan] --12/31/2019 AJD added
	,[GPW Channel]
	,[TermMonths]
	,[GPWTermMonths]
	,[GPWEffectiveQuarter]
	,[GPWEffectiveQtr#]
	,[GPWEffectiveYear]
	,[GPWCancelDate]
	,[GPWCancelQuarter]
	,[GPWCancelQtr#]
	,[GPWRelativeCancelQtr]
	,[GPWFlatCancel]
	,[GPWContractCount]
	,[GPWCancelCount]
	,[GPWGrossReserve]
	,[GPWActiveReserve]
	,[GPWCancelReserve]
	,[GPWClaimCount]
	,[GPWClaims]
	,[GPWLag]
	,[GPWEarnTermMonths]
	,[GPWPercEarned]
	,[GPWEarnedReserves]
	,[GPWUpFrontAdj]
	,[GPWAdjEarnedReserves]
) 

SELECT
	--from Contracts
	[Source],
	[GPWContractType]
      ,[Order Date]
      ,[Sale Date]
      ,[Cust]
      ,[Start Date]
      ,[End Date]
      ,[Total]
      ,[Refund Amount]
      ,[Claims Paid]
      ,[Claims Authorized]
      ,[Term]
      ,[Renewal]
      ,[Plan]
      ,[GPW_CustValue]
      ,[GPW_RenewalCount]
	  ,[Renew_SaleDate]
	  ,[CustidCount]
      ,Contracts.[GPWEffectiveDate]
	  ,Contracts.[GPWExpireDate]
      ,[Monthly Price]
      ,[Total Paid]
      ,[Months]
      ,[StartMonth]
      ,[StartYear]
      ,[MonthCount]

	--from Cancels
	,C.[GPWMaxCancelDate] as [GPWMaxCancelDate]
	,C.RefundAmt as [CancelRefund]

	--GPW fields
	,'' as [GPWCoverage1]
	,'' as [GPWCoverage2]

	--12/31/2019 AJD added the GPWRenewalFlag condition
	,case when GPWContractType = 'Monthly' then GPWContractType
		when Renewal = 'Yes' or GPWRenewalFlag = 'Renewal' then 'Renewal' else 'Original' end as [GPW N/U/P]
		,GPWRenewalFlag as GPWRenewalFlag
	,NULL as GPWPlan	--12/31/2019 AJD added
	--12/31/2019 AJD see note at top of procedure for mapping
	--,case when [Plan] in ('Choice Plan','Choice Plus','Choice Plan','Choice Ultimate','Seller Plan') then 'Real Estate' else 'DTC' end as [GPW_Channel]
	--12/31/2019 There are fewer than 10 contracts with left char = '_' for [Plan] field so they are getting grouped with the largest Channel
	--There are 
	,case when [Plan] in ('Choice Plan','Choice Plus','Choice Plan','Choice Ultimate','Seller Plan') then 'Real Estate' 
			when left([Plan],1)='_' then 'DTC' 
			when left([Plan],1) in ('7','6','5','8') then 'Real Estate' 
			else 'DTC' end as [GPW_Channel]
	,case when GPWContractType = 'Monthly' then 1
		else datediff(m,[Start Date],[End Date]) end as [TermMonths]
	,0 as [GPWTermMonths]
	,'' as [GPWEffectiveQuarter]
	,0 as [GPWEffectiveQtr#]
	,0 as [GPWEffectiveYear]
	,C.[GPWMaxCancelDate] as [GPWCancelDate]
	,'' as [GPWCancelQuarter]
	,0 as [GPWCancelQtr#]
	,0 as [GPWRelativeCancelQtr]
	,case when GPWContractType='Monthly' and Months=0 then 'F' else '' end as [GPWFlatCancel]
	,0 as [GPWContractCount]
	,0 as [GPWCancelCount]
	,[Total] as [GPWGrossReserve] --12/31/2019 AJD this needs to be updated for monthly
	,0 as [GPWActiveReserve]
	,0 as [GPWCancelReserve]
	,0 as [GPWClaimCount]
	,0 as [GPWClaims]
	,0 as [GPWLag]
	,0 as [GPWEarnTermMonths]
	,0 as [GPWPercEarned]
	,0 as [GPWEarnedReserves]
	,50*.74 as [GPWUpFrontAdj] 
	,0 as [GPWAdjEarnedReserves]

FROM Contracts left join CancelSummary C
	on Contracts.cust = C.Custid
	and Contracts.GPWContractType = C.accttype
	and Contracts.GPWEffectiveDate = C.GPWEffectiveDate
	and Contracts.GPWExpireDate = C.GPWExpireDate

--12/9/2020: Victor provided a separate table for RE deals that were never booked
--Included as Flat Cancels to be dropped out
Update GPWContracts
set GPWFlatCancel = 'F'
from GPWContracts left join Tbl_RECancels_Exclude
on GPWContracts.Cust = Tbl_RECancels_Exclude.pol_id
where Tbl_RECancels_Exclude.pol_id is not null

--12/31/2020 AJD Should probably also flat cancel these but we are currently not
--Update GPWContracts
--set GPWFlatCancel = 'F'
--where datediff(m,[start date], [GPWCancelDate]) <= 0
--and GPWContractType = 'Monthly'
--and [CancelRefund] = [Monthly Price]
