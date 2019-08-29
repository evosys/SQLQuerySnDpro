---active outlet B2B
 select distinct distributor+TOWN+LOCALITY+slocality+pop from CASHMEMO 
 where 
 CASHMEMO_TYPE = '05'
		and DOC_DATE between '20180901' and '20181231'

--- Total B2B Sales Value 
 select SUM(NET_AMOUNT) from CASHMEMO 
 where 
 CASHMEMO_TYPE = '05'
		and DOC_DATE between '20180901' and '20181231'

--- Omset DISTRIBUTOR B2B
 select SUM(NET_AMOUNT) from CASHMEMO 
 where 
 visit_type <> '88' and 
 DOC_DATE between '20180901' and '20181231'
and  DISTRIBUTOR in ( select Distinct DISTRIBUTOR from CASHMEMO 
 where  CASHMEMO_TYPE = '05'
and DOC_DATE between '20180901' and '20181231')

--- Omset Outlet B2B

 select SUM(NET_AMOUNT) from CASHMEMO 
 where 
 visit_type <> '88' and 
 DOC_DATE between '20180901' and '20181231'
and  DISTRIBUTOR+town+LOCALITY+SLOCALITY+POP in ( select Distinct DISTRIBUTOR+town+LOCALITY+SLOCALITY+POP from CASHMEMO 
 where  CASHMEMO_TYPE = '05'
and DOC_DATE between '20180901' and '20181231')

--- Jumlah INvoice B2B
 select count(DOC_NO) from CASHMEMO 
 where 
 visit_type <> '88' 
 and CASHMEMO_TYPE = '05'
 and 
 DOC_DATE between '20180901' and '20181231'
 
 ---  Jumlah Line B2B  v1
 		select  count(cd.SKU) first_trans
		from cashmemo cm
		join CASHMEMO_DETAIL cd on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
		where visit_type <> '88'  
		and CASHMEMO_TYPE = '05'
		and cm.DOC_DATE between '20180901' and '20181231'
		and cd.AMOUNT <> 0

--- jumlah line b2b v2 DISTINCT

	 	select distinct cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP , cm.DOC_DATE,cd.SKU
		from cashmemo cm
		join CASHMEMO_DETAIL cd on cd.DISTRIBUTOR = cm.DISTRIBUTOR and cd.DOC_NO = cm.DOC_NO
		where visit_type <> '88'  
		and CASHMEMO_TYPE = '05'
		and cm.DOC_DATE between '20180901' and '20181231'
		and cd.AMOUNT <> 0

---- Repeat Stores
 select y.a from 
 (select distinct distributor+TOWN+LOCALITY+slocality+pop a from CASHMEMO 
 where 
 CASHMEMO_TYPE = '05'
		and DOC_DATE between '20190101' and '20190131'
) y
 join (
 select distinct distributor+TOWN+LOCALITY+slocality+pop a from CASHMEMO 
 where 
 CASHMEMO_TYPE = '05'
		and DOC_DATE between '20190201' and '20190228'
) x on y.a = x.a

--- Total Unfulfilled Orders
 select count(DOC_NO) from CASHMEMO 
 where 
 visit_type = '88' 
 and CASHMEMO_TYPE = '05'
 and 
 DOC_DATE between '20190201' and '20190228'