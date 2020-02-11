select elm.element Element_code,elm.LDESC Outlet_element ,p.SUB_ELEMENT Sub_element_code,elm.Desc_se Outlet_SubElement,
COUNT(p.POP) from pop p
left join (select se.SUB_ELEMENT,se.LDESC Desc_se ,e.ELEMENT,e.LDESC from SUB_ELEMENT se 
		join ELEMENT e on e.ELEMENT = se.ELEMENT and e.CHANNEL =se.CHANNEL and e.SUB_CHANNEL = se.SUB_CHANNEL and e.MASTER_CHANNEL =se.MASTER_CHANNEL
	) elm on elm.SUB_ELEMENT = p.SUB_ELEMENT
where ISNUMERIC(p.DISTRIBUTOR) = 1 
and p.SUB_ELEMENT in ('C71370','C10023','C10025')
group by elm.element ,elm.LDESC  ,p.SUB_ELEMENT ,elm.Desc_se 
order by p.SUB_ELEMENT

select distinct p.DISTRIBUTOR,dt.NAME from POP p
left join distributor dt on dt.distributor=p.DISTRIBUTOR
where ISNUMERIC(p.DISTRIBUTOR) = 1 
and p.SUB_ELEMENT in ('C71370','C10023','C10025')

select DISTRIBUTOR,TOWN,LOCALITY,SLOCALITY,POP,SUB_ELEMENT,ACTIVE,IDENTIFY_ON from POP p
where ISNUMERIC(p.DISTRIBUTOR) = 1 
and p.SUB_ELEMENT in ('C71370','C10023','C10025')


/* end week 52 2019
case when x.first_trans < DATEADD(DAY, -85, '20191231') then 13
when x.first_trans between DATEADD(DAY, -85, '20191231') and DATEADD(DAY, -79, '20191231') then 12
when x.first_trans between DATEADD(DAY, -78, '20191231') and DATEADD(DAY, -72, '20191231') then 11
when x.first_trans between DATEADD(DAY, -71, '20191231') and DATEADD(DAY, -65, '20191231') then 10
when x.first_trans between DATEADD(DAY, -64, '20191231') and DATEADD(DAY, -58, '20191231') then 9
when x.first_trans between DATEADD(DAY, -57, '20191231') and DATEADD(DAY, -51, '20191231') then 8
when x.first_trans between DATEADD(DAY, -50, '20191231') and DATEADD(DAY, -44, '20191231') then 7
when x.first_trans between DATEADD(DAY, -43, '20191231') and DATEADD(DAY, -37, '20191231') then 6
when x.first_trans between DATEADD(DAY, -36, '20191231') and DATEADD(DAY, -30, '20191231') then 5
when x.first_trans between DATEADD(DAY, -29, '20191231') and DATEADD(DAY, -23, '20191231') then 4
when x.first_trans between DATEADD(DAY, -22, '20191231') and DATEADD(DAY, -16, '20191231') then 3
when x.first_trans between DATEADD(DAY, -15, '20191231') and DATEADD(DAY, -9 , '20191231') then 2
when x.first_trans > DATEADD(DAY, -9, '20191231') then 1
*/
/* wk 01 2020
case when x.first_trans < DATEADD(DAY, -83, '20200105') then 13
when x.first_trans between DATEADD(DAY, -83, '20200105') and DATEADD(DAY, -77, '20200105') then 12
when x.first_trans between DATEADD(DAY, -76, '20200105') and DATEADD(DAY, -70, '20200105') then 11
when x.first_trans between DATEADD(DAY, -69, '20200105') and DATEADD(DAY, -63, '20200105') then 10
when x.first_trans between DATEADD(DAY, -62, '20200105') and DATEADD(DAY, -56, '20200105') then 9
when x.first_trans between DATEADD(DAY, -55, '20200105') and DATEADD(DAY, -49, '20200105') then 8
when x.first_trans between DATEADD(DAY, -48, '20200105') and DATEADD(DAY, -42, '20200105') then 7
when x.first_trans between DATEADD(DAY, -41, '20200105') and DATEADD(DAY, -35, '20200105') then 6
when x.first_trans between DATEADD(DAY, -34, '20200105') and DATEADD(DAY, -28, '20200105') then 5
when x.first_trans between DATEADD(DAY, -27, '20200105') and DATEADD(DAY, -21, '20200105') then 4
when x.first_trans between DATEADD(DAY, -20, '20200105') and DATEADD(DAY, -14, '20200105') then 3
when x.first_trans between DATEADD(DAY, -13, '20200105') and DATEADD(DAY, -4 , '20200105') then 2
when x.first_trans > DATEADD(DAY, -4, '20200105') then 1
*/
/* wk 02 2020
case when x.first_trans < DATEADD(DAY, -83, '20200112') then 13
when x.first_trans between DATEADD(DAY, -83, '20200112') and DATEADD(DAY, -77, '20200112') then 12
when x.first_trans between DATEADD(DAY, -76, '20200112') and DATEADD(DAY, -70, '20200112') then 11
when x.first_trans between DATEADD(DAY, -69, '20200112') and DATEADD(DAY, -63, '20200112') then 10
when x.first_trans between DATEADD(DAY, -62, '20200112') and DATEADD(DAY, -56, '20200112') then 9
when x.first_trans between DATEADD(DAY, -55, '20200112') and DATEADD(DAY, -49, '20200112') then 8
when x.first_trans between DATEADD(DAY, -48, '20200112') and DATEADD(DAY, -42, '20200112') then 7
when x.first_trans between DATEADD(DAY, -41, '20200112') and DATEADD(DAY, -35, '20200112') then 6
when x.first_trans between DATEADD(DAY, -34, '20200112') and DATEADD(DAY, -28, '20200112') then 5
when x.first_trans between DATEADD(DAY, -27, '20200112') and DATEADD(DAY, -21, '20200112') then 4
when x.first_trans between DATEADD(DAY, -20, '20200112') and DATEADD(DAY, -12, '20200112') then 3
when x.first_trans between DATEADD(DAY, -11, '20200112') and DATEADD(DAY, -6 , '20200112') then 2
when x.first_trans >= DATEADD(DAY, -6, '20200112') then 1
*/
/* wk 03 2020
case when x.first_trans < DATEADD(DAY, -83, '20200119') then 13
when x.first_trans between DATEADD(DAY, -83, '20200119') and DATEADD(DAY, -77, '20200119') then 12
when x.first_trans between DATEADD(DAY, -76, '20200119') and DATEADD(DAY, -70, '20200119') then 11
when x.first_trans between DATEADD(DAY, -69, '20200119') and DATEADD(DAY, -63, '20200119') then 10
when x.first_trans between DATEADD(DAY, -62, '20200119') and DATEADD(DAY, -56, '20200119') then 9
when x.first_trans between DATEADD(DAY, -55, '20200119') and DATEADD(DAY, -49, '20200119') then 8
when x.first_trans between DATEADD(DAY, -48, '20200119') and DATEADD(DAY, -42, '20200119') then 7
when x.first_trans between DATEADD(DAY, -41, '20200119') and DATEADD(DAY, -35, '20200119') then 6
when x.first_trans between DATEADD(DAY, -34, '20200119') and DATEADD(DAY, -28, '20200119') then 5
when x.first_trans between DATEADD(DAY, -27, '20200119') and DATEADD(DAY, -19, '20200119') then 4
when x.first_trans between DATEADD(DAY, -18, '20200119') and DATEADD(DAY, -14, '20200119') then 3
when x.first_trans between DATEADD(DAY, -13, '20200119') and DATEADD(DAY, -7 , '20200119') then 2
when x.first_trans >= DATEADD(DAY, -6, '20200119') then 1
*/
