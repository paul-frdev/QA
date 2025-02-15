-- check for null 
SELECT *
FROM customers
WHERE address2 IS NOT null;


SELECT coalesce(lastName, 'Empty'), * from customers
where (age IS NULL);

-- Aggregate Functions
select max(birth_date) from employees;


select count(countrycode) from countrylanguage
where isofficial = true;


select AVG(population) from city
where countrycode = 'NLD';

--BETWEEN + AND
SELECT *
FROM customers
WHERE age BETWEEN 30 AND 50 AND income < 50000;

SELECT AVG(income)
FROM customers
WHERE age BETWEEN 20 AND 50;

--Comparison Operators
SELECT COUNT(firstName)
FROM customers
WHERE gender = 'F' and state = 'OR';

SELECT COUNT(income)
FROM customers
WHERE age > 44 and income >= 100000;

SELECT COUNT(income)
FROM customers
WHERE age >= 30 and age <= 50 AND income < 50000;

SELECT AVG(income)
FROM customers
WHERE age > 20 and age < 50;

--Conditional Statements
SELECT prod_id, title, price, 
    CASE   
      WHEN  price > 20 THEN 'expensive'
      WHEN  price <= 10 THEN  'cheap'
      WHEN  price BETWEEN 10 and 20  THEN 'average'
    END AS "price class"
FROM products

--Date Filtering
SELECT AGE(birth_date), * FROM employees
WHERE (
   EXTRACT (YEAR FROM AGE(birth_date))
) > 60 ;


SELECT count(emp_no) FROM employees
where EXTRACT (MONTH FROM hire_date) = 2;

--Distinct
SELECT DISTINCT title FROM titles;

SELECT COUNT(DISTINCT birth_date)
from employees;

--Group By
SELECT hire_date, COUNT(emp_no) as "amount"
FROM employees
GROUP BY hire_date
ORDER BY "amount" DESC;

--Having
SELECT e.emp_no, count(t.title) as "amount of titles"
FROM employees as e
JOIN titles as t ON t.id=e.id
WHERE EXTRACT (YEAR FROM e.hire_date) > 1991
GROUP BY e.emp_no
HAVING count(t.title) > 2
ORDER BY e.emp_no;

--IN
SELECT COUNT(orderid)
FROM orders
WHERE customerid IN (7888, 1082, 12808, 9623)

SELECT COUNT(id)
FROM city
WHERE district IN ('Zuid-Holland', 'Noord-Brabant', 'Utrecht');

--LIKE Operator
SELECT emp_no, first_name, EXTRACT (YEAR FROM AGE(birth_date)) as "age" FROM employees
WHERE first_name ILIKE 'M%';

SELECT count(emp_no) FROM employees
WHERE first_name ILIKE 'A%R';
                                                  
SELECT count(customerid) FROM customers
WHERE zip::text LIKE '%2%';

SELECT count(customerid) FROM customers
WHERE zip::text LIKE '2_1%';

SELECT coalesce(state, 'No State') as "State" FROM customers
WHERE phone::text LIKE '302%';

--NULLIF

SELECT prod_id, title, price, NULLIF(special, 0) as "special"
FROM products

--Null Values
SELECT avg(coalesce(age, 15)) FROM "Student";

SELECT id, coalesce(name, 'fallback'), coalesce(lastName, 'lastName'), age FROM "Student";

--Operator precendence
SELECT firstname, income, age from customers
WHERE income > 50000 AND (age < 30 OR age >= 50)
and (country = 'Japan' OR country = 'Australia')

--Subqueries
SELECT c.firstname, c.lastname, o.orderid 
FROM orders AS o, (
    SELECT customerid, state, firstname, lastname
    FROM customers
) AS c
WHERE  o.customerid = c.customerid AND 
c.state IN ('NY', 'OH', 'OR')
ORDER BY o.orderid;

SELECT emp_no, first_name, last_name
FROM employees
WHERE emp_no IN (
    SELECT emp_no
    FROM dept_emp
    WHERE dept_no = (
        SELECT dept_no 
        FROM dept_manager
        WHERE emp_no = 110183
    )
)
ORDER BY emp_no

--Views
CREATE VIEW "90-95" AS
SELECT *
FROM employees as e
WHERE EXTRACT (YEAR FROM e.hire_date) BETWEEN 1990 AND 1995
ORDER BY e.emp_no;

CREATE VIEW "bigbucks" AS
SELECT e.emp_no, s.salary
FROM employees as e
JOIN salaries as s USING(emp_no)
WHERE s.salary > 80000
ORDER BY s.salary;