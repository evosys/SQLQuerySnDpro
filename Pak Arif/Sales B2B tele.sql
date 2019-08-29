select cm.DISTRIBUTOR,cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP as 'Outlet Code',cm.DSR as 'Salesman',ds.NAME as 'Salesman Name',
MONTH(cm.doc_date) as 'Calendar Month',
cm.DOC_NO as 'Invoice No',((cm.net_amount/1.1)-cm.tot_discount) as 'GSV(Amount)',ct.LDESC as 'Cashmemo Type'
from CASHMEMO cm
left join DSR ds on ds.DISTRIBUTOR = cm.DISTRIBUTOR and ds.DSR = cm.DSR
left join CASHMEMO_TYPE ct on ct.CASHMEMO_TYPE = cm.CASHMEMO_TYPE
where MONTH(cm.DOC_DATE)  in ('08') and YEAR(cm.DOC_DATE) ='2019'
and cm.VISIT_TYPE = '02' and cm.CASHMEMO_TYPE in ('05','06')
order by MONTH(cm.DOC_DATE)

---
select DISTRIBUTOR,name,t.LDESC as'Town Distributor' from DISTRIBUTOR d
left join TOWN t on t.TOWN = d.TOWN 