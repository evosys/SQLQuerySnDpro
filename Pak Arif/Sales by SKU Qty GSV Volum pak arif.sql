

select  dlv.comp3_desc AREA ,d.distributor, d.name Nama_Concess ,
p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP Kode_Outlet_Leveredge, p.NAME Outlet_Name, skugrs.SKU,s.ldesc SKU_Name,skugrs.JCNO ,skugrs.pcs,skugrs.Grs,skugrs.berat

from pop p
join DISTRIBUTOR d on p.distributor = d.distributor
join (
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
left join (
---- Perhitungan Gross SKunya
select cm.DISTRIBUTOR, cm.town+cm.locality+cm.slocality+cm.pop code_pop, cd.sku ,jw.jcno ,sum(cd.amount) Grs, 
		sum(((cd.QTY1*b.SELL_FACTOR1)+ (cd.QTY2*SELL_FACTOR2)+cd.QTY3)) pcs ,
		SUM(((cd.QTY1*b.SELL_FACTOR1)+ (cd.QTY2*SELL_FACTOR2)+cd.QTY3)* b.STANDARD_WEIGHT) berat
 from 
 cashmemo_detail cd
 	join batch b on b.sku = cd.sku
	join cashmemo cm on cd.doc_no = cm.doc_no and cd.distributor = cm.distributor
	join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
where visit_type <> '88' and b.PRICE_STRUC ='0001' and b.SELL_FACTOR1 <> '0'
and jw.year = '2018' 
group by cm.town+cm.locality+cm.slocality+cm.pop ,cd.sku, jw.jcno ,cm.DISTRIBUTOR
--- end gross sku
) skugrs on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = skugrs.code_pop and p.DISTRIBUTOR = skugrs.DISTRIBUTOR
join sku  s on s.sku = skugrs.sku 
where p.DISTRIBUTOR ='15227973'
--dlv.COMP3_DESC = 'ASM IC JAKARTA 1'

--'ASM IC JAKARTA 1'
--'ASM IC SURABAYA'
--'ASM IC BANDUNG'
--'ASM IC CENTRAL'
--'ASM IC SOUTHERN SUMATRA'
--'ASM IC NORTHERN SUMATRA'
--'ASM IC EAST'
--'ASM IC KALIMANTAN'
--'ASM IC JAKARTA 2'
--'ASM IC BALI & NUSRA'
