select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area ,cbp.[DT CODE],dt.NAME ,
CBP.[POPCODE] as 'POPCODE' ,p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'SND outlet Code',replace(p.name,char(9),'') Outlet_name,
elm.element Element_code,elm.LDESC Outlet_element ,p.SUB_ELEMENT Sub_element_code,elm.Desc_se Outlet_SubElement,
cbp.BP as 'Lines',npd.NPD,WP.WP,EB.EB,RL.RL,COTC.COTC
from  
-- BP / Lines
(
	select RS_CODE as 'DT CODE' ,UP_code as 'POPCODE',COunt(UP_code) BP from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019'
	group by RS_CODE,UP_code
	) CBP 

---
	left join pop p on p.TOWN+'-'+p.DISTRIBUTOR+'-'+p.LOCALITY+'-'+p.SLOCALITY+'-'+p.POP = CBP.POPCODE
		left join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
		) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
	left join (
		select da.DISTRIBUTOR,da.VALUE_COMB,clvl.comp2_desc ,clvl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
		join
		vw_complevel clvl on da.VALUE_COMB= clvl.COMPCODE 
		join 
		( 
			select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
			where FIELD_COMB = 'compcode'
			group by DISTRIBUTOR
		) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
	) dlv on p.distributor = dlv.distributor
	left join DISTRIBUTOR dt on dt.DISTRIBUTOR =p.DISTRIBUTOR
-- NPD 
left join (
select RS_CODE as 'DT CODE' ,UP_code as 'POPCODE',COunt(UP_code) NPD from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019' and PACKTYPE ='5'
	group by RS_CODE,UP_code
		) NPD on NPD.POPCODE = cbp.popcode
-- WP IQ WITH
	left join (
select RS_CODE as 'DT CODE' ,UP_code as 'POPCODE',COunt(UP_code) WP from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019' and PACKTYPE ='2'
	group by RS_CODE,UP_code
		) WP on WP.POPCODE = cbp.popcode
-- EB Everbilled
left join (
select RS_CODE as 'DT CODE' ,UP_code as 'POPCODE',COunt(UP_code) EB from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019' and PACKTYPE ='1'
	group by RS_CODE,UP_code
		) EB on EB.POPCODE = cbp.popcode
-- RL/redlines
		left join (
select RS_CODE as 'DT CODE' ,UP_code as 'POPCODE',COunt(UP_code) RL from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019' and Color ='1'
	group by RS_CODE,UP_code
		) RL on RL.POPCODE = cbp.popcode
-- COTC COC
		left join (
select RS_CODE as 'DT CODE' ,UP_code as 'POPCODE',COunt(UP_code) COTC from
	SUGGESTED_ORDER a 
	where MOC_NO ='04' and MOC_YEAR ='2019' and LOCAL_PACKTYPE ='1'
	group by RS_CODE,UP_code
		) COTC on COTC.POPCODE = cbp.popcode
