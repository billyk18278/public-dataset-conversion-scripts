* Encoding: UTF-8.
DO IF (RV.age_at_diagnosis='763013').
compute RV.age_at_diagnosis=''.
END IF.

DO IF (RV.tumor_size='763013').
compute RV.tumor_size=''.
END IF.

DO IF (RV.days_to_recurrence='763013').
compute RV.days_to_recurrence=''.
END IF.

DO IF (RV.days_from_diagnosis_to_last_follow_up='763013').
compute RV.days_from_diagnosis_to_last_follow_up=''.
END IF.


EXECUTE.
