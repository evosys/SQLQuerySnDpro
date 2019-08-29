

select distinct elm.LDESC Outlet_element ,elm.Desc_se Outlet_SubElement,sc.LDESC Selling_category , SUM(tinv.total_doc) Total_invoice,
sum(tinv.total_value) Total_value , sum(lin.total_line) Total_lines
from pop p
join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT

--invoice start
left join (select cm.DISTRIBUTOR,cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP CODE_LE, cm.SELL_CATEGORY,count(DOC_NO) total_doc,sum(cm.NET_AMOUNT) total_value from CASHMEMO cm
where YEAR(doc_date) ='2017' and cm.visit_type = '02'
group by cm.DISTRIBUTOR,cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP,cm.SELL_CATEGORY ) tinv on tinv.DISTRIBUTOR+tinv.CODE_LE = p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
--lines Start
left join SELLING_CATEGORY sc on sc.SELL_CATEGORY = tinv.SELL_CATEGORY and sc.DISTRIBUTOR = tinv.DISTRIBUTOR
left join (
select sk.DISTRIBUTOR, sk.code_Outlet, COUNT(sk.sku) total_line 
from (
select distinct cm.DISTRIBUTOR, cm.town+cm.LOCALITY+cm.SLOCALITY+cm.POP code_Outlet,cm.DOC_DATE ,cd.sku from cashmemo cm
left join cashmemo_detail cd on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO 
and cd.DOC_DATE = cm.DOC_DATE
where YEAR(cm.DOC_DATE) = '2017' and cm.visit_type = '02'
) sk
group by sk.DISTRIBUTOR,sk.code_Outlet
) lin on lin.DISTRIBUTOR+lin.code_Outlet = p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
where isnumeric(p.distributor)=1
group by elm.LDESC ,elm.Desc_se,sc.LDESC
