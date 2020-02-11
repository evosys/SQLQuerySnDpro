select dlv.COMP2_DESC Region, dlv.COMP3_DESC Area , p.distributor, dt.NAME ,
	p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'SND outlet Code', p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'Outlet code', replace(p.name,char(9),'') Outlet_name,
	case 
	when p.active = 1 then 'Active'
	when p.active = 0 then 'InActive'
end Store_ActiveClosed, gsv.GSV as 'GSV value', fcm.GSV as 'Jumlah Invoice', ln.line as 'Line'
from
	---- gsv 
	(
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,
		sum(((cm.net_amount/1.1)-cm.tot_discount)) GSV
	from cashmemo cm
	where cm.VISIT_TYPE = '02' and cm.DOC_DATE between DATEADD(DAY, -90, '20200202') and '20200202' and cm.SUB_DOCUMENT not in ('02','04')
	group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop 
) gsv
	----
	left join
	--- fcm
	(select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele,
		count(cm.DOC_NO) GSV
	from cashmemo cm
	where cm.VISIT_TYPE = '02' and cm.DOC_DATE between DATEADD(DAY, -90, '20200202') and '20200202' and cm.SUB_DOCUMENT not in ('02','04')
	group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop 
) fcm on fcm.DISTRIBUTOR = gsv.DISTRIBUTOR and fcm.codele = gsv.codele
	----
	left join
	---- line
	(
select x.DISTRIBUTOR, x.codele, COUNT(x.SKU) line
	from (
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele, cm.DOC_DATE, cd.SKU,
			SUM((cd.QTY1*b.SELL_FACTOR1)+(cd.qty2*12)+cd.QTY3 ) GSV
		from cashmemo cm
			left join CASHMEMO_DETAIL cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
			left join BATCH b on b.SKU = cd.sku
		where cm.VISIT_TYPE = '02' and cm.DOC_DATE between DATEADD(DAY, -90, '20200202') and '20200202' and cm.SUB_DOCUMENT not in ('02','04')
		group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop ,cm.DOC_DATE,cd.SKU
) x
	where x.GSV <> 0
	group by  x.DISTRIBUTOR,x.codele) ln on ln.DISTRIBUTOR =gsv.DISTRIBUTOR and ln.codele = gsv.codele

	---
	left join pop p on p.distributor= gsv.DISTRIBUTOR and p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = gsv.codele
	left join (
		select da.DISTRIBUTOR, da.VALUE_COMB, clvl.comp2_desc , clvl.comp3_desc
	from DISTRIBUTOR_ASSOCIATION da
		join
		vw_complevel clvl on da.VALUE_COMB= clvl.COMPCODE
		join
		( 
			select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT
		from DISTRIBUTOR_ASSOCIATION
		where FIELD_COMB = 'compcode'
		group by DISTRIBUTOR
		) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
	) dlv on p.distributor = dlv.distributor
	left join DISTRIBUTOR dt on dt.DISTRIBUTOR =p.DISTRIBUTOR
where gsv.DISTRIBUTOR in ('15207803','15368653','15409221')