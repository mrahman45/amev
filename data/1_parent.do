
cd "D:\F\job\nafi\2021\icddrb\amev\data"
use  parental_linked_matched_final_08Feb2022.dta,clear


gen id_n=_n



* #############################################################
* ################ variable creation: mother ##################
* #############################################################
// mother's date of birth (from dss)
gen mdob_dss_y=substr(mdob_dss,-2,.)
gen mdob_dss_m=substr(mdob_dss,-6,.)
replace mdob_dss_m=substr(mdob_dss_m,1,3)

destring mdob_dss_y,replace
replace mdob_dss_y=1900+mdob_dss_y

gen     mdob_dss_m2=1  if mdob_dss_m=="Jan"
replace mdob_dss_m2=2  if mdob_dss_m=="Feb"
replace mdob_dss_m2=3  if mdob_dss_m=="Mar"
replace mdob_dss_m2=4  if mdob_dss_m=="Apr"
replace mdob_dss_m2=5  if mdob_dss_m=="May"
replace mdob_dss_m2=6  if mdob_dss_m=="Jun"
replace mdob_dss_m2=7  if mdob_dss_m=="Jul"
replace mdob_dss_m2=8  if mdob_dss_m=="Aug"
replace mdob_dss_m2=9  if mdob_dss_m=="Sep"
replace mdob_dss_m2=10 if mdob_dss_m=="Oct"
replace mdob_dss_m2=11 if mdob_dss_m=="Nov"
replace mdob_dss_m2=12 if mdob_dss_m=="Dec"

gen mdob_dss_cmc=12*(mdob_dss_y-1800) + mdob_dss_m2 


// mother's date of death (mdod) in months (from dss) 
gen mlastout_dss_d=substr(mlastout_dss_str,1,2)
gen mlastout_dss_m=substr(mlastout_dss_str,3,3)
gen mlastout_dss_y=substr(mlastout_dss_str,6,4)
destring mlastout_dss_y,replace

gen mlastout_dss_m2=01 if mlastout_dss_m=="jan"
replace mlastout_dss_m2=02 if mlastout_dss_m=="feb"
replace mlastout_dss_m2=03 if mlastout_dss_m=="mar"
replace mlastout_dss_m2=04 if mlastout_dss_m=="apr"
replace mlastout_dss_m2=05 if mlastout_dss_m=="may"
replace mlastout_dss_m2=06 if mlastout_dss_m=="jun"
replace mlastout_dss_m2=07 if mlastout_dss_m=="jul"
replace mlastout_dss_m2=08 if mlastout_dss_m=="aug"
replace mlastout_dss_m2=09 if mlastout_dss_m=="sep"
replace mlastout_dss_m2=10 if mlastout_dss_m=="oct"
replace mlastout_dss_m2=11 if mlastout_dss_m=="nov"
replace mlastout_dss_m2=12 if mlastout_dss_m=="dec"

gen mdod_dss=12*(mlastout_dss_y-1800) + mlastout_dss_m2
* This is actually the lastout date, if we put condition status=death then it is the date of death 

// mother's age at death (from dss)
gen mad_dss= int((mdod_dss - mdob_dss_cmc)/12)
label variable mad_dss "Mother's age at death (DSS)"

// mother's current status (from dss)
gen mstatus_dss2=1 if moutcause_dss!=""
                replace mstatus_dss2=2 if moutcause_dss>="801" & moutcause_dss<="899"
                                la def mstatus_dss2 1 "Death" 2 "Mig.-out"
                                la val mstatus_dss2 mstatus_dss2
                                lab var mstatus_dss2 "Type of migration-out"



// mother's age at death (from survey)
gen mad_sur=ps5 if ps5<200
label variable mad_sur "Mother's age at death survey"



// Difference in mother's age at death
gen mad_diff= mad_dss - mad_sur 							
label variable mad_diff "Difference in mother's age at death (DSS - Survey)"



// survey date
gen ifvd_y=substr(ifvd,1,4)
gen ifvd_m=substr(ifvd,6,2)  // will seperate 2 characters starting from 6th character
destring ifvd_*, replace
gen sd=12*(ifvd_y-1800) + ifvd_m 


// how many years ago mother died (from survey) 								
gen md_dur_sur= ps4 if ps4 <200


// how many months ago mother died (from survey) 								
gen md_dur_sur2= ps4*12 if ps4 <200


// mother's date of death (mdod) in months (from survey)
gen mdod_sur= sd-md_dur_sur2


// how many years ago mother died (from dss) 								
gen md_dur_dss = int((sd - mdod_dss)/12)
recode md_dur_dss (0/4=1 "0-4")(5/9=2 "5-9")(10/14=3 "10-14")(15/19=4 "15-19")(20/max=5 "20+"), gen(md_dur_dss5)

// Survey death + dss death
gen m_reg=1 if (ps2==2 & mstatus_dss2==1)
tab m_reg




* #####################################################
* ################ anomalies: mother ##################
* #####################################################
// Survey alive DSS death(sadd): Died before survey is error
gen mstatus_sadd=1 if (ps2==1 & mstatus_dss2==1) & (sd < mdod_dss)
replace mstatus_sadd=2 if (mstatus_sadd==.) & (ps2==1 & mstatus_dss2==1) & (sd > mdod_dss) 
lab def mstatus_sadd 1 "Died after survey" 2 "Died before survey"
lab val mstatus_sadd mstatus_sadd								
lab var mstatus_sadd "Survey alive DSS death"
tab mstatus_sadd


// Survey death DSS migration(sddm): Died before migration out is error
gen mstatus_sddm=1 if (ps2==2 & mstatus_dss2==2) & (mdod_sur > mdod_dss) & mdod_sur!=. 
replace mstatus_sddm=2 if (mstatus_sddm==.) & (ps2==2 & mstatus_dss2==2) & (mdod_sur < mdod_dss)

lab def mstatus_sddm 1 "Died after mig." 2 "Died before mig."								
lab val mstatus_sddm mstatus_sddm
lab var mstatus_sddm "Survey death DSS mig"
tab mstatus_sddm



* #############################################################
* ################ variable creation: father ##################
* #############################################################

// father's date of birth (from dss)
gen fdob_dss_y=substr(fdob_dss,8,4)
replace fdob_dss_y="." if fdob_dss_y=="d"
destring fdob_dss_y,replace


gen fdob_dss_m=substr(fdob_dss,4,3)
gen     fdob_dss_m2=1  if fdob_dss_m=="Jan"
replace fdob_dss_m2=2  if fdob_dss_m=="Feb"
replace fdob_dss_m2=3  if fdob_dss_m=="Mar"
replace fdob_dss_m2=4  if fdob_dss_m=="Apr"
replace fdob_dss_m2=5  if fdob_dss_m=="May"
replace fdob_dss_m2=6  if fdob_dss_m=="Jun"
replace fdob_dss_m2=7  if fdob_dss_m=="Jul"
replace fdob_dss_m2=8  if fdob_dss_m=="Aug"
replace fdob_dss_m2=9  if fdob_dss_m=="Sep"
replace fdob_dss_m2=10 if fdob_dss_m=="Oct"
replace fdob_dss_m2=11 if fdob_dss_m=="Nov"
replace fdob_dss_m2=12 if fdob_dss_m=="Dec"

gen fdob_dss_cmc=12*(fdob_dss_y-1800) + fdob_dss_m2 


// father's date of death (fdod) in months (from dss) 
gen flastout_dss_y=substr(flastout_dss_str,6,4)
destring flastout_dss_y,replace

gen flastout_dss_m=substr(flastout_dss_str,3,3)

gen flastout_dss_m2=01 if flastout_dss_m=="jan"
replace flastout_dss_m2=02 if flastout_dss_m=="feb"
replace flastout_dss_m2=03 if flastout_dss_m=="mar"
replace flastout_dss_m2=04 if flastout_dss_m=="apr"
replace flastout_dss_m2=05 if flastout_dss_m=="may"
replace flastout_dss_m2=06 if flastout_dss_m=="jun"
replace flastout_dss_m2=07 if flastout_dss_m=="jul"
replace flastout_dss_m2=08 if flastout_dss_m=="aug"
replace flastout_dss_m2=09 if flastout_dss_m=="sep"
replace flastout_dss_m2=10 if flastout_dss_m=="oct"
replace flastout_dss_m2=11 if flastout_dss_m=="nov"
replace flastout_dss_m2=12 if flastout_dss_m=="dec"

gen fdod_dss=12*(flastout_dss_y-1800) + flastout_dss_m2 if flastout_dss_y<3000
* This is actually the lastout date, if we put condition status=death then it is the date of death

// father's age at death (from dss)
gen fad_dss= int((fdod_dss - fdob_dss_cmc)/12)
label variable fad_dss "Father's age at death (DSS)"


// father's current status (from dss)
gen fstatus_dss2=1 if foutcause_dss!=""
                replace fstatus_dss2=2 if foutcause_dss>="801" & foutcause_dss<="899"
                                lab def fstatus_dss2 1 "Death" 2 "Mig.-out"
                                lab val fstatus_dss2 mstatus_dss2
                                lab var fstatus_dss2 "Type of migration-out"


// father's age at death (from survey)
gen fad_sur=ps10 if ps10<200
label variable fad_sur "Father's age at death survey"



// Difference in mother's age at death
gen fad_diff= fad_dss - fad_sur 							
label variable fad_diff "Difference in father's age at death (DSS - Survey)"


// how many years ago father died (from survey) 								
gen fd_dur_sur= ps9 if ps9 <200


// how many months ago father died (from survey) 								
gen fd_dur_sur2= ps9*12 if ps9 <200


// father's date of death (fdod) in months (from survey)
gen fdod_sur= sd-fd_dur_sur


// how many years ago father died (from dss) 								
gen fd_dur_dss = int((sd - fdod_dss)/12)
recode fd_dur_dss (0/4=1 "0-4")(5/9=2 "5-9")(10/14=3 "10-14")(15/19=4 "15-19")(20/max=5 "20+"), gen(fd_dur_dss5)

// Survey death + dss death
gen f_reg=1 if (ps7==2 & fstatus_dss2==1)
tab f_reg


* #####################################################
* ################ anomalies: father ##################
* #####################################################
// Survey alive DSS death(sadd): Died before survey is error
gen fstatus_sadd=1 if (ps7==1 & fstatus_dss2==1) & (sd <= fdod_dss)
replace fstatus_sadd=2 if (fstatus_sadd==.) & (ps7==1 & fstatus_dss2==1) & (sd > fdod_dss) 

lab def fstatus_sadd 1 "Died after survey" 2 "Died before survey"
lab val fstatus_sadd fstatus_sadd								
lab var fstatus_sadd "Survey alive DSS death"
tab fstatus_sadd


// Survey death DSS migration(sddm): Died before migration out is error
gen fstatus_sddm=1 if (ps7==2 & fstatus_dss2==2) & (fdod_sur >= fdod_dss) & fdod_sur!=. 
replace fstatus_sddm=2 if (fstatus_sddm==.) & (ps7==2 & fstatus_dss2==2) & (fdod_sur < fdod_dss)

lab def fstatus_sddm 1 "Died after mig." 2 "Died before mig."								
lab val fstatus_sddm fstatus_sddm
lab var fstatus_sddm "Survey death DSS mig"
tab fstatus_sddm
br fstatus_sddm ps7 fstatus_dss2 fdod_sur fdod_dss if ps7==2 & fstatus_dss2==2


save parental_linked_matched_final_09Feb2022.dta, replace













* ########################################
* ########### Results ####################
* ########################################
use parental_linked_matched_final_09Feb2022.dta,clear
keep if m_reg==1 & mmatch3<=1
keep mad_sur mad_dss mad_diff md_dur_sur md_dur_dss md_dur_dss5 d101a d105 d106 d107

gen parent="Mother"
rename d101a sex
rename mad_sur ad_sur
rename mad_dss ad_dss 
rename mad_diff ad_diff
rename md_dur_sur d_dur_sur 
rename md_dur_dss d_dur_dss
rename md_dur_dss5 d_dur_dss5
save mother1,replace


use parental_linked_matched_final_09Feb2022.dta,clear
keep if f_reg==1 & fmatch3<=1
keep fad_sur fad_dss fad_diff fd_dur_sur fd_dur_dss fd_dur_dss5 d101a d105 d106 d107
gen parent="Father"
rename d101a sex
rename fad_sur ad_sur
rename fad_dss ad_dss 
rename fad_diff ad_diff
rename fd_dur_sur d_dur_sur 
rename fd_dur_dss d_dur_dss
rename fd_dur_dss5 d_dur_dss5
save father1,replace


use mother1,clear
append using father1

recode ad_diff(0=0 "0")(-5/-1=1 "[-5,-1]")(1/5=2 "[1,5]")(-10/-6=3 "[-10,-6]")(6/10=4 "[6,10]")(-20/-11=5 "[-20,-11]")(11/20=6 "[11,20]")(min/-21=7 "<=-21")(21/max=8 ">=21"),gen(ad_diff8)
drop if ad_diff8==.
recode ad_diff(0=0 "0")(-5/-1=1 "[-5,-1]")(1/5=2 "[1,5]")(min/-6=3 "[-inf,-6]")(6/max=4 "[6,inf]"),gen(ad_diff4)

// age
recode d105 (15/29=1 "15-29")(30/39=2 "30-39")(40/49=3 "40-49")(50/max=4 "50-63"),gen(age)

// education
gen edu=1 if d106==2
replace edu=2 if d107==1
replace edu=3 if d107==2
replace edu=4 if d107==3
lab def edu 1 "No" 2 "Primary" 3 "Secondary" 4 "Higher"
lab val edu edu

recast byte ad_diff8
recast byte ad_diff4
recast byte d_dur_dss5
recast byte edu
recast byte sex

save father_mother1,replace

use father_mother1,clear
encode parent,gen(parent2)
reg ad_diff2 i.parent2 i.d_dur_dss5 i.sex i.age i.edu, cformat(%9.2f) allbase
reg ad_diff2 i.d_dur_dss5#i.parent2 i.sex i.age i.edu, cformat(%9.2f) allbase


graph twoway (scatter mad_sur mad_dss) (lfit mad_sur mad_dss) if m_reg==1 & mmatch2==0
graph twoway (scatter mad_sur mad_dss) (lfit mad_sur mad_dss) if m_reg==1 & mmatch2<=1
graph twoway (scatter mad_sur mad_dss) (lfit mad_sur mad_dss) if m_reg==1 & mmatch2<=2


hist mad_diff if m_reg==1 & mmatch2==0 ,normal 
hist mad_diff if m_reg==1 & mmatch2<=1 ,normal
hist mad_diff if m_reg==1 & mmatch2<=2 ,normal

tab ad_diff8 if sex==1 & parent=="Father"
tab ad_diff8 if sex==1 & parent=="Mother"
tab ad_diff8 if sex==2 & parent=="Father"
tab ad_diff8 if sex==2 & parent=="Mother"

// Father
tab ps7 fstatus_dss2 if fmatch<=2,m   // these 480 are current resident
br fmatch fstatus_dss2 flastout_dss if fstatus_dss2==. & (ps7==1|ps7==2)


graph twoway (scatter fad_sur fad_dss) (lfit fad_sur fad_dss) if f_reg==1 & fmatch<=2

hist fad_diff if f_reg==1 & fmatch<=2 ,normal









tab mad_sur mad_dss

br mdob_dss mlastout_dss ps2 mstatus_dss2 mstatus_sddm ps4 ps5 mmatch if mad_diff< -40


br mothid mname_dss ps1 mdob_dss mlastout_dss ps4 d105 if mad_diff< -20 & m_reg==1


br mothid mname_dss ps1 mdob_dss mlastout_dss ps4 mad_dss mad_sur mstatus_dss mstatus_dss2 mstatus_sddm ps4 ps5 mmatch if mad_diff< -40 & m_reg==1

br mothid mname_dss ps1 mad_diff ps4  mlastout_dss mmatch ps2 mstatus_dss2 

tab 
hist mad_diff if ps4<=5
sum mad_diff,d


hist mad_diff if mmatch==2


tab ps2
tab ps2,m  // who got dots?
tab ps7,m  // who got dots?


tab ps3 if ps2==1,m  // don't know age of alive mother
tab ps8 if ps7==1,m  // don't know age of alive father


tab ps4  // don't know how many years ago mother died
tab ps9  // don't know how many years ago father died


tab ps5   // don't know mother's age at death
tab ps10  // don't know father's age at death




				
								