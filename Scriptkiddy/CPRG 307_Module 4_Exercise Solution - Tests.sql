SET SERVEROUTPUT ON

-- Component tests --

/* ************************************************************************* **
** Test number:  1															 **
** Test setup: Ensure that the category table has more than one category 	 **
** Setup code: Existing data from original load script will work so          **
**             no changes needed						     				 **
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
    DBMS_OUTPUT.PUT_LINE(r_category.category_code);
  END LOOP;
  
END;
/

/* ************************************************************************* **
** Test number:  2															 **
** Test setup: Ensure that the category table has only one category 	     **
** Setup code:																 **
DELETE cp_rental;
DELETE cp_dvd
 WHERE title_code IN (SELECT title_code
                        FROM cp_title
					   WHERE category_code > 1);
DELETE cp_title
 WHERE category_code > 1;
DELETE cp_category
 WHERE category_code > 1;
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
    DBMS_OUTPUT.PUT_LINE(r_category.category_code);
  END LOOP;
  
END;
/

/* ************************************************************************* **
** Test number:  3															 **
** Test setup: Ensure that the category table has no categories		 	     **
** Setup code:																 **
DELETE cp_rental;
DELETE cp_dvd;
DELETE cp_title;
DELETE cp_category;
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
    DBMS_OUTPUT.PUT_LINE(r_category.category_code);
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Program Ending');
  
END;
/

/* ************************************************************************* **
** Test number:  4															 **
** Test setup: Test a category (input) that has more than one DVD	 	     **
** Setup code:																 **
DELETE cp_rental;
DELETE cp_dvd
 WHERE title_code IN (SELECT title_code
                        FROM cp_title
					   WHERE category_code <> 2);
DELETE cp_title
 WHERE category_code <> 2;
DELETE cp_category
 WHERE category_code <> 2;
**************************************************************************** */
DECLARE

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

BEGIN

  v_category := 2;

-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
      DBMS_OUTPUT.PUT_LINE(r_title.dvd_number);	
    END LOOP;

END;
/

/* ************************************************************************* **
** Test number:  5															 **
** Test setup: Test a category (input) that has only one DVD		 	     **
** Setup code:																 **
DELETE cp_rental;
DELETE cp_dvd
 WHERE title_code IN (SELECT title_code
                        FROM cp_title
					   WHERE category_code <> 1);
DELETE cp_title
 WHERE category_code <> 1;
DELETE cp_category
 WHERE category_code <> 1;
**************************************************************************** */
DECLARE

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

BEGIN

  v_category := 1;

-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
      DBMS_OUTPUT.PUT_LINE(r_title.dvd_number);	
    END LOOP;

END;
/

/* ************************************************************************* **
** Test number:  6															 **
** Test setup: Test a category (input) that has only one DVD		 	     **
** Setup code:																 **
INSERT INTO cp_category VALUES (20, 'No DVDs');
**************************************************************************** */
DECLARE

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

BEGIN

  v_category := 20;

-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
      DBMS_OUTPUT.PUT_LINE(r_title.dvd_number);	
    END LOOP;
	
  DBMS_OUTPUT.PUT_LINE('Program Ending');

END;
/

/* ************************************************************************* **
** Test number:  7															 **
** Test setup: Inventory column is updated to NULL if no DVDs			     **
** Setup code: Existing data from original load script will work so          **
**             no changes needed						     				 **
Perform a SELECT afterwards to confirm NULL value:
SELECT NVL(category_inventory, -1)
  FROM cp_category
 WHERE category_code = 20;
**************************************************************************** */
DECLARE

-- Store current category code	  
  r_category  cp_category%ROWTYPE;


-- Counter variable	   
  v_count NUMBER := 0;

BEGIN

  r_category.category_code := 20;

-- If no DVDs, the value saved in the database should be NULL
	IF (v_count = 0) THEN
	  v_count := NULL;
	END IF;
	
-- Update the number of DVDs in the inventory counter	
    UPDATE cp_category
       SET category_inventory = v_count
     WHERE category_code = r_category.category_code;
  
END;
/

/* ************************************************************************* **
** Test number:  8															 **
** Test setup: Inventory column is updated to correct number of DVDs	     **
** Setup code: Existing data from original load script will work so          **
**             no changes needed						     				 **
Perform a SELECT afterwards to confirm NULL value:
SELECT NVL(category_inventory, -1)
  FROM cp_category
 WHERE category_code = 2;
**************************************************************************** */
DECLARE

-- Store current category code	  
  r_category  cp_category%ROWTYPE;


-- Counter variable	   
  v_count NUMBER := 0;

BEGIN

  r_category.category_code := 2;
  v_count := 6;

-- If no DVDs, the value saved in the database should be NULL
	IF (v_count = 0) THEN
	  v_count := NULL;
	END IF;
	
-- Update the number of DVDs in the inventory counter	
    UPDATE cp_category
       SET category_inventory = v_count
     WHERE category_code = r_category.category_code;
  
END;
/

-- Integration tests --

/* ************************************************************************* **
** Test number:  9															 **
** Test setup: Category retrieval structure is coordinating with     	     **
**			   DVD retrieval structure									     ** 
** Setup code: Existing data from original load script will work so          **
**             no changes needed (focus on categories 1, 2, 3, 8)			 **
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
  
-- Store the current category code to link the inner and outer cursors
    v_category := r_category.category_code ;
	
	DBMS_OUTPUT.PUT_LINE('Category Begins' || r_category.category_code);
	
-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
	  DBMS_OUTPUT.PUT_LINE('----->' || r_title.dvd_number);
    END LOOP;

	DBMS_OUTPUT.PUT_LINE('Category Ends' || r_category.category_code);	 
  END LOOP;
  
END;
/

/* ************************************************************************* **
** Test number:  10															 **
** Test setup: Category retrieval structure is coordinating with     	     **
**			   DVD retrieval structure										 **
** Setup code: Existing data from original load script will work so          **
**             no changes needed (focus on categories 4, 5, 6, 7)			 **
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
  
-- Store the current category code to link the inner and outer cursors
    v_category := r_category.category_code ;
	
	DBMS_OUTPUT.PUT_LINE('Category Begins' || r_category.category_code);
	
-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
	  DBMS_OUTPUT.PUT_LINE('----->' || r_title.dvd_number);
    END LOOP;

	DBMS_OUTPUT.PUT_LINE('Category Ends' || r_category.category_code);	 
  END LOOP;
  
END;
/

/* ************************************************************************* **
** Test number:  11															 **
** Test setup: Category retrieval structure is coordinating with     	     **
**			   DVD retrieval structure and counter is correct for one DVD    ** 
** Setup code: Existing data from original load script will work so          **
**             no changes needed (focus on category 1)						 **
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

-- Counter variable	   
  v_count NUMBER := 0;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
  
-- Store the current category code to link the inner and outer cursors
    v_category := r_category.category_code ;
	
-- Initialize counter variable	
    v_count := 0;

-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
	
-- Increment counter	
      v_count := v_count + 1;
    END LOOP;

  DBMS_OUTPUT.PUT_LINE(r_category.category_code || ' ---> ' || v_count);	
	
  END LOOP;
  
END;
/
  
/* ************************************************************************* **
** Test number:  12															 **
** Test setup: Category retrieval structure is coordinating with     	     **
**			   DVD retrieval structure and counter is correct for 		     **
**			   more than one DVD    									     ** 
** Setup code: Existing data from original load script will work so          **
**             no changes needed (focus on categories 2, 3, 8)				 **
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

-- Counter variable	   
  v_count NUMBER := 0;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
  
-- Store the current category code to link the inner and outer cursors
    v_category := r_category.category_code ;
	
-- Initialize counter variable	
    v_count := 0;

-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
	
-- Increment counter	
      v_count := v_count + 1;
    END LOOP;

  DBMS_OUTPUT.PUT_LINE(r_category.category_code || ' ---> ' || v_count);	
	
  END LOOP;
  
END;
/

/* ************************************************************************* **
** Test number:  13															 **
** Test setup: Category retrieval structure is coordinating with     	     **
**			   DVD retrieval structure and counter is correct for 		     **
**			   no DVDs			    									     ** 
** Setup code: Existing data from original load script will work so          **
**             no changes needed (focus on categories 4, 5, 6, 7)			 **
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

-- Counter variable	   
  v_count NUMBER := 0;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
  
-- Store the current category code to link the inner and outer cursors
    v_category := r_category.category_code ;
	
-- Initialize counter variable	
    v_count := 0;

-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
	
-- Increment counter	
      v_count := v_count + 1;
    END LOOP;

  DBMS_OUTPUT.PUT_LINE(r_category.category_code || ' ---> ' || v_count);	
	
  END LOOP;
  
END;
/

/* ************************************************************************* **
** Test number:  14															 **
** Test setup: Category retrieval structure is coordinating with     	     **
**			   DVD retrieval structure and counter information is  		     **
**			   correctly added to table if no DVDs						     ** 
** Setup code: Existing data from original load script will work so          **
**             no changes needed (focus on categories 4, 5, 6, 7)			 **
Perform a SELECT afterwards to confirm NULL value:
SELECT category_code, NVL(category_inventory, -1)
  FROM cp_category;
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

-- Counter variable	   
  v_count NUMBER := 0;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
  
-- Store the current category code to link the inner and outer cursors
    v_category := r_category.category_code ;
	
-- Initialize counter variable	
    v_count := 0;

-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
	
-- Increment counter	
      v_count := v_count + 1;
    END LOOP;

-- If no DVDs, the value saved in the database should be NULL
	IF (v_count = 0) THEN
	  v_count := NULL;
	END IF;
	
-- Update the number of DVDs in the inventory counter	
    UPDATE cp_category
       SET category_inventory = v_count
     WHERE category_code = r_category.category_code;
  END LOOP;

END;
/

/* ************************************************************************* **
** Test number:  15															 **
** Test setup: Category retrieval structure is coordinating with     	     **
**			   DVD retrieval structure and counter information is  		     **
**			   correctly added to table if have DVDs					     ** 
** Setup code: Existing data from original load script will work so          **
**             no changes needed (focus on categories 1, 2, 3, 8)			 **
Perform a SELECT afterwards to confirm NULL value:
SELECT category_code, NVL(category_inventory, -1)
  FROM cp_category;
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

-- Counter variable	   
  v_count NUMBER := 0;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
  
-- Store the current category code to link the inner and outer cursors
    v_category := r_category.category_code ;
	
-- Initialize counter variable	
    v_count := 0;

-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
	
-- Increment counter	
      v_count := v_count + 1;
    END LOOP;

-- If no DVDs, the value saved in the database should be NULL
	IF (v_count = 0) THEN
	  v_count := NULL;
	END IF;
	
-- Update the number of DVDs in the inventory counter	
    UPDATE cp_category
       SET category_inventory = v_count
     WHERE category_code = r_category.category_code;
  END LOOP;

END;
/

/* ************************************************************************* **
** Test number:  16															 **
** Test setup: Category retrieval structure is coordinating with     	     **
**			   DVD retrieval structure and counter information is  		     **
**			   correctly added to table if no DVDs and the data is saved     ** 
** Setup code: Existing data from original load script will work so          **
**             no changes needed (focus on categories 4, 5, 6, 7)			 **
Perform a SELECT afterwards to confirm NULL value:
SELECT category_code, NVL(category_inventory, -1)
  FROM cp_category;
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

-- Counter variable	   
  v_count NUMBER := 0;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
  
-- Store the current category code to link the inner and outer cursors
    v_category := r_category.category_code ;
	
-- Initialize counter variable	
    v_count := 0;

-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
	
-- Increment counter	
      v_count := v_count + 1;
    END LOOP;

-- If no DVDs, the value saved in the database should be NULL
	IF (v_count = 0) THEN
	  v_count := NULL;
	END IF;
	
-- Update the number of DVDs in the inventory counter	
    UPDATE cp_category
       SET category_inventory = v_count
     WHERE category_code = r_category.category_code;
  END LOOP;

-- Save data changes
  COMMIT;
  
END;
/
  
/* ************************************************************************* **
** Test number:  17															 **
** Test setup: Category retrieval structure is coordinating with     	     **
**			   DVD retrieval structure and counter information is  		     **
**			   correctly added to table if has DVDs and the data is saved    ** 
** Setup code: Existing data from original load script will work so          **
**             no changes needed (focus on categories 1, 2, 3, 8)			 **
Perform a SELECT afterwards to confirm NULL value:
SELECT category_code, NVL(category_inventory, -1)
  FROM cp_category;
**************************************************************************** */
DECLARE

-- Get all categories from the database
  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;

-- Store current category code	  
  v_category  cp_category.category_code%TYPE;

-- Get all DVDs from the database for the current category  
  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

-- Counter variable	   
  v_count NUMBER := 0;

BEGIN

-- Outer loop that cycles through all categories
  FOR r_category IN c_category LOOP
  
-- Store the current category code to link the inner and outer cursors
    v_category := r_category.category_code ;
	
-- Initialize counter variable	
    v_count := 0;

-- Inner loop that cycles through all DVDs for the current category	
    FOR r_title IN c_title LOOP
	
-- Increment counter	
      v_count := v_count + 1;
    END LOOP;

-- If no DVDs, the value saved in the database should be NULL
	IF (v_count = 0) THEN
	  v_count := NULL;
	END IF;
	
-- Update the number of DVDs in the inventory counter	
    UPDATE cp_category
       SET category_inventory = v_count
     WHERE category_code = r_category.category_code;
  END LOOP;

-- Save data changes
  COMMIT;
  
END;
/
    