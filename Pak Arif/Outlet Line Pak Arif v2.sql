
select co.comp2_desc RSM,co.comp3_desc ASM, p.distributor, d.name Distributor_name ,
lines.pjp ,replace(ph.LDESC,char(9),'') PJP_Name , lines.dsr ,replace(ds.name,char(9),'') Name_DSR ,
p.town+p.locality+p.slocality+p.pop POP_Code ,replace(p.name,char(9),'') outlet_name,
(case when p.active = 1 then 'Active' when p.active = 0 then 'InActive' end ) as [Status] 
, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]
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

-- test report start
left join (
select distributor,code_outlet ,DSR,PJP, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]
from
(
select sk.DISTRIBUTOR, sk.code_Outlet,sk.DSR,sk.PJP,jw.year, jw.JCNO , COUNT(sk.sku) total_line 
from (
select distinct cm.DISTRIBUTOR, cm.town+cm.LOCALITY+cm.SLOCALITY+cm.POP code_Outlet,cm.DSR,cm.PJP,cm.DOC_DATE ,cd.sku from cashmemo cm
left join cashmemo_detail cd on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO 
and cd.DOC_DATE = cm.DOC_DATE
where YEAR(cm.DOC_DATE) = '2017' and cm.visit_type = '02'
) sk
join JC_WEEK jw on sk.DOC_DATE between jw.START_DATE and jw.END_DATE
group by sk.DISTRIBUTOR,sk.code_Outlet,sk.DSR,sk.PJP,jw.YEAR, jw.JCNO
) x
pivot ( sum(total_line) for JCNO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])) as pvt
) lines on lines.code_Outlet = p.town+p.locality+p.slocality+p.pop and lines.DISTRIBUTOR = p.DISTRIBUTOR
-- test end
join dsr ds on ds.dsr = lines.dsr and ds.distributor = p.distributor
join PJP_HEAD ph on ph.pjp = lines.pjp and ph.distributor = lines.distributor

--select * from dsr