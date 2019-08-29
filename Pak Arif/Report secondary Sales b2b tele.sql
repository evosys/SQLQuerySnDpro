---Report B2B Secondary sales
select dlv.COMP2_DESC REGION,dlv.COMP3_DESC AREA,cm.DISTRIBUTOR,dt.NAME as 'DISTRIBUTOR NAME',PJP as'PJP ID',
DSR as 'DSR ID',cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP as 'Outlet ID',
cm.CASHMEMO_TYPE, cm.DOC_NO as 'DOC NO SALES', cm.COMMENTS,
convert(varchar,cm.DOC_date,105) as 'DOC DATE',
convert(varchar,cm.DELV_DATE,105) as 'DELV DATE', cd.SKU,
((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3) as 'ORIGINAL ORDER (Pcs)',
 ((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) as 'SERVICE ORDER (Pcs)'
,((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3)* pc.PRICE_UNIT3 as 'ORIGINAL VALUE'
,cd.AMOUNT as 'SERVICE VALUE',
case when tele.kode_Lee is null then '' else 'YES' end Tele,
case when bot.kode_Lee is null then '' else 'YES' end B2B
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
join  CASHMEMO_DETAIL  cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
left join SKU s on s.SKU = cd.SKU
left join (
SELECT distributor, SKU,PRICE_STRUC,EFFECTIVE_DATE,
		LEAD(EFFECTIVE_DATE,1,'99991231') OVER (PARTITION BY distributor,SKU ORDER BY EFFECTIVE_DATE) AS END_DATE,
		PRICE_UNIT3
	FROM PRICE_STRUCTURE) pc on pc.SKU =cd.SKU and pc.DISTRIBUTOR = cd.DISTRIBUTOR and cd.DOC_DATE between pc.EFFECTIVE_DATE and pc.END_DATE
left join (select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop kode_Lee from POP_ATTRIBUTE where FIELD_COMB='TELE_OUTLET' and VALUE_COMB_FROM='Y') tele on tele.kode_Lee = cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP
left join (select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop kode_Lee from POP_ATTRIBUTE where FIELD_COMB='eRTM_OUTLET' and VALUE_COMB_FROM='Y') bot on bot.kode_Lee = cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP

where cm.VISIT_TYPE <> '88' and
cm.DOC_DATE between '20170901' and '20180731' 
--and cm.distributor in ('15173721','94812001','94809001','15061942','15173325','15197007','94803001','94810001','94801001','15141333','15094446')
and cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP in (
select distinct kode_lee from 
(
select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop kode_Lee from POP_ATTRIBUTE where FIELD_COMB='eRTM_OUTLET' and VALUE_COMB_FROM='Y'
union
select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop kode_Lee from POP_ATTRIBUTE where FIELD_COMB='TELE_OUTLET' and VALUE_COMB_FROM='Y'
) x )