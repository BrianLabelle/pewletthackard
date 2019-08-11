-- Data Analysis
-- Once we have completed the imports, we need to address the following:

-- 1.List the following details of each employee: 
-- employee number, last name, first name, gender, and salary.

select e.emp_no, e.last_name, e.first_name, e.gender, s.salary from employees e
left join salaries s on s.emp_no = e.emp_no 
order by emp_no

 
-- 2. List employees who were hired in 1986.
-- The query with an order by employee number.

select * from employees
where date_part('year',hire_date) = 1986
order by emp_no

-- Download CSV File: 2019-08-Pewlett-Hackard-Data-Analysis-Question-02-Order-By-Emp-No.csv

 
-- or order by 1986 then month then day then employee number.

select * from employees
where date_part('year',hire_date) = 1986
order by date_part('month',hire_date), date_part('day',hire_date),emp_no 




-- 3. List the manager of each department with the following information: department number, department name, the -- manager's employee number, last name, first name, and start and end employment dates. 

select d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name, dm.from_date, dm.to_date from dept_manager as dm
join employees e on dm.emp_no = e.emp_no
join departments d on d.dept_no = dm.dept_no

 



-- 4. List the department of each employee with the following information: employee number, last name, first name, -- and department name.
-- * Note several employees are possibly in multiple departments.

select e.emp_no, e.last_name, e.first_name, d.dept_name from dept_emp as de
join employees e on de.emp_no = e.emp_no
join departments d on d.dept_no = de.dept_no
order by emp_no
 


-- 5. List all employees whose first name is "Hercules" and last names begin with "B."

select * from employees
where first_name = 'Hercules' and last_name LIKE 'B%'
order by emp_no

 
-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.

select e.emp_no, e.last_name, e.first_name, d.dept_name from dept_emp as de
join employees e on de.emp_no = e.emp_no
join departments d on d.dept_no = de.dept_no
where dept_name = 'Sales'
order by emp_no

 


-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

select e.emp_no, e.last_name, e.first_name, d.dept_name from dept_emp as de
join employees e on de.emp_no = e.emp_no
join departments d on d.dept_no = de.dept_no
where dept_name in('Sales','Development')
order by emp_no
 

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

select last_name, count(*) as count_name from employees
group by last_name
order by count_name desc

 
-- BONUS:
-- the key SQL query tis to group by the title from the title table joining with the salaries table to sum up the salaries by department
-- then divide by the count then round the results to 2 positions for the average salary.

select t.title as "Title", round(sum(salary)/count(*),2) as "Average Salary" from salaries s
join titles t on t.emp_no = s.emp_no
group by t.title;



-- Epilogue: Employee Number : 499942.
select * from employees where emp_no = '499942'
