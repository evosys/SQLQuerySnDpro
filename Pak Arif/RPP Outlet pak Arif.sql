
select co.comp2_desc RSM,co.comp3_desc ASM, p.distributor, d.name Distributor_name ,
p.town+p.locality+p.slocality+p.pop POP_Code ,replace(p.name,char(9),'') outlet_name,
(case when p.active = 1 then 'Active' when p.active = 0 then 'InActive' end ) as [Status] ,
(cmt.sales/(38 - pmb.Status)) RPP
from pop p
join distributor d on d.distributor =p.distributor
--- join compcode
join (
select da.distributor, cl.comp2_desc, cl.comp3_desc from distributor_association da
join vw_complevel cl on da.value_comb = cl.compcode
join 
	( 
		select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
		where FIELD_COMB = 'compcode'
		group by DISTRIBUTOR
	) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
where field_comb = 'COMPCODE') co on co.distributor = p.distributor
---- join untk membuat pembaginya
join (
select p.town+p.locality+p.slocality+p.pop codepop,jw.week_no,jw.year,
(case when jw.year = year(getdate()) then jw.week_no when jw.year <> year(getdate()) then '1' end )as [Status]
 from pop p
join jc_week jw on p.identify_on between jw.start_date and jw.end_date) pmb on p.town+p.locality+p.slocality+p.pop = pmb.codepop
---- join untuk nilainya
left join  (
select cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP codepop , SUM(cm.NET_AMOUNT) sales from cashmemo cm
where cm.visit_type = '02' and year(cm.DOC_DATE) = '2017'
group by cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP ) cmt on cmt.codepop = p.town+p.locality+p.slocality+p.pop


