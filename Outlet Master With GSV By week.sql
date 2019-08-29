
select  dlv.COMP2_DESC Region,dlv.COMP3_DESC Area ,p.distributor,dt.NAME ,tdt.LDESC as 'Town Distributor' , dt.WORKING_DATE,
p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'SND outlet Code',p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'Outlet code',replace(p.name,char(9),'') Outlet_name,
 t.LDESC Town, l.ldesc locality, sl.LDESC sub_locality ,replace(p.STREET,char(9),'') Outlet_adress, replace(p.OWNER_NAME,char(9),'') as 'Owner Name',
 replace(p.PHONE_NO,char(9),'') as 'Phone No'  ,replace(p.fax_no,char(9),'') FAX_NO,
 elm.element Element_code,elm.LDESC Outlet_element ,p.SUB_ELEMENT Sub_element_code,elm.Desc_se Outlet_SubElement,
case when p.SUB_ELEMENT in ('C10033',
'C10034','C10026','C10024','C10023','C10025') then 'GT DISTRIBUTOR'
when p.SUB_ELEMENT  in ('C16093','C10028',
'C10660','C71369','C71370','C71371','C71367',
'C71366','C71368','C71372','C71373','C71374') then 'MT DISTRIBUTOR'
else 'Invalid'
end as 'Channel Valid for',
pty.ldesc POP_TYPE ,
atp.LDESC as 'Area Type',replace(p.market_name,char(9),'') as Nama_pasar,p.LATITUDE, p.LONGITUDE,
case when p.LATITUDE >= -12.1718 and p.LATITUDE<=6.88969 and p.LONGITUDE>=93.31644 and p.LONGITUDE<= 141.71813 then 'Exist'
else '' end as 'geotag',
case 
	when p.active = 1 then 'Active'
	when p.active = 0 then 'InActive'
end Store_ActiveClosed,
[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]

from pop p
join AREA_TYPE atp on atp.areatype = p.AREATYPE
	join pop_type pty on pty.poptype = p.poptype
	join town t on t.TOWN =p.TOWN
	join LOCALITY l on l.LOCALITY = p.LOCALITY and l.TOWN =p.TOWN
	join SUB_LOCALITY sl on sl.TOWN = p.TOWN and sl.LOCALITY =p.LOCALITY and sl.SLOCALITY =p.SLOCALITY
	left join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
	) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
	left join (select distinct pt.DISTRIBUTOR+pt.TOWN+pt.LOCALITY+pt.SLOCALITY+pt.POP codele, pt.tax_no from POP_TAX pt where pt.TAX_ID = 01) pt on pt.codele =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
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
	left join DISTRIBUTOR dt on dt.DISTRIBUTOR =p.DISTRIBUTOR
	left join TOWN tdt on tdt.TOWN = dt.TOWN
---- GSV start
left join (
select distinct  distributor,codele, [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52]
from 
(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele, jw.WEEK_NO,
 sum(((cm.net_amount/1.1)-cm.tot_discount)) GSV
from cashmemo cm 
 join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
where cm.VISIT_TYPE = '02' and jw.year = '2019'
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop , jw.WEEK_NO
) x
pivot
    (
      sum(GSV) for WEEK_NO in ( [01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],
     [29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52])
    ) as PVT
)gs on gs.distributor = p.distributor and p.town+p.locality+p.slocality+p.pop = gs.codele
--GSV end
where p.ACTIVE ='1' and 
isnumeric(p.distributor)=1
-- distributor UFS on SERVER HPC
and p.DISTRIBUTOR not in ('15440642','15440643','15441941','15446779','15451130',
'15451701')