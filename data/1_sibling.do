
cd "D:\F\job\nafi\2021\icddrb\amev\data"
use sibling_matched_final_05Jan2022, clear

* #############################################################
* ################ variable creation ##########################
* #############################################################
// sibling's date of birth (from dss)
gen sdob_dss_y=substr(sib_dob_dss_str,6,4)
destring sdob_dss_y,replace

gen sdob_dss_m=substr(sib_dob_dss_str,3,3)
gen     sdob_dss_m2=1  if sdob_dss_m=="jan"
replace sdob_dss_m2=2  if sdob_dss_m=="feb"
replace sdob_dss_m2=3  if sdob_dss_m=="mar"
replace sdob_dss_m2=4  if sdob_dss_m=="apr"
replace sdob_dss_m2=5  if sdob_dss_m=="may"
replace sdob_dss_m2=6  if sdob_dss_m=="jun"
replace sdob_dss_m2=7  if sdob_dss_m=="jul"
replace sdob_dss_m2=8  if sdob_dss_m=="aug"
replace sdob_dss_m2=9  if sdob_dss_m=="sep"
replace sdob_dss_m2=10 if sdob_dss_m=="oct"
replace sdob_dss_m2=11 if sdob_dss_m=="nov"
replace sdob_dss_m2=12 if sdob_dss_m=="dec"

gen sdob_dss_cmc=12*(sdob_dss_y-1800) + sdob_dss_m2 


// sibling's date of death (mdod) in months (from dss) 
gen slastout_dss_y=substr(sib_lst_out_date_str,6,4)
destring slastout_dss_y,replace

gen slastout_dss_m=substr(sib_lst_out_date_str,3,3)
gen slastout_dss_m2=01 if slastout_dss_m=="jan"
replace slastout_dss_m2=02 if slastout_dss_m=="feb"
replace slastout_dss_m2=03 if slastout_dss_m=="mar"
replace slastout_dss_m2=04 if slastout_dss_m=="apr"
replace slastout_dss_m2=05 if slastout_dss_m=="may"
replace slastout_dss_m2=06 if slastout_dss_m=="jun"
replace slastout_dss_m2=07 if slastout_dss_m=="jul"
replace slastout_dss_m2=08 if slastout_dss_m=="aug"
replace slastout_dss_m2=09 if slastout_dss_m=="sep"
replace slastout_dss_m2=10 if slastout_dss_m=="oct"
replace slastout_dss_m2=11 if slastout_dss_m=="nov"
replace slastout_dss_m2=12 if slastout_dss_m=="dec"

gen sdod_dss=12*(slastout_dss_y-1800) + slastout_dss_m2 if slastout_dss_y<3000
* This is actually the lastout date, if we put condition status=death then it is the date of death 


// sibling's age at death (from dss)
gen sad_dss= int((sdod_dss - sdob_dss_cmc)/12)
label variable sad_dss "Sibling's age at death (DSS)"


// sibling's current status (from dss)
gen sstatus_dss2=1 if sib_lst_out_cause_dss!=""
                replace sstatus_dss2=2 if sib_lst_out_cause_dss>="801" & sib_lst_out_cause_dss<="899"
				replace sstatus_dss2=3 if slastout_dss_y==3000
                                la def sstatus_dss2 1 "Death" 2 "Mig.-out" 3 "Resident"
                                la val sstatus_dss2 sstatus_dss2
                                lab var sstatus_dss2 "Type of migration-out"
								

// sibling's age at death (from survey)
gen sad_sur=mm18 if mm18<200
label variable sad_sur "Mother's age at death survey"



// Difference in sibling's age at death
gen sad_diff= sad_dss - sad_sur 							
label variable sad_diff "Difference in sibling's age at death (DSS - Survey)"



sum sad_diff if ,d
