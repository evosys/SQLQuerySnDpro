select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area ,p.distributor,dt.NAME ,
p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP code_le,replace(p.name,char(9),'') Outlet_name,
 t.LDESC Town, l.ldesc locality, sl.LDESC sub_locality ,replace(p.STREET,char(9),'') Outlet_adress,dis.,replace(p.fax_no,char(9),'') FAX_NO,
case 
	when p.active = 1 then 'Active'
	when p.active = 0 then 'InActive'
end Store_ActiveClosed,
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
	left join district dis on dis.DISTRICT = p.DISTRICT
where 
--p.ACTIVE ='1' and 
isnumeric(p.distributor)=1
and p.DISTRIBUTOR in ('15218210','15131544')
