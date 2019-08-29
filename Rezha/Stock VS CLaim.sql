---- Stock Distribuutor VS Claim 
select co.COMP2_DESC RSM,co.COMP3_DESC AREA, x.DISTRIBUTOR,d.name,x.WORKING_DATE,wh.LDESC WAREHOUSE,wh.warehouse_type ,
x.SKU,sk.ldesc NAMA_SKU,x.sku_type,
floor(x.pcs/x.SELL_FACTOR1) cs, 
floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)  dz  ,
x.pcs - ((floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1)) - (floor((x.pcs-(floor(x.pcs/x.SELL_FACTOR1)* x.SELL_FACTOR1))/12)*12)  as  pcs,
x.pcs*pc.PRICE_PURCHASE3 as 'Stock Value'

,z.ENTERD_QTY1 QTY_CS_CLAIM ,z.ENTERD_QTY2 QTY_DZ_CLAIM ,z.ENTERD_QTY3 QTY_PCS_CLAIM , 
case 
when z.STATUS = 'U' then 'Unsubmit'
when z.STATUS = 'S' then 'Submit'
when z.STATUS = 'E' then 'Pending Approval'
when z.STATUS = 'A' then 'Approval'
when z.STATUS = 'G' then 'Good Received'
when z.STATUS = 'F' then 'Finalize'

end STATUS

,z.DOC_NO ,z.REF_DOC_NO,z.INVOICE_NO as [Invoice Number], z.SHIPMENT_NO as [Shipment Number],Claim_no,z.value as [Claim Net Value],
z.DOC_DATE, z.CLAIM_TYPE,z.REASON_code as [Reason Code] , z.LDESC as [Loss Reason],z.NET_AMOUNT,z.ADJ_AMOUNT,
(z.[manual value]-(z.[manual value] * case when dfd.VALUE_COMB = '0.2' then 0.002 when dfd.value_comb = '0.3' then 0.003 else 0.7 end  )+ (z.[manual value]*0.1)) as 'manual cal' 

from 

(select sbd.distributor,sbd.WORKING_DATE,sbd.WAREHOUSE, sbd.SKU ,
	case when sbd.sku_type ='01' then 'good'
	when sbd.SKU_TYPE in ('02','03','04') then 'bad'
	end sku_type
	, 
	((sbd.CLOSING_1*b.SELL_FACTOR1)+ (sbd.CLOSING_2*SELL_FACTOR2)+sbd.CLOSING_3) pcs,b.SELL_FACTOR1
	from STOCK_BATCH_DAILY sbd
		join batch b on b.sku = sbd.sku
	where sbd.WORKING_DATE in ('20190420','20190421') and b.PRICE_STRUC ='0001' and b.SELL_FACTOR1 <> '0'
) x	
left join (
SELECT distributor, SKU,PRICE_STRUC,EFFECTIVE_DATE,
		LEAD(EFFECTIVE_DATE,1,'99991231') OVER (PARTITION BY distributor,SKU ORDER BY EFFECTIVE_DATE asc,PRICE_STRUC desc) AS END_DATE,
		PRICE_PURCHASE1,PRICE_PURCHASE2,PRICE_PURCHASE3
	FROM PRICE_STRUCTURE) pc on pc.SKU =x.SKU and pc.DISTRIBUTOR = x.DISTRIBUTOR and x.WORKING_DATE between pc.EFFECTIVE_DATE and pc.END_DATE

left join (	select * from DISTRIBUTOR_ASSOCIATION
	where FIELD_COMB ='DA_FIXED_DISCOUNT') dfd on dfd.DISTRIBUTOR = x.DISTRIBUTOR
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
join sku sk on sk.sku = x.sku
--start
left join (
select ch.DISTRIBUTOR, ch.DOC_NO,ch.REF_DOC_NO,d.INVOICE_NO,Claim_no,d.SHIPMENT_NO ,ch.DOC_DATE ,ch.CLAIM_TYPE,ch.STATUS 
,cd.SKU , cd.ENTERD_QTY1,cd.ENTERD_QTY2 ,cd.ENTERD_QTY3,(ENTERED_AMOUNT+ENTERED_DISCOUNT+ENTERED_GST) as value,ch.REASON_CODE,lr.LDESC
,ch.NET_AMOUNT,ch.ADJ_AMOUNT
,(cd.ENTERD_QTY1*pc.PRICE_PURCHASE1)+(cd.ENTERD_QTY2*pc.PRICE_PURCHASE2)+(cd.ENTERD_QTY3*pc.PRICE_PURCHASE3) as 'manual value'
,ch.REF_DATE,ch.DATE_ENTRY,ch.DATE_FROM,ch.DATE_TO
from CLAIM_HEAD ch
left join LOSS_REASON lr on ch.REASON_CODE = lr.ReasonCode
left join da_head d on ch.REF_DOC_NO = d.doc_no and ch.DISTRIBUTOR = d.DISTRIBUTOR
left join CLAIM_DETAIL cd on cd.DISTRIBUTOR = ch.DISTRIBUTOR and ch.DOC_NO = cd.DOC_NO and ch.CLAIM_TYPE = cd.CLAIM_TYPE
left join (
SELECT distributor, SKU,PRICE_STRUC,EFFECTIVE_DATE,
		LEAD(EFFECTIVE_DATE,1,'99991231') OVER (PARTITION BY distributor,SKU ORDER BY EFFECTIVE_DATE asc,PRICE_STRUC desc) AS END_DATE,
		PRICE_PURCHASE1,PRICE_PURCHASE2,PRICE_PURCHASE3
	FROM PRICE_STRUCTURE) pc on pc.SKU =cd.SKU and pc.DISTRIBUTOR = cd.DISTRIBUTOR and ch.DOC_DATE between pc.EFFECTIVE_DATE and pc.END_DATE

where ch.CLAIM_TYPE	in('DC','MC','RA') ) z on z.DISTRIBUTOR = x.DISTRIBUTOR and z.SKU =x.SKU
where x.pcs <> '0' and x.SELL_FACTOR1 <> 0 and wh.WAREHOUSE_TYPE ='c'


--select ch.DISTRIBUTOR, ch.DOC_NO , ch.CLAIM_TYPE,ch.STATUS 
--,cd.SKU , cd.ENTERD_QTY1,cd.ENTERD_QTY2 ,cd.ENTERD_QTY3
--from CLAIM_HEAD ch
--join CLAIM_DETAIL cd on cd.DISTRIBUTOR = ch.DISTRIBUTOR and ch.DOC_NO = cd.DOC_NO and ch.CLAIM_TYPE = cd.CLAIM_TYPE
--where ch.CLAIM_TYPE	in('DC','MC','RA')

--select  * from CLAIM_DETAIL where CLAIM_TYPE	in('DC','MC','RA')
--select * from CLAIM_HEAD ch where ch.CLAIM_TYPE	in('DC','MC','RA')
--select top 100 * from Claim_Type
----DC MC RA
