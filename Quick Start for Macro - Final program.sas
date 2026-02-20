/*  

 * %snackGraph 

 *    Purpose: Summarize data to revenue per month, and subset to only 

 *             products of a given variety 

 *    Input: variety parameter (single word, used to subset products) 

 *    Output: work.snack and a line graph of revenue, both summarized and subset 

 */  
%macro snackGraph(variety);

	%macro a; %mEnd a; /* restores color coding in Enterprise Guide */ 

	proc sql;  
	create table work.snacks as  
	select put(date, yymmd.) as Month 
			, product 
			, sum(qtySold*price) as Revenue  
		from sashelp.snacks  
		where upcase(product) contains "%sysfunc(upcase(&variety))"  
		group by Month 
			, product 
	;  
	quit; 

	%put &=sqlObs; 
	%if &sqlObs > 0 %then %do; 
		title "Revenue from %sysFunc(propcase(&variety))s";  
		proc sgplot data=work.snacks;  
			series x=Month Y=Revenue / group=Product;  
		run; 
	%end; 
	%else %do; 
		%put WARNING: No rows have the value &variety in their Product value.; 
	%end;  

%mEnd snackGraph; 

%snackGraph(pretZEl) /* expect graph */
%snackGraph(puFF) /* expect graph */
%snackGraph(onion) /* expect warning in log */

 