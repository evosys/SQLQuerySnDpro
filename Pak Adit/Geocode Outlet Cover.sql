select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area ,p.distributor,dt.NAME ,
p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP code_le,replace(p.name,char(9),'') Outlet_name,
case 
	when p.active = 1 then 'Active'
	when p.active = 0 then 'InActive'
end Store_ActiveClosed,
pv.LDESC Province,t.LDESC Town, l.ldesc locality, sl.LDESC sub_locality ,replace(p.STREET,char(9),'') Outlet_adress,
p.LATITUDE, p.LONGITUDE

from pop p
join DISTRIBUTOR dt on p.distributor = dt.distributor
join town t on t.TOWN =p.TOWN
join LOCALITY l on l.LOCALITY = p.LOCALITY and l.TOWN =p.TOWN
join SUB_LOCALITY sl on sl.TOWN = p.TOWN and sl.LOCALITY =p.LOCALITY and sl.SLOCALITY =p.SLOCALITY
join PROVINCE pv on pv.PROVINCE = t.PROVINCE
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
where --p.ACTIVE ='1' and 
isnumeric(p.distributor)=1
and dlv.COMP3_DESC = 'ASM BALI NTB'

