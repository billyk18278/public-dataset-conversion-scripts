* Encoding: UTF-8.
*  TCGA-BRCA to RADIOVAL.
*USE nationwidechildrens.org_clinical_patient_brca.xls without modificatio, all fields will be imported as string.
* Remove first two lines.
SELECT IF NOT (bcr_patient_uuid='bcr_patient_uuid').
SELECT IF NOT (bcr_patient_uuid='CDE_ID:').



compute RV.case_origin_url='https://wiki.cancerimagingarchive.net/pages/viewpage.action?pageId=3539225'.
compute RV.tcia_subject_id=RTRIM(LTRIM(bcr_patient_barcode)).

compute RV.age_at_diagnosis=LTRIM(STRING(ABS(Number(birth_days_to,F20))/365,F11.2)).


RECODE Race ('WHITE'='8527') ('BLACK OR AFRICAN AMERICAN'='8516') ('ASIAN'='8515') INTO 
    RV.race. 

RECODE ethnicity ('NOT HISPANIC OR LATINO'='38003564') ('HISPANIC OR LATINO'='38003563')  INTO 
    RV.ethnicity. 


DO IF (CHAR.INDEX(UPCASE(menopause_status),'PRE') > 0).
COMPUTE RV.menopause='4206716'.
ELSE IF (CHAR.INDEX(UPCASE(menopause_status),'POST') > 0).
COMPUTE RV.menopause = '4144036'.
ELSE IF (CHAR.INDEX(UPCASE(menopause_status),'PERI') > 0).
COMPUTE RV.menopause = '4116468'.
END IF.

DO IF (CHAR.INDEX(UPCASE(anatomic_neoplasm_subdivision),'RIGHT') > 0).
COMPUTE RV.laterality='4248990'.
ELSE IF (CHAR.INDEX(UPCASE(anatomic_neoplasm_subdivision),'LEFT') > 0).
COMPUTE RV.laterality = '4197399'.
END IF.



*44497848:Lower-inner quadrant of breast,44497850:Lower-outer quadrant of breast
44497847:Upper-inner quadrant of breast,44497849:Upper-outer quadrant of breast.
EXECUTE.
DELETE VARIABLES RV.location.
STRING RV.location(A255).
compute RV.location='763013'.
DO IF (CHAR.INDEX(anatomic_neoplasm_subdivision,'Upper Outer') > 0).
COMPUTE RV.location=CONCAT(RV.location,'|44497849').
END IF.
DO IF (CHAR.INDEX(anatomic_neoplasm_subdivision,'Upper Inner') > 0).
COMPUTE RV.location = CONCAT(RV.location,'|44497847').
END IF.
DO IF (CHAR.INDEX(anatomic_neoplasm_subdivision,'Lower Outer') > 0).
COMPUTE RV.location = CONCAT(RV.location,'|44497850').
END IF.
DO IF (CHAR.INDEX(anatomic_neoplasm_subdivision,'Lower Inner') > 0).
COMPUTE RV.location = CONCAT(RV.location,'|44497848').
END IF.
COMPUTE RV.location=REPLACE(RV.location,'763013|','').
EXECUTE.

*add to location LEFT OR RIGHT.
DO IF (CHAR.INDEX(UPCASE(anatomic_neoplasm_subdivision),'RIGHT') > 0).
COMPUTE RV.location = CONCAT(RV.location,'4248990|').
ELSE IF (CHAR.INDEX(UPCASE(anatomic_neoplasm_subdivision),'LEFT') > 0).
COMPUTE RV.location = CONCAT(RV.location,'4197399|').
END IF.


RECODE metastatic_tumor_indicator ('NO'='4245698') ('YES'='4245697')  INTO 
    RV.metastasis. 

DO IF (history_neoadjuvant_treatment='No').
compute RV.neoadjuvant_radiotherapy='4188540'.
compute RV.neoadjuvant_chemotherapy='4188540'.
compute RV.neoadjuvant_chemo_medication=''.
compute RV.neoadjuvant_endocrine_therapy='4188540'.
compute RV.neoadjuvant_endocrine_medication=''.
compute RV.neoadjuvant_therapy_response='35912239'.
END IF.

compute   RV.vital_status='45884343'.

compute RV.days_from_diagnosis_to_last_follow_up=LTRIM(last_contact_days_to).


* adjuvant treatment.

RECODE radiation_treatment_adjuvant ('YES'='4188539') ('NO'='4188540') INTO 
    RV.adjuvant_radiotherapy. 
RECODE pharmaceutical_tx_adjuvant ('YES'='4188539') ('NO'='4188540') INTO 
    RV.adjuvant_chemotherapy. 


*4213045: Lumpectomy of breast,  4249113: Modified radical mastectomy,   4066543:Simple mastectomy.

RECODE surgical_procedure_first ('Lumpectomy'='4213045') ('Modified Radical Mastectomy'='4249113')  ('Simple Mastectomy'='4066543')  INTO 
    RV.surgical_procedure. 



RECODE er_status_by_ihc ('Positive'='4167696') ('Negative'='4261933') INTO 
    RV.er. 
RECODE pr_status_by_ihc ('Positive'='4219694') ('Negative'='4261934') INTO 
    RV.pr. 
RECODE her2_status_by_ihc ('Positive'='44790895') ('Negative'='44790896') INTO 
    RV.her2.

DO IF (er_status_by_ihc='Positive' | pr_status_by_ihc='Positive' ).
COMPUTE RV.hr='4216891'.
ELSE IF (er_status_by_ihc='Negative' & pr_status_by_ihc='Negative' ).
COMPUTE RV.hr = '4230400'.
END IF.

* 1634004:AJCC/UICC pathological T1 Category
* 1633722:AJCC/UICC pathological T1a Category,1633693:AJCC/UICC pathological T1b Category,
* 1635017:AJCC/UICC, pathological T1c Category,1634272:AJCC/UICC pathological T1d Category,
* 1634428:AJCC/UICC pathological T1mi Category, 
* 1633978:AJCC/UICC pathological T2 Category,
* 1634597:AJCC/UICC pathological T2a Category,1635575:AJCC/UICC pathological T2b Category,
* 1634503:AJCC/UICC pathological T2c Category,1633278:AJCC/UICC pathological T2d Category,
* 1634406:AJCC/UICC pathological T3 Category,
* 1633288:AJCC/UICC pathological T3a Category,
* 1633406:AJCC/UICC pathological T3b Category,1635027:AJCC/UICC pathological T3c Category,
* 1635377:AJCC/UICC pathological T3d Category,1634025:AJCC/UICC pathological T3e Category.

RECODE ajcc_tumor_pathologic_pt ('T1'='1634004') ('T1b'='1633693') ('T1c'='1635017') ('T2'='1633978') ('T3'='1634406') INTO 
    RV.pT.

*1633527:AJCC/UICC post therapy pathological N0 Category,1635444:AJCC/UICC post therapy pathological N0(i+) Category,
*1634866:AJCC/UICC post therapy pathological N0(mol+) Category,1634158:AJCC/UICC post therapy pathological N0a Category,1634985:AJCC/UICC post therapy pathological N0b Category,.
*1635613:AJCC/UICC pathological N1 Category	,1634206:AJCC/UICC pathological N1a Category	,1633830:AJCC/UICC pathological N1b Category	,1634589:AJCC/UICC pathological N1c Category	,1633502:AJCC/UICC pathological N1mi Category,.
*1633864:AJCC/UICC pathological N2,1633890:AJCC/UICC pathological N2a,1633460:AJCC/UICC pathological N2b,1633301:AJCC/UICC pathological N2c,1635830:AJCC/UICC pathological N2mi,.
*1635706:AJCC/UICC pathological N3 Category,1633401:AJCC/UICC pathological N3a Category,1633384:AJCC/UICC pathological N3b Category,1634305:AJCC/UICC pathological N3c Category,.
*1634916:AJCC/UICC pathological N4 Category,1635170:AJCC/UICC pathological NX Category.

RECODE ajcc_nodes_pathologic_pn ('N0'='1633527') ('N0 (i-)'='1633527') ('N0 (i+)'='1635444') 
     ('N1'='1635613') ('N1a'='1634206') ('N1b'='1633830') ('N1mi'='1633502') 
     ('N2'='1633864') ('N2a'='1633890') 
     ('N3'='1635706') ('N3a'='1633401') ('NX'='1635170') INTO 
    RV.pN.


*1634618:AJCC/UICC pathological M0 Category,1633457:AJCC/UICC pathological M0(i+) Category, 1633421:AJCC/UICC pathological MX Category.
RECODE ajcc_metastasis_pathologic_pm ('M0'='1634618') ('MX'='1633421') ('cM0 (i+)'='1633457') INTO 
    RV.pM.



*44498348:Infiltrating duct carcinoma, NOS,44498367:Lobular carcinoma, NOS, 44502956:Medullary carcinoma, NOS, of breast, NOS.
RECODE histological_type ('Infiltrating Ductal Carcinoma'='44498348') ('Infiltrating Lobular Carcinoma'='44498367') ('Medullary Carcinoma'='44502956') INTO 
    RV.histology.



*calculate RV.subtype:35917481:Combinations of ER, PR, and HER2 Results.

*HR=0.
DO IF (er_status_by_ihc='Negative' & pr_status_by_ihc='Negative'  & her2_status_by_ihc='Negative').
*35937684:        ER Negative, PR Negative, HER2 Negative (Triple Negative).
COMPUTE RV.subtype='35937684'.
ELSE IF (er_status_by_ihc='Negative' & pr_status_by_ihc='Negative'  & her2_status_by_ihc='Positive').
*35935735:ER Negative, PR Negative, HER2 Positive.
COMPUTE RV.subtype = '35935735'.

*Here on HR=1.
ELSE IF (er_status_by_ihc='Negative' & pr_status_by_ihc='Positive'  & her2_status_by_ihc='Negative').
*35932811 ER Negative, PR Positive, HER2 Negative.
COMPUTE RV.subtype = '35932811'.
ELSE IF (er_status_by_ihc='Negative' & pr_status_by_ihc='Positive'  & her2_status_by_ihc='Positive').
*35924419 	ER Negative, PR Positive, HER2 Positive.
COMPUTE RV.subtype = '35924419'.
ELSE IF (er_status_by_ihc='Positive' & pr_status_by_ihc='Negative'  & her2_status_by_ihc='Negative').
*35932950 ER Positive, PR Negative, HER2 Negative.
COMPUTE RV.subtype = '35932950'.
ELSE IF (er_status_by_ihc='Positive' & pr_status_by_ihc='Negative'  & her2_status_by_ihc='Positive').
*35932308 ER Positive, PR Negative, HER2 Positive.
COMPUTE RV.subtype = '35932308'.
ELSE IF (er_status_by_ihc='Positive' & pr_status_by_ihc='Positive'  & her2_status_by_ihc='Negative').
*35927765 ER Positive, PR Positive, HER2 Negative.
COMPUTE RV.subtype = '35927765'.
ELSE IF (er_status_by_ihc='Positive' & pr_status_by_ihc='Positive'  & her2_status_by_ihc='Positive').
*35933051 ER Positive, PR Positive, HER2 Positive.
COMPUTE RV.subtype = '35933051'.
END IF.
    

EXECUTE.