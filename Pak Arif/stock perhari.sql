--- stock gudang value
select dt.distributor,dt.NAME ,co.COMP2_DESC RSM,co.COMP3_DESC,x.WORKING_DATE,wh.ldesc Warehouse,x.sku_type,x.total
 from distributor dt
join (
select da.distributor, cl.comp2_desc, cl.comp3_desc from distributor_association da
join vw_complevel cl on da.value_comb = cl.compcode
join 
	( 
		select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
		where FIELD_COMB = 'compcode'
		group by DISTRIBUTOR
	) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
where field_comb = 'COMPCODE') co on co.distributor = dt.distributor

left join
(
select fix.distributor,fix.WORKING_DATE,fix.warehouse, fix.SKU_TYPE,SUM(value) total from
(
	select sbd.distributor,sbd.WORKING_DATE,sbd.WAREHOUSE, sbd.SKU ,
	case when sbd.sku_type ='01' then 'good'
	when sbd.SKU_TYPE in ('02','03','04') then 'bad'
	end sku_type
	, 
	((sbd.CLOSING_1*b.SELL_FACTOR1)+ (sbd.CLOSING_2*SELL_FACTOR2)+sbd.CLOSING_3)*ps.PRICE_PURCHASE3  value
	from STOCK_BATCH_DAILY sbd
	join price_structure ps on ps.sku = sbd.sku and sbd.DISTRIBUTOR = ps.DISTRIBUTOR
	join batch b on b.sku = sbd.sku
	where sbd.WORKING_DATE in ('20171014','20171015') and ps.price_struc = '0001'
) fix
group by fix.DISTRIBUTOR,fix.WORKING_DATE,fix.warehouse,fix.SKU_TYPE
) x on x.DISTRIBUTOR =dt.DISTRIBUTOR
join warehouse wh on wh.distributor = dt.distributor and wh.warehouse = x.warehouse

--- stock per sku cs dz pc

select co.COMP2_DESC RSM,co.COMP3_DESC AREA, x.DISTRIBUTOR,d.name,x.WORKING_DATE,wh.LDESC WAREHOUSE,wh.warehouse_type ,x.SKU,sk.ldesc NAMA_SKU,x.sell_factor1 as 'UOM',x.sku_type,
floor(x.pcs/x.SELL_FACTOR1) cs, 
floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)  dz  ,
x.pcs - ((floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1)) - (floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)*12)  as  pcs
,y.total
from 

(select sbd.distributor,sbd.WORKING_DATE,sbd.WAREHOUSE, sbd.SKU ,
	case when sbd.sku_type ='01' then 'good'
	when sbd.SKU_TYPE in ('02','03','04') then 'bad'
	end sku_type
	, 
	((sbd.CLOSING_1*b.SELL_FACTOR1)+ (sbd.CLOSING_2*SELL_FACTOR2)+sbd.CLOSING_3) pcs,b.SELL_FACTOR1
	from STOCK_BATCH_DAILY sbd
		join batch b on b.sku = sbd.sku
	where sbd.WORKING_DATE in ('20190810','20190811') and b.PRICE_STRUC ='0001' and b.SELL_FACTOR1 <> '0'
) x	
--- start comp code
join (
select da.distributor, cl.comp2_desc, cl.comp3_desc from distributor_association da
join vw_complevel cl on da.value_comb = cl.compcode
join 
	( 
		select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
		where FIELD_COMB = 'compcode'
		group by DISTRIBUTOR
	) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
where field_comb = 'COMPCODE') co on co.distributor = x.distributor
---- end comp code
join DISTRIBUTOR d on d.DISTRIBUTOR = x.DISTRIBUTOR
join WAREHOUSE wh on wh.DISTRIBUTOR = x.DISTRIBUTOR  and wh.WAREHOUSE = x.WAREHOUSE
--- start
left join 
(select fix.distributor,fix.WORKING_DATE,fix.warehouse,fix.sku, fix.SKU_TYPE,SUM(value) total from
(
	select sbd.distributor,sbd.WORKING_DATE,sbd.WAREHOUSE, sbd.SKU ,
	case when sbd.sku_type ='01' then 'good'
	when sbd.SKU_TYPE in ('02','03','04') then 'bad'
	end sku_type
	, 
	((sbd.CLOSING_1*b.SELL_FACTOR1)+ (sbd.CLOSING_2*SELL_FACTOR2)+sbd.CLOSING_3)*ps.PRICE_PURCHASE3  value
	from STOCK_BATCH_DAILY sbd
	join price_structure ps on ps.sku = sbd.sku and sbd.DISTRIBUTOR = ps.DISTRIBUTOR
	join batch b on b.sku = sbd.sku
	where sbd.WORKING_DATE in ('20190810','20190811') and ps.price_struc = '0001'
) fix
where fix.value <> 0
group by fix.DISTRIBUTOR,fix.WORKING_DATE,fix.warehouse,fix.sku,fix.SKU_TYPE
) y on y.distributor = x.distributor and y.working_date = x.working_date and y.warehouse = x.warehouse
and y.sku_type = x.SKU_Type and y.sku = x.sku
--- end
join sku sk on sk.sku = x.sku
where x.pcs <> '0' and x.SELL_FACTOR1 <> 0

select distinct DISTRIBUTOR from STOCK_BATCH_DAILY 
where WORKING_DATE in ('20190810','20190811')