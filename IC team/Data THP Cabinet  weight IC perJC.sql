select 
p.PREV_POP_CODE Kode_Outlet_Scylla, p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP Kode_Outlet_Leveredge, p.NAME Outlet_Name,d.distributor,
d.name Nama_Concess , dlv.comp3_desc AREA , replace(p.market_name,char(9),'') as Nama_pasar,e.ldesc Outlet_Type_Desc ,se.ldesc outlet_sub_type_Desc,
kc.ldesc Banner_Desc, [NULL],[100 LTR],[200 LTR],[201 LTR],[30  LTR],[300 LTR],[301 LTR],[400 LTR],[500 LTR],[600 LTR],[700 LTR],[90 LTR],
jmlas.jml,
[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]
,CONVERT(VARCHAR(11),fcm.fcm,6) First_transaction , CONVERT(VARCHAR(11),p.identify_on,6) Date_create_pop
,p.latitude,p.longitude
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
left join sub_element se on p.sub_element = se.sub_element
left join element e on se.element = e.element
left join key_customer kc on p.key_customer = kc.key_customer
left join (
select  p.company+p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as code,
  count(fa_code) jml from 
pop p
left join asset a on p.company+p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = a.lastlocationcode
left join asset_size asz on a.asset_size = asz.asset_size
group by p.company+p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP 
) jmlas on jmlas.code = p.company+p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
left join (
select code,
[NULL],[100 LTR],[200 LTR],[201 LTR],[30  LTR],[300 LTR],[301 LTR],[400 LTR],[500 LTR],[600 LTR],[700 LTR],[90 LTR]
from 
(select  p.company+p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as code,
 asz.ldesc size , count(fa_code) jml from 
pop p
left join asset a on p.company+p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = a.lastlocationcode
left join asset_size asz on a.asset_size = asz.asset_size
group by p.company+p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP , asz.ldesc
) as ass
pivot
    (
      sum(jml) for size in ([NULL],[100 LTR],[200 LTR],[201 LTR],[30  LTR],[300 LTR], [301 LTR], [400 LTR],	[500 LTR],	[600 LTR],	[700 LTR],	[90 LTR])
	  ) as pvt
	  ) cab on cab.code = p.company+p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
--- start net 
left join (
select distinct  distributor,POPCODE, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]
	from 
(select x.JCNO, x.DISTRIBUTOR,x.POPCODE,SUM(x.berat) total_berat
	from
	(
		select jw.JCNO,cd.distributor,cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP POPCODE, cd.SKU, 
		--sum(((cd.QTY1*b.SELL_FACTOR1)+ (cd.QTY2*SELL_FACTOR2)+cd.QTY3)) pcs ,
		SUM(((cd.QTY1*b.SELL_FACTOR1)+ (cd.QTY2*SELL_FACTOR2)+cd.QTY3)* b.STANDARD_WEIGHT) berat
		from cashmemo_detail cd
			join batch b on b.sku = cd.sku
			join jc_week jw on cd.doc_date between jw.start_date and jw.end_date 
			join cashmemo cm on cm.DOC_NO = cd.DOC_NO and cm.DISTRIBUTOR = cd.DISTRIBUTOR
		where jw.YEAR = '2018'
		and b.PRICE_STRUC ='0001' and b.SELL_FACTOR1 <> '0' and cm.VISIT_TYPE <> '88'
		group by jw.JCNO,cd.distributor,cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP , cd.SKU
	) x
	group by x.JCNO, x.DISTRIBUTOR,x.POPCODE
) y
	pivot
    (
      sum(y.total_berat) for jcno in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
    ) as PVT
	) 
	cmn on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = cmn.POPCODE and cmn.DISTRIBUTOR = p.DISTRIBUTOR
---- end net 
left join (
select cm.town+cm.locality+cm.slocality+cm.pop code_pop , min(cm.doc_date) fcm
 from cashmemo cm
where visit_type <> '88'
group by cm.town+cm.locality+cm.slocality+cm.pop
) fcm on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = fcm.code_pop
where p.DISTRIBUTOR <> 'UID00001'
--and p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP in ( '150601200100199241','160610201100198967','357302000200108608')


