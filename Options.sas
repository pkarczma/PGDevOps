proc options option=config;
run;

proc options option=fmtsearch value;
run;

LIBNAME test BASE "/opt/sas/Workshop/VALCourseData/CourseData/";

/* Show current user */
%put &=sysuserid;

proc print data=test1.customer_dim(obs=10);
run;

proc print data=test2.customer_dim(obs=10);
run;

/* Copy library to new location */
libname dane '/opt/sas/Workshop/data';

*proc copy in=test2 out=dane noclone;
*run;

data dane.customer_dim;
	set dane.customer_dim;
	drop Customer_Gender Customer_FirstName;
run;

libname oralib oracle path=orcl schema=student user=student password=xxx;

LIBNAME oralib ORACLE  PATH=orcl  SCHEMA=student  USER=student  PASSWORD="{SAS002}B538F01843669287" ;