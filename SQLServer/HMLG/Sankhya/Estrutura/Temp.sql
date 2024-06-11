USE [Temp]
GO
/****** Object:  User [jackson.matsuura]    Script Date: 24/05/2024 16:11:56 ******/
CREATE USER [jackson.matsuura] FOR LOGIN [jackson.matsuura] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [tiago.rodrigues]    Script Date: 24/05/2024 16:11:56 ******/
CREATE USER [tiago.rodrigues] FOR LOGIN [tiago.rodrigues] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [jackson.matsuura]
GO
ALTER ROLE [db_datareader] ADD MEMBER [jackson.matsuura]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [jackson.matsuura]
GO
ALTER ROLE [db_datareader] ADD MEMBER [tiago.rodrigues]
GO
/****** Object:  Table [dbo].[Sankhya_Entities_to_Options]    Script Date: 24/05/2024 16:11:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sankhya_Entities_to_Options](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationId] [int] NOT NULL,
	[SankhyaEntityId] [int] NOT NULL,
	[CODIGO] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DESCRICAO] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXTRAINFO] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Sankhya_Entities_to_Options] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Sankhya_Field]    Script Date: 24/05/2024 16:11:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sankhya_Field](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationId] [int] NOT NULL,
	[SankhyaEntityId] [int] NOT NULL,
	[Key] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TypeId] [int] NOT NULL,
	[Name] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Multiple] [bit] NOT NULL,
	[ReadOnly] [bit] NOT NULL,
	[Required] [bit] NOT NULL,
	[Options] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsFake] [bit] NULL,
	[SankhyaType] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RequestId] [nvarchar](36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Sankhya_Field] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Sankhya_Grupo_Produto]    Script Date: 24/05/2024 16:11:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sankhya_Grupo_Produto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationId] [int] NOT NULL,
	[CODGRUPOPROD] [int] NOT NULL,
	[DESCRGRUPOPROD] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CODGRUPAI] [int] NOT NULL,
	[GruposBusca] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DESCGRUPAI] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Sankhya_Grupo_Produto] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Sankhya_TipoEndereco]    Script Date: 24/05/2024 16:11:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sankhya_TipoEndereco](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationId] [int] NOT NULL,
	[TIPO] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DESCRICAO] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Sankhya_TipoEndereco] TO  SCHEMA OWNER 
GO
ALTER TABLE [dbo].[Sankhya_Field] ADD  DEFAULT ((0)) FOR [Multiple]
GO
ALTER TABLE [dbo].[Sankhya_Field] ADD  DEFAULT ((0)) FOR [ReadOnly]
GO
ALTER TABLE [dbo].[Sankhya_Field] ADD  DEFAULT ((0)) FOR [Required]
GO
ALTER TABLE [dbo].[Sankhya_Field] ADD  CONSTRAINT [DEFAULT_INTEGRATION_SANKHYATYPE]  DEFAULT ('X') FOR [SankhyaType]
GO
/****** Object:  StoredProcedure [dbo].[AddAndModifyMetadata]    Script Date: 24/05/2024 16:11:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddAndModifyMetadata]
  @integrationId INT

AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY
      --Create Additional Sankhya Fields
	  INSERT INTO [Sankhya_Field]
	    ([IntegrationId],[SankhyaEntityId],[Key],[Name],[TypeId],[ReadOnly],[Multiple],[Required],[Options],[IsFake],[SankhyaType])
		VALUES
            (@integrationId, 54024, 'CODVEND',			'Código (Vendedor)',						4 ,1,0,0, NULL, NULL, 'R') --'I'
            ,(@integrationId, 54024, 'APELIDO',			'Apelido',									1 ,1,0,1,NULL,NULL,'R')--'S'
            ,(@integrationId, 54024, 'EMAIL',			'E-mail',									1 ,1,0,0,NULL,NULL,'R') --'S'
            ,(@integrationId, 54011, 'CODGRUPOPROD',	'Código (Grupo Produto)',					4 ,1,0,0,NULL,NULL,'R') --'I'
            ,(@integrationId, 54011, 'DESCRGRUPOPROD',	'Código e Descrição (Grupo Produto)',		1 ,1,0,1,NULL,NULL,'R') --'S'
            ,(@integrationId, 54011, 'CODGRUPAI',		'Código e Descrição (Grupo Produto Pai)',	1 ,1,0,0,NULL,NULL,'R') --'S'
			,(@integrationId, 54011, 'GruposBusca',		'Hierarquia de Grupos',						7 ,1,1,0,null,1,'K')
            ,(@integrationId, 54001, 'TipoPloomes',		'Parceiro ou Contato',						7 ,0,0,1,'{"P": "Parceiro Pessoa Física", "C": "Contato de Cliente" }',1,'K')
            ,(@integrationId, 54101, 'TipoPloomes',		'Parceiro ou Contato',						7 ,0,0,1,'{"P": "Parceiro Pessoa Física", "C": "Contato de Cliente" }',1,'K')
            ,(@integrationId, 54004, 'DevFinanceiro',	'Consulta de financeiro',					22,1,0,0,NULL,1,'K')
            ,(@integrationId, 54004, 'DevRestricoes',	'Consulta de restrições',					22,1,0,0,NULL,1,'K')
            ,(@integrationId, 54204, 'TotalBloco',		'Cálculo total bloco',						5 ,1,0,0,NULL,1,'K')			
			,(@integrationId, 54020, 'DevEstoque',		'Consulta de estoque',						22,1,0,0,NULL,1,'K')
            ,(@integrationId, 54020, 'DevUnidade',		'Consulta de unidade',						22,1,0,0,NULL,1,'K')
            ,(@integrationId, 54020, 'DevControle',		'Consulta de controle',						22,1,0,0,NULL,1,'K')
            ,(@integrationId, 54020, 'DevValorUnitario', 'Consulta de valor unitário',				22,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'ValorUnitario',	'Consulta de valor unitário',				5 ,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'DevImpostos',		'Consulta de impostos',						22,1,0,0,NULL,1,'K')            
            ,(@integrationId, 54020, 'IcmsAliq',		'Consulta Alíq. ICMS',						13,1,0,0,NULL,1,'K')
            ,(@integrationId, 54020, 'IcmsValor',		'Consulta Valor ICSM',						5 ,1,0,0,NULL,1,'K')
            ,(@integrationId, 54020, 'IpiAliq',			'Consulta Alíq. IPI',						13,1,0,0,NULL,1,'K')
            ,(@integrationId, 54020, 'IpiValor',		'Consulta Valor IPI',						5 ,1,0,0,NULL,1,'K')
            ,(@integrationId, 54020, 'DevProdIntegrado', 'Consulta integração produto',				22,1,0,0,NULL,1,'K')
            ,(@integrationId, 54020, 'ProdIntegrado',	'Consulta integração produto',				10,1,0,0,NULL,1,'K')
            ,(@integrationId, 54020, 'TotalProduto',	'Cálculo total produto',					5 ,0,0,0,NULL,1,'K')
		--Update Some Sankhya Fields
		UPDATE [Sankhya_Field] SET [Name] = 'Tipo e Nome (Endereço)'														WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54001 AND [Key] = 'CODEND'
		UPDATE [Sankhya_Field] SET [Name] = 'Nome (Bairro)'																	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54001 AND [Key] = 'CODBAI'
		UPDATE [Sankhya_Field] SET [Name] = 'Nome e Estado (Cidade)'														WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54001 AND [Key] = 'CODCID'
		UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Centro Resultado)',						[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODCENCUS'
		UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Empresa)',				[Required] = 1,		[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODEMP'
		UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Natureza)',								[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODNAT'
		UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Tipo Operação)',		[Required] = 1,		[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODTIPOPER'
		UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Tipo Negociação)',		[Required] = 1,		[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODTIPVENDA'
        UPDATE [Sankhya_Field] SET														[Required] = 1						WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODPARC'
        UPDATE [Sankhya_Field] SET														[Required] = 1						WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'DTNEG'
        UPDATE [Sankhya_Field] SET																			[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODPARCTRANSP'
        UPDATE [Sankhya_Field] SET																			[TypeId] = 5	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'VLRNOTA'
        UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Grupo Produto)'											WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54010 AND [Key] = 'CODGRUPOPROD'
        UPDATE [Sankhya_Field] SET [Name] = 'Marca ou Descrição (Marca)'													WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54010 AND [Key] = 'MARCA'
        UPDATE [Sankhya_Field] SET																			[TypeId] = 1	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54010 AND [Key] = 'CODPROD'
        UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Empresa)'													WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CODEMP'
        UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Local)',									[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CODLOCALORIG'
        UPDATE [Sankhya_Field] SET																			[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CONTROLE'
        UPDATE [Sankhya_Field] SET																			[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CODVOL'
        UPDATE [Sankhya_Field] SET [Name] = 'Tipo e Nome (Endereço)'														WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODEND'
        UPDATE [Sankhya_Field] SET [Name] = 'Nome (Bairro)'																	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODBAI'
        UPDATE [Sankhya_Field] SET [Name] = 'Nome e Estado (Cidade)'														WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODCID'
        UPDATE [Sankhya_Field] SET [Name] = 'Cód. Contato'																	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODCONTATO'
      COMMIT TRANSACTION	
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
 	  THROW
    END CATCH
END;
GO
ALTER AUTHORIZATION ON [dbo].[AddAndModifyMetadata] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[RefreshMetadata]    Script Date: 24/05/2024 16:11:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RefreshMetadata]
  @integrationId INT,
  @sankhyaEntityId INT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY	  
	  --Delete Old metadata and change the [IntegrationId] of the new Metadada
	  DELETE FROM [Temp].[dbo].[Sankhya_Field] WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = @sankhyaEntityId
	  UPDATE [Temp].[dbo].[Sankhya_Field] SET [IntegrationId] = @integrationId WHERE [IntegrationId] = -@integrationId AND [SankhyaEntityId] = @sankhyaEntityId;

	  IF (@sankhyaEntityId = 54001) -- Add and Update Metadata of Parceiro, Contato, Produto and Nota
		BEGIN -- Parceiro
		  INSERT INTO [Sankhya_Field] -- Additional Parceiro Fields
			([IntegrationId],[SankhyaEntityId],[Key],[Name],[TypeId],[ReadOnly],[Multiple],[Required],[Options],[IsFake],[SankhyaType])
		  VALUES
			(@integrationId, 54001, 'TipoPloomes', 'Parceiro ou Contato', 7 ,0,0,1,'{"P": "Parceiro Pessoa Física", "C": "Contato de Cliente" }',1,'K')
		  UPDATE [Sankhya_Field] SET [Name] = 'Tipo e Nome (Endereço)'	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54001 AND [Key] = 'CODEND';
		  UPDATE [Sankhya_Field] SET [Name] = 'Nome (Bairro)'			WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54001 AND [Key] = 'CODBAI';
		  UPDATE [Sankhya_Field] SET [Name] = 'Nome e Estado (Cidade)'	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54001 AND [Key] = 'CODCID';		  
		END 
	  ELSE IF (@sankhyaEntityId = 54101) -- Contato, Produto and Nota
        BEGIN -- Contato
		  INSERT INTO [Sankhya_Field] -- Additional Contato Fields
			([IntegrationId],[SankhyaEntityId],[Key],[Name],[TypeId],[ReadOnly],[Multiple],[Required],[Options],[IsFake],[SankhyaType])
		  VALUES
			(@integrationId, 54101, 'TipoPloomes', 'Parceiro ou Contato', 7 ,0,0,1,'{"P": "Parceiro Pessoa Física", "C": "Contato de Cliente" }',1,'K');
		  UPDATE [Sankhya_Field] SET [Name] = 'Tipo e Nome (Endereço)'	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODEND'
		  UPDATE [Sankhya_Field] SET [Name] = 'Nome (Bairro)'			WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODBAI'
		  UPDATE [Sankhya_Field] SET [Name] = 'Nome e Estado (Cidade)'	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODCID'
		  UPDATE [Sankhya_Field] SET [Name] = 'Cód. Contato'			WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODCONTATO'
        END
      ELSE IF (@sankhyaEntityId = 54010) -- Produto and Nota
        BEGIN -- Produto
		  UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Grupo Produto)' WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54010 AND [Key] = 'CODGRUPOPROD'
		  UPDATE [Sankhya_Field] SET [Name] = 'Marca ou Descrição (Marca)'		   WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54010 AND [Key] = 'MARCA'
		  UPDATE [Sankhya_Field] SET								[TypeId] = 1   WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54010 AND [Key] = 'CODPROD'
        END  
	  ELSE IF (@sankhyaEntityId = 54004) --Cabecalho and Item Nota
        BEGIN -- CabecalhoNota
		  INSERT INTO [Sankhya_Field] -- Additional CabecalhoNota Fields
			([IntegrationId],[SankhyaEntityId],[Key],[Name],[TypeId],[ReadOnly],[Multiple],[Required],[Options],[IsFake],[SankhyaType])
		  VALUES
			 (@integrationId, 54004, 'DevFinanceiro', 'Consulta de financeiro',	22,1,0,0,NULL,1,'K')
			,(@integrationId, 54004, 'DevRestricoes', 'Consulta de restrições',	22,1,0,0,NULL,1,'K')
		  UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Centro Resultado)',					[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODCENCUS'
		  UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Empresa)',		  [Required] = 1,	[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODEMP'
		  UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Natureza)',							[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODNAT'
		  UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Tipo Operação)',	  [Required] = 1,	[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODTIPOPER'
		  UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Tipo Negociação)', [Required] = 1,	[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODTIPVENDA'
		  UPDATE [Sankhya_Field] SET												  [Required] = 1					WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODPARC'
		  UPDATE [Sankhya_Field] SET												  [Required] = 1					WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'DTNEG'
		  UPDATE [Sankhya_Field] SET																	[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODPARCTRANSP'
		  UPDATE [Sankhya_Field] SET																	[TypeId] = 5	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'VLRNOTA'
        END
	  ELSE IF (@sankhyaEntityId = 54020) --Last ItemNota
		BEGIN --ItemNota
		  INSERT INTO [Sankhya_Field] -- Additional ItemNota Fields
			([IntegrationId],[SankhyaEntityId],[Key],[Name],[TypeId],[ReadOnly],[Multiple],[Required],[Options],[IsFake],[SankhyaType])
		  VALUES
			 (@integrationId, 54020, 'DevEstoque',		'Consulta de estoque',			22,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'DevUnidade',		'Consulta de unidade',			22,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'DevControle',		'Consulta de controle',			22,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'DevValorUnitario', 'Consulta de valor unitário',	22,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'ValorUnitario',	'Consulta de valor unitário',	5 ,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'DevImpostos',		'Consulta de impostos',			22,1,0,0,NULL,1,'K')            
			,(@integrationId, 54020, 'IcmsAliq',		'Consulta Alíq. ICMS',			13,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'IcmsValor',		'Consulta Valor ICSM',			5 ,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'IpiAliq',			'Consulta Alíq. IPI',			13,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'IpiValor',		'Consulta Valor IPI',			5 ,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'DevProdIntegrado', 'Consulta integração produto',	22,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'ProdIntegrado',	'Consulta integração produto',	10,1,0,0,NULL,1,'K')
			,(@integrationId, 54020, 'TotalProduto',	'Cálculo total produto',		5 ,0,0,0,NULL,1,'K')		
		  UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Empresa)'				WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CODEMP'
		  UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Local)', [TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CODLOCALORIG'
		  UPDATE [Sankhya_Field] SET										[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CONTROLE'
		  UPDATE [Sankhya_Field] SET										[TypeId] = 7	WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CODVOL'
		END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
	  THROW
    END CATCH
END;
GO
ALTER AUTHORIZATION ON [dbo].[RefreshMetadata] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[RefreshMetadata1]    Script Date: 24/05/2024 16:11:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[RefreshMetadata1]
  @integrationId INT,    
  @sankhyaEntityId INT,  
  @requestId nvarchar(36)  
AS    
BEGIN    
  SET NOCOUNT ON;    
  BEGIN TRAN    
    BEGIN TRY       
   --Delete Old metadata and change the [IntegrationId] of the new Metadada    
   DELETE FROM [Temp].[dbo].[Sankhya_Field] WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = @sankhyaEntityId    
   UPDATE [Temp].[dbo].[Sankhya_Field] SET [IntegrationId] = @integrationId WHERE [IntegrationId] = -@integrationId AND [SankhyaEntityId] = @sankhyaEntityId and [RequestId] = @requestId;    

   IF (@sankhyaEntityId = 54001) -- Add and Update Metadata of Parceiro, Contato, Produto and Nota    
  BEGIN -- Parceiro    
    INSERT INTO [Sankhya_Field] -- Additional Parceiro Fields    
   ([IntegrationId],[SankhyaEntityId],[Key],[Name],[TypeId],[ReadOnly],[Multiple],[Required],[Options],[IsFake],[SankhyaType])    
    VALUES    
   (@integrationId, 54001, 'TipoPloomes', 'Parceiro ou Contato', 7 ,0,0,1,'{"P": "Parceiro Pessoa Física", "C": "Contato de Cliente" }',1,'K')    
    UPDATE [Sankhya_Field] SET [Name] = 'Tipo e Nome (Endereço)' WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54001 AND [Key] = 'CODEND' and [RequestId] = @requestId;    
    UPDATE [Sankhya_Field] SET [Name] = 'Nome (Bairro)'   WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54001 AND [Key] = 'CODBAI' and [RequestId] = @requestId;    
    UPDATE [Sankhya_Field] SET [Name] = 'Nome e Estado (Cidade)' WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54001 AND [Key] = 'CODCID' and [RequestId] = @requestId;        
  END     
   ELSE IF (@sankhyaEntityId = 54101) -- Contato, Produto and Nota    
        BEGIN -- Contato    
    INSERT INTO [Sankhya_Field] -- Additional Contato Fields    
   ([IntegrationId],[SankhyaEntityId],[Key],[Name],[TypeId],[ReadOnly],[Multiple],[Required],[Options],[IsFake],[SankhyaType])    
    VALUES    
   (@integrationId, 54101, 'TipoPloomes', 'Parceiro ou Contato', 7 ,0,0,1,'{"P": "Parceiro Pessoa Física", "C": "Contato de Cliente" }',1,'K');    
    UPDATE [Sankhya_Field] SET [Name] = 'Tipo e Nome (Endereço)' WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODEND' and [RequestId] = @requestId  
    UPDATE [Sankhya_Field] SET [Name] = 'Nome (Bairro)'   WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODBAI' and [RequestId] = @requestId  
    UPDATE [Sankhya_Field] SET [Name] = 'Nome e Estado (Cidade)' WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODCID' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [Name] = 'Cód. Contato'   WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54101 AND [Key] = 'CODCONTATO' and [RequestId] = @requestId    
        END    
      ELSE IF (@sankhyaEntityId = 54010) -- Produto and Nota    
        BEGIN -- Produto    
    UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Grupo Produto)' WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54010 AND [Key] = 'CODGRUPOPROD' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [Name] = 'Marca ou Descrição (Marca)'     WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54010 AND [Key] = 'MARCA' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET        [TypeId] = 1   WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54010 AND [Key] = 'CODPROD' and [RequestId] = @requestId    
        END      
   ELSE IF (@sankhyaEntityId = 54004) --Cabecalho and Item Nota    
        BEGIN -- CabecalhoNota    
    INSERT INTO [Sankhya_Field] -- Additional CabecalhoNota Fields    
   ([IntegrationId],[SankhyaEntityId],[Key],[Name],[TypeId],[ReadOnly],[Multiple],[Required],[Options],[IsFake],[SankhyaType])    
    VALUES    
    (@integrationId, 54004, 'DevFinanceiro', 'Consulta de financeiro', 22,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54004, 'DevRestricoes', 'Consulta de restrições', 22,1,0,0,NULL,1,'K')    
    UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Centro Resultado)',     [TypeId] = 7 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODCENCUS' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Empresa)',    [Required] = 1, [TypeId] = 7 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODEMP' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Natureza)',       [TypeId] = 7 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODNAT' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Tipo Operação)',   [Required] = 1, [TypeId] = 7 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODTIPOPER' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Tipo Negociação)', [Required] = 1, [TypeId] = 7 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODTIPVENDA' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [Required] = 1 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODPARC' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [Required] = 1 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'DTNEG' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [TypeId] = 7 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'CODPARCTRANSP' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [TypeId] = 5 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54004 AND [Key] = 'VLRNOTA' and [RequestId] = @requestId    
        END    
   ELSE IF (@sankhyaEntityId = 54020) --Last ItemNota    
  BEGIN --ItemNota    
    INSERT INTO [Sankhya_Field] -- Additional ItemNota Fields    
   ([IntegrationId],[SankhyaEntityId],[Key],[Name],[TypeId],[ReadOnly],[Multiple],[Required],[Options],[IsFake],[SankhyaType])    
    VALUES    
    (@integrationId, 54020, 'DevEstoque',  'Consulta de estoque',   22,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'DevUnidade',  'Consulta de unidade',   22,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'DevControle',  'Consulta de controle',   22,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'DevValorUnitario', 'Consulta de valor unitário', 22,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'ValorUnitario', 'Consulta de valor unitário', 5 ,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'DevImpostos',  'Consulta de impostos',   22,1,0,0,NULL,1,'K')                
   ,(@integrationId, 54020, 'IcmsAliq',  'Consulta Alíq. ICMS',   13,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'IcmsValor',  'Consulta Valor ICSM',   5 ,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'IpiAliq',   'Consulta Alíq. IPI',   13,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'IpiValor',  'Consulta Valor IPI',   5 ,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'DevProdIntegrado', 'Consulta integração produto', 22,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'ProdIntegrado', 'Consulta integração produto', 10,1,0,0,NULL,1,'K')    
   ,(@integrationId, 54020, 'TotalProduto', 'Cálculo total produto',  5 ,0,0,0,NULL,1,'K')      
    UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Empresa)'    WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CODEMP' and [RequestId] = @requestId    
    UPDATE [Sankhya_Field] SET [Name] = 'Código e Descrição (Local)', [TypeId] = 7 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CODLOCALORIG' and [RequestId] = @requestId   
    UPDATE [Sankhya_Field] SET          [TypeId] = 7 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CONTROLE' and [RequestId] = @requestId   
    UPDATE [Sankhya_Field] SET          [TypeId] = 7 WHERE [IntegrationId] = @integrationId AND [SankhyaEntityId] = 54020 AND [Key] = 'CODVOL' and [RequestId] = @requestId  
  END    
      COMMIT TRANSACTION    
    END TRY    
    BEGIN CATCH       
      ROLLBACK TRANSACTION    
   THROW    
    END CATCH    
END;  
GO
ALTER AUTHORIZATION ON [dbo].[RefreshMetadata1] TO  SCHEMA OWNER 
GO
