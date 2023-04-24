* Encoding: UTF-8.
*  DUKEto RADIOVAL.
*USE Clinical_and_Other_Features.xlsx delete lines 1 and 3.
* add RV fields.
* apply script.


compute RV.case_origin_url='https://wiki.cancerimagingarchive.net/pages/viewpage.action?pageId=70226903'.
compute RV.tcia_subject_id=RTRIM(LTRIM(PatientID)).
compute RV.other_subject_id=''.
compute RV.age_at_diagnosis=LTRIM(STRING(ABS(DateofBirthDays)/365,F11.2)).

*multi race without definition assigned to not provided.
*hispanic on race assigned on white.

RECODE RaceandEthnicity (1='8527') (5='8527') (2='8516') (3='8515') (7='8557') (4='8657') (8='8657')  INTO 
    RV.race. 

DO IF (RaceandEthnicity=5).
compute RV.ethnicity='38003563'. 
ELSE IF ((RaceandEthnicity~=0)|(RaceandEthnicity~=6)).
compute RV.ethnicity='38003564'. 
END IF.

RECODE Menopauseatdiagnosis (0='4206716') (1='4144036')  INTO 
    RV.menopause. 

*1635661:AJCC/UICC clinical T1 Category,.
*1635033:AJCC/UICC clinical T2 Category,.
*1635895:AJCC/UICC clinical T3 Category,.
*1635558:AJCC/UICC clinical T4 Category.
RECODE StagingTumorSize#T (1='1635661') (2='1635033') (3='1635895') (4='1635558') INTO 
    RV.cT.

*1634145:AJCC/UICC clinical N0 Category,1635729:AJCC/UICC clinical N1 Category,.
*1634523:AJCC/UICC clinical N2 Category,.
* 1633914:AJCC/UICC clinical N3 Category,1633862:AJCC/UICC clinical N4 Category.
RECODE StagingNodes#Nxreplacedby1N (1='1635729') (2='1634523') (3='1633914') (0='1634145') INTO 
    RV.cN.

*1635085:AJCC/UICC clinical M1 Category,.
*1635291:AJCC/UICC clinical M0 Category,.
*1634755:AJCC/UICC clinical MX Category.

RECODE StagingMetastasis#Mxreplacedby1M (1='1635085') (-1='1634755') (0='1635291') INTO 
    RV.cM.

*4273543:Both breasts,4248990:Right breast structure,4197399:Left breast structure.
DO IF (BilateralInformation='1').
compute RV.laterality='4273543'.
else if (TumorLocation='L').
compute RV.laterality='4197399'.
else if (TumorLocation='R').
compute RV.laterality='4248990'.
else if (TumorLocation='').
DO IF (CHAR.INDEX(Position,'R')=1).
compute RV.laterality='4248990'.
else if  (CHAR.INDEX(Position,'L')=1).
compute RV.laterality='4197399'.
END IF.
END IF.


*4241191:Single tumor, 4181140:Multifocal.
RECODE  MulticentricMultifocal (1='4181140') (0='4241191') INTO 
    RV.focality.


*CAUTION CHECK IF  SPSS RUNS WITH ,(comma) or dot as decimal delimiter.
string tempVar (a70).
recode TumorSizecm (else = copy) into tempVar.
compute tempVar=LTRIM(RTRIM(replace(tempVar,'[',''))).
compute tempVar=LTRIM(RTRIM(replace(tempVar,']',''))).
compute tempVar=LTRIM(RTRIM(replace(tempVar,' (1.5)',''))).


execute.
DO IF (CHAR.INDEX(tempVar,' ')>1).
compute tempVar=SUBSTR(tempVar,1,CHAR.INDEX(tempVar,' ')+1).
END IF.


DO IF (CHAR.INDEX(tempVar,'.')=0).
compute tempVar=CONCAT(tempVar,'.0').
END IF.

*change next lines if SPSS with . delimeter
compute tempVar=REPLACE(tempVar,'.',',')
DO IF (CHAR.INDEX(tempVar,',')=0)
compute tempVar=CONCAT(tempVar,',0')
END IF
*--------------------.

NUMERIC tempnum.
formats tempnum (F4.1).
compute tempnum=Number(tempVar,F4.1).
EXECUTE.
DO IF (~Missing(tempnum)).
compute RV.tumor_size=LTRIM(RTRIM(String(tempnum*10,f4.0))).
END IF.
EXECUTE.
delete variables tempVar tempnum.
exe.

*4245698:Tumor metastasis to non-regional lymph nodes absent, .       
*4245697:Tumor metastasis to non-regional lymph nodes present.

RECODE MetastaticatPresentationOutsideofLymphNodes (0='4245698') (1='4245697') INTO
    RV.metastasis.

*4188539:Yes , 4188540:No, 763013:Not provided.
RECODE NeoadjuvantChemotherapy  (0='4188540') (1='4188539') INTO
    RV.neoadjuvant_chemotherapy.

RECODE NeoadjuvantRadiationTherapy  (0='4188540') (1='4188539') INTO
    RV.neoadjuvant_radiotherapy.

RECODE NeoadjuvantEndocrineTherapyMedications  (0='4188540') (1='4188539') INTO
    RV.neoadjuvant_endocrine_therapy.

RECODE AdjuvantChemotherapy  ('0'='4188540') ('1'='4188539') INTO
    RV.adjuvant_chemotherapy.

RECODE AdjuvantRadiationTherapy  (0='4188540') (1='4188539') INTO
    RV.adjuvant_radiotherapy.

RECODE AdjuvantEndocrineTherapyMedications  ('0'='4188540') ('1'='4188539') INTO
    RV.adjuvant_endocrine_therapy.

*35933862: Complete response (CR), 35912239: Not applicable: Neoadjuvant therapy not given,.
*35937289: Partial response (PR), 35938553: No response (NR).

RECODE OverallNearcompleteResponseStricterDefinition  ('0'='35938553') ('1'='35933862') ('2'='35937289') ('NA'='35912239') INTO
    RV.neoadjuvant_therapy_response.

*4213045: Lumpectomy of breast,  4249113: Modified radical mastectomy,   4066543:Simple mastectomy.

RECODE DefinitiveSurgeryType (0='4213045') (1='4066543')  INTO 
    RV.surgical_procedure. 


*4167696:Estrogen receptor positive tumor,4261933:Estrogen receptor negative neoplasm.
RECODE ER (1='4167696') (0='4261933') INTO 
    RV.er. 
*4219694:Progesterone receptor positive tumor,4261934:Progesterone receptor negative neoplasm.
RECODE PR (1='4219694') (0='4261934') INTO 
    RV.pr. 
*44790895:Human epidermal growth factor receptor 2 gene positive, 44790896:Human epidermal growth factor receptor 2 gene negative.
RECODE HER2 (1='44790895') (0='44790896') INTO 
    RV.her2.

*4216891:Hormone receptor positive malignant neoplasm of breast:SNOMED, 4230400:Hormone receptor negative neoplasm:SNOMED.
DO IF (ER=1 | PR=1).
COMPUTE RV.hr='4216891'.
ELSE IF (ER=0 & PR=0).
COMPUTE RV.hr = '4230400'.
END IF.

* Value-set from ICD-O-3: 44498348:Infiltrating duct carcinoma, .
*NOS,44498367:Lobular carcinoma, NOS, .
*44502956:Medullary carcinoma, NOS, of breast, NOS.
*44498801:Ductal carcinoma in situ, solid type.
*44498562:Metaplastic carcinoma, NOS.
*44501721:Tubular adenocarcinoma of breast, NOS.
*44505277:Mucinous adenocarcinoma of breast.
RECODE Histologictype (0='44498801') (1='44498348') (2='44498367') (3='44498562') (5='44501721') (9='44505277') INTO 
    RV.histology.


*calculate RV.subtype:35917481:Combinations of ER, PR, and HER2 Results.

*HR=0.
DO IF (ER=0 & PR=0  & HER2=0).
*35937684:        ER Negative, PR Negative, HER2 Negative (Triple Negative).
COMPUTE RV.subtype='35937684'.
ELSE IF (ER=0 & PR=0  & HER2=1).
*35935735:ER Negative, PR Negative, HER2 Positive.
COMPUTE RV.subtype = '35935735'.

*Here on HR=1.
ELSE IF (ER=0 & PR=1  & HER2=0).
*35932811 ER Negative, PR Positive, HER2 Negative.
COMPUTE RV.subtype = '35932811'.
ELSE IF (ER=0 & PR=1  & HER2=1).
*35924419 	ER Negative, PR Positive, HER2 Positive.
COMPUTE RV.subtype = '35924419'.
ELSE IF (ER=1 & PR=0  & HER2=0).
*35932950 ER Positive, PR Negative, HER2 Negative.
COMPUTE RV.subtype = '35932950'.
ELSE IF (ER=1 & PR=0  & HER2=1).
*35932308 ER Positive, PR Negative, HER2 Positive.
COMPUTE RV.subtype = '35932308'.
ELSE IF (ER=1 & PR=1  & HER2=0).
*35927765 ER Positive, PR Positive, HER2 Negative.
COMPUTE RV.subtype = '35927765'.
ELSE IF (ER=1 & PR=1  & HER2=1).
*35933051 ER Positive, PR Positive, HER2 Positive.
COMPUTE RV.subtype = '35933051'.
END IF.



*https://www.oncolink.org/cancers/breast/screening-diagnosis/understanding-your-pathology-report-breast-cancer.
*The three scores (nuclear grade, mitotic rate, and tubule formation) are then combined for a total score between 3 (1+1+1) and 9 (3+3+3). This score makes up the histological grade.
* You may see the three values and total score, or just the final grade.
*    Score of 3,4 or 5: Well differentiated or low grade (Grade 1).
*    Score of 6 or 7: Moderately differentiated or intermediate grade (Grade 2).
*    Score of 8 or 9: Poorly differentiated or high grade (Grade 3).

*1634371:Grade 1 tumor.
*1634752:Grade 2 tumor.
*1633749:Grade 3 tumor.
DO IF ((TumorGrade+V33+V34)<6).
compute RV.grade='1634371'.
ELSE if ((TumorGrade+V33+V34)<8).
compute RV.grade='1634752'.
ELSE if ((TumorGrade+V33+V34)>=8).
compute RV.grade='1633749'.
END IF.

*1633925:AJCC/UICC pathological TX Category.
*1635740:AJCC/UICC pathological T0 Category.
* 1634004:AJCC/UICC pathological T1 Category.
* 1633722:AJCC/UICC pathological T1a Category,1633693:AJCC/UICC pathological T1b Category,.
* 1635017:AJCC/UICC, pathological T1c Category,1634272:AJCC/UICC pathological T1d Category,.
* 1634428:AJCC/UICC pathological T1mi Category, .
* 1633978:AJCC/UICC pathological T2 Category,.
* 1634597:AJCC/UICC pathological T2a Category,1635575:AJCC/UICC pathological T2b Category,.
* 1634503:AJCC/UICC pathological T2c Category,1633278:AJCC/UICC pathological T2d Category,.
* 1634406:AJCC/UICC pathological T3 Category,.
* 1633288:AJCC/UICC pathological T3a Category,.
* 1633406:AJCC/UICC pathological T3b Category,1635027:AJCC/UICC pathological T3c Category,.
* 1635377:AJCC/UICC pathological T3d Category,1634025:AJCC/UICC pathological T3e Category.
*1633943:AJCC/UICC pathological T4 Category.
*1634623:AJCC/UICC pathological Tis(DCIS) Category.

RECODE PathologicresponsetoNeoadjuvanttherapyPathologicstageTfollowingn  ('-1'='1633925')  ('0'='1635740') ('1'='1634004') ('2'='1633978') ('3'='1634406') ('4'='1633943') ('5'='1634623') INTO 
    RV.pT.

*1633527:AJCC/UICC post therapy pathological N0 Category,1635444:AJCC/UICC post therapy pathological N0(i+) Category,
*1634866:AJCC/UICC post therapy pathological N0(mol+) Category,1634158:AJCC/UICC post therapy pathological N0a Category,1634985:AJCC/UICC post therapy pathological N0b Category,.
*1635613:AJCC/UICC pathological N1 Category	,1634206:AJCC/UICC pathological N1a Category	,1633830:AJCC/UICC pathological N1b Category	,1634589:AJCC/UICC pathological N1c Category	,1633502:AJCC/UICC pathological N1mi Category,.
*1633864:AJCC/UICC pathological N2,1633890:AJCC/UICC pathological N2a,1633460:AJCC/UICC pathological N2b,1633301:AJCC/UICC pathological N2c,1635830:AJCC/UICC pathological N2mi,.
*1635706:AJCC/UICC pathological N3 Category,1633401:AJCC/UICC pathological N3a Category,1633384:AJCC/UICC pathological N3b Category,1634305:AJCC/UICC pathological N3c Category,.
*1634916:AJCC/UICC pathological N4 Category,1635170:AJCC/UICC pathological NX Category.

RECODE PathologicresponsetoNeoadjuvanttherapyPathologicstageNfollowingn ('-1'='1634916') ('0'='1633527') ('1'='1635613') ('2'='1633864') 
     ('3'='1635706')  INTO 
    RV.pN.


*1634618:AJCC/UICC pathological M0 Category,1633457:AJCC/UICC pathological M0(i+) Category, 1633421:AJCC/UICC pathological MX Category.
*1635505:AJCC/UICC pathological M1 Category.
RECODE PathologicresponsetoNeoadjuvanttherapyPathologicstageMfollowingn ('0'='1634618') ('-1'='1633421') ('1'='1633457') INTO 
    RV.pM.

*4186416:No evidence of recurrence of cancer.
*4058583:Recurrence of problem.
RECODE Recurrenceevents (0='4186416') (1='4058583') INTO
RV.recurrence.

* MIN Days to local recurrence (from the date of diagnosis) ;	Days to distant recurrence(from the date of diagnosis) .
DO IF  (LTRIM(RTRIM(Daystolocalrecurrencefromthedateofdiagnosis))='NP' & LTRIM(RTRIM(Daystodistantrecurrencefromthedateofdiagnosis))='NP').
COMPUTE RV.days_to_recurrence= ''.
ELSE IF (LTRIM(RTRIM(Daystolocalrecurrencefromthedateofdiagnosis))~='NP' & LTRIM(RTRIM(Daystodistantrecurrencefromthedateofdiagnosis))='NP').
COMPUTE RV.days_to_recurrence=LTRIM(STRING(NUMBER(LTRIM(RTRIM(Daystolocalrecurrencefromthedateofdiagnosis)),F5),F5)).
ELSE IF (LTRIM(RTRIM(Daystolocalrecurrencefromthedateofdiagnosis))='NP' & LTRIM(RTRIM(Daystodistantrecurrencefromthedateofdiagnosis))~='NP').
COMPUTE RV.days_to_recurrence=LTRIM(STRING(NUMBER(LTRIM(RTRIM(Daystodistantrecurrencefromthedateofdiagnosis)),F5),F5)).
ELSE IF (LTRIM(RTRIM(Daystolocalrecurrencefromthedateofdiagnosis))~='NP' & LTRIM(RTRIM(Daystodistantrecurrencefromthedateofdiagnosis))~='NP').
COMPUTE RV.days_to_recurrence=LTRIM(STRING(MIN(NUMBER(LTRIM(RTRIM(Daystodistantrecurrencefromthedateofdiagnosis)),F5),NUMBER(LTRIM(RTRIM(Daystodistantrecurrencefromthedateofdiagnosis)),F5)),F5)).
END IF.
EXECUTE.


*if no day to death then alive.
*45884343: Alive, 45880868: Dead.
* if alive then max age is MAX of .
*Days to last local recurrence free assessment (from the date of diagnosis) ;	Days to last distant recurrence free assemssment(from the date of diagnosis) ;.
*Age at last contact in EMR f/u(days)(from the date of diagnosis) ,last time patient known to be alive, unless age of death is reported,in such case the age of death.

DO IF (LTRIM(RTRIM(Daystodeathfromthedateofdiagnosis))='NP').
COMPUTE RV.vital_status='45884343'.
COMPUTE RV.days_from_diagnosis_to_last_follow_up=LTRIM( STRING(
MAX.1(Daystolastlocalrecurrencefreeassessmentfromthedateofdiagnosis,Daystolastdistantrecurrencefreeassemssmentfromthedateofdiagnosis,AgeatlastcontactinEMRfudaysfromthedateofdiagnosislasttimepatient)
,F5) ).
ELSE. 
COMPUTE RV.vital_status='45880868'.
COMPUTE RV.days_from_diagnosis_to_last_follow_up=LTRIM(STRING(NUMBER(LTRIM(RTRIM(Daystodeathfromthedateofdiagnosis)),F5),F5)).
END IF.

EXECUTE.
