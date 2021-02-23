data suv_upto_30k;
	set sashelp.cars;
	where type = "SUV" and msrp <= 30000;

run;

/* Formats */
data class_bday;
	set pg1.class_birthdate(drop=age);
	format Birthdate ddmmyyd10.;
	where Birthdate >= "01sep2005"d;
	where sex = "M";
run;

/* Sort */
proc sort data=class_bday out=class_bday_srt;
	by age DESCENDING Height;
run;

/* Remove duplicates */
proc sort data=pg1.class_test3 out=class_test3_clean nodupkey dupout=class_test3_dups;
/*	by name Subject TestScore;*/
	by _all_;
run;

