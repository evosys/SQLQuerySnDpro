select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area ,p.distributor,dt.NAME ,'' DT_Status ,
p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP code_le,replace(p.name,char(9),'') Outlet_name,
 t.LDESC Town, l.ldesc locality, sl.LDESC sub_locality ,replace(p.STREET,char(9),'') Outlet_adress,replace(p.fax_no,char(9),'') FAX_NO,
case 
	when p.active = 1 then 'Active'
	when p.active = 0 then 'InActive'
end Store_ActiveClosed,
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
p.IDENTIFY_ON ,p.IDENTIFY_BY,p.DATE_MODIFY ,
datediff(day,p.DATE_MODIFY,GETDATE()) selisih_day_Mod,
case 
	when p.DATE_MODIFY >= DATEADD(DAY, -30, GETDATE()) then 'Yes'
	else 'NO'
end DM_month_1,
case 
	when p.DATE_MODIFY >= DATEADD(DAY, -90, GETDATE()) then 'Yes'
	else 'NO'
end DM_month_3,
case 
	when p.DATE_MODIFY >= DATEADD(DAY, -180, GETDATE()) then 'Yes'
	else 'NO'
end DM_month_6,
case 
	when p.DATE_MODIFY <= DATEADD(DAY, -180, GETDATE()) then 'Yes'
	else 'NO'
end DM_Over_month_6,
p.USER_MODIFY,p.DATE_ENTRY ,p.USER_ENTRY,elm.element Element_code,
elm.LDESC Outlet_element ,p.SUB_ELEMENT Sub_element_code,elm.Desc_se Outlet_SubElement,pty.ldesc POP_TYPE ,p.LATITUDE, p.LONGITUDE,
replace(p.NIC_NO,char(9),'') NIC_NO, replace(pt.TAX_NO,char(9),'') VAT
from pop p
	join pop_type pty on pty.poptype = p.poptype
	join town t on t.TOWN =p.TOWN
	join LOCALITY l on l.LOCALITY = p.LOCALITY and l.TOWN =p.TOWN
	join SUB_LOCALITY sl on sl.TOWN = p.TOWN and sl.LOCALITY =p.LOCALITY and sl.SLOCALITY =p.SLOCALITY
	join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
	) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
	left join (select distinct pt.DISTRIBUTOR+pt.TOWN+pt.LOCALITY+pt.SLOCALITY+pt.POP codele, pt.tax_no from POP_TAX pt where pt.TAX_ID = 01) pt on pt.codele =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
	join (
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
	left join (
		select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop , max(cm.doc_date) last_trans
		from cashmemo cm
		where visit_type <> '88' 
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
	) fcm on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = fcm.code_pop and p.DISTRIBUTOR = fcm.DISTRIBUTOR

where p.ACTIVE ='1' and 
isnumeric(p.distributor)=1
and p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
in (
select codele from 
(select p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP codele , COUNT(p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP) a from pop p
where p.ACTIVE ='1' and ISNUMERIC(p.DISTRIBUTOR) = '1'
group by p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
) b
where a >1)
