select co.comp2_desc,co.comp3_desc, p.DISTRIBUTOR,co.name,
p.town+p.locality+p.slocality+p.pop popcode,p.NAME, pcs.sku,s.ldesc,
[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45]
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
select distinct  distributor,codele,sku, [33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45]
from 
	(
		select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,jw.WEEK_NO, 
		cd.sku , sum((cd.qty1*b.SELL_FACTOR1)+(cd.qty2*12)+cd.qty3) pcs 
		from cashmemo_detail cd
			join cashmemo cm on cm.distributor = cd.distributor and cd.doc_no = cm.doc_no
			join jc_week jw on cd.doc_date between jw.start_date and jw.end_date 
			join BATCH b on b.sku = cd.sku
		where cm.VISIT_TYPE = '02' and jw.year = '2018' and b.price_struc = '0001' )
		group by cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop ,jw.WEEK_NO,cd.sku 
	) x
pivot
    (
      sum(pcs) for WEEK_NO in ( [33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45])
    ) as PVT 
) pcs on p.town+p.locality+p.slocality+p.pop = pcs.codele and p.distributor = pcs.distributor
join sku s on pcs.sku = s.sku
where co.comp2_desc ='RSM WEST'