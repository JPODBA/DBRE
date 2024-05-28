--Text
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CREATE VIEW [dbo].[SVw_Usuario] AS

SELECT Usu.*, U.ID as ID_Usuario,
		CONVERT(BIT, IIF(Usu.ID = PC.ID_Criador, 1, 0)) as CriadorConta,
		CONVERT(BIT, IIF((U.ID_Perfil = 1 OR Usu.ID = U.ID) AND Usu.ID > 0 AND((Usu.IntegracaoNativa = 0 AND NOT EXISTS(SELECT TOP 1 1 FROM Ploomes_Usuario_SupportUser SU WHERE SU.SupportUserId = Usu.ID)) OR (EXISTS(SELECT TOP 1 1 FROM Ploomes_Usuario_SupportUser SU WHERE SU.SupportUserId = U.ID) AND EXISTS(SELECT TOP 1 1 FROM Ploomes_Usuario_SupportUser SU WHERE SU.SupportUserId = Usu.ID))), 1, 0)) as Edita,
		IIF(U.ID_Perfil = 1 AND Usu.Integracao = 'True' AND NOT EXISTS(SELECT TOP 1 1 FROM Ploomes_Usuario_SupportUser SU WHERE SU.SupportUserId = Usu.ID), Usu.Chave, NULL) as Chave2,
		--IIF(U.ID_Perfil = 1, CONVERT(DATETIME, '1900-01-01'), NULL) as UltimoLogin,
		CONVERT(DATETIME, NULL) as UltimoLogin,
		NULL as FreqUso,
		IIF(CONVERT(DATE,DATEADD(YEAR,(DATEDIFF(YEAR,Usu.Birthday,GETDATE())),Usu.Birthday)) >= CONVERT(DATE,GETDATE()),DATEADD(YEAR,(DATEDIFF(YEAR,Usu.Birthday,GETDATE()) - 1),Usu.Birthday),DATEADD(YEAR,(DATEDIFF(YEAR,Usu.Birthday,GETDATE())),Usu.Birthday) ) AS PreviousAnniversary,
		IIF(CONVERT(DATE,DATEADD(YEAR,(DATEDIFF(YEAR,Usu.Birthday,GETDATE())),Usu.Birthday)) >= CONVERT(DATE,GETDATE()),DATEADD(YEAR,(DATEDIFF(YEAR,Usu.Birthday,GETDATE())),Usu.Birthday),DATEADD(YEAR,(DATEDIFF(YEAR,Usu.Birthday,GETDATE()))+1,Usu.Birthday) ) AS NextAnniversary,
		ISNULL(Usu.DataAtualizacao, Usu.DataCriacao) as LastUpdateDate,
		CONVERT(BIT, 1) as SMTPAtivo
FROM Usuario Usu LEFT JOIN Ploomes_Cliente PC ON Usu.ID_ClientePloomes = PC.ID
--LEFT JOIN Usuario_Email_Integracao UEI ON Usu.ID = UEI.ID_Usuario
CROSS JOIN Usuario U


SELECT TOP 1 1 FROM Ploomes_Usuario_SupportUser SU WHERE SU.SupportUserId = 96
sp_helpindex 'Ploomes_Usuario_SupportUser'