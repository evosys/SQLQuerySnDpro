
select co.COMP3_DESC,A.distributor,co.NAME ,A.SKU,s.LDESC NAMA_SKU,a.sku_type,a.pc,b.SKU,b.sku_type,b.cs,b.dz,b.pcs
from
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
	where sbd.WORKING_DATE in ('20171107') and b.PRICE_STRUC ='0001' and b.SELL_FACTOR1 <> '0'
) y
group by y.DISTRIBUTOR,y.sku,y.sku_type
) A 
left Join 
(
select x.distributor, sku,
	case when x.pcs >= 0 then 'good'
	when x.pcs < 0 then 'bad'
	end sku_type
,
floor(x.pcs/x.SELL_FACTOR1) cs, 
floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)  dz  ,
x.pcs - ((floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1)) - (floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)*12)  as  pcs
from 
	(
	select cd.distributor,cd.sku,b.sell_factor1,
		sum (((cd.qty1*b.SELL_FACTOR1)+ (cd.qty2*b.SELL_FACTOR2)+cd.qty3)) pcs
	from cashmemo_detail cd
		join cashmemo cm on cm.distributor = cd.distributor and cm.doc_no = cd.doc_no
		join batch b on b.sku = cd.sku

	where b.PRICE_STRUC ='0001' and b.SELL_FACTOR1 <> '0' and cm.VISIT_TYPE = '02' 
		and cd.doc_date between '20170808' and '20171106'
	group by cd.distributor , cd.sku,b.sell_factor1
	) x 
) B on A.SKU = b.SKU and a.DISTRIBUTOR = B.DISTRIBUTOR and a.sku_type = b.sku_type

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
where field_comb = 'COMPCODE') co on co.distributor = A.distributor
join sku s on s.SKU =a.SKU