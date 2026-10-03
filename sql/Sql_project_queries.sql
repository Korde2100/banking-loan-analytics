-- BANK LOAN ANALYSIS

create table Bank_loan( State_Abbr varchar(50),	Account_ID varchar(50),	Age varchar(10), BH_Name varchar(50),Bank_Name varchar(50),
	Branch_Name varchar(50),	Caste varchar(50),	Center_Id varchar(50),	City varchar(50),	Client_id bigint,	Client_Name varchar(50),
	Close_Client varchar(50),	Closed_Date date,	Credif_Officer_Name varchar(50),	Date_of_Birth date,	Disb_By varchar(50),
	Disbursement_Date date,	Disbursement_Date_Years varchar(50),	Gender_ID varchar(50),	Home_Ownership varchar(50),	Loan_Status varchar(50),
	Loan_Transfer_date varchar(50),	Next_Meeting_Date date,	Product_Code varchar(50),	Grrade varchar(50),	Sub_Grade varchar(50),
	Product_Id varchar(50),	Purpose_Category varchar(50),	Region_Name	 varchar(50),Religion varchar(50),	Verification_Status varchar(50),
	State_Name varchar(50),	Tranfer_Logic varchar(50),	Is_Delinquent_Loan varchar(50),	Is_Default_Loan varchar(50),
	Age_T varchar(20), 	Delinq_2_Yrs tinyint,	Application_Type varchar(50),	Loan_Amount bigint,	Funded_Amount float,	Funded_Amount_Inv float,
	Term varchar(50),	Int_Rate float,	Total_Pymnt float8,	Total_Pymnt_inv float,	Total_Rec_Prncp float,	Total_Fees float,
 	Total_Rrec_int float,	Total_Rec_Late_fee float8,	Recoveries float,	Collection_Recovery_fee float);

select * from bank_loan;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bank Data Analystics.csv'
ignore
INTO TABLE bank_loan
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
ignore 1 rows ; 


-- 1. Total Collection
SELECT round(sum(Total_Pymnt),2) AS Total_Collection
FROM bank_loan ;

-- 2. Total Interest
SELECT round(sum(Total_Rrec_int),2) AS Total_Interest
FROM bank_loan;

-- 3. Number of Verified Loans
SELECT COUNT(*) AS Verified_Loans_Count
FROM bank_loan
WHERE `Verification_Status` IN ('Verified', 'Source Verified');

-- 4. Default Loan Count
SELECT COUNT(*) AS Default_Loan_Count
FROM BankData
WHERE `Is Default Loan` = 'Y';

-- 5. Delinquent Loan Rate
SELECT
ROUND(SUM(CASE WHEN `Is_Delinquent_Loan` = 'Y' THEN 1 ELSE 0 END)
* 100.0 / COUNT(*), 2) AS Delinquent_Rate_Percentage
FROM bank_loan;

-- 6. Default Loan Rate
SELECT
ROUND(SUM(CASE WHEN `Is_Default_Loan` = 'Y' THEN 1 ELSE 0 END) *
100.0 / COUNT(*), 2) AS Default_Rate_Percentage
FROM bank_loan;

-- 7. Branch-Wise Highest 2 Performance (By Loan Amount)
SELECT `Branch_Name`, SUM(`Loan_Amount`) AS Total_Loan_Amount
FROM bank_loan
GROUP BY `Branch_Name`
ORDER BY Total_Loan_Amount DESC
LIMIT 2;

-- 8. Disbursement Trend (By Year)
SELECT `Disbursement_Date_Years` AS Year, COUNT(*) AS Total_Loans,
SUM(`Loan_Amount`) AS Total_Amount
FROM bank_loan
GROUP BY `Disbursement_Date_Years`
ORDER BY Year;


-- 9. Age Group Wise Loan
SELECT `Age`, COUNT(*) AS Total_Loans, SUM(`Loan_Amount`) AS
Total_Amount
FROM bank_loan
GROUP BY `Age`
ORDER BY `Age`;


-- 10. Grade Wise Loan
SELECT `Grrade`, COUNT(*) AS Total_Loans, SUM(`Loan_Amount`) AS
Total_Amount
FROM bank_loan
WHERE `Grrade` IS NOT NULL AND `Grrade` != ''
GROUP BY `Grrade`
ORDER BY `Grrade`;

-- 11. Loan Maturity (Term)
SELECT `Term`, COUNT(*) AS Total_Loans, SUM(`Loan_Amount`) AS
Total_Amount
FROM bank_loan
GROUP BY `Term`
ORDER BY `Term`;

-- 12. Loan Status Wise
SELECT `Loan_Status`, COUNT(*) AS Total_Loans, SUM(`Loan_Amount`) AS
Total_Amount
FROM bank_loan
GROUP BY `Loan_Status`
ORDER BY Total_Loans DESC;


-- 13. Product Group Wise Loan
SELECT `Product_Code`, COUNT(*) AS Total_Loans, SUM(`Loan_Amount`) AS
Total_Amount
FROM bank_loan
GROUP BY `Product_Code`
ORDER BY Total_Loans DESC;




-- CREDIT AND DEBIT BANK ANALYSIS

CREATE TABLE credit_debit(Customer_ID varchar(50),Customer_Name varchar(50),Account_Number varchar(50),Transaction_Date date,
Transaction_Type varchar(50),Amount float,Balance float,Description varchar(50),Branch varchar(50),Transaction_Method varchar(50),
Currency varchar(50),Bank_Name varchar(50),Risk varchar(50),Flaged_Transactions varchar(50));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Debit and Credit bankingg_data.csv'
ignore
INTO TABLE bank_loan
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
ignore 1 rows ; 


-- 1.Total Credit Amount
SELECT SUM(amount) as Total_Credit_Amount
FROM credit_debit
WHERE Transaction_Type = 'Credit';

-- 2.Total Debit Amount
select sum(amount) as Total_Debit_Amount
FROM credit_debit
WHERE Transaction_Type = 'Debit';

-- 3.Net Transaction Amount
SELECT
 ROUND(SUM(CASE WHEN transaction_type = 'Credit' THEN amount ELSE 0 END) -
      SUM(CASE WHEN transaction_type = 'Debit' THEN amount ELSE 0 END),2) AS net_transaction_amount
 FROM credit_debit;

-- 4. Credit to Debit Ratio
SELECT
 ROUND(SUM(CASE WHEN transaction_type = 'Credit' THEN amount ELSE 0 END) /
        SUM(CASE WHEN transaction_type = 'Debit' THEN amount ELSE 0 END),2) AS credit_debit_ratio
FROM credit_debit;


-- 5.Account Activity Ratio
SELECT
 ROUND((COUNT(customer_id)) / NULLIF(SUM(amount), 0),4) AS account_activity_ratio
 FROM credit_debit;


-- 1. Transaction Amount by Branch
SELECT branch,
round(SUM(amount),2) AS total_amount
FROM credit_debit
GROUP BY branch
ORDER BY total_amount DESC;

-- 2.Transaction Amount by Bank Name
SELECT bank_name,
round(SUM(amount),2) AS total_amount
FROM  credit_debit
GROUP BY bank_name
ORDER BY total_amount DESC;

-- 3. Transaction count by Month
SELECT
DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
COUNT(*) AS total_transaction_count
FROM credit_debit
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY transaction_month asc;

-- 4. High Risk Count
SELECT risk,
COUNT(*) AS transaction_count
FROM credit_debit
GROUP BY risk;

-- 5. Transactions by Transaction Method
SELECT transaction_method,
COUNT(*) AS total_transaction_count
FROM credit_debit
GROUP BY transaction_method
ORDER BY total_transaction_count DESC;



-- 6.Flagged Count by Month
 SELECT
 DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
 COUNT(*) AS high_risk_count
 FROM credit_debit
 WHERE risk = 'High Risk'  -- matches your exact text value
 GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
 ORDER BY transaction_month asc;

-- 7.Growth Rate by Month and Branch

WITH MonthlyCounts AS (
   SELECT
     DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
     COUNT(*) AS current_month_count
    FROM credit_debit
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m'))
 
   SELECT
    transaction_month,
    current_month_count,
    LAG(current_month_count) OVER (ORDER BY transaction_month) AS previous_month_count,
 
    ROUND(((current_month_count - LAG(current_month_count) OVER (ORDER BY transaction_month)) * 100.0)
        / NULLIF(LAG(current_month_count) OVER (ORDER BY transaction_month), 0),2) AS count_growth_rate_pct
    FROM MonthlyCounts
    ORDER BY transaction_month DESC;

