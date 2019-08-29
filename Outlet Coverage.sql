select co.comp3_desc, p.distributor,co.name, p.town+p.locality+p.slocality+p.pop,replace(p.name,char(9),'') outlet_name,
(case when p.active = 1 then 'Active' when p.active = 0 then 'InActive' end ) as [Status],
pj.pjp 
from pop p
join (
select da.distributor,d.name, cl.comp2_desc, cl.comp3_desc from distributor_association da
join distributor d on d.distributor = da.distributor
join vw_complevel cl on da.value_comb = cl.compcode
join 
	( 
		select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
		where FIELD_COMB = 'compcode'
		group by DISTRIBUTOR
	) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
where field_comb = 'COMPCODE') co on co.distributor = p.distributor
left join (
select spp.distributor, spp.town+spp.locality+spp.slocality+spp.pop cpop, count(pjp) pjp from section_pop_permanent spp 
group by spp.distributor, spp.town+spp.locality+spp.slocality+spp.pop 
) pj on pj.cpop = p.town+p.locality+p.slocality+p.pop and pj.distributor = p.distributor
