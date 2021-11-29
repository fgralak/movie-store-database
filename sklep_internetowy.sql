/* --------------- DROP ALL --------------- */

drop table filmy cascade constraints;
drop table gatunek cascade constraints;
drop table klienci cascade constraints;
drop table magazyn cascade constraints;
drop table produkcja cascade constraints;
drop table zamowienia cascade constraints;
drop table zamowienia_filmy cascade constraints;

/* --------------- TWORZENIE TABEL --------------- */

create table klienci
(
    id_klienta number(6) not null,
    nazwisko varchar2(30) not null,
    imie varchar2(20) not null,
    data_urodzenia date,
    ulica varchar2(30),
    kod_pocztowy number(5),
    miejscowosc varchar2(20),
    nr_telefonu number(9)
);

create table filmy
(
    id_filmu number(6) not null,
    tytul varchar2(50) not null,
    gatunek varchar2(15),
    produkcja varchar2(20),
    rezyser varchar2(30),
    dlugosc number(3),
    nosnik varchar2(10),
    cena number(5,2)
);

create table zamowienia_filmy
(
    id_zamowienia number(6) not null,
    id_filmu number(6) not null,
    ilosc number(3),
    komentarz varchar2(300)
);

create table zamowienia
(
    id_zamowienia number(6) not null,
    id_klienta number(6) not null,
    data_zamowienia date,
    data_wyslania date,
    naleznosc number(6,2)
);

create table magazyn
(
    ulica varchar2(30),
    miejscowosc varchar2(20),
    kod_pocztowy number(5),
    id_filmu number(6) not null,
    ilosc number(5)
);

create table gatunek
(
    nazwa varchar2(15),
    opis varchar2(300)
);

create table produkcja
(
    kraj varchar2(20),
    opis varchar2(200)
);

/* --------------- TWORZENIE KLUCZY GLOWNYCH --------------- */

alter table zamowienia_filmy
add constraint zamowienia_filmy_pk primary key(id_zamowienia, id_filmu);

alter table filmy
add constraint filmy_pk primary key(id_filmu);

alter table zamowienia
add constraint zamowienia_pk primary key(id_zamowienia);

alter table klienci
add constraint klienci_pk primary key(id_klienta);

alter table gatunek
add constraint gatunek_pk primary key(nazwa);

alter table produkcja
add constraint produkcja_pk primary key(kraj);

alter table magazyn
add constraint magazyn_pk primary key(ulica, miejscowosc, id_filmu);

/* --------------- TWORZENIE KLUCZY OBCYCH --------------- */

alter table zamowienia_filmy
add constraint zamowienia_filmy_fk1 foreign key(id_zamowienia)
references zamowienia(id_zamowienia);

alter table zamowienia_filmy
add constraint zamowienia_filmy_fk2 foreign key(id_filmu)
references filmy(id_filmu);

alter table filmy
add constraint filmy_fk1 foreign key(gatunek)
references gatunek(nazwa);

alter table filmy
add constraint filmy_fk2 foreign key(produkcja)
references produkcja(kraj);

alter table zamowienia
add constraint zamowienia_fk1 foreign key(id_klienta)
references klienci(id_klienta);

alter table magazyn
add constraint magazyn_fk1 foreign key(id_filmu)
references filmy(id_filmu);

/* --------------- WPROWADZANIE DANYCH DO MNIEJSZYCH TABEL --------------- */

insert into gatunek values ('Horror', 'Mroczny, straszny, przedstawiajacy przerazajace historie');
insert into gatunek values ('Komedia', 'Zabawne dialogi, luzny klimat, przesmiewczy');
insert into gatunek values ('Przygodowy', 'Opowiada perypetie bohatera, ktoremu towazyszymy podczas przygod');
insert into gatunek values ('Akcji', 'Poscigi, strzelaniny, zabili go i uciekl');
insert into gatunek values ('Thriller', 'Trzymajacy w napieciu, zaskakujace zakonczenie');
insert into gatunek values ('Dokumentalny', 'Przedstawia wycinek historii, dokumentuje jakies wydarzenie');
insert into gatunek values ('Komedia rom.', 'Historie milosne przedstawione w zabawny sposob');
insert into gatunek values ('Dramat', 'Filmy, ktorych nie da sie zakwalifikowac do okreslonych gatunkow filmowych');

insert into produkcja values ('Brytyjska', 'Nakrecony w Wielkiej Brytani');
insert into produkcja values ('Niemiecka', 'Nakrecony w Niemczech');
insert into produkcja values ('Polska', 'Nakrecony w Polsce');
insert into produkcja values ('Portugalska', 'Nakrecony w Portugali');
insert into produkcja values ('Francuska', 'Nakrecony we Francji');
insert into produkcja values ('Rosyjska', 'Nakrecony w Rosji');
insert into produkcja values ('Amerykanska', 'Nakrecony w USA');
insert into produkcja values ('Chinska', 'Nakrecony w Chinach');

/* --------------- GENERATOR DANYCH W TABELI FILMY --------------- */

set serveroutput on format wrapped;
set define off;

DROP SEQUENCE filmy_seq;

CREATE SEQUENCE filmy_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE;
/*CREATE INDEX companies_name_idx ON companies (name); */

CREATE OR REPLACE TRIGGER id_filmu_trigger
BEFORE INSERT ON filmy
FOR EACH ROW
BEGIN
  SELECT filmy_seq.nextval INTO :new.id_filmu FROM dual;
END;
/

DELETE FROM filmy;
--generate data for filmy table

DECLARE
	TYPE TABSTR IS TABLE OF VARCHAR2(50);
	tytul TABSTR;
	qtytul NUMBER(5);
  TYPE GATUNKI IS TABLE OF VARCHAR2(15);
	gatunek GATUNKI;
  random_gat NUMBER(1);
  TYPE PRODUKCJE IS TABLE OF VARCHAR2(20);
	produkcja PRODUKCJE;
  random_prod NUMBER(1);
  rezyser VARCHAR2(30);
  dlugosc NUMBER(3,0);
  TYPE NOSNIKI IS TABLE OF VARCHAR2(10);
  nosnik NOSNIKI;
  random_nos NUMBER(1);
	cena NUMBER(5,2);
BEGIN
	tytul := TABSTR ('Angel Heart', 'Angels & Demons', 'Angels in the Outfield', 'Angels with Dirty Faces', 'Angus, Thongs and Perfect Snogging', 'Angry Birds Movie, The', 'Angry Birds Movie 2, The', 'Animal Farm', 'Animal Crackers', 'Animal House', 'Anna and the King', 'Anna Karenina (2012)', 'Annie (2014 film)', 'Annie', 'Annie Hall', 'Another Cinderella Story', 'Ant Bully, The', 'Antitrust', 'Ant-Man', 'Antz', 'Apocalypse Now', 'Apocalypto', 'Apollo 13', 'Apt Pupil', 'Are We Done Yet?', 'Are We There Yet?', 'Argo (2012)', 'Aristocats, The', 'Armageddon',
            'Around the World in 80 Days', 'Arrival', 'Arsenic and Old Lace', 'Arthur', 'As Good As It Gets', 'Assassination Games', 'Assassination of a High School President', 'Babar: The Movie', 'Babar: King of the Elephants', 'Babe', 'Babe: Pig in the City', 'Babe, The', 'Babylon A.D', 'Bachelor Mother', 'Bachelorette', 'Back to School', 'Back to School with Franklin', 'Back to the Future', 'Back to the Future Part II', 'Back to the Future Part III', 'Backdraft', 'Bad and the Beautiful, The', 'Bad Boys', 'Bad Boys II', 'Bad Day at Black Rock', 'Bad Santa',
            'Bad Taste', 'Badlands', 'Balto', 'Bambi', 'Bambi II', 'Bananas', 'Barbarella', 'Barbecue Brawl', 'Barcelona', 'Barneys Great Adventure', 'Barry Lyndon', 'Barton Fink', 'BASEketball', 'Basic Instinct', 'Basic Instinct 2', 'Batman', 'Batman Begins', 'Batman Forever', 'Batman Returns', 'Batman and Robin', 'Batman v Superman: Dawn of Justice', 'Battle: Los Angeles', 'Battle of San Pietro, The', 'Da Vinci Code, The', 'Daddy Day Camp', 'Daddy Day Care', 'Daffy Duck and the Dinosaur', 'Daffy Ducks Quackbusters', 'Dallas Buyers Club', 'Dan in Real Life',
            'Dance of the Dead', 'Dancer In The Dark', 'Dances with Wolves', 'Dangerous Beauty', 'Daredevil', 'Darjeeling Limited, The', 'Dark City', 'Dark Knight, The', 'Dark Knight Rises, The', 'Dark Passage', 'Dark Side of the Moon, The (1990)', 'Das Boot', 'Das Leben der Anderen', 'Dave', 'Dawn of the Dead (1978)', 'Dawn of the Dead (2004)', 'Day After Tomorrow, The', 'Day at the Races, A', 'Day of the Jackal, The', 'Day the Earth Stood Still, The (1951)', 'Day the Earth Stood Still, The (2008)', 'Daydream Nation', 'Days of Being Wild', 'Days of Thunder',
            'Dazed and Confused', 'DC Super Hero Girls: Intergalactic Games', 'DC Super Hero Girls: Legends of Atlantis', 'DC Super Hero Girls: Super Hero High', 'Dead Alive', 'Dead Man', 'Dead Man Walking', 'Dead Poets Society', 'Dead Zone, The', 'Deadfall', 'Deadpool', 'Deadpool 2', 'Death in Venice', 'Death Becomes Her', 'Death Race', 'Death Rides a Horse', 'Death to Smoochy', 'Death Wish (I-V)', 'D.E.B.S.', 'Dedication', 'Deep Impact', 'Deep Throat', 'Deer Hunter, The', 'Deewar', 'Defending Your Life', 'Defendor', 'Defiance (2008)', 'Dï¿½j? Vu (2006)',
            'Money Pit, The', 'Money Talks', 'Moneyball', 'Mongol', 'Monsters, Inc.', 'Monsters University', 'Monsters vs. Aliens', 'Monty Python and the Holy Grail', 'Moon Child', 'Moonlight', 'Moonlight Mile', 'Moonrise Kingdom', 'Moonstruck', 'Motorcycle Diaries, The', 'Moulin Rouge!', 'Mouse Trouble', 'MouseHunt', 'Movie 43', 'Mozart and the Whale', 'Mr. Beans Holiday', 'Mr. Brooks', 'Mr. Bug Goes to Town', 'Poohs Heffalump Movie', 'Pootie Tang', 'Popeye', 'Porco Rosso', 'Poseidon', 'Poseidon Adventure, The', 'Postman Always Rings Twice, The', 'Powder',
            'Practical Magic', 'Precious: Based on the Novel "Push" by Sapphire', 'Predator', 'Predator 2', 'Prestige, The', 'Presumed Innocent', 'Pretty in Pink', 'Pretty Woman', 'Pride', 'Pride and Prejudice', 'Primal Fear', 'SpongeBob SquarePants Movie, The', 'Spotlight', 'Spy', 'Spy Hard', 'Stage Door', 'Stage Fright', 'Stagecoach', 'Stand and Deliver', 'Stand by Me', 'Stanford Prison Experiment, The', 'Star, The', 'Star is Born, A', 'Star Chamber, The', 'Star Kid', 'Star Trek', 'Toy Story 2', 'Toy Story 3', 'Toy Story That Time Forgot', 'Toy Story Toons',
            'Trading Places', 'Traffic', 'Train, The', 'Training Day', 'Trainspotting', 'Transamerica', 'Transformers', 'Transformers: Age of Extinction', 'Transformers: Dark of the Moon', 'Transformers: Revenge of the Fallen', 'Wild One, The', 'Willow', 'Willy Wonka & the Chocolate Factory', 'Windtalkers', 'Wings of Desire', 'Winnie the Pooh', 'Winters Bone', 'Wishmaster', 'Wishmaster 2: Evil Never Dies', 'Witch, The', 'Witches of Eastwick, The', 'Witchfinder General', 'Withnail and I', 'Without a Paddle', 'Witness', 'Wizard of Oz, The', 'Wizards', 'Wolf Man, The',
            'Wolf of Wall Street, The', 'Wolverine, The', 'Woman in the Window, The', 'Woman of the Year', 'Wonder Boys', 'Working Girl', 'Your Highness', 'Your Name', 'Zack and Miri Make a Porno', 'Zardoz', 'Zathura', 'Zed & Two Noughts, A', 'Zeitgeist: The Movie', 'Zelig', 'Zenon: Girl of the 21st Century', 'Zero Day', 'Zodiac', 'Zombieland', 'Zoolander', 'Zoot Cat, The', 'Zootopia', 'Zorro Rides Again', 'Zorros Fighting Legion', 'Zorro, The Gay Blade', 'Zulu'
            );
    gatunek := GATUNKI ('Horror', 'Komedia', 'Przygodowy', 'Akcji', 'Thriller', 'Dokumentalny', 'Dramat', 'Komedia rom.');
    produkcja := PRODUKCJE ('Brytyjska', 'Niemiecka', 'Polska', 'Portugalska', 'Francuska', 'Rosyjska', 'Amerykanska', 'Chinska');
    nosnik := NOSNIKI ('DVD', 'Blu-ray');
	qtytul := tytul.count;

	FOR i IN 1..qtytul LOOP
        rezyser := dbms_random.string('U', 9);
        cena := dbms_random.value(19,50);
		dlugosc := dbms_random.value(80,200);
        random_gat := dbms_random.value(1,8);
        random_prod := dbms_random.value(1,8);
        random_nos := dbms_random.value(1,2);
		INSERT INTO filmy VALUES (NULL, tytul(i), gatunek(random_gat), produkcja(random_prod), rezyser, dlugosc, nosnik(random_nos), cena);
	END LOOP;
	DBMS_OUTPUT.put_line('All films added.');

END;
/

/* --------------- GENERATOR DANYCH W TABELI KLIENCI --------------- */

set serveroutput on format wrapped;
set define off;

DROP SEQUENCE klienci_seq;

CREATE SEQUENCE klienci_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE;

CREATE OR REPLACE TRIGGER id_klienta_trigger
BEFORE INSERT ON klienci
FOR EACH ROW
BEGIN
  SELECT klienci_seq.nextval INTO :new.id_klienta FROM dual;
END;
/

DELETE FROM klienci;
--generate data for klienci table

DECLARE
	TYPE NAZWISKA IS TABLE OF VARCHAR2(30);
	nazwisko NAZWISKA;
	qnazwisko NUMBER(5);
	TYPE IMIONA IS TABLE OF VARCHAR2(20);
	imie IMIONA;
  qimie NUMBER(5);
    ulica VARCHAR2(30);
    kod_pocztowy NUMBER(5,0);
    miejscowosc VARCHAR2(20);
    nr_telefonu NUMBER(9,0);

BEGIN
	nazwisko := NAZWISKA ('Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzales', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson');
	qnazwisko := nazwisko.count;
    imie := IMIONA ('Emma', 'Olivia', 'Ava', 'Isabella', 'Sophia', 'Liam', 'Noah', 'William', 'James', 'Oliver');
    qimie := imie.count;

  FOR j IN 1..qimie LOOP
	 FOR i IN 1..qnazwisko LOOP
          ulica := dbms_random.string('L',9);
          kod_pocztowy := dbms_random.value(10000,99999);
          miejscowosc := dbms_random.string('U',8);
          nr_telefonu := dbms_random.value(500000000,900000000);
          INSERT INTO klienci VALUES (NULL, nazwisko(i), imie(j), TRUNC(SYSDATE - dbms_random.value(3660,18300)), ulica, kod_pocztowy, miejscowosc, nr_telefonu);
	 END LOOP;
  END LOOP;
	DBMS_OUTPUT.put_line('All klients added.');

END;
/

/* --------------- GENERATOR DANYCH W TABELI ZAMOWIENIA --------------- */

set serveroutput on format wrapped;
set define off;

DROP SEQUENCE zamowienia_seq;

CREATE SEQUENCE zamowienia_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE;

CREATE OR REPLACE TRIGGER id_zamowienia_trigger
BEFORE INSERT ON zamowienia
FOR EACH ROW
BEGIN
  SELECT zamowienia_seq.nextval INTO :new.id_zamowienia FROM dual;
END;
/

DELETE FROM zamowienia;
--generate data for zamowienia table

DECLARE
    id_klienta NUMBER(5);
    naleznosc NUMBER(6,2);

BEGIN

  FOR i IN 1..3000 LOOP
        id_klienta := dbms_random.value(1,300);
        naleznosc := dbms_random.value(50,2000);
	      INSERT INTO zamowienia VALUES (NULL, id_klienta, TRUNC(SYSDATE - dbms_random.value(6,10)), TRUNC(SYSDATE - dbms_random.value(1,5)), naleznosc);
  END LOOP;
	DBMS_OUTPUT.put_line('All zamowienia added.');

END;
/

/* --------------- GENERATOR DANYCH W TABELI MAGAZYN --------------- */

set serveroutput on format wrapped;
set define off;

DELETE FROM magazyn;
--generate data for magazyn table

DECLARE
	TYPE ULICE IS TABLE OF VARCHAR2(30);
	ulica ULICE;
    qulica NUMBER(1);
	TYPE MIEJSCOWOSCI IS TABLE OF VARCHAR2(20);
	miejscowosc MIEJSCOWOSCI;
    TYPE KODY IS TABLE OF NUMBER(5,0);
    kod_pocztowy KODY;
    id_filmu NUMBER(6);
    ilosc NUMBER(5);

BEGIN
	ulica := ULICE ('Podgorska', 'Armi Krajowej', 'Sandomierska', 'Modlinska', 'Arbuzowa');
    miejscowosc := MIEJSCOWOSCI ('Poznan', 'Warszawa', 'Wroclaw', 'Gdansk', 'Krakow');
    kod_pocztowy := KODY (10410, 12345, 25456, 42680, 39823);
    qulica := ulica.count;

    FOR j IN 1..qulica LOOP
        FOR i IN 1..250 LOOP
            ilosc := dbms_random.value(0,1000);
            INSERT INTO magazyn VALUES (ulica(j), miejscowosc(j), kod_pocztowy(j), i, ilosc);
        END LOOP;
    END LOOP;
	DBMS_OUTPUT.put_line('All magazyny added.');

END;
/

/* --------------- GENERATOR DANYCH W TABELI ZAMOWIENIA_FILMY --------------- */

set serveroutput on format wrapped;
set define off;

DROP SEQUENCE zamowienia_filmy_seq;

CREATE SEQUENCE zamowienia_filmy_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE;

CREATE OR REPLACE TRIGGER zamowienia_filmy_trigger
BEFORE INSERT ON zamowienia_filmy
FOR EACH ROW
BEGIN
  SELECT zamowienia_filmy_seq.nextval INTO :new.id_zamowienia FROM dual;
END;
/

DELETE FROM zamowienia_filmy;
--generate data for zamowienia_filmy table

DECLARE
    id_filmu NUMBER(6);
    ilosc NUMBER(3);
    komentarz VARCHAR2(300);

BEGIN

    FOR i IN 1..3000 LOOP
        id_filmu := dbms_random.value(1,5);
        ilosc := dbms_random.value(1,5);
        komentarz := dbms_random.string('L',20);
        INSERT INTO zamowienia_filmy VALUES (NULL, id_filmu, ilosc, komentarz);
    END LOOP;
	DBMS_OUTPUT.put_line('All zamowienia_filmy added.');

END;
/

/* --------------- TRIGGERY --------------- */

CREATE OR REPLACE TRIGGER display_naleznosc_changes 
BEFORE DELETE OR INSERT OR UPDATE ON zamowienia
FOR EACH ROW 
WHEN (NEW.Id_zamowienia > 0) 
DECLARE 
   nal_diff number(6,2); 
BEGIN 
   nal_diff := :NEW.naleznosc  - :OLD.naleznosc; 
   dbms_output.put_line('Old naleznosc: ' || :OLD.naleznosc); 
   dbms_output.put_line('New naleznosc: ' || :NEW.naleznosc); 
   dbms_output.put_line('Naleznosc difference: ' || nal_diff); 
END; 
/

CREATE OR REPLACE TRIGGER max_zamowienie 
BEFORE INSERT OR UPDATE OF ilosc ON zamowienia_filmy
FOR EACH ROW
DECLARE 
   max_ilosc constant number := 5;
BEGIN 
    IF :NEW.ilosc > max_ilosc THEN
    :NEW.ilosc := max_ilosc; 
    dbms_output.put_line('Maksymalna ilosc w jednym zamowieniu wynosi 5 i taka zostala usatwiona'); 
    END IF; 
END; 
/


CREATE OR REPLACE TRIGGER items_in_magazyn
BEFORE INSERT OR UPDATE OF ilosc ON magazyn
FOR EACH ROW 
BEGIN 
    if :NEW.ilosc > 1000 then
    RAISE_APPLICATION_ERROR(-20999,'Nie mozna przechowywac wiecej niz 1000 sztuk jednego filmu w danym magazynie!');
    end if;
END; 
/

CREATE OR REPLACE TRIGGER birth_date
BEFORE INSERT OR UPDATE OF data_urodzenia ON klienci
FOR EACH ROW 
BEGIN 
    if :NEW.data_urodzenia > SYSDATE then
    RAISE_APPLICATION_ERROR(-20999,'Data urodzenia nie moze byc z przyszlosci!');
    end if;
END; 
/

CREATE OR REPLACE TRIGGER data_wyslania_a_zamowienie
BEFORE INSERT OR UPDATE OF data_wyslania ON zamowienia
FOR EACH ROW 
BEGIN 
    if :NEW.data_wyslania < :NEW.data_zamowienia then
    RAISE_APPLICATION_ERROR(-20999,'Data wyslania nie moze byc wczesniejsza niz data zamowienia!');
    end if;
END;
/

update zamowienia
set naleznosc = naleznosc + 300
where id_zamowienia = 1;

update zamowienia_filmy
set ilosc = 6
where id_zamowienia = 2 and id_filmu = 5;

update magazyn
set ilosc = 1001
where ulica = 'Arbuzowa' and miejscowosc = 'Krakow' and id_filmu = 19;

update klienci
set data_urodzenia = SYSDATE + 1
where id_klienta = 1;

update zamowienia
set data_wyslania = data_zamowienia - 1
where id_zamowienia = 1;


/* --------------- ZAPYTANIA --------------- */

--having

--zapytanie zwraca tytul filmu i ilosc kopii jaka znajduje sie w wszystkich magazynach, jezeli ich ilosc przekracza 2000

select tytul, sum(ilosc)
from filmy natural join magazyn
group by tytul
having sum(ilosc) > 2000
order by sum(ilosc) desc;

--group by

--zapytanie zwraca imie, nazwisko oraz ilosc zamowien, jezeli srednia cena zamowien wyniosla wiecej niz 1500

select nazwisko, imie, count(id_zamowienia)
from klienci natural join zamowienia
group by nazwisko, imie
having avg(naleznosc) > 1500
order by count(id_zamowienia) desc;

--podzapytania

--zapytanie zwraca id_filmu oraz tytul, jezeli gatunek filmu to komedia i jego cena jest wyzsza niz srednia cena filmow komediowych

select id_filmu, tytul 
from filmy 
where gatunek = 'Komedia' and cena > 
            (select avg(cena) from filmy
             where gatunek = 'Komedia')
order by id_filmu asc;

--funkcje obliczajace

--zapytanie zwraca zaokraglona srednia wartosc filmow sprzedawanych na nosnikach Blue-ray

select round(avg(dlugosc),0)
from filmy
where nosnik = 'Blu-ray';

/* --------------- OPTYMALIZACJA INDEKSY --------------- */

drop index zam_idx1;
create index zam_idx1 on zamowienia(id_klienta);

drop index zam_idx2;
create index zam_idx2 on zamowienia(id_klienta, id_zamowienia);

alter index zamowienia_pk visible;
alter index zam_idx1 visible;
alter index zam_idx2 visible;

EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('sklep','zamowienia');

--index dla jednego wiersza na wyjœciu

explain plan for
select id_klienta from zamowienia where id_zamowienia = 100 order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia where id_zamowienia = 100 order by 1;

--index dla nie wiêcej ni¿ 40% wierszy na wyjœciu

explain plan for
select id_klienta from zamowienia where id_zamowienia between 1 and 1199 order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia where id_zamowienia between 1 and 1199;   -- 0,40

--przy wypisywaniu calej tabeli

explain plan for
select id_klienta from zamowienia order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia order by 1;


alter index zamowienia_pk invisible;
alter index zam_idx1 visible;
alter index zam_idx2 visible;

--index dla jednego wiersza na wyjœciu

explain plan for
select id_klienta from zamowienia where id_zamowienia = 100 order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia where id_zamowienia = 100 order by 1;

--index dla nie wiêcej ni¿ 40% wierszy na wyjœciu

explain plan for
select id_klienta from zamowienia where id_zamowienia between 1 and 1199 order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia where id_zamowienia between 1 and 1199;   -- 0,40

--przy wypisywaniu calej tabeli

explain plan for
select id_klienta from zamowienia order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia order by 1;


alter index zamowienia_pk invisible;
alter index zam_idx1 invisible;
alter index zam_idx2 visible;

--index dla jednego wiersza na wyjœciu

explain plan for
select id_klienta from zamowienia where id_zamowienia = 100 order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia where id_zamowienia = 100 order by 1;

--index dla nie wiêcej ni¿ 40% wierszy na wyjœciu

explain plan for
select id_klienta from zamowienia where id_zamowienia between 1 and 1199 order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia where id_zamowienia between 1 and 1199;   -- 0,40

--przy wypisywaniu calej tabeli

explain plan for
select id_klienta from zamowienia order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia order by 1;

alter index zamowienia_pk visible;
alter index zam_idx1 visible;
alter index zam_idx2 invisible;

--index dla jednego wiersza na wyjœciu

explain plan for
select id_klienta from zamowienia where id_zamowienia = 100 order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia where id_zamowienia = 100 order by 1;

--index dla nie wiêcej ni¿ 40% wierszy na wyjœciu

explain plan for
select id_klienta from zamowienia where id_zamowienia between 1 and 1199 order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia where id_zamowienia between 1 and 1199;   -- 0,40

--przy wypisywaniu calej tabeli

explain plan for
select id_klienta from zamowienia order by 1;
select *
from table (dbms_xplan.display);
select count(*)/3001 from zamowienia order by 1;

/* --------------- HINTY --------------- */

execute dbms_stats.gather_table_stats ('sklep','zamowienia');
execute dbms_stats.gather_table_stats ('sklep','klienci');
execute dbms_stats.gather_table_stats ('sklep','filmy');
execute dbms_stats.gather_table_stats ('sklep','gatunek');

drop index kli_idx1;
create index kli_idx1 on klienci(id_klienta ,nazwisko, imie);
drop index fil_idx2;
create index fil_idx2 on filmy(id_filmu, tytul);

alter index kli_idx1 visible;
alter index fil_idx2 visible;

--hash join

explain plan for
select id_zamowienia, k.id_klienta, nazwisko, imie from zamowienia z join klienci k on (z.id_klienta = k.id_klienta) where z.naleznosc >= 500 and z.naleznosc <= 1000;
select * from table (dbms_xplan.display);

explain plan for
select /*+ use_merge(z, k)*/ id_zamowienia, k.id_klienta, nazwisko, imie from zamowienia z join klienci k on (z.id_klienta = k.id_klienta) where z.naleznosc >= 500 and z.naleznosc <= 1000;
select * from table (dbms_xplan.display);

explain plan for
select /*+ use_nl(z, k)*/ id_zamowienia, k.id_klienta, nazwisko, imie from zamowienia z join klienci k on (z.id_klienta = k.id_klienta) where z.naleznosc >= 500 and z.naleznosc <= 1000;
select * from table (dbms_xplan.display);

--nested loop

explain plan for
select id_filmu, tytul, g.opis from filmy f join gatunek g on (f.gatunek = g.nazwa) where gatunek = 'Komedia';
select * from table (dbms_xplan.display);

explain plan for
select /*+ use_merge(z, k)*/ id_filmu, tytul, g.opis from filmy f join gatunek g on (f.gatunek = g.nazwa) where gatunek = 'Komedia';
select * from table (dbms_xplan.display);

explain plan for
select /*+ use_hash(z, k)*/ id_filmu, tytul, g.opis from filmy f join gatunek g on (f.gatunek = g.nazwa) where gatunek = 'Komedia';
select * from table (dbms_xplan.display);


--merge join

explain plan for
select id_zamowienia, k.id_klienta, nazwisko, imie from zamowienia z join klienci k on (z.id_klienta > k.id_klienta) where z.naleznosc >= 500 and z.naleznosc <= 1000;
select * from table (dbms_xplan.display);

explain plan for
select /*+ use_nl(z, k)*/ id_zamowienia, k.id_klienta, nazwisko, imie from zamowienia z join klienci k on (z.id_klienta > k.id_klienta) where z.naleznosc >= 500 and z.naleznosc <= 1000;
select * from table (dbms_xplan.display);

explain plan for
select /*+ use_hash(z, k)*/ id_zamowienia, k.id_klienta, nazwisko, imie from zamowienia z join klienci k on (z.id_klienta > k.id_klienta) where z.naleznosc >= 500 and z.naleznosc <= 1000;
select * from table (dbms_xplan.display);
