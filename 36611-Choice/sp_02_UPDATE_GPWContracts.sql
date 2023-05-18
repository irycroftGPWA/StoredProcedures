DECLARE @ValDate as DATE
SELECT @ValDate = ValDate FROM Tbl_DBValues

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

UPDATE GPWContracts
Set GPWPlan = [Plan]
where GPWContractType = 'Monthly'

UPDATE GPWContracts
Set GPWPlan = case when left([Plan],1) = '1' then 'Basic Plan'
					when left([Plan],1) = '2' then 'Total Plan'
					when left([Plan],1) = '5' then 'Choice Ultimate' 
					when left([Plan],1) = '6' then 'Choice Plus'
					when left([Plan],1) = '7' then 'Choice Plan'
					when left([Plan],1) = '8' then 'Seller Plan'
					else NULL end
where GPWContractType = 'Yearly'

--AJD 12/31/2021
--the new 2021 only monthly contracts only specify the plan number such as '3_2' and not by name.
UPDATE GPWContracts
Set GPWPlan = case when left([Plan],1) = '1' then 'Basic Plan'
					when left([Plan],1) = '2' then 'Total Plan'
					when left([Plan],1) = '5' then 'Choice Ultimate' 
					when left([Plan],1) = '6' then 'Choice Plus'
					when left([Plan],1) = '7' then 'Choice Plan'
					when left([Plan],1) = '8' then 'Seller Plan'
					else NULL end
where [source] = 'monthly_only2021'

--6/30/2020 - NEW METHOD OF UPDATING MONTHLY PRICES
--12/31/2021 AJD created an updated price chg table for monthly contracts
Update GPWContracts
set [Monthly Price] = case when GPWEffectiveDate > @valdate then 0 else [new_MonthlyPriceChgTable].[GPW_Window_MonthlyPrice] end
, Total = case when [new_MonthlyPriceChgTable].[GPWReversedInd]=1 then [new_MonthlyPriceChgTable].old_total else [new_MonthlyPriceChgTable].total end 
from GPWcontracts left join [new_MonthlyPriceChgTable]
on GPWContracts.Cust = [new_MonthlyPriceChgTable].Cust_id
and GPWContracts.GPWEffectiveDate >= [new_MonthlyPriceChgTable].[GPW_Date_Window_Start]
and GPWContracts.GPWEffectiveDate < [new_MonthlyPriceChgTable].[GPW_Date_Window_End]
where [new_MonthlyPriceChgTable].cust_id is not null 

UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '1.' + Cast(Year([GPWEffectiveDate]) AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=1
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '1.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=2
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '1.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=3
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '2.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=4
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '2.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=5
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '2.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=6
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '3.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=7
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '3.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=8
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '3.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=9	
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '4.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=10
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '4.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=11
UPDATE GPWContracts 
SET GPWContracts.GPWEffectiveQuarter = '4.'+ Cast(Year([GPWEffectiveDate])AS varchar) + '.'
WHERE Month([GPWEffectiveDate])=12

UPDATE GPWContracts
SET GPWContracts.GPWEffectiveYear = Year([GPWEffectiveDate])

UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '1.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=1
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '1.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=2
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '1.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=3
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '2.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=4
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '2.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=5
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '2.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=6
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '3.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=7
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '3.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=8
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '3.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=9
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '4.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=10
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '4.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=11
UPDATE GPWContracts
SET GPWContracts.GPWCancelQuarter = '4.' + Cast(Year([GPWCancelDate])AS varchar) + '.'
WHERE Month([GPWCancelDate])=12	

UPDATE GPWContracts
	SET GPWTermMonths = 
		  Case when term = '1m' then 1
				when [TermMonths] <= 9 then 6
				when [TermMonths] <= 20 then 12
				when [TermMonths] <= 32 then 28
				when [TermMonths] <= 48 then 42
				when [TermMonths] <= 64 then 60
				when [TermMonths] <= 80 then 72
				else 84 
		  end
	FROM GPWContracts

--IR added 12/31/18 to allow joins on null plan values
update GPWContracts
set [Plan] = CASE when [Plan] is null then 'NULL' else [Plan] END



--Added for earning curves
--DECLARE @ValDate as DATE
--SELECT @ValDate = ValDate FROM Tbl_DBValues
Update GPWContracts
Set GPWLag = datediff(month,GPWEffectiveDate,@Valdate)+1,
	GPWEarnTermMonths = case when GPWTermMonths = 1 then 1
							when TermMonths <= 6 then 6
							when TermMonths >= 75 then 75
							else TermMonths end

Update GPWContracts
Set GPWPercEarned = case when c.GPWLag > 75 then 1
						when c.gpwlag<=0 then 0
						when c.GPWEarnTermMonths = 1 and c.GPWLag=1 then 0.5
						when c.GPWEarnTermMonths = 1 then 1 else
						e.CumulPercEarned end
	from GPWContracts c left join tbl_EarningCurves e
		on c.[GPW Channel] = e.Channel
		and c.GPWLag=e.Lag
		and c.GPWEarnTermMonths = e.TermMonths
