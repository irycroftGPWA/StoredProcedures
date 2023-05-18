--*********************************
--*********************************
--Table to indicate whether single policy record for Yearly
--*********************************

if exists (select name from sysobjects
	where name = 'tbl_SingleYearly')
	DROP TABLE tbl_SingleYearly

--select Cust, count(*) as 'CustIdCount'
--into tbl_SingleYearly
--from RawData_Contracts
--group by Cust
--12/31/2019 AJD modified since given contracts and renewals in separate table
select Cust, count(*) as 'CustIdCount'
into tbl_SingleYearly
from (
select RawData_ContractsAnnual.Cust as Cust
from RawData_ContractsAnnual 
union all
select Cust as Cust
from RawData_ContractsAnnual_Renewals
) temptbl
group by Cust


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPW_RawData_Contracts')
	DROP TABLE GPW_RawData_Contracts

select
'NA' as [Source]
,'NonRenewal' as GPWRenewalFlag
,[Order Date]
,Cust
,[Sale Date]
,[Start Date]
,[End Date]
,Total
,Term
,[Plan]
into GPW_RawData_Contracts
from RawData_ContractsAnnual
union all
select 
'NA' as [Source]
,'Renewal' as GPWRenewalFlag
,[Order Date]
,Cust
,[Sale Date]
,[Start Date]
,[End Date]
,Total
,Term
,[Plan]
from RawData_ContractsAnnual_Renewals
--union all
--select 
--'Prior' as GPWRenewalFlag
--,[Order Date]
--,Cust
--,[Sale Date]
--,[Start Date]
--,[End Date]
--,Total
--,Term
--,[Plan]
--from MissingPriorContracts



IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'Contracts')
	DROP TABLE Contracts

--6/30/2018:
--Yearly and Monthly Contracts separately
--Monthly -- run Make_MonthlyContracts first

CREATE TABLE [Contracts] (
[Source] NVARCHAR(255), --breaks apart pre 2021 and 2021 monthly contracts
	[GPWContractType] nvarchar(255), -- Yearly or Monthly
	GPWRenewalFlag nvarchar(255), --source file (prior db, current renewal file or current nonrenewals file)
--Yearly Fields
	[Order Date] [datetime] NULL,
	[Sale Date] [datetime] NULL,
	[Cust] [float] NULL,
	[Start Date] [datetime] NULL,
	[End Date] [datetime] NULL,
	[Total] [float] NULL,
	[Refund Amount] [float] NULL,--12/31/2019 AJD excluded
	[Claims Paid] [float] NULL,--12/31/2019 AJD excluded
	[Claims Authorized] [float] NULL,--12/31/2019 AJD excluded
	[Term] [nvarchar](255) NULL,
	[Renewal] [nvarchar](255) NULL,--12/31/2019 AJD excluded
	[Plan] [nvarchar](255) NULL,
	[GPW_CustValue] [float] NULL,--12/31/2019 AJD excluded
	[GPW_RenewalCount] [float] NULL,--12/31/2019 AJD excluded
	--added for next policy
	[Renew_SaleDate] [datetime] NULL, --12/31/2019 AJD excluded
	[CustidCount] float null,
	
--Monthly Fields

	--[Order Date] [datetime] NULL,
	--[Sale Date] [datetime] NULL,
	--[Cust] [float] NULL,
	--[Start Date] [datetime] NULL,  --MAP
	[GPWEffectiveDate] [date] NULL,
	[GPWExpireDate] [date] NULL,
	[Monthly Price] [money] NULL,
	[Total Paid] [money] NULL,
	--[Claims Paid] [money] NULL,  --MAP
	--[Claim Authorization] [money] NULL,  --MAP
	--[Plan] [nvarchar](255) NULL,  --MAP
	[Months] [float] NULL,
	[StartMonth] [float] NULL,
	[StartYear] [float] NULL,
	[MonthCount] [int] NULL
)

--**************************************--
--**************YEARLY DATA**************--
--**************************************--
INSERT INTO Contracts(
	[source],
	[GPWContractType],
	GPWRenewalFlag, --12/31/2019 AJD added
	[Order Date],
	[Sale Date],
	[Cust],
	[Start Date],
	[End Date],
	[Total],
	[Refund Amount], --12/31/2019 AJD excluded
	[Claims Paid], --12/31/2019 AJD excluded
	[Claims Authorized], --12/31/2019 AJD excluded
	[Term],
	[Renewal], --12/31/2019 AJD excluded
	[Plan],
	[GPW_CustValue], --12/31/2019 AJD excluded
	[GPW_RenewalCount], --12/31/2019 AJD excluded

	[Renew_SaleDate], --12/31/2019 AJD excluded
	[CustidCount],

	[GPWEffectiveDate],
	[GPWExpireDate],
	[Monthly Price],
	[Total Paid],
	[Months],
	[StartMonth],
	[StartYear],
	[MonthCount]
	
)

Select
	c1.[Source],
	'Yearly' as [GPWContractType],
	c1.GPWRenewalFlag,
	c1.[Order Date],
	c1.[Sale Date],
	c1.[Cust],
	c1.[Start Date],
	c1.[End Date],
	c1.[Total],
	null, --c1.[Refund Amount],
	null, --c1.[Claims Paid],
	null, --c1.[Claims Authorized],
	c1.[Term],
	null, --c1.[Renewal],
	c1.[Plan],
	null, --c1.[GPW_CustValue],
	null, --c1.[GPW_RenewalCount],

	null, --c2.[Sale Date] as [Renew_SaleDate],
	c3.[CustidCount] as [CustidCount],

	c1.[Start Date] as [GPWEffectiveDate],
	c1.[End Date] as [GPWExpireDate],
	null,  --c1.[Monthly Price],
	null,  --c1.[Total Paid],
	null, --c1.[Months],
	month(c1.[start date]) as [StartMonth],
	year(c1.[start date]) as [StartYear],
	null --c1.[MonthCount]
	
		
FROM GPW_RawData_Contracts c1 left join GPW_RawData_Contracts c2
	on c1.cust=c2.cust --and c1.GPW_RenewalCount + 1 = c2.GPW_RenewalCount
		left join tbl_SingleYearly c3
	on c1.cust=c3.cust
	
	group by 
	c1.[Source],
	c1.[Order Date],
	c1.GPWRenewalFlag,
	c1.[Sale Date],
	c1.[Cust],
	c1.[Start Date],
	c1.[End Date],
	c1.[Total],
	--c1.[Refund Amount],
	--c1.[Claims Paid],
	--c1.[Claims Authorized],
	c1.[Term],
	--c1.[Renewal],
	c1.[Plan],
	--c1.[GPW_CustValue],
	--c1.[GPW_RenewalCount],
	--c2.[Sale Date],
	--c2.Renewal_Date,
	c3.[CustidCount]



--	order by c1.cust, c1.[Sale Date]


--**************************************--
--***************MONTHLY DATA***************--
--**************************************--
INSERT INTO Contracts(
	[Source],
	[GPWContractType],

	[Order Date],
	[Sale Date],
	[Cust],
	[Start Date],
	[End Date],
	[Total],
	[Refund Amount],
	[Claims Paid],
	[Claims Authorized],
	[Term],
	[Renewal],
	[Plan],
	[GPW_CustValue],
	[GPW_RenewalCount],

	[Renew_SaleDate],
	[CustidCount],

	[GPWEffectiveDate],
	[GPWExpireDate],
	[Monthly Price],
	[Total Paid],
	[Months],
	[StartMonth],
	[StartYear],
	[MonthCount]
	
)

Select
	[Source],
	'Monthly' as [GPWContractType],

	[Order Date],
	[Sale Date],
	[Cust],
	[Start Date],
	null, --[End Date],
	[Monthly Price] as [Total],
	null,  --[Refund Amount],
	[Claims Paid],
	[Claim Authorization] as [Claims Authorized],
	'1m' as [Term],
	null, --[Renewal],
	[Plan],
	null, --[GPW_CustValue],
	null, --[GPW_RenewalCount],
	null, --[Renew_SaleDate],
	null, --[CustidCount],

	[GPWEffectiveDate],
	[GPWExpireDate],
	[Monthly Price],
	[Total Paid],
	[Months],
	[StartMonth],
	[StartYear],
	[MonthCount]
		
FROM MonthlyContracts
where [Sale Date] >='1/1/2014' and year(GPWEffectiveDate)>=2014
--ACL: added per Victor, monthly contracts with sale date < 1/1/2014 do not have correct cancellation dates
--1 contract had a sale date in 2017, but was a 2011-2012 contract -- want to filter out as well.

group by 
	[Source],
	[Order Date],
	[Sale Date],
	[Cust],
	[Start Date],
	[Monthly Price],
	[Claims Paid],
	[Claim Authorization],
	[Plan],
	
	[GPWEffectiveDate],
	[GPWExpireDate],
	[Monthly Price],
	[Total Paid],
	[Months],
	[StartMonth],
	[StartYear],
	[MonthCount]




