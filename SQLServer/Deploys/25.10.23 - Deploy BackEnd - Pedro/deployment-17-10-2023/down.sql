-- down up 2
-- removido do pacote

-- down up 3
ALTER TABLE [dbo].[Campo] DROP CONSTRAINT [DF_Campo_RemoveFieldHeightLimit]
GO
ALTER TABLE [dbo].[Campo] DROP COLUMN [RemoveFieldHeightLimit]
GO

-- down up 4
ALTER VIEW [dbo].[SVw_Campo] AS
SELECT F.FieldId as ID, 
       F.[Key] as Chave, 
       F.[Dynamic] as Dinamico, 
       ISNULL(CL.Name, C.Descricao) as Descricao,
       C.ID_Tabela,
       C.ID_Tipo,
	   C.ID_TabelaEstrangeira,
       C.ID_TabelaEstrangeiraFixa, 
       C.Multiplo,
       IIF(C.ID_Tipo = 1, 250, NULL) as StringLength,
       C.Obrigatorio,
       CONVERT(BIT, 0) AS NaoNulavel, 
       CONVERT(BIT, 0) AS Permanente, 
       C.Unico,
       CONVERT(BIT, IIF(C.ID_Tipo NOT IN (2, 22), 1, 0)) AS Filtro, 
       C.Filtro AS FiltroFormulario, 
       CONVERT(BIT, 0) AS PulaTabelaIntermediaria, 
       CONVERT(BIT, IIF(C.ID_Tipo <> 22, 1, 0)) AS Importavel, 
       C.Expandido, 
       C.ColumnSize,
       C.Formula,
	   ISNULL(C.FormulaExternaUrl, IIF(CGS.ID IS NOT NULL, CASE WHEN db_name() = 'Ploomes_CRM_SPA' THEN 'https://api2-dev.ploomes.com/' WHEN db_name() = 'Ploomes_CRM_QA' THEN 'https://api2-qa.ploomes.com/' WHEN db_name() = 'Ploomes_CRM_PPrd2' THEN 'https://api2-pprd.ploomes.com/' ELSE 'https://app-api2.ploomes.com/' END + 'Fields@GoogleSheetsIntegrations(' + CONVERT(NVARCHAR(10), CGS.ID) + ')/CalculateValue', NULL)) AS FormulaExternaUrl,
	   ISNULL(C.FormulaExternaMethod, IIF(CGS.ID IS NOT NULL, 'POST', NULL)) AS FormulaExternaMethod, 
       ISNULL(C.FormulaExternaHeaders, IIF(CGS.ID IS NOT NULL, '{"User-Key": "' + U.Chave + '"}', NULL)) AS FormulaExternaHeaders,
	   ISNULL(C.FormulaExternaRequestBody, '{"Variables": [' + (SELECT '{"VariableId": ' + CONVERT(NVARCHAR(10), CGSV.ID) + ', "Value": ' + IIF(CVT.EFType IN ('String', 'DateTime') OR CVT.ID = 7, '"', '') + '[V' + CONVERT(NVARCHAR(10), CGSV.ID) + ']' + IIF(CVT.EFType IN ('String', 'DateTime') OR CVT.ID = 7, '"', '') + '},' FROM Campo_GoogleSheets_Variavel CGSV LEFT JOIN Campo CV ON CGSV.ID_CampoVariavel = CV.ID AND CGSV.Fixo = 'False' LEFT JOIN CampoFixo2 CFV ON CGSV.ID_CampoVariavel = CFV.ID AND CGSV.Fixo = 'True' LEFT JOIN Campo_Tipo CVT ON ISNULL(CV.ID_Tipo, CFV.ID_Tipo) = CVT.ID WHERE CGSV.ID_Integracao = CGS.ID For XML PATH, TYPE).value('.[1]', 'NVARCHAR(MAX)') + ']}') AS FormulaExternaRequestBody,
	   CGS.ID AS ID_Integracao_GoogleSheets,
	   C.Bloqueado,
       C.Oculto,
       C.Integracao,
       C.IntegrationCustomFieldId,
       IIF(C.ID_Tipo = 7 AND C.ID_TabelaEstrangeira IS NOT NULL, 'Fields@OptionsTables@Options', NULL) AS ApiUrl,
	   NULL AS PropertyName, 
       NULL AS UpdatePropertyName, 
       CONVERT(BIT, 0) AS DisplayProperty, 
       C.AutoParagraph,
	   CONVERT(BIT, CASE
						WHEN C.ID_Tipo = 19 AND C.IsMobileEdit = 1 THEN 0
						WHEN C.ID_Tipo = 22 THEN 0
						ELSE 1
					END) AS Editavel, 
       IIF(C.ID_Tipo = 7 AND C.ID_TabelaEstrangeira IS NOT NULL,'OtherOptionsCreatePermission', CT.OptionsCreationPermissionPropertyName) AS PermissaoCriacaoOpcoes,
       IIF(C.ID_TipoItem = 2, C.ID_Item, NULL) AS ID_ProdutoGrupo,
	   IIF(C.ID_TipoItem = 3, C.ID_Item, NULL) AS ID_ProdutoFamilia,
	   C.ValorTextoPadrao, 
       C.ValorTextoMultilinhaPadrao, 
       C.ValorInteiroPadrao, 
       C.ValorDecimalPadrao,
	   C.ValorDataHoraPadrao,
       C.ValorBooleanoPadrao, 
       ISNULL(CO.Chave, CFO.Chave) AS Chave_CampoOrigem, 
       ISNULL(CVn.ID_Caminho, CTC.ID) AS ID_Caminho_CampoOrigem,
	   C.FormulaEditor, 
       C.UseCheckbox, 
       C.FilterId,
	   /*CONVERT(BIT, 1) as EditaValor,
	   NULL AS [Label],
	   CONVERT(BIT, 1) as [Hidden],*/
       CONVERT(BIT, CASE WHEN U.ID_Perfil = 1 THEN 1
                                              WHEN NOT EXISTS(SELECT 1 FROM Campo_Permissao_Usuario WHERE ID_Campo = C.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 0)
                                                   AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Equipe WHERE ID_Campo = C.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 0)
                                                   AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_PerfilUsuario WHERE ID_Campo = C.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 0) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Usuario WHERE ID_Campo = C.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 0 AND ID_Usuario = U.ID) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_PerfilUsuario WHERE ID_Campo = C.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 0 AND ID_Perfil = U.ID_Perfil) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Equipe PE INNER JOIN Equipe_Usuario EU ON PE.ID_Campo = C.ID AND PE.ID_ClientePloomes = U.ID_ClientePloomes AND PE.Fixo = 0 AND PE.ID_Equipe = EU.ID_Equipe AND EU.ID_Usuario = U.ID) THEN 1
                                              ELSE 0
                                         END) AS EditaValor,
        C.[Label],
		CONVERT(BIT, CASE WHEN U.ID_Perfil = 1 THEN 0
                                               WHEN NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_User CPU WHERE CPU.FieldId = C.ID AND CPU.AccountId = U.ID_ClientePloomes AND CPU.FieldFixed = 0)
                                               	    AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_Team CPT WHERE CPT.FieldId = C.ID AND CPT.AccountId = U.ID_ClientePloomes AND CPT.FieldFixed = 0)
                                               	    AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_UserProfile CPP WHERE CPP.FieldId = C.ID AND CPP.AccountId = U.ID_ClientePloomes AND CPP.FieldFixed = 0) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_User CPU WHERE CPU.FieldId = C.ID AND CPU.AccountId = U.ID_ClientePloomes AND CPU.FieldFixed = 0 AND CPU.UserId = U.ID) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_UserProfile CPP WHERE CPP.FieldId = C.ID AND CPP.AccountId = U.ID_ClientePloomes AND CPP.FieldFixed = 0 AND CPP.ProfileId = U.ID_Perfil) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_Team CPT INNER JOIN Equipe_Usuario EU ON CPT.FieldId = C.ID AND CPT.AccountId = U.ID_ClientePloomes AND CPT.FieldFixed = 0 AND CPT.TeamId = EU.ID_Equipe AND EU.ID_Usuario = U.ID) THEN 0
                                               ELSE 1
                                          END) AS [Hidden],
		U.ID as ID_Usuario,
		C.FieldHideFormula,
		C.FieldDisableFormula,
		C.InlineEditTriggerDocumentGeneration,
		C.IsSensitiveData,
		C.ShowTime,
		C.IsMobileEdit,
		C.UseAttachmentUrl,
		C.ClearOnDefaultCrud,
		C.ExternalListUrl,
        NULL as InversePropertyFieldKey,
		C.SendExternalKey,
		C.ReceiveExternalKey,
		C.EnableFormatting,
		ISNULL(C.DataAtualizacao, C.DataCriacao) as LastUpdateDate
   FROM Field F 
  INNER JOIN Usuario U ON F.AccountId = U.ID_ClientePloomes
   INNER JOIN Campo C ON F.FieldId = C.ID AND F.[Dynamic] = 1 AND C.Suspenso = 'False'
   LEFT JOIN Campo_Language CL ON CL.FieldId = C.ID AND CL.LanguageId = U.LanguageId
   LEFT JOIN Campo_GoogleSheets CGS ON C.ID = CGS.ID_Campo
   LEFT JOIN Campo_Vinculo CVn ON CVn.ID_CampoDestino = C.ID AND CVn.Fixo_CampoDestino = 'False'
   LEFT JOIN Campo CO ON CVn.ID_CampoOrigem = CO.ID AND CVn.Fixo_CampoOrigem = 'False'
   LEFT JOIN CampoFixo2 CFO ON CVn.ID_CampoOrigem = CFO.ID AND CVn.Fixo_CampoOrigem = 'True'
   LEFT JOIN Campo_Tabela_Caminho CTC ON CTC.ID_TabelaOrigem = C.ID_Tabela AND CTC.ID_TabelaDestino = ISNULL(CO.ID_Tabela, CFO.ID_Tabela) AND CTC.Padrao = 'True'
   LEFT JOIN Campo_Tabela CT ON CT.ID = C.ID_TabelaEstrangeiraFixa


UNION ALL


SELECT F.FieldId as ID, 
       F.[Key] as Chave, 
       F.[Dynamic] as Dinamico, 
       ISNULL(CFCA.Name, CFC.Descricao) as Descricao,
       CF.ID_Tabela, 
       CF.ID_Tipo,
	    NULL AS ID_TabelaEstrangeira,
       CF.ID_TabelaEstrangeiraFixa, 
       CF.Multiplo,
       CF.StringLength,
       ISNULL(CFCP.Obrigatorio, CF.Obrigatorio) AS Obrigatorio,
       CF.NaoNulavel, 
       CONVERT(BIT, IIF(CF.Obrigatorio = 'True' AND CF.NaoNulavel = 'True', 1, 0)) AS Permanente, 
       ISNULL(CFCP.Unico, CF.Unico) AS Unico,
       CF.Filtro AS Filtro,
       ISNULL(CFCP.FiltroFormulario, CF.FiltroFormulario) AS FiltroFormulario, 
       CF.PulaTabelaIntermediaria, 
       CF.Importavel, 
       ISNULL(CFCP.Expandido, CONVERT(BIT, IIF(CF.ID_Tipo = 2, 1, 0))) AS Expandido, 
       ISNULL(CFCP.ColumnSize, CF.ColumnSize) AS ColumnSize,
       ISNULL(CFCPF.Formula, CF.Formula) AS Formula,
       CFCPF.ExternalFormulaUrl AS FormulaExternaUrl,
       CFCPF.ExternalFormulaMethod AS FormulaExternaMethod, 
       CFCPF.ExternalFormulaHeaders AS FormulaExternaHeaders,
       CFCPF.ExternalFormulaRequestBody AS FormulaExternaRequestBody,
	   NULL AS ID_Integracao_GoogleSheets,
	   ISNULL(CFCP.Bloqueado, CONVERT(BIT, 0)) AS Bloqueado,
       ISNULL(CFCP.Oculto, CONVERT(BIT, 0)) AS Oculto,
       CONVERT(BIT, 0) AS Integracao,
       NULL AS IntegrationCustomFieldId,
       CF.ApiUrl,
	   CF.PropertyName, 
       CF.UpdatePropertyName, 
       CF.DisplayProperty, 
       CONVERT(BIT, 1) AS AutoParagraph,
	   CF.Editavel, 
       CT.OptionsCreationPermissionPropertyName AS PermissaoCriacaoOpcoes, 
       NULL AS ID_ProdutoGrupo,
	   NULL AS ID_ProdutoFamilia,
	   NULL AS ValorTextoPadrao, 
       NULL AS ValorTextoMultilinhaPadrao, 
       NULL AS ValorInteiroPadrao, 
       NULL AS ValorDecimalPadrao,
	   NULL AS ValorDataHoraPadrao,
       NULL AS ValorBooleanoPadrao, 
       ISNULL(CFCO.Chave, CFCFO.Chave) AS Chave_CampoOrigem, 
       ISNULL(CFCVn.ID_Caminho, CFCTC.ID) AS ID_Caminho_CampoOrigem,
	   CONVERT(BIT, ISNULL(CFCP.FormulaEditor, 0)) AS FormulaEditor, 
       CFCP.UseCheckbox, 
       CFCP.FilterId,
	   /*CONVERT(BIT, 1) as EditaValor,
	   NULL AS [Label],
	   CONVERT(BIT, 1) as [Hidden],*/
       CONVERT(BIT, CASE WHEN U.ID_Perfil = 1 THEN 1
                                              WHEN NOT EXISTS(SELECT 1 FROM Campo_Permissao_Usuario WHERE ID_Campo = CF.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 1)
                                                   AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Equipe WHERE ID_Campo = CF.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 1)
                                                   AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_PerfilUsuario WHERE ID_Campo = CF.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 1) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Usuario WHERE ID_Campo = CF.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 1 AND ID_Usuario = U.ID) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_PerfilUsuario WHERE ID_Campo = CF.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 1 AND ID_Perfil = U.ID_Perfil) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Equipe PE INNER JOIN Equipe_Usuario EU ON PE.ID_Campo = CF.ID AND PE.Fixo = 1 AND PE.ID_ClientePloomes = U.ID_ClientePloomes AND PE.ID_Equipe = EU.ID_Equipe AND EU.ID_Usuario = U.ID) THEN 1
                                              ELSE 0
	                                     END) AS EditaValor,
        NULL AS [Label],
		CONVERT(BIT, CASE WHEN U.ID_Perfil = 1 THEN 0
                                               WHEN NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_User CPU WHERE CPU.FieldId = CF.ID AND CPU.AccountId = U.ID_ClientePloomes AND CPU.FieldFixed = 1)
                                               	    AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_Team CPT WHERE CPT.FieldId = CF.ID AND CPT.AccountId = U.ID_ClientePloomes AND CPT.FieldFixed = 1)
                                               	    AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_UserProfile CPP WHERE CPP.FieldId = CF.ID AND CPP.AccountId = U.ID_ClientePloomes AND CPP.FieldFixed = 1) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_User WHERE FieldId = CF.ID AND AccountId = U.ID_ClientePloomes AND FieldFixed = 1 AND UserId = U.ID) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_UserProfile WHERE FieldId = CF.ID AND AccountId = U.ID_ClientePloomes AND FieldFixed = 1 AND ProfileId = U.ID_Perfil) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_Team CPT INNER JOIN Equipe_Usuario EU ON CPT.FieldId = CF.ID AND CPT.AccountId = U.ID_ClientePloomes AND CPT.FieldFixed = 1 AND CPT.TeamId = EU.ID_Equipe AND EU.ID_Usuario = U.ID) THEN 0
                                               ELSE 1
                                          END) AS [Hidden],
		U.ID as ID_Usuario,
		CFCPF.FieldHideFormula,
		CFCPF.FieldDisableFormula,
		CF.InlineEditTriggerDocumentGeneration,
		NULL as IsSensitiveData,
		NULL as ShowTime,
		NULL as IsMobileEdit,
		NULL as UseAttachmentUrl,
		CONVERT(BIT, 0) as ClearOnDefaultCrud,
		NULL as ExternalListUrl,
        CF.InversePropertyFieldKey,
		CFCP.SendExternalKey,
		CFCP.ReceiveExternalKey,
		CFCP.EnableFormatting,
		ISNULL(CFCP.UpdateDate, CF.CreateDate) as LastUpdateDate
   FROM Field F 
  INNER JOIN Usuario U ON F.AccountId = U.ID_ClientePloomes
   INNER JOIN CampoFixo2 CF ON F.FieldId = CF.ID AND F.[Dynamic] = 0
   LEFT JOIN CampoFixo2_Cultura CFC ON CF.ID = CFC.ID_Campo AND CFC.Cultura = U.Cultura
   LEFT JOIN CampoFixo2_Cultura_Account CFCA ON CFCA.FieldLanguageId = CFC.ID AND U.ID_ClientePloomes = CFCA.AccountId AND U.LanguageId = CFCA.LanguageId
   LEFT JOIN CampoFixo2_ClientePloomes CFCP ON CFCP.ID_ClientePloomes = U.ID_ClientePloomes AND CFCP.ID_Campo = CF.ID 
   LEFT JOIN CampoFixo2_ClientePloomes_Formula CFCPF ON CFCPF.ID_ClientePloomes = U.ID_ClientePloomes AND CFCPF.ID_Campo = CF.ID
   LEFT JOIN Campo_Vinculo CFCVn ON CFCVn.ID_CampoDestino = CF.ID AND CFCVn.Fixo_CampoDestino = 'True' AND CFCVn.ID_ClientePloomes = U.ID_ClientePloomes
   LEFT JOIN CampoFixo2_Vinculo CFVn ON CFVn.ID_CampoDestino = CF.ID
   LEFT JOIN Campo CFCO ON CFCVn.ID_CampoOrigem = CFCO.ID AND CFCVn.Fixo_CampoOrigem = 'False'
   LEFT JOIN CampoFixo2 CFCFO ON CFCVn.ID_CampoOrigem = CFCFO.ID AND CFCVn.Fixo_CampoOrigem = 'True' OR CFVn.ID_CampoOrigem = CFCFO.ID AND CFCVn.ID IS NULL
   LEFT JOIN Campo_Tabela_Caminho CFCTC ON CFCTC.ID_TabelaOrigem = CF.ID_Tabela AND CFCTC.ID_TabelaDestino = ISNULL(CFCO.ID_Tabela, CFCFO.ID_Tabela) AND CFCTC.Padrao = 'True'
   LEFT JOIN Campo_Tabela CT ON CT.ID = CF.ID_TabelaEstrangeiraFixa
GO


-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)