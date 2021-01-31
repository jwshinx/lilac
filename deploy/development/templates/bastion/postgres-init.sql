DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS colleges;

CREATE TABLE students (
	id SERIAL PRIMARY KEY,
  first_name VARCHAR(256),
  last_name VARCHAR(1024),
  email VARCHAR(256)
);

CREATE TABLE colleges (
  id SERIAL PRIMARY KEY,
	name VARCHAR(256),
  established INT
);

INSERT INTO students(first_name, last_name, email) 
SELECT 'Jeff','Buckley', 'jeff@yahoo.com'
WHERE NOT EXISTS (
    select 1 from students where first_name = 'Jeff' and last_name = 'Buckley'
);

INSERT INTO students(first_name, last_name, email) 
SELECT 'David','Bowie', 'dbowie@yahoo.com'
WHERE NOT EXISTS (
    select 1 from students where first_name = 'David' and last_name = 'Bowie'
);

INSERT INTO students(first_name, last_name, email) 
SELECT 'Ringo','Starr', 'rs@yahoo.com'
WHERE NOT EXISTS (
    select 1 from students where first_name = 'Ringo' and last_name = 'Starr'
);

INSERT INTO students(first_name, last_name, email) 
SELECT 'Lou','Reed', 'lr@yahoo.com'
WHERE NOT EXISTS (
    select 1 from students where first_name = 'Lou' and last_name = 'Reed'
);

INSERT INTO colleges(name, established)
SELECT 'SUNY New Paltz', 1793
WHERE NOT EXISTS (
    select 1 from colleges where name = 'SUNY New Paltz' and established = 1793
);

INSERT INTO colleges(name, established)
SELECT 'Santa Monica College', 1930
WHERE NOT EXISTS (
    select 1 from colleges where name = 'Santa Monica College' and established = 1930
);

INSERT INTO colleges(name, established)
SELECT 'Swarthmore College', 1703
WHERE NOT EXISTS (
    select 1 from colleges where name = 'Swarthmore College' and established = 1703
);

INSERT INTO colleges(name, established)
SELECT 'Cal State Northridge', 1834
WHERE NOT EXISTS (
    select 1 from colleges where name = 'Cal State Northridge' and established = 1834
);

INSERT INTO colleges(name, established)
SELECT 'UC Santa Cruz', 1921
WHERE NOT EXISTS (
    select 1 from colleges where name = 'UC Santa Cruz' and established = 1921
);
