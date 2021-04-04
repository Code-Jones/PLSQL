SET SERVEROUTPUT ON

--Task 1
ALTER TABLE ata_entertainer
  ADD more_than_one NUMBER;


DECLARE

  CURSOR c_entertainer IS
   SELECT *
     FROM ata_entertainer
      FOR UPDATE;

  r_entertainer ata_entertainer%ROWTYPE;

  v_number_of_styles NUMBER;

BEGIN

  OPEN c_entertainer;

  LOOP
    FETCH c_entertainer INTO r_entertainer;
    EXIT WHEN c_entertainer%NOTFOUND;

    SELECT COUNT(*)
      INTO v_number_of_styles
      FROM ata_entertainers_style
     WHERE entertainer_id = r_entertainer.entertainer_id;
     
    IF v_number_of_styles <= 1 THEN
      v_number_of_styles := NULL;
    END IF;      

    UPDATE ata_entertainer
       SET more_than_one = v_number_of_styles
     WHERE CURRENT OF c_entertainer;

  END LOOP;

  CLOSE c_entertainer;

  COMMIT;


END;
/




-- Task 2
ALTER TABLE ata_entertainer
  ADD more_than_one NUMBER;


DECLARE

  CURSOR c_entertainer IS
   SELECT *
     FROM ata_entertainer;

  v_number_of_styles NUMBER;

BEGIN

  FOR r_entertainer IN c_entertainer LOOP

    SELECT COUNT(*)
      INTO v_number_of_styles
      FROM ata_entertainers_style
     WHERE entertainer_id = r_entertainer.entertainer_id;

    CASE
     WHEN v_number_of_styles <= 1 THEN
             v_number_of_styles := NULL;
             
     ELSE NULL;

    END CASE;
    
    UPDATE ata_entertainer
       SET more_than_one = v_number_of_styles
     WHERE entertainer_id = r_entertainer.entertainer_id;
    

  END LOOP;


  COMMIT;


END;
/


