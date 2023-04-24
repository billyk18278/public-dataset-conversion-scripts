* Encoding: UTF-8.
* ISPY2 conversion script.
compute RV.case_origin_url='https://wiki.cancerimagingarchive.net/pages/viewpage.action?pageId=20643859'.
compute RV.tcia_subject_id=CONCAT('ISPY1_',LTRIM(STRING(SUBJECTID,F7.0))). 

DO IF ~(SYSMIS(age)).
compute RV.age_at_diagnosis=LTRIM(STRING(age,F5.2)).
END IF.


RECODE race_id (1='8527') (3='8516') (4='8515') (5='8557') (6='8567') (50='8522') INTO 
    RV.race. 


* (Allred Score or Community determined), pre-treatment.


DO IF (ERpos=1).
COMPUTE RV.er='4167696'.
ELSE IF (ERpos = 0).
COMPUTE RV.er = '4261933'.
ELSE IF (ERpos = 2).
* nothing to do since Indeterminate => not provided for radioval.
END IF.

DO IF (PgRpos=1).
COMPUTE RV.pr='4219694'.
ELSE IF (PgRpos = 0).
COMPUTE RV.pr = '4261934'.
ELSE IF (PgRpos = 2).
* nothing to do since Indeterminate => not provided for radioval.
END IF.


DO IF (HRPos=1).
COMPUTE RV.hr='4216891'.
ELSE IF (HRPos = 0).
COMPUTE RV.hr = '4230400'.
ELSE IF (HRPos = 2).
* nothing to do since Indeterminate => not provided for radioval.
END IF.

* Her2 Status, pre-treatment, adding in Central Her2 IHC results for missing Community.
DO IF (Her2MostPos=1).
COMPUTE RV.her2='44790895'.
ELSE IF (Her2MostPos = 0).
COMPUTE RV.her2 = '44790896'.
END IF.



*calculate RV.subtype:35917481:Combinations of ER, PR, and HER2 Results.

*HRpos=0.
DO IF (HRPos=0 & Her2MostPos=0).
*35937684:        ER Negative, PR Negative, HER2 Negative (Triple Negative).
COMPUTE RV.subtype='35937684'.
ELSE IF (HRPos = 0 & Her2MostPos=1).
*35935735:ER Negative, PR Negative, HER2 Positive.
COMPUTE RV.subtype = '35935735'.

*Here on HRpos=1.
ELSE IF (ERpos = 0 & PgRpos=1 & Her2MostPos=0).
*35932811 ER Negative, PR Positive, HER2 Negative.
COMPUTE RV.subtype = '35932811'.
ELSE IF (ERpos = 0 & PgRpos=1 & Her2MostPos=1).
*35924419 	ER Negative, PR Positive, HER2 Positive.
COMPUTE RV.subtype = '35924419'.
ELSE IF (ERpos = 1 & PgRpos=0 & Her2MostPos=0).
*35932950 ER Positive, PR Negative, HER2 Negative.
COMPUTE RV.subtype = '35932950'.
ELSE IF (ERpos = 1 & PgRpos=0 & Her2MostPos=1).
*35932308 ER Positive, PR Negative, HER2 Positive.
COMPUTE RV.subtype = '35932308'.
ELSE IF (ERpos = 1 & PgRpos=1 & Her2MostPos=0).
*35927765 ER Positive, PR Positive, HER2 Negative.
COMPUTE RV.subtype = '35927765'.
ELSE IF (ERpos = 1 & PgRpos=1 & Her2MostPos=1).
*35933051 ER Positive, PR Positive, HER2 Positive.
COMPUTE RV.subtype = '35933051'.
END IF.
    

DO IF (BilateralCa=1).
COMPUTE RV.laterality ='4273543'.
ELSE IF (BilateralCa = 0 & Laterality=1).
COMPUTE RV.laterality = '4197399'.
ELSE IF (BilateralCa = 0 & Laterality=2).
COMPUTE RV.laterality = '4248990'.
END IF.


DO IF ~(SYSMIS(MRILDBaseline)).
compute RV.tumor_size=LTRIM(STRING(MRILDBaseline,F4.0)).
END IF.

* all on neoadjuvant chemo.
COMPUTE RV.neoadjuvant_chemotherapy='4188539'.

* Outcomes worksheet.
RECODE sstat (7='45884343') (8='45880868') INTO 
    RV.vital_status. 


DO IF ~(SYSMIS(survDtD2tx)).
compute RV.days_from_diagnosis_to_last_follow_up=LTRIM(STRING(survDtD2tx,F7.0)).
END IF.

RECODE rfs_ind (1='4058583') (0='4186416') INTO 
    RV.recurrence. 


RECODE rfs_ind (1='4058583') (0='4186416') INTO 
    RV.recurrence. 

RECODE PCR (1='35933862') (0='35938553') INTO 
    RV.neoadjuvant_therapy_response. 


EXECUTE.

