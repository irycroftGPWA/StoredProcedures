--Set up table for loop
IF EXISTS (SELECT name FROM sysobjects                
      WHERE name = 'MonthlyContracts')       
      DROP TABLE MonthlyContracts            


--we need to manipulate the start date on monthly contracts in the 2021only data.  The start dates are in prior years.       
Select [Source]
	  ,[Order Date]
      ,[Sale Date]
      ,[Cust]
	  ,[Start Date]
      ,cast([Start Date] as date) as GPWEffectiveDate
	  ,dateadd(d, -1, dateadd(m, 1, cast([Start Date] as date))) as GPWExpireDate  --add 1 month, take away 1 day so expire and next effective are not the same
      ,[Monthly Price]
      ,[Total Paid]
      ,[Claims Paid]
      ,[Claim Authorization]
      ,[Plan]
      ,round([Months],0) as Months
      ,month([Start Date]) as StartMonth
      ,year([Start Date]) as StartYear
	  ,cast(1 as int) as [MonthCount]
 Into MonthlyContracts                  
FROM Pre_MonthlyContracts --combines old 2020 monthly file with the data from 2021 payments only
where [Source] = 'monthly_pre2021' and [Start Date] < '1/1/2021' --AJD/ACL add start date restriction so NO contracts from prior data get started in 2021

union ALL

Select [Source] 
	  ,[Order Date]
      ,[Sale Date]
      ,[Cust]
	  ,[Start Date]
	  ,case when [Start Date] is null then cast('1/1/1901' as date) 
			when year([Start Date]) = 2021 then cast([Start Date] as date) 
			--when month([Start Date])=2 and day([Start Date])=29 then cast('2/28/2021' as date) --removed - don't want to map contracts prior to 2021 to Feb they should start in Jan
			else cast('1/'+str(day([Start Date]))+'/2021' as date) --contracts that start in prior years should begin in 2021 in january
			end as GPWEffectiveDate --make the contract starting point in 2021
		,dateadd(d, -1, dateadd(m, 1, case when [Start Date] is null then cast('1/1/1901' as date) 
			when year([Start Date]) = 2021 then cast([Start Date] as date) 
			--when month([Start Date])=2 and day([Start Date])=29 then cast('2/28/2021' as date)
			else cast('1/'+str(day([Start Date]))+'/2021' as date) end)) as GPWExpireDate   --add 1 month, take away 1 day so expire and next effective are not the same
      ,[Monthly Price]
      ,[Total Paid]
      ,[Claims Paid]
      ,[Claim Authorization]
      ,[Plan]
      ,round([Months],0) as Months
      ,month([Start Date]) as StartMonth
      ,year([Start Date]) as StartYear
	  ,cast(1 as int) as [MonthCount]	  
FROM Pre_MonthlyContracts --combines old 2020 monthly file with the data from 2021 payments only
where [Source] = 'monthly_only2021' and [Start Date] < '1/1/2022'

union ALL

Select [Source] 
	  ,[Order Date]
      ,[Sale Date]
      ,[Cust]
	  ,[Start Date]
	  ,case when [Start Date] is null then cast('1/1/1901' as date) 
			when year([Start Date]) = 2022 then cast([Start Date] as date) 
			else cast('1/'+str(day([Start Date]))+'/2022' as date) --contracts that start in prior years should begin in 2022 in january
			end as GPWEffectiveDate --make the contract starting point in 2022
		,dateadd(d, -1, dateadd(m, 1, case when [Start Date] is null then cast('1/1/1901' as date) 
			when year([Start Date]) = 2022 then cast([Start Date] as date) 
			else cast('1/'+str(day([Start Date]))+'/2022' as date) end)) as GPWExpireDate   --add 1 month, take away 1 day so expire and next effective are not the same
      ,[Monthly Price]
      ,[Total Paid]
      ,[Claims Paid]
      ,[Claim Authorization]
      ,[Plan]
      ,round([Months],0) as Months
      ,month([Start Date]) as StartMonth
      ,year([Start Date]) as StartYear
	  ,cast(1 as int) as [MonthCount]	  
FROM Pre_MonthlyContracts --adding data from 2022 payments only
where [Source] = 'monthly_only2022' and [Start Date] < '1/1/2023'

--Create interim table for loop to pull from
IF EXISTS (SELECT name FROM sysobjects                
      WHERE name = 'MonthlyContracts_Temp')       
      DROP TABLE MonthlyContracts_Temp
	  
Select *
Into MonthlyContracts_Temp
From MonthlyContracts	       


--Loop
                  
declare @i int          
set @i = 1

declare @maxrenewal int
set @maxrenewal = (select round(max(months),0) from Pre_MonthlyContracts)--RawData_ContractsMonthly) --AJD chg'd for 12/31/21 val


while (@i <= @maxrenewal)               
begin             
                  
Insert Into MonthlyContracts 
select [Source]
	  ,[Order Date]
      ,[Sale Date]
      ,[Cust]
	  ,[Start Date]
      ,dateadd(m, @i, GPWEffectiveDate)
	  ,dateadd(m, @i, GPWExpireDate)
      ,[Monthly Price]
      ,0
      ,0
      ,0
      ,[Plan]
      ,[Months]
      ,[StartMonth]
      ,[StartYear] 
	  ,@i+1 as [MonthCount]
FROM MonthlyContracts_Temp
where [Months] >= @i+1 and [Source] = 'monthly_pre2021' and dateadd(m, @i, GPWEffectiveDate) < '1/1/2021' --need to not let pre2021 data spill over into 2021

Insert Into MonthlyContracts 
select [Source]
	  ,[Order Date]
      ,[Sale Date]
      ,[Cust]
	  ,[Start Date]
      ,dateadd(m, @i, GPWEffectiveDate)
	  ,dateadd(m, @i, GPWExpireDate)
      ,[Monthly Price]
      ,0
      ,0
      ,0
      ,[Plan]
      ,[Months]
      ,[StartMonth]
      ,[StartYear] 
	  ,@i+1 as [MonthCount]
FROM MonthlyContracts_Temp
where [Months] >=  @i+1 and [Source] = 'monthly_only2021'  and dateadd(m, @i, GPWEffectiveDate) < '1/1/2022' --AJD added just to make the monthly contracts table cleaner

Insert Into MonthlyContracts 
select [Source]
	  ,[Order Date]
      ,[Sale Date]
      ,[Cust]
	  ,[Start Date]
      ,dateadd(m, @i, GPWEffectiveDate)
	  ,dateadd(m, @i, GPWExpireDate)
      ,[Monthly Price]
      ,0
      ,0
      ,0
      ,[Plan]
      ,[Months]
      ,[StartMonth]
      ,[StartYear] 
	  ,@i+1 as [MonthCount]
FROM MonthlyContracts_Temp
where [Months] >=  @i+1 and [Source] = 'monthly_only2022'  and dateadd(m, @i, GPWEffectiveDate) < '1/1/2023' --AJD added just to make the monthly contracts table cleaner

--select @i as Counter
set @i = @i + 1                 
end 

    
--drop interim table
DROP TABLE MonthlyContracts_Temp      


--SCRATCH
--select top 1000 *
--from MonthlyContracts
--where source = 'pre2021'
--order by Cust, MonthCount

