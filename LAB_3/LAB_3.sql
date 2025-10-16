CREATE DATABASE BANK;
USE BANK;

CREATE TABLE Branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50),
    assets REAL
);

CREATE TABLE BankAccount (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(50),
    balance REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE BankCustomer (
    customer_name VARCHAR(50) PRIMARY KEY,
    customer_street VARCHAR(50),
    customer_city VARCHAR(50)
);

CREATE TABLE Depositer (
    customer_name VARCHAR(50),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES BankCustomer(customer_name),
    FOREIGN KEY (accno) REFERENCES BankAccount(accno)
);

CREATE TABLE Loan (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(50),
    amount REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

INSERT INTO Branch VALUES
('SBI_ResidencyRoad', 'Bangalore', 50000000),
('ICICI_MG', 'Bangalore', 40000000),
('HDFC_KarolBagh', 'Delhi', 35000000),
('Axis_CP', 'Delhi', 45000000),
('Canara_Jayanagar', 'Bangalore', 30000000);
select *from Branch;
INSERT INTO BankAccount VALUES
(1, 'SBI_ResidencyRoad', 25000),
(2, 'SBI_ResidencyRoad', 42000),
(3, 'ICICI_MG', 15000),
(4, 'HDFC_KarolBagh', 60000),
(5, 'Axis_CP', 52000),
(6, 'Canara_Jayanagar', 18000),
(7, 'ICICI_MG', 30000),
(8, 'SBI_ResidencyRoad', 22000),
(9, 'Axis_CP', 27000),
(10, 'SBI_ResidencyRoad', 40000);
select *from BankAccount;
INSERT INTO BankCustomer VALUES
('Avinash', 'Bull_Temple_Road', 'Bangalore'),
('Dinesh', 'Bannergatta_Road', 'Bangalore'),
('Mohan', 'NationalCollege_Road', 'Bangalore'),
('Nikil', 'Akbar_Road', 'Delhi'),
('Ravi', 'Prithviraj_Road', 'Delhi');
select *from BankCustomer;
INSERT INTO Depositer VALUES
('Avinash', 8),
('Dinesh', 2),
('Dinesh', 10),
('Mohan', 3),
('Nikil', 4),
('Ravi', 5),
('Avinash', 1);
select *from Depositer;
INSERT INTO Loan VALUES
(101, 'SBI_ResidencyRoad', 80000),
(102, 'ICICI_MG', 120000),
(103, 'Axis_CP', 95000),
(104, 'HDFC_KarolBagh', 70000),
(105, 'Canara_Jayanagar', 65000);
select *from Loan;
SELECT branch_name, (assets / 100000) AS "Assets in Lakhs" FROM Branch;

SELECT d.customer_name, b.branch_name, COUNT(*) AS Num_Accounts FROM Depositer d JOIN BankAccount b ON d.accno = b.accno GROUP BY d.customer_name, b.branch_name
HAVING COUNT(*) >= 2;

CREATE VIEW Branch_Loan_Summary AS SELECT branch_name, SUM(amount) AS Total_Loan_Amount FROM Loan GROUP BY branch_name;


SELECT * FROM Branch_Loan_Summary;

SELECT DISTINCT c.customer_name, b.balance FROM BankCustomer c JOIN Depositer d ON c.customer_name = d.customer_name JOIN BankAccount b ON d.accno = b.accno WHERE c.customer_city = 'Bangalore' AND b.balance > 20000;


SELECT DISTINCT d.customer_name
FROM Depositer d
JOIN BankAccount ba ON d.accno = ba.accno
JOIN Branch b ON ba.branch_name = b.branch_name
WHERE b.branch_city = 'Bangalore'
GROUP BY d.customer_name
HAVING COUNT(DISTINCT b.branch_name) = (
    SELECT COUNT(*)
    FROM Branch
    WHERE branch_city = 'Bangalore'
);


SELECT DISTINCT l.customer_name FROM (SELECT DISTINCT d.customer_name FROM Depositer d) AS account_holders RIGHT JOIN (SELECT DISTINCT bc.customer_name FROM BankCustomer bc WHERE EXISTS (SELECT 1 FROM Loan ln
JOIN Branch br ON ln.branch_name = br.branch_name WHERE bc.customer_name IN (SELECT borrower_name FROM Borrower WHERE loan_number = ln.loan_number))) AS l ON account_holders.customer_name = l.customer_name
WHERE account_holders.customer_name IS NULL;


SELECT branch_name, assets FROM Branch WHERE assets > ALL (SELECT assets FROM Branch WHERE branch_city = 'Delhi');


DELETE FROM Depositer WHERE accno IN (SELECT ba.accno FROM BankAccount ba JOIN Branch b ON ba.branch_name = b.branch_name
WHERE b.branch_city = 'Delhi'
);

DELETE FROM BankAccount WHERE branch_name IN (SELECT branch_name FROM Branch WHERE branch_city = 'Delhi'
);
