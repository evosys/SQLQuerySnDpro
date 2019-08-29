
select da.distributor,d.NAME,da.DOC_NO,da.DOC_DATE,da.COMMENTS,da.USER_ENTRY,da.INVOICE_NO,td.sku,s.LDESC,
	td.QTY1,td.QTY2,td.QTY3,td.LOSS_QTY1,td.LOSS_QTY2,td.LOSS_QTY3,td.AMOUNT,td.DISCOUNT,td.GST 
from DA_HEAD da
	join TRANS_DETAIL td on td.DISTRIBUTOR =da.DISTRIBUTOR and td.DOC_NO =da.DOC_NO
	join DISTRIBUTOR  d on d.DISTRIBUTOR = da.DISTRIBUTOR
	join sku s on s.SKU = td.SKU
where da.INVOICE_NO is null
	and YEAR(da.doc_date) = '2018'
	and da.DISTRIBUTOR in ('15280990','15129867')