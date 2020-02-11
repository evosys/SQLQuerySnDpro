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
'98003001',
'15083019',
'98022001',
'15110376',
'15113121',
'98009001',
'15113127',
'98030001',
'15217657',
'98049001',
'15228987',
'98026001',
'15281320',
'15079123',
'98039001',
'15227973',
'98008001',
'15146016',
'15111004',
'98016001',
'15110949',
'15317859',
'15311012',
'15225454',
'98045001',
'98012001',
'15068900',
'98004002',
'15173711',
'15293534',
'98004001',
'15071057',
'98041001',
'15092740',
'98048001',
'15315816',
'15281339',
'98038001',
'15110378',
'15116568',
'15157239',
'98035001',
'98047001',
'98044001',
'15086205',
'98019001',
'98034001',
'15132693',
'15182037',
'98028001'

) and doc_date between '20170101' and '20180215' and (wf_status is not null and wf_status <>'R') and ra.sub_document in ('01','03')
and ref_document <>'CL'

