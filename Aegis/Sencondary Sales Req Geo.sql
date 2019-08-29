---Report B2B Secondary sales
select dlv.COMP2_DESC REGION,dlv.COMP3_DESC AREA,cm.DISTRIBUTOR,dt.NAME as 'DISTRIBUTOR NAME',PJP as'PJP ID',
DSR as 'DSR ID',cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP as 'Outlet ID',p.NAME as 'Outlet Name',
cm.CASHMEMO_TYPE,cm.REF_DOC_NO, cm.DOC_NO as 'DOC NO SALES', cm.COMMENTS,
convert(varchar,cm.DOC_date,105) as 'DOC DATE',
convert(varchar,cm.DELV_DATE,105) as 'DELV DATE', cd.SKU,
((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3) as 'ORIGINAL ORDER (Pcs)',
 ((cd.QTY1*s.SELL_FACTOR1)+ (cd.QTY2*s.SELL_FACTOR2)+cd.QTY3) as 'SERVICE ORDER (Pcs)'
,((cd.REF_QTY1*s.SELL_FACTOR1)+ (cd.REF_QTY2*s.SELL_FACTOR2)+cd.REF_QTY3)* pc.PRICE_UNIT3 as 'ORIGINAL VALUE'
,cd.AMOUNT as 'SERVICE VALUE'
from cashmemo cm
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
	) dlv on cm.distributor = dlv.distributor
	left join DISTRIBUTOR dt on dt.DISTRIBUTOR =cm.DISTRIBUTOR
join  CASHMEMO_DETAIL  cd on cd.DOC_NO = cm.DOC_NO and cd.DISTRIBUTOR = cm.DISTRIBUTOR
left join pop p on p.DISTRIBUTOR+p.TOWN+p.LOCALITY+p.SLOCALITY+p.POP = cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP
left join SKU s on s.SKU = cd.SKU
left join (
SELECT distributor, SKU,PRICE_STRUC,EFFECTIVE_DATE,
		LEAD(EFFECTIVE_DATE,1,'99991231') OVER (PARTITION BY distributor,SKU ORDER BY EFFECTIVE_DATE) AS END_DATE,
		PRICE_UNIT3
	FROM PRICE_STRUCTURE) pc on pc.SKU =cd.SKU and pc.DISTRIBUTOR = cd.DISTRIBUTOR and cd.DOC_DATE between pc.EFFECTIVE_DATE and pc.END_DATE
where cm.VISIT_TYPE <> '88' and
cm.DOC_DATE between '20180101' and '20180331' 
and cm.DISTRIBUTOR+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.POP in ('98682001357102001500036415',
'94025001337413000100353267',
'15369392320220000801073060',
'98682001350311000300036353',
'98682001350622000300036374',
'98682001350614000801048173',
'98681001351514001100598993',
'94210001340404000200358951',
'15369351327601000700349911',
'93504001330104000400188857',
'15409987351514001300001389',
'93528001337602000200397740',
'98681001357815000600001292',
'15322545352611001000122533',
'15409987351507002301078352',
'94212001331109000401065633',
'94210001340102000800358962',
'15247788330606001300358984',
'15369351327601100700349910',
'15224518350517000200070463',
'15224518357201000500070401',
'15152343317504000600009309',
'94210001340407000100358932',
'15315318357805000300967187',
'15228579320519000900402808',
'15189935351713001200026133',
'15212473317109000201086386',
'15261556320916200501058815',
'15315813327106000400391196',
'15152343317503000600009244',
'15170193360317000400361534',
'15126013357301000900123501',
'15149589352907000500106571',
'15281632331072000800378943',
'93504001330102000700188474',
'15247710351901001400926389',
'15261556320916200501081005',
'15234930321709000600380867',
'15242468351315000600030759',
'94210001347104000600358937',
'15147292317102000101032277',
'15234930321708000300382027',
'15322545352613000800109303',
'15271608327326000300402735',
'98681001357818000500001295',
'93528001332616000500397762',
'15213006320119000600048051',
'15334658330211000800172672',
'15195745347106000201086766',
'15334658330117000800172530',
'15281632331413000900403147',
'15299979352425000300107506',
'15152343317209000600009264',
'15131251320320000500950553',
'15281632330905000300378941',
'15272585330709002000165347',
'15369392320225000600371794',
'15369392320220001200372620',
'15334658330211000700173047',
'98684001350913000400665911',
'15409987351514000300001394',
'15170181317404000200004577',
'15369351327601100400393338',
'94210001340311000400359000',
'15235811351018000400600257',
'15261556320916200501058820',
'15131251320314000700960441',
'15147578330312000600188179',
'15170193360303000400361529',
'15344994330118000900166898',
'15110816332908001700157427',
'94025001337403000500353254',
'15146528331315000300162319',
'15261120331305000300430189',
'93528001332810000700397738',
'15152343317209000100009314',
'15272585330709002000165355',
'98682001350517000500919402',
'15152343317209000500009288',
'94212001337201000200378942',
'15242468350806001800030724',
'15310522330516000700136215',
'15146528331415000600162027',
'15131843357503100500121172',
'98074001331222000800210501',
'15281632331112000400378966',
'15147292327505000300974055',
'15281632331413000900378961',
'94210001340407000200358986',
'15334658330274000700173487',
'94210001340205000300359022',
'15390407331610001601064301',
'98681001357805000300001368',
'98681001357816000200001310',
'15118791320813000500395927',
'15266921330107000500362588',
'15118791320816000300395931',
'98681001357823000200001296',
'94212001331108000900983142',
'15261556320916200501058821',
'15300127352703000700081432',
'15281632337301000100378953',
'15126013357901000400106592',
'98681001357816000501064320',
'15147579332303002300165330',
'94210001340102000800358963',
'15409987351516001400001332',
'15212473327604001300008227',
'15242468350804000800759065',
'94025001332101000700353250',
'93528001337502000500397776',
'15322545352612001000122534',
'98682001350311000500036406',
'98681001357808000400001363',
'93504001330103000700189022',
'15215742317501000200015390',
'15170181317403000300004568',
'15242468351318000400030722',
'15189935351713001200026110',
'15170193367103001700361522',
'15281632330905000300378973',
'93528001332917000900397761',
'15344994330172000500173514',
'15224518357201000500070434',
'15260849351210000300600246',
'15260849351212000800090348',
'98681001357820000100001373',
'93528001332810000400397769',
'94210001340203000300358969',
'15131251320320001100869544',
'15369392320218000300368954',
'15147579332303002300165331',
'94212001331109000600378951',
'15242468350806000901089687',
'15261120331309000800430153',
'15299979352308001500001323',
'94210001347104000200359003',
'15147579332303001101068319',
'15271607327702000600402745',
'15369351367402001300393352',
'15207579332007000700380631',
'94025001332101000901099990',
'15315814317102000300389607',
'98681001357807000100001344',
'15310522330520000300136185',
'94025001332215100600353272',
'15334658330273000400173483',
'15152343317209000401041575',
'15261120331310000500430057',
'15149589352907000500106577',
'15308809331517001400137680',
'15315814317101000500391240',
'15261556320916200501059015',
'15310522330519000900135297',
'15258079332002100200213708',
'15281632331072000800378991',
'15409220327805000400380576',
'15188372351518000500001412',
'15344994330171000100173504',
'15207579331901001300380629',
'15088918331209000500143705',
'15409220327805000400957124',
'15315813317202000300391174',
'15260849351105000200082736',
'94228001340216000300204348',
'93528001332708001500397768',
'15238048320309000600399414',
'15252343350104000700977140',
'15271608327325000300402732',
'15281632337301000100378952',
'94025001337405000100353248',
'15344994330171000100173512',
'15361000321515000600069480',
'15131251320319001600956245',
'15132705352802001900097562',
'93528001332816000100397767',
'15299979352315000500001162',
'93528001332812001200397779',
'15152343317506000400009243',
'94025001337408000100353251',
'15322545352612001000122535',
'98681001357814000600001338',
'15238048320311001000399419',
'15126013357301001100123503',
'15261555321014001300373377',
'15247788330811001000358957',
'15242468357403100600127914',
'15422115321304000200336915',
'98681001357815000601087966',
'15334658330211000500173035',
'94210001347109000200358924',
'15152343317504000400009258',
'15409220327805000500380577',
'15308809337407000800829038',
'94025001332101000900353270',
'15334658330273000100173473',
'15118791320816001300395934',
'94025001332107000400353264',
'15170181317404000700004580',
'93528001332810000901023251',
'15208733320810001500978844',
'94210001340412000200358991',
'15207579331810000700380620',
'98682001350510000300600744',
'15266921320728001100367867',
'98681001357813000300001325',
'98684001351007000500094462',
'15213006327503100100920352',
'15409987351513000900001343',
'94212001331413000900378984',
'94210001340102000800359028',
'15147579332306000900165333',
'15238048320306000400399415',
'94210001340412000100358975',
'94212001337204001000378969',
'15252343350104000800977091',
'15409220320613000400380580',
'15247788337101100500358977',
'15228579320519000800402809',
'15215742317402000700015416',
'98684001350901000501046359',
'98684001351012001100601961',
'15242468350806001800030753',
'15132705352807000500091298',
'15126013357303000800123483',
'93528001337602000500397754',
'15334658330209000600173280',
'15310523332711000800148297',
'15266921327901000500918865',
'94282001340211000200205810',
'15224518350508000500070426',
'15147578330306001100165317',
'15152493321213000600380607',
'15322545352611000800122526',
'15152493321215001300380611',
'98684001350905000400030765',
'15315318357804000200022986',
'15247710351903001201048020',
'15281632331112000400378945',
'15247788330606001300358927',
'15147578330316000900188166',
'98684001351010000300030725',
'15124533331605001300122510',
'15207579331810000700380626',
'93528001337602000400397730',
'15238048320302000600399416',
'94212001331311000300378970',
'15308809337405000700163892',
'94210001340201000200358999',
'15334658330273000200957349',
'15131843351420001100121175',
'15300127352711001100081424',
'94025001332417001600353259',
'94025001337408000200353280',
'15126012357303000300108048',
'94025001337414000100353278',
'15322545352611001000122529',
'93504001330106000300188656',
'15441955330911000600153668',
'94025001331513001200353249',
'93047001367304000500329511',
'15409987351504000900001297',
'15080895350614000200028266',
'94282001340408000200666038',
'15235811351018000500119733',
'94025001337415000500353266',
'15260849351210001300030740',
'15334658330211000400172531',
'15250153320107001200716632',
'94025001332417001600353282',
'98681001357811000600001304',
'15247710350217000800036356',
'94025001332417001700353260',
'98682001350605000300036432',
'15224518350508000500070402',
'15147579332303002400165332',
'15170193360303000400361528',
'98684001350971000400030733',
'15260849351212000800089459',
'15300300340406000300202462',
'94025001337416000600944740',
'94212001331214001000378960',
'94025001332215100700353271',
'15310522330503000900136060',
'15261555321017000400378169',
'15208733320810001500978846',
'94025001337407000800353274',
'15170181317308000400004575',
'94008001337410000100164101',
'15118791320813000500395938',
'94212001331311000300378974',
'15261555321017000400378145',
'15147292327505000301044502',
'98682001350606000700036396',
'15271607327305000500402741',
'93528001332903000500397773',
'98681001357812000300001377',
'15132708352111000400035218',
'93528001332708001500397744',
'15110816332907000900156959',
'15281632331112000400378940',
'15247710351814000400036418',
'15247710350217001400036420',
'15131720330512002400159483',
'15147578330312000600187741',
'15310522330520000301072556',
'15131251320320000800399831',
'93528001332812001200397743',
'93528001332917000900397760',
'15142051330807001000159918',
'93528001332917001700397732',
'15167937330214001100169934',
'94212001337204000200378979',
'15260849351110001000030736',
'15247788330606001300358959',
'93528001332814000800397737',
'15167937330217000700170118',
'15146528331402001000161694',
'98681001357813000300001390',
'15281632330905000300378981',
'94210001340407000100358978',
'15131251320320000800399825',
'15102648352216000900043836',
'98682001350613000201076855',
'15281632331112000400378968',
'15242468351315000200030758',
'94025001331513001200353258',
'15208733320808000700348451',
'93528001332708001500397741',
'98682001350412001000036386',
'93528001332812001200397777',
'98681001357809000400001360',
'15322545352611000800122527',
'15131843351412000800121135',
'15152343317209000700009256',
'94207001330818000600201157',
'15238048320303000500399417',
'15195745347106000201086765',
'15315814317105000200008195',
'94210001347106000500358930',
'94282001340214000200205727',
'93528001332908001700397766',
'15315813327604100300387560',
'15266921327901000500362618',
'94212001337202000100378938',
'98682001350507001200036363',
'94210001347101000100358947',
'15102648352216000900043833',
'94210001340401000100359026',
'15409987351516001600001351',
'94025001332101000700353257',
'98681001357810000200001293',
'15334658330274000500173481',
'94212001331413000900378950',
'15147292317102000100932337',
'15247710352006001500036354',
'15131251320320000200399813',
'15247710350217000300036409',
'15369351367406000900393396',
'15167937330202000600169902',
'98681001357810000600001362',
'15170193360303000400361525',
'15131251320320000700399824',
'15152343317206000600009298',
'15334658330273000200173476',
'15247710351814001001048172',
'98682001350412001400036424',
'15197538327801000700357729',
'93528001332917000900397736',
'15215742367102001200015418',
'15188372351605001100001439',
'15147578330406001500211705',
'15147578330305001200165319',
'15230292360306001100397060',
'15369351367405000200393350',
'98682001350216001000036429',
'15207579332010001100380624',
'15147578330306000600165322',
'15212473317106000400008184',
'15250153327104000700716582',
'15170193360313000300361535',
'15147292317203000400012850',
'15334658330223000100173501',
'15369392327203000300369787',
'15147578330312000600188035',
'15213006327503000400048054',
'15215742317407000400403399',
'93047001367202100101093772',
'15131251320322000500399833',
'15369392320218000300368953',
'15147578330403000800165315',
'94210001340201000200359006',
'15310522330519000800135004',
'15300300340412000500202653',
'94210001340215000400358933',
'98682001357202000100036434',
'94025001332417000901025477',
'15126013357305000200123512',
'15344994330118000900166899',
'94212001337204001000378977',
'93528001332903000500397734',
'93528001337601000800397765',
'98682001357203000500036361',
'15126013350729000200123507',
'15207579332011001100380623',
'94025001337405000700353263',
'15310522330501001600136253',
'94282001340211000200206121',
'15147578330316000900188080',
'15131251320317001100399834',
'15409987351514000401088617',
'94210001347104000300358970',
'93528001332816000200397774',
'94228001340202000200204115',
'15247710351903001200036348',
'98681001357812000400001301',
'15390407331603000301066048',
'15170193367103000600361572',
'94210001347103000100358993',
'15131843351412000800121142',
'94025001332407000600353283',
'15102648352410001400043830',
'98684001350972000500030756',
'15088918331207001000143713',
'94210001340407000300358974',
'98684001351010000300030723',
'15369351327601000600349909',
'93528001337603000300397731',
'94210001347104000200359015',
'93528001337603000600397739',
'94210001340213000200358949',
'94210001340309001000358954',
'15242468351320001000937619',
'15132705352805000800097563',
'93528001332903000500397733',
'98684001350971000200030734',
'15147578330306001100165321',
'15132705352805000800091263',
'94212001331311000300378946',
'94025001337408000600353265',
'98682001350603000701098234',
'15281632331018001000378976',
'15170193367104100600361521',
'94210001340207000400358995',
'15247710350209001700036405',
'94282001340214000100979825',
'15131251320320000500399832',
'15334658330273000200173486',
'94210001347104000100358972',
'15310523332701100200148754',
'15409987351507001200001317',
'15132705352802001900097561',
'98682001350311000500036349',
'15102648352216000800043829',
'94210001347106000300358926',
'15102648352313001300043827',
'15247788330807001400358983',
'15142051330802001100159580',
'15366019352410001400100430',
'15390407331705000800167445',
'15247788337101100100359014',
'94210001347101000200358946',
'94025001337407001100976118',
'93528001332913001700397751',
'15247788340214000300359027',
'15131251320312000300399814',
'98682001357102001700128665',
'98681001357811000600001388',
'98682001350614000800036360',
'15260849351212000801099966',
'15147292317303000500012873',
'98682001357201000501064761',
'94210001347109000200358925',
'93528001332810000400397746',
'15189935351713001200026085',
'15409987351516001600001397',
'94282001340213000500205421',
'94210001340407000200358931',
'15207579332008000400380617',
'15310523332712001400148481',
'15315813327104000200391144',
'15409220327805000400380597',
'15170193360313000600361530',
'15368653327403000100390282',
'94212001331214001000378964',
'15334658330273000400173472',
'98682001350603000701045977',
'15189935351713001200026092',
'15195745340213000600180302',
'15152343317207000600009281',
'15315813327102000600973711',
'15247710352006001900036340',
'15131251320312000300399828',
'15299979352425000800107424',
'15170193360305000200361533',
'93504001330103000700189540',
'15409987351514000600001380',
'93528001332810000500397755',
'15247788330811000800358958',
'94212001337204000200378947',
'15152343317506000600009259',
'15409220320606000500380581',
'15310523332712000900148260',
'15102648352403001600043837',
'15118791320813000500395933',
'15310522330520000300136187',
'15228293331072000700183138',
'94210001340412000200358964',
'94282001340214000200205485',
'15212473317202000101086383',
'15132705352805000800097565',
'93047001367202100601069025',
'15300127352703000700081409',
'15147578330402000100165316',
'15310523332708001600148619',
'15102648352422000600043838',
'98682001357102001400036413',
'15281632331413000900378949',
'98074001331210001100210738',
'94025001337416000400353253',
'15310523332712001200148955',
'15188372357602000600001411',
'15212473317101000400008193',
'15188372351518000500001440',
'94282001340211000200205821',
'15281632337201000100378965',
'98681001357812000400001306',
'94210001340407000100358939',
'15261555321004000500378146',
'15230292360306001100397061',
'15247710352105001700036339',
'98682001350614000900036414',
'94212001337202000100378983',
'98684001350901000501046511',
'15409220320605000200393318',
'15131720330512002400159482',
'15208733320811101000978843',
'15409987351514000200001401',
'15213006320118001900129735',
'15170193360312100400361531',
'93504001330103000700189050',
'15247788337101100500358928',
'15247710357701000400036390',
'15369392320220000801073059',
'98681001357811000400001385',
'15247710350217000701069616',
'93528001332907000900397759',
'94210001340207000300358979',
'15281632331072000800378963',
'15147533320211000600392449',
'15266921320710000900362591',
'15252343350104000800977141',
'98682001350412001400036428',
'15207579331810001500380630',
'15238048320310000200399418',
'15170193360305100300361565',
'98681001357814100400001291',
'94025001337416000700353252',
'93528001332903001000397757',
'15310522330207000700970839',
'98681001357825000300001392',
'15322545352611001001000211',
'94210001340410000100358973',
'94212001331112000400378988',
'15102648352313001500043831',
'94025001332210000500353255',
'15188372351608000700664642',
'15215742317501000500015419',
'15261555321021000700373536',
'15334658330271000600173475',
'94210001340213000800358971',
'15315814317101000500391239',
'15369392320220100100372626',
'15126013357303001100123493',
'94212001331104000500984739',
'15334658330223000300173477',
'94210001340309001101023969',
'93528001332816000600397747',
'15261556320912002400400672',
'98682001350412001000036423')