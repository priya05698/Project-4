SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

--PROJECT TASK--

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"


INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;


-- Task 2: Update an Existing Member's Address--

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
SELECT * FROM members;


-- Task 3: Delete a Record from the Issued Status Table-- 
-- Objective: Deleting the record with issued_id = 'IS121' from the issued_status table.--

SELECT * FROM issued_status
WHERE issued_id = 'IS121';

DELETE FROM issued_status
WHERE issued_id = 'IS121'
SELECT * FROM issued_status;

-- Task 4: Retrieve All Books Issued by a Specific Employee --
-- Objective: Selecting all books issued by the employee with emp_id = 'E101'.--

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';


-- Task 5: List Members Who Have Issued More Than One Book -- 
--Objective: Using GROUP BY to find members who have issued more than one book.--

SELECT 
issued_emp_id
--COUNT(issued_id) AS total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT (issued_id) > 1

--CTAS--
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**--

CREATE TABLE book_cnts
AS
SELECT 
b.isbn,
b.book_title,
COUNT(ist.issued_id) AS no_issued 
FROM books as b
JOIN
issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2

SELECT * FROM book_cnts;

-- Task 7. Retrieve All Books in a Specific Category--

SELECT * FROM books
WHERE category = 'Classic'

-- Task 8: Find Total Rental Income by Category--

SELECT 
b.category,
SUM(b.rental_price),
COUNT (*)
FROM books as b
JOIN
issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1

--Task 9: List Members Who Registered in the Last 1 year--

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '365 days'

-- Task 10: List Employees with Their Branch Manager's Name and their branch details--

SELECT 
e1.*,
b.manager_id,
e2.emp_name AS manager
FROM employees AS e1
JOIN
branch AS b
ON b.branch_id = e1.branch_id
JOIN
employees AS e2
ON b.manager_id = e2.emp_id

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD--

CREATE TABLE books_price_greater_than_seven
AS
SELECT * FROM books
WHERE rental_price > 7

SELECT *
FROM books_price_greater_than_seven

--Task 12: Retrieve the List of Books Not Yet Returned--

SELECT 
DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL

SELECT * FROM return_status


 --Task 13: Identifying Members with Overdue Books--
 --Write a query to identify members who have overdue books--
 -- (assume a 120-day return period). Display the member's_id, member's name, book title, days overdue and issue date.--

 SELECT
 ist.issued_member_id,
 m.member_name,
 bk.book_title,
 ist.issued_date,
 CURRENT_DATE - ist.issued_date AS over_due_days
 FROM issued_status AS ist
 JOIN
 members AS m
 ON m.member_id = ist.issued_member_id
 JOIN
 books AS bk
 ON bk.isbn = ist.issued_book_isbn
 LEFT JOIN
 return_status AS rs
 ON rs.issued_id = ist.issued_id
 WHERE rs.return_date IS NULL
 AND
(CURRENT_DATE - ist.issued_date) > 120
ORDER BY 1

