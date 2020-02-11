--- total Discount 
select distinct  distributor,DSR,NAME, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor,cm.DSR,d.NAME, jw.WEEK_NO,
 sum(cm.TOT_DISCOUNT) NIV
from cashmemo cm 
 join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
 left join dsr d on d.DISTRIBUTOR = cm.DISTRIBUTOR and d.DSR = cm.DSR
where cm.VISIT_TYPE = '02' and jw.year = '2019'
group by cm.distributor,cm.DSR,d.NAME,jw.WEEK_NO
) x
pivot
    (
      sum(NIV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
     [29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT


--- TPR Uang
select distinct  distributor,DSR,NAME, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor,cm.DSR,d.NAME, jw.WEEK_NO,
 sum(sd.DISCOUNT) NIV
 from CASHMEMO cm
left join SCHEME_DISCOUNT sd on sd.DISTRIBUTOR = cm.DISTRIBUTOR and sd.DOC_NO = cm.DOC_NO 
and sd.DOCUMENT = cm.DOCUMENT and sd.SUB_DOCUMENT = cm.SUB_DOCUMENT
left join pb_setup ps on ps.pbs_mp_code = sd.Mp_Code and sd.Seq_Id =ps.pbs_seqid
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date
left join dsr d on d.DISTRIBUTOR = cm.DISTRIBUTOR and d.DSR = cm.DSR
where ps.PBS_CLAIM_SUB_TYPE = 'OA' and VISIT_TYPE ='02'
and jw.YEAR = '2019'
group by cm.distributor,cm.DSR,d.NAME,jw.WEEK_NO
) x
pivot
    (
      sum(NIV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
     [29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT

--- TPR Barang

select distinct  distributor,DSR,NAME, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor,cm.DSR,d.NAME, jw.WEEK_NO,
 sum(sd.AMOUNT*-1) NIV
 from CASHMEMO cm
left join SCHEME_SKU sd on sd.DISTRIBUTOR = cm.DISTRIBUTOR and sd.DOC_NO = cm.DOC_NO 
and sd.DOCUMENT = cm.DOCUMENT and sd.SUB_DOCUMENT = cm.SUB_DOCUMENT
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date
left join dsr d on d.DISTRIBUTOR = cm.DISTRIBUTOR and d.DSR = cm.DSR
where  VISIT_TYPE ='02'
and jw.YEAR = '2019'
group by cm.distributor,cm.DSR,d.NAME,jw.WEEK_NO
) x
pivot
    (
      sum(NIV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
     [29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
--- AR Outlet 

select distinct  distributor,DSR,NAME, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor,cm.DSR,d.NAME, jw.WEEK_NO,
 sum(cm.received_amt - cm.NET_AMOUNT ) NIV
from cashmemo cm 
 join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
 left join dsr d on d.DISTRIBUTOR = cm.DISTRIBUTOR and d.DSR = cm.DSR
where cm.VISIT_TYPE = '02' and sub_document='01' and jw.year = '2019'
group by cm.distributor,cm.DSR,d.NAME,jw.WEEK_NO
) x
pivot
    (
      sum(NIV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
     [29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
