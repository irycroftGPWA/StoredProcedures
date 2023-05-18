IF EXISTS (SELECT name FROM sysobjects                
      WHERE name = 'Pre_MonthlyContracts')       
      DROP TABLE Pre_MonthlyContracts            
      
--2022 activity file will be used to get all contract information including "cancels" or where to stop, will not be using cancels file
--to updated 2022 contract data
select
'monthly_only2022' as [Source]
,NULL as [Order Date]
, [n].[date_order] as [Sale Date]
, n.cust_id as [Cust]
, cast(n.contract_start as date) as [Start Date]
, round(n.total/12.0,2) as [Monthly Price]
, n.[SUM(ho.amount)] as [Total Paid]
, NULL as [Claims Paid]
, NULL as [Claim Authorization]
, [n].[plan] as [Plan]
, n.[COUNT(ho.amount)] as [months]
into Pre_MonthlyContracts
from [RawData_ContractsMonthly_2022only] n

union all
--2021 activity file will be used to get all contract information including "cancels" or where to stop, will not be using cancels file
--to updated 2021 contract data
select
'monthly_only2021' as [Source]
,NULL as [Order Date]
, [n].[date_order] as [Sale Date]
, n.cust_id as [Cust]
, cast(n.contract_start as date) as [Start Date]
, round(n.total/12.0,2) as [Monthly Price]
, n.[SUM(ho.amount)] as [Total Paid]
, NULL as [Claims Paid]
, NULL as [Claim Authorization]
, [n].[plan] as [Plan]
, n.[COUNT(ho.amount)] as [months]
from [RawData_ContractsMonthly_2021only] n 

union ALL

select 
'monthly_pre2021' as [Source]
, o.[Order Date] as [Order Date]
, o.[Sale Date] as [Sale Date]
, o.cust as [Cust]
, o.[Start Date] as [Start Date]
, o.[Monthly Price] as [Monthly Price]
, o.[Total Paid]  as [Total Paid]
, o.[Claims Paid] as [Claims Paid]
, o.[Claim Authorization] as [Claim Authorization]
, o.[Plan] as [Plan]
--if a contracts # Months brought the contract to Dec 2020 we add another 12 months.
, o.[Months] as [Months]
from [RawData_ContractsMonthly_asof202012] o 




--Test Commit
