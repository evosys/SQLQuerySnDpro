select 
p.PREV_POP_CODE Kode_Outlet_Scylla, p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP Kode_Outlet_Leveredge, p.NAME Outlet_Name,
d.name Nama_Concess , dlv.comp3_desc AREA , p.market_name Nama_pasar,e.ldesc Outlet_Type_Desc ,se.ldesc outlet_sub_type_Desc,
kc.ldesc Banner_Desc, asz.ldesc CABINET_SIZE, cmn.net Total_Jualan_Q1 ,CONVERT(VARCHAR(11),fcm.fcm,6) First_transaction , CONVERT(VARCHAR(11),p.identify_on,6) Date_create_pop
from pop p
join DISTRIBUTOR d on p.distributor = d.distributor
join (
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
join sub_element se on p.sub_element = se.sub_element
left join element e on se.element = e.element
left join key_customer kc on p.key_customer = kc.key_customer
left join asset a on p.company+p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = a.lastlocationcode
join asset_size asz on a.asset_size = asz.asset_size
left join (
select cm.town+cm.locality+cm.slocality+cm.pop code_pop , sum(cm.net_amount) net
 from cashmemo cm
where visit_type <> '88'
and cm.doc_date between '20170101' and '20170331'
group by cm.town+cm.locality+cm.slocality+cm.pop) cmn on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = cmn.code_pop
left join (
select cm.town+cm.locality+cm.slocality+cm.pop code_pop , min(cm.doc_date) fcm
 from cashmemo cm
where visit_type <> '88'
group by cm.town+cm.locality+cm.slocality+cm.pop
) fcm on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = fcm.code_pop
where p.DISTRIBUTOR <> 'UID00001'

