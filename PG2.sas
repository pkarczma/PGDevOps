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