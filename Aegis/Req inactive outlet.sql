select pc.DISTRIBUTOR,pc.TOWN+pc.LOCALITY+pc.SLOCALITY+pc.POP Code_le , pc.REQ_DATE,
case 
	when pcd.VALUE_COMB_FROM = 1 then 'Active'
	when pcd.VALUE_COMB_FROM = 0 then 'InActive'
end
VALUE_COMB_FROM, case 
	when pcd.REQ_VALUE_COMB_TO = 1 then 'Active'
	when pcd.REQ_VALUE_COMB_TO = 0 then 'InActive'
end REQ_VALUE_COMB_TO 
from POP_CHANGE_REQ pc
join POP_CHANGE_REQ_DETAIL pcd on pc.DISTRIBUTOR = pcd.DISTRIBUTOR and pc.REQ_ID = pcd.REQ_ID
where pcd.FIELD_COMB = 'active' and pc.REQ_STATUS = 'S'