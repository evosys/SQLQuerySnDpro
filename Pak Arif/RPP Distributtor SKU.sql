
select ftcm.DISTRIBUTOR,
ftcm.SKU,sk.ldesc NAMA_SKU,ftcm.first_trans,vrp.gsv as 'Last 13 WKs', 
case when ftcm.first_trans < DATEADD(DAY, -83, '20200202') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20200202') and DATEADD(DAY, -77, '20200202') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20200202') and DATEADD(DAY, -70, '20200202') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20200202') and DATEADD(DAY, -63, '20200202') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20200202') and DATEADD(DAY, -56, '20200202') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20200202') and DATEADD(DAY, -49, '20200202') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20200202') and DATEADD(DAY, -42, '20200202') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20200202') and DATEADD(DAY, -33, '20200202') then 6
when ftcm.first_trans between DATEADD(DAY, -32, '20200202') and DATEADD(DAY, -28, '20200202') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20200202') and DATEADD(DAY, -21, '20200202') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20200202') and DATEADD(DAY, -14, '20200202') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20200202') and DATEADD(DAY, -7 , '20200202') then 2
when ftcm.first_trans >= DATEADD(DAY, -6, '20200202') then 1
end pembagi,
vrp.gsv/
case when ftcm.first_trans < DATEADD(DAY, -83, '20200202') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20200202') and DATEADD(DAY, -77, '20200202') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20200202') and DATEADD(DAY, -70, '20200202') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20200202') and DATEADD(DAY, -63, '20200202') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20200202') and DATEADD(DAY, -56, '20200202') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20200202') and DATEADD(DAY, -49, '20200202') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20200202') and DATEADD(DAY, -42, '20200202') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20200202') and DATEADD(DAY, -33, '20200202') then 6
when ftcm.first_trans between DATEADD(DAY, -32, '20200202') and DATEADD(DAY, -28, '20200202') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20200202') and DATEADD(DAY, -21, '20200202') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20200202') and DATEADD(DAY, -14, '20200202') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20200202') and DATEADD(DAY, -7 , '20200202') then 2
when ftcm.first_trans >= DATEADD(DAY, -6, '20200202') then 1
end as 'RPP Value 13 WKs'
,qrp.gsv as 'Qty CS',
qrp.gsv/
case when ftcm.first_trans < DATEADD(DAY, -83, '20200202') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20200202') and DATEADD(DAY, -77, '20200202') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20200202') and DATEADD(DAY, -70, '20200202') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20200202') and DATEADD(DAY, -63, '20200202') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20200202') and DATEADD(DAY, -56, '20200202') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20200202') and DATEADD(DAY, -49, '20200202') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20200202') and DATEADD(DAY, -42, '20200202') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20200202') and DATEADD(DAY, -33, '20200202') then 6
when ftcm.first_trans between DATEADD(DAY, -32, '20200202') and DATEADD(DAY, -28, '20200202') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20200202') and DATEADD(DAY, -21, '20200202') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20200202') and DATEADD(DAY, -14, '20200202') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20200202') and DATEADD(DAY, -7 , '20200202') then 2
when ftcm.first_trans >= DATEADD(DAY, -6, '20200202') then 1
end as 'RPP QTY 13 WKs'
from 
--- Value 
 (
		select cm.DISTRIBUTOR,cd.SKU , sum(cd.AMOUNT) gsv
		from cashmemo cm
		left join cashmemo_detail cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
		where cm.VISIT_TYPE = '02' and cm.DOC_DATE between DATEADD(DAY, -90, '20200202') and '20200202'
		group by cm.DISTRIBUTOR,cd.SKU
		)  vrp 
left join (
		select cm.DISTRIBUTOR,cd.SKU , min(cm.doc_date) first_trans
		from cashmemo cm
		left join cashmemo_detail cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
		where cm.VISIT_TYPE = '02' 
		group by cm.DISTRIBUTOR,cd.SKU
		) ftcm on vrp.DISTRIBUTOR = ftcm.DISTRIBUTOR and vrp.SKU =ftcm.SKU
join sku sk on sk.sku = vrp.sku
--- QTY CS 
left join (
		select cm.DISTRIBUTOR,cd.SKU , sum((cd.QTY1)+((cd.QTY2*s.SELL_FACTOR2)+cd.QTY3)/s.SELL_FACTOR1) gsv
		from cashmemo cm
		left join cashmemo_detail cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
		left join SKU s on s.SKU = cd.SKU
		where cm.VISIT_TYPE = '02' and cm.DOC_DATE between DATEADD(DAY, -90, '20200202') and '20200202'
		group by cm.DISTRIBUTOR,cd.SKU
		)  qrp on qrp.DISTRIBUTOR = vrp.DISTRIBUTOR and qrp.SKU =vrp.SKU
		