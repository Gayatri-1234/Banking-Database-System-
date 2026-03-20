create Database Banking_system;
use Banking_system  ;
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(15)
    );
    
    CREATE TABLE Accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    account_type ENUM('savings', 'checking') NOT NULL,
    balance DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    transaction_type ENUM('deposit', 'withdrawal') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

INSERT INTO Customers (first_name, last_name, email, phone_number)
VALUES ('John', 'Doe', 'john.doe@example.com', '555-1234'),
	   ('ONKAR','CHOUGULE','omkarchougule@gmail.com',7438415692),
       ('AKSHAY', 'SHAHA','akshayshaha@gamil.com',7841236954),
	   ('SONALI','POWER','sonalipower@gamil.com',7548123689),
	   ('SANKET', 'KUMAR','sanketkumar@gmail.com',9475861237),
	   ('PRANJLI', 'MISAL','pranjalimisal@gmail.com',7412365895),
		('SHITAL', 'PATIL','shiatlpatil@gmail.com',9754861234),
		('GAYATRI', 'JANGAM','gayatrijangam@gmail.com',8457912364);

INSERT INTO Accounts (customer_id, account_type, balance)
VALUES (1, 'savings', 1000.00),
(2,'savings',5000.00),
(2,	'checking',	1500.00	),
(2,'savings',3500.00),
(2,	'checking',	1200.00),	
(3,'savings',7000.00),	
(5,'savings',8000.00),	
(5,'checking',	3000.00);

INSERT INTO Transactions (account_id, transaction_type, amount)
VALUES (1, 'deposit', 500.00),
(2,'deposit',500.00),
(4,'deposit',300.00	),
(5,	'deposit',1000.00),	
(6,'deposit',2000.00),	
(2,'withdrawal',200.00),
(3,'withdrawal',150.00),	
(6,'withdrawal',500.00),
(7,	'withdrawal',100.00),
(5,	'deposit',1000.00),	
(6,	'withdrawal',1000.00);

select*from  Customers;
select*from Accounts;
select*from Transactions;

#Retrieve a list of all customers with their first and last names.
select first_name,last_name from Customers;

#Find the balance of a specific customer's account by customer_id.
select balance
from Accounts
where customer_id=1;

#Calculate the total balance of all customer accounts combined.
SELECT SUM(balance) AS total_balance FROM Accounts;

#Count how many accounts each customer has.
SELECT customer_id, COUNT(account_id) AS num_accounts
FROM Accounts
GROUP BY customer_id;

#Find customers who have more than one account.
SELECT customer_id, COUNT(account_id) AS num_accounts
FROM Accounts
GROUP BY customer_id
HAVING COUNT(account_id) > 1;

#Find the average balance for each account type
SELECT account_type, AVG(balance) AS average_balance
FROM Accounts
GROUP BY account_type;

#Identify which account has the highest number of transactions
SELECT account_id, COUNT(*) AS num_transactions
FROM Transactions
GROUP BY account_id
ORDER BY num_transactions DESC
LIMIT 1;

#Identify accounts that have withdrawal more than $1000 in total.
SELECT account_id, SUM(amount) AS total_withdrawal
FROM Transactions
WHERE transaction_type = 'withdrawal'
GROUP BY account_id
HAVING total_withdrawal > 1000;

#Find the customer name along with their account balance by joining the Customers and Accounts tables.
SELECT c.first_name, c.last_name, a.balance
FROM Customers c
INNER JOIN Accounts a ON c.customer_id = a.customer_id;

#Find Accounts Without Transactions
SELECT a.account_id, a.account_type
FROM Accounts a
LEFT JOIN Transactions t ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL;

#Get All Accounts with Their Total Transaction Amount
SELECT a.account_id, a.account_type, SUM(t.amount) AS total_transaction
FROM Accounts a
RIGHT JOIN Transactions t ON a.account_id = t.account_id
GROUP BY a.account_id;

#Get All Transactions and Their Account Details
SELECT t.transaction_id, t.transaction_type, t.amount,a.account_id, a.account_type
FROM Transactions t
LEFT JOIN Accounts a ON t.account_id = a.account_id
UNION
SELECT t.transaction_id, t.transaction_type, t.amount,a.account_id, a.account_type
FROM Transactions t
RIGHT JOIN Accounts a ON t.account_id = a.account_id;

#Generate All Possible Customer and balance Combinations
SELECT c.first_name, c.last_name, a.balance
FROM Customers c
cross join (select 1000 as balance  ) a;

#Get account type with account id and customer id
SELECT e1.account_id, e1.account_type as Accounts, e2.account_type  as Customers
from Accounts e1
inner join Accounts e2
on e1.account_id=e2.customer_id;

CREATE VIEW CustomerAccountInfo AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone_number,
    a.account_id,
    a.account_type,
    a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id;
select * from CustomerAccountInfo;

CREATE VIEW CustomersWithMultipleAccounts AS
SELECT 
    c.first_name,
    c.last_name,
    COUNT(a.account_id) AS num_accounts
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id
HAVING COUNT(a.account_id) > 1;
select * from CustomersWithMultipleAccounts;

CREATE VIEW TransactionHistory AS
SELECT 
    t.transaction_id,
    t.transaction_type,
    t.amount,
    a.account_id,
    a.account_type
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id;
select * from TransactionHistory;
