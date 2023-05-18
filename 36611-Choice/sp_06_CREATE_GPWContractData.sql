DECLARE @ValDate AS DATE
DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM Tbl_DBValues)
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWContractData')
	DROP TABLE GPWContractData

CREATE TABLE [GPWContractData] (
	 [Source] nvarchar(255)
	,[GPWCoverage1] nvarchar(255)
	,[GPWCoverage2] nvarchar(255)
	,[GPW N/U/P] nvarchar(255)
	,[GPW Channel] nvarchar(255)
	,[GPW Plan] nvarchar(255)
	,[GPWEffectiveDate] date
--	,[GPWEffectiveMiles] float
	,[GPWTermMonths] float
--	,[GPWTermMiles] float
	,[GPWCancelDate] date
	,[GPWEffectiveQuarter] nvarchar(255)
	,[GPWEffectiveQtr#] int NULL
	,[GPWEffectiveYear] int NULL
	,[GPWExpireDate] date NULL
	,[GPWCancelQuarter] nvarchar(255)
	,[GPWCancelQtr#] int NULL
	,[GPWRelativeCancelQtr] int NULL
	,[GPWFlatCancel] nvarchar(255)
	,[GPWContractCount] int
	,[GPWCancelCount] int
	,[GPWActiveReserve] float
	,[GPWCancelReserve] float
--	,[GPWMMEarned] float
	,[GPWCancelCount1] int
	,[GPWCancelCount2] int
	,[GPWCancelCount3] int
	,[GPWCancelCount4] int
	,[GPWCancelCount5] int
	,[GPWCancelCount6] int
	,[GPWCancelCount7] int
	,[GPWCancelCount8] int
	,[GPWCancelCount9] int
	,[GPWCancelCount10] int
	,[GPWCancelCount11] int
	,[GPWCancelCount12] int
	,[GPWCancelCount13] int
	,[GPWCancelCount14] int
	,[GPWCancelCount15] int
	,[GPWCancelCount16] int
	,[GPWCancelCount17] int
	,[GPWCancelCount18] int
	,[GPWCancelCount19] int
	,[GPWCancelCount20] int
	,[GPWCancelCount21] int
	,[GPWCancelCount22] int
	,[GPWCancelCount23] int
	,[GPWCancelCount24] int
	,[GPWCancelCount25] int
	,[GPWCancelCount26] int
	,[GPWCancelCount27] int
	,[GPWCancelCount28] int
	,[GPWCancelCount29] int
	,[GPWCancelCount30] int
	,[GPWCancelCount31] int
	,[GPWCancelCount32] int
	,[GPWCancelCount33] int
	,[GPWCancelCount34] int
	,[GPWCancelCount35] int
	,[GPWCancelCount36] int
	,[GPWCancelCount37] int
	,[GPWCancelCount38] int
	,[GPWCancelCount39] int
	,[GPWCancelCount40] int
	,[GPWCancelRx1] float
	,[GPWCancelRx2] float
	,[GPWCancelRx3] float
	,[GPWCancelRx4] float
	,[GPWCancelRx5] float
	,[GPWCancelRx6] float
	,[GPWCancelRx7] float
	,[GPWCancelRx8] float
	,[GPWCancelRx9] float
	,[GPWCancelRx10] float
	,[GPWCancelRx11] float
	,[GPWCancelRx12] float
	,[GPWCancelRx13] float
	,[GPWCancelRx14] float
	,[GPWCancelRx15] float
	,[GPWCancelRx16] float
	,[GPWCancelRx17] float
	,[GPWCancelRx18] float
	,[GPWCancelRx19] float
	,[GPWCancelRx20] float
	,[GPWCancelRx21] float
	,[GPWCancelRx22] float
	,[GPWCancelRx23] float
	,[GPWCancelRx24] float
	,[GPWCancelRx25] float
	,[GPWCancelRx26] float
	,[GPWCancelRx27] float
	,[GPWCancelRx28] float
	,[GPWCancelRx29] float
	,[GPWCancelRx30] float
	,[GPWCancelRx31] float
	,[GPWCancelRx32] float
	,[GPWCancelRx33] float
	,[GPWCancelRx34] float
	,[GPWCancelRx35] float
	,[GPWCancelRx36] float
	,[GPWCancelRx37] float
	,[GPWCancelRx38] float
	,[GPWCancelRx39] float
	,[GPWCancelRx40] float
 )
INSERT INTO GPWContractData(
	[Source]
	,[GPWCoverage1]
	,[GPWCoverage2]
	,[GPW N/U/P]
	,[GPW Channel]
	,[GPW Plan]
	,[GPWEffectiveDate]
--	,[GPWEffectiveMiles]
	,[GPWTermMonths]
--	,[GPWTermMiles]
	,[GPWCancelDate]
	,[GPWEffectiveQuarter]
	,[GPWEffectiveQtr#]
	,[GPWEffectiveYear]
	,[GPWExpireDate]
	,[GPWCancelQuarter]
	,[GPWCancelQtr#]
	,[GPWRelativeCancelQtr]
	,[GPWFlatCancel]
	,[GPWContractCount]
	,[GPWCancelCount]
	,[GPWActiveReserve]
	,[GPWCancelReserve]
--	,[GPWMMEarned]
	,[GPWCancelCount1] 
	,[GPWCancelCount2] 
	,[GPWCancelCount3] 
	,[GPWCancelCount4] 
	,[GPWCancelCount5] 
	,[GPWCancelCount6] 
	,[GPWCancelCount7] 
	,[GPWCancelCount8] 
	,[GPWCancelCount9] 
	,[GPWCancelCount10] 
	,[GPWCancelCount11] 
	,[GPWCancelCount12] 
	,[GPWCancelCount13] 
	,[GPWCancelCount14] 
	,[GPWCancelCount15] 
	,[GPWCancelCount16] 
	,[GPWCancelCount17] 
	,[GPWCancelCount18] 
	,[GPWCancelCount19] 
	,[GPWCancelCount20] 
	,[GPWCancelCount21] 
	,[GPWCancelCount22] 
	,[GPWCancelCount23] 
	,[GPWCancelCount24] 
	,[GPWCancelCount25] 
	,[GPWCancelCount26] 
	,[GPWCancelCount27] 
	,[GPWCancelCount28] 
	,[GPWCancelCount29] 
	,[GPWCancelCount30] 
	,[GPWCancelCount31] 
	,[GPWCancelCount32] 
	,[GPWCancelCount33] 
	,[GPWCancelCount34] 
	,[GPWCancelCount35] 
	,[GPWCancelCount36] 
	,[GPWCancelCount37] 
	,[GPWCancelCount38] 
	,[GPWCancelCount39] 
	,[GPWCancelCount40]
	,[GPWCancelRx1] 
	,[GPWCancelRx2] 
	,[GPWCancelRx3] 
	,[GPWCancelRx4] 
	,[GPWCancelRx5] 
	,[GPWCancelRx6] 
	,[GPWCancelRx7] 
	,[GPWCancelRx8] 
	,[GPWCancelRx9] 
	,[GPWCancelRx10] 
	,[GPWCancelRx11] 
	,[GPWCancelRx12] 
	,[GPWCancelRx13] 
	,[GPWCancelRx14] 
	,[GPWCancelRx15] 
	,[GPWCancelRx16] 
	,[GPWCancelRx17] 
	,[GPWCancelRx18] 
	,[GPWCancelRx19] 
	,[GPWCancelRx20] 
	,[GPWCancelRx21] 
	,[GPWCancelRx22] 
	,[GPWCancelRx23] 
	,[GPWCancelRx24] 
	,[GPWCancelRx25] 
	,[GPWCancelRx26] 
	,[GPWCancelRx27] 
	,[GPWCancelRx28] 
	,[GPWCancelRx29] 
	,[GPWCancelRx30] 
	,[GPWCancelRx31] 
	,[GPWCancelRx32] 
	,[GPWCancelRx33] 
	,[GPWCancelRx34] 
	,[GPWCancelRx35] 
	,[GPWCancelRx36] 
	,[GPWCancelRx37] 
	,[GPWCancelRx38] 
	,[GPWCancelRx39] 
	,[GPWCancelRx40]
 )
SELECT 
[Source] as [Source]
,[GPWCoverage1] AS [GPWCoverage1]
,[GPWCoverage2] AS [GPWCoverage2]
,[GPW N/U/P] AS [GPW N/U/P]
,[GPW Channel] as [GPW Channel]
--,[Plan] as [GPW Plan]
,[GPWPlan] as [GPW Plan]
,[GPWEffectiveDate] AS [GPWEffectiveDate]
--,[GPWEffectiveMiles] AS [GPWEffectiveMiles]
,[GPWTermMonths] AS [GPWTermMonths]
--,[GPWTermMiles] AS [GPWTermMiles]
,[GPWCancelDate] AS [GPWCancelDate]
,[GPWEffectiveQuarter] AS [GPWEffectiveQuarter]
,[GPWEffectiveQtr#] AS [GPWEffectiveQtr#]
,[GPWEffectiveYear] AS [GPWEffectiveYear]
,[GPWExpireDate] AS [GPWExpireDate]
,[GPWCancelQuarter] AS [GPWCancelQuarter]
,[GPWCancelQtr#] AS [GPWCancelQtr#]
,[GPWRelativeCancelQtr] AS [GPWRelativeCancelQtr]
,[GPWFlatCancel] AS [GPWFlatCancel]
,[GPWContractCount] AS [GPWContractCount]
,[GPWCancelCount] AS [GPWCancelCount]
,[GPWActiveReserve] AS [GPWActiveReserve]
,[GPWCancelReserve] AS [GPWCancelReserve]
--,[GPWMMEarned] AS [GPWMMEarned]
,0 AS GPWCancelCount1 
,0 AS GPWCancelCount2 
,0 AS GPWCancelCount3 
,0 AS GPWCancelCount4 
,0 AS GPWCancelCount5 
,0 AS GPWCancelCount6 
,0 AS GPWCancelCount7 
,0 AS GPWCancelCount8 
,0 AS GPWCancelCount9 
,0 AS GPWCancelCount10 
,0 AS GPWCancelCount11
,0 AS GPWCancelCount12 
,0 AS GPWCancelCount13 
,0 AS GPWCancelCount14 
,0 AS GPWCancelCount15 
,0 AS GPWCancelCount16 
,0 AS GPWCancelCount17 
,0 AS GPWCancelCount18 
,0 AS GPWCancelCount19 
,0 AS GPWCancelCount20 
,0 AS GPWCancelCount21 
,0 AS GPWCancelCount22 
,0 AS GPWCancelCount23 
,0 AS GPWCancelCount24 
,0 AS GPWCancelCount25 
,0 AS GPWCancelCount26 
,0 AS GPWCancelCount27 
,0 AS GPWCancelCount28 
,0 AS GPWCancelCount29 
,0 AS GPWCancelCount30 
,0 AS GPWCancelCount31 
,0 AS GPWCancelCount32 
,0 AS GPWCancelCount33 
,0 AS GPWCancelCount34 
,0 AS GPWCancelCount35 
,0 AS GPWCancelCount36 
,0 AS GPWCancelCount37 
,0 AS GPWCancelCount38 
,0 AS GPWCancelCount39 
,0 AS GPWCancelCount40
,0 AS GPWCancelRx1 
,0 AS GPWCancelRx2 
,0 AS GPWCancelRx3 
,0 AS GPWCancelRx4 
,0 AS GPWCancelRx5 
,0 AS GPWCancelRx6 
,0 AS GPWCancelRx7 
,0 AS GPWCancelRx8 
,0 AS GPWCancelRx9
,0 AS GPWCancelRx10 
,0 AS GPWCancelRx11
,0 AS GPWCancelRx12 
,0 AS GPWCancelRx13 
,0 AS GPWCancelRx14 
,0 AS GPWCancelRx15 
,0 AS GPWCancelRx16 
,0 AS GPWCancelRx17 
,0 AS GPWCancelRx18 
,0 AS GPWCancelRx19 
,0 AS GPWCancelRx20 
,0 AS GPWCancelRx21 
,0 AS GPWCancelRx22 
,0 AS GPWCancelRx23 
,0 AS GPWCancelRx24 
,0 AS GPWCancelRx25 
,0 AS GPWCancelRx26 
,0 AS GPWCancelRx27 
,0 AS GPWCancelRx28 
,0 AS GPWCancelRx29 
,0 AS GPWCancelRx30 
,0 AS GPWCancelRx31 
,0 AS GPWCancelRx32 
,0 AS GPWCancelRx33 
,0 AS GPWCancelRx34 
,0 AS GPWCancelRx35 
,0 AS GPWCancelRx36 
,0 AS GPWCancelRx37 
,0 AS GPWCancelRx38 
,0 AS GPWCancelRx39
,0 AS GPWCancelRx40 
FROM GPWContracts
WHERE (GPWContracts.GPWEffectiveDate >= @BegDate AND GPWContracts.GPWEffectiveDate <= @ValDate) 
AND (GPWContracts.GPWTermMonths>0) 
And (GPWContracts.GPWTermMonths<181) --ACL: updated to 180
AND (GPWContracts.GPWRelativeCancelQtr>=0) 
AND (GPWContracts.GPWContractCount=1) 
--AND (GPWContracts.GPWActiveReserve>0 OR GPWContracts.GPWCancelReserve>0)  --we want to send through negatives because of potential timing mismatches with cancels file
