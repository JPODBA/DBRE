
--Insert Ploomes_CRM..WebHook_Log
--	(Id																					
--	 ,WebhookId																		
--	 ,AttemptId																		
--	 ,DateTime																		
--	 ,HttpStatus																
--	 ,CurrentAttempt															
--	 ,EntityId																		
--	 ,SecondaryEntityId														
--	 ,ActionId																		
--	 ,CallbackUrl																	
--	 ,ValidationKey																
--	 ,ResponseBody																
--	 ,TimeSpanFromCreationToExecutionInMilliseconds
----	 )
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
	--COUNT(t1.id)
into BA_DBA.dbo.dba_bkp_webhook
From Ploomes_CRM..Webhook_log_Old t1 (nolock)
where not exists (Select 1 from Ploomes_CRM..WebHook_Log t2 (nolock) where t2.Id = t1.Id and t2.id <= 744117420)

--Select max(id) from Webhook_log_Old
--drop table if exists BA_DBA.dbo.dba_bkp_webhook
--select count(1) from BA_DBA.dbo.dba_bkp_webhook
--Select id into BA_DBA.dbo.dba_bkp_webhook from #Webhook_log_Old

Declare @maxid int, @minid int
while exists (select 1 from BA_DBA.dbo.dba_bkp_webhook)
Begin
	SET IDENTITY_INSERT Ploomes_CRM..WebHook_Log ON;  

	drop table if exists #tempdel
	Select top 10000 id into #tempdel from BA_DBA.dbo.dba_bkp_webhook

	Select @minid = min(id), @maxid = max(id) from #tempdel

	If exists (select 1 from Ploomes_CRM..WebHook_Log t1 where t1.Id >= @minid and t1.Id <= @maxid)
	begin
		Print 'TEM ID'

	end
	else
	begin

		Insert Ploomes_CRM..WebHook_Log
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
		From Ploomes_CRM..Webhook_log_Old t1 (nolock)
		where t1.Id >= @minid
			and t1.Id <= @maxid
			
			
	end

	Delete dba
	--Select dba.id
	from BA_DBA.dbo.dba_bkp_webhook dba
	join #tempdel tpm on tpm.id = dba.id
	Select @@ROWCOUNT as dell

	
	SET IDENTITY_INSERT Ploomes_CRM..WebHook_Log OFF;  
	--return

END
	
