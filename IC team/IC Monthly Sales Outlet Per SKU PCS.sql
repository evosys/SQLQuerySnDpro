

select  p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP Kode_Outlet_Leveredge, p.NAME Outlet_Name,d.distributor,
d.name Nama_Concess , dlv.comp3_desc AREA ,elm.LDESC Outlet_element,elm.Desc_se Outlet_SubElement ,skugrs.SKU,s.ldesc SKU_Name,
[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]

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
	join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
	) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
left join (
---- Perhitungan Gross SKunya
select distinct DISTRIBUTOR, code_pop, sku, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]
from 
(select cm.DISTRIBUTOR, cm.town+cm.locality+cm.slocality+cm.pop code_pop, cd.sku ,jw.jcno ,
sum((cd.QTY1*b.SELL_FACTOR1)+(cd.qty2*12)+(cd.QTY3)) Grs
 from 
 cashmemo_detail cd
join cashmemo cm on cd.doc_no = cm.doc_no and cd.distributor = cm.distributor
 join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
 left join BATCH b on b.SKU = cd.sku
where visit_type <> '88'
and jw.year = '2018' 
group by cm.town+cm.locality+cm.slocality+cm.pop ,cd.sku, jw.jcno ,cm.DISTRIBUTOR) x
pivot
    (
      sum(Grs) for jcno in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
    ) as PVT
--- end gross sku
) skugrs on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = skugrs.code_pop and p.DISTRIBUTOR = skugrs.DISTRIBUTOR
join sku  s on s.sku = skugrs.sku 
where 
p.active = '1'
dlv.COMP3_DESC = --'ASM IC JAKARTA 1'
'ASM IC JAKARTA 1'
--'ASM IC SURABAYA'
--'ASM IC BANDUNG'
--'ASM IC CENTRAL'
--'ASM IC SOUTHERN SUMATRA'
--'ASM IC NORTHERN SUMATRA'
--'ASM IC EAST'
--'ASM IC KALIMANTAN'
--'ASM IC JAKARTA 2'
--'ASM IC BALI & NUSRA'
