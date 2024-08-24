/* Step 1: Define the Azure Blob Storage URL */
filename mydata url "https://devenvironmentdata.blob.core.windows.net/bronze/Raw_Data/Hospital_Data.csv?sp=r&st=2024-08-24T01:19:32Z&se=2024-08-30T09:19:32Z&spr=https&sv=2022-11-02&sr=b&sig=CumF5qOnwpKNxJR4OtjrDAf%2BvYelNhrjMSmp%2F3E50L0%3D";

/* Step 2: Read the CSV file and rename columns during the data loading process */
data healthcare_data_load;
    infile mydata dsd firstobs=2 truncover; /* Read from the Azure Blob Storage URL */
    
    /* Define the length and type of each variable (column) */
    length CaseID $8 
           HospitalCode $8 
           HospitalTypeCode $8 
           CityCodeHospital $8 
           HospitalRegionCode $8 
           ExtraRoomsAvailable 8 
           Department $20 
           WardType $8 
           WardFacilityCode $8 
           BedGrade 8 
           PatientID $8 
           CityCodePatient $8 
           AdmissionType $20 
           IllnessSeverity $20 
           VisitorsCount 8 
           AgeGroup $10 
           AdmissionDeposit 8 
           StayDuration $100;

    /* Read the data and assign the defined variable names */
    input CaseID : $8.
          HospitalCode : $8.
          HospitalTypeCode : $8.
          CityCodeHospital : $8.
          HospitalRegionCode : $8.
          ExtraRoomsAvailable : 8.
          Department : $20.
          WardType : $8.
          WardFacilityCode : $8.
          BedGrade : 8.
          PatientID : $8.
          CityCodePatient : $8.
          AdmissionType : $20.
          IllnessSeverity : $20.
          VisitorsCount : 8.
          AgeGroup : $10.
          AdmissionDeposit : 8.
          StayDuration : $100.;
run;

/* Step 3: Clear the filename reference */
filename mydata clear;

/* Step 4: Display the first 10 rows of the loaded dataset with renamed columns */
proc print data=healthcare_data_load(obs=10);
    title "First 10 Observations of the Healthcare Data";
run;

/* Step 5: Optionally save the renamed dataset to a permanent location */
libname mydata "/home/u63366120/Nirmal"; /* Specify the library location */

data mydata.healthcare_data_load;
    set healthcare_data_load; /* Save the dataset to the specified location */
run;
