--Identity Crisis
Duel.LoadScript("big_aux.lua")


local s,id=GetID()
function s.initial_effect(c)
	--Activate Skill
	aux.AddSkillProcedure(c,2,false,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)

        local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetCondition(s.repcon)
		e2:SetOperation(s.repop)
		Duel.RegisterEffect(e2,tp)

        local e3=e2:Clone()
        e3:SetCode(EVENT_SPSUMMON_SUCCESS)
        Duel.RegisterEffect(e3,tp)


        local e4=e2:Clone()
        e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
        Duel.RegisterEffect(e4, tp)


	end
	e:SetLabel(1)
end

local levelcards={}
levelcards[1]={99171160,1929294,32274490,27288416,80825553,68140974,16024176,35405755,14957440,13582837,72714392,58695102,57421866,51916853,25533642,79905468,47474172,81951640,75886890,98049915,68167124,78274190,36472900,40640057,57116033,65899613,79279397,92676637,2830693,11548522,12538374,12398280,57769391,67441435,81752019,85457355,96146814,5577149,18789533,4632019,14729426,40380686,51275027,1434352,3657444,7268133,7969770,14198496,18590133,28427869,34659866,40441990,43803845,48868994,52254878,56597272,70410002,72992744,78642798,79538761,79491903,81587028,97631303,86271510,63845230,75198893,87978805,64631466,76815942}
levelcards[2]={92667214,11066358,52550973,89959682,14181608,12482652,42941100,79335209,95511642,47217354,75922381,48519867,90311614,59575539,26157485,2311090,1566817,86993168,23168060,22567609,17932494,46701379,22180094,19113101,28139785,30276969,53855409,27416701,69529567,25716180,76573247,59563768,55702233,82593786,64583600,66288028,17857780,72291078,15198996,83370323,46657337,8201910,80741828,68658728,12061457,16222645,67629977,2694423,40583194,71625222,23434538,33420078,46925518,25034083,13026402,38049541,40867519,3078576,85914562,52430902,30765615,7304544,58518520,3248469,74983881,51196174,55990317,37038993,17994645,62560742,50091196}
levelcards[3]={23635815,74093656,22916281,68505803,42625254,60246171,23898021,57036718,17948378,80925836,89222931,35199656,25795273,97896503,30227494,9637706,83239739,90508760,66500065,36717258,43586926,46609443,57568840,89015998,29834183,6901008,70298454,43426903,22174866,81035362,8910240,71519605,42874792,79853073,29618570,2009101,42463414,49959355,93900406,24087580,39041550,20127343,95443805,6967870,13215230,15394083,52860176,72403299,77087109,80233946,77013169,58589739,10809984,23289281,43739056,61587183,77379481,93445074,15150365,26202165,41872150,88032368,90654356,20586572,17601919,95360850,11390349,57624336,29177818,54959865,3510565,4906301,17955766,3233859,17679043,61681816,66451379,48686504,83602069,15383415,19280589,87257460,89621922,99801464,5519829,79575620,85087012,83903521,26308721,50593156,66436257,17732278,15341821,23205979,82458280,20228463,14558127,52038441,52038442,59438930,60643553,62015408,69764158,73642296,83982270,87319876,36584821,50599453,99414168,92385016,46057733,81846453,15240238,13574687}
levelcards[4]={23771716, 51351302, 30012506, 12694768, 89718302, 70832512, 49771608, 44179224, 24907044, 65477143, 51028231, 7279373, 51391183, 18318842, 88409165, 44223284, 11302671, 10286023, 47897376, 74891384, 45236142, 71620241, 72843899, 16135253, 62320425, 101201027, 86377375, 69023354, 78121572, 86120751, 43096270, 62315111, 38468214, 64160836, 97127906, 25920413, 58066722, 91070115, 98719226, 64428736, 25771826, 76650663, 55982698, 85876417, 92998610, 99785935, 85673903, 53143898, 27632240, 62962630, 27024795, 32181268, 22662014, 67314110, 17968114, 91869203, 29654737, 55821894, 47480070, 53162898, 94004268, 89567993, 64342551, 58324930, 38520918, 93221206, 60953949, 18486927, 17663375, 43230671, 36821538, 6438003, 13923256, 77539547, 40140448, 40428851, 87979586, 43583400, 41098335, 41158734, 96427353, 85639257, 40916023, 22377815, 16889337, 8396952, 35781051, 61175706, 97574404, 34568403, 92039899, 48675364, 14430063, 49881766, 40502912, 75730490, 1225009, 56827051, 36151751, 28985331, 75220074, 84430950, 20470500, 7180418, 86915847, 67159705, 15480588, 17535588, 17170970, 29071332, 22493812, 29687169, 85489096, 7913375, 3431737, 72714226, 77036039, 39015, 29311166, 69852487, 2134346, 74311226, 70089580, 29139104, 84914462, 48305365, 42969214, 75081613, 77411244, 8567955, 39892082, 86325596, 10476868, 84478195, 19740112, 46145256, 73356503, 60549248, 47346845, 44586426, 48094997, 5053103, 64178868, 69695704, 90161770, 100432033, 5361647, 79867938, 100432034, 35537251, 32750341, 68144350, 100432032, 13313278, 40133511, 84990171, 21362970, 16796157, 99426834, 46924949, 16899564, 32452818, 58400390, 30587695, 51578214, 6628343, 94022093, 33731070, 39168895, 39256679, 58685438, 32696942, 16768387, 53606874, 74130411, 75252099, 45547649, 36694815, 50896944, 61901281, 75672051, 79409334, 52319752, 91642007, 87564352, 17465972, 49003716, 88305978, 19462747, 41902352, 81105204, 8571567, 58820853, 70465810, 73534250, 14785765, 70194827, 39507162, 97023549, 21051146, 26302522, 16984449, 95515789, 92518817, 5464695, 35215622, 61802346, 43694481, 50920465, 48115278, 34743446, 48115277, 97783659, 55969226, 50903514, 54582424, 98884569, 14089428, 7953868, 41396436, 55349375, 40634253, 21340051, 37675138, 938717, 13316346, 20546916, 32296881, 61156777, 45025640, 74277583, 78161361, 66740005, 71413901, 52840598, 16719802, 27217742, 6353603, 66762372, 92572371, 93751476, 43748308, 98093548, 70355994, 66084673, 75132317, 6214884, 36569343, 23979249, 70026064, 9418365, 92586237, 53678698, 29981935, 32339440, 42551040, 88940154, 68601507, 89662736, 23857661, 59251766, 16157341, 94096616, 10860121, 50474354, 69723159, 11958188, 56574543, 86868952, 5818294, 80555062, 32202803, 59364406, 4998619, 7150545, 3405259, 91449144, 74440055, 5244497, 11384280, 16021142, 55289183, 4694209, 46848859, 62121, 54360049, 61245403, 93220472, 54092240, 45531624, 91152256, 96930127, 88190453, 77252217, 32600024, 18859369, 66699781, 53871273, 30327674, 47829960, 49191560, 16956455, 7198399, 95905259, 54878729, 94766498, 20154092, 52158283, 88552992, 97112505, 67559101, 24861088, 2089016, 50916353, 58383100, 21999001, 81974607, 98234196, 87468732, 21830679, 17810268, 79703905, 43318266, 13474291, 16197610, 42541548, 3534077, 94395649, 65496056, 75130221, 8662794, 24661486, 54656181, 8806072, 10375182, 22666164, 68018709, 44656450, 43513897, 41269771, 82913020, 70908596, 78364470, 78358521, 101201005, 93889755, 38289717, 53713014, 28358902, 74976215, 64806765, 9505425, 73853830, 54525057, 81524756, 69937550, 21698716, 7093411, 95600067, 14469229, 39964797, 55326322, 10789972, 69526976, 21915012, 85802526, 59907935, 59281922, 29975188, 5373478, 91663373, 30655537, 76763417, 80316585, 3370104, 39978267, 75559356, 5370235, 77625948, 41230939, 3019642, 96428622, 645087, 36033786, 51020079, 34614910, 81057959, 70074904, 44792253, 52702748, 48092532, 95291684, 37043180, 7572887, 36614113, 19808608, 39153655, 55415564, 28406301, 12822541, 72181263, 46796664, 34109611, 59546528, 90925163, 16209941, 52350806, 41949033, 11321183, 57784563, 33875961, 91596726, 31919988, 62312469, 81755371, 21417692, 88685329, 14536035, 26914168, 19357125, 90980792, 85313220, 99261403, 74153887, 40933924, 89494469, 83269557, 59784896, 17881964, 5388481, 78861134, 67316075, 35394356, 6351548, 29116732, 14943837, 10209545, 8649148, 2525268, 87621407, 12262393, 12079734, 12965761, 81985784, 78613627, 38981606, 22227683, 42908201, 63362460, 64184058, 54749427, 13093792, 48150362, 91691605, 93431862, 80744121, 73481154, 80186010, 11232355, 30037118, 17257342, 62893810, 66961194, 1596508, 36733451, 27143874, 28720123, 32134638, 38988538, 64973287, 1580833, 38628859, 92133240, 29996433, 56980148, 19612721, 15595052, 76446915, 41113025, 20277376, 62113340, 77153811, 34358408, 98371278, 19700943, 85310252, 39432962, 59724555, 1003028, 33296432, 60303688, 96891787, 95816395, 57062206, 18106132, 72717433, 76922029, 69436288, 22804644, 64379430, 58369990, 84916669, 44436472, 28355719, 64319467, 49684352, 17643265, 88413677, 42596828, 65737274, 65472618, 76066541, 87835759, 84462118, 83980492, 78009994, 92870717, 15146890, 73779005, 28183605, 89172051, 81661951, 92868896, 99050989, 71218746, 85360035, 28798938, 12766474, 12493482, 35195612, 20137754, 67310848, 39396763, 7409792, 53461122, 67987302, 67105242, 51858306, 4192696, 96352326, 61173621, 34566435, 97567736, 44178886, 40844553, 35283277, 80532587, 17412721, 95824983, 34710660, 23118924, 30314994, 65260293, 92755808, 66712593, 97623219, 63060238, 79979666, 80908502, 84327329, 69572169, 98266377, 95362816, 59392529, 5285665, 69884162, 37195861, 89312388, 50720316, 45195443, 20721928, 40044918, 9327502, 86188410, 75434695, 45702014, 75043725, 21672573, 9482987, 72631243, 50078320, 76909279, 38695361, 52566270, 24326617, 52900001, 11460577, 32013448, 13650422, 95943058, 42679662, 79785958, 77542832, 35209994, 4756629, 40921545, 8814959, 72429240, 5284653, 4058065, 78663366, 3536537, 96872283, 16146511, 80651316, 17045014, 16480084, 101201018, 54266211, 63749102, 74131780, 12600382, 16474916, 79858629, 37343995, 5352328, 43863925, 7080743, 984114, 26050548, 93449450, 67045745, 12235475, 60434101, 24040093, 57630503, 73040500, 20315854, 81563416, 86937530, 65953423, 42921475, 55623480, 68401546, 75582395, 86170989, 68468459, 31887905, 21390858, 68881649, 4376658, 40542825, 31764353, 54100561, 34193084, 73176465, 97396380, 218704, 41392891, 89529919, 77456781, 68870276, 2863439, 22855882, 27012717, 81109178, 68535320, 69000994, 66413481, 46534755, 64752646, 27132350, 87473172, 20455229, 86605184, 71407486, 10560119, 33034646, 41089128, 79444933, 66499018, 23297235, 77372241, 95621257, 96890582, 17390179, 209710, 83812099, 9400127, 10851853, 39246582, 82896870, 66457138, 13241004, 66765023, 31987274, 84834865, 3134241, 88875132, 5628232, 33314479, 15001940, 5298175, 29088922, 12015000, 10040267, 17706537, 86520461, 16556849, 85359414, 98818516, 12451640, 38538445, 98336111, 90642597, 4130270, 12423762, 26082117, 28884172, 49003308, 51355346, 50354944, 40371092, 14882493, 28770951, 9024367, 863795, 98555327, 77491079, 2196767, 11549357, 24291651, 88283496, 59019082, 12800777, 19012345, 91482773, 5818798, 101201003, 30190809, 423705, 85651167, 47030842, 92693205, 923596, 73428497, 72370114, 47687766, 11662742, 27004302, 90019393, 72056560, 69243722, 91731841, 45662855, 35622739, 27126980, 43114901, 54620698, 64734090, 69140098, 26254876, 91798373, 19041767, 72305034, 99000107, 69247929, 98147766, 91438994, 27827903, 68450517, 94622638, 56511382, 24432029, 19182751, 67483216, 52222372, 77895328, 54635862, 28373620, 77936940, 21887179, 59965151, 61103515, 64804316, 95265975, 41762634, 58185394, 73698349, 97017120, 58831685, 80280944, 8471389, 47606319, 82116191, 17241941, 38445524, 76543119, 20032555, 8226374, 29216967, 84620194, 69811710, 92784374, 16693254, 36227804, 66399675, 73551138, 39905966, 19959742, 17241370, 63942761, 30334522, 29888389, 59789370, 43175027, 90582719, 52502677, 41470137, 25924653, 31247589, 57731460, 4253484, 2067935, 78868776, 77642288, 50893987, 899287, 78658564, 66707058, 18960169, 85306040, 12755462, 82324312, 63665875, 25259669, 83743222, 53493204, 10236520, 21155323, 56105047, 39695323, 19667590, 62476815, 2948263, 59911557, 15367030, 55010259, 28565527, 76203291, 81344070, 52323207, 7526150, 42868711, 24073068, 52467217, 10992251, 13944422, 13676474, 35866404, 32907538, 2906250, 40937767, 11448373, 22134079, 25262697, 99877698, 17393207, 30213599, 37101832, 46955770, 63695531, 58657303, 24317029, 11813953, 55691901, 27796375, 92736188, 13429800, 41172955, 13090893, 53829412, 58314394, 17243896, 56198785, 53754104, 99581584, 73544866, 10755153, 9633505, 33460840, 89272878, 47879985, 75209824, 6990577, 54629413, 98301564, 45883110, 41788781, 38975369, 61027400, 24639891, 63748694, 78362751, 28066831, 17201174, 94535485, 5640330, 68473226, 73941492, 90238142, 68815132, 56585883, 76812113, 91932350, 27927359, 54415063, 66386380, 39392286, 75064463, 31987203, 85399281, 5434080, 31281980, 34761062, 90365482, 74968065, 54493213, 47025270, 66337215, 60316373, 87255382, 56921677, 96704018, 82315772, 82293134, 19310321, 45705025, 65848811, 89774530, 34143852, 18548966, 61132951, 50491121, 52370835, 1833916, 86943389, 64501875, 78033100, 41639001, 54579801, 71459017, 76184692, 43730887, 70124586, 40410110, 37742478, 69669405, 75830094, 43530283, 46821314, 90788081, 73018302, 37869028, 22587018, 2118022, 2671330, 40348946, 20351153, 22200403, 21297224, 95929069, 99328137, 82777208, 28762303, 24019092, 97024987, 56347375, 32485518, 53303460, 56673112, 62953041, 55273560, 3775068, 84173492, 82773292, 47754278, 8581705, 99177923, 51566770, 54320860, 74823665, 101201014, 94730900, 21351206, 89423971, 62034800, 76520646, 4941482, 97923414, 35052053, 28450915, 3056267, 13529466, 38450736, 52601736, 53274132, 41916534, 73405179, 4042268, 22657402, 3137279, 43543777, 23850421, 44364207, 96235275, 84673417, 96287685, 14851496, 83725008, 43697559, 40894584, 51916032, 94773007, 53535814, 42851643, 51855378, 43436049, 78922939, 59546797, 11012887, 71106375, 23927545, 59312550, 52768103, 51934376, 20065259, 94656263, 17444133, 100207002, 68928540, 41544074, 12829151, 95789089, 39118197, 24150026, 6276588, 3846170, 70271583, 54541900, 31149212, 48048590, 66752837, 54878498, 25926710, 80441106, 63542003, 20541432, 88979991, 83986578, 64788463, 15767889, 75901113, 39037517, 80367387, 6320631, 32314730, 41201555, 54520292, 14309486, 19642889, 176392, 74576482, 80839052, 176393, 95204084, 30936186, 95090813, 1184620, 67724379, 67050396, 93302695, 76512652, 82642348, 56514812, 60802233, 97590747, 90147755, 16188701, 38480590, 84900597,
				 79418153, 11125718, 46272804, 95993388, 70156946, 80275707, 35911108, 41741922, 30303854, 11834972, 38492752, 46404281, 89609515, 52786469, 67468948, 7127502, 87010442, 15327215, 75116619, 49721904, 25280974, 62543393, 98225108, 47226949, 49922726, 55444629, 16312943, 82128978, 89617515, 54766667, 27407330, 68812773, 52339733, 23331400, 4611269, 61692648, 55210709, 90790253, 40666140, 94183877, 35514096, 99510761, 81618817, 40320754, 45871897, 68762510, 48596760, 11439455, 14152693, 35618217, 50546208, 11091375, 92746535, 22624373, 10071151, 96384007, 42940404, 85136114, 54563536, 23782705, 60999392, 45674286, 96938777, 94664694, 79182538, 79870141, 34680482, 48252330, 11868731, 26016357, 52404456, 77848740, 22530212, 10239627, 23220863, 6061630, 46474915, 68024506, 31629407, 94418111, 43930492, 43857222, 80304126, 66078354, 47929865, 45655875, 19489718, 15983048, 95833645, 26655293, 93013676, 40695128, 21524779, 84055227, 17214465, 79629370, 68395509, 94784213, 645794, 32918479, 60102563, 21593977, 14255590, 72657739, 13723605, 43714890, 95492061, 71277255, 33945211, 91953000, 99885917, 21057444, 44287299, 53573406, 22512406, 10189126, 75499502, 24530661, 34160055, 75195825, 80965043, 36521307, 17946349, 89743495, 52354896, 53577438, 27182739, 16360142, 59036972, 94538053, 4417407, 94973028, 20368763, 31533704, 44026393, 15335853, 67922702, 94667532, 7359741, 58843503, 18551923, 90444325, 36849933, 63056220, 81823360, 47731128, 93715853, 84754430, 3715284, 2137678, 75733063, 39648965, 86569121, 49905576, 34198387, 24435369, 21767650, 282886, 58471134, 22076135, 81019803, 37792478, 33256280, 32472237, 19476824, 26638543, 92826944, 62327910, 47558785, 5130393, 72427512, 61845881, 24419823, 53666449, 46864967, 63259351, 101201006, 38572779, 12836042, 65549080, 82199284, 22837504, 29054481, 71340250, 45159319, 4732017, 7225792, 637216, 45909477, 16366944, 71717923, 43573231, 92720564, 37260946, 55119278, 75775867, 84592800, 57839750, 78394032, 86767655, 82108372, 99937011, 35514097, 4848423, 9837195, 54098121, 18108166, 47060154, 68516705, 100207235, 74591968, 83011278, 15025844, 15613529, 50457953, 80959027, 55424270, 28570310, 54965929, 43709490, 97518132, 70948327, 27762803, 29942771, 33866130, 70083723, 80555116, 84905691, 51254980, 96653775, 25654671, 55099248, 24644634, 62405028, 28297833, 60666820, 89463537, 72090076, 16587243, 816427, 91554542, 85840608, 19594506, 50930991, 78734254, 13857930, 4335645, 88724332, 78402798, 20295753, 81306586, 66569334, 24701235, 11987744, 95027497, 4041838, 92125819, 30575681, 47120245, 57690191, 42472002, 19680539, 13391185, 88923963, 18426196, 59057152, 5361816, 73359475, 34242278, 92887027, 91011603, 48783998, 92065772, 36010310, 12953226, 52077741, 98806751, 90464188, 45121025, 12948099, 70913714, 3606209, 66927994, 95990456, 43268675, 14531242, 93130022, 71071546, 57835716, 2311603, 59644958, 39229392, 58071123, 13760677, 84530620, 71408082, 6075801, 85346853, 86401517, 68670547, 73398797, 21263083, 39091951, 75375465, 15936370, 42035044, 73776643, 71930383, 4807253, 31292357, 71578874, 7563579, 67696066, 72708264, 37745740, 44481227, 9000988, 92644052, 21949879, 64207696, 55997110, 88358139, 92170894, 10731333, 47075569, 71863024, 44364077, 15978426, 26270847, 42562690, 40318957, 65195959, 93892436, 29169993, 220414, 73511233, 7714344, 79967395, 99792080, 62393472, 71181155, 34961968, 7576264, 43191636, 74852097, 30312361, 12958919, 67556500, 98881931, 2618045, 64145892, 1362589, 97639441, 89132148, 65367484, 17418745, 43147039, 69846323, 16020923, 20700531, 26185991, 83682209, 97526666, 43716289, 6903857, 89547299, 68075840, 50621530, 31440046, 31600513, 22011689, 52792430, 31118030, 549481, 64025981, 8129306, 2316186, 75917088, 78527720, 82213171, 21414674, 89770167, 10071456, 16684346, 9798352, 29417188, 65471349, 58453942, 77590412, 48461764, 77044671, 86605515, 71411377, 25652259, 73783043, 6256844, 46572756, 74875003, 84177693, 70856343, 6483224, 56524813, 37829468, 77558536, 10194329, 73977033, 5929801, 96345188, 60508057, 51814159, 6552938, 60950180, 31314549, 87321742, 83236601, 53251824, 9190563, 44680819, 255998, 6337436, 80516007, 25236056, 43378076, 18000338, 91020571, 79387392, 10028593, 23421244, 4550066, 65570596, 8372133, 86445415, 72318602, 81354330, 14886469, 53485634, 67300516, 30494314, 68769900, 2851070, 70821187, 20210570, 80102359, 60606759, 89594399, 43002864, 16909657, 14878871, 56343672, 50485594, 85138716, 70630741, 65734501, 91222209, 96938986, 46502744, 3072077, 87347365, 31709826, 12469386, 62403074, 83957459, 11845050, 132308, 72498838, 14812659, 71971554, 38601126, 44203504, 36187051, 46354113, 30860696, 51987571, 91939608, 67127799, 77189532, 5969957, 68464358, 44956694, 96385345, 2752099, 23087070, 1557341, 46303688, 54040221, 16509093, 70791313, 37953640, 24919805, 24611934, 91864689, 63193879, 37265642, 30914564, 44877690, 15130912, 67972302, 20618081, 89662401, 56003780, 13173832, 44161893, 93124273, 64926005, 68989981, 14344682, 73648243, 64538655, 65056481, 2273734, 26057276, 86466163, 75878039, 99668578, 13851202, 63274863, 1050186, 38667773, 96223501, 82361809, 19139516, 56746202, 97000273, 64550682, 80529459, 69155991, 12152769, 71746462, 42071342, 20345391, 80885324, 24062258, 97064649, 70180284, 6579928, 93104633, 23401839, 85448931, 42029847, 43359262, 71829750, 82466274, 77723643, 52551211, 30328508, 95401059, 57827484, 9603356, 27869883, 20939559, 10163855, 77312273, 15939448, 98126725, 98162021, 87303357, 95956346, 82085619, 49776811, 66815913, 39817919, 92200612, 25415053, 4148264, 35818851, 62038047, 94801854, 99423156, 41562624, 2584136, 14771222, 3603242, 65422840, 10449150, 90303176, 73665146, 62950604, 31059809, 71015787, 15947754, 73001017, 29021114, 9791914, 32476603, 52843699, 59707204, 57019473, 89362180, 88901771, 88232397, 73752131, 65338781, 46363422, 27655513, 62782218, 86652646, 5265750, 67750322, 10202894, 64306248, 30532390, 26077387, 37351133, 12958920, 78636495, 40200834, 29802344, 84290642, 3070049, 15893860, 60228941, 45985838, 28966434, 14763299, 57617178, 40384720, 62895219, 49218300, 15734813, 31242786, 44335251, 36119641, 44308317, 31553716, 70655556, 84569017, 86174055, 69550259, 53054833, 50482813, 23792058, 17328157, 16947147, 85034450, 80559548, 93966624, 73061465, 13522325, 14037717, 26517393, 80770678, 67957315, 19307353, 86396750, 49885567, 13890468, 88123329, 65193366, 50155385, 67436768, 45484331, 56818977, 20424878, 80637190, 94096018, 41091257, 20584712, 24610207, 49407319, 44273680, 64726269, 38331564, 8875971, 91110378, 70668285, 34244455, 37799519, 63184227, 15381421, 59228631, 27036706, 86613346, 44818, 23220533, 15458892, 49964567, 98049038, 44729197, 2396042, 53116300, 26722601, 35618486, 22617205, 72269672, 31812496, 89571015, 29013526, 50032342, 27415516, 13002461, 41006930, 74715061, 23535429, 13521194, 30106950, 99861526, 16428514, 16719140, 423585, 10321588, 86804246, 8091563, 85374678, 5220687, 41628550, 5182107, 41307269, 89091772, 82112494, 78391364, 56727340, 90361010, 34496660, 44072894, 69610326, 31259606, 40473581, 79972330, 20001443, 56495147, 11682713, 62434031, 70204022, 49919798, 12927849, 36687247, 11234702, 44073668, 3170832, 79757784, 64892035, 86039057, 18444902, 73956664, 572850, 84847656, 42822433, 79210531, 732302, 41589166, 97036149, 24557335, 63308047, 56681873, 35975813, 52367652, 28573958, 38730226, 71107816, 45005708, 54706054, 97093037, 93346024, 4404099, 26704411, 89194103, 94845226, 44155002, 84080939, 82489470, 68049471, 83764996, 84926738, 8978197, 99315585, 36704180, 32541773, 76305638, 27782503, 31904181, 95519486, 29491031, 10262698, 87557188, 78243409, 18180762, 38479725, 65475294, 51838385, 33977496, 78423643, 12332865, 76075810, 16223761, 70797118, 14089429, 48049769, 49791927, 64730881, 82496097, 74578720, 19891131, 52083044, 56308388, 18063928, 68860936, 11375683, 69572024, 59383041, 79875176, 42386471, 15270885, 64116319, 16392422, 65458948, 53623827, 71283180, 1826676, 58132856, 94283662, 34072799, 13821299, 52286175, 75416738, 55428242, 45803070, 88078306, 82738277, 91812341, 28201945, 49027020, 28868394, 45221020, 87209160, 19096726, 77827521, 32912040, 33184167, 86361354, 61283655, 91505214, 59604521, 20474741, 45042329, 96163807, 61538782, 34853266, 47459126, 37313348, 70050374, 88132637, 24025620, 40225398, 94119974, 72842870, 2333365, 83235263, 11637481, 72491806, 60806437, 7152333, 33551032, 30464153, 52639377, 92084010, 58911105, 1784619, 101201028, 8512558, 33725002, 51638941, 99348756, 3026686, 80485722, 26495087, 88728507, 1371589, 46571052, 61777313, 77135531, 100420019, 100420017, 100420016, 29280200, 66401502, 29302858, 41802073, 69512157, 31772684, 22499463, 36278828, 36745317, 9350312, 10642488, 43014054, 79928401, 93130021, 94042337, 62379337, 56043447, 54185227, 27780618, 52575195, 76459806, 17415895, 93151201, 14898066, 75311421, 13220032, 168917, 5237827, 47228077, 74064212, 40619741, 10712320, 84313685, 87836938, 96300057, 13945283, 52589809, 42994702, 83286340, 19771459, 47504322, 75953262, 5438492, 43797906, 66073051, 55014050, 93343894, 2483611, 88205593, 88392300, 81896771, 72053645, 23147658, 91996584, 15090429, 99234526, 1571945, 48654323, 12213463, 49930315, 11067666, 31374201, 65810490, 92391084, 99865167, 85682655, 80538728, 59297550, 25484449, 12299841, 53540729, 71007216, 87796900, 57405307, 18430390, 87523462, 72714461, 30525991, 78010363, 17720747, 21744288, 36304921, 56369281, 44928016, 15079028, 51043243, 88438982, 73216412, 85754829, 71315423, 17649753, 3204467, 30299166, 11722335, 47111934, 69750536, 58996430, 62651957, 23115241, 50604950, 26993374, 17086528, 5998840, 77330185, 86062400, 43138260, 7850740, 86559484, 65622692, 29380133, 10315429, 94215860, 71280811, 13839120, 64749612, 53090623, 57511992, 65247798, 92246806, 28630501, 58981727, 91420254, 25244515, 64500000, 40460013, 29951323, 84388461, 12171659, 93816465, 35998832, 16268841, 31525442, 43642620, 17259470, 81616639, 14575467, 88472456, 78872731, 77150143, 31755044, 36099130, 68258355, 4647954, 23720856, 7459013, 40941889, 2648201, 95886782, 18865703, 76080032}
levelcards[5]={43793530,48766543,78060096,35565537,48202661,32012842,46384672,27882993,74388798,12408276,20292186,10852583,70456282,20537097,82482194,40663548,53839837,19153634,21368442,76052811,59380081,35595518,13250922,2356994,18036057,48768179,51644030,82627406,40659562,57579381,65479980,42338879,30778711,55151012,65976795,21250202,41039846,41141943,91862578,60822251,95727991,15464375,74641045,101201101,3111207,6180710,61465001,50400231,13482075,52846880,99427357,81612598,3113836,92731385,49513164,57477163,26273196,66235877,47219274,45231177,81197327,16114248,72959823,85684223,68319538,29981921,94515289,76359406,43385557,76891401,88033975,37706769,77506119,26593852,286392,45298492,77092311,42110604,38148100,40251688,65398390,63364266,53325667,76524506,29143726}
levelcards[6]={70781052,87151205,78984772,340002,6637331,99365553,39357122,77363314,53982768,27383719,12298909,17573739,94944637,85967160,95218695,27354732,53257892,82260502,59023523,9596126,55589254,56931015,4472318,11224103,25551951,77121851,98954375,83274244,50287060,27198001,58363151,23116808,62742651,81059524,35984222,89810518,35960413,56099748,29491334,31178212,34966096,77527210,38033121,40607210,34294855,80513550,44913552,27408609,11449436,20799347,83021423,66690411,68774379,11508758,82971335,35330871,95825679,26674724,4849037,30243636,44665365,48832775,7243511,86274272,11825276,76614340,32775808,99724761,10920352,57594700,21947653,61204971,98927491,16507828,2111707,85545073,33129626,25119460,22160245,35809262,47737087,58859575,52031567,85908279,11765832,7391448,97204936,64635042,5309481,9061682,35252119,98637386,42566602,50321796,21187631,97792247,49565413,70583986,64880894}
levelcards[7]={31447217,42129512,36996508,89943723,74677424,20849090,29424328,65192027,94392192,77797992,87742943,40732515,14989021,71564150,39711336,56619314,78193831,25955164,57046845,26400609,59793705,58554959,48964966,60948488,15744417,98434877,29436665,68304193,73734821,99458769,62701967,68299524,31759689,32909498,62340868,89399912,62503746,12510878,70969517,91512835,90411554,23431858,85679527,5560911,7369217,87564935,78534861,31986288,96227613,22211622,95568112,50263751,61757117,60258960,54752875,82956492,2519690,37057012,43892408,11502550,48996569,55171412,81566151,85507811,93729065,99551425,10383554,41462083,13756293,12307878,18013090,59771339,6568731,43202238,4779823,23874409,32646477,82044279,73580471,98506199,25862681,50065971,50793215}
levelcards[8]={89631139,56649609,13140300,55735315,48579379,85520851,83104731,81497285,57774843,72989439,93717133,15894048,50383626,32543380,99456344,57610714,2347656,61231400,95701283,10532969,63737050,53842431,60681103,11819616,40737112,76039636,85066822,5645210,47297616,64335804,45154513,4722253,53027855,35842855,13959634,76728962,49217579,75713017,82556058,85800949,84565800,80019195,35699,58206034,71438011,61160289,84366728,24413299,52248570,51617185,63487632,16886617,34172284,33331231,34022290,27103517,55125728,92204263,61441708,90488465,61505339,92719314,59900655,43413875,13694209,95679145,81555617,3117804,64681432,31042659,97811903,86327225,5405694,25857246,69123138,16313112,97642679,19025379,72426662,72566043,30086349,86676862,48791583,37818794,84330567,91998119,97165977,90579153,73452089,3642509,74157028,41209828,60461804,6855503,44373896,39823987,72896720,52145422,70902743,25165047,65187687,42216237,76774528,9012916,30757396,23693634,25132288,88643579,44508094,83994433,31385077,83755611,67904682}
levelcards[9]={48770333,29146185,92377303,84257883,97854941,29603180,26866984,14553285,1586457,33022867,33776734,27134689,6150044,3897065,11321089,37663536,11901678,45349196,28226490,54401832,70219023,79864860,17032740,49352945,78512663,90307498,41232647,59353647,18386170,15661378,75286621,52352005,16527176,63422098,3486020,52687916,40908371,3322931,87188910}
levelcards[10]={58054262,10000000,32491822,69890967,32240937,87997872,9822220,51402908,53347303,70335319,58153103,80208158,69133798,88264978,63804806,51402177,95440946,68406755,69456283,24521754,22804410,78371393,99748883,93880808,7634581,10000010,10000020,98777036,66729231,13518809,59913418,86346643,95463814,1546123,39915560,24550676,58601383,59255742,11270236,41685633,14017402,76263644,96220350,69394324,87460579,93483212,27572350,30604579,67098114,89907227,24696097,40139997,86682165}
levelcards[11]={25833572,22073844,27204311,4779091,54135423,21105106,47556396,37169670,82734805,18666161,40939228,41517789,44708154,70980824,39475024,90050480}
levelcards[12]={47027714,63468625,80630522,16802689,82103466,16306932,69815951,95209656,48546368,62873545,37542782,84433295,23995346,84544192,37440988,54702678,50687050,32615065,43378048,26268488,97836203,97489701,26443791,53971455,64193046,17775525,90884403}


function s.validreplacefilter(c, e)
    return c:HasLevel() and c:GetFlagEffect(id)==0 and c:GetOwner()==e:GetHandlerPlayer()
end

function s.repcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.validreplacefilter, 1, nil, e)
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    Duel.Hint(HINT_CARD,tp,id)

    local tc=eg:GetFirst()
    while tc do
        if s.validreplacefilter(tc, e) then
            local level=tc:GetLevel()
            if level<1 then
                level=1
            end

            if level>12 then
                level=12
            end
            --Debug.Message(levelcards[level][Duel.GetRandomNumber(1,#levelcards[level])])
			tc:Recreate(levelcards[level][Duel.GetRandomNumber(1,#levelcards[level])],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
            --tc:RegisterFlagEffect(id, RESETS_STANDARD, 0, 0)
        end
        
        tc=eg:GetNext()
    end

end






function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)

	--start of duel effects go here

	--s.startofdueleff(e,tp,eg,ep,ev,re,r,rp)

	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

function s.startofdueleff(e,tp,eg,ep,ev,re,r,rp)
    --stuff we gotta do

    for _, levelcardsin in ipairs(levelcards) do
        for _,innermostloader in ipairs(levelcardsin) do
            Duel.LoadCardScript(innermostloader)
        end
        
    end

end