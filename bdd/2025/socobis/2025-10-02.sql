CREATE OR REPLACE  VIEW CLIENTLIB AS 

SELECT 
	c.* ,
	t.val AS idTypeClientLib, p.VAL AS provincelib
FROM CLIENT c
LEFT JOIN typeclient t ON c.idTypeClient = t.id
LEFT JOIN PROVINCE p ON p.id = c.idprovince ;
