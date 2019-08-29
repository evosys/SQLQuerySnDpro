select co.comp2_desc,co.comp3_desc, p.DISTRIBUTOR,co.name,
p.town+p.locality+p.slocality+p.pop popcode,p.NAME, pcs.sku,s.ldesc,
[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from pop p
--- compcode
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
--- perhitungannya
left join
(
select distinct  distributor,codele,sku, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
	(
		select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,jw.WEEK_NO, 
		cd.sku , sum((cd.qty1*b.SELL_FACTOR1)+(cd.qty2*12)+cd.qty3) pcs 
		from cashmemo_detail cd
			join cashmemo cm on cm.distributor = cd.distributor and cd.doc_no = cm.doc_no
			join jc_week jw on cd.doc_date between jw.start_date and jw.end_date 
			join BATCH b on b.sku = cd.sku
		where cm.VISIT_TYPE = '02' and jw.year = '2017' and b.price_struc = '0001'
		and cd.DISTRIBUTOR in (
'15061942','15094446','15131446','15132773','15139169','15141333','15173325','15173721','15178495','15195919',
'15197007','15210256','15211052','15261011','94801001','94803001','94809001','94810001','94812001','94816001','98991001'
)
		group by cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop ,jw.WEEK_NO,cd.sku 
	) x
pivot
    (
      sum(pcs) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
     [29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT 
) pcs on p.town+p.locality+p.slocality+p.pop = pcs.codele and p.distributor = pcs.distributor
join sku s on pcs.sku = s.sku
where p.DISTRIBUTOR in (
'15061942','15094446','15131446','15132773','15139169','15141333','15173325','15173721','15178495','15195919',
'15197007','15210256','15211052','15261011','94801001','94803001','94809001','94810001','94812001','94816001','98991001'
)