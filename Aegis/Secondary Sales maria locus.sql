---Report Maria Secondary sales
select dlv.COMP2_DESC REGION,dlv.COMP3_DESC AREA,cm.DISTRIBUTOR,dt.NAME as 'DISTRIBUTOR NAME',PJP as'PJP ID',cm.REF_PJP,
cm.DSR as 'DSR ID',cm.REF_DSR as'DM ID',ds.VEHICLE,ds.DESCRIPTION as 'Description Vehicle',ds.REG_NO,
cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP as 'Outlet ID',replace(p.name,char(9),'') as 'Outlet Name',
cm.CASHMEMO_TYPE, cm.DOC_NO as 'DOC NO SALES', replace(cm.COMMENTS,char(9),'') COMMENTS,
convert(varchar,cm.DOC_date,105) as 'DOC DATE',
convert(varchar,cm.DELV_DATE,105) as 'DELV DATE', cd.SKU,s.LDESC as 'SKU Name',
 ((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) as 'SERVICE ORDER (Pcs)'
,cd.AMOUNT as 'SERVICE VALUE'
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
left join pop p on p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP
left join SKU s on s.SKU = cd.SKU
left join (
select d.DISTRIBUTOR,d.DSR,d.NAME,d.VEHICLE,v.DESCRIPTION,v.REG_NO from DSR d
left join VEHICLE v on v.VEHICLE =d.VEHICLE and v.DISTRIBUTOR = d.DISTRIBUTOR) ds on ds.DISTRIBUTOR = cm.DISTRIBUTOR and ds.DSR =cm.REF_DSR
where cm.VISIT_TYPE = '02' and
cm.DOC_DATE between '20181001' and '20190331'
and cm.distributor in ('15111550',
'15132240',
'15132762',
'15162280',
'15178499')

