/*
    Script de subida do deployment 20-2-2024
*/
USE Ploomes_CRM;
GO

-- up 1
-- https://app.asana.com/0/626405171214145/1206444324523350/f
ALTER VIEW [dbo].[SVw_Lead] AS
	SELECT L.*, IIF(L.ID_Empresa > 0, L.ID_Empresa, NULL) as ID_Empresa2, ISNULL(L.Empresa, E.Nome) as NomeEmpresa, ISNULL(L.RazaoSocial, E.RazaoSocial) as RazaoSocial2,
			ISNULL(L.CNPJ, E.CNPJ) as CNPJ2, IIF(L.ID_Contato > 0, L.ID_Contato, NULL) as ID_Contato2, ISNULL(L.Nome, Ct.Nome) as NomeContato,
			U.ID as ID_Usuario,
			CONVERT(BIT, CASE
				WHEN P.Lead_Edita = 1
					THEN 1
				WHEN P.Lead_Edita BETWEEN 2 AND 3
						AND L.ID_Responsavel = U.ID
					THEN 1
				WHEN P.Lead_Edita = 2
						AND EXISTS (
							SELECT 1
								FROM Equipe_Usuario EU
								WHERE EU.ID_Usuario = U.ID
									AND EXISTS (
										SELECT 1
											FROM Equipe_Usuario
											WHERE ID_Equipe = EU.ID_Equipe
												AND ID_Usuario = L.ID_Responsavel
									)
						)
					THEN 1
				ELSE 0
			END) as Edita,
			CONVERT(BIT, CASE
				WHEN P.Lead_Exclui = 1
					THEN 1
				WHEN P.Lead_Exclui BETWEEN 2 AND 3
						AND L.ID_Responsavel = U.ID
					THEN 1
				WHEN P.Lead_Exclui = 2
						AND EXISTS (
							SELECT 1
								FROM Equipe_Usuario EU
								WHERE EU.ID_Usuario = U.ID
									AND EXISTS (
										SELECT 1
											FROM Equipe_Usuario
											WHERE ID_Equipe = EU.ID_Equipe
												AND ID_Usuario = L.ID_Responsavel
									)
						)
					THEN 1
				ELSE 0
			END) as Exclui,
			P.Lead_Manipula as Manipula,
			ISNULL(L.DataAtualizacao, L.DataCriacao) as UltimaAtualizacao,
			CONVERT(BIT, IIF(L.ID_Status <> 2, 0, 1)) as ContatoAgendado,
			IIF(L.ID_Status BETWEEN 4 AND 6, L.ID_Status, 0) as OrdemStatus,
			IIF(L.ID_Status = 2 AND (T.Datepart = 'day' AND DATEDIFF(DAY, L.ProximoContato, GETDATE()) >= T.Tempo OR T.Datepart = 'minute' AND DATEDIFF(MINUTE, L.ProximoContato, GETDATE()) >= T.Tempo), L.ProximoContato, CONVERT(DATETIME, '12/12/9999')) as Ordem
		FROM Lead L INNER JOIN Usuario U ON L.ID_ClientePloomes = U.ID_ClientePloomes
			INNER JOIN Ploomes_Cliente PC ON U.ID_ClientePloomes = PC.ID
			LEFT JOIN Lead_Topo T ON L.ID_Topo = T.ID
			LEFT JOIN Usuario_Perfil P ON U.ID_Perfil = P.ID
			LEFT JOIN Cliente E ON L.ID_Empresa = E.ID
			LEFT JOIN Cliente Ct ON L.ID_Contato = Ct.ID
		WHERE EXISTS(SELECT 1 FROM Usuario_Responsavel WHERE ID_Usuario = U.ID AND ID_Responsavel = ISNULL(L.ID_Responsavel, 0) AND ID_Tipo = 3)
			AND L.Suspenso = 'False'
			AND PC.Leads = 1
GO

-- up 2
-- https://app.asana.com/0/626405171214145/1206511378282382/f
ALTER TABLE [PublicForm_Field_Option]
ALTER COLUMN [Name] [nvarchar](200) COLLATE Latin1_General_CI_AI NOT NULL 
GO

-- up 3
-- https://app.asana.com/0/626405171214145/1206511378282382/f
ALTER TABLE [Automation]
ADD [DisabledDueToError] BIT NOT NULL,
CONSTRAINT [DF_Automation_DisabledDueToError] DEFAULT ((0)) FOR [DisabledDueToError]
GO

ALTER TRIGGER [dbo].[Tg_Campo_Update]
	ON [dbo].[Campo]
	AFTER UPDATE
AS BEGIN
	DECLARE @ID_ClientePloomes INT, @ID_Campo INT, @Chave NVARCHAR(100)
	SELECT @ID_ClientePloomes = i.ID_ClientePloomes, @ID_Campo = i.ID, @Chave = i.Chave
		FROM inserted i INNER JOIN deleted d ON i.ID = d.ID
		WHERE i.Suspenso = 'True' AND d.Suspenso = 'False'

	IF @ID_Campo IS NOT NULL BEGIN
		DELETE FROM Formulario_Campo WHERE ID_Campo = @ID_Campo AND Fixo = 'False'
		DELETE FROM Tabela_Campo WHERE ID_Campo = @ID_Campo AND Fixo = 'False'
		DELETE FROM Tabela_Campo_Campo WHERE ID_Campo = @ID_Campo AND Fixo = 'False'
		DELETE FROM RegraNegocio_Campo WHERE ID_Campo = @ID_Campo AND Fixo = 'False'
		DELETE FROM Campo_Formula_Variavel WHERE ID_CampoVariavel = @ID_Campo AND Fixo = 'False'
		DELETE CF
			FROM Checklist_Field CF INNER JOIN Checklist C ON CF.ChecklistId = C.Id AND C.AccountId = @ID_ClientePloomes
			WHERE CF.FieldKey = @Chave
		DELETE FROM Field WHERE AccountId = @ID_ClientePloomes AND FieldId = @ID_Campo AND [Dynamic] = 1
		DELETE PFFO
			FROM PublicForm_Field_Option PFFO INNER JOIN PublicForm_Field PFF ON PFFO.PublicFormFieldId = PFF.Id
				INNER JOIN PublicForm PF ON PF.Id = PFF.PublicFormId AND PF.AccountId = @ID_ClientePloomes
			WHERE PFF.FieldKey = @Chave
		DELETE PFF
			FROM PublicForm_Field PFF INNER JOIN PublicForm PF ON PF.Id = PFF.PublicFormId AND PF.AccountId = @ID_ClientePloomes
			WHERE PFF.FieldKey = @Chave
		DELETE PFDFV
			FROM PublicForm_DefaultField_Value PFDFV INNER JOIN PublicForm_DefaultField PFDF ON PFDFV.PublicFormDefaultFieldId = PFDF.Id
				INNER JOIN PublicForm PF ON PF.Id = PFDF.PublicFormId AND PF.AccountId = @ID_ClientePloomes
			WHERE PFDF.FieldKey = @Chave
		DELETE PFDF 
			FROM PublicForm_DefaultField PFDF INNER JOIN PublicForm PF ON PF.Id = PFDF.PublicFormId AND PF.AccountId = @ID_ClientePloomes
			WHERE PFDF.FieldKey = @Chave
		UPDATE A
			SET [DisabledDueToError] = 1, [Enabled] = 0
			FROM Automation AS A
			INNER JOIN Automation_Action AS AA
			ON A.Id = AA.AutomationId
			WHERE AA.FieldKey = @Chave
	END
END
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)