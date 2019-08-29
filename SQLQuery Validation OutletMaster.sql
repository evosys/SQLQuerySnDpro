

select p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP Outlet_Code,p.NAME ,
DATEDIFF(WEEK,p.IDENTIFY_ON,GETdate()) Active_Week,
convert(varchar,p.IDENTIFY_ON,105) Identify_Date,convert(varchar,cm.ftrans,105) First_Trans_Date,
convert(varchar,cm.ltrans,105) Last_Trans_Date ,
a.serialno CabinetAsset_ID,
case when p.ACTIVE = 1 then 'Active' when p.ACTIVE = 0 then 'Inactive' end Status,
se.ELEMENT Outlet_Type_Code, e.LDESC Outlet_Type_Desc,
se.SUB_ELEMENT Outlet_Sub_Type_Code , se.LDESC Outlet_sub_Type_Description,
p.KEY_CUSTOMER Banner_Code ,kc.LDESC Banner_Desc
from pop p
join SUB_ELEMENT se on se.SUB_ELEMENT = p.SUB_ELEMENT
join ELEMENT e on e.ELEMENT = se.ELEMENT
join KEY_CUSTOMER kc on kc.KEY_CUSTOMER = p.KEY_CUSTOMER
left join (select cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP outletcode, MIN(doc_date) ftrans ,MAX(doc_date)ltrans
from cashmemo cm
group by cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP)cm 
on cm.outletcode = p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP 
left join asset a on a.lastlocationcode = p.company+p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
