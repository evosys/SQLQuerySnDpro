
select p.distributor,t.ldesc town,l.ldesc locality,sl.ldesc slocality,p.pop,p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP LE_code,
replace(p.name,char(9),'') Name ,replace(p.street,char(9),'') Street,
se.ldesc sub_element,pt.ldesc poptype,
p.pop_barcode,p.latitude,p.longitude,p.total_turnover,
case 
when p.active = 1 then 'Active'
when p.active = 0 then 'InActive'
end Store_ActiveClosed
,p.phone_no
 from pop p
join town t on p.town = t.town
join locality l on l.locality = p.locality and l.town = p.town
join sub_locality sl on sl.slocality = p.slocality and sl.locality = p.locality and sl.town = p.town
join sub_element se on se.sub_element = p.sub_element
join pop_type pt on pt.poptype = p.poptype
where isnumeric(p.distributor)=1