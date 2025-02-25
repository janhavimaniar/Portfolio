/* Phase 3 - Answer to Business Intelligence Questions */
/* Team # 2 */

/* Participating member names: Emily Lucia, Janhavi Maniar, Jake Aufiero */



/* SQL Answer to Question 1*/ 
/* Question 1 -  What are the different loan statuses related to late payments or grace periods, and what percentage do they represent out of the total loans?*/

    SELECT DISTINCT loan_status AS "Loan Status",
            ROUND((count(loan_status)/44342)*100,2) AS "Percentage of Total Loans"
    FROM loan_funding
    WHERE UPPER(loan_status) LIKE '%LATE%'
          OR UPPER(loan_status) LIKE '%GRACE%'
    GROUP BY loan_status;
        


/* SQL Answer to Question 2 */ 
/* Question 2 - What is the total amount funded for each loan purpose, and which purposes received the highest funding? */

    SELECT l.loan_purpose AS "Loan Purpose",
           SUM(f.funded_amount) AS "Total Amount Funded"
    FROM loan l
    LEFT JOIN loan_funding f
    ON l.loan_id = f.loan_id
    GROUP BY l.loan_purpose
    ORDER BY SUM(f.funded_amount) DESC;
/* Debt consolidation has the highest amount funded at $397,936,625 */



/* SQL Answer to Question 3 */ 
/* Question 3 - Is the loan installment value stored in the table correct when verified using the standard loan installment formula? */

    SELECT loan_installment AS "Loan Installment Currently in Table",
           ROUND((Loan_Amount * ((loan_Interest_Rate/100)/12) * POWER(1 + ((loan_Interest_Rate/100)/12), Loan_Term)) / (POWER(1 + ((loan_Interest_Rate/100)/12), Loan_Term) - 1),2) AS "Loan Installment Verified"
    FROM loan_financial;



/* SQL Answer to Question 4 */ 
/* Question 4 - Which state has borrowers with the longest credit history, and what is the highest credit history length in years? */

    SELECT b.state AS "State",
            ROUND((to_date(last_credit_pull_date) - to_date(earliest_credit_line_date))/365,2) "Highest Credit History Length in Years"
    FROM borrower_credit bc, borrower b
    WHERE bc.borrower_id = b.borrower_id
    ORDER BY ROUND((to_date(last_credit_pull_date) - to_date(earliest_credit_line_date))/365,2) DESC;
/* The state with the consumer with the highest credit history length in years is California with a length of 73.09 years */



/* SQL Answer to Question 5 */ 
/* Question 5 - For this question, we decided to categorize the annual income based on standard 
US Income brackets. We used a case statement to filter the categories base on
this standard. We also found the average loan amount for each group. We then
ordered the data by average loan amount and confirmed that on average as annual 
income increases, individuals are typically granted larger loans. Specifically, 
those in lower class average $6,830 loans while upper class averages $23,450 loans */

    
    SELECT ROUND(avg(loan_amount)) AS "LoanAmount",
        CASE 
            WHEN annual_income <= 30000 THEN 'Lower'
            WHEN annual_income > 30000 AND annual_income <= 60000 THEN 'LowerMiddle'
            WHEN annual_income > 60000 AND annual_income <= 95000 THEN 'Middle'
            WHEN annual_income > 95000 AND annual_income <= 155000 THEN 'UpperMiddle'
            WHEN annual_income > 155000 THEN 'Upper' 
        END AS IncomeCategory
    FROM borrower_income bi, loan l, loan_financial lf
    WHERE bi.borrower_id = l.borrower_id AND l.loan_id = lf.loan_id 
    GROUP BY CASE WHEN annual_income <= 30000 THEN 'Lower' WHEN annual_income > 30000 AND annual_income <= 60000 THEN 'LowerMiddle' WHEN annual_income > 60000 AND annual_income <= 95000 THEN 'Middle' WHEN annual_income > 95000 AND annual_income <= 155000 THEN 'UpperMiddle' WHEN annual_income > 155000 THEN 'Upper' END
    ORDER BY ROUND(avg(loan_amount));

    

/* End of Phase 3 Script */