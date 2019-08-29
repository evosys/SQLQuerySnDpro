
select co.comp2_desc RSM,co.comp3_desc ASM, p.distributor, d.name Distributor_name ,
p.town+p.locality+p.slocality+p.pop POP_Code ,replace(p.name,char(9),'') outlet_name,
(case when p.active = 1 then 'Active' when p.active = 0 then 'InActive' end ) as [Status] 
, [201601],[201602],[201603],[201604],[201605],[201606],[201607],[201608],[201609],[201610],[201611],[201612], [201701],[201702],[201703],[201704],[201705],[201706],[201707],[201708],[201709],[201710],[201711],[201712]
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
select distributor,code_outlet , [201601],[201602],[201603],[201604],[201605],[201606],[201607],[201608],[201609],[201610],[201611],[201612], [201701],[201702],[201703],[201704],[201705],[201706],[201707],[201708],[201709],[201710],[201711],[201712]
from
(
select sk.DISTRIBUTOR, sk.code_Outlet,jw.year+jw.JCNO yjc, COUNT(sk.sku) total_line 
from (
select distinct cm.DISTRIBUTOR, cm.town+cm.LOCALITY+cm.SLOCALITY+cm.POP code_Outlet,cm.DOC_DATE ,cd.sku 
from cashmemo cm
left join cashmemo_detail cd on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO 
and cd.DOC_DATE = cm.DOC_DATE
left join DSR d on d.DSR = cm.DSR and d.DISTRIBUTOR = cm.DISTRIBUTOR
where YEAR(cm.DOC_DATE) in ('2016','2017') and cm.visit_type = '02' and cm.sub_document = '01'
and cd.amount  <> '0' and d.COUNTERSALE_YN+d.JOB_TYPE <> 'Y03' 
) sk
join JC_WEEK jw on sk.DOC_DATE between jw.START_DATE and jw.END_DATE
--where YEAR(sk.DOC_DATE) = '2017'
group by sk.DISTRIBUTOR,sk.code_Outlet,jw.YEAR, jw.JCNO
) x
pivot ( sum(total_line) for yjc in ( [201601],
[201602],[201603],[201604],[201605],[201606],[201607],[201608],[201609],[201610],[201611],[201612], [201701],[201702],[201703],[201704],[201705],[201706],[201707],[201708],[201709],[201710],[201711],[201712] )) as pvt
) lines on lines.code_Outlet = p.town+p.locality+p.slocality+p.pop and lines.DISTRIBUTOR = p.DISTRIBUTOR

-- test end

--select top 100 * from cashmemo_detail