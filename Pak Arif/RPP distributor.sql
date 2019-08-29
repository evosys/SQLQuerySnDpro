select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area ,p.distributor,p.NAME ,
gs19.sales/27 as 'GSV 2019/YTD',
GSV.GSV /13
as 'RPP WK15 - WK27' 
from DISTRIBUTOR p
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
	--- RPP 
left join (
select cm.distributor, sum(cm.NET_AMOUNT) GSV
from cashmemo cm 
where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20190408' and '20190707'
group by cm.distributor
) GSV on GSV.DISTRIBUTOR = p.DISTRIBUTOR 
--- RPP WK15 - WK27

left join (
		select cm.DISTRIBUTOR ,SUM(cm.NET_AMOUNT) sales
		from cashmemo cm
		where cm.VISIT_TYPE = '02' and YEAR(cm.doc_date) = '2019'
		group by cm.DISTRIBUTOR
	) gs19 on p.DISTRIBUTOR = gs19.DISTRIBUTOR

where  
isnumeric(p.distributor)=1
-- distributor UFS on SERVER HPC
and p.DISTRIBUTOR not in ('15440642','15440643','15441941','15446779','15451130',
'15451701')