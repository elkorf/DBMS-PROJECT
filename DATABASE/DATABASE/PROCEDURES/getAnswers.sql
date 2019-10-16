delimiter //
create procedure getAnswers(in qid varchar(10))
BEGIN
	select * from answers
	where question_id = qid
   	order by posted_on DESC;
END
delimiter ;

