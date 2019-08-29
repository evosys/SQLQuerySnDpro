select  p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP code_le,replace(p.name,char(9),'') Outlet_name,
replace(p.STREET,char(9),'') Outlet_adress,p.SUB_ELEMENT Sub_element_code,elm.Desc_se Outlet_SubElement,
p.poptype,pty.ldesc POP_TYPE ,p.POP_BARCODE,p.LATITUDE, p.LONGITUDE,dlv.COMP3 Code_Area ,dlv.COMP3_DESC Area ,dt.NAME DT_NAME
from pop p
	join pop_type pty on pty.poptype = p.poptype
	join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
		) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
	left join (select distinct pt.DISTRIBUTOR+pt.TOWN+pt.LOCALITY+pt.SLOCALITY+pt.POP codele, pt.tax_no from POP_TAX pt where pt.TAX_ID = 01) pt on pt.codele =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
	join (
		select da.DISTRIBUTOR,da.VALUE_COMB,clvl.comp2_desc ,clvl.COMP3,clvl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
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
where ISNUMERIC(p.distributor)= 1