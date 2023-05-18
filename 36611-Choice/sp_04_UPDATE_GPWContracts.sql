DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)


--   UPDATE GPWCancelCount Column
UPDATE GPWContracts
SET GPWCancelCount= 0
WHERE GPWContractCount=0
UPDATE GPWContracts
Set GPWCancelCount = 0
WHERE GPWCancelDate > @ValDate
UPDATE GPWContracts
SET GPWCancelCount = 1
WHERE GPWCancelDate <= @ValDate AND GPWContractCount<>0
-- UPDATE GPWCancelQtr#
UPDATE GPWContracts
SET [GPWCancelQtr#] = (YEAR(GPWCancelDate) - YEAR(@valDate))*4 + CEILING(Cast((MONTH(GPWCancelDate) - MONTH(@valDate)) as float)/3) + 40
UPDATE GPWContracts
SET [GPWCancelQtr#] = 0
FROM GPWContracts 
WHERE [GPWCancelQtr#] IS NULL
