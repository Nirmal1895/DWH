/* 
Assign a library reference to your directory (uncomment if you want to use it)
libname mylib "C:\path\to\your\directory";
*/

/* Step 1: Create Age Group Buckets */
data healthcare_data_age_groups;
    set healthcare_data_load; /* Load the original dataset */

    /* Create a new variable to categorize age groups with a length of 20 characters */
    length AgeGroup_Label $20.;

    /* Assign labels based on the AgeGroup variable */
    if AgeGroup = '0-10' then AgeGroup_Label = 'Children';
    else if AgeGroup = '11-20' then AgeGroup_Label = 'Teens';
    else if AgeGroup = '21-30' then AgeGroup_Label = 'Young Adults';
    else if AgeGroup = '31-40' then AgeGroup_Label = 'Adults';
    else if AgeGroup = '41-50' then AgeGroup_Label = 'Middle-Aged Adults';
    else if AgeGroup = '51-60' then AgeGroup_Label = 'Seniors';
    else AgeGroup_Label = 'Oldage'; /* Default to 'Oldage' if none of the above conditions are met */
run;

/* Step 2: Calculate the Distribution of Patients Across Age Groups by Department */
proc freq data=healthcare_data_age_groups;
    /* Cross-tabulate AgeGroup_Label by Department */
    tables Department*AgeGroup_Label / nocum norow nocol nopercent;
    title "Distribution of Patients Across Age Groups by Department";
run;

/* Step 3: Categorize Admission Deposits */
data healthcare_data_deposits;
    set healthcare_data_load; /* Load the original dataset */

    /* Create a new variable to categorize admission deposits with a length of 20 characters */
    length Deposit_Category $20.;

    /* Categorize AdmissionDeposit into 'Low', 'Medium', and 'High' */
    if AdmissionDeposit < 2000 then Deposit_Category = 'Low';
    else if AdmissionDeposit <= 5000 then Deposit_Category = 'Medium';
    else Deposit_Category = 'High'; /* Default to 'High' if AdmissionDeposit is above 5000 */
run;

/* Step 4: Calculate the Average Admission Deposit by Hospital and Department */
proc means data=healthcare_data_deposits mean;
    format AdmissionDeposit dollar12.; /* Format the output as dollars */
    class HospitalCode Department; /* Group by HospitalCode and Department */
    var AdmissionDeposit; /* Calculate the mean for AdmissionDeposit */
    title "Average Admission Deposit by Hospital and Department";
run;

/* Step 5: Count the Number of Patients by Illness Severity and Department */
proc freq data=healthcare_data_load;
    /* Cross-tabulate IllnessSeverity by Department */
    tables Department*IllnessSeverity / nocum norow nocol nopercent;
    title "Number of Patients by Illness Severity and Department";
run;

/* Step 6: Calculate the Average Number of Visitors per Patient by Hospital and Department */
proc means data=healthcare_data_load mean;
    class HospitalCode Department; /* Group by HospitalCode and Department */
    var VisitorsCount; /* Calculate the mean for VisitorsCount */
    title "Average Number of Visitors per Patient by Hospital and Department";
run;

/* Step 7: Identify Departments with the Highest Revenue */
proc means data=healthcare_data_load sum maxdec=0;
    class Department; /* Group by Department */
    var AdmissionDeposit; /* Sum the AdmissionDeposit for each Department */
    format TotalRevenue dollar12.; /* Format the output as dollars */
    output out=department_revenue sum=TotalRevenue; /* Output the results to a new dataset */
    title "Department-wise Revenue";
run;

/* Step 8: Identify Departments with the Most Emergency Admissions */
proc freq data=healthcare_data_load noprint;
    /* Cross-tabulate AdmissionType by Department and output results to admission_counts */
    tables Department*AdmissionType / out=admission_counts;
    where AdmissionType = 'Emergency'; /* Filter for 'Emergency' admissions only */
run;

proc sort data=admission_counts;
    by descending count; /* Sort by count in descending order */
run;

proc print data=admission_counts;
    var Department AdmissionType count; /* Display Department, AdmissionType, and count */
    title "Departments with the Most Emergency Admissions";
run;

/* Step 9: Identify the Department with the Highest Total Visitors */
proc sql;
    /* Calculate the total number of visitors by department */
    create table total_visitors_by_dept as
    select Department,
           sum(VisitorsCount) as Total_Visitors
    from healthcare_data_load
    group by Department;
quit;

proc sql;
    /* Identify the department with the highest total visitors */
    create table highest_visitor_dept as
    select Department, 
           Total_Visitors
    from total_visitors_by_dept
    having Total_Visitors = max(Total_Visitors); /* Select only the department with the maximum total visitors */
quit;

proc print data=highest_visitor_dept;
    title "Department with the Highest Total Visitors"; /* Display the department with the most visitors */
run;
