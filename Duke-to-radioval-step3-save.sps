* Encoding: UTF-8.
SAVE TRANSLATE OUTFILE='DukeV3.csv' 
  /TYPE=CSV 
  /ENCODING='UTF8' 
  /MAP 
  /REPLACE 
  /FIELDNAMES 
  /CELLS=VALUES 
  /DROP=PatientID DaystoMRIFromtheDateofDiagnosis Manufacturer ManufacturerModelName ScanOptions 
    FieldStrengthTesla PatientPositionDuringMRI ImagePositionofPatient ContrastAgent 
    ContrastBolusVolumemL TRRepetitionTime TEEchoTime AcquisitionMatrix SliceThickness Rows Columns 
    ReconstructionDiameter FlipAngle FOVComputedFieldofViewincm DateofBirthDays Menopauseatdiagnosis 
    RaceandEthnicity MetastaticatPresentationOutsideofLymphNodes ER PR HER2 MolSubtype Oncotypescore 
    StagingTumorSize#T StagingNodes#Nxreplacedby1N StagingMetastasis#Mxreplacedby1M TumorGrade V33 V34 
    Nottinghamgrade Histologictype TumorLocation Position BilateralInformation V40 V41 
    ForOtherSideIfBilateral V43 V44 V45 V46 V47 V48 MulticentricMultifocal 
    ContralateralBreastInvolvement LymphadenopathyorSuspiciousNodes SkinNippleInvovlement 
    PecChestInvolvement Surgery DaystoSurgeryfromthedateofdiagnosis DefinitiveSurgeryType 
    NeoadjuvantRadiationTherapy AdjuvantRadiationTherapy ClinicalResponseEvaluatedThroughImaging 
    PathologicResponsetoNeoadjuvantTherapy Recurrenceevents Daystolocalrecurrencefromthedateofdiagnosis 
    Daystodistantrecurrencefromthedateofdiagnosis Daystodeathfromthedateofdiagnosis 
    Daystolastlocalrecurrencefreeassessmentfromthedateofdiagnosis 
    Daystolastdistantrecurrencefreeassemssmentfromthedateofdiagnosis 
    AgeatlastcontactinEMRfudaysfromthedateofdiagnosislasttimepatient V68 Ageatmammodays BreastDensity 
    Shape Margin TumorSizecm Architecturaldistortion MassDensity Calcifications Shape_A Margin_A 
    TumorSizecm_A Echogenicity Solid Posterioracousticshadowing NeoadjuvantChemotherapy 
    AdjuvantChemotherapy NeoadjuvantEndocrineTherapyMedications AdjuvantEndocrineTherapyMedications 
    KnownOvarianStatus NumberofOvariesInSitu 
    TherapeuticorProphylacticOophorectomyaspartofEndocrineTherapy NeoadjuvantAntiHer2NeuTherapy 
    AdjuvantAntiHer2NeuTherapy ReceivedNeoadjuvantTherapyorNot 
    PathologicresponsetoNeoadjuvanttherapyPathologicstageTfollowingn 
    PathologicresponsetoNeoadjuvanttherapyPathologicstageNfollowingn 
    PathologicresponsetoNeoadjuvanttherapyPathologicstageMfollowingn 
    OverallNearcompleteResponseStricterDefinition OverallNearcompleteResponseLooserDefinition 
    NearcompleteResponseGradedMeasure V99.
EXECUTE.
