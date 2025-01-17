-- 2019-08-04-PostGres-SQL to Generate Database & Tables.

CREATE DATABASE pewletthackard
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE pewletthackard
    IS 'Pewlett Hackard Employees 1980-1999 Project';


-- ==========================================================================================

CREATE TABLE public.employees
(
    emp_no integer NOT NULL,
    birth_date date NOT NULL,
    first_name character varying(45) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(45) COLLATE pg_catalog."default" NOT NULL,
    gender "char" NOT NULL,
    hire_date date NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT pk_emp_no PRIMARY KEY (emp_no)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.employees
    OWNER to postgres;
COMMENT ON TABLE public.employees
    IS 'Employee Table for Pewlett Hackard Employees 1980-1999 Project';




-- ==========================================================================================


CREATE TABLE public.departments
(
    dept_no character varying(4) COLLATE pg_catalog."default" NOT NULL,
    dept_name character varying(45) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_dept_no PRIMARY KEY (dept_no)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.departments
    OWNER to postgres;
COMMENT ON TABLE public.departments
    IS 'Departments Table for Pewlett Hackard Employees 1980-1999 Project';



-- ==========================================================================================
CREATE TABLE public.titles
(
    emp_no integer NOT NULL,
    title character varying(45) COLLATE pg_catalog."default" NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL DEFAULT '9999-01-01'::date,
    CONSTRAINT fk_emp_no FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.titles
    OWNER to postgres;
COMMENT ON TABLE public.titles
    IS 'Titles Table for Pewlett Hackard Employees 1980-1999 Project ';

COMMENT ON CONSTRAINT fk_emp_no ON public.titles
    IS 'Employee Foreign Key in titles table which is Primary Key in Employees table.';


-- ==========================================================================================

CREATE TABLE public.salaries
(
    emp_no integer NOT NULL,
    salary numeric NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL DEFAULT '9999-01-01'::date,
    CONSTRAINT fk_emp_no FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.salaries
    OWNER to postgres;
COMMENT ON TABLE public.salaries
    IS 'Salaries Table for Pewlett Hackard Employees 1980-1999 Project ';

COMMENT ON CONSTRAINT fk_emp_no ON public.salaries
    IS 'Employee Foreign Key in salaries table which is Primary Key in Employees table.';


-- ==========================================================================================
CREATE TABLE public.dept_emp
(
    emp_no integer NOT NULL,
    dept_no character varying(45) COLLATE pg_catalog."default" NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL DEFAULT '9999-01-01'::date,
    CONSTRAINT fk_dept_no FOREIGN KEY (dept_no)
        REFERENCES public.departments (dept_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_emp_no FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.dept_emp
    OWNER to postgres;
COMMENT ON TABLE public.dept_emp
    IS 'Dept & Employee JOIN Table for Pewlett Hackard Employees 1980-1999 Project.';

COMMENT ON CONSTRAINT fk_dept_no ON public.dept_emp
    IS 'Department Foreign Key in dept_emp table which is Primary Key in Departments table.';
COMMENT ON CONSTRAINT fk_emp_no ON public.dept_emp
    IS 'Employee Foreign Key in dept_emp table which is Primary Key in Employees table.';


-- ==========================================================================================

CREATE TABLE public.dept_manager
(
    dept_no character varying(4) COLLATE pg_catalog."default" NOT NULL,
    emp_no integer NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL DEFAULT '9999-01-01'::date,
    CONSTRAINT pk_dept_manager PRIMARY KEY (dept_no, empy_no),
    CONSTRAINT fk_dept_no FOREIGN KEY (dept_no)
        REFERENCES public.departments (dept_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_emp_no FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.dept_manager
    OWNER to postgres;
COMMENT ON TABLE public.dept_manager
    IS 'Dept & Employee JOIN Passthrough Table for Pewlett Hackard Employees 1980-1999 Project.';

COMMENT ON CONSTRAINT fk_dept_no ON public.dept_manager
    IS 'Department Foreign Key in dept_manager table which is Primary Key in Departments table.';
COMMENT ON CONSTRAINT fk_emp_no ON public.dept_manager
    IS 'Employee Foreign Key in dept_manager table which is Primary Key in Employees table.';




-- ==========================================================================================





