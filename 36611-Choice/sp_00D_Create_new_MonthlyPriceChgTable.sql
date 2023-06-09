if exists (select name from sysobjects
	where name = 'temp_new_MonthlyPriceChgTable')
	DROP TABLE temp_new_MonthlyPriceChgTable

if exists (select name from sysobjects
	where name = 'new_MonthlyPriceChgTable')
	DROP TABLE new_MonthlyPriceChgTable


SELECT
cust_id
, total
, old_total
, 0 as [GPWReversedInd]
, date_increased as [GPW_Date_Changed]
, date_increased as [GPW_Date_Window_Start]
, cast(NULL as date) as [GPW_Date_Window_End]
--, cast(NULL as int) as cust_id_price_chg_order
, cast(NULL as float) as [GPW_Window_MonthlyPrice]
into temp_new_MonthlyPriceChgTable
from RawData_homeprotection_price_increases
where price_reversed_date = 'NULL' --AJD 12/31/21 chg'd from scf_reversed_date since the indicator [price reversed] is always 1  when [price_reversed_date] is populated else 0

union ALL

select 
cust_id
, total
, old_total
, 1 as [GPWReversedInd]
, cast(price_reversed_date as date) as [GPW_Date_Changed]
, cast(price_reversed_date as date) as [GPW_Date_Window_Start]
, cast(NULL as date) as [GPW_Date_Window_End]
--, cast(NULL as int) as cust_id_price_chg_order
, cast(NULL as float) as [GPW_Window_MonthlyPrice]
from RawData_homeprotection_price_increases
where price_reversed_date != 'NULL' and  price_reversed_date > date_increased --AJD 12/31/21 chg'd from scf_reversed_date since the indicator [price reversed] is always 1  when [price_reversed_date] is populated else 0


SELECT *
, ROW_NUMBER() OVER(Partition by Cust_id ORDER BY GPW_Date_Changed) AS Cust_id_PriceChgOrder 
into new_MonthlyPriceChgTable
from temp_new_MonthlyPriceChgTable

drop table temp_new_MonthlyPriceChgTable

--update end dates where there is a newer price change
update l
set GPW_Date_Window_End = dateadd(day, -1, r.[GPW_Date_Window_Start])
from new_MonthlyPriceChgTable l inner join new_MonthlyPriceChgTable r
on l.cust_id = r.cust_id and l.Cust_id_PriceChgOrder + 1 = r.Cust_id_PriceChgOrder

--update end dates to 1/1/2100 where there is no newer price change
update l
set GPW_Date_Window_End = cast('1/1/2100' as date)
from new_MonthlyPriceChgTable l left join new_MonthlyPriceChgTable r
on l.cust_id = r.cust_id and l.Cust_id_PriceChgOrder + 1 = r.Cust_id_PriceChgOrder
where r.Cust_id_PriceChgOrder is null 
--and l.cust_id = 2638965

--now create the starting window using old_total from the first price change
insert INTO
new_MonthlyPriceChgTable 
(
cust_id
, total
, old_total
, [GPWReversedInd]
, [GPW_Date_Changed]
, [GPW_Date_Window_Start]
, [GPW_Date_Window_End]
, [GPW_Window_MonthlyPrice]
, Cust_id_PriceChgOrder
)
select 
cust_id
, old_total as total
, NULL as old_total
, 0 as [GPWReversedInd]
, cast('1/1/1900' as date) as [GPW_Date_Changed]
, cast('1/1/1900' as date) as [GPW_Date_Window_Start]
, dateadd(day, -1, [GPW_Date_Window_Start]) as [GPW_Date_Window_End]
, cast(NULL as float) as [GPW_Window_MonthlyPrice]
, 0 as Cust_id_PriceChgOrder --this is the starting point
from new_MonthlyPriceChgTable
where cust_id_PriceChgOrder = 1

update new_MonthlyPriceChgTable
set GPW_Window_MonthlyPrice = round(total / 12.0, 2)
where gpwReversedInd = 0

update new_MonthlyPriceChgTable
set GPW_Window_MonthlyPrice = round(old_total / 12.0,2)
where GPWReversedInd = 1

--SCRATCH
--select *
--from RawData_homeprotection_price_increases
--where cust_id = 2638965
--order by date_increased

--select *
--from new_monthlypricechgtable
--where cust_id = 2638965
--order by cust_id, Cust_id_PriceChgOrder
