delimiter //
create procedure getPosts(in pid varchar(10))
begin
	select * from comments 
	where post_id = pid
	order by posted_on desc;
end //
delimiter ;
