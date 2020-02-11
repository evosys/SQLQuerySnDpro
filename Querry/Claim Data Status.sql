select distinct ch.Distributor, dt.Name as [Distributor Name], Claim_no as [Claim Number], doc_date as [Claim Date], 
(case when status ='S' then 'Submitted' when status = 'E' then 'Waiting for Approval' when Status ='A' then 'Approved'
when Status = 'R' then 'Rejected' when status ='C' then 'Cancelled' end) as [Claim Status], status, 
Claim_type as [Claim Type], Net_Amount as [Amount]  from claim_head ch
join (select distinct distributor, name from distributor) dt on ch.distributor = dt.distributor
join (select Distributor, vc.COMP3_DESC from distributor_association da 
	  join vw_complevel vc on da.value_comb = vc.compcode
	  where da.field_comb = 'compcode'
	)ss on ch.DISTRIBUTOR = ss.DISTRIBUTOR
where ch.status not in ('G','F') and claim_type in ('MC','DC','RA')

