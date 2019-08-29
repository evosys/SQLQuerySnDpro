
select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area,t.LDESC Town,
p.distributor,d.NAME, p.town+p.locality+p.slocality+p.pop popcode , replace(p.name,char(9),'') outlet_name ,
case 
when p.active = 1 then 'Active'
when p.active = 0 then 'InActive'
end Store_ActiveClosed,elm.LDESC Outlet_element ,elm.Desc_se Outlet_SubElement,p.LATITUDE, p.LONGITUDE,gs.SKU,s.LDESC as 'SKU Name',
gs.[01],gs.[02],gs.[03],gs.[04],gs.[05],gs.[06],gs.[07],gs.[08],gs.[09],gs.[10],gs.[11],gs.[12],gs.[13],gs.[14],gs.[15],
gs.[16],gs.[17],gs.[18],gs.[19],gs.[20],gs.[21],gs.[22],gs.[23],gs.[24],gs.[25],gs.[26],gs.[27],gs.[28],gs.[29],gs.[30],
gs.[31],gs.[32],gs.[33],gs.[34],gs.[35],gs.[36],gs.[37],gs.[38],gs.[39],gs.[40],gs.[41],gs.[42],gs.[43],gs.[44],gs.[45],
gs.[46],gs.[47],gs.[48],gs.[49],gs.[50],gs.[51],gs.[52],

fcm.[01],fcm.[02],fcm.[03],fcm.[04],fcm.[05],fcm.[06],fcm.[07],fcm.[08],fcm.[09],fcm.[10],fcm.[11],fcm.[12],
fcm.[13],fcm.[14],fcm.[15],fcm.[16],fcm.[17],fcm.[18],fcm.[19],fcm.[20],fcm.[21],fcm.[22],fcm.[23],fcm.[24],
fcm.[25],fcm.[26],fcm.[27],fcm.[28],fcm.[29],fcm.[30],fcm.[31],fcm.[32],fcm.[33],fcm.[34],fcm.[35],fcm.[36],
fcm.[37],fcm.[38],fcm.[39],fcm.[40],fcm.[41],fcm.[42],fcm.[43],fcm.[44],fcm.[45],fcm.[46],fcm.[47],fcm.[48],
fcm.[49],fcm.[50],fcm.[51],fcm.[52]
from pop p
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
---- GSV start
join (select distinct  distributor,codele,SKU, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,cd.SKU,jw.WEEK_NO,
 sum(cd.AMOUNT) GSV
from cashmemo_detail cd 
left join cashmemo cm on cm.DISTRIBUTOR = cd.DISTRIBUTOR and cm.DOC_NO =cd.DOC_NO
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
where cm.VISIT_TYPE = '02' and jw.year = '2019' and  cm.SUB_DOCUMENT in ('02','04')
and cd.sku in ('67069765',
'62072024','67543240',
'67103389','67103391',
'67465881','67438433')and AMOUNT <> 0
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,cd.SKU,jw.WEEK_NO
) x
pivot
    (
      sum(GSV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
)gs on gs.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = gs.codele
--GSV end

--- fcm
left join (
select distinct  distributor,codele, SKU,[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,cd.SKU,jw.WEEK_NO,
 count(cm.DOC_NO) GSV
from cashmemo_detail cd 
left join cashmemo cm on cm.DISTRIBUTOR = cd.DISTRIBUTOR and cm.DOC_NO =cd.DOC_NO
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
where cm.VISIT_TYPE = '02' and jw.year = '2019' and  cm.SUB_DOCUMENT in ('02','04')
and cd.sku in ('67069765',
'62072024','67543240',
'67103389','67103391',
'67465881','67438433')and AMOUNT <> 0
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop,cd.SKU ,jw.WEEK_NO
) x
pivot
    (
      sum(GSV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
)fcm on fcm.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = fcm.codele and gs.SKU = fcm.SKU
--end fcm
left join sku s on s.SKU =gs.SKU
 where  ISNUMERIC(p.distributor) = '1'
