----Outlet Classification over 5 m
select elm.element Element_code,elm.LDESC Outlet_element ,p.SUB_ELEMENT Sub_element_code,elm.Desc_se Outlet_SubElement, COUNT(pop) total_outlet
from POP p
	left join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
	) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
		left join (
		select da.DISTRIBUTOR,da.VALUE_COMB,clvl.COMP2,clvl.comp2_desc ,clvl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
		join
		vw_complevel clvl on da.VALUE_COMB= clvl.COMPCODE 
		join 
		( 
			select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
			where FIELD_COMB = 'compcode'
			group by DISTRIBUTOR
		) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
	) dlv on p.distributor = dlv.distributor
	left join ( select a.DISTRIBUTOR,a.code_pop,case when a.sales>5000000 then 'over5m' else 'less5m' end status 
	 from (
	 	select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop ,SUM(((cm.net_amount/1.1)-cm.tot_discount))/365*7 sales
		from cashmemo cm
		where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20180601' and '20190531'
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
		)a) sls on sls.code_pop = p.TOWN+p.LOCALITY+p.SLOCALITY+p.pop and sls.DISTRIBUTOR = p.DISTRIBUTOR
	where 
	p.ACTIVE ='1' and 
isnumeric(p.distributor)=1
and dlv.COMP2 in ('E1005E2023','E1005E2655')
	 and p.DISTRIBUTOR not in ('15440642','15440643','15441941','15446779','15451130','15451701')
	 and sls.status ='over5m'
	 group by elm.element ,elm.LDESC  ,p.SUB_ELEMENT ,elm.Desc_se 

--- >5m GT+LMT - Sec Sales

select dlv.COMP2_DESC REGION,dlv.COMP3_DESC AREA,cm.DISTRIBUTOR,dt.NAME as 'DISTRIBUTOR NAME',PJP as'PJP ID',
DSR as 'DSR ID',cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP as 'Outlet ID',p.NAME as 'Outlet Name',
cm.CASHMEMO_TYPE, cm.DOC_NO as 'DOC NO SALES', cm.COMMENTS,
convert(varchar,cm.DOC_date,105) as 'DOC DATE',
convert(varchar,cm.DELV_DATE,105) as 'DELV DATE', cd.SKU,
((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3) as 'ORIGINAL ORDER (Pcs)',
 ((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) as 'SERVICE ORDER (Pcs)'
,((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3)* pc.PRICE_UNIT3 as 'ORIGINAL VALUE'
,cd.AMOUNT as 'SERVICE VALUE'
from cashmemo cm
	left join (
		select da.DISTRIBUTOR,da.VALUE_COMB,clvl.COMP2,clvl.comp2_desc ,clvl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
		join
		vw_complevel clvl on da.VALUE_COMB= clvl.COMPCODE 
		join 
		( 
			select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
			where FIELD_COMB = 'compcode'
			group by DISTRIBUTOR
		) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
	) dlv on cm.distributor = dlv.distributor
	left join DISTRIBUTOR dt on dt.DISTRIBUTOR =cm.DISTRIBUTOR
join  CASHMEMO_DETAIL  cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
left join pop p on p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP
left join SKU s on s.SKU = cd.SKU
left join (
SELECT distributor, SKU,PRICE_STRUC,EFFECTIVE_DATE,
		LEAD(EFFECTIVE_DATE,1,'99991231') OVER (PARTITION BY distributor,SKU ORDER BY EFFECTIVE_DATE) AS END_DATE,
		PRICE_UNIT3
	FROM PRICE_STRUCTURE) pc on pc.SKU =cd.SKU and pc.DISTRIBUTOR = cd.DISTRIBUTOR and cd.DOC_DATE between pc.EFFECTIVE_DATE and pc.END_DATE
where cm.VISIT_TYPE = '02' and
cm.DOC_DATE between '20180601' and '20180930' 
		and dlv.COMP2 in ('E1005E2023','E1005E2655')
		and p.DISTRIBUTOR not in ('15440642','15440643','15441941','15446779','15451130','15451701')
and cm.distributor+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP in (	 select a.DISTRIBUTOR+a.code_pop 
	 from (
	 	select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop ,SUM(((cm.net_amount/1.1)-cm.tot_discount))/365*7 sales
		from cashmemo cm
		where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20180601' and '20190531'
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
		)a	where a.sales>5000000 )



---Rest of Outlets - Sec Sales

select floor(p.LATITUDE*100)as 'LATITUDE',floor(p.LONGITUDE*100) as 'LONGITUDE',jw.WEEK_NO,jw.YEAR,ms.PROD3,

sum( ((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) ) as 'SERVICE ORDER (Pcs)',
sum( ((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) /s.SELL_FACTOR1 ) as 'SERVICE ORDER (CS)',
sum( ((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) /s.SELL_FACTOR1 * s.SELL_WEIGHT1/1000 ) as 'Gross weight KG',
sum( ((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) /s.SELL_FACTOR1 * s.SELL_HEIGHT1*s.SELL_LENGTH1*s.SELL_WIDTH1 ) as 'Volume CCM',
sum( cd.AMOUNT) as 'SERVICE VALUE'
from cashmemo cm
	left join (
		select da.DISTRIBUTOR,da.VALUE_COMB,clvl.COMP2,clvl.comp2_desc ,clvl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
		join
		vw_complevel clvl on da.VALUE_COMB= clvl.COMPCODE 
		join 
		( 
			select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
			where FIELD_COMB = 'compcode'
			group by DISTRIBUTOR
		) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
	) dlv on cm.distributor = dlv.distributor
join  CASHMEMO_DETAIL  cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
left join pop p on p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP
left join SKU s on s.SKU = cd.SKU
left join MASTER_SKU ms on ms.MASTER_SKU =s.MASTER_SKU
join jc_week jw on cm.doc_date between jw.start_date and jw.end_date 
where cm.VISIT_TYPE = '02' and
cm.DOC_DATE between '20180601' and '20190531'
		and dlv.COMP2 in ('E1005E2023','E1005E2655')
		and p.DISTRIBUTOR not in ('15440642','15440643','15441941','15446779','15451130','15451701')
and cm.distributor+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP in (	 select a.DISTRIBUTOR+a.code_pop 
	 from (
	 	select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop ,SUM(((cm.net_amount/1.1)-cm.tot_discount))/365*7 sales
		from cashmemo cm
		where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20180601' and '20190531'
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
		)a	where a.sales<5000000 )
group by floor(p.LATITUDE*100),floor(p.LONGITUDE*100) ,jw.WEEK_NO,jw.YEAR,ms.PROD3
