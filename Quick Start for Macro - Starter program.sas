proc sql;  
create table work.snacks as  
select put(date, yymmd.) as Month 
		, product 
		, sum(qtySold*price) as Revenue  
	from sashelp.snacks  
	where upcase(product) contains "PRETZEL"  
	group by Month 
		, product 
;  
quit; 

title "Revenue from Pretzels";  
proc sgplot data=work.snacks;  
	series x=Month Y=Revenue / group=Product;  
run; 