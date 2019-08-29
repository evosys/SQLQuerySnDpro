
select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area,t.LDESC Town,
p.distributor,d.NAME, p.town+p.locality+p.slocality+p.pop popcode , replace(p.name,char(9),'') outlet_name ,
case 
when p.active = 1 then 'Active'
when p.active = 0 then 'InActive'
end Store_ActiveClosed,elm.LDESC Outlet_element ,elm.Desc_se Outlet_SubElement,p.LATITUDE, p.LONGITUDE,
gs.[01],gs.[02],gs.[03],gs.[04],gs.[05],gs.[06],gs.[07],gs.[08],gs.[09],gs.[10],gs.[11],gs.[12],gs.[13],gs.[14],gs.[15],
gs.[16],gs.[17],gs.[18],gs.[19],gs.[20],gs.[21],gs.[22],gs.[23],gs.[24],gs.[25],gs.[26],gs.[27],gs.[28],gs.[29],gs.[30],
gs.[31],gs.[32],gs.[33],gs.[34],gs.[35],gs.[36],gs.[37],gs.[38],gs.[39],gs.[40],gs.[41],gs.[42],gs.[43],gs.[44],gs.[45],
gs.[46],gs.[47],gs.[48],gs.[49],gs.[50],gs.[51],gs.[52],
rp.RPP,
fcm.[01],fcm.[02],fcm.[03],fcm.[04],fcm.[05],fcm.[06],fcm.[07],fcm.[08],fcm.[09],fcm.[10],fcm.[11],fcm.[12],
fcm.[13],fcm.[14],fcm.[15],fcm.[16],fcm.[17],fcm.[18],fcm.[19],fcm.[20],fcm.[21],fcm.[22],fcm.[23],fcm.[24],
fcm.[25],fcm.[26],fcm.[27],fcm.[28],fcm.[29],fcm.[30],fcm.[31],fcm.[32],fcm.[33],fcm.[34],fcm.[35],fcm.[36],
fcm.[37],fcm.[38],fcm.[39],fcm.[40],fcm.[41],fcm.[42],fcm.[43],fcm.[44],fcm.[45],fcm.[46],fcm.[47],fcm.[48],
fcm.[49],fcm.[50],fcm.[51],fcm.[52]
,qcs.[01],qcs.[02],qcs.[03],qcs.[04],qcs.[05],qcs.[06],qcs.[07],qcs.[08],qcs.[09],qcs.[10],qcs.[11],qcs.[12],qcs.[13],
qcs.[14],qcs.[15],qcs.[16],qcs.[17],qcs.[18],qcs.[19],qcs.[20],qcs.[21],qcs.[22],qcs.[23],qcs.[24],qcs.[25],qcs.[26],
qcs.[27],qcs.[28],qcs.[29],qcs.[30],qcs.[31],qcs.[32],qcs.[33],qcs.[34],qcs.[35],qcs.[36],qcs.[37],qcs.[38],qcs.[39],
qcs.[40],qcs.[41],qcs.[42],qcs.[43],qcs.[44],qcs.[45],qcs.[46],qcs.[47],qcs.[48],qcs.[49],qcs.[50],qcs.[51],qcs.[52]
, [SR  2ND DEALER],
[SLD MIXED HCF],[SLD CORPORATE],[SLD MIXED PC],[SR  MIXED],[SLD HC FOODS],[TELE SALES],[Fast Team],[SR  MT],
[SHOP SALES],[CORPORATE MONTERADO],[SR TT BEAUTY],[SR BUAVITA],[SLD SERBU/SUT],[SLD PC],[SPECIAL TEAM]
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
left join (
select distinct  distributor,codele, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,jw.WEEK_NO,
 sum(((cm.net_amount/1.1)-cm.tot_discount)) GSV
from cashmemo cm 
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
where cm.VISIT_TYPE = '02' and jw.year = '2018'
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,jw.WEEK_NO
) x
pivot
    (
      sum(GSV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
)gs on gs.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = gs.codele
--GSV end

-- test rpp
left join (
select pmb.DISTRIBUTOR,cmt.codepop,
(cmt.sales/(53 - pmb.Status)) RPP
from 
 (
select cm.DISTRIBUTOR, cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP codepop , SUM(((cm.net_amount/1.1)-cm.tot_discount)) sales from cashmemo cm
where cm.visit_type = '02' and year(cm.DOC_DATE) = '2018'
group by cm.DISTRIBUTOR, cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP ) 
cmt 
---- join untk membuat pembaginya
left join (
select p.DISTRIBUTOR, p.town+p.locality+p.slocality+p.pop codepop,jw.WEEK_NO,jw.year,
(case when jw.year = year(getdate()) then jw.WEEK_NO 
when jw.year <> year(getdate()) then '1' end )as [Status]
 from pop p
join jc_week jw on p.identify_on between jw.start_date and jw.end_date)
 pmb  on cmt.codepop = pmb.codepop and cmt.DISTRIBUTOR = pmb.DISTRIBUTOR
 ) rp on rp.DISTRIBUTOR =p.DISTRIBUTOR and rp.codepop = p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
--- fcm
left join (
select distinct  distributor,codele, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,jw.WEEK_NO,
 count(cm.DOC_NO) GSV
from cashmemo cm 
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
where cm.VISIT_TYPE = '02' and jw.year = '2018'
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,jw.WEEK_NO
) x
pivot
    (
      sum(GSV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
)fcm on fcm.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = fcm.codele
--end fcm
left join (
select distinct  codele, [SR  2ND DEALER],
[SLD MIXED HCF],[SLD CORPORATE],[SLD MIXED PC],[SR  MIXED],[SLD HC FOODS],[TELE SALES],[Fast Team],[SR  MT],
[SHOP SALES],[CORPORATE MONTERADO],[SR TT BEAUTY],[SR BUAVITA],[SLD SERBU/SUT],[SLD PC],[SPECIAL TEAM]
from 
(
select sp.DISTRIBUTOR+sp.TOWN+sp.LOCALITY+sp.SLOCALITY+sp.POP codele,sp.SELL_CATEGORY,sc.LDESC from SECTION_POP sp
left join SELLING_CATEGORY sc on sc.SELL_CATEGORY =sp.SELL_CATEGORY and sc.DISTRIBUTOR = sp.DISTRIBUTOR
left join PJP_HEAD ph on ph.DISTRIBUTOR =sp.DISTRIBUTOR and sp.PJP = ph.PJP
left join DSR d on d.DSR = ph.DSR and d.DISTRIBUTOR =sp.DISTRIBUTOR 
where ph.ACTIVE = '1' and d.STATUS ='y'
) x
pivot
    (
      count(SELL_CATEGORY) for LDESC in ([SR  2ND DEALER],
[SLD MIXED HCF],[SLD CORPORATE],[SLD MIXED PC],[SR  MIXED],[SLD HC FOODS],[TELE SALES],[Fast Team],[SR  MT],
[SHOP SALES],[CORPORATE MONTERADO],[SR TT BEAUTY],[SR BUAVITA],[SLD SERBU/SUT],[SLD PC],[SPECIAL TEAM])
    ) as PVT
) slkt on slkt.codele = p.distributor+p.town+p.locality+p.slocality+p.pop
left join (
select distinct  distributor,codele, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,jw.WEEK_NO,
 SUM(cd.QTY1+(((cd.qty2*12)+cd.QTY3)/b.SELL_FACTOR1)) GSV
from cashmemo cm 
left join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
left join CASHMEMO_DETAIL cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
left join BATCH b on b.SKU = cd.sku
where cm.VISIT_TYPE = '02' and jw.year = '2018'
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,jw.WEEK_NO
) x
pivot
    (
      sum(GSV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
) qcs on qcs.DISTRIBUTOR+qcs.codele = p.distributor+p.town+p.locality+p.slocality+p.pop
 where p.ACTIVE = '1' and ISNUMERIC(p.distributor) = '1'