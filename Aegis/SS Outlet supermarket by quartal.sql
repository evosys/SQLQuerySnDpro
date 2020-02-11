select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area ,p.distributor,dt.NAME ,
p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'SND outlet Code',p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'Outlet code',replace(p.name,char(9),'') Outlet_name,
case 
	when p.active = 1 then 'Active'
	when p.active = 0 then 'InActive'
end Store_ActiveClosed,
elm.element Element_code,elm.LDESC Outlet_element ,p.SUB_ELEMENT Sub_element_code,elm.Desc_se Outlet_SubElement,
x.SKU,s.LDESC as 'SKU Name',[1],[2],[3],[4]
from (
select codele,SKU,[1],[2],[3],[4]
from 
(
select cm.distributor+cm.town+cm.locality+cm.slocality+cm.pop codele,jc.QUARTER  as 'QYear',cd.SKU,sum(cd.AMOUNT) total from CASHMEMO cm
left join cashmemo_detail cd on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
left join J_CYCLE jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20190101' and '20191231'
group by cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP, jc.QUARTER ,cd.SKU
) x 
		pivot
			(
			  sum(total) for qyear in ( [1],[2],[3],[4])
			) as PVT 
		) x
left join pop p on p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = x.codele
left join sku s on s.SKU = x.SKU
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
		left join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
	) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
where elm.ELEMENT = 'C01025'