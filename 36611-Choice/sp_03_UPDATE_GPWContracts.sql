DECLARE @ValDate date
Select @ValDate = ValDate from Tbl_DBValues
 
--   UPDATE GPWContractCount Column
UPDATE GPWContracts 
SET GPWContracts.GPWContractCount = 1 
UPDATE GPWContracts 
SET GPWContracts.GPWContractCount = 0 
WHERE [GPWEffectiveDate]>@ValDate
	Or [GPWTermMonths]<1 Or [TermMonths]>180  --ACL: LW has 180
	Or [GPWFlatCancel]='F'

UPDATE GPWContracts
set GPWGrossReserve = case when [GPWEffectiveDate] < @ValDate then [Monthly Price] else 0 end
where GPWContractType = 'Monthly'-- and GPWContractCount = 1 
 
--10/31/2020 - old number of months file is not updated for cancellations, need to use new cancel date from cancels file
UPDATE GPWContracts
set GPWContractCount = 0 --needs to also be udpated in sp3
from GPWContracts con inner join CancelsbyContract can
on con.Cust = can.custid and con.GPWEffectiveDate > can.GPWCancelDate
and con.GPWContractType = can.accttype
where GPWContractType = 'Monthly'

--10/31/2020 (AJD added 12/18/2020)
update gpwcontracts
set GPWGrossReserve = 0
where gpwcontractCount = 0 and GPWContractType = 'Monthly'

--6/30/2020
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'temp_total_prem_tbl')
	DROP TABLE temp_total_prem_tbl

select cust, sum([Monthly Price]) as TotalPaid 
into temp_total_prem_tbl
from GPWContracts 
where GPWContractType = 'Monthly'
group by Cust	

update GPWContracts
set [Total Paid] = temp_total_prem_tbl.TotalPaid
from GPWContracts left join temp_total_prem_tbl 
on GPWContracts.Cust = temp_total_prem_tbl.Cust
where temp_total_prem_tbl.Cust is not null
and GPWContracts.MonthCount = 1

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'temp_total_prem_tbl')
	DROP TABLE temp_total_prem_tbl
  
--   UPDATE GPWEffectiveQtr# Column
UPDATE GPWContracts
SET GPWEffectiveQtr# = (YEAR(GPWEffectiveDate) - YEAR(@valDate))*4 + CEILING(Cast((MONTH(GPWEffectiveDate) - MONTH(@valDate)) as float)/3) + 40
