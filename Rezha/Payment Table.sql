
select dlv.COMP2_DESC Region ,dlv.COMP3_DESC Area, ph.DISTRIBUTOR,dt.NAME ,
 replace(ph.DOC_NO,char(9),'') DOC_NO,
 case when ph.DOCUMENT = 'CI' then 'Credit Note'
 when ph.DOCUMENT = 'DI' then 'Debit Note'
 when ph.DOCUMENT = 'IN' then 'Invoice'
 when ph.DOCUMENT = 'RI' then 'Return Invoice'
 end Document
 ,convert(varchar,ph.DOC_DATE,105) as [Document Date],convert(varchar,ph.DUE_DATE,105) as [DUE Date],replace(ph.ref_doc_no,char(9),'') Ref_doc_no,replace(ph.remarks,char(9),'') remakrs,
 case when  ph.STATUS ='0' then 'ASN Not GR'
 when  ph.STATUS ='1' and ph.document = 'IN' then 'ASN GR'
 when  ph.STATUS ='1' and ph.document <> 'IN' then 'Open'
 when  ph.STATUS ='A' then 'Approve'
 when  ph.STATUS ='C' then 'Cancelled'
 when  ph.STATUS ='E' then 'UnSubmitted'
 when  ph.STATUS ='F' then 'Finalized'
 when  ph.STATUS ='R' then 'Rejected'
 when  ph.STATUS ='S' then 'Submitted'

 end Status

,ph.NET_AMOUNT ,ph.TOTAL_ADJUSTED_AMOUNT 
,paj.ADJUSTED_AMT,convert(varchar,paj.ADJUSTED_DATE,105) as [Adjusted Date],convert(varchar,paj.DATE_ENTRY,105) as [Date Entry]
from PAYMENT_HEAD ph
join DISTRIBUTOR dt on dt.DISTRIBUTOR =ph.DISTRIBUTOR
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
) dlv on ph.distributor = dlv.distributor

left join PAYMENT_ADJ paj on paj.REF_DOC_NO =ph.DOC_NO and paj.DISTRIBUTOR =ph.DISTRIBUTOR

where ph.STATUS not in ('f') and ph.DOCUMENT not in ('PV')

/* 
document
CI = Credit Note
DI = Debit Note
IN = Invoice 
RI = Return Invoice 

status 
0 = ASN Not GR
1 if doc IN = ASN GR else Open
A = Approve
C = Cancelled
E = UnSubmitted
F = Finalized
R = Rejected
S = Submitted

*/