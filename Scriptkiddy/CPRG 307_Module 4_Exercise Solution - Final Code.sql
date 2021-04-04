DECLARE

  CURSOR c_category IS
    SELECT category_code
      FROM cp_category;


  v_category  cp_category.category_code%TYPE;


  CURSOR c_title IS
    SELECT dvd_number
      FROM cp_title ti, cp_dvd dvd
     WHERE ti.title_code = dvd.title_code
       AND category_code = v_category;

  v_count NUMBER := 0;

BEGIN


  FOR r_category IN c_category LOOP
  
    v_category := r_category.category_code ;
	
    v_count := 0;

    FOR r_title IN c_title LOOP
	
      v_count := v_count + 1;
    END LOOP;

	IF (v_count = 0) THEN
	  v_count := NULL;
	END IF;	

    UPDATE cp_category
       SET category_inventory = v_count
     WHERE category_code = r_category.category_code;
  END LOOP;
  
  COMMIT;
END;
/
  