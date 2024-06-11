use Ploomes_CRM
go


-- RENOMEAR A TABELA ANTIGA PARA OLD E A NOVA PARA SER ORIGINAL
EXEC sp_rename 'dbo.webhook_log', 'Webhook_log_Old'
EXEC sp_rename 'dbo.WebHook_Log_BKP', 'Webhook_log'

--Select max(id) from Webhook_log_Old (nolock)
--Select max(id) from Webhook_log (nolock) 

select count(1) from webhook_log_Old (nolock)

sp_help 'webhook_log'
sp_help 'Webhook_log_Old'


-- RENOMEAR AS PKs PARA TEREM O NOME CORRETO
EXEC sp_rename 'dbo.PK_WebHook_Log', 'PK_WebHook_Log_Old', 'OBJECT'
EXEC sp_rename 'dbo.PK_WebHook_Log_BKP', 'PK_WebHook_Log', 'OBJECT'

--sp_helpindex 'webhook_log'
--sp_helpindex 'Webhook_log_Old'

--Truncate table Webhook_log_Old
