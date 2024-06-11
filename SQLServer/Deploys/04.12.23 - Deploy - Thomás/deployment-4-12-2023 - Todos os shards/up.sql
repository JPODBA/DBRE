-- up 1
-- https://app.asana.com/0/1200108110051246/1205949185279052/f

use Ploomes_CRM
go

INSERT INTO Integration_Field VALUES (189,22,'company_search_field',7,1,0,0,0,NULL,NULL,'getfields2companyfilter',NULL,NULL,0,1)
GO
INSERT INTO Integration_Field_Language VALUES (189,189,'pt-BR', 'Detectar duplicidade de empresas pelo seguinte campo (necessário mapear)')
GO
INSERT INTO Integration_Field_Language VALUES (10189,189,'en-US', 'Detect duplication of companies by the following field (necessary to map)')
GO
INSERT INTO Integration_Field_Language VALUES (20189,189,'pt-PT', 'Detectar duplicação de empresas pelo seguinte campo (necessário mapear)')
GO
INSERT INTO Integration_Field_Language VALUES (30189,189,'es-ES', 'Detecte empresas duplicadas usando el siguiente campo (se requiere mapeo)')
GO


-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)