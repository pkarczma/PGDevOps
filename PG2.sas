data storm_summary;
	set pg2.storm_summary(obs=5);
	duration = EndDate - StartDate;
	*putlog "ERROR: duration=" duration;
	*putlog "WARNING: " duration=;
	putlog _all_;
run;

data camping(drop=LodgingOther) lodging(drop=CampTotal);
	set pg2.np_2017;
	CampTotal = sum(of Camping:);
	format CampTotal comma10.;
	if CampTotal > 0 then output camping;
	if LodgingOther > 0 then output lodging;
	keep ParkName Month DayVisits CampTotal LodgingOther;
run;

data quiz;
	set pg2.class_quiz;
	avgQuiz = mean(of q:);
	*drop Quiz1-Quiz5;
	format _numeric_ 4.1;
	format Quiz3--avgQuiz 4.2;
run;

data quiz;
	set pg2.class_quiz;
	putlog "NOTE: before";
	putlog _all_;
	call sortn(of Q:);
	putlog "NOTE: after";
	putlog _all_;
	if mean(of Q:) < 7 then
		call missing(of _all_);
run;

data quiz;
	set pg2.class_quiz;
	quiz1st = largest(1, of quiz1-quiz5);
	quiz2nd = largest(2, of quiz1-quiz5);
	avgBest = mean(quiz1st, quiz2nd);
	studentId = rand('integer', 100, 999);
	avg = round(mean(of quiz1-quiz5));
run;

data test;
	a = "abc ";
	call missing(a);
	l1 = length(a);
	l2 = lengthc(a);
	l3 = lengthn(a);
run;

data test;
	length firstname secondname lastname $20;
	firstname = "Oscar";
	secondname = "Gonzalez";
	lastname = "Lopez";
	fullname = cat(firstname, secondname, lastname);
	fullname2 = firstname !! secondname || lastname;
	fullname3 = catx(" ", firstname, secondname, lastname);
run;

options locale=pl_pl;
data stocks2;
	set pg2.stocks2(rename=(Date=DateOld High=HighOld Volume=VolumeOld));
	Date = input(DateOld, date9.);
	High = input(HighOld, best12.);
	Volume = input(VolumeOld, comma12.);
	format Date ddmmyy10. Volume nlnum12.;
	drop DateOld HighOld VolumeOld;
run;

data stocks3;
	set stocks2;
	value_pln = put(Volume, nlmny15.2);
run;

/* Copy data from sashelp.class to work.class
*  Append pg2.class_new to work.class */
proc copy in=sashelp out=work;
	select class; /* use exclude instead to copy everything except listed datasets */
run;

data class;
	length name $9;
	set sashelp.class;
run;

proc append base=class data=pg2.class_new;
run;

proc append base=class data=pg2.class_new2(rename=(student=name));
run;

/* Create empty table (no rows) but with PDV vector of columns */
data class2;
	if 0 then do;
		set sashelp.class;
		output;
	end;
run;

/* Same as above but use SQL */
proc sql;
	create table class2 like sashelp.class;
quit;

/* Merge data (must be sorted to use 'by') */
data class_grades;
	merge pg2.class_update(in=c) pg2.class_teachers(in=t);
	by name;
	if c = 1 and t = 1;
	/* Same as above but shorter */
	*if c = t;
run;

/* Loops */
data doLoop;
	do i=1 to 10 /*by 2*/;
		rand = rand("integer", 1, 100);
		output;
	end;
run;

data doWhile;
	do while(i <= 10);
		rand = rand("integer", 1, 100);
		output;
	end;
run;