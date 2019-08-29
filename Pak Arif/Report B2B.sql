---Report B2B
select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area,cm.DISTRIBUTOR,dt.NAME,cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP code_LE,cm.DOC_NO  ,cm.DOC_DATE,cm.DELV_DATE,
COUNT(cd.fix_pcs) 'Original Line',SUM(CASE WHEN cd.fix_pcs NOT IN ('0') THEN 1 ELSE 0 END) as 'Serviced Lines',
sum(cd.amount_pcs)as 'Original Order Value',SUM(cd.AMOUNT) as 'Serviced value',
sum(cd.order_pcs) as 'Original Quantity (PCS)',SUM(cd.fix_pcs) as 'Serviced Quantity (PCS)'
from cashmemo cm
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
	) dlv on cm.distributor = dlv.distributor
	left join DISTRIBUTOR dt on dt.DISTRIBUTOR =cm.DISTRIBUTOR
join 
(
select cd.DISTRIBUTOR,cd.DOC_NO,cd.SKU,((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) as 'fix_pcs',
((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3) as 'order_pcs',cd.AMOUNT
,((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3)* pc.PRICE_UNIT3 as 'amount_pcs'
 from CASHMEMO_DETAIL cd
left join SKU s on s.SKU = cd.SKU
left join (
SELECT distributor, SKU,PRICE_STRUC,EFFECTIVE_DATE,
		LEAD(EFFECTIVE_DATE,1,'99991231') OVER (PARTITION BY distributor,SKU ORDER BY EFFECTIVE_DATE) AS END_DATE,
		PRICE_UNIT3
	FROM PRICE_STRUCTURE) pc on pc.SKU =cd.SKU and pc.DISTRIBUTOR = cd.DISTRIBUTOR and cd.DOC_DATE between pc.EFFECTIVE_DATE and pc.END_DATE
) cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
where cm.VISIT_TYPE <> '88' and
cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.pop in (select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop from POP_ATTRIBUTE where FIELD_COMB='eRTM_OUTLET' and VALUE_COMB_FROM='Y') and
cm.DOC_DATE between '20190201' and '20190228' 
group by dlv.COMP2_DESC ,dlv.COMP3_DESC ,cm.DISTRIBUTOR,dt.NAME,cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP,cm.DOC_NO ,cm.DOC_DATE,cm.DELV_DATE





--- tester
select top 10 * from CASHMEMO_DETAIL

select cd.DISTRIBUTOR,cd.DOC_NO,cd.SKU,((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) as 'fix_pcs',
((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3) as 'order_pcs',cd.AMOUNT
,((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3)* pc.PRICE_UNIT3 as 'amount_pcs'
 from CASHMEMO_DETAIL cd
left join SKU s on s.SKU = cd.SKU
left join (
SELECT distributor,
		SKU,
		PRICE_STRUC,
		EFFECTIVE_DATE,
		LEAD(EFFECTIVE_DATE,1,'99991231') OVER (PARTITION BY distributor,SKU ORDER BY EFFECTIVE_DATE) AS END_DATE,
		PRICE_UNIT3
	FROM PRICE_STRUCTURE) pc on pc.SKU =cd.SKU and pc.DISTRIBUTOR = cd.DISTRIBUTOR and cd.DOC_DATE between pc.EFFECTIVE_DATE and pc.END_DATE
where 
--DOC_DATE between '20190220' and '20190221' 
cd.DOC_NO ='190013001570'
 and cd.DISTRIBUTOR ='94810001' 

select * from PRICE_STRUCTURE
where sku ='21133369' and distributor ='15060926'

SELECT distributor,
		SKU,
		PRICE_STRUC,
		EFFECTIVE_DATE,
		LEAD(EFFECTIVE_DATE,1,'99991231') OVER (PARTITION BY distributor,SKU ORDER BY EFFECTIVE_DATE) AS END_DATE,
		PRICE_UNIT3
	FROM PRICE_STRUCTURE
where sku ='21133369' --and distributor ='15060926'


---- req pak rock


		select  count(cm.DOC_NO) first_trans
		from cashmemo cm
		join CASHMEMO_DETAIL cd on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
		where visit_type <> '88'  
		and CASHMEMO_TYPE = '05'
		and cm.DOC_DATE between '20181001' and '20181231'
		and cd.AMOUNT <> 0
		and cm.DISTRIBUTOR+TOWN+LOCALITY+SLOCALITY+POP in (select distinct DISTRIBUTOR+town+LOCALITY+SLOCALITY+POP from POP_ATTRIBUTE 
 where FIELD_COMB='eRTM_OUTLET' and VALUE_COMB_FROM='Y')