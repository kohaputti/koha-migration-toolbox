--
-- Initial JYKDOK parameterization for Koha
--

TRUNCATE itemtypes;

INSERT INTO `itemtypes` (itemtype, description, notforloan, checkinmsgtype) VALUES 
('GRADUL','Gradulokero','1','message'),
('KONVERSIO','KONVERSIO','1','message'),
('LAINA0','Ei lainata','1','message'),
('LAINA1','Lyhytlaina','0','message'),
('LAINA14','Kurssikirjat','0','message'),
('LAINA28','Laina-aika 28 vrk','0','message'),
('SP','Säilytyspaikka','1','message'),
('TABLETIT14','Lainattavat tablettitietokoneet','0','message'),
('VARASTO180','Varastolaina 180 vrk','0','message'),
('VARASTO28','Varastolaina 28 vrk','0','message'),
('VARASTO28L','Varasto, lukusalilaina','0','message');
UNLOCK TABLES;


LOCK TABLES `authorised_values` WRITE;

DELETE FROM authorised_values WHERE category = 'CCODE';

INSERT INTO `authorised_values` (category, authorised_value, lib) VALUES 
	('CCODE', 'f', 'Avohyllyyn'),
	('CCODE', 'v', 'Avohyllystä varastoon'),
	('CCODE', 'h', 'Hyllystä toiseen'),
	('CCODE', 'p', 'Laitokselta pääkirjastoon'),
	('CCODE', 'k', 'Korvaa avohyllyn kirjan');
UNLOCK TABLES;



LOCK TABLES `authorised_values` WRITE;

DELETE FROM authorised_values WHERE category = 'LOC';

INSERT INTO `authorised_values` (category, authorised_value, lib) VALUES 
	('LOC', '100', 'Pääkirjasto'),
	('LOC', '101', 'P Yleiskok Laina 3.krs'),
	('LOC', '102', 'P Yleiskok LsKirja 3.krs'),
	('LOC', '104', 'P Lehdet 3.krs'),
	('LOC', '106', 'P Yleiskok Laina 2.krs'),
	('LOC', '107', 'P Yleiskok LsKirja 2.krs'),
	('LOC', '108', 'P Bibliografiat 2.krs'),
	('LOC', '109', 'P Lehdet 2.krs'),
	('LOC', '110', 'P Mikromuoto 3.krs'),
	('LOC', '111', 'P Lainattava kurssikirja'),
	('LOC', '112', 'P Mikrofilmilehdet'),
	('LOC', '113', 'P Kaunok. 2.krs'),
	('LOC', '114', 'P Vapaakappale Xa tabloid'),
	('LOC', '115', 'P Lyhytlainakurssikirjat'),
	('LOC', '117', 'P Yleiskok Varastokirjat'),
	('LOC', '128', 'P Yleiskok. Käsik. var'),
	('LOC', '119', 'P Yleiskok Varastolehdet'),
	('LOC', '120', 'P Pihkalan kokoelma'),
	('LOC', '121', 'P Vapaakappalekokoelma'),
	('LOC', '122', 'P Fennica piennumerus'),
	('LOC', '190', 'Internet-yhteys'),
	('LOC', '191', 'Ebook Central'),
	('LOC', '300', 'Tietokannat'),
	('LOC', '301', 'P Sanomalehdet Kanavuori'),
	('LOC', '350', 'P Tilatut kotim sanomaleh'),
	('LOC', '609', 'Kanavuoren gradut'),
	('LOC', '1201', 'P Fredriksonin kartat'),
	('LOC', '1600', 'Aallon lukusali'),
	('LOC', '2100', 'VESILINNA. Kirjat'),
	('LOC', '2501', 'Museologia. Kirjat'),
	('LOC', '7000', 'Kultt.hist. museo. Kirjat'),
	('LOC', '303', 'P Lehdet Tupa'),
	('LOC', '1210', 'P Fennica numerus 2010-'),
	('LOC', '1211', 'P Varhaisfennica Arkholvi'),
	('LOC', '1020', 'P Varhaiskirjallisuus'),
	('LOC', '192', 'Ellibs'),
	('LOC', '116', 'P KäsikKurssik'),
	('LOC', '1212', 'P Arkkiveisut'),
	('LOC', '9999', 'Säilytyspaikkahuone 302'),
	('LOC', '9996', 'Säilytyspaikkahuone 204'),
	('LOC', '9997', 'Säilytyspaikkahuone 202'),
	('LOC', '9998', 'Säilytyspaikkahuone 303'),
	('LOC', '1219', 'Digitoidut aineistot'),
	('LOC', '1110', 'e-kurssik'),
	('LOC', '1213', 'P Arkistoholvi'),
	('LOC', '1214', 'P Komiteanmietinnöt'),
	('LOC', '1215', 'P Fennica Mikrokortit'),
	('LOC', '5001', 'P Tabletit'),
	('LOC', '1216', 'P Aikakauslehdet Kanavuor'),
	('LOC', '193', 'JY:n digitoidut aineistot'),
	('LOC', '1220', 'P Fennica lehdet 2017-'),
	('LOC', '9995', 'Gradulokerohuone 302'),
	('LOC', '124', ' EU-kokoelma'),
	('LOC', '6001', 'Chydenius-Inst. Laina'),
	('LOC', '6000', 'Chydenius-Inst LsKirja'),
	('LOC', '6002', 'Chydenius-Inst. Kurssik'),
	('LOC', '2900', 'Yliopiston kielikeskus, kirjat'),
	('LOC', '2200', 'Musiikin lts. LsKirja'),
	('LOC', '2202', 'Musiikin lts. LsMusiikki'),
	('LOC', '2205', 'Musiikin lts. LsPartituuri'),
	('LOC', '2201', 'Musiikin lts. Lainattava'),
	('LOC', '2203', 'Musiikin lts. LsNuotit'),
	('LOC', '2206', 'Musiikin lts. LainaPartituurit'),
	('LOC', '2208', 'Musiikin lts. LsOppikirja'),
	('LOC', '2204', 'Musiikin lts. Nuotit'),
	('LOC', '601', '601 MK Lainattavat'),
	('LOC', '600', 'MK Ls Kirja'),
	('LOC', '821', 'YK FYS Lainattavat'),
	('LOC', '800', 'YK LS Kirja'),
	('LOC', '903', 'YK BIO LsKirja'),
	('LOC', '5558', 'Testikokoelma3'),
	('LOC', '1404', 'Historia Fredrikson'),
	('LOC', '405', 'Frankofonia Kanavuori'),
	('LOC', '1820', 'Hungarologia gradut'),
	('LOC', '1401', 'TAIH Gradu'),
	('LOC', '851', 'YK KEM Lehdet'),
	('LOC', '2300', 'Kielikeskus lehdet'),
	('LOC', '902', 'Ambiotica BIO Lainattavat'),
	('LOC', '8000', 'Poistettu kokoelmista'),
	('LOC', '129', 'P Mikromuoto var'),
	('LOC', '615', 'MK TIE Gradu'),
	('LOC', '614', 'Tietotekn gradut'),
	('LOC', '504', 'Liikunnan gradut 2010-'),
	('LOC', '1830', 'Kirjallisuus gradut'),
	('LOC', '812', 'YK Gradut'),
	('LOC', '1300', 'Rehtori-insituutti gradut'),
	('LOC', 'EI_KOHAAN', 'Ei Kohaan');

DELETE FROM authorised_values WHERE category = 'STATISTIC';

INSERT INTO `authorised_values` (category, authorised_value, lib) VALUES 
    ('STATISTIC', 'I', 'Muiden yliopistojen henkilökunta'),
    ('STATISTIC', 'J', 'Muiden yliopistojen opiskelijat'),
    ('STATISTIC', 'O', 'Ulkomaiset kirjastot'),
    ('STATISTIC', 'R', 'Elinkeinoelämä'),
    ('STATISTIC', 'U', 'Muut asiakkaat'),
    ('STATISTIC', 'J', 'Muiden yliopistojen opiskelijat'),
    ('STATISTIC', 'BT', 'Avoimen yliopiston henkilökunta'),
    ('STATISTIC', 'EH', 'HYTKY opiskelijat'),
    ('STATISTIC', 'EM', 'MTDK opiskelijat'),
    ('STATISTIC', 'EH', 'HYTKY opiskelijat'),
    ('STATISTIC', 'EL', 'LTDK opiskelijat'),
    ('STATISTIC', 'BH', 'HYTKY henkilökunta'),
    ('STATISTIC', 'ES', 'EDUPSY opiskelijat'),
    ('STATISTIC', 'ET', 'Avoimen yliopiston opiskelijat'),
    ('STATISTIC', 'EJ', 'JSBN opiskelijat'),
    ('STATISTIC', 'BM', 'MTDK henkilökunta'),
    ('STATISTIC', 'EI', 'ITDK opiskelijat'),
    ('STATISTIC', 'BI', 'ITDK henkilökunta'),
    ('STATISTIC', 'N', 'Kotimaiset kirjastot'),
    ('STATISTIC', 'BE', 'Erillislaitosten henkilökunta'),
    ('STATISTIC', 'G', 'Ammattikorkeakoulut'),
    ('STATISTIC', 'BS', 'EDUPSY henkilökunta'),
    ('STATISTIC', 'BH', 'HYTKY henkilökunta'),
    ('STATISTIC', 'BL', 'LTDK henkilökunta'),
    ('STATISTIC', 'BJ', 'JSBE henkilökunta'),
    ('STATISTIC', 'S', 'Julkishallinto'),
    ('STATISTIC', 'EH', 'HYTKY opiskelijat'),
    ('STATISTIC', 'BH', 'HYTKY henkilökunta'),
    ('STATISTIC', 'ES', 'EDUPSY opiskelijat'),
    ('STATISTIC', 'BS', 'EDUPSY henkilökunta');

UNLOCK TABLES;