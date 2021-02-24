/* Selection with where */
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

/* Calculate mean */
data cars_avg;
	format mpg_mean 5.2;
	set sashelp.cars;
	mpg_mean = mean(mpg_city, mpg_highway);
run;

/* Calculate mean in range */
data storm_avg;
	set pg1.storm_range;
	wind_avg = mean(of wind1-wind4);
	*wind_avg = mean(of wind:);
run;

/* Conditional expressions */
data Basic Luxury ExtraLuxury;
	set sashelp.cars;
	length car_category $12;
	if MSRP <= 40000 then do;
		cost_group = 1;
		car_category = "Basic";
		output Basic;
	end;
	else if MSRP <= 60000 then do;
		cost_group = 2;
		car_category = "Luxury";
		output Luxury;
	end;
	else do;
		cost_group = 3;
		car_category = "Extra Luxury";
		output ExtraLuxury;
	end;
run;

/* SQL Join */
proc sql;
	create table class_grades as
	select coalesce(t.name, c.name), sex, age, teacher, grade
		from pg1.class_teachers as t
			full join pg1.class_update as c
		on t.name = c.name;
quit;