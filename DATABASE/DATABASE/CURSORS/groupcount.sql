DELIMITER $$
CREATE PROCEDURE groupcount ()
BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE store varchar(10);
    DECLARE noOfGroups INT;
 
    SET noOfGroups :=0;
    
    BEGIN
	     -- declare cursor for employee email
	    DECLARE t_group CURSOR FOR 
		    SELECT group_id FROM group_details;
	 
	    -- declare NOT FOUND handler
	    DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finished = 1;
	 
	    OPEN t_group;
	 
	    getUsers: LOOP
		FETCH t_group INTO store;
		
		IF finished = 1 THEN 
		    LEAVE getUsers;
		ELSE
		    SET noOfGroups := noOfGroups+1;
		END IF;
	    END LOOP getUsers;
	    CLOSE t_group;
    END;
  SELECT noOfGroups;
END$$
DELIMITER ;
