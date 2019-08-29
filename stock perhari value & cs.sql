select y.RSM,y.AREA,y.DISTRIBUTOR,y.NAME,y.WORKING_DATE,wh.LDESC WAREHOUSE,y.sku_type,y.total total_cs ,x.total total_value
from
( select x.rsm,x.area,x.distributor,x.name,x.working_date, x.warehouse,x.sku_type, sum(x.cs) total
from
(select co.COMP2_DESC RSM,co.COMP3_DESC AREA, x.DISTRIBUTOR,d.name,x.WORKING_DATE,x.WAREHOUSE WAREHOUSE,x.SKU,x.sku_type,
floor(x.pcs/x.SELL_FACTOR1) cs, 
floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)  dz  ,
x.pcs - ((floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1)) - (floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)*12)  as  pcis
from 
(select sbd.distributor,sbd.WORKING_DATE,sbd.WAREHOUSE, sbd.SKU ,
	case when sbd.sku_type ='01' then 'good'
	when sbd.SKU_TYPE in ('02','03','04') then 'bad'
	end sku_type
	, 
	((sbd.CLOSING_1*b.SELL_FACTOR1)+ (sbd.CLOSING_2*SELL_FACTOR2)+sbd.CLOSING_3) pcs,b.SELL_FACTOR1
	from STOCK_BATCH_DAILY sbd
	join batch b on b.sku = sbd.sku
	where sbd.WORKING_DATE in ('20171014','20171015') and b.PRICE_STRUC ='0001' and b.SELL_FACTOR1 <> '0'
) x	
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
join DISTRIBUTOR d on d.DISTRIBUTOR = x.DISTRIBUTOR
join WAREHOUSE wh on wh.DISTRIBUTOR = x.DISTRIBUTOR  and wh.WAREHOUSE = x.WAREHOUSE
where x.pcs <> '0') x
group by x.rsm,x.area,x.distributor,x.name,x.working_date, x.warehouse ,x.sku_type
) y
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
) x on x.DISTRIBUTOR = y.DISTRIBUTOR and x.WAREHOUSE = y.WAREHOUSE and x.WORKING_DATE = y.WORKING_DATE
join WAREHOUSE wh on wh.WAREHOUSE = x.WAREHOUSE and wh.DISTRIBUTOR = x.DISTRIBUTOR and x.sku_type = y.sku_type