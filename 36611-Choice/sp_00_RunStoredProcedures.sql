USE [36611_202212_ChoiceHW]


exec sp_0_Create_Pre_MonthlyContracts --this is to stack the monthly contract data using the monthly table as of prior (12/31/2020) and a new file just for 2021
EXEC sp_00_Make_MonthlyContracts; print 'sp_00_Make_MonthlyContracts has been Executed'
EXEC sp_00A_CREATE_Contracts; print 'sp_00A_CREATE_Contracts has been Executed'
EXEC sp_00B_CREATE_Claims; print 'sp_00B_CREATE_Claims has been Executed'
EXEC sp_00C_CREATE_Cancels; print 'sp_00C_CREATE_Cancels has been Executed'
EXEC [sp_00D_Create_new_MonthlyPriceChgTable]; print 'sp_00D_Create_new_MonthlyPriceChgTable has been executed'
--EXEC sp_00D_CREATE_MonthlyPriceTable; print 'sp_00D_CREATE_MonthlyPriceTable has been Executed' --this procedure wasn't working correctly, cleaned up with new procedure above

EXEC [sp_01_CREATE_GPWContracts]; print '[sp_01_CREATE_GPWContracts] has been Executed'
EXEC [sp_02_UPDATE_GPWContracts]; print '[sp_02_UPDATE_GPWContracts] has been Executed'
EXEC [sp_03_UPDATE_GPWContracts]; print '[sp_03_UPDATE_GPWContracts] has been Executed'
EXEC [sp_04_UPDATE_GPWContracts]; print '[sp_04_UPDATE_GPWContracts] has been Executed'
EXEC [sp_05_UPDATE_GPWContracts]; print '[sp_05_UPDATE_GPWContracts] has been Executed'
EXEC [sp_06_CREATE_GPWContractData]; print '[sp_06_CREATE_GPWContractData] has been Executed'
EXEC [sp_07_CREATE_GPWClaims]; print '[sp_07_CREATE_GPWClaims] has been Executed'
EXEC [sp_08_UPDATE_GPWClaims]; print '[sp_08_UPDATE_GPWClaims] has been Executed'
EXEC [sp_09_UPDATE_GPWClaims]; print '[sp_09_UPDATE_GPWClaims] has been Executed'
EXEC [sp_10_UPDATE_GPWClaims]; print '[sp_10_UPDATE_GPWClaims] has been Executed'
EXEC [sp_11_CREATE_GPWClaimsData]; print '[sp_11_CREATE_GPWClaimsData] has been Executed'
EXEC [sp_12_UPDATE_GPWContractData]; print '[sp_12_UPDATE_GPWContractData] has been Executed'
EXEC [sp_13_UPDATE_GPWClaimsData]; print '[sp_13_UPDATE_GPWClaimsData] has been Executed'
EXEC [sp_14_CREATE_GPWContractDataSummary]; print '[sp_14_CREATE_GPWContractDataSummary] has been Executed'
EXEC [sp_15_CREATE_GPWClaimsDataSummary]; print '[sp_15_CREATE_GPWClaimsDataSummary] has been Executed'
EXEC [sp_16_CREATE_GPWDataSummary]; print '[sp_16_CREATE_GPWDataSummary] has been Executed'

EXEC spt_00_CreateTableauTables; print 'spt_00_CreateTableauTables has been Executed'


/*
--SCRATCH
select *
from MonthlyPriceTable
where cust_id = '4227814'
select *
from RawData_homeprotection_price_increases
where cust_id = '4227814'
select *
from GPWContracts
where Cust = '4227814'
order by GPWEffectiveDate

select *
from Tbl_DBValues

select *
from MonthlyPriceTable
where cust_id = '1213170'
select *
from GPWContracts
where Cust = '1213170'
order by GPWEffectiveDate

select *
from MonthlyPriceTable
where cust_id = '12468'
select *
from RawData_homeprotection_price_increases
where cust_id = '12468'

select *
from RawData_ContractsMonthly
where Cust = '6765687'
select *
from RawData_ContractsMonthly_NewFormat
where Cust = '12468'



select *
from Contracts
where Cust = '12468'
order by GPWEffectiveDate
select *
from GPWContracts
where Cust = '12468'
order by GPWEffectiveDate

select *
from RawData_homeprotection_price_increases rd left join RawData_ContractsMonthly mo
on rd.cust_id = mo.Cust
where mo.Cust is null

select *
from RawData_homeprotection_price_increases rd left join [36611_201912_ChoiceHW].dbo.GPWContracts mo
on rd.cust_id = mo.Cust
where mo.Cust is null

*/
