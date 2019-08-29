select co.comp3_desc,y.distributor ,co.name,y.SKU,s.ldesc, y.cs,y.dz,y.pcs,y.inpcs ,a.pc stock_gudang
from
(select x.distributor, sku,
floor(x.pcs/x.SELL_FACTOR1) cs, 
floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)  dz  ,
x.pcs - ((floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1)) - (floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)*12)  as  pcs
,x.pcs inpcs
from 
	(
	select cd.distributor,cd.sku,b.sell_factor1,
		sum (((cd.qty1*b.SELL_FACTOR1)+ (cd.qty2*b.SELL_FACTOR2)+cd.qty3)) pcs
	from cashmemo_detail cd
		join cashmemo cm on cm.distributor = cd.distributor and cm.doc_no = cd.doc_no
		join batch b on b.sku = cd.sku

	where b.PRICE_STRUC ='0001' and b.SELL_FACTOR1 <> '0' and cm.VISIT_TYPE = '02' 
		and cd.doc_date between '20170807' and '20171105'
	group by cd.distributor , cd.sku,b.sell_factor1
	) x 
) y
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
where field_comb = 'COMPCODE') co on co.distributor = y.distributor
join sku s on s.sku = y.sku
join 
(
select y.distributor ,y.sku,y.sku_type,sum(y.pcs) pc
from
(
select sbd.distributor,sbd.WORKING_DATE,sbd.WAREHOUSE, sbd.SKU ,
	case when sbd.sku_type ='01' then 'good'
	when sbd.SKU_TYPE in ('02','03','04') then 'bad'
	end sku_type
	, 
	((sbd.CLOSING_1*b.SELL_FACTOR1)+ (sbd.CLOSING_2*SELL_FACTOR2)+sbd.CLOSING_3) pcs,b.SELL_FACTOR1
	from STOCK_BATCH_DAILY sbd
		join batch b on b.sku = sbd.sku
	where sbd.WORKING_DATE in ('20171105') and b.PRICE_STRUC ='0001' and b.SELL_FACTOR1 <> '0'
) y 
where y.sku_type ='good' and y.DISTRIBUTOR ='15132240'
group by y.DISTRIBUTOR,y.sku,y.sku_type
) A  on a.DISTRIBUTOR = y.DISTRIBUTOR and a.SKU = y.SKU
where y.distributor = '15132240'
--group by co.comp3_desc,y.distributor, co.name
--- test

--select top 100 * from sku