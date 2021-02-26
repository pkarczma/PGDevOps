%let path=/opt/sas/Workshop/danePGDevOps/LWPG1V2/data_old;

libname np_park xlsx "&path/np_info.xlsx";

data parks;
	set np_park.visits(obs=10);
run;

libname np_park clear;

proc import file="&path/np_info.xlsx" out=tab1 dbms=xlsx replace;
	sheet=visits;
run;

proc import file="&path/np_traffic.csv" out=np_traffic dbms=csv replace;
run;

/* 1. 2-35 ex. 2 */
proc import file="&path/np_traffic.csv" out=traffic dbms=csv replace;
	guessingrows = MAX;
run;

proc contents data=traffic;
run;

/* 1. 2-35 ex. 3 */
proc import file="&path/np_traffic.dat" out=traffic2 dbms=dlm replace;
	delimiter = '|';
run;

/* Read file in data step */
data np_traffic;
	infile "&path/np_traffic.csv" firstobs=2 dlm=',';
	input ParkName :$30. UnitCode :$30. ParkType :$30. Region :$30. TrafficCounter :$30. ReportingDate :date9. TrafficCount;
	format ReportingDate ddmmyy10.;
	repDate = intck("month", ReportingDate, today(), 'c');
run;

%let pathPD3 = /opt/sas/Workshop/danePGDevOps/PD3;

data osoby2;
	infile "&pathPD3/osoby2.txt";
	input id 1 height 2-4 weight 5-6 sex $ 7 age 8-9 name $ +1;
run;

data pracownicy;
	infile "&pathPD3/pracownicy.txt";
	input id :1. nazwisko $ :20. imie $ :15. kod $ :2. data :ddmmyy8.;
	input id2 :1. x :4. dataz :ddmmyy8. plec $ :1.;
	format data dataz ddmmyy10.;
	nazwisko = propcase(nazwisko);
	imie = propcase(imie);
	drop id2 x;
run;

data script;
	infile "/opt/sas/Workshop/scripts/lesson4_practice3.sh";
	/* Move buffer to '-' sign */
	*input @'-' a :$100.;
	/* Read full line if it starts with '#' */
	input @'#';
	x = _infile_;
	/* Find word 'back' in each line */
	backup = find(x, "back");
run;

data logfile;
	infile "/opt/sas/Workshop/danePGDevOps/PD3/SASApp_STPServer_2020-01-28_sasapp_18318.log";
	input @"WARN";
	date = substr(_infile_, 1, 10);
	time = substr(_infile_, 12, 8);
	text = substr(_infile_, find(_infile_, " - ") + 3);
run;

data logfile2;
	infile "/opt/sas/Workshop/danePGDevOps/PD3/SASApp_STPServer_2020-01-28_sasapp_18318.log";
	input @"WARN";
	x = _infile_;
	date = input(scan(x, 1, "T"), yymmdd10.);
	time = input(scan(x, 2, "T,"), time8.);
	text = substr(x, find(x, " - ") + 3);
	format date yymmdd10. time time8.;
	drop x;
run;