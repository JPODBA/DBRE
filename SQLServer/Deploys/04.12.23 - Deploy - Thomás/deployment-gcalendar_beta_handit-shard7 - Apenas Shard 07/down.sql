/*
Script de rollback do calendar no shard 5 para as contas novas criadas com os modelos trial
*/

USE Ploomes_CRM;

DELETE FROM INTEGRATION WHERE ID = 27;
DELETE FROM Integration_CustomField WHERE IntegrationId = 27;

DELETE FROM Integration_CustomField_Language WHERE ID = 131;
DELETE FROM Integration_CustomField_Language WHERE ID = 10131;
DELETE FROM Integration_CustomField_Language WHERE ID = 20131;
DELETE FROM Integration_CustomField_Language WHERE ID = 132;
DELETE FROM Integration_CustomField_Language WHERE ID = 10132;
DELETE FROM Integration_CustomField_Language WHERE ID = 20132;
DELETE FROM Integration_CustomField_Language WHERE ID = 133;
DELETE FROM Integration_CustomField_Language WHERE ID = 10133;
DELETE FROM Integration_CustomField_Language WHERE ID = 20133;
DELETE FROM Integration_CustomField_Language WHERE ID = 134;
DELETE FROM Integration_CustomField_Language WHERE ID = 10134;
DELETE FROM Integration_CustomField_Language WHERE ID = 20134;
DELETE FROM Integration_CustomField_Language WHERE ID = 135;
DELETE FROM Integration_CustomField_Language WHERE ID = 10135;
DELETE FROM Integration_CustomField_Language WHERE ID = 20135;
DELETE FROM Integration_CustomField_Language WHERE ID = 136;
DELETE FROM Integration_CustomField_Language WHERE ID = 10136;
DELETE FROM Integration_CustomField_Language WHERE ID = 20136;
DELETE FROM Integration_CustomField_Language WHERE ID = 137;
DELETE FROM Integration_CustomField_Language WHERE ID = 10137;
DELETE FROM Integration_CustomField_Language WHERE ID = 20137;
DELETE FROM Integration_CustomField_Language WHERE ID = 138;
DELETE FROM Integration_CustomField_Language WHERE ID = 10138;
DELETE FROM Integration_CustomField_Language WHERE ID = 20138;
DELETE FROM Integration_CustomField_Language WHERE ID = 139;
DELETE FROM Integration_CustomField_Language WHERE ID = 10139;
DELETE FROM Integration_CustomField_Language WHERE ID = 20139;
DELETE FROM Integration_CustomField_Language WHERE ID = 140;
DELETE FROM Integration_CustomField_Language WHERE ID = 10140;
DELETE FROM Integration_CustomField_Language WHERE ID = 20140;
DELETE FROM Integration_CustomField_Language WHERE ID = 141;
DELETE FROM Integration_CustomField_Language WHERE ID = 10141;
DELETE FROM Integration_CustomField_Language WHERE ID = 20141;
DELETE FROM Integration_CustomField_Language WHERE ID = 142;
DELETE FROM Integration_CustomField_Language WHERE ID = 10142;
DELETE FROM Integration_CustomField_Language WHERE ID = 20142;
DELETE FROM Integration_CustomField_Language WHERE ID = 143;
DELETE FROM Integration_CustomField_Language WHERE ID = 10143;
DELETE FROM Integration_CustomField_Language WHERE ID = 20143;
DELETE FROM Integration_CustomField_Language WHERE ID = 144;
DELETE FROM Integration_CustomField_Language WHERE ID = 10144;
DELETE FROM Integration_CustomField_Language WHERE ID = 20144;
DELETE FROM Integration_CustomField_Language WHERE ID = 145;
DELETE FROM Integration_CustomField_Language WHERE ID = 10145;
DELETE FROM Integration_CustomField_Language WHERE ID = 20145;

DELETE FROM Integration_Language WHERE IntegrationId = 27;

DELETE FROM Integration_Webhook WHERE IntegrationId = 27;

UPDATE WebHook SET Active = 1 WHERE ID IN (10001388,10001389,10001390,10001391,10001392,10001671,10001672,10001673,10001674,10001675,
10001676,10001677,10001678,10001679,10001680,10002066,10002067,10002068,10002069,10002070,10005879,10005880,10005881,10005882,10005883,
10011330,10011331,10011332,10011333,10011334,10011537,10011538,10011539,10011540,10011541,10012798,10012799,10012800,10012801,10012802)

UPDATE Ploomes_Cliente_Integration SET StatusId = 1, Authorized = 1 WHERE ID IN (10000546,10000625,10001946,10003688)
GO

ALTER VIEW [dbo].[SVw_Integration] AS
	SELECT I.*, IL.Description, U.ID as ViewUserId
		FROM Integration I INNER JOIN Integration_Language IL ON I.Id = IL.IntegrationId
			INNER JOIN Usuario U ON IL.Language = U.Cultura
			LEFT JOIN Ploomes_Cliente PC ON U.ID_ClientePloomes = PC.ID
GO

ALTER VIEW [dbo].[SVw_Ploomes_Cliente_Integration] AS
	SELECT PCI.*, Usu.Chave as IntegrationUserKey, U.ID as ViewUserId
		FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.AccountId = U.ID_ClientePloomes
			LEFT JOIN Usuario Usu ON PCI.IntegrationUserId = Usu.ID
			INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 1

	UNION ALL

	SELECT PCI.*, Usu.Chave as IntegrationUserKey, U.ID as ViewUserId
		FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.CreatorId = U.ID
			INNER JOIN Usuario Usu ON PCI.IntegrationUserId = Usu.ID
			INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 2

	UNION ALL

	SELECT PCI.*, U.Chave as IntegrationUserKey, U.ID as ViewUserId
		FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.IntegrationUserId = U.ID AND U.IntegracaoNativa = 1
			INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 2
GO

ALTER VIEW [dbo].[Vw_Self] AS
	SELECT S.*,
			CONVERT(BIT, IIF(PC.ID_Plano = 2 AND CAST(PC.Expira as DATE) < CAST(GETDATE() as DATE), 1, 0)) as ContaExpirada,
			CONVERT(BIT, IIF(PC.ID_Plano = 2 AND CAST(PC.Expira as DATE) < CAST(GETDATE() as DATE) AND EXISTS(SELECT 1 FROM Ploomes_Cliente_Bloqueio WHERE ID_ClientePloomes = PC.ID), 1, 0)) as ContaBloqueada,
			0 as ContagemTarefas2,
			0 as ContagemEmails2,
			S.ContagemLeads as ContagemLeads2,
			ISNULL(ISNULL((SELECT MAX(DataHora) FROM Log_Logon L WHERE L.ID_Usuario = S.ID AND L.ID <> (SELECT MAX(ID) FROM Log_Logon WHERE ID_Usuario = S.ID)), (SELECT MAX(DataHora) FROM Log_Logon L WHERE L.ID_Usuario = S.ID)), GETDATE()) as UltimoLogin,
			(SELECT TOP 1 ID FROM Usuario_Agenda_Integracao WHERE ID_Usuario = S.ID) as ID_AgendaIntegracao,
			(SELECT TOP 1 ITVU.ID FROM Integracao_TotalVoice_Usuario ITVU INNER JOIN Integracao_TotalVoice ITV ON ITVU.ID_Integracao = ITV.ID AND ITV.Suspenso = 'False' WHERE ITVU.ID_Usuario = S.ID) as ID_TotalVoiceIntegracao,
			(SELECT TOP 1 ID FROM Usuario_Email_Integracao WHERE ID_Usuario = S.ID) as ID_EmailIntegracao,
			CONVERT(BIT, IIF(EXISTS(SELECT 1 FROM Vw_Oportunidade_Funil WHERE ID_Usuario = S.ID), 1, 0)) as PossuiFunis,
			CONVERT(BIT, IIF(EXISTS(SELECT 1 FROM Usuario_Agenda_Integracao WHERE ID_Usuario = S.ID AND ID_Calendario IS NOT NULL) OR EXISTS(SELECT 1 FROM Ploomes_Cliente_Integration WHERE IntegrationId IN (7, 12) AND CreatorId = S.ID AND StatusId = 1 AND Enabled = 1), 1, 0)) as HasTasksIntegration,
			CONVERT(BIT, IIF(EXISTS(SELECT 1 FROM Ploomes_Usuario_SupportUser WHERE SupportUserId = S.ID), 1, 0)) as IsSupportUser,
			IIF(PC.PipelineUserUsabilityId = 3, S.PipelineUserUsabilityId, PC.PipelineUserUsabilityId) as PipelineUserUsabilityId2,
			IIF(PC.QuoteTemplateUserUsabilityId = 3, S.QuoteTemplateUserUsabilityId, PC.QuoteTemplateUserUsabilityId) as QuoteTemplateUserUsabilityId2,
			IIF(PC.OrderTemplateUserUsabilityId = 3, S.OrderTemplateUserUsabilityId, PC.OrderTemplateUserUsabilityId) as OrderTemplateUserUsabilityId2,
			IIF(PC.DocumentTemplateUserUsabilityId = 3, S.DocumentTemplateUserUsabilityId, PC.DocumentTemplateUserUsabilityId) as DocumentTemplateUserUsabilityId2,
			CONVERT(BIT, IIF(S.ID = PC.ID_Criador, 1, 0)) as CriadorConta
		FROM Usuario S LEFT JOIN Ploomes_Cliente PC ON S.ID_ClientePloomes = PC.ID
		WHERE S.Suspenso = 'False'
GO

DROP PROCEDURE [dbo].[Int_Update_Campo_Task_Valor]
GO

DROP TRIGGER [dbo].[Change_Ploomes_Task_Calendar_Id]
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)