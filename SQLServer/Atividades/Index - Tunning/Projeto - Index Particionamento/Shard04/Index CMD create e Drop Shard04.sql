drop table if exists BA_DBA.dbo.DROP_DBA_ESTRUTURA_INDEXDEPLOY
Create table BA_DBA.dbo.DROP_DBA_ESTRUTURA_INDEXDEPLOY (id int identity (1,1), inx_name varchar(300), createcmd text, dropcmd text)

insert BA_DBA.dbo.DROP_DBA_ESTRUTURA_INDEXDEPLOY
SELECT I.name as IndexName, 
        -- Uncommnent line below to include checking for index exists as part of the script
        --'IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = '''+ I.name +''') ' +
        'CREATE ' + CASE WHEN I.is_unique = 1 THEN ' UNIQUE ' ELSE '' END +
        I.type_desc COLLATE DATABASE_DEFAULT + ' INDEX [' +
        I.name + '] ON [' + SCHEMA_NAME(T.schema_id) + '].[' + T.name + '] (' + STUFF(
        (SELECT ', [' + C.name + CASE WHEN IC.is_descending_key = 0 THEN '] ASC' ELSE '] DESC' END
            FROM sys.index_columns IC INNER JOIN sys.columns C ON  IC.object_id = C.object_id  AND IC.column_id = C.column_id
            WHERE IC.is_included_column = 0 AND IC.object_id = I.object_id AND IC.index_id = I.Index_id
            FOR XML PATH('')), 1, 2, '')  + ') ' +
        ISNULL(' INCLUDE (' + IncludedColumns + ') ', '') +
        ISNULL(' WHERE ' + I.filter_definition, '') + 
        'WITH (FILLFACTOR = ' + CONVERT(VARCHAR(5), CASE WHEN I.fill_factor = 0 THEN 100 ELSE I.fill_factor END) +
           ') ON [INDEX];' + CHAR(13) + CHAR(10) as [CreateIndex],
        'DROP INDEX IF EXISTS ['+ I.name +'] ON ['+ SCHEMA_NAME(T.schema_id) +'].['+ T.name +'];' +
        CHAR(13) + CHAR(10) AS [DropIndex]
FROM    sys.indexes I INNER JOIN        
        sys.tables T ON  T.object_id = I.object_id INNER JOIN       
        sys.stats ST ON  ST.object_id = I.object_id AND ST.stats_id = I.index_id INNER JOIN 
        sys.data_spaces DS ON  I.data_space_id = DS.data_space_id INNER JOIN 
        sys.filegroups FG ON  I.data_space_id = FG.data_space_id LEFT OUTER JOIN 
        (SELECT * FROM 
            (SELECT IC2.object_id, IC2.index_id,
                STUFF((SELECT ', ' + C.name FROM sys.index_columns IC1 INNER JOIN 
                    sys.columns C ON C.object_id = IC1.object_id
                        AND C.column_id = IC1.column_id
                        AND IC1.is_included_column = 1
                    WHERE  IC1.object_id = IC2.object_id AND IC1.index_id = IC2.index_id
                    GROUP BY IC1.object_id, C.name, index_id  FOR XML PATH('')
                ), 1, 2, '') as IncludedColumns
            FROM sys.index_columns IC2
            GROUP BY IC2.object_id, IC2.index_id) tmp1
            WHERE IncludedColumns IS NOT NULL
        ) tmp2
        ON tmp2.object_id = I.object_id AND tmp2.index_id = I.index_id
WHERE I.is_primary_key = 0 AND I.is_unique_constraint = 0
and  I.name not in (
'IX_Equipe_Usuario_ID_Equipe'
,'IX_Campo_Tabela_Caminho_ID_TabelaOrigem'
,'IX_Campo_Vinculo_ID_CampoDestino'
,'IX_Usuario_ID_ClientePloomes'
,'IX_Campo_Language_FieldId_LanguageId'
,'IX_CampoFixo2_ClientePloomes_Formula_ID_Campo'
,'IX_CampoFixo2_Cultura_Account_AccountId'
,'IX_Cliente_Colaborador_Usuario_ID_Usuario'
,'IX_Campo_GoogleSheets_ID_Campo'
,'IX_Campo_Permissao_Equipe_ID_ClientePloomes'
,'IX_Campo_Permissao_Usuario_ID_ClientePloomes'
,'IX_Campo_Permissao_Exhibition_User_AccountId'
,'IX_Campo_Permissao_Exhibition_UserProfile_AccountId'
,'IX_Campo_Permissao_PerfilUsuario_ID_ClientePloomes'
,'IX_Campo_Permissao_Exhibition_Team_AccountId'
,'IX_Equipe_Usuario_ID_Usuario'
,'IX_CampoFixo2_ID_Tabela'
,'IX_Ploomes_Usuario_SupportUser_SupportUser_SupportUserId'
,'IX_Cotacao_ID_Oportunidade'
,'Usuario_IDM'
,'IX_Usuario_Cultura'
,'IX_Document_ContactId'
,'IX_Oportunidade_Client_Dt_Vlr')


-- Select * from BA_DBA.dbo.DROP_DBA_ESTRUTURA_INDEXDEPLOY
