--*******Old claims pulled from 6/30 at 9/30 & 10/31**************
--*******See code at bottom of SP*********************************

--**Combine 2 location cknum files**--AJD not needed for 12/31/2019 - data provided as single file
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'location_cknum')
	DROP TABLE location_cknum

select *
into location_cknum
from RawData_location_cknum
where type='claim'

--insert into location_cknum
--select *
--from RawData_location_cknum2
--where type='claim'

--**CHECK**
/*
select payee, count(*), sum(amount)
from location_cknum
where right(rtrim(payee),2)<>'RE'
group by payee
*/

declare @valdate as date
set @valdate = (select valdate from Tbl_DBValues)

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'UniquePayments')
	DROP TABLE UniquePayments

Select --[id]
      cast([date] as date) as [PaidDate]  --paid date
      --,[checknum]
      ,case when cast([date] as date)<=@valdate then cast([amount] as float)
		else 0 end as 'paid'
	  ,case when cast([date] as date)>@valdate then cast([amount] as float)
		else 0 end as 'ibnr'
      ,[claimno]
      --,[type]
      --,[payee]  --reissues have "RE" as last 2 digits -- removing these
      ,[vendorid]
      --,[cleardate]
      --,[ck4]
      --,[checktotal]
      --,[tid]
      --,[void_date]
      --,[reissue]
      --,[wex_pmt]
      --,[wex_id]

into UniquePayments
from location_cknum
where right(rtrim(payee),2)<>'RE'
group by 
	cast([date] as date),
	case when cast([date] as date)<=@valdate then cast([amount] as float)
		else 0 end,
	case when cast([date] as date)>@valdate then cast([amount] as float)
		else 0 end,
	claimno, vendorid



----*****************************************************
----12/31/2020 AJD added for missing claims
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'RawData_Claims_FROM_202009_db_MISSING_IN_CURRENT')
	DROP TABLE RawData_Claims_FROM_202009_db_MISSING_IN_CURRENT

select old.* 
into RawData_Claims_FROM_202009_db_MISSING_IN_CURRENT
from rawdata_claims new full outer join [36611_202009_ChoiceHW].dbo.rawdata_claims old
on new.[claim #] = old.[claim #]
and new.[customer ID] = old.[customer ID]
where new.[claim #] is null
--order by old.[Claim Date] asc
----*****************************************************

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'Claims')
	DROP TABLE Claims

--For 12/31/2019 were given ITD claims
CREATE TABLE [Claims] (
[Authorized Date] [datetime] NULL,
	[Amount Authorized] [float] NULL,
	[Paid Date] [datetime] NULL,
	[Amount Paid] [float] NULL,
	[Claim #] [nvarchar](255) NULL,
	[Claim Date] [DATE] NULL, --acl 4/5/2019 - CHANGED TO DATE FROM DATETIME
	[Contract Type] [nvarchar](255) NULL,
	[Contract Start] [datetime] NULL,
	[Contract End] [datetime] NULL,
	[Contract Term] [nvarchar](255) NULL,
	[Plan] [nvarchar](255) NULL,
	[Type of Claim] [nvarchar](255) NULL,
	[Customer ID] [nvarchar](255) NULL,
	[Total] [float] NULL

)

INSERT INTO Claims(
[Authorized Date]
      ,[Amount Authorized]
      ,[Paid Date]
      ,[Amount Paid]
      ,[Claim #]
      ,[Claim Date]
      ,[Contract Type]
      ,[Contract Start]
      ,[Contract End]
      ,[Contract Term]
      ,[Plan]
      ,[Type of Claim]
      ,[Customer ID]
      ,[Total]
)



--AJD: for 12/31/2019 we were provided ITD claims - changed code from prior with different fields
Select
cast([Authorized Date] as date) as [Authorized Date]
,case when ltrim(rtrim([Amount Authorized])) = '' then 0.0 else cast(ltrim(rtrim([Amount Authorized])) as float) end as [Amount Authorized]
,NULL as [Paid Date]
,NULL as [Amount Paid]
,[Claim #] as [Claim #]
,cast([Claim Date] as date) as [Claim Date]
,null as [Contract Type]
,null as [Contract Start]
,null as [Contract End]
,null as [Contract Term]
,null as [Plan]
,null as [Type of Claim]
,[Customer ID] as [Customer ID]
,null as [Total]
FROM RawData_Claims



----*****************************************************
----12/31/2020 AJD added for missing claims
union all
select
cast([Authorized Date] as date) as [Authorized Date]
,case when ltrim(rtrim([Amount Authorized])) = '' then 0.0 else cast(ltrim(rtrim([Amount Authorized])) as float) end as [Amount Authorized]
,NULL as [Paid Date]
,NULL as [Amount Paid]
,[Claim #] as [Claim #]
,cast([Claim Date] as date) as [Claim Date]
,null as [Contract Type]
,null as [Contract Start]
,null as [Contract End]
,null as [Contract Term]
,null as [Plan]
,null as [Type of Claim]
,[Customer ID] as [Customer ID]
,null as [Total]
from RawData_Claims_FROM_202009_db_MISSING_IN_CURRENT
----*****************************************************



IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'UniqueClaimNumber')
	DROP TABLE UniqueClaimNumber

select [Claim #], cast([Claim Date] as date) as [Claim Date], [Contract Type] --ACL 20190404: case claim date as date -- there are some time differences
into UniqueClaimNumber
from Claims
group by [Claim #], cast([Claim Date] as date), [Contract Type]



IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'AuthByClaimNumber')
	DROP TABLE AuthByClaimNumber

select [Claim #], [Claim Date], [Contract Type], sum([Amount Authorized]) as 'AmountAuthorized', cast(0 as float) as 'AuthClaimCount'
into AuthByClaimNumber
from Claims
group by [Claim #], [Claim Date], [Contract Type]

Update AuthByClaimNumber
set AuthClaimCount = case when AmountAuthorized>0 then 1 else 0 end



IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PaidByClaimNumber')
	DROP TABLE PaidByClaimNumber

select claimno, sum(paid) as 'AmountPaid', cast(0 as float) as 'PaidClaimCount', sum(ibnr) as 'IBNR'
into PaidByClaimNumber
from [dbo].[UniquePayments]
group by claimno

Update PaidByClaimNumber
set PaidClaimCount = case when AmountPaid>0 then 1 else 0 end






IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PaidtoAuthbyClaimNumber')
	DROP TABLE PaidtoAuthbyClaimNumber

select UniqueClaimNumber.[Claim #], UniqueClaimNumber.[Claim Date], UniqueClaimNumber.[Contract Type],
		AuthByClaimNumber.AmountAuthorized, AuthByClaimNumber.AuthClaimCount,
		PaidByClaimNumber.AmountPaid, PaidByClaimNumber.PaidClaimCount, PaidByClaimNumber.IBNR
into PaidtoAuthbyClaimNumber
from UniqueClaimNumber
	LEFT JOIN AuthByClaimNumber on UniqueClaimNumber.[Claim #]=AuthByClaimNumber.[Claim #] 
				--and UniqueClaimNumber.[Contract Type]=AuthByClaimNumber.[Contract Type]  --ACL 7/18/2020 no contract type in claims this year
	LEFT JOIN PaidByClaimNumber on UniqueClaimNumber.[Claim #]=PaidByClaimNumber.claimno



---*****************************************--
---*****************************************--
-- used for checks
---*****************************************--
---*****************************************--
/*
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'Claims_UniquePaid')
	DROP TABLE Claims_UniquePaid

select 
	--[Authorized Date]
    --  ,[Amount Authorized]
      [Paid Date]
      ,[Amount Paid]
      ,[Claim #]
      ,[Claim Date]
      ,[Contract Type]
      ,[Contract Start]
      ,[Contract End]
      ,[Contract Term]
      ,[Plan]
      ,[Type of Claim]
      ,[Customer ID]
      ,[Total]
into Claims_UniquePaid
from Claims
group by [Paid Date]
      ,[Amount Paid]
      ,[Claim #]
      ,[Claim Date]
      ,[Contract Type]
      ,[Contract Start]
      ,[Contract End]
      ,[Contract Term]
      ,[Plan]
      ,[Type of Claim]
      ,[Customer ID]
      ,[Total]
Order by [Customer ID], [Claim #], [Claim Date], [Paid Date]
*/

---*****************************************--
---*****************************************--
-- sum to claim for authorized amount, join for paid amount
--THIS will be used for GPWClaims
---*****************************************--
---*****************************************--

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'Claims_Unique')
	DROP TABLE Claims_Unique

select 
	--[Authorized Date]
    sum([Amount Authorized]) as 'Amount Authorized'
    --[Paid Date]
    --  ,[Amount Paid]
      ,[Claim #]
      ,[Claim Date]
      ,[Contract Type]
      ,[Contract Start]
      ,[Contract End]
      ,[Contract Term]
      ,[Plan]
    --  ,[Type of Claim]
      ,[Customer ID]
    --  ,[Total]
		,paidbyclaimnumber.AmountPaid
		,PaidByClaimNumber.IBNR
into Claims_Unique
from Claims left join PaidByClaimNumber
	on Claims.[Claim #]=PaidByClaimNumber.claimno
group by 
      [Claim #]
      ,[Claim Date]
      ,[Contract Type]
      ,[Contract Start]
      ,[Contract End]
      ,[Contract Term]
      ,[Plan]
      ,[Customer ID]
	  ,PaidByClaimNumber.AmountPaid
	  ,PaidByClaimNumber.IBNR
Order by [Customer ID], [Claim #]


--added for data checks
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'UniquePaymentsMaxDate')
	DROP TABLE UniquePaymentsMaxDate

select claimno as claimno, max(paidDate) as MaxPaidDate
into UniquePaymentsMaxDate
from UniquePayments
group by claimno
order by claimno

/*
--**For 9/30/2012 & 10/31/2012 ONLY -- missing old authorizations
select *
into RawData_Claims_Backup
from RawData_Claims

delete RawData_Claims
where year([claim date])<2014

insert into RawData_Claims
select *
from [36611_202006_ChoiceHW].dbo.RawData_Claims
where year([claim date])<2014
*/
