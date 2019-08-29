
select p.distributor, p.town+p.locality+p.slocality+p.pop popcode , replace(p.name,char(9),'') outlet_name ,
case 
when p.active = 1 then 'Active'
when p.active = 0 then 'InActive'
end Store_ActiveClosed,
gs.pjp, ph.ldesc pjp_name,
[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
,rp.RPP
from pop p

---- GSV start
left join (
select distinct  distributor,codele,pjp, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele, cm.pjp,jw.WEEK_NO,
 sum(cm.net_amount) NIV
from cashmemo cm 
 join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
where cm.VISIT_TYPE = '02' and jw.year = '2017'
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop , cm.pjp,jw.WEEK_NO
) x
pivot
    (
      sum(NIV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
     [29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
)gs on gs.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = gs.codele
--GSV end
join pjp_head ph on ph.pjp = gs.pjp and ph.distributor = gs.distributor
-- test rpp
join (
select pmb.DISTRIBUTOR,cmt.codepop,
(cmt.sales/(43 - pmb.Status)) RPP
from 
 (
select cm.DISTRIBUTOR, cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP codepop , SUM(cm.NET_AMOUNT) sales from cashmemo cm
where cm.visit_type = '02' and year(cm.DOC_DATE) = '2017'
group by cm.DISTRIBUTOR, cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP ) 
cmt 
---- join untk membuat pembaginya
join (
select p.DISTRIBUTOR, p.town+p.locality+p.slocality+p.pop codepop,jw.week_no,jw.year,
(case when jw.year = year(getdate()) then jw.week_no 
when jw.year <> year(getdate()) then '1' end )as [Status]
 from pop p
join jc_week jw on p.identify_on between jw.start_date and jw.end_date)
 pmb  on cmt.codepop = pmb.codepop and cmt.DISTRIBUTOR = pmb.DISTRIBUTOR
 ) rp on rp.DISTRIBUTOR =p.DISTRIBUTOR and rp.codepop = p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP

