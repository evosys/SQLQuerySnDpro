select distributor,[20170821],[20170822],[20170823],[20170824],[20170825],[20170826],[20170827]
from
(
	select distinct cd.DISTRIBUTOR,sum(cd.amount+cd.scheme_skushare) as 'Gross',cd.doc_date
	from cashmemo_detail cd 
join (select distributor,doc_no,town,locality,slocality,pop,net_amount,VISIT_TYPE,sub_document,dsr from cashmemo
) c on cd.distributor=c.distributor and cd.doc_no=c.doc_no
join jC_week jc on cd.doc_date between jc.start_date and jc.end_date
where c.visit_type='02' and jc.year='2017' and jc.week_no ='34'
group by cd.DISTRIBUTOR,cd.doc_date

) d
pivot
(
  max(gross)
  for doc_date in ([20170821],[20170822],[20170823],[20170824],[20170825],[20170826],[20170827])
	
)piv;


