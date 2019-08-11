# Homework 7: Employee Database: Mystery in Two Parts

![PewlettHackard](images/ph-logo-trimmed.jpg)


## Background

It is a beautiful spring day, and it is two weeks since you have been hired as a new data engineer at Pewlett Hackard. Your first major task is a research project on employees of the corporation from the 1980s and 1990s. All that remain of the database of employees from that period are six CSV files.

In this assignment, you will design the tables to hold data in the CSVs, import the CSVs into a SQL database, and answer questions about the data. In other words, you will perform:

1. Data Modeling
2. Data Engineering
3. Data Analysis

[**Summaried below. Additional details available reviewing this document.**](https://github.com/BrianLabelle/pewletthackard/blob/master/2019-PH-SQL-Employee-Database.docx)

_**Original screenshots include salary column as a Postgres money datatype which lead to problems in pandas, so an alter to the table afterwards with a change to a decimal datatype**_

# 1. Data Modeling

![PH-Data-Modeling](resources/2019-PH-SQL-ER-Diagram-Using-MySQL.png)

<b><font color=" #FC0007">Note:</font></b> I generated by ER diagram using MySQL back engineering feature. 


# 2. Data Engineering

![PH-Data-Modeling](images/postgres-db.jpg)

To view the PostGres SQL Schema go to the below link.
https://github.com/BrianLabelle/pewletthackard/blob/master/sql/2019-08-04-PostGres-SQL-Schema.sql

**Create SQL tables to house the required CSV files.**
It’s important to note that the sequence of creating the SQL tables is critical in order to properly implement the usage of primary keys & foreign keys constraints during the table creation phase. While it’s possible to alter the tables, it’s always best to map out the proper table creation sequence prior to starting. Creating the ER diagram helps with identifying the proper sequence. You must create the main data tables first that have no foreign key constraints, so Employees & Departments table are created first. The auxiliary supporting tables or passthrough join tables can only be created after as they contain foreign keys which point to the primary data tables. 

It’s also important to note that using a **standard naming convention with an underscore** shows that these tables are used as passthrough join tables. dept_emp table naming implies that this is a join table between the departments table and the employees table with implies 1 department name to many employees. As opposed to a single named table as in employees which only contains employees.

1. Create the Employees table with the emp_no as the primary key.
2. Create the departments table with the dept_no as primary key.
3. Creating the salaries & titles tables, they do not have any primary keys but they do have foreign keys back into the employees table.
4. Creating the dept_manager & dept_emp tables have 2 foreign keys which reference the employees table and the departments table.
5. When possible, default values were set based on possible future data entries if project is deemed usable. A default hiredate in the employee table was set to CURRENTDATE. Many other date fields called to_date were set with a default value of 9999-01-01 as a date in the future.

6. Next step is to import the CSV files into the tables.
      - [x] import employees.csv 
      - [x] import salaries.csv
      - [x] import titles.csv
      - [x] import departments.csv
      - [x] import dept_emp.csv
      - [x] import dept_manager.csv
      - [x] import employees.csv


# 3. Data Analysis

Once we have completed the imports, we need to address the following:


**1. List the following details of each employee: 
employee number, last name, first name, gender, and salary.**

            select e.emp_no, e.last_name, e.first_name, e.gender, s.salary from employees e
            left join salaries s on s.emp_no = e.emp_no 
            order by emp_no


[Download CSV File: 2019-08-Pewlett-Hackard-Data-Analysis-Question-01.csv](https://github.com/BrianLabelle/pewletthackard/blob/master/data_analysis/2019-08-Pewlett-Hackard-Data-Analysis-Question-01.csv)

Screenshot is a subset of the query data results, download CSV file for entire results.
![Data-Analysis-Screenshot-001](images/da-001.jpg)


_________________________________________________________________________________

**2. List employees who were hired in 1986.**
The query with an order by employee number.

            select * from employees
            where date_part('year',hire_date) = 1986
            order by emp_no


[Download CSV File: 2019-08-Pewlett-Hackard-Data-Analysis-Question-02-Order-By-Emp-No.csv](https://github.com/BrianLabelle/pewletthackard/blob/master/data_analysis/2019-08-Pewlett-Hackard-Data-Analysis-Question-02-Order-By-Emp-No.csv)

Screenshot is a subset of the query data results, download CSV file for entire results.
![Data-Analysis-Screenshot-002](images/da-002.jpg)

or order by 1986 then month then day then employee number.

            select * from employees
            where date_part('year',hire_date) = 1986
            order by date_part('month',hire_date), date_part('day',hire_date),emp_no 


[Download CSV File: 2019-08-Pewlett-Hackard-Data-Analysis-Question-02-Order-By-1986-Month-Day-Emp_No.csv](https://github.com/BrianLabelle/pewletthackard/blob/master/data_analysis/2019-08-Pewlett-Hackard-Data-Analysis-Question-02-Order-By-1986-Month-Day-Emp_No.csv)

Screenshot is a subset of the query data results, download CSV file for entire results.
![Data-Analysis-Screenshot-002b](images/da-002b.jpg)

_________________________________________________________________________________

**3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.**

            select d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name, dm.from_date, dm.to_date from dept_manager as dm
            join employees e on dm.emp_no = e.emp_no
            join departments d on d.dept_no = dm.dept_no



[Download CSV File: 2019-08-Pewlett-Hackard-Data-Analysis-Question-03-Dept-Managers.csv](https://github.com/BrianLabelle/pewletthackard/blob/master/data_analysis/2019-08-Pewlett-Hackard-Data-Analysis-Question-03-Dept-Managers.csv)

Screenshot is a subset of the query data results, download CSV file for entire results.
![Data-Analysis-Screenshot-003](images/da-003.jpg)


_________________________________________________________________________________

**4. List the department of each employee with the following information: employee number, last name, first name, and department name.**

_***Note several employees are possibly in multiple departments and/or have received promotions based date ranges with different titles and departments.**_


            select e.emp_no, e.last_name, e.first_name, d.dept_name from dept_emp as de
            join employees e on de.emp_no = e.emp_no
            join departments d on d.dept_no = de.dept_no
            order by emp_no


[Download CSV File: 2019-08-Pewlett-Hackard-Data-Analysis-Question-04-Dept-Employees.csv](https://github.com/BrianLabelle/pewletthackard/blob/master/data_analysis/2019-08-Pewlett-Hackard-Data-Analysis-Question-04-Dept-Employees.csv)

Screenshot is a subset of the query data results, download CSV file for entire results.
![Data-Analysis-Screenshot-004](images/da-004.jpg)


_________________________________________________________________________________

**5. List all employees whose first name is "Hercules" and last names begin with "B."**

            select * from employees
            where first_name = 'Hercules' and last_name LIKE 'B%'
            order by emp_no

[Download CSV File: 2019-08-Pewlett-Hackard-Data-Analysis-Question-05-Hercules-B.csv](https://github.com/BrianLabelle/pewletthackard/blob/master/data_analysis/2019-08-Pewlett-Hackard-Data-Analysis-Question-05-Hercules-B.csv)

Screenshot is a subset of the query data results, download CSV file for entire results.
![Data-Analysis-Screenshot-005](images/da-005.jpg)


_________________________________________________________________________________

**6. List all employees in the Sales department, including their employee number, last name, first name, and department name.**

            select e.emp_no, e.last_name, e.first_name, d.dept_name from dept_emp as de
            join employees e on de.emp_no = e.emp_no
            join departments d on d.dept_no = de.dept_no
            where dept_name = 'Sales'
            order by emp_no

[Download CSV File: 2019-08-Pewlett-Hackard-Data-Analysis-Question-06-Sales.csv](https://github.com/BrianLabelle/pewletthackard/blob/master/data_analysis/2019-08-Pewlett-Hackard-Data-Analysis-Question-06-Sales.csv)

Screenshot is a subset of the query data results, download CSV file for entire results.
![Data-Analysis-Screenshot-006](images/da-006.jpg)


_________________________________________________________________________________

**7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.**


            select e.emp_no, e.last_name, e.first_name, d.dept_name from dept_emp as de
            join employees e on de.emp_no = e.emp_no
            join departments d on d.dept_no = de.dept_no
            where dept_name in('Sales','Development')
            order by emp_no

[Download CSV File: 2019-08-Pewlett-Hackard-Data-Analysis-Question-07-Sales-Development.csv](https://github.com/BrianLabelle/pewletthackard/blob/master/data_analysis/2019-08-Pewlett-Hackard-Data-Analysis-Question-07-Sales-Development.csv)

Screenshot is a subset of the query data results, download CSV file for entire results.
![Data-Analysis-Screenshot-007](images/da-007.jpg)


_________________________________________________________________________________

**8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.**

            select last_name, count(*) as count_name from employees
            group by last_name
            order by count_name desc


[Download CSV File: 2019-08-Pewlett-Hackard-Data-Analysis-Question-08-Last_Name_Count_Desc.csv](https://github.com/BrianLabelle/pewletthackard/blob/master/data_analysis/2019-08-Pewlett-Hackard-Data-Analysis-Question-08-Last_Name_Count_Desc.csv)

Screenshot is a subset of the query data results, download CSV file for entire results.
![Data-Analysis-Screenshot-008](images/da-008.jpg)


_________________________________________________________________________________

 # **BONUS**
As you examine the data, you are overcome with a creeping suspicion that the dataset is fake. You surmise that your boss handed you spurious data in order to test the data engineering skills of a new employee. To confirm your hunch, you decide to take the following steps to generate a visualization of the data, with which you will confront your boss:

1. Import the SQL database into Pandas.

[**Click to view the Jupyter Notebooks Code Cell by Cell**](https://github.com/BrianLabelle/pewletthackard/blob/master/archive/2019-Pewlett-Hackard-Jupyter-Notebook-Cells.txt)

![Data-Analysis-Pandas-DataFrame](images/ph-dataframe-avg-salary-by-title.jpg)


## **Create a bar chart of average salary by title.**

      # plot dataframe for the average salary as a bar chart with the appropriate labels.
      df_salaries2.plot.bar()
      ax = df_salaries2['Average Salary'].plot(kind='bar', title ="Pewlett Hackard | Average Salary by Title", figsize=(15, 10), legend=False, fontsize=12)
      plt.xlabel("Pewlett Hackard | Title")
      plt.ylabel("Pewlett Hackard | Average Salary")

      plt.show()

![Data-Analysis-Bar-Chart](images/ph-notebook-avg-salary-by-title.jpg)


_________________________________________________________________________________

 # **EPILOGUE**
Evidence in hand, you march into your boss's office and present the visualization. With a sly grin, your boss thanks you for your work. On your way out of the office, you hear the words, "Search your ID number." You look down at your badge to see that your employee ID number is 499942.

**Employee Number : 499942.**

            select * from employees where emp_no = '499942'


![Data-Analysis-Epilogue](images/epilogue.jpg)


_________________________________________________________________________________

# Summary

**Create an image file of your ERD.**
[Download Image](https://github.com/BrianLabelle/pewletthackard/blob/master/images/2019-PH-SQL-ER-Diagram-Using-MySQL.jpg)

**Create a .sql file of your table schemata.**
[Click to view SQL Schema file](https://github.com/BrianLabelle/pewletthackard/blob/master/sql/2019-08-04-PostGres-SQL-Schema.sql)

**Create a .sql file of your queries.**
[Click to view SQL query file](https://github.com/BrianLabelle/pewletthackard/blob/master/sql/2019-Pewlett-Hackard-Data-Analysis-Answers.sql)

**(Optional) Create a Jupyter Notebook of the bonus analysis.**
[click to view Jupyter Notebook file](https://github.com/BrianLabelle/pewletthackard/blob/master/HW-07-Postgres-Employee_Database-Bonus.ipynb)


_________________________________________________________________________________


## Submission

https://github.com/BrianLabelle/pewletthackard

- - -

© 2019 Rice Cookers | Brian Labelle | Sous-Coding Chef
