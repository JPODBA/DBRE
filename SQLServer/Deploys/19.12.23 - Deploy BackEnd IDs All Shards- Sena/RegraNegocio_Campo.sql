use Ploomes_CRM
go
--drop table [RegraNegocio_Campo_Temp]
-- CRIAR UMA TABELA TEMPORÁRIA
CREATE TABLE [dbo].[RegraNegocio_Campo_Temp](
	[ID]            [int] IDENTITY(1,1) NOT NULL,
	[ID_Regra]      [int] NOT NULL,
	[ID_Campo]      [int] NOT NULL,
	[Fixo]          [bit] NOT NULL,
	[ID_Operador]   [int] NOT NULL,
	[Valor]         [sql_variant] NULL,
	[ValorTexto]    [nvarchar](100) COLLATE Latin1_General_CI_AI NULL,
	[ValorInteiro]  [int] NULL,
	[ValorDecimal]  [float] NULL,
	[ValorDataHora] [datetime] NULL,
	[ValorBooleano] [bit] NULL,
	[ID_Caminho]	[int] NULL,
 CONSTRAINT [PK_RegraNegocio_Campo_Temp] PRIMARY KEY CLUSTERED ([ID] ASC) ON [PRIMARY]
) ON [PRIMARY]
GO

-- SETAR IDENTITY PARA INSERIR OS NOVOS IDS
SET IDENTITY_INSERT [dbo].[RegraNegocio_Campo_Temp] ON
GO

-- INSERIR NOVOS IDS NA TABELA TEMP
INSERT INTO RegraNegocio_Campo_Temp (ID, ID_Regra, ID_Campo, Fixo, ID_Operador, Valor, ValorTexto, ValorInteiro, ValorDecimal, ValorDataHora, ValorBooleano, ID_Caminho)
SELECT ID + 400000, ID_Regra, ID_Campo, Fixo, ID_Operador, Valor, ValorTexto, ValorInteiro, ValorDecimal, ValorDataHora, ValorBooleano, ID_Caminho
FROM RegraNegocio_Campo

Declare @id int
SELECT @id = MAX(ID) + 1 FROM RegraNegocio_Campo_Temp

DBCC CHECKIDENT ('RegraNegocio_Campo_Temp', RESEED, @id)

-- VOLTAR O IDENTITY
SET IDENTITY_INSERT [dbo].[RegraNegocio_Campo_Temp] OFF
GO

Select * from [RegraNegocio_Campo_Temp] order by id desc
Select * from [RegraNegocio_Campo] order by id desc
Select * from [RegraNegocio_Campo_OLD] order by id desc


-- ATUALIZAR TODO MUNDO PARA APONTAR PARA O NOVO ID
UPDATE RegraNegocio_Campo_Value
SET BusinessRuleFieldId = BusinessRuleFieldId + 400000

-- RENOMEAR A TABELA ANTIGA PARA OLD E A NOVA PARA SER ORIGINAL
EXEC sp_rename 'dbo.RegraNegocio_Campo', 'RegraNegocio_Campo_Old'
EXEC sp_rename 'dbo.RegraNegocio_Campo_Temp', 'RegraNegocio_Campo'

-- RENOMEAR AS PKs PARA TEREM O NOME CORRETO
EXEC sp_rename 'dbo.PK_RegraNegocio_Campo', 'PK_RegraNegocio_Campo_Old', 'OBJECT'
EXEC sp_rename 'dbo.PK_RegraNegocio_Campo_Temp', 'PK_RegraNegocio_Campo', 'OBJECT'

EXEC sp_rename 'Tg_RegraNegocio_Campo_Insert', 'Tg_RegraNegocio_Campo_Insert_Old', 'OBJECT';
EXEC sp_rename 'RegraNegocio_Campo_OLD.IX_RegraNegocio_Campo_ID_Regra', 'IX_RegraNegocio_Campo_ID_Regra_Old', 'INDEX';


-- CRIAR INDEX E TRIGGER QUE EXISTEM NA TABELA ORIGINAL
CREATE NONCLUSTERED INDEX [IX_RegraNegocio_Campo_ID_Regra] ON [dbo].[RegraNegocio_Campo]
([ID_Regra] ASC
)WITH (FILLFACTOR = 100) ON [PRIMARY]
GO

CREATE TRIGGER [dbo].[Tg_RegraNegocio_Campo_Insert]
	ON [dbo].[RegraNegocio_Campo]
	AFTER INSERT
AS BEGIN
	BEGIN TRY
		UPDATE RegraNegocio_Campo
			SET ValorTexto = IIF(RNC.Valor IS NOT NULL AND ISNULL(C.ID_Tipo, CF.ID_Tipo) IN (1, 7, 9, 11, 12), TRY_CONVERT(NVARCHAR(100), RNC.Valor), RNC.ValorTexto),
				ValorInteiro = IIF(RNC.Valor IS NOT NULL AND ISNULL(C.ID_Tipo, CF.ID_Tipo) = 4, TRY_CONVERT(INT, RNC.Valor), RNC.ValorInteiro),
				ValorDecimal = IIF(RNC.Valor IS NOT NULL AND ISNULL(C.ID_Tipo, CF.ID_Tipo) IN (5, 6, 13, 14, 15 ,16), TRY_CONVERT(FLOAT, RNC.Valor), RNC.ValorDecimal),
				ValorDataHora = IIF(RNC.Valor IS NOT NULL AND ISNULL(C.ID_Tipo, CF.ID_Tipo) = 8, TRY_CONVERT(DATETIME, RNC.Valor), RNC.ValorDataHora),
				ValorBooleano = IIF(RNC.Valor IS NOT NULL AND ISNULL(C.ID_Tipo, CF.ID_Tipo) = 10, TRY_CONVERT(BIT, RNC.Valor), RNC.ValorBooleano)
			FROM RegraNegocio_Campo RNC LEFT JOIN Campo C ON RNC.ID_Campo = C.ID AND RNC.Fixo = 'False'
				LEFT JOIN CampoFixo2 CF ON RNC.ID_Campo = CF.ID AND RNC.Fixo = 'True'
				INNER JOIN inserted i ON RNC.ID = i.ID

		UPDATE RegraNegocio_Campo
			SET Valor = TRY_CONVERT(SQL_VARIANT, CASE
					WHEN RNC.ValorTexto IS NOT NULL AND RNC.Valor IS NULL THEN RNC.ValorTexto
					WHEN RNC.ValorInteiro IS NOT NULL AND RNC.Valor IS NULL THEN RNC.ValorInteiro
					WHEN RNC.ValorDecimal IS NOT NULL AND RNC.Valor IS NULL THEN RNC.ValorDecimal
					WHEN RNC.ValorDataHora IS NOT NULL AND RNC.Valor IS NULL THEN RNC.ValorDataHora
					WHEN RNC.ValorBooleano IS NOT NULL AND RNC.Valor IS NULL THEN RNC.ValorBooleano
					ELSE RNC.Valor
				END)
			FROM RegraNegocio_Campo RNC LEFT JOIN Campo C ON RNC.ID_Campo = C.ID AND RNC.Fixo = 'False'
				LEFT JOIN CampoFixo2 CF ON RNC.ID_Campo = CF.ID AND RNC.Fixo = 'True'
				INNER JOIN inserted i ON RNC.ID = i.ID
	END TRY
	BEGIN CATCH
	END CATCH
END
GO
ALTER TABLE [dbo].[RegraNegocio_Campo] ENABLE TRIGGER [Tg_RegraNegocio_Campo_Insert]
GO

-- CASO TUDO DÊ SUCESSO, SÓ DROPAR A ANTIGA
-- DROP TABLE RegraNegocio_Campo_Old