

select  plv.PROD3_DESC,plv.PROD4_DESC,cd.distributor,co.COMP2_DESC,glv.geo1_desc,sch.ldesc,
year(cd.doc_date)tahun, sum(cd.QTY1) cs, sum(cd.amount) gss
from cashmemo_detail cd
join cashmemo cm on cm.DOC_NO = cd.DOC_NO and cm.DISTRIBUTOR = cd.DISTRIBUTOR
join sku s on cd.sku = s.sku
join vw_PRODLEVEL plv on plv.MASTERSKU = s.MASTER_SKU and s.PROD1+s.PROD2+s.PROD3+s.PROD4 = plv.PROD4
--- compcode
join (
	select da.distributor, cl.comp2_desc, cl.comp3_desc from distributor_association da
	join vw_complevel cl on da.value_comb = cl.compcode
	join 
		( 
			select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
			where FIELD_COMB = 'compcode'
			group by DISTRIBUTOR
		) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
	where field_comb = 'COMPCODE'
) co on co.DISTRIBUTOR = cd.DISTRIBUTOR
--end compcode --- start geo
join (
	select DISTRIBUTOR,name,GEO1_DESC,GEO2_DESC,GEO3_DESC from DISTRIBUTOR d
	join vw_GEOLEVEL gl on gl.GEOCODE = d.GEOCODE
) glv on glv.DISTRIBUTOR = cd.DISTRIBUTOR
--- end geo --- start subelement
join (
	select  p.distributor , p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP lE_code,p.SUB_ELEMENT,sc.LDESC from pop p
	join SUB_ELEMENT se on se.SUB_ELEMENT = p.SUB_ELEMENT
	join SUB_CHANNEL sc on sc.SUB_CHANNEL = se.SUB_CHANNEL and sc.CHANNEL = se.CHANNEL and sc.MASTER_CHANNEL = se.MASTER_CHANNEL
	
) sch on sch.DISTRIBUTOR = cd.DISTRIBUTOR and cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP = sch.lE_code
where year(cd.doc_date) in ('2017','2016')
group by plv.PROD3_DESC,plv.PROD4_DESC,cd.distributor,co.COMP2_DESC,glv.geo1_desc,sch.ldesc,
year(cd.doc_date)


select * from sub_channel
select top 100 * from sku
select top 100 * from cashmemo_detail

select top 100 * from STOCK_BATCH
select top 100 * from geo_table
