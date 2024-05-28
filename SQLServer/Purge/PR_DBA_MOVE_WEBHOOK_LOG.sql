USE BA_DBA
GO
IF (OBJECT_ID ('PR_DBA_MOVE_WEBHOOK_LOG') IS NULL) EXEC ('Create Procedure PR_DBA_MOVE_WEBHOOK_LOG as return')
GO
CREATE OR ALTER PROC PR_DBA_MOVE_WEBHOOK_LOG
	@Debug bit = 0
/************************************************************************
 Autor: João Paulo Oliveira \ DBA
 Data de criação: 28/04/2024
 Data de Atualização:   
 
 Funcionalidade: Faz a movimentação de Dados da tabela Ploomes_CRM..WebHook_Log
 para um Ploomes_CRM..WebHook_Log_BKP e depois poder truncar a tabela e liberar
 espaço no disco Data. 
*************************************************************************/
AS
BEGIN

	Drop table if exists #DBA_ID
	Create table #DBA_ID (Id int Primary key)

	Declare @maxId int, @Count_WebHook_Quente int, @Count_WebHook_bkp int

	Select @Count_WebHook_Quente = 727561625 --count(id) From Ploomes_CRM..WebHook_Log (nolock)
	Select @Count_WebHook_bkp = Count(id) From Ploomes_CRM..WebHook_Log_BKP (nolock)
		
	If (@Debug = 1)
	Begin
		Select @Count_WebHook_bkp as Count_WebHook_bkp, @Count_WebHook_Quente as Count_WebHook_Quente
		Select Count(id) as Count_WebHook_bkp_TABELA From Ploomes_CRM..WebHook_Log_BKP (nolock)
		--return
	End

	While @Count_WebHook_bkp < @Count_WebHook_Quente
	Begin
		
		If not exists (Select 1 From Ploomes_CRM..WebHook_Log_BKP (nolock))
		Begin
			insert #DBA_ID
			Select top 1000000 Id From Ploomes_CRM..WebHook_Log (nolock) order by id asc
		End
		Else
		Begin
				
			Select @maxId = max(id) From Ploomes_CRM..WebHook_Log_BKP (nolock)
			-- Top é o limite do insert
			insert #DBA_ID
			Select top 1000000 Id From Ploomes_CRM..WebHook_Log (nolock) where id > @maxId  order by id asc

		End

		If (@Debug = 1)
		Begin
			Select @maxId as MaxID
			Select Count(id) as Count_Valida_Insert_Tralha From #DBA_ID (nolock)
			Select Max(id) as MaxID_Tralha_DepoisDOInsert From #DBA_ID (nolock)

			return
		End
			
		SET IDENTITY_INSERT Ploomes_CRM..WebHook_Log_BKP ON;  

		Insert Ploomes_CRM..WebHook_Log_BKP
			(Id																					
			 ,WebhookId																		
			 ,AttemptId																		
			 ,DateTime																		
			 ,HttpStatus																
			 ,CurrentAttempt															
			 ,EntityId																		
			 ,SecondaryEntityId														
			 ,ActionId																		
			 ,CallbackUrl																	
			 ,ValidationKey																
			 ,ResponseBody																
			 ,TimeSpanFromCreationToExecutionInMilliseconds
			 )
		Select
			t1.Id																					
		 ,WebhookId																		
		 ,AttemptId																		
		 ,DateTime																	
		 ,HttpStatus																	
		 ,CurrentAttempt														
		 ,EntityId																	
		 ,SecondaryEntityId														
		 ,ActionId																		
		 ,CallbackUrl																	
		 ,ValidationKey																
		 ,ResponseBody																
		 ,TimeSpanFromCreationToExecutionInMilliseconds
		From Ploomes_CRM..WebHook_Log t1 (nolock)
		join #DBA_ID								  t2 (nolock) on t2.id = t1.id

		SET IDENTITY_INSERT Ploomes_CRM..WebHook_Log_BKP OFF;  

		Truncate table #DBA_ID
		Select @Count_WebHook_bkp = Count(id) From Ploomes_CRM..WebHook_Log_BKP (nolock)
		
	End -- While 

End -- Proc


--Select MIN(id), MAX(id), count(1) from Ploomes_CRM..WebHook_Log_BKP (nolock) where id <= 6000000
--Select MIN(id), MAX(id), count(1) from Ploomes_CRM..WebHook_Log_BKP (nolock)

-- ESSA QUERY É A VALIDAÇÂO! Lembrando que vai ficar cada fez pior devido a quantidade de linhas
--Select COUNT(t1.id), COUNT(t2.id)
--From Ploomes_CRM..WebHook_Log			t1 (nolock)
--Join Ploomes_CRM..WebHook_Log_BKP t2 (nolock) on t2.id = t1.id

--truncate table Ploomes_CRM..WebHook_Log_BKP
--DBCC CHECKIDENT ('WebHook_Log_BKP', RESEED, 0);

--exec PR_DBA_MOVE_WEBHOOK_LOG
--Select COUNT(t1.id), COUNT(t2.id)
--From Ploomes_CRM..WebHook_Log			t1 (nolock)
--Join Ploomes_CRM..WebHook_Log_BKP t2 (nolock) on t2.id = t1.id
--GO
--Select  max(t1.id)
--From Ploomes_CRM..WebHook_Log_BKP t1 (nolock)

--17.000.001
--173.000.000
--445.000.000 