
select clv.comp2_desc,clv.comp3_desc ,t.ldesc Town, l.ldesc locality, sl.ldesc sublocality, sum(cm.net_amount/1.1) from cashmemo cm
join town t on t.town=cm.town
join locality l on l.town = cm.town and l.locality = cm.locality
join sub_locality sl on sl.town = cm.town and sl.locality = cm.LOCALITY and sl.slocality =cm.slocality
join (
select da.distributor, cl.comp2_desc,cl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
join vw_complevel cl on da.value_comb = cl.compcode
where field_comb ='COMPCODE') clv on clv.distributor = cm.distributor

where cm.doc_date between '20170801' and '20170821' 
and cm.visit_type not in ('88')
group by clv.comp2_desc,clv.comp3_desc,t.ldesc,l.ldesc,sl.ldesc


---- include subelement dan element

select clv.comp2_desc,clv.comp3_desc ,t.ldesc Town, l.ldesc locality, sl.ldesc sublocality,
 el.subelement, el.element, sum(cm.net_amount/1.1) from cashmemo cm
join town t on t.town=cm.town
join locality l on l.town = cm.town and l.locality = cm.locality
join sub_locality sl on sl.town = cm.town and sl.locality = cm.LOCALITY and sl.slocality =cm.slocality
join (
select da.distributor, cl.comp2_desc,cl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
join vw_complevel cl on da.value_comb = cl.compcode
where field_comb ='COMPCODE') clv on clv.distributor = cm.distributor
join (
select  p.distributor, p.town,p.locality,p.slocality,p.pop, se.ldesc subelement, e.ldesc element from pop p
join sub_element se on se.sub_element = p.sub_element
join element e  on e.element = se.element ) el on el.distributor = cm.distributor and el.town = cm.town 
and el.locality = cm.locality and el.slocality = cm.slocality and el.pop = cm.pop

where cm.doc_date between '20170801' and '20170821' 
and cm.visit_type not in ('88')
group by clv.comp2_desc,clv.comp3_desc,t.ldesc,l.ldesc,sl.ldesc , el.subelement, el.element