* Encoding: UTF-8.
* ISPY2 conversion script.
compute RV.case_origin_url='https://wiki.cancerimagingarchive.net/pages/viewpage.action?pageId=70230072'.
compute RV.tcia_subject_id=CONCAT('ISPY2-',LTRIM(STRING(Patient_ID,F7.0))). 

DO IF ~(SYSMIS(Age_at_Screening)).
compute RV.age_at_diagnosis=LTRIM(STRING(Age_at_Screening,F3.0)).
END IF.

DO IF (CHAR.INDEX(UPCASE(menopausal_status),'PREMENOPAUSAL') > 0).
COMPUTE RV.menopause='4206716'.
ELSE IF (CHAR.INDEX(UPCASE(menopausal_status),'POSTMENOPAUSAL') > 0).
COMPUTE RV.menopause = '4144036'.
ELSE IF (CHAR.INDEX(UPCASE(menopausal_status),'PERIMENOPAUSAL') > 0).
COMPUTE RV.menopause = '4116468'.
END IF.


RECODE Race ('White'='8527') ('Black or African American'='8516') ('Asian'='8515') ('Native '+ 
    'Hawaiian or Pacific Islander'='8557') ('American Indian or Alaska Native'='8567') ('Native '+ 
    'Hawaiian or Other Pacific Islande'='8557') ('Asian,White'='8515|8527') ('Native Hawaiian or '+ 
    'Pacific Islander;White'='8557|8527') ('American Indian or Alaska Native;White'='8567|8527') INTO 
    RV.race. 

RECODE ethnicity ('Not Hispanic or Latino'='38003564') ('Hispanic or Latino'='38003563')  INTO 
    RV.ethnicity. 


* Medication.
compute RV.neoadjuvant_chemo_medication=REPLACE(RTRIM(LTRIM(Arm)),' ','').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'+','|').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'Paclitaxel','1378382').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'Ganitumab','36856365').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'Carboplatin','1344905').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'Corboplatin','1344905').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'ABT888','36848631').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'AMG386','36863101').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'Neratinib','793846').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'Trastuzumab','1387104').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'MK-2206','36852007').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'Ganetespib','36850204').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'Pembrolizumab','45775965').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'Pertuzumab','42801287').
compute RV.neoadjuvant_chemo_medication=REPLACE(RV.neoadjuvant_chemo_medication,'T-DM1','43525787').
 *  all ispy2 participants.

compute RV.neoadjuvant_chemo_medication=CONCAT(RV.neoadjuvant_chemo_medication,'|1310317').

* all on neoadjuvant chemo.

COMPUTE RV.neoadjuvant_chemotherapy='4188539'.

* . ---Medication.

* Pathology report.
DO IF (HR=1).
COMPUTE RV.hr='4216891'.
ELSE IF (HR = 0).
COMPUTE RV.hr = '4230400'.
END IF.

DO IF (HER2=1).
COMPUTE RV.her2='44790895'.
ELSE IF (HER2 = 0).
COMPUTE RV.her2 = '44790896'.
END IF.


*calculate RV.subtype:35917481:Combinations of ER, PR, and HER2 Results.

*HRpos=0.
DO IF (HR=0 & HER2=0).
*35937684:        ER Negative, PR Negative, HER2 Negative (Triple Negative).
COMPUTE RV.subtype='35937684'.
ELSE IF (HR = 0 & HER2=1).
*35935735:ER Negative, PR Negative, HER2 Positive.
COMPUTE RV.subtype = '35935735'.

*Here on HRpos=1
ELSE IF (ERpos = 0 & PgRpos=1 & Her2MostPos=0).
*35932811 ER Negative, PR Positive, HER2 Negative
COMPUTE RV.subtype = '35932811'
ELSE IF (ERpos = 0 & PgRpos=1 & Her2MostPos=1)
*35924419 	ER Negative, PR Positive, HER2 Positive
COMPUTE RV.subtype = '35924419'
ELSE IF (ERpos = 1 & PgRpos=0 & Her2MostPos=0)
*35932950 ER Positive, PR Negative, HER2 Negative
COMPUTE RV.subtype = '35932950'
ELSE IF (ERpos = 1 & PgRpos=0 & Her2MostPos=1)
*35932308 ER Positive, PR Negative, HER2 Positive
COMPUTE RV.subtype = '35932308'
ELSE IF (ERpos = 1 & PgRpos=1 & Her2MostPos=0)
*35927765 ER Positive, PR Positive, HER2 Negative
COMPUTE RV.subtype = '35927765'
ELSE IF (ERpos = 1 & PgRpos=1 & Her2MostPos=1).
*35933051 ER Positive, PR Positive, HER2 Positive
COMPUTE RV.subtype = '35933051'.
END IF.
    
* ---Pathology report.

RECODE pCR (1='35933862') (0='35938553') INTO 
    RV.neoadjuvant_therapy_response. 

EXECUTE.

