--  Data is from https://github.com/vrajmohan/pgsql-sample-data/tree/master/employee
-- Creating tables for PH-EmployeeDB

CREATE TABLE departments (
  dept_no VARCHAR(4) NOT NULL,
  dept_name VARCHAR(40) NOT NULL,
  PRIMARY KEY (dept_no),
  UNIQUE (dept_name)
);

CREATE TABLE employees (
  emp_no INT NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  gender VARCHAR NOT NULL,
  hire_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);


Select * From departments;

Select * From dept_emp limit 10;

Select * From dept_manager;

Select * From employees limit 10;

Select * From salaries;

Select * From titles limit 10;


-- CHALLENGE 7

-- Retrieve emp_no, first_name, and last_name columns from the employee

SELECT emp_no, first_name, last_name 
FROM Employees;
-- INTO retirement_titles
Where (birth_date BETWEEN '1952-01-01' AND '1955-12-31')

-- Retrieve title, from_date, and to_date columns from the titles table.

SELECT title, from_date, to_date
FROM titles
--INTO retirement_titles
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')

-- joining tables on primary key -> emp_no
-- include birth-date column - will filter later

-- #1-7 All Above Condensed Below

SELECT e.emp_no,
	   e.first_name,
	   e.last_name,
	   ti.title,
	   ti.from_date,
	   ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
	ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

Select * FROM retirement_titles limit 10

-- #8 Use DISTINCT ON with ORDER BY to remove duplicate rows
-- ? select to-date?
-- Through #15 below:

SELECT DISTINCT ON (rt.emp_no)
	rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles AS rt
WHERE rt.to_date = ('9999-01-01')
ORDER BY rt.emp_no, rt.to_date DESC;

Select * From retirement_titles limit 10;

-- #16 of challenge - retrieve the number of employees 
-- by their most recent job title who are about to retire.
-- Through #22 below:

SELECT COUNT(ut.title),
	ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER by count DESC;

Select * From retiring_titles


--------------------DELIVERABLE 2 Eligibility for mentorship program

SELECT DISTINCT ON (e.emp_no)
		e.emp_no,
		e.first_name,
		e.last_name,
		e.birth_date,
		de.from_date,
		de.to_date,
		ti.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
	ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND de.to_date = ('9999-01-01')
ORDER BY e.emp_no