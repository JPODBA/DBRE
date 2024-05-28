-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CREATE VIEW [dbo].[SVw_Campo_Valor] AS
SELECT CV.*, C.Chave as Chave_Campo,
		NULL as ValorObjeto,
		NULL as ImagemObjeto,
		U.ID as ID_UsuarioView,
		A.Arquivo as AttachmentValueName,
		Cli.Nome as  ContactValueName,Cli.ID_Tipo as ContactValueTypeId, 
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Cli.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', '') as ContactValueRegister,
		P.Descricao as ProductValueName,
		Usu.Nome as UserValueName,
		Usu.AvatarUrl as UserValueAvatarUrl,
		CTEV.Descricao as ObjectValueName,
		AI.Name as AttachmentItemValueName
FROM Campo_Valor                           CV 
LEFT JOIN Campo                            C ON CV.ID_Campo = C.ID
LEFT JOIN Anexo                            A ON A.ID = CV.AttachmentValueId
LEFT JOIN Cliente                        Cli ON Cli.ID = CV.ContactValueId
LEFT JOIN Produto                          P ON P.ID = CV.ID_Produto
LEFT JOIN Usuario                        Usu ON Usu.ID = CV.ID_UsuarioValor
LEFT JOIN Campo_TabelaEstrangeira_Valor CTEV ON CTEV.ID = CV.ID_OpcaoValor
LEFT JOIN Anexo_Item AI                      ON AI.Id = CV.AttachmentItemValueId
CROSS JOIN Usuario U


CREATE NONCLUSTERED Index IX_Campo_Valor_SVw_Campo_Valor_01 on Campo_Valor (ID_Campo, AttachmentValueId, ContactValueId, ID_Produto, ID_UsuarioValor, ID_OpcaoValor) on [INDEX]
