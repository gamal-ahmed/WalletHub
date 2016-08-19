--1-Write a query to rank order the following table in MySQL by votes, display the rank as one of the columns. CREATE TABLE votes ( name CHAR(10), votes INT ); INSERT INTO votes VALUES ('Smith',10), ('Jones',15), ('White',20), ('Black',40), ('Green',50), ('Brown',20);

CREATE TABLE votes ( name CHAR(10), votes INT ); 
INSERT INTO votes VALUES ('Smith',10), ('Jones',15), ('White',20), ('Black',40), ('Green',50), ('Brown',20);


--- Answer 

--The query is a two-step:
--1. Join the table to itself on the value to be ranked, handling ties
--2. Group and order the result of the self-join on rank: 

SELECT v1.name, v1.votes, COUNT(v2.votes) AS Rank 
FROM votes v1 
JOIN votes v2 ON v1.votes < v2.votes OR (v1.votes=v2.votes and v1.name = v2.name) 
GROUP BY v1.name, v1.votes 
ORDER BY v1.votes DESC, v1.name DESC; 

+-------+-------+------+ 
| name  | votes | Rank | 
+-------+-------+------+ 
| Green |    50 |    1 | 
| Black |    40 |    2 | 
| White |    20 |    3 | 
| Brown |    20 |    3 | 
| Jones |    15 |    5 | 
| Smith |    10 |    6 | 
+-------+-------+------+ 


--2-Write a function to capitalize the first letter of a word in a given string;
--Example: initcap(UNITED states Of AmERIca ) = United States Of America

CREATE FUNCTION capitalize_the_first_letter  (input VARCHAR(500))

RETURNS VARCHAR(500)

DETERMINISTIC

BEGIN
	DECLARE length INT;
	DECLARE i INT;
	SET i = 0;

	SET length   = CHAR_lengthGTH(input);
	SET input = LOWER(input);

	WHILE (i < length) DO
		IF (MID(input,i,1) = ' ' OR i = 0) THEN
			IF (i < length) THEN
				SET input = CONCAT(
					LEFT(input,i),
					UPPER(MID(input,i + 1,1)),
					RIGHT(input,length - i - 1)
				);
			END IF;
		END IF;
		SET i = i + 1;
	END WHILE;

	RETURN input;
END;

--Test
SELECT capitalize_the_first_letter("UNITED states Of AmERIca")
FROM dual
  
+---------------------------------------------------------+
| capitalize_the_first_letter("UNITED states Of AmERIca") |
+---------------------------------------------------------+
| United States Of America        					      |
+---------------------------------------------------------+


--3-Write a procedure in MySQL to split a column into rows using a delimiter.
--CREATE TABLE sometbl ( ID INT, NAME VARCHAR(50) );
--INSERT INTO sometbl VALUES (1, 'Smith'), (2, 'Julio|Jones|Falcons'), (3,
--'White|Snow'), (4, 'Paint|It|Red'), (5, 'Green|Lantern'), (6, 'Brown|bag');
--For (2), example rows would look like >> “3, white”, “3, Snow” …

--Answer
DROP PROCEDURE IF EXISTS split_column;

DELIMITER ||  

CREATE PROCEDURE split_column(IN p_id INT) 
BEGIN  
    DECLARE v_finished INTEGER DEFAULT 0;
    DECLARE v_found INT DEFAULT 0;  
    DECLARE v_name VARCHAR(50);
    DECLARE v_keep INT DEFAULT 1;
    DECLARE cursor_names CURSOR FOR 
        SELECT NAME 
          FROM sometbl
         WHERE id = p_id;
    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET v_finished = 1;

    DROP TEMPORARY TABLE IF EXISTS sometbl_tmp;
    CREATE TEMPORARY TABLE sometbl_tmp (ID INT, NAME VARCHAR(50));    

    OPEN cursor_names;

    process_names: LOOP
        FETCH cursor_names INTO v_name;

        if v_finished = 1 THEN
            LEAVE process_names;
        END IF;

        WHILE v_keep = 1 DO  
            BEGIN  

            SET v_found = INSTR(v_name, '|');

            IF v_found = 0 THEN
                BEGIN

                INSERT INTO sometbl_tmp
                     VALUES (p_id, v_name);

                SET v_keep = 0;

                END;
            ELSE 
                BEGIN

                INSERT INTO sometbl_tmp
                     VALUES (p_id, SUBSTRING(v_name, 1, v_found - 1));

                SET v_name = SUBSTRING(v_name, v_found + 1);

                END;
            END IF;
            END;  
        END WHILE;  
    END LOOP;

    SELECT *
      FROM sometbl_tmp
     WHERE id = p_id;

    DROP TEMPORARY TABLE IF EXISTS sometbl_tmp;

END ||  

DELIMITER ; 

--  Test
CALL split_column(3);
+------+-------+
| ID   | NAME  |
+------+-------+
|    3 | White |
|    3 | Snow  |
+------+-------+




--4- I have a table for bugs from a bug tracking software; let’s call the table “bugs”.
--The table has four columns (id, open_date, close_date, severity). On any given day
--a bug is open if the open_date is on or before that day and close_date is after
--that day. For example, a bug is open on “2012-01-01”, if it’s created on or
--before “2012-01-01” and closed on or after “2012-01-02”. I want a SQL to show
--number of bugs open for a range of dates.


SET @dateStart  = '2015-07-01';            
SET @dateEnd    = '2015-08-02';

SELECT open_date, count(1) as bugs_opened
  FROM bugs
 WHERE open_date >= @dateStart
   AND open_date <= @dateEnd
   AND close_date <= @dateEnd
 GROUP BY open_date;
 
 
-- Test
 +------------+-------------+
| open_date  | bugs_opened |
+------------+-------------+
| 2015-07-30 |           1 |
| 2015-07-31 |           1 |
| 2015-08-01 |           1 |
+------------+-------------+

