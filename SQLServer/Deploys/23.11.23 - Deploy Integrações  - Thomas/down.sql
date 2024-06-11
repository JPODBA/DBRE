DROP TRIGGER Change_Ploomes_Task_Calendar_Id
GO
DROP PROCEDURE Int_Update_Campo_Task_Valor
GO

ALTER VIEW [dbo].[SVw_Integration] AS  
 SELECT I.*, IL.Description, U.ID as ViewUserId  
  FROM Integration I INNER JOIN Integration_Language IL ON I.Id = IL.IntegrationId  
   INNER JOIN Usuario U ON IL.Language = U.Cultura  
   LEFT JOIN Ploomes_Cliente PC ON U.ID_ClientePloomes = PC.ID  
   WHERE ((PC.ID <> 3000022 AND PC.ID <> 3000023 AND PC.ID <> 1 AND (PC.AccountModelId NOT IN (137, 139, 140, 141, 142, 143, 144, 145, 146) OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao < '2023-11-08')) AND I.ID <> 27) OR ((PC.ID = 3000022 OR PC.ID = 3000023 OR PC.ID = 1 OR PC.ID = 4001566 OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao >= '2023-11-08')) AND I.ID <> 12))
GO

ALTER VIEW [dbo].[SVw_Ploomes_Cliente_Integration] AS  
 SELECT PCI.*, Usu.Chave as IntegrationUserKey, U.ID as ViewUserId  
  FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.AccountId = U.ID_ClientePloomes  
   LEFT JOIN Usuario Usu ON PCI.IntegrationUserId = Usu.ID  
   INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 1  
	WHERE I.ID <> 27
 UNION ALL  
  
 SELECT PCI.*, Usu.Chave as IntegrationUserKey, U.ID as ViewUserId  
  FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.CreatorId = U.ID  
   INNER JOIN Usuario Usu ON PCI.IntegrationUserId = Usu.ID  
   INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 2  
   INNER JOIN Ploomes_Cliente PC ON PCI.AccountId = PC.ID
  WHERE I.ID <> 27 AND (PCI.AccountId <> 3000022 AND PCI.AccountId <> 3000023 AND PCI.AccountId <> 1 AND (PC.AccountModelId NOT IN (137, 139, 140, 141, 142, 143, 144, 145, 146) OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao < '2023-11-08')))
 UNION ALL  
  
 SELECT PCI.*, U.Chave as IntegrationUserKey, U.ID as ViewUserId  
  FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.IntegrationUserId = U.ID AND U.IntegracaoNativa = 1  
   INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 2
   INNER JOIN Ploomes_Cliente PC ON PCI.AccountId = PC.ID
   WHERE I.ID <> 27 AND (PCI.AccountId <> 3000022 AND PCI.AccountId <> 3000023 AND PCI.AccountId <> 1 AND (PC.AccountModelId NOT IN (137, 139, 140, 141, 142, 143, 144, 145, 146) OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao < '2023-11-08')))
 UNION ALL
  SELECT PCI.*, Usu.Chave as IntegrationUserKey, U.ID as ViewUserId  
  FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.AccountId = U.ID_ClientePloomes  
   LEFT JOIN Usuario Usu ON PCI.IntegrationUserId = Usu.ID  
   INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 1  
   INNER JOIN Ploomes_Cliente PC ON PCI.AccountId = PC.ID
	WHERE I.ID = 27 AND (PCI.AccountId = 3000022 OR PCI.AccountId = 3000023 OR PCI.AccountId = 1 OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao >= '2023-11-08'))
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)