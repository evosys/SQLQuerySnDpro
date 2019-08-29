select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area ,p.distributor,dt.NAME ,tdt.LDESC as 'Town Distributor' , '' as 'DT Status' ,
p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'SND outlet Code',p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'Outlet code',replace(p.name,char(9),'') Outlet_name,
 t.LDESC Town, l.ldesc locality, sl.LDESC sub_locality ,replace(p.STREET,char(9),'') Outlet_adress, replace(p.OWNER_NAME,char(9),'') as 'Owner Name',
 replace(p.PHONE_NO,char(9),'') as 'Phone No'  ,replace(p.fax_no,char(9),'') FAX_NO,
case 
	when p.active = 1 then 'Active'
	when p.active = 0 then 'InActive'
end Store_ActiveClosed,ftcm.first_trans as 'First Trans(FT)',jw.YEAR as 'FT Year',jw.JCNO as 'FT JC', jw.WEEK_NO as 'FT Week',
fcm.last_trans,
case 
	when fcm.last_trans >= DATEADD(DAY, -30, GETDATE()) then 'Yes'
	else ''
end LT_month_1,
case 
	when fcm.last_trans >= DATEADD(DAY, -90, GETDATE()) then 'Yes'
	else ''
end LT_month_3,
--case 
--	when fcm.last_trans <= DATEADD(DAY, -90, GETDATE()) and fcm.last_trans >= DATEADD(DAY, -180, GETDATE()) then 'Yes'
--	else ''
--end LT_month_6,
case 
	when fcm.last_trans <= DATEADD(DAY, -90, GETDATE()) then 'Yes'
	else ''
end as 'LT Over 3 Month' ,
case 
	when fcm.last_trans IS NULL then 'Yes'
	else ''
end NoTransaction,
case 
	when fcm.last_trans IS NULL or fcm.last_trans <= DATEADD(DAY, -90, GETDATE()) then 'Yes'
	else ''
end as 'LT Over 3 month and No Trans',
datediff(MONTH,fcm.last_trans,GETDATE()) as 'selisih month LT',
datediff(day,fcm.last_trans,GETDATE()) as 'selisih day LT',
elm.element Element_code,elm.LDESC Outlet_element ,p.SUB_ELEMENT Sub_element_code,elm.Desc_se Outlet_SubElement,
pty.ldesc POP_TYPE ,
atp.LDESC as 'Area Type',replace(p.market_name,char(9),'') as Nama_pasar,p.LATITUDE, p.LONGITUDE,
case when p.LATITUDE >= -12.1718 and p.LATITUDE<=6.88969 and p.LONGITUDE>=93.31644 and p.LONGITUDE<= 141.71813 then 'Exist'
else 'Not Exist' end as 'geotag',
replace(p.NIC_NO,char(9),'') NIC_NO, replace(pt.TAX_NO,char(9),'') VAT,
case when sp.kode_Lee is null then '' else 'YES' end PJP,
case when soo.kode_le is null then '' else 'YES' end as 'IQ SO',
case when ftcm.first_trans < DATEADD(DAY, -90, '20190331') then 13
when ftcm.first_trans between DATEADD(DAY, -90, '20190331') and DATEADD(DAY, -84, '20190331') then 12
when ftcm.first_trans between DATEADD(DAY, -83, '20190331') and DATEADD(DAY, -77, '20190331') then 11
when ftcm.first_trans between DATEADD(DAY, -76, '20190331') and DATEADD(DAY, -70, '20190331') then 10
when ftcm.first_trans between DATEADD(DAY, -69, '20190331') and DATEADD(DAY, -63, '20190331') then 9
when ftcm.first_trans between DATEADD(DAY, -62, '20190331') and DATEADD(DAY, -56, '20190331') then 8
when ftcm.first_trans between DATEADD(DAY, -55, '20190331') and DATEADD(DAY, -49, '20190331') then 7
when ftcm.first_trans between DATEADD(DAY, -48, '20190331') and DATEADD(DAY, -42, '20190331') then 6
when ftcm.first_trans between DATEADD(DAY, -41, '20190331') and DATEADD(DAY, -35, '20190331') then 5
when ftcm.first_trans between DATEADD(DAY, -34, '20190331') and DATEADD(DAY, -28, '20190331') then 4
when ftcm.first_trans between DATEADD(DAY, -27, '20190331') and DATEADD(DAY, -21, '20190331') then 3
when ftcm.first_trans between DATEADD(DAY, -20, '20190331') and DATEADD(DAY, -14, '20190331') then 2
when ftcm.first_trans > DATEADD(DAY, -14, '20190331') then 1
end pembagi,
GSV.GSV as 'GSV RPP',
GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -90, '20190331') then 13
when ftcm.first_trans between DATEADD(DAY, -90, '20190331') and DATEADD(DAY, -84, '20190331') then 12
when ftcm.first_trans between DATEADD(DAY, -83, '20190331') and DATEADD(DAY, -77, '20190331') then 11
when ftcm.first_trans between DATEADD(DAY, -76, '20190331') and DATEADD(DAY, -70, '20190331') then 10
when ftcm.first_trans between DATEADD(DAY, -69, '20190331') and DATEADD(DAY, -63, '20190331') then 9
when ftcm.first_trans between DATEADD(DAY, -62, '20190331') and DATEADD(DAY, -56, '20190331') then 8
when ftcm.first_trans between DATEADD(DAY, -55, '20190331') and DATEADD(DAY, -49, '20190331') then 7
when ftcm.first_trans between DATEADD(DAY, -48, '20190331') and DATEADD(DAY, -42, '20190331') then 6
when ftcm.first_trans between DATEADD(DAY, -41, '20190331') and DATEADD(DAY, -35, '20190331') then 5
when ftcm.first_trans between DATEADD(DAY, -34, '20190331') and DATEADD(DAY, -28, '20190331') then 4
when ftcm.first_trans between DATEADD(DAY, -27, '20190331') and DATEADD(DAY, -21, '20190331') then 3
when ftcm.first_trans between DATEADD(DAY, -20, '20190331') and DATEADD(DAY, -14, '20190331') then 2
when ftcm.first_trans > DATEADD(DAY, -14, '20190331') then 1
end as 'RPP Wk13' ,gs18.sales as 'GSV 2018',gs19.sales as 'GSV 2019'

from pop p
	join AREA_TYPE atp on atp.AREATYPE = p.AREATYPE
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
	left join (
		select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop , max(cm.doc_date) last_trans
		from cashmemo cm
		where visit_type <> '88' 
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
	) fcm on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = fcm.code_pop and p.DISTRIBUTOR = fcm.DISTRIBUTOR
	left join (
		select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop , min(cm.doc_date) first_trans
		from cashmemo cm
		where visit_type <> '88' 
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
	) ftcm on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = ftcm.code_pop and p.DISTRIBUTOR = ftcm.DISTRIBUTOR
	left join JC_WEEK jw on ftcm.first_trans between jw.START_DATE and jw.END_DATE

--- Start IQ
	left join (
		select distinct so.rs_code, replace(so.UP_CODE,'-','') kode_LE from SUGGESTED_ORDER so where moc_no in (month(getdate()))
	) soo on soo.kode_LE = p.TOWN+p.DISTRIBUTOR+p.LOCALITY+p.SLOCALITY+p.POP
-- salees start
	left join (
			select distinct z.distributor+z.town+z.locality+z.slocality+z.pop kode_Lee from SECTION_POP z
				join (select ph.DISTRIBUTOR,ph.pjp,ph.DSR,ph.SELL_CATEGORY,ph.ACTIVE,s.ldesc 
					from PJP_HEAD ph join (select DISTRIBUTOR,sell_category,ldesc from SELLING_CATEGORY) s on ph.DISTRIBUTOR=s.DISTRIBUTOR and ph.SELL_CATEGORY=s.SELL_CATEGORY
				) ph on z.DISTRIBUTOR=ph.DISTRIBUTOR and z.PJP=ph.PJP and z.SELL_CATEGORY=ph.SELL_CATEGORY
				join (select DISTRIBUTOR,DSR,STATUS,name,
				case when ds.COUNTERSALE_YN = 'Y' and ds.JOB_TYPE ='03' then 'Shopsales' else  j.LDESC end as 'DSR Type'
				from DSR ds
				left join JOB_TYPE j on ds.JOB_TYPE=j.JOB_TYPE )ds on ph.DISTRIBUTOR=ds.DISTRIBUTOR and ph.DSR=ds.DSR
				join SECTION sc on sc.DISTRIBUTOR =z.DISTRIBUTOR and sc.SELL_CATEGORY =z.SELL_CATEGORY and sc.SECTION = z.SECTION
		where ph.active = 1 and ds.STATUS ='y' and ds.[DSR Type] in ('Order Booker','Spot Seller') and ph.SELL_CATEGORY not in ('401')
	) sp on p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = sp.kode_Lee 
--- RPP 
left join (
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele, sum(((cm.net_amount/1.1)-cm.tot_discount)) GSV
from cashmemo cm 
where cm.VISIT_TYPE <> '88' and cm.DOC_DATE between '20190101' and '20190331'
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop 
) GSV on GSV.DISTRIBUTOR = p.DISTRIBUTOR and p.town+p.locality+p.slocality+p.pop = GSV.codele
--- RPP WK1 - WK13
left join (
		select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop ,SUM(((cm.net_amount/1.1)-cm.tot_discount)) sales
		from cashmemo cm
		where visit_type <> '88' and YEAR(cm.doc_date) = '2018'
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
	) gs18 on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = gs18.code_pop and p.DISTRIBUTOR = gs18.DISTRIBUTOR
	
left join (
		select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop ,SUM(((cm.net_amount/1.1)-cm.tot_discount)) sales
		from cashmemo cm
		where visit_type <> '88' and YEAR(cm.doc_date) = '2019'
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
	) gs19 on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = gs19.code_pop and p.DISTRIBUTOR = gs19.DISTRIBUTOR

where p.ACTIVE ='1' and 
isnumeric(p.distributor)=1
