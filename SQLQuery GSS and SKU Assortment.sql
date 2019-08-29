
select tdt.ncomp2, tdt.ncomp3, pvt1.distributor, pvt1.popcode ,tpop.element ,tpop.town,tpop.STREET
,pvt1.[20151],pvt1.[20152],pvt1.[20153],pvt1.[20154],pvt1.[20155],pvt1.[20156],pvt1.[20157],pvt1.[20158],pvt1.[20159],pvt1.[201510],
pvt1.[201511],pvt1.[201512]
,pvt2.[20151],pvt2.[20152],pvt2.[20153],pvt2.[20154],pvt2.[20155],pvt2.[20156],pvt2.[20157],pvt2.[20158],pvt2.[20159],pvt2.[201510],
pvt2.[201511],pvt2.[201512]
from 
(
	select distributor, popcode , [20151],[20152],[20153],[20154],[20155],[20156],[20157],[20158],[20159],[201510],[201511],[201512]
	from (
		SELECT cm.DISTRIBUTOR, cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP popcode 
		, cast (YEAR(cm.doc_date) as varchar)+cast(MONTH(cm.DOC_DATE) as varchar) bulan ,cd.SKU jmlsku from cashmemo cm
		join cashmemo_detail cd on cm.DOC_NO = cd.DOC_NO
		where cm.VISIT_TYPE in ('01','02') 
) cmd
pivot
	(count(jmlsku) for bulan in ([20151],[20152],[20153],[20154],[20155],[20156],[20157],[20158],[20159],[201510],[201511],[201512]))
	AS pivottable1 
) pvt1 

join 
(
	select p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP pop,p.STREET,p.DISTRIBUTOR,se.LDESC subelement,e.LDESC element,t.LDESC town from pop p
	join SUB_ELEMENT se on p.SUB_ELEMENT = se.SUB_ELEMENT
	join ELEMENT e on e.ELEMENT = se.ELEMENT
	join TOWN t on p.TOWN=t.TOWN
) tpop on tpop.pop =pvt1.popcode and tpop.distributor=pvt1.DISTRIBUTOR

join
(

	select da.DISTRIBUTOR,da.VALUE_COMB,clvl.ncomp2 ,clvl.ncomp3 from DISTRIBUTOR_ASSOCIATION da
	join
	(
		select ct.COMPCODE,ct.LDESC ncompcode, ct.COMP1,cl1.LDESC Ncomp1 ,ct.COMP2,
		cl2.LDESC ncomp2 ,ct.COMP3 ,cl3.LDESC ncomp3 from COMP_TABLE ct
		join COMP_LEVEL1 cl1 on ct.COMP1 = cl1.COMP1
		join COMP_LEVEL2 cl2 on ct.COMP2 = cl2.COMP2 and ct.COMP1=cl2.COMP1
		join COMP_LEVEL3 cl3 on ct.COMP1 = cl3.COMP1 and ct.COMP2=cl3.COMP2 and ct.COMP3 = cl3.COMP3
	) clvl on da.VALUE_COMB= clvl.COMPCODE 
	join 
	( 
		select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
		where FIELD_COMB = 'compcode'
		group by DISTRIBUTOR
	) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
) tdt on pvt1.DISTRIBUTOR = tdt.DISTRIBUTOR

join 
(
	select distributor, popcode , [20151],[20152],[20153],[20154],[20155],[20156],[20157],[20158],[20159],[201510],[201511],[201512]
	from (
	SELECT cm.DISTRIBUTOR, cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP popcode 
	, cast (YEAR(cm.doc_date) as varchar)+cast(MONTH(cm.DOC_DATE) as varchar) bulan , cm.NET_AMOUNT/1.1 jmlsku from cashmemo cm
	where cm.VISIT_TYPE in ('02','01') 
) cmd
pivot
( sum(jmlsku) for bulan in ([20151],[20152],[20153],[20154],[20155],[20156],[20157],[20158],[20159],[201510],[201511],[201512]))
AS pivottable1 
) pvt2 on pvt2.DISTRIBUTOR = pvt1.DISTRIBUTOR and pvt1.popcode = pvt2.popcode
