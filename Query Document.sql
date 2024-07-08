-- Overall Grid View
SELECT * FROM Bank_loan_data

-- Total loan applicants
SELECT COUNT(id) AS Total_loan_applicants FROM Bank_loan_data

-- Total loan applicants from last month which is DECEMBER 2021
SELECT COUNT(id) AS Total_loan_applicants FROM Bank_loan_data
WHERE MONTH(issue_date) = 12

-- if we have more than one year so we can use YEAR function 
SELECT COUNT(id) AS MTD_Total_loan_applicants FROM Bank_loan_data 
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021

-- PMTD shows the NOVEMBER month total applicants
SELECT COUNT(id) Previous_MTD_loan_applications FROM Bank_loan_data 
WHERE MONTH(issue_date) = 11

-- total amount provided by the bank to the customer
SELECT SUM(loan_amount) AS Total_funded_amount FROM Bank_loan_data

-- total amount provided by the bank to the customer in DECEMBER month (MTD)
SELECT SUM(loan_amount) AS MTD_funded_amount FROM Bank_loan_data
WHERE MONTH(issue_date) = 12

-- total amount provided by the bank to the customer in NOVEMBER month (PMTD)
SELECT SUM(loan_amount) AS PMTD_funded_amount FROM Bank_loan_data 
WHERE MONTH(issue_date) = 11

-- total amount recieved by the customer to the bank
SELECT SUM(total_payment) AS Total_amount_recieved FROM Bank_loan_data

-- total amount recieved by the customer to the bank in DECEMBER month (MTD)
SELECT SUM(total_payment) AS MTD_amount_recieved FROM Bank_loan_data
WHERE MONTH(issue_date) = 12

-- total amount recieved by the customer to the bank in NOVEMBER month (PMTD)
SELECT SUM(total_payment) AS PMTD_amount_recieved FROM Bank_loan_data
WHERE MONTH(issue_date) = 11

-- Average interest rate which bank provides
SELECT ROUND (AVG (int_rate) * 100,2)  AS Averag_interest_rate FROM Bank_loan_data

-- Average interest rate which bank provides for the month of DECEMBER (MTD)
SELECT ROUND (AVG (int_rate) * 100,2)  AS MTD_Averag_interest_rate FROM Bank_loan_data 
WHERE MONTH(issue_date) = 12

-- Average interest rate which bank provides for the month of NOVEMBER (PMTD)
SELECT ROUND (AVG (int_rate) * 100,2)  AS PMTD_Averag_interest_rate FROM Bank_loan_data 
WHERE MONTH(issue_date) = 11
 
-- Average debt to income ratio which bank checks for the financial health of customer 
-- which should range b/w 30-35 or 25-30 depending on bank, it should not be very high 
-- ( this means the person is poor with finance )
-- and
-- not be very low ( this means the person can't repay back the money )
-- both are bad situations

SELECT ROUND(AVG(dti) * 100,2) AS Average_debt_to_income_ratio FROM Bank_loan_data

-- Average debt to income ratio for the month of DECEMBER (MTD)
SELECT ROUND(AVG(dti) * 100,2) AS Average_debt_to_income_ratio FROM Bank_loan_data
WHERE MONTH(issue_date) = 12

-- Average debt to income ratio for the month of NOVEMBER (PMTD)
SELECT ROUND(AVG(dti) * 100,2) AS Average_debt_to_income_ratio FROM Bank_loan_data
WHERE MONTH(issue_date) = 11

-- GOOD LOAN application percentage, people who have fully paid their loan or paying their 
-- installments on time
-- calculated as ( total number of good loan applications * 100 / total loan applications )
-- multiplying with 100 for percentage
SELECT 
  (COUNT (CASE WHEN loan_status = 'Fully paid' OR loan_status = 'Current' THEN id END) * 100)
	  /
   COUNT(id) AS Good_loan_application_percentage
	  FROM Bank_loan_data

-- Instead of loan_status we can also use id (same result)
-- this gives total number of good loan applictions
SELECT COUNT(loan_status) AS Good_loan_application  FROM Bank_loan_data 
WHERE loan_status = 'Fully paid' OR loan_status = 'Current'

--Using IN function makes more clear where clause
SELECT COUNT(loan_status) AS Good_loan_application  FROM Bank_loan_data
WHERE loan_status IN('Fully paid', 'Current')

-- total good loan funded which will surely give profit
SELECT SUM(loan_amount) AS Good_loan_Funded_amount FROM Bank_loan_data 
WHERE loan_status = 'Fully paid' OR loan_status = 'Current'

-- Total amount recieved from good loans (using IN function)
-- GOOD LOAN RECIEVED AMOUNT - GOOD LOAN FUNDED GIVES THE TOTAL PROFIT WHICH BANK MADE
SELECT SUM(total_payment) AS Good_loan_recieved_amount FROM Bank_loan_data
WHERE loan_status IN ('Fully paid', 'Current')

-- Without using IN function
SELECT SUM(total_payment) AS Good_loan_recieved_amount FROM Bank_loan_data
WHERE loan_status ='Fully paid' OR loan_status = 'Current'

-- BAD LOAN total application percentage 
-- people who are defaulters come in this category who don't pay installments on time
-- who fail to re pay the money to the bank
-- calculated as ( total bad loan applications * 100 / total loan applications )
SELECT 
      (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) 
	   /
	   COUNT(id) AS Bad_loan_application_percentage
	   FROM Bank_loan_data

-- this gives total number of bad loan applictions
SELECT COUNT(id) AS Bad_loan_applications  FROM Bank_loan_data
 WHERE loan_status = 'Charged Off'	   
	
-- total bad loan funded which is at risk ( bad for the bank )
SELECT SUM(loan_amount) AS Bad_loan_funded_amount FROM Bank_loan_data
WHERE loan_status = 'Charged Off'

-- total amount recieved from the bad loan funded 
-- TOTAL BAD LOAN AMOUNT FUNDED - TOTAL BAD LOAN AMOUNT RECIEVED SHOWS THE LOSS OF AMOUNT 
SELECT SUM(total_payment) AS Bad_loan_recieved_amount FROM Bank_loan_data
WHERE loan_status = 'Charged Off'


-- this shows grid view for loan status wrt total loan applications, total funded amount,
-- total amount recieved, average interest rate and debt to income ratio
-- shows above parameters wrt good loan and bad loan 
SELECT 
       loan_status,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
	   SUM(total_payment) AS Total_recieved_amount,
	   AVG(int_rate * 100) AS Average_interest_rate,
	   AVG(dti * 100) AS Debt_to_income_ratio
	   FROM Bank_loan_data
	   GROUP BY  loan_status


-- shows for the month of DECEMBER that how much money is funded and recieved
SELECT 
      loan_status,
	  SUM(loan_amount) AS MTD_funded_amount,
	  SUM(total_payment) AS MTD_recieved_amount
	  fROM Bank_loan_data
	  WHERE MONTH(issue_date) = 12
	  GROUP BY loan_status

-- shows month wise total applications, funded amount and recieved amount
SELECT
      MONTH(issue_date) AS Month_number,
      DATENAME(MONTH, issue_date) AS Month_name,
	  COUNT(id) AS Total_loan_applications,
	  SUM(loan_amount) AS Total_funded_amount,
	  SUM(total_payment) AS Total_recieved_amount
	  FROM Bank_loan_data

	  GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
	  ORDER BY MONTH(issue_date)


-- order by address state, shows address_state wise total applications, 
-- funded amount and recieved amount
SELECT 
       address_state,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_recieved_amount
	   FROM Bank_loan_data
	   GROUP BY address_state
	   ORDER BY address_state


-- order by total loan applicants, shows address_state wise total applications, 
-- funded amount and recieved amount
SELECT 
       address_state,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_recieved_amount
	   FROM Bank_loan_data
	   GROUP BY address_state
	   ORDER BY COUNT(id) desc

-- order by total payment recieved, shows address_state wise total applications, 
-- funded amount and recieved amount
SELECT 
       address_state,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_recieved_amount
	   FROM Bank_loan_data
	   GROUP BY address_state
	   ORDER BY SUM(total_payment) DESC

-- shows term ( 36 months and 60 months ) wise total applications, 
-- funded amount and recieved amount
SELECT 
      term,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_recieved_amount
	   FROM Bank_loan_data
	   GROUP BY term
	   ORDER BY term

-- shows emp_length ( how many years the person has worked ) 
-- wise total applications, 
-- funded amount and recieved amount
SELECT 
      emp_length,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_recieved_amount
	   FROM Bank_loan_data
	   GROUP BY emp_length
	   ORDER BY emp_length

-- order by count id ( total loan applications )
SELECT 
      emp_length,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_recieved_amount
	   FROM Bank_loan_data
	   GROUP BY emp_length
	   ORDER BY COUNT(id) DESC

-- shows purpose of loan wise total applications, 
-- funded amount and recieved amount  
SELECT 
       purpose,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_recieved_amount
	   FROM Bank_loan_data
	   GROUP BY purpose
	   ORDER BY purpose

-- Order by count id ( total loan applications )
SELECT 
       purpose,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_recieved_amount
	   FROM Bank_loan_data
	   GROUP BY purpose
	   ORDER BY COUNT(id) DESC

-- shows home ownership ( RENT, MORTAGE, OWN) wise total applications, 
-- funded amount and recieved amount  
SELECT 
       home_ownership,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_recieved_amount
	   FROM Bank_loan_data
	   GROUP BY home_ownership
	   ORDER BY Count(id) DESC

-- we can apply some filters also like in power BI 
SELECT 
       home_ownership,
	   COUNT(id) AS Total_loan_applications,
	   SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_recieved_amount
	   FROM Bank_loan_data
	   WHERE grade = 'A' AND address_state = 'CA'
	   GROUP BY home_ownership
	   ORDER BY Count(id) DESC





      

	  
      