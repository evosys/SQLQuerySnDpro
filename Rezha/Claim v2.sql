select distinct da.COMP2_DESC as [Region], da.COMP3_DESC as [Area], ch.Distributor, DT.Name, Claim_no, cd.DOC_NO,
case when ch.status = 'S' then 'Submitted' when ch.STATUS = 'E' then 'Waiting for Approval' when ch.STATUS = 'A' then 'Approved'
when ch.status = 'R' then 'Rejected' when ch.STATUS = 'C' then 'Cancelled' 
when ch.STATUS = 'G' and ra.doc_no is not null then 'Good Received'
when ch.STATUS = 'G' and ra.doc_no is null then 'Good Received[NR not Generated]' 
when ch.status = 'F' then 'Finalized' 
When ch.status = 'U' then 'Unsubmitted' end as [Status], 
cd.SKU, cd.CS, cd.DZ, cd.PC, st.LDESC as [SKU Type], w.LDESC as [Warehouse], w.WAREHOUSE_TYPE,
case when ch.CLAIM_TYPE ='DC' then 'Fresh Return' when ch.claim_type='RA' then 'Removal' when ch.Claim_type='MC' then 'Return to ULI' end
, lr.LDESC as [Loss Reason], cd.value as [Claim Net Value],ch.REASON_code as [Reason Code], 
d.INVOICE_NO as [Invoice Number], d.SHIPMENT_NO as [Shipment Number] 
,ch.REF_NUMBER as 'Transaction Number' , ch.LDESC as 'Transaction Description'
from claim_head ch
left join (select distinct Distributor, doc_no, sku, sku_type, warehouse,enterd_qty1 as CS, ENTERD_QTY2 as DZ, ENTERD_QTY3 as PC,
(ENTERED_AMOUNT+ENTERED_DISCOUNT+ENTERED_GST) as value from claim_detail) cd
on ch.DISTRIBUTOR = cd.DISTRIBUTOR and ch.DOC_NO = cd.DOC_NO
join warehouse w on ch.distributor = w.DISTRIBUTOR and cd.WAREHOUSE = w.WAREHOUSE 
join (select distinct distributor, working_Date, Name from distributor where distributor <> 'UID00001')dt on ch.distributor = dt.DISTRIBUTOR
join sku_type st on cd.SKU_TYPE = st.SKU_TYPE
join (select Distributor, value_comb, cl.COMP3, cl.COMP3_DESC, cl.comp2, cl.COMP2_DESC from DISTRIBUTOR_ASSOCIATION d
join vw_COMPLEVEL cl on d.VALUE_COMB = cl.COMPCODE
where field_comb='compcode') da on ch.DISTRIBUTOR = da.DISTRIBUTOR
join LOSS_REASON lr on ch.REASON_CODE = lr.ReasonCode
left join da_head d on ch.REF_DOC_NO = d.doc_no and ch.DISTRIBUTOR = d.DISTRIBUTOR
left join ra_head ra on ch.DISTRIBUTOR = ra.DISTRIBUTOR and ch.doc_no = ra.REF_DOC_NO

