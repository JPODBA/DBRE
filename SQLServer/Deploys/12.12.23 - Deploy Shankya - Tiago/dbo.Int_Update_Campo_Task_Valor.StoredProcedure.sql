USE [Queue]
GO
/****** Object:  StoredProcedure [dbo].[Log_CountQueue]    Script Date: 12/12/2023 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE or ALTER PROCEDURE [dbo].[Log_CountQueue]            
 @integrationId int ,             
 @itemId int ,             
 @entityOptionId int ,             
 @userId int ,             
 @statusId int ,             


 @actionTypeId int ,             
 @ploomesToSankhya bit,             
 @createDateFrom datetime,             
 @createDateTo datetime             
AS            
BEGIN            
 DECLARE @select nvarchar(1000);            

 SET @select = 'SELECT COUNT(1) AS Quantidade FROM [Queue].[dbo].[Integration_Queue] WHERE [IntegrationId] = ' + CAST(@integrationId AS NVARCHAR);            

 IF @itemId IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [ItemId] = @itemId' -- + CAST(@itemId AS NVARCHAR);            
 END;            

IF @entityOptionId IS NOT NULL            
 BEGIN            
  IF @entityOptionId = 1      
  BEGIN       
   SET @select = @select+' AND [RuleId] = 1';      
  END      
  ELSE IF @entityOptionId = 2      
  BEGIN       
  SET @select = @select+' AND [RuleId] IN (2,6) ';      
  END      
  ELSE IF @entityOptionId = 3      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 3';      
  END      
  ELSE IF @entityOptionId = 4      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 5';      
  END      
  ELSE IF @entityOptionId = 5      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 4';       
  END      
  ELSE IF @entityOptionId = 6      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 7';      
  END      
  ELSE IF @entityOptionId = 7      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 8';      
  END      
  ELSE IF @entityOptionId = 8      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 9';      
  END      
 END         

 IF @userId IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [PloomesUserId] = @userId'; -- + CAST(@userId AS NVARCHAR);            
 END;            

 IF @statusId IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [Status] = @statusId'; -- + CAST(@statusId AS NVARCHAR);            
 END;            

 IF @actionTypeId IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [ActionId] = @actionTypeId'; -- + CAST(@actionTypeId AS NVARCHAR);            
 END;            

 IF(@userId IS NULL)            
 BEGIN            
  IF(@ploomesToSankhya IS NOT NULL)            
  BEGIN            
   IF @ploomesToSankhya = 1            
   BEGIN            
    SET @select = @select+' AND [PloomesToSankhya] = 1';            
   END            
   ELSE IF @ploomesToSankhya = 0            
   BEGIN             
    SET @select = @select+' AND [PloomesToSankhya] = 0';            
   END;            
  END;            
 END            
 ELSE            
 BEGIN             
  SET @select = @select+' AND [PloomesToSankhya] = 1';            
 END             

 IF @createDateFrom IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [CreateDate] >= @createDateFrom'; -- + CAST(@createDateFrom AS NVARCHAR);            
 END;            

 IF @createDateTo IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [CreateDate] <= @createDateTo'; -- + CAST(@createDateTo AS NVARCHAR);            
 END;            


 --EXEC sp_executesql @select;      
 EXEC sp_executesql @select, N'@itemId int, @userId int, @statusId int, @actionTypeId int, @createDateFrom datetime, @createDateTo datetime ', @itemId,@userId,@statusId,@actionTypeId,@createDateFrom,@createDateTo;  



END;
GO
---------

USE [Queue]
GO
/****** Object:  StoredProcedure [dbo].[Log_Queue]    Script Date: 12/12/2023 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_helptext Log_Queue       
CREATE or alter PROCEDURE [dbo].[Log_Queue]       
 @isAdmin bit,    
 @integrationId int ,           
 @itemId int ,           
 @entityOptionId int ,           
 @userId int ,           
 @statusId int ,           
 @actionTypeId int ,           
 @ploomesToSankhya bit,           
 @createDateFrom datetime,           
 @createDateTo datetime,         
 @page int,    
 @pageSize int    
AS          
BEGIN          
 DECLARE @select nvarchar(1000);    

 IF @isAdmin = 1     
 BEGIN     
 SET @select = 'SELECT * FROM [Queue].[dbo].[vw_QueueForAdmin] ';    
 END    
 ELSE    
 BEGIN    
 SET @select = 'SELECT * FROM [Queue].[dbo].[vw_QueueForNotAdmin] ';    
 END;    

 SET @select = @select + ' WHERE [IntegrationId] = @integrationId';-- + CAST(@integrationId AS NVARCHAR);          

 IF @itemId IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [ItemId] = @itemId' -- + CAST(@itemId AS NVARCHAR);            
 END;            

IF @entityOptionId IS NOT NULL            
 BEGIN            
  IF @entityOptionId = 1      
  BEGIN       
   SET @select = @select+' AND [RuleId] = 1';      
  END      
  ELSE IF @entityOptionId = 2      
  BEGIN       
  SET @select = @select+' AND [RuleId] IN (2,6) ';      
  END      
  ELSE IF @entityOptionId = 3      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 3';      
  END      
  ELSE IF @entityOptionId = 4      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 5';      
  END      
  ELSE IF @entityOptionId = 5      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 4';       
  END      
  ELSE IF @entityOptionId = 6      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 7';      
  END      
  ELSE IF @entityOptionId = 7      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 8';      
  END      
  ELSE IF @entityOptionId = 8      
  BEGIN       
  SET @select = @select+' AND [RuleId] = 9';      
  END      
 END         

 IF @userId IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [UserId] = @userId'; -- + CAST(@userId AS NVARCHAR);            
 END;            

 IF @statusId IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [StatusId] = @statusId'; -- + CAST(@statusId AS NVARCHAR);            
 END;            

 IF @actionTypeId IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [ActionId] = @actionTypeId'; -- + CAST(@actionTypeId AS NVARCHAR);            
 END;            

 IF(@userId IS NULL)            
 BEGIN            
  IF(@ploomesToSankhya IS NOT NULL)            
  BEGIN            
   IF @ploomesToSankhya = 1            
   BEGIN            
    SET @select = @select+' AND [PloomesToSankhya] = 1';            
   END            
   ELSE IF @ploomesToSankhya = 0            
   BEGIN             
    SET @select = @select+' AND [PloomesToSankhya] = 0';            
   END;            
  END;            
 END            
 ELSE            
 BEGIN             
  SET @select = @select+' AND [PloomesToSankhya] = 1';            
 END             

 IF @createDateFrom IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [CreateDate] >= @createDateFrom'; -- + CAST(@createDateFrom AS NVARCHAR);            
 END;            

 IF @createDateTo IS NOT NULL            
 BEGIN            
  SET @select = @select+' AND [CreateDate] <= @createDateTo'; -- + CAST(@createDateTo AS NVARCHAR);            
 END;          

 SET @select = @select + ' ORDER BY Id DESC OFFSET (@page-1)*@pageSize ROWS FETCH NEXT @pageSize ROWS ONLY '    

  EXEC sp_executesql @select, N'@integrationId int, @itemId int, @userId int, @statusId int, @actionTypeId int, @createDateFrom datetime, @createDateTo datetime, @page int, @pageSize int ', @integrationId, @itemId,@userId,@statusId,@actionTypeId,@createDateFrom,@createDateTo,@page,@pageSize;  

 --EXEC sp_executesql @select;          
END;
GO

----------------
USE [Queue]
GO
/****** Object:  View [dbo].[vw_QueueForAdmin]    Script Date: 12/12/2023 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or alter VIEW [dbo].[vw_QueueForAdmin]  
AS    
SELECT   
 [Id],  
 [IntegrationId],  
 [PloomesToSankhya],  
 [ItemId],  
 [Status]'StatusId',  
 [ActionId],  
 [EntityUpdateDate],  
 [CreateDate],  
 [Body],  
 [PloomesUserId]'UserId',  
 [FriendlyErrorMessage],  
 [LastTryError],  
 [RequestJson],  
 [ResponseJson],  
 [NextRetryDate],  
 [RetryCount],  
 [RuleId],
 CASE WHEN[RuleId] = 1 THEN 'Parceiro cliente pessoa jur dica' WHEN[RuleId] = 2 THEN 'Contato de Cliente' WHEN[RuleId] = 3 THEN 'Produto' WHEN[RuleId] = 4 THEN 'Vendedor' WHEN[RuleId] = 5 THEN 'Grupo de produto' WHEN[RuleId] = 6 THEN 'Parceiro cliente pes
soa f sica' WHEN[RuleId] = 7 THEN 'Or amento' WHEN[RuleId] = 8 THEN 'Pedido de Venda' WHEN[RuleId] = 9 THEN 'Pedido' ELSE null END as 'SankhyaEntityName',  
 CASE WHEN[RuleId] = 1 THEN 'Empresa' WHEN[RuleId] = 2 THEN 'Pessoa' WHEN[RuleId] = 3 THEN 'Produto' WHEN[RuleId] = 4 THEN 'Usu rio' WHEN[RuleId] = 5 THEN 'Grupo de produto' WHEN[RuleId] = 6 THEN 'Pessoa' WHEN[RuleId] = 7 THEN 'Proposta' WHEN[RuleId] = 8 
THEN 'Venda' WHEN[RuleId] = 9 THEN 'Documento' ELSE null END as 'PloomesEntityName'   
FROM [Queue].[dbo].[Integration_Queue];
GO

USE [Queue]
GO
/****** Object:  View [dbo].[vw_QueueForNotAdmin]    Script Date: 12/12/2023 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or alter VIEW [dbo].[vw_QueueForNotAdmin]  
AS    
SELECT  
[Id],  
[IntegrationId],  
[PloomesToSankhya],  
[ItemId],  
[Status]'StatusId',  
[ActionId],  
[EntityUpdateDate],  
[PloomesUserId]'UserId',  
[FriendlyErrorMessage],  
[NextRetryDate],  
[RetryCount],  
[RuleId],
CASE WHEN [RuleId] = 1 THEN 'Parceiro cliente pessoa jur dica' WHEN [RuleId] = 2 THEN 'Contato de Cliente' WHEN [RuleId] = 3 THEN 'Produto' WHEN [RuleId] = 4 THEN 'Vendedor' WHEN [RuleId] = 5 THEN 'Grupo de produto' WHEN [RuleId] = 6 THEN 'Parceiro client
e pessoa f sica' WHEN [RuleId] = 7 THEN 'Or amento' WHEN [RuleId] = 8 THEN 'Pedido de Venda' WHEN [RuleId] = 9 THEN 'Pedido' ELSE null END as 'SankhyaEntityName',  
CASE WHEN [RuleId] = 1 THEN 'Empresa' WHEN [RuleId] = 2 THEN 'Pessoa' WHEN [RuleId] = 3 THEN 'Produto' WHEN [RuleId] = 4 THEN 'Usu rio' WHEN [RuleId] = 5 THEN 'Grupo de produto' WHEN [RuleId] = 6 THEN 'Pessoa' WHEN [RuleId] = 7 THEN 'Proposta' WHEN [RuleId] = 8 THEN 'Venda' WHEN [RuleId] = 9 THEN 'Documento' ELSE null END as 'PloomesEntityName'   
FROM [Queue].[dbo].[Integration_Queue];  
GO

