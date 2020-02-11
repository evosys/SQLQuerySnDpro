select cm.DISTRIBUTOR,cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP as 'Outlet Code',cm.DSR as 'Salesman',ds.NAME as 'Salesman Name',
MONTH(cm.doc_date) as 'Calendar Month',
cm.DOC_NO as 'Invoice No',((cm.net_amount/1.1)-cm.tot_discount) as 'GSV(Amount)',ct.LDESC as 'Cashmemo Type'
from CASHMEMO cm
left join DSR ds on ds.DISTRIBUTOR = cm.DISTRIBUTOR and ds.DSR = cm.DSR
left join CASHMEMO_TYPE ct on ct.CASHMEMO_TYPE = cm.CASHMEMO_TYPE
where cm.DOC_DATE between '20200101' and getdate()
and cm.VISIT_TYPE = '02' and cm.CASHMEMO_TYPE in ('05','06')
order by MONTH(cm.DOC_DATE)

---
select DISTRIBUTOR,name,t.LDESC as'Town Distributor' from DISTRIBUTOR d
left join TOWN t on t.TOWN = d.TOWN 


----

select cm.distributor ,ct.LDESC as 'Cashmemo Type',count(cm.doc_no) 
from cashmemo cm 
left join CASHMEMO_TYPE ct on ct.CASHMEMO_TYPE = cm.CASHMEMO_TYPE
where cm.VISIT_TYPE = '88' and MONTH(cm.DOC_DATE)  in ('11') and cm.CASHMEMO_TYPE in ('05','06')
group by cm.distributor ,ct.LDESC

-----
