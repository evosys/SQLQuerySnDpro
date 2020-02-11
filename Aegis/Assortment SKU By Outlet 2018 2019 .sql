--- quartal bookmonth
select codele,[12018],[22018],[32018],[42018],[12019],[22019],[32019],[42019]
from 
(
select cm.distributor+cm.town+cm.locality+cm.slocality+cm.pop codele,CONCAT(quarter,year)  as 'QYear',COUNT(distinct cd.sku) total from CASHMEMO cm
left join cashmemo_detail cd on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
left join J_CYCLE jc on cm.DOC_DATE between jc.START_DATE and jc.END_DATE
where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20180101' and '20191231'
group by cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP,CONCAT(quarter,year) 
) x 
		pivot
			(
			  sum(total) for qyear in ( [12018],[22018],[32018],[42018],[12019],[22019],[32019],[42019])
			) as PVT 
----- gergorian Quartal
select codele,[2018-Q1],[2018-Q2],[2018-Q3],[2018-Q4],[2019-Q1],[2019-Q2],[2019-Q3],[2019-Q4]
from 
(
select cm.distributor+replace(cm.town,' ','')+cm.locality+cm.slocality+cm.pop codele,CAST(year(cm.DOC_DATE) AS char(4)) + '-Q' + 
    CAST(DATEPART(QQ, cm.DOC_DATE) AS char(1))  as 'QYear',COUNT(distinct cd.sku) total from CASHMEMO cm
left join cashmemo_detail cd on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20180101' and '20191231'
group by cm.distributor+replace(cm.town,' ','')+cm.locality+cm.slocality+cm.pop,CAST(year(cm.DOC_DATE) AS char(4)) + '-Q' + 
    CAST(DATEPART(QQ, cm.DOC_DATE) AS char(1))
) x 
		pivot
			(
			  sum(total) for qyear in ( [2018-Q1],[2018-Q2],[2018-Q3],[2018-Q4],[2019-Q1],[2019-Q2],[2019-Q3],[2019-Q4])
			) as PVT 

----- month
select codele,
[201801], [201802], [201803], [201804], [201805], [201806], [201807], [201808], [201809], [201810], [201811], [201812],
[201901], [201902], [201903], [201904], [201905], [201906], [201907], [201908], [201909], [201910], [201911], [201912]
from 
(
select cm.distributor+replace(cm.town,' ','')+cm.locality+cm.slocality+cm.pop codele,format(cm.DOC_DATE, 'yyyyMM')  as 'QYear'
,COUNT(distinct cd.sku) total from CASHMEMO cm
left join cashmemo_detail cd on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20180101' and '20191231'
group by cm.distributor+replace(cm.town,' ','')+cm.locality+cm.slocality+cm.pop,format(cm.DOC_DATE, 'yyyyMM')
) x 
		pivot
			(
			  sum(total) for qyear in ( 
[201801], [201802], [201803], [201804], [201805], [201806], [201807], [201808], [201809], [201810], [201811], [201812],
[201901], [201902], [201903], [201904], [201905], [201906], [201907], [201908], [201909], [201910], [201911], [201912])
			) as PVT 
