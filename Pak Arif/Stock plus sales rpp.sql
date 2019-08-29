
select co.COMP2_DESC RSM,co.COMP3_DESC AREA, x.DISTRIBUTOR,d.name,x.WORKING_DATE,wh.LDESC WAREHOUSE,wh.warehouse_type ,x.SKU,sk.ldesc NAMA_SKU,x.sell_factor1 as 'UOM',x.sku_type,
floor(x.pcs/x.SELL_FACTOR1) cs, 
floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)  dz  ,
x.pcs - ((floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1)) - (floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)*12)  as  pcs
,y.total
,ft.first_trans,vrp.gsv as 'GSV WK 22 - 34', 
case when ft.first_trans < DATEADD(DAY, -83, '20190825') then 13
when ft.first_trans between DATEADD(DAY, -83, '20190825') and DATEADD(DAY, -77, '20190825') then 12
when ft.first_trans between DATEADD(DAY, -76, '20190825') and DATEADD(DAY, -70, '20190825') then 11
when ft.first_trans between DATEADD(DAY, -69, '20190825') and DATEADD(DAY, -63, '20190825') then 10
when ft.first_trans between DATEADD(DAY, -62, '20190825') and DATEADD(DAY, -56, '20190825') then 9
when ft.first_trans between DATEADD(DAY, -55, '20190825') and DATEADD(DAY, -49, '20190825') then 8
when ft.first_trans between DATEADD(DAY, -48, '20190825') and DATEADD(DAY, -42, '20190825') then 7
when ft.first_trans between DATEADD(DAY, -41, '20190825') and DATEADD(DAY, -35, '20190825') then 6
when ft.first_trans between DATEADD(DAY, -34, '20190825') and DATEADD(DAY, -28, '20190825') then 5
when ft.first_trans between DATEADD(DAY, -27, '20190825') and DATEADD(DAY, -21, '20190825') then 4
when ft.first_trans between DATEADD(DAY, -20, '20190825') and DATEADD(DAY, -14, '20190825') then 3
when ft.first_trans between DATEADD(DAY, -13, '20190825') and DATEADD(DAY, -7 , '20190825') then 2
when ft.first_trans > DATEADD(DAY, -7, '20190825') then 1
end pembagi,
vrp.gsv/
case when ft.first_trans < DATEADD(DAY, -83, '20190825') then 13
when ft.first_trans between DATEADD(DAY, -83, '20190825') and DATEADD(DAY, -77, '20190825') then 12
when ft.first_trans between DATEADD(DAY, -76, '20190825') and DATEADD(DAY, -70, '20190825') then 11
when ft.first_trans between DATEADD(DAY, -69, '20190825') and DATEADD(DAY, -63, '20190825') then 10
when ft.first_trans between DATEADD(DAY, -62, '20190825') and DATEADD(DAY, -56, '20190825') then 9
when ft.first_trans between DATEADD(DAY, -55, '20190825') and DATEADD(DAY, -49, '20190825') then 8
when ft.first_trans between DATEADD(DAY, -48, '20190825') and DATEADD(DAY, -42, '20190825') then 7
when ft.first_trans between DATEADD(DAY, -41, '20190825') and DATEADD(DAY, -35, '20190825') then 6
when ft.first_trans between DATEADD(DAY, -34, '20190825') and DATEADD(DAY, -28, '20190825') then 5
when ft.first_trans between DATEADD(DAY, -27, '20190825') and DATEADD(DAY, -21, '20190825') then 4
when ft.first_trans between DATEADD(DAY, -20, '20190825') and DATEADD(DAY, -14, '20190825') then 3
when ft.first_trans between DATEADD(DAY, -13, '20190825') and DATEADD(DAY, -7 , '20190825') then 2
when ft.first_trans > DATEADD(DAY, -7, '20190825') then 1
end as 'RPP WK 22 - 34'
,qrp.gsv as 'Qty CS',
qrp.gsv/
case when ft.first_trans < DATEADD(DAY, -83, '20190825') then 13
when ft.first_trans between DATEADD(DAY, -83, '20190825') and DATEADD(DAY, -77, '20190825') then 12
when ft.first_trans between DATEADD(DAY, -76, '20190825') and DATEADD(DAY, -70, '20190825') then 11
when ft.first_trans between DATEADD(DAY, -69, '20190825') and DATEADD(DAY, -63, '20190825') then 10
when ft.first_trans between DATEADD(DAY, -62, '20190825') and DATEADD(DAY, -56, '20190825') then 9
when ft.first_trans between DATEADD(DAY, -55, '20190825') and DATEADD(DAY, -49, '20190825') then 8
when ft.first_trans between DATEADD(DAY, -48, '20190825') and DATEADD(DAY, -42, '20190825') then 7
when ft.first_trans between DATEADD(DAY, -41, '20190825') and DATEADD(DAY, -35, '20190825') then 6
when ft.first_trans between DATEADD(DAY, -34, '20190825') and DATEADD(DAY, -28, '20190825') then 5
when ft.first_trans between DATEADD(DAY, -27, '20190825') and DATEADD(DAY, -21, '20190825') then 4
when ft.first_trans between DATEADD(DAY, -20, '20190825') and DATEADD(DAY, -14, '20190825') then 3
when ft.first_trans between DATEADD(DAY, -13, '20190825') and DATEADD(DAY, -7 , '20190825') then 2
when ft.first_trans > DATEADD(DAY, -7, '20190825') then 1
end as 'RPP QTY WK 22 - 34'
from 

(select sbd.distributor,sbd.WORKING_DATE,sbd.WAREHOUSE, sbd.SKU ,
	case when sbd.sku_type ='01' then 'good'
	when sbd.SKU_TYPE in ('02','03','04') then 'bad'
	end sku_type
	, 
	((sbd.CLOSING_1*b.SELL_FACTOR1)+ (sbd.CLOSING_2*SELL_FACTOR2)+sbd.CLOSING_3) pcs,b.SELL_FACTOR1
	from STOCK_BATCH_DAILY sbd
		join batch b on b.sku = sbd.sku
	where sbd.WORKING_DATE in ('20190824','20190825') and b.PRICE_STRUC ='0001' and b.SELL_FACTOR1 <> '0'
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
	where sbd.WORKING_DATE in ('20190824','20190825') and ps.price_struc = '0001'
) fix
where fix.value <> 0
group by fix.DISTRIBUTOR,fix.WORKING_DATE,fix.warehouse,fix.sku,fix.SKU_TYPE
) y on y.distributor = x.distributor and y.working_date = x.working_date and y.warehouse = x.warehouse
and y.sku_type = x.SKU_Type and y.sku = x.sku
--- end
join sku sk on sk.sku = x.sku
left join (
		select cm.DISTRIBUTOR,cd.SKU , min(cm.doc_date) first_trans
		from cashmemo cm
		left join cashmemo_detail cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
		where cm.VISIT_TYPE = '02' 
		group by cm.DISTRIBUTOR,cd.SKU
		) ft on ft.DISTRIBUTOR = x.DISTRIBUTOR and ft.SKU = x.SKU
--- Value WK 22 - 34
left join (
		select cm.DISTRIBUTOR,cd.SKU , sum(cd.AMOUNT) gsv
		from cashmemo cm
		left join cashmemo_detail cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
		where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20190527' and '20190825'
		group by cm.DISTRIBUTOR,cd.SKU
		)  vrp on vrp.DISTRIBUTOR = x.DISTRIBUTOR and vrp.SKU =x.SKU
--- QTY CS WK 22 - 34
left join (
		select cm.DISTRIBUTOR,cd.SKU , sum((cd.QTY1)+((cd.QTY2*s.SELL_FACTOR2)+cd.QTY3)/s.SELL_FACTOR1) gsv
		from cashmemo cm
		left join cashmemo_detail cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
		left join SKU s on s.SKU = cd.SKU
		where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20190527' and '20190825'
		group by cm.DISTRIBUTOR,cd.SKU
		)  qrp on qrp.DISTRIBUTOR = x.DISTRIBUTOR and qrp.SKU =x.SKU

where x.pcs <> '0' and x.SELL_FACTOR1 <> 0
