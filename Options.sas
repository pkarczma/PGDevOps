proc options option=config;
run;

proc options option=fmtsearch value;
run;

LIBNAME test BASE "/opt/sas/Workshop/VALCourseData/CourseDaa/";
