select dlv.COMP2_DESC Region,dlv.COMP3_DESC Area ,p.distributor,dt.NAME ,tdt.LDESC as 'Town Distributor' , dt.WORKING_DATE,
p.distributor+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'SND outlet Code',p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP as 'Outlet code',replace(p.name,char(9),'') Outlet_name,
 t.LDESC Town, l.ldesc locality, sl.LDESC sub_locality ,replace(p.STREET,char(9),'') Outlet_adress, replace(p.OWNER_NAME,char(9),'') as 'Owner Name',
 replace(p.PHONE_NO,char(9),'') as 'Phone No'  ,replace(p.fax_no,char(9),'') FAX_NO,
case 
	when p.active = 1 then 'Active'
	when p.active = 0 then 'InActive'
end Store_ActiveClosed,ftcm.first_trans as 'First Trans(FT)',jw.YEAR as 'FT Year',jw.JCNO as 'FT JC', jw.WEEK_NO as 'FT Week',
fcm.last_trans,
case 
	when fcm.last_trans >= DATEADD(DAY, -30, GETDATE()) then 'Yes'
	else ''
end LT_month_1,
case 
	when fcm.last_trans >= DATEADD(DAY, -90, GETDATE()) then 'Yes'
	else ''
end LT_month_3,
--case 
--	when fcm.last_trans <= DATEADD(DAY, -90, GETDATE()) and fcm.last_trans >= DATEADD(DAY, -180, GETDATE()) then 'Yes'
--	else ''
--end LT_month_6,
case 
	when fcm.last_trans <= DATEADD(DAY, -90, GETDATE()) then 'Yes'
	else ''
end as 'LT Over 3 Month' ,
case 
	when fcm.last_trans IS NULL then 'Yes'
	else ''
end NoTransaction,
case 
	when fcm.last_trans IS NULL or fcm.last_trans <= DATEADD(DAY, -90, GETDATE()) then 'Yes'
	else ''
end as 'LT Over 3 month and No Trans',
datediff(MONTH,fcm.last_trans,GETDATE()) as 'selisih month LT',
datediff(day,fcm.last_trans,GETDATE()) as 'selisih day LT',
elm.element Element_code,elm.LDESC Outlet_element ,p.SUB_ELEMENT Sub_element_code,elm.Desc_se Outlet_SubElement,
case when p.SUB_ELEMENT in ('C10033',
'C10034','C10026','C10024','C10023','C10025') then 'GT DISTRIBUTOR'
when p.SUB_ELEMENT  in ('C16093','C10028',
'C10660','C71369','C71370','C71371','C71367',
'C71366','C71368','C71372','C71373','C71374') then 'MT DISTRIBUTOR'
else 'Invalid'
end as 'Channel Valid for',
pty.ldesc POP_TYPE ,
atp.LDESC as 'Area Type',replace(p.market_name,char(9),'') as Nama_pasar,p.LATITUDE, p.LONGITUDE,
case when p.LATITUDE >= -12.1718 and p.LATITUDE<=6.88969 and p.LONGITUDE>=93.31644 and p.LONGITUDE<= 141.71813 then 'Exist'
else '' end as 'geotag',
replace(p.NIC_NO,char(9),'') NIC_NO, replace(pt.TAX_NO,char(9),'') VAT,
case when popar.LE_code is null then '' else 'YES' end as 'AR Outlet',
case when popud.LE_code is null then '' else 'YES' end as 'Undeliverd CM',
case when sp.kode_Lee is null then '' else 'YES' end as 'PJP Daily',
case when ppm.kode_Lee is null then '' else 'YES' end as 'PJP Permanent',
case when soo.kode_le is null then '' else 'YES' end as 'IQ SO',
case when ftcm.first_trans <  DATEADD(DAY, -356, '20181230') then 52
when ftcm.first_trans between DATEADD(DAY, -356, '20181230') and DATEADD(DAY, -350, '20181230') then 51
when ftcm.first_trans between DATEADD(DAY, -349, '20181230') and DATEADD(DAY, -343, '20181230') then 50
when ftcm.first_trans between DATEADD(DAY, -342, '20181230') and DATEADD(DAY, -336, '20181230') then 49
when ftcm.first_trans between DATEADD(DAY, -335, '20181230') and DATEADD(DAY, -329, '20181230') then 48
when ftcm.first_trans between DATEADD(DAY, -328, '20181230') and DATEADD(DAY, -322, '20181230') then 47
when ftcm.first_trans between DATEADD(DAY, -321, '20181230') and DATEADD(DAY, -315, '20181230') then 46
when ftcm.first_trans between DATEADD(DAY, -314, '20181230') and DATEADD(DAY, -308, '20181230') then 45
when ftcm.first_trans between DATEADD(DAY, -307, '20181230') and DATEADD(DAY, -301, '20181230') then 44
when ftcm.first_trans between DATEADD(DAY, -300, '20181230') and DATEADD(DAY, -294, '20181230') then 43
when ftcm.first_trans between DATEADD(DAY, -293, '20181230') and DATEADD(DAY, -287, '20181230') then 42
when ftcm.first_trans between DATEADD(DAY, -286, '20181230') and DATEADD(DAY, -280, '20181230') then 41
when ftcm.first_trans between DATEADD(DAY, -279, '20181230') and DATEADD(DAY, -273, '20181230') then 40
when ftcm.first_trans between DATEADD(DAY, -272, '20181230') and DATEADD(DAY, -266, '20181230') then 39
when ftcm.first_trans between DATEADD(DAY, -265, '20181230') and DATEADD(DAY, -259, '20181230') then 38
when ftcm.first_trans between DATEADD(DAY, -258, '20181230') and DATEADD(DAY, -252, '20181230') then 37
when ftcm.first_trans between DATEADD(DAY, -251, '20181230') and DATEADD(DAY, -245, '20181230') then 36
when ftcm.first_trans between DATEADD(DAY, -244, '20181230') and DATEADD(DAY, -238, '20181230') then 35
when ftcm.first_trans between DATEADD(DAY, -237, '20181230') and DATEADD(DAY, -231, '20181230') then 34
when ftcm.first_trans between DATEADD(DAY, -230, '20181230') and DATEADD(DAY, -224, '20181230') then 33
when ftcm.first_trans between DATEADD(DAY, -223, '20181230') and DATEADD(DAY, -217, '20181230') then 32
when ftcm.first_trans between DATEADD(DAY, -216, '20181230') and DATEADD(DAY, -210, '20181230') then 31
when ftcm.first_trans between DATEADD(DAY, -209, '20181230') and DATEADD(DAY, -203, '20181230') then 30
when ftcm.first_trans between DATEADD(DAY, -202, '20181230') and DATEADD(DAY, -196, '20181230') then 29
when ftcm.first_trans between DATEADD(DAY, -195, '20181230') and DATEADD(DAY, -189, '20181230') then 28
when ftcm.first_trans between DATEADD(DAY, -188, '20181230') and DATEADD(DAY, -182, '20181230') then 27
when ftcm.first_trans between DATEADD(DAY, -181, '20181230') and DATEADD(DAY, -175, '20181230') then 26
when ftcm.first_trans between DATEADD(DAY, -174, '20181230') and DATEADD(DAY, -168, '20181230') then 25
when ftcm.first_trans between DATEADD(DAY, -167, '20181230') and DATEADD(DAY, -161, '20181230') then 24
when ftcm.first_trans between DATEADD(DAY, -160, '20181230') and DATEADD(DAY, -154, '20181230') then 23
when ftcm.first_trans between DATEADD(DAY, -153, '20181230') and DATEADD(DAY, -147, '20181230') then 22
when ftcm.first_trans between DATEADD(DAY, -146, '20181230') and DATEADD(DAY, -140, '20181230') then 21
when ftcm.first_trans between DATEADD(DAY, -139, '20181230') and DATEADD(DAY, -133, '20181230') then 20
when ftcm.first_trans between DATEADD(DAY, -132, '20181230') and DATEADD(DAY, -126, '20181230') then 19
when ftcm.first_trans between DATEADD(DAY, -125, '20181230') and DATEADD(DAY, -119, '20181230') then 18
when ftcm.first_trans between DATEADD(DAY, -118, '20181230') and DATEADD(DAY, -112, '20181230') then 17
when ftcm.first_trans between DATEADD(DAY, -111, '20181230') and DATEADD(DAY, -105, '20181230') then 16
when ftcm.first_trans between DATEADD(DAY, -104, '20181230') and DATEADD(DAY,  -98, '20181230') then 15
when ftcm.first_trans between DATEADD(DAY,  -97, '20181230') and DATEADD(DAY,  -91, '20181230') then 14
when ftcm.first_trans between DATEADD(DAY,  -90, '20181230') and DATEADD(DAY,  -84, '20181230') then 13
when ftcm.first_trans between DATEADD(DAY,  -83, '20181230') and DATEADD(DAY,  -77, '20181230') then 12
when ftcm.first_trans between DATEADD(DAY,  -76, '20181230') and DATEADD(DAY,  -70, '20181230') then 11
when ftcm.first_trans between DATEADD(DAY,  -69, '20181230') and DATEADD(DAY,  -63, '20181230') then 10
when ftcm.first_trans between DATEADD(DAY,  -62, '20181230') and DATEADD(DAY,  -56, '20181230') then 9
when ftcm.first_trans between DATEADD(DAY,  -55, '20181230') and DATEADD(DAY,  -49, '20181230') then 8
when ftcm.first_trans between DATEADD(DAY,  -48, '20181230') and DATEADD(DAY,  -42, '20181230') then 7
when ftcm.first_trans between DATEADD(DAY,  -41, '20181230') and DATEADD(DAY,  -35, '20181230') then 6
when ftcm.first_trans between DATEADD(DAY,  -34, '20181230') and DATEADD(DAY,  -28, '20181230') then 5
when ftcm.first_trans between DATEADD(DAY,  -27, '20181230') and DATEADD(DAY,  -21, '20181230') then 4
when ftcm.first_trans between DATEADD(DAY,  -20, '20181230') and DATEADD(DAY,  -14, '20181230') then 3
when ftcm.first_trans between DATEADD(DAY,  -13, '20181230') and DATEADD(DAY,   -7, '20181230') then 2
when ftcm.first_trans > 	  DATEADD(DAY,   -7, '20181230') then 1
end pembagi_FULL_2018,
gs18.sales as 'GSV 2018',
case when ftcm.first_trans <  DATEADD(DAY, -209, '20180805') then 31
when ftcm.first_trans between DATEADD(DAY, -209, '20180805') and DATEADD(DAY, -203, '20180805') then 30
when ftcm.first_trans between DATEADD(DAY, -202, '20180805') and DATEADD(DAY, -196, '20180805') then 29
when ftcm.first_trans between DATEADD(DAY, -195, '20180805') and DATEADD(DAY, -189, '20180805') then 28
when ftcm.first_trans between DATEADD(DAY, -188, '20180805') and DATEADD(DAY, -182, '20180805') then 27
when ftcm.first_trans between DATEADD(DAY, -181, '20180805') and DATEADD(DAY, -175, '20180805') then 26
when ftcm.first_trans between DATEADD(DAY, -174, '20180805') and DATEADD(DAY, -168, '20180805') then 25
when ftcm.first_trans between DATEADD(DAY, -167, '20180805') and DATEADD(DAY, -161, '20180805') then 24
when ftcm.first_trans between DATEADD(DAY, -160, '20180805') and DATEADD(DAY, -154, '20180805') then 23
when ftcm.first_trans between DATEADD(DAY, -153, '20180805') and DATEADD(DAY, -147, '20180805') then 22
when ftcm.first_trans between DATEADD(DAY, -146, '20180805') and DATEADD(DAY, -140, '20180805') then 21
when ftcm.first_trans between DATEADD(DAY, -139, '20180805') and DATEADD(DAY, -133, '20180805') then 20
when ftcm.first_trans between DATEADD(DAY, -132, '20180805') and DATEADD(DAY, -126, '20180805') then 19
when ftcm.first_trans between DATEADD(DAY, -125, '20180805') and DATEADD(DAY, -119, '20180805') then 18
when ftcm.first_trans between DATEADD(DAY, -118, '20180805') and DATEADD(DAY, -112, '20180805') then 17
when ftcm.first_trans between DATEADD(DAY, -111, '20180805') and DATEADD(DAY, -105, '20180805') then 16
when ftcm.first_trans between DATEADD(DAY, -104, '20180805') and DATEADD(DAY,  -98, '20180805') then 15
when ftcm.first_trans between DATEADD(DAY,  -97, '20180805') and DATEADD(DAY,  -91, '20180805') then 14
when ftcm.first_trans between DATEADD(DAY,  -90, '20180805') and DATEADD(DAY,  -84, '20180805') then 13
when ftcm.first_trans between DATEADD(DAY,  -83, '20180805') and DATEADD(DAY,  -77, '20180805') then 12
when ftcm.first_trans between DATEADD(DAY,  -76, '20180805') and DATEADD(DAY,  -70, '20180805') then 11
when ftcm.first_trans between DATEADD(DAY,  -69, '20180805') and DATEADD(DAY,  -63, '20180805') then 10
when ftcm.first_trans between DATEADD(DAY,  -62, '20180805') and DATEADD(DAY,  -56, '20180805') then 9
when ftcm.first_trans between DATEADD(DAY,  -55, '20180805') and DATEADD(DAY,  -49, '20180805') then 8
when ftcm.first_trans between DATEADD(DAY,  -48, '20180805') and DATEADD(DAY,  -42, '20180805') then 7
when ftcm.first_trans between DATEADD(DAY,  -41, '20180805') and DATEADD(DAY,  -35, '20180805') then 6
when ftcm.first_trans between DATEADD(DAY,  -34, '20180805') and DATEADD(DAY,  -28, '20180805') then 5
when ftcm.first_trans between DATEADD(DAY,  -27, '20180805') and DATEADD(DAY,  -21, '20180805') then 4
when ftcm.first_trans between DATEADD(DAY,  -20, '20180805') and DATEADD(DAY,  -14, '20180805') then 3
when ftcm.first_trans between DATEADD(DAY,  -13, '20180805') and DATEADD(DAY,   -7, '20180805') then 2
when ftcm.first_trans > 	  DATEADD(DAY,   -7, '20180805') then 1
end pembagi_YTD_2018,
ytd18.gsv as 'YTD 2018 july',

case when ftcm.first_trans <  DATEADD(DAY, -209, '20190804') then 31
when ftcm.first_trans between DATEADD(DAY, -209, '20190804') and DATEADD(DAY, -203, '20190804') then 30
when ftcm.first_trans between DATEADD(DAY, -202, '20190804') and DATEADD(DAY, -196, '20190804') then 29
when ftcm.first_trans between DATEADD(DAY, -195, '20190804') and DATEADD(DAY, -189, '20190804') then 28
when ftcm.first_trans between DATEADD(DAY, -188, '20190804') and DATEADD(DAY, -182, '20190804') then 27
when ftcm.first_trans between DATEADD(DAY, -181, '20190804') and DATEADD(DAY, -175, '20190804') then 26
when ftcm.first_trans between DATEADD(DAY, -174, '20190804') and DATEADD(DAY, -168, '20190804') then 25
when ftcm.first_trans between DATEADD(DAY, -167, '20190804') and DATEADD(DAY, -161, '20190804') then 24
when ftcm.first_trans between DATEADD(DAY, -160, '20190804') and DATEADD(DAY, -154, '20190804') then 23
when ftcm.first_trans between DATEADD(DAY, -153, '20190804') and DATEADD(DAY, -147, '20190804') then 22
when ftcm.first_trans between DATEADD(DAY, -146, '20190804') and DATEADD(DAY, -140, '20190804') then 21
when ftcm.first_trans between DATEADD(DAY, -139, '20190804') and DATEADD(DAY, -133, '20190804') then 20
when ftcm.first_trans between DATEADD(DAY, -132, '20190804') and DATEADD(DAY, -126, '20190804') then 19
when ftcm.first_trans between DATEADD(DAY, -125, '20190804') and DATEADD(DAY, -119, '20190804') then 18
when ftcm.first_trans between DATEADD(DAY, -118, '20190804') and DATEADD(DAY, -112, '20190804') then 17
when ftcm.first_trans between DATEADD(DAY, -111, '20190804') and DATEADD(DAY, -105, '20190804') then 16
when ftcm.first_trans between DATEADD(DAY, -104, '20190804') and DATEADD(DAY,  -98, '20190804') then 15
when ftcm.first_trans between DATEADD(DAY,  -97, '20190804') and DATEADD(DAY,  -91, '20190804') then 14
when ftcm.first_trans between DATEADD(DAY,  -90, '20190804') and DATEADD(DAY,  -84, '20190804') then 13
when ftcm.first_trans between DATEADD(DAY,  -83, '20190804') and DATEADD(DAY,  -77, '20190804') then 12
when ftcm.first_trans between DATEADD(DAY,  -76, '20190804') and DATEADD(DAY,  -70, '20190804') then 11
when ftcm.first_trans between DATEADD(DAY,  -69, '20190804') and DATEADD(DAY,  -63, '20190804') then 10
when ftcm.first_trans between DATEADD(DAY,  -62, '20190804') and DATEADD(DAY,  -56, '20190804') then 9
when ftcm.first_trans between DATEADD(DAY,  -55, '20190804') and DATEADD(DAY,  -49, '20190804') then 8
when ftcm.first_trans between DATEADD(DAY,  -48, '20190804') and DATEADD(DAY,  -42, '20190804') then 7
when ftcm.first_trans between DATEADD(DAY,  -41, '20190804') and DATEADD(DAY,  -35, '20190804') then 6
when ftcm.first_trans between DATEADD(DAY,  -34, '20190804') and DATEADD(DAY,  -28, '20190804') then 5
when ftcm.first_trans between DATEADD(DAY,  -27, '20190804') and DATEADD(DAY,  -21, '20190804') then 4
when ftcm.first_trans between DATEADD(DAY,  -20, '20190804') and DATEADD(DAY,  -14, '20190804') then 3
when ftcm.first_trans between DATEADD(DAY,  -13, '20190804') and DATEADD(DAY,   -7, '20190804') then 2
when ftcm.first_trans > 	  DATEADD(DAY,   -7, '20190804') then 1
end pembagi_YTD_2019_july,
ytd19.gsv as 'YTD 2019 july',
gs19.sales as 'GSV 2019/YTD',
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end pembagi,
GSV.GSV as 'GSV RPP',
GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end as 'RPP WK20 - WK32' ,
--Status RPP
case when GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end < 0 then 'Minus'
when GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end = 0 then 'No Trans.'
when GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end > 0 and GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end < 50000 then '< 50,000'
when GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end >= 50000 and GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end <= 100000 then '50-100 K'
when GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end > 100000 and GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end <= 250000 then '100-250 K'
when GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end > 250000 and GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end <= 500000 then '250-500 K'
when GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end > 500000  then '> 500,000'
end as 'Status RPP',
--Status RPP 2
case when GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end < 0 then 'Minus'
when GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end = 0 then 'No Trans.'
when GSV.GSV /
case when ftcm.first_trans < DATEADD(DAY, -83, '20190811') then 13
when ftcm.first_trans between DATEADD(DAY, -83, '20190811') and DATEADD(DAY, -77, '20190811') then 12
when ftcm.first_trans between DATEADD(DAY, -76, '20190811') and DATEADD(DAY, -70, '20190811') then 11
when ftcm.first_trans between DATEADD(DAY, -69, '20190811') and DATEADD(DAY, -63, '20190811') then 10
when ftcm.first_trans between DATEADD(DAY, -62, '20190811') and DATEADD(DAY, -56, '20190811') then 9
when ftcm.first_trans between DATEADD(DAY, -55, '20190811') and DATEADD(DAY, -49, '20190811') then 8
when ftcm.first_trans between DATEADD(DAY, -48, '20190811') and DATEADD(DAY, -42, '20190811') then 7
when ftcm.first_trans between DATEADD(DAY, -41, '20190811') and DATEADD(DAY, -35, '20190811') then 6
when ftcm.first_trans between DATEADD(DAY, -34, '20190811') and DATEADD(DAY, -28, '20190811') then 5
when ftcm.first_trans between DATEADD(DAY, -27, '20190811') and DATEADD(DAY, -21, '20190811') then 4
when ftcm.first_trans between DATEADD(DAY, -20, '20190811') and DATEADD(DAY, -14, '20190811') then 3
when ftcm.first_trans between DATEADD(DAY, -13, '20190811') and DATEADD(DAY, -7 , '20190811') then 2
when ftcm.first_trans > DATEADD(DAY, -7, '20190811') then 1
end > 0 then 'Positive'
end as 'Status RPP 2',cso.VALUE_COMB_FROM as 'Call Center Code', tle.VALUE_COMB_FROM as 'Teleorder',b2.VALUE_COMB_FROM as 'B2B'
from pop p
	join AREA_TYPE atp on atp.areatype = p.AREATYPE
	join pop_type pty on pty.poptype = p.poptype
	join town t on t.TOWN =p.TOWN
	join LOCALITY l on l.LOCALITY = p.LOCALITY and l.TOWN =p.TOWN
	join SUB_LOCALITY sl on sl.TOWN = p.TOWN and sl.LOCALITY =p.LOCALITY and sl.SLOCALITY =p.SLOCALITY
	left join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
	) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
	left join (select distinct pt.DISTRIBUTOR+pt.TOWN+pt.LOCALITY+pt.SLOCALITY+pt.POP codele, pt.tax_no from POP_TAX pt where pt.TAX_ID = 01) pt on pt.codele =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
	left join (
		select da.DISTRIBUTOR,da.VALUE_COMB,clvl.comp2_desc ,clvl.comp3_desc from DISTRIBUTOR_ASSOCIATION da
		join
		vw_complevel clvl on da.VALUE_COMB= clvl.COMPCODE 
		join 
		( 
			select distinct DISTRIBUTOR, COUNT (DISTRIBUTOR) AS CNT from DISTRIBUTOR_ASSOCIATION
			where FIELD_COMB = 'compcode'
			group by DISTRIBUTOR
		) dbl on da.SEQ_NO= dbl.CNT and dbl.DISTRIBUTOR =da.DISTRIBUTOR
	) dlv on p.distributor = dlv.distributor
	left join DISTRIBUTOR dt on dt.DISTRIBUTOR =p.DISTRIBUTOR
	left join TOWN tdt on tdt.TOWN = dt.TOWN
	left join (
		select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop , max(cm.doc_date) last_trans
		from cashmemo cm
		where cm.VISIT_TYPE = '02' 
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
	) fcm on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = fcm.code_pop and p.DISTRIBUTOR = fcm.DISTRIBUTOR
	left join (
		select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop , min(cm.doc_date) first_trans
		from cashmemo cm
		where cm.VISIT_TYPE = '02' 
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
	) ftcm on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = ftcm.code_pop and p.DISTRIBUTOR = ftcm.DISTRIBUTOR
	left join JC_WEEK jw on ftcm.first_trans between jw.START_DATE and jw.END_DATE

--- Start IQ
	left join (
		select distinct so.rs_code, replace(so.UP_CODE,'-','') kode_LE from SUGGESTED_ORDER so where moc_no in (month(getdate()))
	) soo on soo.kode_LE = p.TOWN+p.DISTRIBUTOR+p.LOCALITY+p.SLOCALITY+p.POP
-- salees start
	left join (
			select distinct z.distributor+z.town+z.locality+z.slocality+z.pop kode_Lee from SECTION_POP z
				join (select ph.DISTRIBUTOR,ph.pjp,ph.DSR,ph.SELL_CATEGORY,ph.ACTIVE,s.ldesc 
					from PJP_HEAD ph join (select DISTRIBUTOR,sell_category,ldesc from SELLING_CATEGORY) s on ph.DISTRIBUTOR=s.DISTRIBUTOR and ph.SELL_CATEGORY=s.SELL_CATEGORY
				) ph on z.DISTRIBUTOR=ph.DISTRIBUTOR and z.PJP=ph.PJP and z.SELL_CATEGORY=ph.SELL_CATEGORY
				join (select DISTRIBUTOR,DSR,STATUS,name,
				case when ds.COUNTERSALE_YN = 'Y' and ds.JOB_TYPE ='03' then 'Shopsales' else  j.LDESC end as 'DSR Type'
				from DSR ds
				left join JOB_TYPE j on ds.JOB_TYPE=j.JOB_TYPE )ds on ph.DISTRIBUTOR=ds.DISTRIBUTOR and ph.DSR=ds.DSR
				join SECTION sc on sc.DISTRIBUTOR =z.DISTRIBUTOR and sc.SELL_CATEGORY =z.SELL_CATEGORY and sc.SECTION = z.SECTION
		where ph.active = 1 and ds.STATUS ='y' and ds.[DSR Type] in ('Order Booker','Spot Seller') and ph.SELL_CATEGORY not in ('401')
	) sp on p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = sp.kode_Lee 
--- RPP  WK20 - WK32
left join (
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele, sum(((cm.net_amount/1.1)-cm.tot_discount)) GSV
from cashmemo cm 
where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20190513' and '20190811'
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop 
) GSV on GSV.DISTRIBUTOR = p.DISTRIBUTOR and p.town+p.locality+p.slocality+p.pop = GSV.codele
--- RPP End
--- GSV Full year 2018
left join (
		select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop ,SUM(((cm.net_amount/1.1)-cm.tot_discount)) sales
		from cashmemo cm
		where cm.VISIT_TYPE = '02' and YEAR(cm.doc_date) = '2018'
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
	) gs18 on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = gs18.code_pop and p.DISTRIBUTOR = gs18.DISTRIBUTOR
--- GSV YTD wk01 - wk31 2018 july
left join (
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele, sum(((cm.net_amount/1.1)-cm.tot_discount)) GSV
from cashmemo cm 
where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20180101' and '20180805'
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop 
) ytd18 on ytd18.DISTRIBUTOR = p.DISTRIBUTOR and p.town+p.locality+p.slocality+p.pop = ytd18.codele
--- GSV YTD wk01 - wk31 2019 july 
left join (
select cm.distributor, cm.town+cm.locality+cm.slocality+cm.pop codele, sum(((cm.net_amount/1.1)-cm.tot_discount)) GSV
from cashmemo cm 
where cm.VISIT_TYPE = '02' and cm.DOC_DATE between '20190101' and '20190804'
group by cm.distributor,cm.town+cm.locality+cm.slocality+cm.pop 
) ytd19 on ytd19.DISTRIBUTOR = p.DISTRIBUTOR and p.town+p.locality+p.slocality+p.pop = ytd19.codele

--- Gsv YTD 2019
left join (
		select cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop code_pop ,SUM(((cm.net_amount/1.1)-cm.tot_discount)) sales
		from cashmemo cm
		where cm.VISIT_TYPE = '02' and YEAR(cm.doc_date) = '2019'
		group by cm.DISTRIBUTOR,cm.town+cm.locality+cm.slocality+cm.pop
	) gs19 on p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = gs19.code_pop and p.DISTRIBUTOR = gs19.DISTRIBUTOR
left join (
select distinct distributor+town+locality+slocality+pop LE_code from cashmemo 
where visit_type='02' and sub_document='01'
and received_amt <> net_amount 
) popar on popar.LE_code = p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
--- pjp permanent
left join (select distinct spp.DISTRIBUTOR+spp.TOWN+spp.LOCALITY+spp.SLOCALITY+spp.POP kode_Lee from SECTION_POP_PERMANENT spp
left join PJP_HEAD ph on spp.DISTRIBUTOR = ph.DISTRIBUTOR and spp.PJP =ph.PJP 
left join dsr d on d.DISTRIBUTOR = spp.DISTRIBUTOR and d.DSR = ph.DSR
where POP_INDEX <> 0
 and ph.ACTIVE = 1 and d.STATUS = 'Y'
) ppm on ppm.kode_Lee = p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
---
left join (
select distinct distributor+town+locality+slocality+pop LE_code from cashmemo 
where visit_type='01'
) popud on popud.LE_code = p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
left join ( select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop kode_Lee,VALUE_COMB_FROM from POP_ATTRIBUTE where FIELD_COMB='Call_Center_Code') cso on cso.kode_Lee =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
left join ( select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop kode_Lee,VALUE_COMB_FROM from POP_ATTRIBUTE where FIELD_COMB='TELE_OUTLET') tle on tle.kode_Lee =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP
left join ( select DISTRIBUTOR+town+LOCALITY+SLOCALITY+pop kode_Lee,VALUE_COMB_FROM from POP_ATTRIBUTE where FIELD_COMB='eRTM_OUTLET') b2 on b2.kode_Lee =p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP

where p.ACTIVE ='1' and 
isnumeric(p.distributor)=1
-- distributor UFS on SERVER HPC
and p.DISTRIBUTOR not in ('15440642','15440643','15441941','15446779','15451130',
'15451701')