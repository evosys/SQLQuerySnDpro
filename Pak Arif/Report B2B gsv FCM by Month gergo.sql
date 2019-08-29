
select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area,t.LDESC as 'Town Distributor',
p.distributor,d.NAME, p.town+p.locality+p.slocality+p.pop popcode , replace(p.name,char(9),'') outlet_name ,
case 
when p.active = 1 then 'Active'
when p.active = 0 then 'InActive'
end Store_ActiveClosed,elm.LDESC Outlet_element ,elm.Desc_se Outlet_SubElement,p.LATITUDE, p.LONGITUDE,
cso.VALUE_COMB_FROM as 'Call Center Code', tle.VALUE_COMB_FROM as 'Teleorder',b2.VALUE_COMB_FROM as 'B2B'
,ct.LDESC as 'Cashmemo Type',
gs.[01] as 'GSV 01',fcm.[01] as 'BILL 01',
gs.[02] as 'GSV 02',fcm.[02] as 'BILL 02',
gs.[03] as 'GSV 03',fcm.[03] as 'BILL 03',
gs.[04] as 'GSV 04',fcm.[04] as 'BILL 04',
gs.[05] as 'GSV 05',fcm.[05] as 'BILL 05',
gs.[06] as 'GSV 06',fcm.[06] as 'BILL 06',
gs.[07] as 'GSV 07',fcm.[07] as 'BILL 07',
gs.[08] as 'GSV 08',fcm.[08] as 'BILL 08',
gs.[09] as 'GSV 09',fcm.[09] as 'BILL 09',
gs.[10] as 'GSV 10',fcm.[10] as 'BILL 10',
gs.[11] as 'GSV 11',fcm.[11] as 'BILL 11',
gs.[12] as 'GSV 12',fcm.[12] as 'BILL 12'

from 
---- GSV start
 (
select distinct  distributor,codele,CASHMEMO_TYPE, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,CASHMEMO_TYPE,month(doc_date) GMonth,
 sum(((cm.net_amount/1.1)-cm.tot_discount)) GSV
from cashmemo cm 
where cm.VISIT_TYPE = '02' and Year(doc_date) = '2019' and cm.SUB_DOCUMENT not in ('02','04')
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,CASHMEMO_TYPE,month(doc_date) 
) x
pivot
    (
      sum(GSV) for GMonth in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
    ) as PVT
)gs 
--GSV end
left join pop p on gs.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = gs.codele
left join distributor d on d.DISTRIBUTOR = p.DISTRIBUTOR
 left join TOWN t on d.TOWN =t.TOWN 
 join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
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
--- fcm
left join (
select distinct  distributor,codele,CASHMEMO_TYPE, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,CASHMEMO_TYPE,month(doc_date) GMonth,
 count(cm.DOC_NO) GSV
from cashmemo cm 
where cm.VISIT_TYPE = '02' and Year(doc_date) = '2019'and cm.SUB_DOCUMENT not in ('02','04')
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop,CASHMEMO_TYPE ,month(doc_date) 
) x
pivot
    (
      sum(GSV) for GMonth in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
    ) as PVT
)fcm on fcm.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = fcm.codele and gs.cashmemo_type = fcm.cashmemo_type
--end fcm
left join ( select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop kode_Lee,VALUE_COMB_FROM from POP_ATTRIBUTE where FIELD_COMB='Call_Center_Code') cso on cso.kode_Lee =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
left join ( select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop kode_Lee,VALUE_COMB_FROM from POP_ATTRIBUTE where FIELD_COMB='TELE_OUTLET') tle on tle.kode_Lee =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
left join ( select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop kode_Lee,VALUE_COMB_FROM from POP_ATTRIBUTE where FIELD_COMB='eRTM_OUTLET') b2 on b2.kode_Lee =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
left join CASHMEMO_TYPE ct on ct.CASHMEMO_TYPE =gs.CASHMEMO_TYPE 
 where  p.distributor in (
'15061942','15086082','15094446','15132240','15132762',
'15139169','15141333','15146248','15162280','15173325',
'15173721','15197007','15227796','15251536','15261370',
'15315705','15390663','94418001','94432001','94458001',
'94801001','94803001','94809001','94810001','94812001',
'15164231','15072228','91009001') and (b2.VALUE_COMB_FROM = 'y' or tle.VALUE_COMB_FROM = 'y')