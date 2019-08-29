select p.DISTRIBUTOR,t.LDESC TOWN, l.LDESC Locality , sl.LDESC sub_locality ,
p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP LE_POPCODE , p.POP POP_CODE, p.NAME , p.STREET ,
se.LDESC sub_element , pt.LDESC pop_type ,p.POP_BARCODE , p.LONGITUDE ,p.LATITUDE ,p.TOTAL_TURNOVER , p.ACTIVE 
  from pop p
join TOWN t on t.TOWN = p.TOWN
join LOCALITY l on l.LOCALITY = p.LOCALITY and p.TOWN = l.TOWN
join SUB_LOCALITY sl on sl.SLOCALITY = p.SLOCALITY and sl.TOWN = p.TOWN and sl.LOCALITY = p.LOCALITY
join SUB_ELEMENT se on se.SUB_ELEMENT = p.SUB_ELEMENT
join POP_TYPE pt on pt.POPTYPE = p.POPTYPE