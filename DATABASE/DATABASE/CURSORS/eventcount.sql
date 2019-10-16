DELIMITER $$
CREATE PROCEDURE eventcount ()
BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE store varchar(10);
    DECLARE noOfEvents INT;
 
    SET noOfEvents :=0;
    
    BEGIN
	     -- declare cursor for employee email
	    DECLARE t_event CURSOR FOR 
		    SELECT event_id FROM event;
	 
	    -- declare NOT FOUND handler
	    DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finished = 1;
	 
	    OPEN t_event;
	 
	    getUsers: LOOP
		FETCH t_event INTO store;
		
		IF finished = 1 THEN 
		    LEAVE getUsers;
		ELSE
		    SET noOfEvents := noOfEvents+1;
		END IF;
	    END LOOP getUsers;
	    CLOSE t_event;
    END;
  SELECT noOfEvents;
END$$
DELIMITER ;
