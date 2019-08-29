select cbp.SKU_CODE as 'SKU BASEPACK' ,
cbp.BP as 'Lines',npd.NPD,WP.WP,EB.EB,RL.RL,COTC.COTC
from  
-- BP / Lines
(
	select SKU_CODE,COunt(UP_code) BP from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019'
	group by SKU_CODE
	) CBP 

-- NPD 
left join (
select SKU_CODE,COunt(UP_code) NPD from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019' and PACKTYPE ='5'
	group by SKU_CODE
		) NPD on NPD.SKU_CODE = cbp.SKU_CODE
-- WP IQ WITH
	left join (
select SKU_CODE,COunt(UP_code) WP from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019' and PACKTYPE ='2'
	group by SKU_CODE
		) WP on WP.SKU_CODE = cbp.SKU_CODE
-- EB Everbilled
left join (
select SKU_CODE,COunt(UP_code) EB from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019' and PACKTYPE ='1'
	group by SKU_CODE
		) EB on EB.SKU_CODE = cbp.SKU_CODE
-- RL/redlines
		left join (
select SKU_CODE,COunt(UP_code) RL from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019' and Color ='1'
	group by SKU_CODE
		) RL on RL.SKU_CODE = cbp.SKU_CODE
-- COTC COC
		left join (
select SKU_CODE,COunt(UP_code) COTC from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019' and LOCAL_PACKTYPE ='1'
	group by SKU_CODE
		) COTC on COTC.SKU_CODE = cbp.SKU_CODE
