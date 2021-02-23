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

data cars_avg;
	format mpg_mean 5.2;
	set sashelp.cars;
	mpg_mean = mean(mpg_city, mpg_highway);
run;

data storm_avg;
	set pg1.storm_range;
	wind_avg = mean(of wind1-wind4);
	*wind_avg = mean(of wind:);
run;
