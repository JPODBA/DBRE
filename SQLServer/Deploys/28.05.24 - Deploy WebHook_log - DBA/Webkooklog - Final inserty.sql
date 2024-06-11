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
--join #DBA_ID								  t2 (nolock) on t2.id = t1.id
where t1.id > 737000017
	and t1.id <= 741738717

SET IDENTITY_INSERT Ploomes_CRM..WebHook_Log_BKP OFF;  