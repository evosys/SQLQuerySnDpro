select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area ,p.distributor,dt.NAME ,
p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP code_le,p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP DT_LECODE,
replace(p.name,char(9),'') Outlet_name,
case 
when p.active = 1 then 'Active'
when p.active = 0 then 'InActive'
end Store_ActiveClosed,fcm.last_trans
from pop p
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
left join DISTRIBUTOR dt on dt.DISTRIBUTOR =p.DISTRIBUTOR
left join (
select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop , max(cm.doc_date) last_trans
 from cashmemo cm
where visit_type <> '88' 
group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
) fcm on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = fcm.code_pop and p.DISTRIBUTOR = fcm.DISTRIBUTOR
where ISNUMERIC(p.DISTRIBUTOR) =1
and p.ACTIVE =1 
and p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP in (
select lecode from (
select p.town+p.locality+p.slocality+p.pop leCode,count(p.distributor) a
from pop p 
where p.ACTIVE = 1 and ISNUMERIC(distributor) =1
group by p.town+p.locality+p.slocality+p.pop
) b where a>1)