create view useprod as 

select distinct 
	np.product_base_no as article_code, 
	tres.CompanyIdentifier as article_vendor, 
	tres.product_line as article_product_line,
	tres.short_desc as article_name,
	tres.long_desc as article_description
from 
	NancyProducts np  
cross apply 
	( select top 1 
		pin.CompanyIdentifier, 
		pin.product_line,
		pin.short_desc,
		pin.long_desc

	   from NancyProducts pin 
	   where pin.product_base_no = np.product_base_no 
	   order by UpdatedDateTimeStamp desc) tres
where 
	tres.CompanyIdentifier is not null or np.UpdatedDateTimeStamp > '2013-01-01'