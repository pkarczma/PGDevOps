data np_summary_update;
	set pg1.np_summary;
	keep Reg ParkName DayVisits OtherLodging Acres SqMiles Camping;
	SqMiles = Acres * 0.0015625;
	Camping = OtherCamping + TentCampers + RVCampers + BackcountryCampers;
	format SqMiles Camping comma15.;
run;

data eu_occ_total;
	set pg1.eu_occ;
	Year = input(substr(YearMon, 1, 4), 4.);
	Mon = input(substr(YearMon, 6, 2), 2.);
	ReportDate = mdy(month(Mon), day(1), year(Year));
	Total = Hotel + ShortStay + Camp;
	format Hotel ShortStay Camp Total comma15. ReportDate monyy7.;
	keep Country Year Mon Hotel ShortStay Camp ReportDate Total;
run;

data np_summary2;
	set pg1.np_summary;
	ParkType = scan(ParkName, -1);
	keep Reg Type ParkName ParkType;
run;