
select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area,t.LDESC Town,
p.distributor,d.NAME, p.town+p.locality+p.slocality+p.pop popcode , replace(p.name,char(9),'') outlet_name ,
case 
when p.active = 1 then 'Active'
when p.active = 0 then 'InActive'
end Store_ActiveClosed,elm.LDESC Outlet_element ,elm.Desc_se Outlet_SubElement,p.LATITUDE, p.LONGITUDE,
-- service value gsv
gs.[01],gs.[02],gs.[03],gs.[04],gs.[05],gs.[06],gs.[07],gs.[08],gs.[09],gs.[10],gs.[11],gs.[12],gs.[13],gs.[14],gs.[15],
gs.[16],gs.[17],gs.[18],gs.[19],gs.[20],gs.[21],gs.[22],gs.[23],gs.[24],gs.[25],gs.[26],gs.[27],gs.[28],gs.[29],gs.[30],
gs.[31],gs.[32],gs.[33],gs.[34],gs.[35],gs.[36],gs.[37],gs.[38],gs.[39],gs.[40],gs.[41],gs.[42],gs.[43],gs.[44],gs.[45],
gs.[46],gs.[47],gs.[48],gs.[49],gs.[50],gs.[51],gs.[52],
-- original order qty
fcm.[01],fcm.[02],fcm.[03],fcm.[04],fcm.[05],fcm.[06],fcm.[07],fcm.[08],fcm.[09],fcm.[10],fcm.[11],fcm.[12],
fcm.[13],fcm.[14],fcm.[15],fcm.[16],fcm.[17],fcm.[18],fcm.[19],fcm.[20],fcm.[21],fcm.[22],fcm.[23],fcm.[24],
fcm.[25],fcm.[26],fcm.[27],fcm.[28],fcm.[29],fcm.[30],fcm.[31],fcm.[32],fcm.[33],fcm.[34],fcm.[35],fcm.[36],
fcm.[37],fcm.[38],fcm.[39],fcm.[40],fcm.[41],fcm.[42],fcm.[43],fcm.[44],fcm.[45],fcm.[46],fcm.[47],fcm.[48],
fcm.[49],fcm.[50],fcm.[51],fcm.[52]
--service order qty
,qcs.[01],qcs.[02],qcs.[03],qcs.[04],qcs.[05],qcs.[06],qcs.[07],qcs.[08],qcs.[09],qcs.[10],qcs.[11],qcs.[12],qcs.[13],
qcs.[14],qcs.[15],qcs.[16],qcs.[17],qcs.[18],qcs.[19],qcs.[20],qcs.[21],qcs.[22],qcs.[23],qcs.[24],qcs.[25],qcs.[26],
qcs.[27],qcs.[28],qcs.[29],qcs.[30],qcs.[31],qcs.[32],qcs.[33],qcs.[34],qcs.[35],qcs.[36],qcs.[37],qcs.[38],qcs.[39],
qcs.[40],qcs.[41],qcs.[42],qcs.[43],qcs.[44],qcs.[45],qcs.[46],qcs.[47],qcs.[48],qcs.[49],qcs.[50],qcs.[51],qcs.[52]
--original line
,lno.[01],lno.[02],lno.[03],lno.[04],lno.[05],lno.[06],lno.[07],lno.[08],lno.[09],lno.[10],lno.[11],lno.[12],lno.[13],
lno.[14],lno.[15],lno.[16],lno.[17],lno.[18],lno.[19],lno.[20],lno.[21],lno.[22],lno.[23],lno.[24],lno.[25],lno.[26],
lno.[27],lno.[28],lno.[29],lno.[30],lno.[31],lno.[32],lno.[33],lno.[34],lno.[35],lno.[36],lno.[37],lno.[38],lno.[39],
lno.[40],lno.[41],lno.[42],lno.[43],lno.[44],lno.[45],lno.[46],lno.[47],lno.[48],lno.[49],lno.[50],lno.[51],lno.[52]
--service line
,lns.[01],lns.[02],lns.[03],lns.[04],lns.[05],lns.[06],lns.[07],lns.[08],lns.[09],lns.[10],lns.[11],lns.[12],lns.[13],
lns.[14],lns.[15],lns.[16],lns.[17],lns.[18],lns.[19],lns.[20],lns.[21],lns.[22],lns.[23],lns.[24],lns.[25],lns.[26],
lns.[27],lns.[28],lns.[29],lns.[30],lns.[31],lns.[32],lns.[33],lns.[34],lns.[35],lns.[36],lns.[37],lns.[38],lns.[39],
lns.[40],lns.[41],lns.[42],lns.[43],lns.[44],lns.[45],lns.[46],lns.[47],lns.[48],lns.[49],lns.[50],lns.[51],lns.[52]

from 
---- GSV start
(
select distinct  distributor,codele, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,jw.WEEK_NO,
 sum(((cm.net_amount/1.1)-cm.tot_discount)) GSV
from cashmemo cm 
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
where cm.VISIT_TYPE = '02' and jw.year = '2019' and cm.CASHMEMO_TYPE in ('05','06')
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,jw.WEEK_NO
) x
pivot
    (
      sum(GSV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
)gs 
--GSV end


--- fcm original order pcs
left join (
select distinct  distributor,codele, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,jw.WEEK_NO,
 SUM((cd.REF_QTY1*b.SELL_FACTOR1)+(cd.REF_QTY2*12)+cd.REF_QTY3 ) GSV
from cashmemo cm 
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
left join CASHMEMO_DETAIL cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
left join BATCH b on b.SKU = cd.sku
where cm.VISIT_TYPE = '02' and jw.year = '2019' and cm.CASHMEMO_TYPE in ('05','06')
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,jw.WEEK_NO
) x
pivot
    (
      sum(GSV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
)fcm on fcm.distributor = gs.distributor and GS.codele = fcm.codele
--end fcm
-- service order qty pcs
left join (
select distinct  distributor,codele, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,jw.WEEK_NO,
 SUM((cd.QTY1*b.SELL_FACTOR1)+(cd.qty2*12)+cd.QTY3 ) GSV
from cashmemo cm 
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
left join CASHMEMO_DETAIL cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
left join BATCH b on b.SKU = cd.sku
where cm.VISIT_TYPE = '02' and jw.year = '2019' and cm.CASHMEMO_TYPE in ('05','06')
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,jw.WEEK_NO
) x
pivot
    (
      sum(GSV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
) qcs on qcs.DISTRIBUTOR+qcs.codele = GS.DISTRIBUTOR+gs.codele
-- end service qty pcs
--- line original
left join (select distinct  distributor,codele, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select x.DISTRIBUTOR,x.codele,jw.WEEK_NO,COUNT(x.SKU) line
from (
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,cm.DOC_DATE,cd.SKU,
 SUM((cd.QTY1*b.SELL_FACTOR1)+(cd.qty2*12)+cd.QTY3 ) GSV
from cashmemo cm 
left join CASHMEMO_DETAIL cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
left join BATCH b on b.SKU = cd.sku
where cm.VISIT_TYPE = '02' and YEAR(cm.DOC_DATE) = '2019' and  cm.CASHMEMO_TYPE in ('05','06')
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,cm.DOC_DATE,cd.SKU
) x 
left join jc_week jw on x.doc_date between jw.start_date and jw.end_date
group by  x.DISTRIBUTOR,x.codele,jw.WEEK_NO
) x
pivot
    (
      sum(x.line) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
) lno on lno.DISTRIBUTOR+lno.codele = GS.DISTRIBUTOR+gs.codele
--- line original end

--- line service
left join (select distinct  distributor,codele, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select x.DISTRIBUTOR,x.codele,jw.WEEK_NO,COUNT(x.SKU) line
from (
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,cm.DOC_DATE,cd.SKU,
 SUM((cd.QTY1*b.SELL_FACTOR1)+(cd.qty2*12)+cd.QTY3 ) GSV
from cashmemo cm 
left join CASHMEMO_DETAIL cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
left join BATCH b on b.SKU = cd.sku
where cm.VISIT_TYPE = '02' and YEAR(cm.DOC_DATE) = '2019' and  cm.CASHMEMO_TYPE in ('05','06')
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,cm.DOC_DATE,cd.SKU
) x 
left join jc_week jw on x.doc_date between jw.start_date and jw.end_date
where x.GSV <> 0
group by  x.DISTRIBUTOR,x.codele,jw.WEEK_NO
) x
pivot
    (
      sum(x.line) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
) lns on lns.DISTRIBUTOR+lns.codele = GS.DISTRIBUTOR+gs.codele

--- end line service
left join pop p on gs.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = gs.codele
left join distributor d on d.DISTRIBUTOR = p.DISTRIBUTOR
 left join TOWN t on d.TOWN =t.TOWN 
 join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
	) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
left join (
		select da.DISTRIBUTOR,da.VALUE_COMB,clvl.comp2_desc ,clvl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
		join
		vw_complevel clvl on da.VALUE_COMB= clvl.COMPCODE 
		join 
		( 
			select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
			where FIELD_COMB = 'compcode'
			group by DISTRIBUTOR
		) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
	) dlv on p.distributor = dlv.distributor


/* where p.ACTIVE = '1' and ISNUMERIC(p.distributor) = '1'
and p.DISTRIBUTOR not in ('15440642','15440643','15441941','15446779','15451130',
'15451701') and p.distributor in (
'15061942','15086082','15094446','15132240','15132762',
'15139169','15141333','15146248','15162280','15173325',
'15173721','15197007','15227796','15251536','15261370',
'15315705','15390663','94418001','94432001','94458001',
'94801001','94803001','94809001','94810001','94812001',
'15164231','15072228','91009001')
*/