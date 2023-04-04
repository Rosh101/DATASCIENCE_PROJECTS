CREATE DATABASE IF NOT EXISTS SCHOOL_RANKING;
SHOW DATABASES;
USE SCHOOL_RANKING;
SHOW TABLES;

-- QUERY TO CREATE STUDENTS TABLE.
CREATE TABLE STUDENTS(
STUDENT_ID INT(10) PRIMARY KEY NOT NULL,
FIRST_NAME VARCHAR(30) NOT NULL,
LAST_NAME VARCHAR(30) NOT NULL,
CLASS VARCHAR(10),
AGE INT(2)
);
DESCRIBE STUDENTS;

-- QUERY TO CREATE MARKSHEET TABLE.
CREATE TABLE MARKSHEET(
SCORE INT(4),
YEAR INT(4),
RANKING INT(3),
CLASS VARCHAR(19),
STUDENT_ID INT(10)
);
DESCRIBE MARKSHEET;

-- QUERY TO MODIFY COULUM STUDENT_ID ATTRIBUTE.
ALTER TABLE MARKSHEET MODIFY COLUMN STUDENT_ID INT(10) NOT NULL PRIMARY KEY;
DESCRIBE MARKSHEET;	
SHOW TABLES;

-- QUERY TO INSERT DATA IN STUDENTS AND MARKSHEET TABLE
INSERT INTO STUDENTS(STUDENT_ID,FIRST_NAME,LAST_NAME,CLASS,AGE)
SELECT * FROM STUDENT_DATASETS;
INSERT INTO MARKSHEET (SCORE,YEAR,RANKING,CLASS,STUDENT_ID)
SELECT *FROM MARKSHEET_DATASETS;

/*Display student id and student first name from the student table
if the age is greater than or equal to 16 and the student's last name is Kumar.
*/
SELECT STUDENT_ID,FIRST_NAME
FROM STUDENTS
WHERE AGE >= 16 AND LAST_NAME="Kumar"
;
-- Query to display all the details from the marksheet table if the score is between 800 and 1000.
SELECT * FROM MARKSHEET
WHERE SCORE >=800 AND SCORE <=1000;
/*Query to display the marksheet details from the marksheet table by adding 5 to the score
and by naming the column as new score.*/
SELECT SCORE,YEAR,RANKING,CLASS,STUDENT_ID,SCORE+5 AS NEW_SCORE
FROM MARKSHEET;
--  Query to display the marksheet table in descending order of the  score.
SELECT *  FROM MARKSHEET
ORDER BY SCORE DESC;
-- Query to display details of the students whose first name starts with a.
SELECT * FROM STUDENTS
WHERE FIRST_NAME LIKE 'a%';