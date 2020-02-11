
select co.comp2_desc RSM,co.comp3_desc ASM, p.distributor, d.name Distributor_name,
pjd.pjp,replace(pjd.ldesc,char(9),'') PJP_Name ,pjd.dsr,replace(pjd.name,char(9),'') DSR_Name,
p.town+p.locality+p.slocality+p.pop POP_Code ,replace(p.name,char(9),'') outlet_name,
(case when pjd.WEEKS_IN_CYCLE = 1 then 'Weekly' when pjd.WEEKS_IN_CYCLE = 2 then 'BeWeekly' end ) as [Status] ,
(case when p.active = 1 then 'Active' when p.active = 0 then 'InActive' end ) as [Status]
 from pop p
join distributor d on d.distributor =p.distributor
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
left join (
select distinct sp.town+sp.locality+sp.slocality+sp.pop popcode, sp.PJP,ph.LDESC ,ph.WEEKS_IN_CYCLE,ph.dsr,d.name 
from section_pop sp
join PJP_HEAD ph on ph.pjp = sp.PJP and ph.distributor = sp.distributor
join dsr d on d.dsr = ph.dsr and d.distributor = ph.distributor
where d.job_type in ('01','03')
) pjd on pjd.popcode = p.town+p.locality+p.slocality+p.pop

