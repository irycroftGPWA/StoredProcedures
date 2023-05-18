-- UPDATE GPWActiveReserve
UPDATE GPWContracts
SET GPWActiveReserve = GPWGrossReserve
FROM GPWContracts
WHERE GPWContractCount <> 0 AND GPWCancelCount <> 1
UPDATE GPWContracts
SET GPWActiveReserve = 0
FROM GPWContracts
WHERE GPWContractCount = 0 OR GPWCancelCount = 1

-- UPDATE GPWCancelReserve
UPDATE GPWContracts
SET GPWCancelReserve = GPWGrossReserve - CancelRefund
FROM GPWContracts
WHERE GPWCancelCount=1
UPDATE GPWContracts
SET GPWCancelReserve = 0
FROM GPWContracts
WHERE GPWCancelCount <> 1

-- UPDATE GPWRelativeCancelQtr
UPDATE GPWContracts
SET GPWRelativeCancelQtr = 0
FROM GPWContracts
WHERE [GPWEffectiveQtr#]=0 OR [GPWCancelQtr#] =0
UPDATE GPWContracts
SET GPWRelativeCancelQtr = [GPWCancelQtr#]-[GPWEffectiveQtr#]+1
FROM GPWContracts
WHERE  ([GPWEffectiveQtr#]) <> 0 AND [GPWCancelQtr#] <> 0


--IR added for new triangle segments differentiating between sales channel and plan
update GPWContracts
set [GPW N/U/P] = case when [GPW Channel] = 'DTC' then [GPW N/U/P]
  				   when [GPW Channel] = 'Real Estate' and [GPW N/U/P] <> 'Monthly' then 'RealEstate-'+[GPWPlan] +'-'+[GPWRenewalFlag] --12/31/2019 AJD added Contract Type to split RealEstate segments 
				   when [GPW Channel] = 'Real Estate' and [GPW N/U/P] = 'Monthly' then 'RealEstate-Monthly' end 


--Update for Earning Curves
Update GPWContracts
Set GPWEarnedReserves = GPWActiveReserve * GPWPercEarned + GPWCancelReserve


Update GPWContracts
Set [GPWAdjEarnedReserves] = case when GPWContractCount <> 0 AND GPWCancelCount <> 1
									then case when GPWTermMonths = 1 then GPWActiveReserve * GPWPercEarned
											when GPWActiveReserve <= GPWUpFrontAdj  then GPWActiveReserve
											else (GPWActiveReserve - GPWUpFrontAdj) * GPWPercEarned + GPWUpFrontAdj end
									when GPWCancelCount=1
									then GPWCancelReserve end
