CREATE FUNCTION dbo.resolve2pl(@product_base_no varchar(30)) 
RETURNS VARCHAR(30) as 
BEGIN
DECLARE @RES VARCHAR(30)
SELECT @RES = coalesce(og.product_line, np.product_line, pp.product_line) 
FROM (select @product_base_no as product_base_no) nout
outer apply
  (SELECT top 1 ProductLine as product_line
   FROM opgdet
 WHERE dbo.ven2clean(opgdet.VendorPartNo) = nout.product_base_no and 
 ProductLine is not null) og

outer apply
    (SELECT top 1 pin.product_line
    FROM NancyProducts pin
        WHERE pin.product_base_no = nout.product_base_no and pin.product_line is not null) np

outer apply
    (SELECT top 1 pin.prod_line as product_line
    FROM products pin
        WHERE dbo.ven2clean(pin.product_base_no) = nout.product_base_no and pin.prod_line is not null) pp
RETURN @RES
END
