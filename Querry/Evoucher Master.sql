select Distributor, ep.EVOUCHER_MASTER as [Evoucher Master Code], ea.emas as [Evoucher Master Desc], 
ep.EVOUCHER_CATEGORY as [Evoucher Category Code], ea.ecat as[Evoucher Category Desc], ea.ALLOCATION_ID,
ea.Period, ea.Allo as [Allocation], ea.Uti as [Utilized], case when status='A' and QUALIFY_STATUS is null then 'Associated' 
when status='A' and QUALIFY_STATUS ='U' then 'Unqualified' when status='A' and QUALIFY_STATUS ='Q' then 'Qualified'
when status='F' and QUALIFY_STATUS ='Q' then 'Finalized' when status is null and qualify_status ='U' then 'NULL + U'
	 when status = 'P' and qualify_status ='Q' then 'P + Q'
	 when status = 'U' and qualify_status is null then 'U + NULL' 
	 when status = 'U' and qualify_status ='U' then 'NULL + U'
	 when status = 'U' and qualify_status ='Q' then 'NULL + U' end as [Status], Town+LOCALITY+SLOCALITY+pop as [Outlet Code]
from EV_EVOUCHER_POP ep

join (select e.EVOUCHER_MASTER, e.EVOUCHER_CATEGORY, ALLOCATION_ID, right(value_comb,8) as DT, POP_ALLOCATION as Allo, POP_UTILIZED as Uti,
      em.ldesc as emas, ec.ldesc as ecat, ec.period  from ev_evoucher_allocation e
      join (select evoucher_master, Ldesc  from EV_EVOUCHER_MASTER
	  ) em on e.evoucher_master = em.evoucher_master
      join (select evoucher_master, evoucher_category, ldesc, convert(varchar,From_Date,103)+' '+'-'+' '+convert(varchar,End_Date,103) as [Period] 
	        from EV_EVOUCHER_CATEGORY where status=1) ec on e.evoucher_master+e.evoucher_category = ec.evoucher_master+ec.evoucher_category
	   where ALLOCATION_LEVEL=3
)ea on  ep.distributor = ea.dt and ep.EVOUCHER_MASTER+ep.EVOUCHER_CATEGORY = ea.EVOUCHER_MASTER+ea.EVOUCHER_CATEGORY

where distributor in ()


