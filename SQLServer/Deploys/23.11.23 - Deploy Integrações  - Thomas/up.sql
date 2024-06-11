CREATE OR ALTER PROCEDURE Int_Update_Campo_Task_Valor
	@NewFieldId Int = NULL,
	@CustomFieldId Int = NULL
AS
	DECLARE @OldFieldId Int;
	DECLARE @OldAccountIntegrationId Int;
BEGIN		
	 SELECT TOP 1 @OldAccountIntegrationId = Id FROM Ploomes_Cliente_Integration PCI where PCI.AccountId = 4001566 AND PCI.IntegrationId = 12;
	 SELECT @OldFieldId = pcicf.FieldId FROM  Ploomes_Cliente_Integration_CustomField (NOLOCK) PCICF WHERE PCICF.AccountIntegrationId = @OldAccountIntegrationId And pcicf.CustomFieldId = @CustomFieldId;
	 
	 SET ROWCOUNT 100
	 DECLARE @rowcount int
	 SELECT @rowcount = count(1) FROM Campo_Valor_Task WHERE FieldId = @OldFieldId
	 WHILE @rowcount <> 0 BEGIN
		UPDATE Campo_Valor_Task SET FieldId = @NewFieldId WHERE FieldId = @OldFieldId		  
		IF @@ROWCOUNT = 0 BREAK
	 end
END
GO

CREATE OR ALTER TRIGGER Change_Ploomes_Task_Calendar_Id ON Ploomes_Cliente_Integration_CustomField 
AFTER INSERT  
AS  
	DECLARE @NewFieldId Int;	
	DECLARE @NewAccountIntegrationId Int;
BEGIN

 SELECT @NewAccountIntegrationId = Id FROM Ploomes_Cliente_Integration PCI where PCI.AccountId = 4001566 AND PCI.IntegrationId = 27;
 IF EXISTS(SELECT 1 FROM inserted i where AccountIntegrationId = @NewAccountIntegrationId) 
 BEGIN
	IF EXISTS(SELECT 1 FROM inserted i where AccountIntegrationId = @NewAccountIntegrationId AND CustomFieldId = 131) 
	BEGIN
	 SELECT @NewFieldId = i.FieldId from inserted i Where I.AccountIntegrationId = @NewAccountIntegrationId And i.CustomFieldId = 131;
	 EXEC Ploomes_CRM.dbo.Int_Update_Campo_Task_Valor @NewFieldId = @NewFieldId, @CustomFieldId = 38;
	END;

	IF EXISTS(SELECT 1 FROM inserted i where AccountIntegrationId = @NewAccountIntegrationId AND CustomFieldId = 132) 
	BEGIN
	 SELECT @NewFieldId = i.FieldId from inserted i Where I.AccountIntegrationId = @NewAccountIntegrationId And i.CustomFieldId = 132;
	 EXEC Ploomes_CRM.dbo.Int_Update_Campo_Task_Valor @NewFieldId = @NewFieldId, @CustomFieldId = 39;
	END;

	IF EXISTS(SELECT 1 FROM inserted i where AccountIntegrationId = @NewAccountIntegrationId AND CustomFieldId = 133) 
	BEGIN
	 SELECT @NewFieldId = i.FieldId from inserted i Where I.AccountIntegrationId = @NewAccountIntegrationId And i.CustomFieldId = 133;
	 EXEC Ploomes_CRM.dbo.Int_Update_Campo_Task_Valor @NewFieldId = @NewFieldId, @CustomFieldId = 78;
	END;
 END;
END;  
GO  
 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[SVw_Integration] AS  
 SELECT I.*, IL.Description, U.ID as ViewUserId  
  FROM Integration I INNER JOIN Integration_Language IL ON I.Id = IL.IntegrationId  
   INNER JOIN Usuario U ON IL.Language = U.Cultura  
   LEFT JOIN Ploomes_Cliente PC ON U.ID_ClientePloomes = PC.ID  
   WHERE ((PC.ID <> 3000022 AND PC.ID <> 3000023 AND PC.ID <> 1 AND PC.ID <> 4001566 AND (PC.AccountModelId NOT IN (137, 139, 140, 141, 142, 143, 144, 145, 146) OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao < '2023-11-08')) AND I.ID <> 27) OR ((PC.ID = 3000022 OR PC.ID = 3000023 OR PC.ID = 1 OR PC.ID = 4001566 OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao >= '2023-11-08')) AND I.ID <> 12))
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
  WHERE I.ID <> 27 AND (PCI.AccountId <> 3000022 AND PCI.AccountId <> 3000023 AND PCI.AccountId <> 1 AND PCI.AccountId <> 4001566 AND (PC.AccountModelId NOT IN (137, 139, 140, 141, 142, 143, 144, 145, 146) OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao < '2023-11-08')))
 UNION ALL  
  
 SELECT PCI.*, U.Chave as IntegrationUserKey, U.ID as ViewUserId  
  FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.IntegrationUserId = U.ID AND U.IntegracaoNativa = 1  
   INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 2
   INNER JOIN Ploomes_Cliente PC ON PCI.AccountId = PC.ID
   WHERE I.ID <> 27 AND (PCI.AccountId <> 3000022 AND PCI.AccountId <> 3000023 AND PCI.AccountId <> 1 AND PCI.AccountId <> 4001566 AND (PC.AccountModelId NOT IN (137, 139, 140, 141, 142, 143, 144, 145, 146) OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao < '2023-11-08')))
 UNION ALL
  SELECT PCI.*, Usu.Chave as IntegrationUserKey, U.ID as ViewUserId  
  FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.AccountId = U.ID_ClientePloomes  
   LEFT JOIN Usuario Usu ON PCI.IntegrationUserId = Usu.ID  
   INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 1  
   INNER JOIN Ploomes_Cliente PC ON PCI.AccountId = PC.ID
	WHERE I.ID = 27 AND (PCI.AccountId = 3000022 OR PCI.AccountId = 3000023 OR PCI.AccountId = 1 OR PCI.AccountId = 4001566 OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao >= '2023-11-08'))
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)