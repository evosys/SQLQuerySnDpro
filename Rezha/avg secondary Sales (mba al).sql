

select N.distributor,d.name , g.gsv_2016,n.niv_2016,g.gsv_2017,n.niv_2017
from (
select distributor,  [2016]/313 NIV_2016 ,[2017]/233 NIV_2017
from
(
select distributor ,year(doc_date) tahun, sum(net_amount) net
from cashmemo
where DOC_DATE between '20160101' and '20171001'  and VISIT_TYPE = '02'
group by distributor, year(doc_date)
)x
pivot ( sum(net) for tahun in ( [2016],[2017]))
 as pvt) n 
--- gst
join (
select distributor,  [2016]/313 GSV_2016 ,[2017]/233 GSV_2017
from
(
select distributor ,year(doc_date) tahun,
sum((net_amount/1.1)-TOT_DISCOUNT) gross from cashmemo
where DOC_DATE between '20160101' and '20171001' and VISIT_TYPE = '02'
group by distributor, year(doc_date)
)x
pivot ( sum(gross) for tahun in ( [2016],[2017]))
 as pvt ) g on g.DISTRIBUTOR = n.DISTRIBUTOR
join DISTRIBUTOR d on d.distributor = n.distributor



--- per year
select year(doc_date) tahun,
sum((net_amount/1.1)-TOT_DISCOUNT) gross , sum(net_amount) net
from cashmemo
where DOC_DATE between '20160101' and '20171001' and VISIT_TYPE = '02'
group by  year(doc_date)