use Ploomes_CRM
GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SVw_Produto_List_Product] AS
    SELECT PLP.*, U.ID as ViewUserId
        FROM Produto_List_Product PLP 
            INNER JOIN Produto_List PL ON PL.Id = PLP.ListId AND PL.Suspended = 'False'
            INNER JOIN Produto P ON PLP.ProductId = P.ID AND P.Suspenso = 'False'
            INNER JOIN Usuario U ON U.ID_ClientePloomes = P.ID_ClientePloomes AND U.ID_ClientePloomes = PL.AccountId
GO