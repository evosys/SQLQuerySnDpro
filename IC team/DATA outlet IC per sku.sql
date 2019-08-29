select  cl.area, p.distributor kode_DT,dt.name nama_DT, p.town+p.locality+p.slocality+p.pop kode_outlet, p.name nama_outlet,
pt.ldesc pop_type, kc.ldesc BANNER, s.sku,s.nama_sku , s.sales
from pop p
join (select da.DISTRIBUTOR,cl.COMP3, cl.COMP3_DESC AREA from distributor_association da
join vw_complevel cl on cl.compcode = da.VALUE_COMB
join (select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
		where FIELD_COMB = 'compcode'
		group by DISTRIBUTOR) sq on da.SEQ_NO = sq.CNT and da.DISTRIBUTOR = sq.DISTRIBUTOR
where da.FIELD_COMB = 'compcode' 
) cl on cl.DISTRIBUTOR = p.DISTRIBUTOR
join pop_type pt on p.poptype = pt.poptype
join key_customer kc on kc.key_customer = p.key_customer
join distributor dt on dt.distributor = p.distributor
---- sales & outlet
left join 
(select cd.distributor,cm.town+cm.locality+cm.slocality+cm.pop kode_pop,cd.sku, s.ldesc nama_SKU , sum(cd.amount+cd.GST) sales  from cashmemo_detail cd
join cashmemo cm on cd.doc_no = cm.doc_no and cm.distributor = cd.distributor
join sku s on s.sku= cd.sku
where cd.doc_date between '20170101' and '20170702' and  cm.visit_type = '02' 
group by cd.distributor, cm.town+cm.locality+cm.slocality+cm.pop,cd.sku, s.ldesc ) s
on s.kode_pop = p.town+p.locality+p.slocality+p.pop and p.distributor = s.distributor
where p.DISTRIBUTOR in (
'98008001',
'98009001',
'98016001',
'98026001',
'98030001',
'98039001',
'98047001',
'98048001',
'98049001'
)
--where cl.COMP3 ='E1005E2051E4192'

--select distinct COMP3, comp3_desc from vw_COMPLEVEL