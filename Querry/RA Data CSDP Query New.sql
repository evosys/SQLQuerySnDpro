select distinct ra.Distributor, dt.name as [Distributor Name], ra.Doc_No as [Documet Number], 
ra.Doc_Date as [Document Date], wh.ldesc as [Warehouse], lc.ldesc as [Return To], 
case when wf_serial =1 and wf_status='0' then 'UnApprove' when wf_serial=1 and wf_status='Y' and ra.status=0 then 'Approved'
when wf_serial=1 and wf_status='Y' and ra.status=1 then 'Stock Generated' 
else 'Unidentified' end as [Status], 
dc.ldesc as [RA Type], da.invoice_no as [Invoice Reference], 
ra.CREDIT_NOTE_NO as [CN Number],
ra.net_amount as [Net Amount] from ra_head ra
join distributor dt on ra.distributor = dt.distributor
join warehouse wh on ra.distributor= wh.distributor and ra.warehouse= wh.warehouse
join location lc on ra.location =lc.location
join document dc on ra.document=dc.document and ra.sub_document=dc.sub_document
join (select distributor, doc_no, invoice_no from da_head) da on ra.distributor = da.distributor and ra.ref_doc_no = da.doc_no
where ra.distributor in (
'15280990',
'15251430',
'15317075',
'15301046',
'15087529',
'15178506',
'94032001',
'15261518',
'15132240',
'94814001',
'15315814',
'94025001',
'95019001',
'94210001',
'94212001',
'94409001',
'15309234',
'15132705',
'15207803',
'15201924',
'15147579',
'93310001',
'15261547',
'92408001',
'93047001',
'15230632',
'94461001',
'15149262',
'15250189',
'95003001'

) and doc_date between '20170101' and '20180215' and (wf_status is not null and wf_status <>'R') and ra.sub_document in ('01','03')
and ref_document <>'CL'


