DELIMITER $$
CREATE PROCEDURE usercount ()
BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE store varchar(10);
    DECLARE noOfUsers INT;
 
    SET noOfUsers :=0;
    
    BEGIN
	     -- declare cursor for employee email
	    DECLARE t_users CURSOR FOR 
		    SELECT user_id FROM users;
	 
	    -- declare NOT FOUND handler
	    DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finished = 1;
	 
	    OPEN t_users;
	 
	    getUsers: LOOP
		FETCH t_users INTO store;
		
		IF finished = 1 THEN 
		    LEAVE getUsers;
		ELSE
		    SET noOfUsers := noOfUsers+1;
		END IF;
	    END LOOP getUsers;
	    CLOSE t_users;
    END;
  SELECT noOfUsers;
END$$
DELIMITER ;
