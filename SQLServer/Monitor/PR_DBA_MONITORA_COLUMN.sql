-- define the max value for each data type
CREATE TABLE #DataTypeMaxValue (DataType varchar(50), MaxValue bigint)

INSERT INTO #DataTypeMaxValue VALUES 
   ('tinyint' , 255),
   ('smallint' , 32767),
   ('int' , 2147483647),
   ('bigint' , 9223372036854775807)

-- retrieve identity column information
SELECT 
   Distinct OBJECT_NAME (TN.object_id) AS Tabela,
   IC.name							   AS Coluna,
   TYPE_NAME(IC.system_type_id)		   AS DataType,
   DTM.MaxValue						   AS MaxDataType,
   IC.seed_value					   AS Identity_Seed,
   IC.increment_value				   AS Identity_icr, 
   IC.last_value                       AS Ultimo_ID,
   DBPS.row_count                      AS QTD_Linhas,
   (convert(decimal(18,2),
   CONVERT(bigint,IC.last_value)
   *100/DTM.MaxValue)) 				   AS Porcentagem_De_Uso
INTO #Coluna_MaxIDs
FROM sys.identity_columns		 IC
JOIN sys.tables					 TN ON IC.object_id = TN.object_id
JOIN #DataTypeMaxValue			DTM ON TYPE_NAME(IC.system_type_id)=DTM.DataType
JOIN sys.dm_db_partition_stats DBPS ON DBPS.object_id =IC.object_id 
JOIN sys.indexes 			    IDX ON DBPS.index_id =IDX.index_id 
WHERE DBPS.row_count > 0 
ORDER BY Porcentagem_De_Uso desc

DROP TABLE #DataTypeMaxValue

Select distinct 
Tabela,
Coluna,
DataType,
MaxDataType,
Identity_Seed,
Identity_icr, 
Ultimo_ID,
QTD_Linhas,
Porcentagem_De_Uso
From #Coluna_MaxIDs
Order by Porcentagem_De_Uso desc

Select * from DealCollaboratorUser