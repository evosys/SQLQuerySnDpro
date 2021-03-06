select dlv.COMP2, dlv.COMP2_DESC Region,dlv.COMP3,dlv.COMP3_DESC Area ,p.distributor,dt.NAME ,
p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP code_le,
replace(p.name,char(9),'') Outlet_name,
p.town code_town, t.LDESC Town, p.locality code_locality, l.ldesc locality,
p.slocality sub_locality_code ,sl.LDESC sub_locality ,
p.STREET outlet_address, p.FAX_NO,
case 
when p.active = 1 then 'Active'
when p.active = 0 then 'InActive'
end Store_ActiveClosed, 
elm.LDESC Outlet_element ,elm.Desc_se Outlet_SubElement ,p.LATITUDE, p.LONGITUDE,
replace(p.NIC_NO,char(9),'') NIC_NO, replace(pt.TAX_NO,char(9),'') VAT,
sp.PJP,sp.SELL_CATEGORY as 'Selling Category', replace(sp.section,char(9),'') as 'Section pop',
sp.DSR,sp.NAME as 'Salesman Name'
from pop p
join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.LDESC from SUB_ELEMENT se join ELEMENT e on e.ELEMENT = se.ELEMENT) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
left join POP_TAX pt on pt.DISTRIBUTOR+pt.TOWN+pt.LOCALITY+pt.SLOCALITY+pt.POP =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
join (
select da.DISTRIBUTOR,da.VALUE_COMB,ct.COMP2,clvl.comp2_desc ,ct.COMP3,clvl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
	join
	vw_complevel clvl on da.VALUE_COMB= clvl.COMPCODE 
	join COMP_TABLE ct on da.VALUE_COMB = ct.COMPCODE
	join 
	( 
		select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
		where FIELD_COMB = 'compcode'
		group by DISTRIBUTOR
	) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
) dlv on p.distributor = dlv.distributor
left join DISTRIBUTOR dt on dt.DISTRIBUTOR =p.DISTRIBUTOR
join town t on t.TOWN =p.TOWN
join LOCALITY l on l.LOCALITY = p.LOCALITY and l.TOWN =p.TOWN
join SUB_LOCALITY sl on sl.TOWN = p.TOWN and sl.LOCALITY =p.LOCALITY and sl.SLOCALITY =p.SLOCALITY
-- salees start
left join (select distinct z.distributor,z.town,z.locality,z.slocality,z.pop,
z.sell_category,z.pjp,ph.DSR,ds.name,sc.LDESC section from SECTION_POP z
		join (select DISTRIBUTOR,PJP,DSR,sell_category from PJP_HEAD where ACTIVE = '1') ph on z.DISTRIBUTOR=ph.DISTRIBUTOR and z.PJP=ph.PJP and z.SELL_CATEGORY=ph.SELL_CATEGORY
		join (select DISTRIBUTOR,DSR,name from DSR where job_type <>'02' and STATUS ='y')ds on ph.DISTRIBUTOR=ds.DISTRIBUTOR and ph.DSR=ds.DSR
		join SECTION sc on sc.DISTRIBUTOR =z.DISTRIBUTOR and sc.SELL_CATEGORY =z.SELL_CATEGORY and sc.SECTION = z.SECTION
) sp on p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP=sp.DISTRIBUTOR+sp.TOWN+sp.LOCALITY+sp.SLOCALITY+sp.POP

where  p.ACTIVE ='1' and
 isnumeric(p.distributor)=1
--and p.DISTRIBUTOR ='15081408'
--select * from COMP_TABLE where compcode ='E55880'
--select * from pop where ACTIVE ='1' and isnumeric(distributor)=1
