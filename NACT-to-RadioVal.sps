* Encoding: UTF-8.
*  NACT to RADIOVAL.
*USE SharedClinicalAndRFS.xls without modification.

*Fix import.
DELETE VARIABLES V44	V45	V46	V47	V48	V49	V50	V51	V52	V53	V54	V55	V56	V57	V58	V59	V60	V61	V62	V63	V64	V65	V66	V67	
V68	V69	V70	V71	V72	V73	V74	V75	V76	V77	V78	V79	V80	V81	V82	V83	V84	V85	V86	V87	V88	V89	V90	V91	V92	V93	V94	V95	V96	
V97	V98	V99	V100	V101	V102	V103	V104	V105	V106	V107	V108	V109	V110	V111	V112	V113	V114	V115	V116	V117	V118	V119	V120	
V121	V122	V123	V124	V125	V126	V127	V128	V129	V130	V131	V132	V133	V134	V135	V136	V137	V138	V139	V140	V141	V142	V143	
V144	V145	V146	V147	V148	V149	V150	V151	V152	V153	V154	V155	V156	V157	V158	V159	V160	V161	V162	V163	V164	V165	V166	
V167	V168	V169	V170	V171	V172	V173	V174	V175	V176	V177	V178	V179	V180	V181	V182	V183	V184	V185	V186	V187	V188	V189	
V190	V191	V192	V193	V194	V195	V196	V197	V198	V199	V200.
SELECT IF (~Missing(PRIMARYIDNumber)).

compute RV.case_origin_url='https://wiki.cancerimagingarchive.net/pages/viewpage.action?pageId=22513764'.

COMPUTE  RV.tcia_subject_id=CONCAT('UCSF-BR-',lpad(ltrim(rtrim(STRING(PRIMARYIDNumber,f3.0),' ')),2,'0')).

compute RV.age_at_diagnosis=LTRIM(STRING(AGEatMRI1yrs,F11.2)).


RECODE Race ('caucasian'='8527') ('hispanic'='8527') ('african-amer'='8516') ('asian'='8515') INTO 
    RV.race. 

RECODE Race ('hispanic'='38003563')  INTO 
    RV.ethnicity. 


DO IF (UPCASE(breastlaterality)='RIGHT').
COMPUTE RV.laterality='4248990'.
ELSE IF (UPCASE(breastlaterality)='LEFT').
COMPUTE RV.laterality = '4197399'.
END IF.


DO IF (~Missing(LD1cm)).
compute RV.tumor_size=LTRIM(RTRIM(String(LD1cm*10,f4.0))).
END IF.

*4245698:Tumor metastasis to non-regional lymph nodes absent, .       
*4245697:Tumor metastasis to non-regional lymph nodes present.

RECODE recurtype ('local'='4245698') (''='4245698') ('met'='4245697') INTO
    RV.metastasis.






*4188539:Yes , 4188540:No, 763013:Not provided.

compute RV.neoadjuvant_radiotherapy='4188540'.

compute RV.neoadjuvant_chemotherapy='4188539'.

* 35807214:Anthracycline, 35807304:Taxane = 1378382:paclitaxel.

RECODE AConly0taxol1 ('0'='35807214') ('1'='35807214|1378382') INTO
    RV.neoadjuvant_chemo_medication.


*Clinical response	
1	NED, no evidence of disease
2	>1/3 decrease clinical longest diameter
3	<1/3 decrease LD
4	4: SD, steady disease/PD, progressive disease.

*35933862: Complete response (CR), 35912239: Not applicable: Neoadjuvant therapy not given,.
*35937289: Partial response (PR), 35938553: No response (NR).

RECODE  Clinicalresponse (4='35938553') (1='35933862') (2='35937289')  (3='35937289') INTO
    RV.neoadjuvant_therapy_response.


*surg type	Type of surgery
M	Mastectomy
L	Lumpectomy
L (Q)	Quadrantectomy
no rd tx	Declined post-surgery radiation treatment.

*4213045: Lumpectomy of breast,  4249113: Modified radical mastectomy,   4066543:Simple mastectomy.

DO IF (CHAR.INDEX(Surgerytype,'L')=1).
COMPUTE RV.surgical_procedure='4213045'.
ELSE IF (CHAR.INDEX(Surgerytype,'M')=1).
COMPUTE RV.surgical_procedure='4066543'.
 END IF. 


*4167696:Estrogen receptor positive tumor,4261933:Estrogen receptor negative neoplasm.
COMPUTE tempER=NUMBER (ERpositive,F1.0).

RECODE tempER (1='4167696') (0='4261933') INTO 
    RV.er. 
*4219694:Progesterone receptor positive tumor,4261934:Progesterone receptor negative neoplasm.
RECODE PRPositive (1='4219694') (0='4261934') INTO 
    RV.pr. 
*44790895:Human epidermal growth factor receptor 2 gene positive, 44790896:Human epidermal growth factor receptor 2 gene negative.
RECODE HER2Positive (1='44790895') (0='44790896') INTO 
    RV.her2.

*4216891:Hormone receptor positive malignant neoplasm of breast:SNOMED, 4230400:Hormone receptor negative neoplasm:SNOMED.
DO IF (tempER=1 | PRPositive=1).
COMPUTE RV.hr='4216891'.
ELSE IF (tempER=0 & PRPositive=0).
COMPUTE RV.hr = '4230400'.
END IF.

*calculate RV.subtype:35917481:Combinations of ER, PR, and HER2 Results.

*HR=0.
DO IF (tempER=0 & PRPositive=0  & HER2Positive=0).
*35937684:        ER Negative, PR Negative, HER2 Negative (Triple Negative).
COMPUTE RV.subtype='35937684'.
ELSE IF (tempER=0 & PRPositive=0  & HER2Positive=1).
*35935735:ER Negative, PR Negative, HER2 Positive.
COMPUTE RV.subtype = '35935735'.

*Here on HR=1.
ELSE IF (tempER=0 & PRPositive=1  & HER2Positive=0).
*35932811 ER Negative, PR Positive, HER2 Negative.
COMPUTE RV.subtype = '35932811'.
ELSE IF (tempER=0 & PRPositive=1  & HER2Positive=1).
*35924419 	ER Negative, PR Positive, HER2 Positive.
COMPUTE RV.subtype = '35924419'.
ELSE IF (tempER=1 & PRPositive=0  & HER2Positive=0).
*35932950 ER Positive, PR Negative, HER2 Negative.
COMPUTE RV.subtype = '35932950'.
ELSE IF (tempER=1 & PRPositive=0  & HER2Positive=1).
*35932308 ER Positive, PR Negative, HER2 Positive.
COMPUTE RV.subtype = '35932308'.
ELSE IF (tempER=1 & PRPositive=1  & HER2Positive=0).
*35927765 ER Positive, PR Positive, HER2 Negative.
COMPUTE RV.subtype = '35927765'.
ELSE IF (tempER=1 & PRPositive=1  & HER2Positive=1).
*35933051 ER Positive, PR Positive, HER2 Positive.
COMPUTE RV.subtype = '35933051'.
END IF.



DELETE VARIABLES tempER.
EXECUTE.




*Patient UCSF_BR_27 declined standard-of-care post-surgery radiation and hormonal treatments. .


 
DO IF (PRIMARYIDNumber~=27).
COMPUTE   RV.adjuvant_radiotherapy= '4188539'.
COMPUTE   RV.adjuvant_endocrine_therapy= '4188539'.
ELSE.
COMPUTE   RV.adjuvant_radiotherapy= '4188540'.
COMPUTE   RV.adjuvant_endocrine_therapy= '4188540'.
END IF.



*44501483:Adenocarcinoma, NOS, of breast, NOS.
*44498348:Infiltrating duct carcinoma, NOS .
*44498367:Lobular carcinoma, NOS, .
*44502956:Medullary carcinoma, NOS, of breast, NOS.
*44498801:Ductal carcinoma in situ, solid type.
*44498562:Metaplastic carcinoma, NOS.
*44501721:Tubular adenocarcinoma of breast, NOS.
*44505277:Mucinous adenocarcinoma of breast.
*44498540:Infiltrating duct and lobular carcinoma.
RECODE Cancertype 
('IL'='44498367')
('ID'='44498348') ('ID/mucinous'='44498348') ('pagets, ID'='44498348')
('adenocarc NOS'='44501483')
('ID/IL'='44498540') 
 ('mucinous'='44505277') ('mucinous (DCIS)'='44505277') ('adenocarc NOS (mucinous)'='44505277')
 INTO 
    RV.histology.

*4186416:No evidence of recurrence of cancer.
*4058583:Recurrence of problem.
RECODE censor (0='4058583') (1='4186416') INTO 
RV.recurrence.

*DFS time	Time from surgery to recurence or last follow-up
	"censor=0:
Number of weeks from surgery to local recurrence, metastasis, or death"
	"censor=1:
Number of weeks from surgery to most recent exam".
*Since it is weeks from surgery i can not define  days_to_recurrence.
* on the other hand i know that they where alive after DFS time from diagnosis so i add this into the respective field.

compute RV.days_from_diagnosis_to_last_follow_up=LTRIM(STRING(DFStimeweeks*7,F6.0)).


EXECUTE.