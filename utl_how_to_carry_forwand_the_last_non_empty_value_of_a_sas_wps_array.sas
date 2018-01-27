StackOverflow SAS: How to carry forward the last non empty value of a SAS or WPS array

  github
  https://goo.gl/rNfNzk
  https://github.com/rogerjdeangelis/utl_how_to_carry_forwand_the_last_non_empty_value_of_a_sas_wps_array

  Two Solutions
     1. Coalesec
     2. cmiss and pokelong (Søren Lassen <000002b7c5cf1459-dmarc-request@listserv.uga.edu>) very fast

  Same resuts in WPS/SAS

    WPS has a big advantage over SAS because SAS typically locksdown pokelong(heavy marketing?).
    SAS promotes supermax lockdown systems with VM solitary confinement as enhancements.
    Even worse becase SAS is increasing the cost of full classic SAS on a workstation, forcing users
    into supermax lockdown systems with VM solitary confinement as enhancements.

see
https://goo.gl/Ebq7tm
https://stackoverflow.com/questions/48473937/how-to-get-last-non-empty-column-of-a-series-from-a-date-set-in-sas

user667489 profile
https://stackoverflow.com/users/667489/user667489

INPUT
=====

  Algorithm
     Carry forward the last non=missing value

  WORK.HAVE total obs=4

     RK     ID      NAME     VALUE_0    VALUE_1    VALUE_2    VALUE_3    VALUE_4

     1     one      one       val_0      val_1      val_2      val_3
     2     two      two       val_0      val_1      val_2
     3     three    three     val_0
     4     four     four      val_0      val_1

 RULES
 =====
 WORK.WANT total obs=4

   RK    ID      NAME     VALUE

   1    one      one      val_3   * last non missing;
   2    two      two      val_2   * last non missing;
   3    three    three    val_0   ..
   4    four     four     val_1   ..


PROCESS
=======

  1. Coalesec

       data want;
         set have;
         array vs[5] $8 value_4 value_3 value_2 value_1 value_0;
         value = coalescec(of vs[*]);
         keep id name value;
       run;quit;

  2. cmiss and pokelong (Søren Lassen <000002b7c5cf1459-dmarc-request@listserv.uga.edu>)

      %utl_submit_wps64('
      libname wrk sas7bdat "%sysfunc(pathname(work))";
      data wrk.wantwps(rename=value_4=value);;
         set wrk.have;
         array t[*] $5 value_4 value_3 value_2 value_1 value_0;;
          _N_=cmiss(of t[*]);
         if 0<_N_<dim(t) then
              call pokelong (repeat (put (t(_N_+1),$5.), _N_), addrlong(value_4));
         keep id name value_4;
      run;quit;
      ');

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data have;
informat rk ID name value_0 value_1 value_2 value_3 value_4 $5.;
input rk ID name value_0 value_1 value_2 value_3 value_4;
cards4;
1 one one val_0 val_1 val_2 val_3 .
2 two two val_0 val_1 val_2 . .
3 three three val_0 . . . .
4 four four val_0 val_1 . . .
;;;;
run;quit;

*                _
  ___ ___   __ _| | ___  ___  ___ ___  ___
 / __/ _ \ / _` | |/ _ \/ __|/ __/ _ \/ __|
| (_| (_) | (_| | |  __/\__ \ (_|  __/ (__
 \___\___/ \__,_|_|\___||___/\___\___|\___|

;

%utl_submit_wps64('
libname wrk sas7bdat "%sysfunc(pathname(work))";
data wrk.want;
  set wrk.have;
  array vs[5] $8 value_4 value_3 value_2 value_1 value_0;
  value = coalescec(of vs[*]);
  keep id name value;
run;quit;
');

Up to 40 obs WORK.WANT total obs=4

Obs     ID      NAME     VALUE

 1     one      one      val_3
 2     two      two      val_2
 3     three    three    val_0
 4     four     four     val_1

*
 ___  ___  _ __ ___ _ __
/ __|/ _ \| '__/ _ \ '_ \
\__ \ (_) | | |  __/ | | |
|___/\___/|_|  \___|_| |_|

;

* SAS;
* Sorens superfast algorithm in sas;
data want(rename=value_4=value);;
set have;
array t[*] $5 value_4 value_3 value_2 value_1 value_0;;
 _N_=cmiss(of t[*]);
if 0<_N_<dim(t) then
     call pokelong (repeat (put (t(_N_+1),$5.), _N_), addrlong(value_4));
keep id name value_4;
run;quit;


* Sorens superfast algorithm in wps;

%utl_submit_wps64('
libname wrk sas7bdat "%sysfunc(pathname(work))";
data wrk.wantwps(rename=value_4=value);;
   set wrk.have;
   array t[*] $5 value_4 value_3 value_2 value_1 value_0;;
    _N_=cmiss(of t[*]);
   if 0<_N_<dim(t) then
        call pokelong (repeat (put (t(_N_+1),$5.), _N_), addrlong(value_4));
   keep id name value_4;
run;quit;
');

