

select distributor,[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from
(

	select distinct cd.DISTRIBUTOR,sum(cd.amount+cd.scheme_skushare) as 'Gross',jc.week_no
	from cashmemo_detail cd 
join (select distributor,doc_no,town,locality,slocality,pop,net_amount,VISIT_TYPE,sub_document,dsr from cashmemo) c on cd.distributor=c.distributor and cd.doc_no=c.doc_no
join jC_week jc on cd.doc_date between jc.start_date and jc.end_date

where c.visit_type='02' and jc.year='2017'


group by cd.DISTRIBUTOR,jc.week_no


) d
pivot
(
  max(gross)
  for week_no in ([01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
  [29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
	
)piv;


