select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area,dt.DISTRIBUTOR,dt.NAME, cd.SKU,cd.LDESC as 'SKU Name',cd.WEEK_NO,
COUNT(cd.fix_pcs) 'Original Line',SUM(CASE WHEN cd.fix_pcs NOT IN ('0') THEN 1 ELSE 0 END) as 'Serviced Lines',
sum(cd.amount_pcs)as 'Original Order Value',SUM(cd.AMOUNT) as 'Serviced value',
sum(cd.order_pcs) as 'Original Quantity (PCS)',SUM(cd.fix_pcs) as 'Serviced Quantity (PCS)'
from distributor dt
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
	) dlv on dt.distributor = dlv.distributor
left join 
(
select cd.DISTRIBUTOR,cd.DOC_NO,cd.SKU,s.LDESC,jw.WEEK_NO,jw.YEAR,jw.JCNO,((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) as 'fix_pcs',
((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3) as 'order_pcs',cd.AMOUNT
,((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3)* pc.PRICE_UNIT3 as 'amount_pcs'
 from cashmemo cm
left join CASHMEMO_DETAIL cd on cd.DOC_NO = cm.DOC_NO and cm.DISTRIBUTOR = cd.DISTRIBUTOR
left join SKU s on s.SKU = cd.SKU
left join jc_week jw on cd.doc_date between jw.start_date and jw.end_date 
left join (
SELECT distributor, SKU,PRICE_STRUC,EFFECTIVE_DATE,
		LEAD(EFFECTIVE_DATE,1,'99991231') OVER (PARTITION BY distributor,SKU ORDER BY EFFECTIVE_DATE) AS END_DATE,
		PRICE_UNIT3
	FROM PRICE_STRUCTURE) pc on pc.SKU =cd.SKU and pc.DISTRIBUTOR = cd.DISTRIBUTOR and cd.DOC_DATE between pc.EFFECTIVE_DATE and pc.END_DATE
where cm.VISIT_TYPE <> '88' and cm.CASHMEMO_TYPE not in ('17','18','19')
) cd on  cd.DISTRIBUTOR = dt.DISTRIBUTOR
where dt.DISTRIBUTOR in (select distinct distributor from DISTRIBUTOR_ASSOCIATION where FIELD_COMB = 'Cust_Type' and VALUE_COMB = 'MT')
and cd.YEAR='2018' 
group by dlv.COMP2_DESC ,dlv.COMP3_DESC ,dt.DISTRIBUTOR,dt.NAME,cd.SKU,cd.LDESC,cd.WEEK_NO

