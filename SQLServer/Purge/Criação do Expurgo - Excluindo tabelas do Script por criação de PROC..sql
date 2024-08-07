


PRINT 'Running accountId 1 and table [Usuario_Notificacao]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempUsuario_Notificacao

                            CREATE TABLE #TempUsuario_Notificacao
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempUsuario_Notificacao (Id)
                            SELECT  [UN].Id
                            FROM [Usuario_Notificacao] UN INNER JOIN [Usuario] U ON UN.[ID_Usuario] = U.[ID]
                            WHERE [U].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempUsuario_NotificacaoDel
                            CREATE TABLE #TempUsuario_NotificacaoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempUsuario_Notificacao))
                            BEGIN
                                TRUNCATE TABLE #TempUsuario_NotificacaoDel

                                INSERT #TempUsuario_NotificacaoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempUsuario_Notificacao
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempUsuario_NotificacaoDel
                                DELETE UN
                                FROM [Usuario_Notificacao] UN INNER JOIN #TempUsuario_NotificacaoDel TempUsuario_NotificacaoDel ON [UN].ID = TempUsuario_NotificacaoDel.Id
                                WHERE [UN].ID >= @MinId AND [UN].ID <= @MaxId
                                        
                                DELETE #TempUsuario_Notificacao
                                FROM #TempUsuario_Notificacao TempUsuario_Notificacao INNER JOIN #TempUsuario_NotificacaoDel TempUsuario_NotificacaoDel ON TempUsuario_Notificacao.ID = TempUsuario_NotificacaoDel.Id
                            END
                            DROP TABLE #TempUsuario_Notificacao
                            DROP TABLE #TempUsuario_NotificacaoDel
                            GO
PRINT 'Running accountId 1 and table [Produto_Grupo_Permissao_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_Grupo_Permissao_Usuario

                            CREATE TABLE #TempProduto_Grupo_Permissao_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_Grupo_Permissao_Usuario (Id)
                            SELECT  [PU].Id
                            FROM [Produto_Grupo_Permissao_Usuario] PU INNER JOIN [Usuario] U ON PU.[ID_Usuario] = U.[ID]
                            WHERE [U].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_Grupo_Permissao_UsuarioDel
                            CREATE TABLE #TempProduto_Grupo_Permissao_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_Grupo_Permissao_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_Grupo_Permissao_UsuarioDel

                                INSERT #TempProduto_Grupo_Permissao_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_Grupo_Permissao_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_Grupo_Permissao_UsuarioDel
                                DELETE PU
                                FROM [Produto_Grupo_Permissao_Usuario] PU INNER JOIN #TempProduto_Grupo_Permissao_UsuarioDel TempProduto_Grupo_Permissao_UsuarioDel ON [PU].ID = TempProduto_Grupo_Permissao_UsuarioDel.Id
                                WHERE [PU].ID >= @MinId AND [PU].ID <= @MaxId
                                        
                                DELETE #TempProduto_Grupo_Permissao_Usuario
                                FROM #TempProduto_Grupo_Permissao_Usuario TempProduto_Grupo_Permissao_Usuario INNER JOIN #TempProduto_Grupo_Permissao_UsuarioDel TempProduto_Grupo_Permissao_UsuarioDel ON TempProduto_Grupo_Permissao_Usuario.ID = TempProduto_Grupo_Permissao_UsuarioDel.Id
                            END
                            DROP TABLE #TempProduto_Grupo_Permissao_Usuario
                            DROP TABLE #TempProduto_Grupo_Permissao_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Permission_User]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPermission_User

                            CREATE TABLE #TempPermission_User
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPermission_User (Id)
                            SELECT  [PU].Id
                            FROM [Permission_User] PU INNER JOIN [Usuario] U ON Pu.[UserId] = U.[ID]
                            WHERE [U].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPermission_UserDel
                            CREATE TABLE #TempPermission_UserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPermission_User))
                            BEGIN
                                TRUNCATE TABLE #TempPermission_UserDel

                                INSERT #TempPermission_UserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPermission_User
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPermission_UserDel
                                DELETE PU
                                FROM [Permission_User] PU INNER JOIN #TempPermission_UserDel TempPermission_UserDel ON [PU].ID = TempPermission_UserDel.Id
                                WHERE [PU].ID >= @MinId AND [PU].ID <= @MaxId
                                        
                                DELETE #TempPermission_User
                                FROM #TempPermission_User TempPermission_User INNER JOIN #TempPermission_UserDel TempPermission_UserDel ON TempPermission_User.ID = TempPermission_UserDel.Id
                            END
                            DROP TABLE #TempPermission_User
                            DROP TABLE #TempPermission_UserDel
                            GO
PRINT 'Running accountId 1 and table [Informe_Permissao]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempInforme_Permissao

                            CREATE TABLE #TempInforme_Permissao
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempInforme_Permissao (Id)
                            SELECT  [P].Id
                            FROM [Informe_Permissao] P INNER JOIN [Usuario] U ON P.[ID_Usuario] = U.[ID]
                            WHERE [U].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempInforme_PermissaoDel
                            CREATE TABLE #TempInforme_PermissaoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempInforme_Permissao))
                            BEGIN
                                TRUNCATE TABLE #TempInforme_PermissaoDel

                                INSERT #TempInforme_PermissaoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempInforme_Permissao
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempInforme_PermissaoDel
                                DELETE P
                                FROM [Informe_Permissao] P INNER JOIN #TempInforme_PermissaoDel TempInforme_PermissaoDel ON [P].ID = TempInforme_PermissaoDel.Id
                                WHERE [P].ID >= @MinId AND [P].ID <= @MaxId
                                        
                                DELETE #TempInforme_Permissao
                                FROM #TempInforme_Permissao TempInforme_Permissao INNER JOIN #TempInforme_PermissaoDel TempInforme_PermissaoDel ON TempInforme_Permissao.ID = TempInforme_PermissaoDel.Id
                            END
                            DROP TABLE #TempInforme_Permissao
                            DROP TABLE #TempInforme_PermissaoDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Colaborador_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Colaborador_Usuario

                            CREATE TABLE #TempOportunidade_Colaborador_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Colaborador_Usuario (Id)
                            SELECT  [OCU].Id
                            FROM [Oportunidade_Colaborador_Usuario] OCU INNER JOIN [Usuario] U ON OCU.[ID_Usuario] = U.[ID]
                            WHERE [U].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_Colaborador_UsuarioDel
                            CREATE TABLE #TempOportunidade_Colaborador_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Colaborador_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_Colaborador_UsuarioDel

                                INSERT #TempOportunidade_Colaborador_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Colaborador_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_Colaborador_UsuarioDel
                                DELETE OCU
                                FROM [Oportunidade_Colaborador_Usuario] OCU INNER JOIN #TempOportunidade_Colaborador_UsuarioDel TempOportunidade_Colaborador_UsuarioDel ON [OCU].ID = TempOportunidade_Colaborador_UsuarioDel.Id
                                WHERE [OCU].ID >= @MinId AND [OCU].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Colaborador_Usuario
                                FROM #TempOportunidade_Colaborador_Usuario TempOportunidade_Colaborador_Usuario INNER JOIN #TempOportunidade_Colaborador_UsuarioDel TempOportunidade_Colaborador_UsuarioDel ON TempOportunidade_Colaborador_Usuario.ID = TempOportunidade_Colaborador_UsuarioDel.Id
                            END
                            DROP TABLE #TempOportunidade_Colaborador_Usuario
                            DROP TABLE #TempOportunidade_Colaborador_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [ComentarioExterno]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempComentarioExterno

                            CREATE TABLE #TempComentarioExterno
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempComentarioExterno (Id)
                            SELECT  [CE].Id
                            FROM [ComentarioExterno] CE INNER JOIN [Usuario] U ON CE.[ID_Criador] = U.[ID]
                            WHERE [U].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempComentarioExternoDel
                            CREATE TABLE #TempComentarioExternoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempComentarioExterno))
                            BEGIN
                                TRUNCATE TABLE #TempComentarioExternoDel

                                INSERT #TempComentarioExternoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempComentarioExterno
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempComentarioExternoDel
                                DELETE CE
                                FROM [ComentarioExterno] CE INNER JOIN #TempComentarioExternoDel TempComentarioExternoDel ON [CE].ID = TempComentarioExternoDel.Id
                                WHERE [CE].ID >= @MinId AND [CE].ID <= @MaxId
                                        
                                DELETE #TempComentarioExterno
                                FROM #TempComentarioExterno TempComentarioExterno INNER JOIN #TempComentarioExternoDel TempComentarioExternoDel ON TempComentarioExterno.ID = TempComentarioExternoDel.Id
                            END
                            DROP TABLE #TempComentarioExterno
                            DROP TABLE #TempComentarioExternoDel
                            GO
PRINT 'Running accountId 1 and table [Comentario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempComentario

                            CREATE TABLE #TempComentario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempComentario (Id)
                            SELECT  [C].Id
                            FROM [Comentario] C INNER JOIN  [Usuario] U ON C.ID_Criador = U.ID
                            WHERE [U].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempComentarioDel
                            CREATE TABLE #TempComentarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempComentario))
                            BEGIN
                                TRUNCATE TABLE #TempComentarioDel

                                INSERT #TempComentarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempComentario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempComentarioDel
                                DELETE C
                                FROM [Comentario] C INNER JOIN #TempComentarioDel TempComentarioDel ON [C].ID = TempComentarioDel.Id
                                WHERE [C].ID >= @MinId AND [C].ID <= @MaxId
                                        
                                DELETE #TempComentario
                                FROM #TempComentario TempComentario INNER JOIN #TempComentarioDel TempComentarioDel ON TempComentario.ID = TempComentarioDel.Id
                            END
                            DROP TABLE #TempComentario
                            DROP TABLE #TempComentarioDel
                            GO
PRINT 'Running accountId 1 and table [Chat_User]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempChat_User

                            CREATE TABLE #TempChat_User
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempChat_User (Id)
                            SELECT  [C].Id
                            FROM [Chat_User] C INNER JOIN [Usuario] U ON C.[UserId] = U.[ID]
                            WHERE [U].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempChat_UserDel
                            CREATE TABLE #TempChat_UserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempChat_User))
                            BEGIN
                                TRUNCATE TABLE #TempChat_UserDel

                                INSERT #TempChat_UserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempChat_User
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempChat_UserDel
                                DELETE C
                                FROM [Chat_User] C INNER JOIN #TempChat_UserDel TempChat_UserDel ON [C].ID = TempChat_UserDel.Id
                                WHERE [C].ID >= @MinId AND [C].ID <= @MaxId
                                        
                                DELETE #TempChat_User
                                FROM #TempChat_User TempChat_User INNER JOIN #TempChat_UserDel TempChat_UserDel ON TempChat_User.ID = TempChat_UserDel.Id
                            END
                            DROP TABLE #TempChat_User
                            DROP TABLE #TempChat_UserDel
                            GO
PRINT 'Running accountId 1 and table [RegraNegocio_Aprovacao_Nivel_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempRegraNegocio_Aprovacao_Nivel_Usuario

                            CREATE TABLE #TempRegraNegocio_Aprovacao_Nivel_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempRegraNegocio_Aprovacao_Nivel_Usuario (Id)
                            SELECT  [RANU].Id
                            FROM [RegraNegocio_Aprovacao_Nivel_Usuario] RANU INNER JOIN [Usuario] U ON RANU.[ID_Usuario] = U.[ID]
                            WHERE [U].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempRegraNegocio_Aprovacao_Nivel_UsuarioDel
                            CREATE TABLE #TempRegraNegocio_Aprovacao_Nivel_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempRegraNegocio_Aprovacao_Nivel_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempRegraNegocio_Aprovacao_Nivel_UsuarioDel

                                INSERT #TempRegraNegocio_Aprovacao_Nivel_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempRegraNegocio_Aprovacao_Nivel_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempRegraNegocio_Aprovacao_Nivel_UsuarioDel
                                DELETE RANU
                                FROM [RegraNegocio_Aprovacao_Nivel_Usuario] RANU INNER JOIN #TempRegraNegocio_Aprovacao_Nivel_UsuarioDel TempRegraNegocio_Aprovacao_Nivel_UsuarioDel ON [RANU].ID = TempRegraNegocio_Aprovacao_Nivel_UsuarioDel.Id
                                WHERE [RANU].ID >= @MinId AND [RANU].ID <= @MaxId
                                        
                                DELETE #TempRegraNegocio_Aprovacao_Nivel_Usuario
                                FROM #TempRegraNegocio_Aprovacao_Nivel_Usuario TempRegraNegocio_Aprovacao_Nivel_Usuario INNER JOIN #TempRegraNegocio_Aprovacao_Nivel_UsuarioDel TempRegraNegocio_Aprovacao_Nivel_UsuarioDel ON TempRegraNegocio_Aprovacao_Nivel_Usuario.ID = TempRegraNegocio_Aprovacao_Nivel_UsuarioDel.Id
                            END
                            DROP TABLE #TempRegraNegocio_Aprovacao_Nivel_Usuario
                            DROP TABLE #TempRegraNegocio_Aprovacao_Nivel_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [BulkProcedure]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempBulkProcedure

                            CREATE TABLE #TempBulkProcedure
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempBulkProcedure (Id)
                            SELECT  [B].Id
                            FROM [BulkProcedure] B INNER JOIN [Usuario] U ON B.[CreatorId] = U.[ID]
                            WHERE [U].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempBulkProcedureDel
                            CREATE TABLE #TempBulkProcedureDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempBulkProcedure))
                            BEGIN
                                TRUNCATE TABLE #TempBulkProcedureDel

                                INSERT #TempBulkProcedureDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempBulkProcedure
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempBulkProcedureDel
                                DELETE B
                                FROM [BulkProcedure] B INNER JOIN #TempBulkProcedureDel TempBulkProcedureDel ON [B].ID = TempBulkProcedureDel.Id
                                WHERE [B].ID >= @MinId AND [B].ID <= @MaxId
                                        
                                DELETE #TempBulkProcedure
                                FROM #TempBulkProcedure TempBulkProcedure INNER JOIN #TempBulkProcedureDel TempBulkProcedureDel ON TempBulkProcedure.ID = TempBulkProcedureDel.Id
                            END
                            DROP TABLE #TempBulkProcedure
                            DROP TABLE #TempBulkProcedureDel
                            GO
PRINT 'Running accountId 1 and table [Anexo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo

                            CREATE TABLE #TempAnexo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo (Id)
                            SELECT  [A].Id
                            FROM [Anexo] A INNER JOIN [Usuario] U ON A.[ID_Criador] = U.[ID]
                            WHERE [U].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexoDel
                            CREATE TABLE #TempAnexoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo))
                            BEGIN
                                TRUNCATE TABLE #TempAnexoDel

                                INSERT #TempAnexoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexoDel
                                DELETE A
                                FROM [Anexo] A INNER JOIN #TempAnexoDel TempAnexoDel ON [A].ID = TempAnexoDel.Id
                                WHERE [A].ID >= @MinId AND [A].ID <= @MaxId
                                        
                                DELETE #TempAnexo
                                FROM #TempAnexo TempAnexo INNER JOIN #TempAnexoDel TempAnexoDel ON TempAnexo.ID = TempAnexoDel.Id
                            END
                            DROP TABLE #TempAnexo
                            DROP TABLE #TempAnexoDel
                            GO
PRINT 'Running accountId 1 and table [Approval]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempApproval

                            CREATE TABLE #TempApproval
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempApproval (Id)
                            SELECT  [A].Id
                            FROM [Approval] A INNER JOIN [Usuario] U ON A.[UserId] = U.[ID]
                            WHERE [U].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempApprovalDel
                            CREATE TABLE #TempApprovalDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempApproval))
                            BEGIN
                                TRUNCATE TABLE #TempApprovalDel

                                INSERT #TempApprovalDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempApproval
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempApprovalDel
                                DELETE A
                                FROM [Approval] A INNER JOIN #TempApprovalDel TempApprovalDel ON [A].ID = TempApprovalDel.Id
                                WHERE [A].ID >= @MinId AND [A].ID <= @MaxId
                                        
                                DELETE #TempApproval
                                FROM #TempApproval TempApproval INNER JOIN #TempApprovalDel TempApprovalDel ON TempApproval.ID = TempApprovalDel.Id
                            END
                            DROP TABLE #TempApproval
                            DROP TABLE #TempApprovalDel
                            GO
PRINT 'Running accountId 1 and table [Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempUsuario

                            CREATE TABLE #TempUsuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempUsuario (Id)
                            SELECT  [Usuario].Id
                            FROM [Usuario] Usuario
                            WHERE [Usuario].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempUsuarioDel
                            CREATE TABLE #TempUsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempUsuario))
                            BEGIN
                                TRUNCATE TABLE #TempUsuarioDel

                                INSERT #TempUsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempUsuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempUsuarioDel
                                DELETE Usuario
                                FROM [Usuario] Usuario INNER JOIN #TempUsuarioDel TempUsuarioDel ON [Usuario].ID = TempUsuarioDel.Id
                                WHERE [Usuario].ID >= @MinId AND [Usuario].ID <= @MaxId
                                        
                                DELETE #TempUsuario
                                FROM #TempUsuario TempUsuario INNER JOIN #TempUsuarioDel TempUsuarioDel ON TempUsuario.ID = TempUsuarioDel.Id
                            END
                            DROP TABLE #TempUsuario
                            DROP TABLE #TempUsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Timeline_TipoItem_Cultura_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTimeline_TipoItem_Cultura_Account

                            CREATE TABLE #TempTimeline_TipoItem_Cultura_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTimeline_TipoItem_Cultura_Account (Id)
                            SELECT  [Timeline_TipoItem_Cultura_Account].Id
                            FROM [Timeline_TipoItem_Cultura_Account] Timeline_TipoItem_Cultura_Account
                            WHERE [Timeline_TipoItem_Cultura_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTimeline_TipoItem_Cultura_AccountDel
                            CREATE TABLE #TempTimeline_TipoItem_Cultura_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTimeline_TipoItem_Cultura_Account))
                            BEGIN
                                TRUNCATE TABLE #TempTimeline_TipoItem_Cultura_AccountDel

                                INSERT #TempTimeline_TipoItem_Cultura_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTimeline_TipoItem_Cultura_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTimeline_TipoItem_Cultura_AccountDel
                                DELETE Timeline_TipoItem_Cultura_Account
                                FROM [Timeline_TipoItem_Cultura_Account] Timeline_TipoItem_Cultura_Account INNER JOIN #TempTimeline_TipoItem_Cultura_AccountDel TempTimeline_TipoItem_Cultura_AccountDel ON [Timeline_TipoItem_Cultura_Account].ID = TempTimeline_TipoItem_Cultura_AccountDel.Id
                                WHERE [Timeline_TipoItem_Cultura_Account].ID >= @MinId AND [Timeline_TipoItem_Cultura_Account].ID <= @MaxId
                                        
                                DELETE #TempTimeline_TipoItem_Cultura_Account
                                FROM #TempTimeline_TipoItem_Cultura_Account TempTimeline_TipoItem_Cultura_Account INNER JOIN #TempTimeline_TipoItem_Cultura_AccountDel TempTimeline_TipoItem_Cultura_AccountDel ON TempTimeline_TipoItem_Cultura_Account.ID = TempTimeline_TipoItem_Cultura_AccountDel.Id
                            END
                            DROP TABLE #TempTimeline_TipoItem_Cultura_Account
                            DROP TABLE #TempTimeline_TipoItem_Cultura_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Tarefa_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTarefa_Usuario

                            CREATE TABLE #TempTarefa_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTarefa_Usuario (Id)
                            SELECT DISTINCT [TU].Id
                            FROM [Tarefa_Usuario] TU INNER JOIN [Tarefa] T ON Tu.[ID_Tarefa] = T.[ID] INNER JOIN [Tarefa_Conclusao] TC ON T.[ID] = TC.[ID_Tarefa]
                            WHERE [TC].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTarefa_UsuarioDel
                            CREATE TABLE #TempTarefa_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTarefa_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempTarefa_UsuarioDel

                                INSERT #TempTarefa_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTarefa_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTarefa_UsuarioDel
                                DELETE TU
                                FROM [Tarefa_Usuario] TU INNER JOIN #TempTarefa_UsuarioDel TempTarefa_UsuarioDel ON [TU].ID = TempTarefa_UsuarioDel.Id
                                WHERE [TU].ID >= @MinId AND [TU].ID <= @MaxId
                                        
                                DELETE #TempTarefa_Usuario
                                FROM #TempTarefa_Usuario TempTarefa_Usuario INNER JOIN #TempTarefa_UsuarioDel TempTarefa_UsuarioDel ON TempTarefa_Usuario.ID = TempTarefa_UsuarioDel.Id
                            END
                            DROP TABLE #TempTarefa_Usuario
                            DROP TABLE #TempTarefa_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Tarefa_Contato]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTarefa_Contato

                            CREATE TABLE #TempTarefa_Contato
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTarefa_Contato (Id)
                            SELECT DISTINCT [TC].Id
                            FROM [Tarefa_Contato] TC INNER JOIN [Tarefa] T ON TC.[ID_Tarefa] = T.[ID] INNER JOIN [Tarefa_Conclusao] TCo ON T.[ID] = TCo.[ID_Tarefa]
                            WHERE [TCo].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTarefa_ContatoDel
                            CREATE TABLE #TempTarefa_ContatoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTarefa_Contato))
                            BEGIN
                                TRUNCATE TABLE #TempTarefa_ContatoDel

                                INSERT #TempTarefa_ContatoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTarefa_Contato
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTarefa_ContatoDel
                                DELETE TC
                                FROM [Tarefa_Contato] TC INNER JOIN #TempTarefa_ContatoDel TempTarefa_ContatoDel ON [TC].ID = TempTarefa_ContatoDel.Id
                                WHERE [TC].ID >= @MinId AND [TC].ID <= @MaxId
                                        
                                DELETE #TempTarefa_Contato
                                FROM #TempTarefa_Contato TempTarefa_Contato INNER JOIN #TempTarefa_ContatoDel TempTarefa_ContatoDel ON TempTarefa_Contato.ID = TempTarefa_ContatoDel.Id
                            END
                            DROP TABLE #TempTarefa_Contato
                            DROP TABLE #TempTarefa_ContatoDel
                            GO
PRINT 'Running accountId 1 and table [Tarefa]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTarefa

                            CREATE TABLE #TempTarefa
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTarefa (Id)
                            SELECT DISTINCT [T].Id
                            FROM [Tarefa] T INNER JOIN [Tarefa_Conclusao] TC ON T.[ID] = TC.[ID_Tarefa]
                            WHERE [TC].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTarefaDel
                            CREATE TABLE #TempTarefaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTarefa))
                            BEGIN
                                TRUNCATE TABLE #TempTarefaDel

                                INSERT #TempTarefaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTarefa
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTarefaDel
                                DELETE T
                                FROM [Tarefa] T INNER JOIN #TempTarefaDel TempTarefaDel ON [T].ID = TempTarefaDel.Id
                                WHERE [T].ID >= @MinId AND [T].ID <= @MaxId
                                        
                                DELETE #TempTarefa
                                FROM #TempTarefa TempTarefa INNER JOIN #TempTarefaDel TempTarefaDel ON TempTarefa.ID = TempTarefaDel.Id
                            END
                            DROP TABLE #TempTarefa
                            DROP TABLE #TempTarefaDel
                            GO
PRINT 'Running accountId 1 and table [Tarefa_Conclusao]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTarefa_Conclusao

                            CREATE TABLE #TempTarefa_Conclusao
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTarefa_Conclusao (Id)
                            SELECT  [Tarefa_Conclusao].Id
                            FROM [Tarefa_Conclusao] Tarefa_Conclusao
                            WHERE [Tarefa_Conclusao].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTarefa_ConclusaoDel
                            CREATE TABLE #TempTarefa_ConclusaoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTarefa_Conclusao))
                            BEGIN
                                TRUNCATE TABLE #TempTarefa_ConclusaoDel

                                INSERT #TempTarefa_ConclusaoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTarefa_Conclusao
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTarefa_ConclusaoDel
                                DELETE Tarefa_Conclusao
                                FROM [Tarefa_Conclusao] Tarefa_Conclusao INNER JOIN #TempTarefa_ConclusaoDel TempTarefa_ConclusaoDel ON [Tarefa_Conclusao].ID = TempTarefa_ConclusaoDel.Id
                                WHERE [Tarefa_Conclusao].ID >= @MinId AND [Tarefa_Conclusao].ID <= @MaxId
                                        
                                DELETE #TempTarefa_Conclusao
                                FROM #TempTarefa_Conclusao TempTarefa_Conclusao INNER JOIN #TempTarefa_ConclusaoDel TempTarefa_ConclusaoDel ON TempTarefa_Conclusao.ID = TempTarefa_ConclusaoDel.Id
                            END
                            DROP TABLE #TempTarefa_Conclusao
                            DROP TABLE #TempTarefa_ConclusaoDel
                            GO
PRINT 'Running accountId 1 and table [Tarefa_Classe_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTarefa_Classe_Account

                            CREATE TABLE #TempTarefa_Classe_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTarefa_Classe_Account (Id)
                            SELECT  [Tarefa_Classe_Account].Id
                            FROM [Tarefa_Classe_Account] Tarefa_Classe_Account
                            WHERE [Tarefa_Classe_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTarefa_Classe_AccountDel
                            CREATE TABLE #TempTarefa_Classe_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTarefa_Classe_Account))
                            BEGIN
                                TRUNCATE TABLE #TempTarefa_Classe_AccountDel

                                INSERT #TempTarefa_Classe_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTarefa_Classe_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTarefa_Classe_AccountDel
                                DELETE Tarefa_Classe_Account
                                FROM [Tarefa_Classe_Account] Tarefa_Classe_Account INNER JOIN #TempTarefa_Classe_AccountDel TempTarefa_Classe_AccountDel ON [Tarefa_Classe_Account].ID = TempTarefa_Classe_AccountDel.Id
                                WHERE [Tarefa_Classe_Account].ID >= @MinId AND [Tarefa_Classe_Account].ID <= @MaxId
                                        
                                DELETE #TempTarefa_Classe_Account
                                FROM #TempTarefa_Classe_Account TempTarefa_Classe_Account INNER JOIN #TempTarefa_Classe_AccountDel TempTarefa_Classe_AccountDel ON TempTarefa_Classe_Account.ID = TempTarefa_Classe_AccountDel.Id
                            END
                            DROP TABLE #TempTarefa_Classe_Account
                            DROP TABLE #TempTarefa_Classe_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Tabela_Campo_Campo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTabela_Campo_Campo

                            CREATE TABLE #TempTabela_Campo_Campo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTabela_Campo_Campo (Id)
                            SELECT  [TCC].Id
                            FROM [Tabela_Campo_Campo] TCC INNER JOIN [Tabela_Campo] TC ON TCC.[ID_TabelaCampo] = TC.[ID] INNER JOIN [Tabela] T ON  TC.[ID_Tabela] = T.[ID]
                            WHERE [T].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTabela_Campo_CampoDel
                            CREATE TABLE #TempTabela_Campo_CampoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTabela_Campo_Campo))
                            BEGIN
                                TRUNCATE TABLE #TempTabela_Campo_CampoDel

                                INSERT #TempTabela_Campo_CampoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTabela_Campo_Campo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTabela_Campo_CampoDel
                                DELETE TCC
                                FROM [Tabela_Campo_Campo] TCC INNER JOIN #TempTabela_Campo_CampoDel TempTabela_Campo_CampoDel ON [TCC].ID = TempTabela_Campo_CampoDel.Id
                                WHERE [TCC].ID >= @MinId AND [TCC].ID <= @MaxId
                                        
                                DELETE #TempTabela_Campo_Campo
                                FROM #TempTabela_Campo_Campo TempTabela_Campo_Campo INNER JOIN #TempTabela_Campo_CampoDel TempTabela_Campo_CampoDel ON TempTabela_Campo_Campo.ID = TempTabela_Campo_CampoDel.Id
                            END
                            DROP TABLE #TempTabela_Campo_Campo
                            DROP TABLE #TempTabela_Campo_CampoDel
                            GO
PRINT 'Running accountId 1 and table [Tabela_Permissao_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTabela_Permissao_Usuario

                            CREATE TABLE #TempTabela_Permissao_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTabela_Permissao_Usuario (Id)
                            SELECT  [TPU].Id
                            FROM [Tabela_Permissao_Usuario] TPU INNER JOIN [Tabela] T ON TPU.[ID_Tabela] = T.[ID]
                            WHERE [T].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTabela_Permissao_UsuarioDel
                            CREATE TABLE #TempTabela_Permissao_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTabela_Permissao_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempTabela_Permissao_UsuarioDel

                                INSERT #TempTabela_Permissao_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTabela_Permissao_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTabela_Permissao_UsuarioDel
                                DELETE TPU
                                FROM [Tabela_Permissao_Usuario] TPU INNER JOIN #TempTabela_Permissao_UsuarioDel TempTabela_Permissao_UsuarioDel ON [TPU].ID = TempTabela_Permissao_UsuarioDel.Id
                                WHERE [TPU].ID >= @MinId AND [TPU].ID <= @MaxId
                                        
                                DELETE #TempTabela_Permissao_Usuario
                                FROM #TempTabela_Permissao_Usuario TempTabela_Permissao_Usuario INNER JOIN #TempTabela_Permissao_UsuarioDel TempTabela_Permissao_UsuarioDel ON TempTabela_Permissao_Usuario.ID = TempTabela_Permissao_UsuarioDel.Id
                            END
                            DROP TABLE #TempTabela_Permissao_Usuario
                            DROP TABLE #TempTabela_Permissao_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Tabela_Campo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTabela_Campo

                            CREATE TABLE #TempTabela_Campo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTabela_Campo (Id)
                            SELECT  [TC].Id
                            FROM [Tabela_Campo] TC INNER JOIN [Tabela] T ON  TC.[ID_Tabela] = T.[ID]
                            WHERE [T].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTabela_CampoDel
                            CREATE TABLE #TempTabela_CampoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTabela_Campo))
                            BEGIN
                                TRUNCATE TABLE #TempTabela_CampoDel

                                INSERT #TempTabela_CampoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTabela_Campo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTabela_CampoDel
                                DELETE TC
                                FROM [Tabela_Campo] TC INNER JOIN #TempTabela_CampoDel TempTabela_CampoDel ON [TC].ID = TempTabela_CampoDel.Id
                                WHERE [TC].ID >= @MinId AND [TC].ID <= @MaxId
                                        
                                DELETE #TempTabela_Campo
                                FROM #TempTabela_Campo TempTabela_Campo INNER JOIN #TempTabela_CampoDel TempTabela_CampoDel ON TempTabela_Campo.ID = TempTabela_CampoDel.Id
                            END
                            DROP TABLE #TempTabela_Campo
                            DROP TABLE #TempTabela_CampoDel
                            GO
PRINT 'Running accountId 1 and table [Tabela]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTabela

                            CREATE TABLE #TempTabela
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTabela (Id)
                            SELECT  [Tabela].Id
                            FROM [Tabela] Tabela
                            WHERE [Tabela].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTabelaDel
                            CREATE TABLE #TempTabelaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTabela))
                            BEGIN
                                TRUNCATE TABLE #TempTabelaDel

                                INSERT #TempTabelaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTabela
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTabelaDel
                                DELETE Tabela
                                FROM [Tabela] Tabela INNER JOIN #TempTabelaDel TempTabelaDel ON [Tabela].ID = TempTabelaDel.Id
                                WHERE [Tabela].ID >= @MinId AND [Tabela].ID <= @MaxId
                                        
                                DELETE #TempTabela
                                FROM #TempTabela TempTabela INNER JOIN #TempTabelaDel TempTabelaDel ON TempTabela.ID = TempTabelaDel.Id
                            END
                            DROP TABLE #TempTabela
                            DROP TABLE #TempTabelaDel
                            GO
PRINT 'Running accountId 1 and table [Reports_Sync_Status]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempReports_Sync_Status

                            CREATE TABLE #TempReports_Sync_Status
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempReports_Sync_Status (Id)
                            SELECT  [Reports_Sync_Status].Id
                            FROM [Reports_Sync_Status] Reports_Sync_Status
                            WHERE [Reports_Sync_Status].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempReports_Sync_StatusDel
                            CREATE TABLE #TempReports_Sync_StatusDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempReports_Sync_Status))
                            BEGIN
                                TRUNCATE TABLE #TempReports_Sync_StatusDel

                                INSERT #TempReports_Sync_StatusDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempReports_Sync_Status
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempReports_Sync_StatusDel
                                DELETE Reports_Sync_Status
                                FROM [Reports_Sync_Status] Reports_Sync_Status INNER JOIN #TempReports_Sync_StatusDel TempReports_Sync_StatusDel ON [Reports_Sync_Status].ID = TempReports_Sync_StatusDel.Id
                                WHERE [Reports_Sync_Status].ID >= @MinId AND [Reports_Sync_Status].ID <= @MaxId
                                        
                                DELETE #TempReports_Sync_Status
                                FROM #TempReports_Sync_Status TempReports_Sync_Status INNER JOIN #TempReports_Sync_StatusDel TempReports_Sync_StatusDel ON TempReports_Sync_Status.ID = TempReports_Sync_StatusDel.Id
                            END
                            DROP TABLE #TempReports_Sync_Status
                            DROP TABLE #TempReports_Sync_StatusDel
                            GO
PRINT 'Running accountId 1 and table [Relatorio_Contato]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempRelatorio_Contato

                            CREATE TABLE #TempRelatorio_Contato
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempRelatorio_Contato (Id)
                            SELECT  [RC].Id
                            FROM [Relatorio_Contato] RC INNER JOIN [Relatorio] R ON RC.[ID_Relatorio] = R.[ID]
                            WHERE [R].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempRelatorio_ContatoDel
                            CREATE TABLE #TempRelatorio_ContatoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempRelatorio_Contato))
                            BEGIN
                                TRUNCATE TABLE #TempRelatorio_ContatoDel

                                INSERT #TempRelatorio_ContatoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempRelatorio_Contato
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempRelatorio_ContatoDel
                                DELETE RC
                                FROM [Relatorio_Contato] RC INNER JOIN #TempRelatorio_ContatoDel TempRelatorio_ContatoDel ON [RC].ID = TempRelatorio_ContatoDel.Id
                                WHERE [RC].ID >= @MinId AND [RC].ID <= @MaxId
                                        
                                DELETE #TempRelatorio_Contato
                                FROM #TempRelatorio_Contato TempRelatorio_Contato INNER JOIN #TempRelatorio_ContatoDel TempRelatorio_ContatoDel ON TempRelatorio_Contato.ID = TempRelatorio_ContatoDel.Id
                            END
                            DROP TABLE #TempRelatorio_Contato
                            DROP TABLE #TempRelatorio_ContatoDel
                            GO
PRINT 'Running accountId 1 and table [Relatorio]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempRelatorio

                            CREATE TABLE #TempRelatorio
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempRelatorio (Id)
                            SELECT  [Relatorio].Id
                            FROM [Relatorio] Relatorio
                            WHERE [Relatorio].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempRelatorioDel
                            CREATE TABLE #TempRelatorioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempRelatorio))
                            BEGIN
                                TRUNCATE TABLE #TempRelatorioDel

                                INSERT #TempRelatorioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempRelatorio
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempRelatorioDel
                                DELETE Relatorio
                                FROM [Relatorio] Relatorio INNER JOIN #TempRelatorioDel TempRelatorioDel ON [Relatorio].ID = TempRelatorioDel.Id
                                WHERE [Relatorio].ID >= @MinId AND [Relatorio].ID <= @MaxId
                                        
                                DELETE #TempRelatorio
                                FROM #TempRelatorio TempRelatorio INNER JOIN #TempRelatorioDel TempRelatorioDel ON TempRelatorio.ID = TempRelatorioDel.Id
                            END
                            DROP TABLE #TempRelatorio
                            DROP TABLE #TempRelatorioDel
                            GO
PRINT 'Running accountId 1 and table [RelatedPerson_Email_Type_Template]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempRelatedPerson_Email_Type_Template

                            CREATE TABLE #TempRelatedPerson_Email_Type_Template
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempRelatedPerson_Email_Type_Template (Id)
                            SELECT  [RelatedPerson_Email_Type_Template].Id
                            FROM [RelatedPerson_Email_Type_Template] RelatedPerson_Email_Type_Template
                            WHERE [RelatedPerson_Email_Type_Template].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempRelatedPerson_Email_Type_TemplateDel
                            CREATE TABLE #TempRelatedPerson_Email_Type_TemplateDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempRelatedPerson_Email_Type_Template))
                            BEGIN
                                TRUNCATE TABLE #TempRelatedPerson_Email_Type_TemplateDel

                                INSERT #TempRelatedPerson_Email_Type_TemplateDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempRelatedPerson_Email_Type_Template
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempRelatedPerson_Email_Type_TemplateDel
                                DELETE RelatedPerson_Email_Type_Template
                                FROM [RelatedPerson_Email_Type_Template] RelatedPerson_Email_Type_Template INNER JOIN #TempRelatedPerson_Email_Type_TemplateDel TempRelatedPerson_Email_Type_TemplateDel ON [RelatedPerson_Email_Type_Template].ID = TempRelatedPerson_Email_Type_TemplateDel.Id
                                WHERE [RelatedPerson_Email_Type_Template].ID >= @MinId AND [RelatedPerson_Email_Type_Template].ID <= @MaxId
                                        
                                DELETE #TempRelatedPerson_Email_Type_Template
                                FROM #TempRelatedPerson_Email_Type_Template TempRelatedPerson_Email_Type_Template INNER JOIN #TempRelatedPerson_Email_Type_TemplateDel TempRelatedPerson_Email_Type_TemplateDel ON TempRelatedPerson_Email_Type_Template.ID = TempRelatedPerson_Email_Type_TemplateDel.Id
                            END
                            DROP TABLE #TempRelatedPerson_Email_Type_Template
                            DROP TABLE #TempRelatedPerson_Email_Type_TemplateDel
                            GO
PRINT 'Running accountId 1 and table [RegraNegocio_Campo_Value]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempRegraNegocio_Campo_Value

                            CREATE TABLE #TempRegraNegocio_Campo_Value
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempRegraNegocio_Campo_Value (Id)
                            SELECT  [RNCV].Id
                            FROM [RegraNegocio_Campo_Value] RNCV INNER JOIN [RegraNegocio_Campo] RC ON RNCV.BusinessRuleFieldId = RC.ID INNER JOIN [RegraNegocio] R ON RC.[ID_Regra] = R.[ID]
                            WHERE [R].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempRegraNegocio_Campo_ValueDel
                            CREATE TABLE #TempRegraNegocio_Campo_ValueDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempRegraNegocio_Campo_Value))
                            BEGIN
                                TRUNCATE TABLE #TempRegraNegocio_Campo_ValueDel

                                INSERT #TempRegraNegocio_Campo_ValueDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempRegraNegocio_Campo_Value
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempRegraNegocio_Campo_ValueDel
                                DELETE RNCV
                                FROM [RegraNegocio_Campo_Value] RNCV INNER JOIN #TempRegraNegocio_Campo_ValueDel TempRegraNegocio_Campo_ValueDel ON [RNCV].ID = TempRegraNegocio_Campo_ValueDel.Id
                                WHERE [RNCV].ID >= @MinId AND [RNCV].ID <= @MaxId
                                        
                                DELETE #TempRegraNegocio_Campo_Value
                                FROM #TempRegraNegocio_Campo_Value TempRegraNegocio_Campo_Value INNER JOIN #TempRegraNegocio_Campo_ValueDel TempRegraNegocio_Campo_ValueDel ON TempRegraNegocio_Campo_Value.ID = TempRegraNegocio_Campo_ValueDel.Id
                            END
                            DROP TABLE #TempRegraNegocio_Campo_Value
                            DROP TABLE #TempRegraNegocio_Campo_ValueDel
                            GO
PRINT 'Running accountId 1 and table [RegraNegocio_Campo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempRegraNegocio_Campo

                            CREATE TABLE #TempRegraNegocio_Campo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempRegraNegocio_Campo (Id)
                            SELECT  [RC].Id
                            FROM [RegraNegocio_Campo] RC INNER JOIN [RegraNegocio] R ON RC.[ID_Regra] = R.[ID]
                            WHERE [R].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempRegraNegocio_CampoDel
                            CREATE TABLE #TempRegraNegocio_CampoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempRegraNegocio_Campo))
                            BEGIN
                                TRUNCATE TABLE #TempRegraNegocio_CampoDel

                                INSERT #TempRegraNegocio_CampoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempRegraNegocio_Campo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempRegraNegocio_CampoDel
                                DELETE RC
                                FROM [RegraNegocio_Campo] RC INNER JOIN #TempRegraNegocio_CampoDel TempRegraNegocio_CampoDel ON [RC].ID = TempRegraNegocio_CampoDel.Id
                                WHERE [RC].ID >= @MinId AND [RC].ID <= @MaxId
                                        
                                DELETE #TempRegraNegocio_Campo
                                FROM #TempRegraNegocio_Campo TempRegraNegocio_Campo INNER JOIN #TempRegraNegocio_CampoDel TempRegraNegocio_CampoDel ON TempRegraNegocio_Campo.ID = TempRegraNegocio_CampoDel.Id
                            END
                            DROP TABLE #TempRegraNegocio_Campo
                            DROP TABLE #TempRegraNegocio_CampoDel
                            GO
PRINT 'Running accountId 1 and table [RegraNegocio_Aprovacao_Nivel]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempRegraNegocio_Aprovacao_Nivel

                            CREATE TABLE #TempRegraNegocio_Aprovacao_Nivel
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempRegraNegocio_Aprovacao_Nivel (Id)
                            SELECT  [RAN].Id
                            FROM [RegraNegocio_Aprovacao_Nivel] RAN INNER JOIN [RegraNegocio] R ON RAN.[ID_Regra] = R.[ID]
                            WHERE [R].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempRegraNegocio_Aprovacao_NivelDel
                            CREATE TABLE #TempRegraNegocio_Aprovacao_NivelDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempRegraNegocio_Aprovacao_Nivel))
                            BEGIN
                                TRUNCATE TABLE #TempRegraNegocio_Aprovacao_NivelDel

                                INSERT #TempRegraNegocio_Aprovacao_NivelDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempRegraNegocio_Aprovacao_Nivel
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempRegraNegocio_Aprovacao_NivelDel
                                DELETE RAN
                                FROM [RegraNegocio_Aprovacao_Nivel] RAN INNER JOIN #TempRegraNegocio_Aprovacao_NivelDel TempRegraNegocio_Aprovacao_NivelDel ON [RAN].ID = TempRegraNegocio_Aprovacao_NivelDel.Id
                                WHERE [RAN].ID >= @MinId AND [RAN].ID <= @MaxId
                                        
                                DELETE #TempRegraNegocio_Aprovacao_Nivel
                                FROM #TempRegraNegocio_Aprovacao_Nivel TempRegraNegocio_Aprovacao_Nivel INNER JOIN #TempRegraNegocio_Aprovacao_NivelDel TempRegraNegocio_Aprovacao_NivelDel ON TempRegraNegocio_Aprovacao_Nivel.ID = TempRegraNegocio_Aprovacao_NivelDel.Id
                            END
                            DROP TABLE #TempRegraNegocio_Aprovacao_Nivel
                            DROP TABLE #TempRegraNegocio_Aprovacao_NivelDel
                            GO
PRINT 'Running accountId 1 and table [RegraNegocio]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempRegraNegocio

                            CREATE TABLE #TempRegraNegocio
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempRegraNegocio (Id)
                            SELECT  [RegraNegocio].Id
                            FROM [RegraNegocio] RegraNegocio
                            WHERE [RegraNegocio].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempRegraNegocioDel
                            CREATE TABLE #TempRegraNegocioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempRegraNegocio))
                            BEGIN
                                TRUNCATE TABLE #TempRegraNegocioDel

                                INSERT #TempRegraNegocioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempRegraNegocio
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempRegraNegocioDel
                                DELETE RegraNegocio
                                FROM [RegraNegocio] RegraNegocio INNER JOIN #TempRegraNegocioDel TempRegraNegocioDel ON [RegraNegocio].ID = TempRegraNegocioDel.Id
                                WHERE [RegraNegocio].ID >= @MinId AND [RegraNegocio].ID <= @MaxId
                                        
                                DELETE #TempRegraNegocio
                                FROM #TempRegraNegocio TempRegraNegocio INNER JOIN #TempRegraNegocioDel TempRegraNegocioDel ON TempRegraNegocio.ID = TempRegraNegocioDel.Id
                            END
                            DROP TABLE #TempRegraNegocio
                            DROP TABLE #TempRegraNegocioDel
                            GO
PRINT 'Running accountId 1 and table [PublicForm_Deal]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPublicForm_Deal

                            CREATE TABLE #TempPublicForm_Deal
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPublicForm_Deal (Id)
                            SELECT  [PublicForm_Deal].Id
                            FROM [PublicForm_Deal] PublicForm_Deal
                            WHERE [PublicForm_Deal].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPublicForm_DealDel
                            CREATE TABLE #TempPublicForm_DealDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPublicForm_Deal))
                            BEGIN
                                TRUNCATE TABLE #TempPublicForm_DealDel

                                INSERT #TempPublicForm_DealDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPublicForm_Deal
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPublicForm_DealDel
                                DELETE PublicForm_Deal
                                FROM [PublicForm_Deal] PublicForm_Deal INNER JOIN #TempPublicForm_DealDel TempPublicForm_DealDel ON [PublicForm_Deal].ID = TempPublicForm_DealDel.Id
                                WHERE [PublicForm_Deal].ID >= @MinId AND [PublicForm_Deal].ID <= @MaxId
                                        
                                DELETE #TempPublicForm_Deal
                                FROM #TempPublicForm_Deal TempPublicForm_Deal INNER JOIN #TempPublicForm_DealDel TempPublicForm_DealDel ON TempPublicForm_Deal.ID = TempPublicForm_DealDel.Id
                            END
                            DROP TABLE #TempPublicForm_Deal
                            DROP TABLE #TempPublicForm_DealDel
                            GO
PRINT 'Running accountId 1 and table [PublicForm_Contact]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPublicForm_Contact

                            CREATE TABLE #TempPublicForm_Contact
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPublicForm_Contact (Id)
                            SELECT  [PublicForm_Contact].Id
                            FROM [PublicForm_Contact] PublicForm_Contact
                            WHERE [PublicForm_Contact].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPublicForm_ContactDel
                            CREATE TABLE #TempPublicForm_ContactDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPublicForm_Contact))
                            BEGIN
                                TRUNCATE TABLE #TempPublicForm_ContactDel

                                INSERT #TempPublicForm_ContactDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPublicForm_Contact
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPublicForm_ContactDel
                                DELETE PublicForm_Contact
                                FROM [PublicForm_Contact] PublicForm_Contact INNER JOIN #TempPublicForm_ContactDel TempPublicForm_ContactDel ON [PublicForm_Contact].ID = TempPublicForm_ContactDel.Id
                                WHERE [PublicForm_Contact].ID >= @MinId AND [PublicForm_Contact].ID <= @MaxId
                                        
                                DELETE #TempPublicForm_Contact
                                FROM #TempPublicForm_Contact TempPublicForm_Contact INNER JOIN #TempPublicForm_ContactDel TempPublicForm_ContactDel ON TempPublicForm_Contact.ID = TempPublicForm_ContactDel.Id
                            END
                            DROP TABLE #TempPublicForm_Contact
                            DROP TABLE #TempPublicForm_ContactDel
                            GO
PRINT 'Running accountId 1 and table [PublicForm_Field_Option]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPublicForm_Field_Option

                            CREATE TABLE #TempPublicForm_Field_Option
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPublicForm_Field_Option (Id)
                            SELECT  [PFO].Id
                            FROM [PublicForm_Field_Option] PFO INNER JOIN [PublicForm_Field] PF ON PFO.[PublicFormFieldId] = PF.[ID] INNER JOIN [PublicForm] P ON PF.[PublicFormId] = P.[ID]
                            WHERE [P].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPublicForm_Field_OptionDel
                            CREATE TABLE #TempPublicForm_Field_OptionDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPublicForm_Field_Option))
                            BEGIN
                                TRUNCATE TABLE #TempPublicForm_Field_OptionDel

                                INSERT #TempPublicForm_Field_OptionDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPublicForm_Field_Option
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPublicForm_Field_OptionDel
                                DELETE PFO
                                FROM [PublicForm_Field_Option] PFO INNER JOIN #TempPublicForm_Field_OptionDel TempPublicForm_Field_OptionDel ON [PFO].ID = TempPublicForm_Field_OptionDel.Id
                                WHERE [PFO].ID >= @MinId AND [PFO].ID <= @MaxId
                                        
                                DELETE #TempPublicForm_Field_Option
                                FROM #TempPublicForm_Field_Option TempPublicForm_Field_Option INNER JOIN #TempPublicForm_Field_OptionDel TempPublicForm_Field_OptionDel ON TempPublicForm_Field_Option.ID = TempPublicForm_Field_OptionDel.Id
                            END
                            DROP TABLE #TempPublicForm_Field_Option
                            DROP TABLE #TempPublicForm_Field_OptionDel
                            GO
PRINT 'Running accountId 1 and table [PublicForm_DefaultField_Value]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPublicForm_DefaultField_Value

                            CREATE TABLE #TempPublicForm_DefaultField_Value
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPublicForm_DefaultField_Value (Id)
                            SELECT  [PDV].Id
                            FROM [PublicForm_DefaultField_Value] PDV INNER JOIN [PublicForm_DefaultField] PD ON PDV.[PublicFormDefaultFieldId] = PD.[ID] INNER JOIN [PublicForm] P ON PD.[PublicFormId] = P.[ID]
                            WHERE [P].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPublicForm_DefaultField_ValueDel
                            CREATE TABLE #TempPublicForm_DefaultField_ValueDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPublicForm_DefaultField_Value))
                            BEGIN
                                TRUNCATE TABLE #TempPublicForm_DefaultField_ValueDel

                                INSERT #TempPublicForm_DefaultField_ValueDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPublicForm_DefaultField_Value
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPublicForm_DefaultField_ValueDel
                                DELETE PDV
                                FROM [PublicForm_DefaultField_Value] PDV INNER JOIN #TempPublicForm_DefaultField_ValueDel TempPublicForm_DefaultField_ValueDel ON [PDV].ID = TempPublicForm_DefaultField_ValueDel.Id
                                WHERE [PDV].ID >= @MinId AND [PDV].ID <= @MaxId
                                        
                                DELETE #TempPublicForm_DefaultField_Value
                                FROM #TempPublicForm_DefaultField_Value TempPublicForm_DefaultField_Value INNER JOIN #TempPublicForm_DefaultField_ValueDel TempPublicForm_DefaultField_ValueDel ON TempPublicForm_DefaultField_Value.ID = TempPublicForm_DefaultField_ValueDel.Id
                            END
                            DROP TABLE #TempPublicForm_DefaultField_Value
                            DROP TABLE #TempPublicForm_DefaultField_ValueDel
                            GO
PRINT 'Running accountId 1 and table [PublicForm_Field]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPublicForm_Field

                            CREATE TABLE #TempPublicForm_Field
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPublicForm_Field (Id)
                            SELECT  [PF].Id
                            FROM [PublicForm_Field] PF INNER JOIN [PublicForm] P ON PF.[PublicFormId] = P.[ID]
                            WHERE [P].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPublicForm_FieldDel
                            CREATE TABLE #TempPublicForm_FieldDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPublicForm_Field))
                            BEGIN
                                TRUNCATE TABLE #TempPublicForm_FieldDel

                                INSERT #TempPublicForm_FieldDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPublicForm_Field
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPublicForm_FieldDel
                                DELETE PF
                                FROM [PublicForm_Field] PF INNER JOIN #TempPublicForm_FieldDel TempPublicForm_FieldDel ON [PF].ID = TempPublicForm_FieldDel.Id
                                WHERE [PF].ID >= @MinId AND [PF].ID <= @MaxId
                                        
                                DELETE #TempPublicForm_Field
                                FROM #TempPublicForm_Field TempPublicForm_Field INNER JOIN #TempPublicForm_FieldDel TempPublicForm_FieldDel ON TempPublicForm_Field.ID = TempPublicForm_FieldDel.Id
                            END
                            DROP TABLE #TempPublicForm_Field
                            DROP TABLE #TempPublicForm_FieldDel
                            GO
PRINT 'Running accountId 1 and table [PublicForm_DefaultField]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPublicForm_DefaultField

                            CREATE TABLE #TempPublicForm_DefaultField
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPublicForm_DefaultField (Id)
                            SELECT  [PD].Id
                            FROM [PublicForm_DefaultField] PD INNER JOIN [PublicForm] P ON PD.[PublicFormId] = P.[ID]
                            WHERE [P].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPublicForm_DefaultFieldDel
                            CREATE TABLE #TempPublicForm_DefaultFieldDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPublicForm_DefaultField))
                            BEGIN
                                TRUNCATE TABLE #TempPublicForm_DefaultFieldDel

                                INSERT #TempPublicForm_DefaultFieldDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPublicForm_DefaultField
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPublicForm_DefaultFieldDel
                                DELETE PD
                                FROM [PublicForm_DefaultField] PD INNER JOIN #TempPublicForm_DefaultFieldDel TempPublicForm_DefaultFieldDel ON [PD].ID = TempPublicForm_DefaultFieldDel.Id
                                WHERE [PD].ID >= @MinId AND [PD].ID <= @MaxId
                                        
                                DELETE #TempPublicForm_DefaultField
                                FROM #TempPublicForm_DefaultField TempPublicForm_DefaultField INNER JOIN #TempPublicForm_DefaultFieldDel TempPublicForm_DefaultFieldDel ON TempPublicForm_DefaultField.ID = TempPublicForm_DefaultFieldDel.Id
                            END
                            DROP TABLE #TempPublicForm_DefaultField
                            DROP TABLE #TempPublicForm_DefaultFieldDel
                            GO
PRINT 'Running accountId 1 and table [PublicForm]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPublicForm

                            CREATE TABLE #TempPublicForm
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPublicForm (Id)
                            SELECT  [PublicForm].Id
                            FROM [PublicForm] PublicForm
                            WHERE [PublicForm].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPublicFormDel
                            CREATE TABLE #TempPublicFormDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPublicForm))
                            BEGIN
                                TRUNCATE TABLE #TempPublicFormDel

                                INSERT #TempPublicFormDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPublicForm
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPublicFormDel
                                DELETE PublicForm
                                FROM [PublicForm] PublicForm INNER JOIN #TempPublicFormDel TempPublicFormDel ON [PublicForm].ID = TempPublicFormDel.Id
                                WHERE [PublicForm].ID >= @MinId AND [PublicForm].ID <= @MaxId
                                        
                                DELETE #TempPublicForm
                                FROM #TempPublicForm TempPublicForm INNER JOIN #TempPublicFormDel TempPublicFormDel ON TempPublicForm.ID = TempPublicFormDel.Id
                            END
                            DROP TABLE #TempPublicForm
                            DROP TABLE #TempPublicFormDel
                            GO
PRINT 'Running accountId 1 and table [Produto_Parte_Group]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_Parte_Group

                            CREATE TABLE #TempProduto_Parte_Group
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_Parte_Group (Id)
                            SELECT  [Produto_Parte_Group].Id
                            FROM [Produto_Parte_Group] Produto_Parte_Group
                            WHERE [Produto_Parte_Group].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_Parte_GroupDel
                            CREATE TABLE #TempProduto_Parte_GroupDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_Parte_Group))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_Parte_GroupDel

                                INSERT #TempProduto_Parte_GroupDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_Parte_Group
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_Parte_GroupDel
                                DELETE Produto_Parte_Group
                                FROM [Produto_Parte_Group] Produto_Parte_Group INNER JOIN #TempProduto_Parte_GroupDel TempProduto_Parte_GroupDel ON [Produto_Parte_Group].ID = TempProduto_Parte_GroupDel.Id
                                WHERE [Produto_Parte_Group].ID >= @MinId AND [Produto_Parte_Group].ID <= @MaxId
                                        
                                DELETE #TempProduto_Parte_Group
                                FROM #TempProduto_Parte_Group TempProduto_Parte_Group INNER JOIN #TempProduto_Parte_GroupDel TempProduto_Parte_GroupDel ON TempProduto_Parte_Group.ID = TempProduto_Parte_GroupDel.Id
                            END
                            DROP TABLE #TempProduto_Parte_Group
                            DROP TABLE #TempProduto_Parte_GroupDel
                            GO
PRINT 'Running accountId 1 and table [Produto_List]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_List

                            CREATE TABLE #TempProduto_List
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_List (Id)
                            SELECT  [Produto_List].Id
                            FROM [Produto_List] Produto_List
                            WHERE [Produto_List].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_ListDel
                            CREATE TABLE #TempProduto_ListDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_List))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_ListDel

                                INSERT #TempProduto_ListDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_List
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_ListDel
                                DELETE Produto_List
                                FROM [Produto_List] Produto_List INNER JOIN #TempProduto_ListDel TempProduto_ListDel ON [Produto_List].ID = TempProduto_ListDel.Id
                                WHERE [Produto_List].ID >= @MinId AND [Produto_List].ID <= @MaxId
                                        
                                DELETE #TempProduto_List
                                FROM #TempProduto_List TempProduto_List INNER JOIN #TempProduto_ListDel TempProduto_ListDel ON TempProduto_List.ID = TempProduto_ListDel.Id
                            END
                            DROP TABLE #TempProduto_List
                            DROP TABLE #TempProduto_ListDel
                            GO
PRINT 'Running accountId 1 and table [Produto_Grupo_Familia]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_Grupo_Familia

                            CREATE TABLE #TempProduto_Grupo_Familia
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_Grupo_Familia (Id)
                            SELECT  [Produto_Grupo_Familia].Id
                            FROM [Produto_Grupo_Familia] Produto_Grupo_Familia
                            WHERE [Produto_Grupo_Familia].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_Grupo_FamiliaDel
                            CREATE TABLE #TempProduto_Grupo_FamiliaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_Grupo_Familia))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_Grupo_FamiliaDel

                                INSERT #TempProduto_Grupo_FamiliaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_Grupo_Familia
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_Grupo_FamiliaDel
                                DELETE Produto_Grupo_Familia
                                FROM [Produto_Grupo_Familia] Produto_Grupo_Familia INNER JOIN #TempProduto_Grupo_FamiliaDel TempProduto_Grupo_FamiliaDel ON [Produto_Grupo_Familia].ID = TempProduto_Grupo_FamiliaDel.Id
                                WHERE [Produto_Grupo_Familia].ID >= @MinId AND [Produto_Grupo_Familia].ID <= @MaxId
                                        
                                DELETE #TempProduto_Grupo_Familia
                                FROM #TempProduto_Grupo_Familia TempProduto_Grupo_Familia INNER JOIN #TempProduto_Grupo_FamiliaDel TempProduto_Grupo_FamiliaDel ON TempProduto_Grupo_Familia.ID = TempProduto_Grupo_FamiliaDel.Id
                            END
                            DROP TABLE #TempProduto_Grupo_Familia
                            DROP TABLE #TempProduto_Grupo_FamiliaDel
                            GO
PRINT 'Running accountId 1 and table [Produto_Grupo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_Grupo

                            CREATE TABLE #TempProduto_Grupo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_Grupo (Id)
                            SELECT  [Produto_Grupo].Id
                            FROM [Produto_Grupo] Produto_Grupo
                            WHERE [Produto_Grupo].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_GrupoDel
                            CREATE TABLE #TempProduto_GrupoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_Grupo))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_GrupoDel

                                INSERT #TempProduto_GrupoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_Grupo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_GrupoDel
                                DELETE Produto_Grupo
                                FROM [Produto_Grupo] Produto_Grupo INNER JOIN #TempProduto_GrupoDel TempProduto_GrupoDel ON [Produto_Grupo].ID = TempProduto_GrupoDel.Id
                                WHERE [Produto_Grupo].ID >= @MinId AND [Produto_Grupo].ID <= @MaxId
                                        
                                DELETE #TempProduto_Grupo
                                FROM #TempProduto_Grupo TempProduto_Grupo INNER JOIN #TempProduto_GrupoDel TempProduto_GrupoDel ON TempProduto_Grupo.ID = TempProduto_GrupoDel.Id
                            END
                            DROP TABLE #TempProduto_Grupo
                            DROP TABLE #TempProduto_GrupoDel
                            GO
PRINT 'Running accountId 1 and table [Produto_Parte_SuggestedPart]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_Parte_SuggestedPart

                            CREATE TABLE #TempProduto_Parte_SuggestedPart
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_Parte_SuggestedPart (Id)
                            SELECT  [PPS].Id
                            FROM [Produto_Parte_SuggestedPart] PPS INNER JOIN [Produto_Parte] PP ON PPS.[PartId] = PP.[Id] INNER JOIN [Produto] P ON PP.[ID_Produto] = P.[ID]
                            WHERE [P].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_Parte_SuggestedPartDel
                            CREATE TABLE #TempProduto_Parte_SuggestedPartDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_Parte_SuggestedPart))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_Parte_SuggestedPartDel

                                INSERT #TempProduto_Parte_SuggestedPartDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_Parte_SuggestedPart
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_Parte_SuggestedPartDel
                                DELETE PPS
                                FROM [Produto_Parte_SuggestedPart] PPS INNER JOIN #TempProduto_Parte_SuggestedPartDel TempProduto_Parte_SuggestedPartDel ON [PPS].ID = TempProduto_Parte_SuggestedPartDel.Id
                                WHERE [PPS].ID >= @MinId AND [PPS].ID <= @MaxId
                                        
                                DELETE #TempProduto_Parte_SuggestedPart
                                FROM #TempProduto_Parte_SuggestedPart TempProduto_Parte_SuggestedPart INNER JOIN #TempProduto_Parte_SuggestedPartDel TempProduto_Parte_SuggestedPartDel ON TempProduto_Parte_SuggestedPart.ID = TempProduto_Parte_SuggestedPartDel.Id
                            END
                            DROP TABLE #TempProduto_Parte_SuggestedPart
                            DROP TABLE #TempProduto_Parte_SuggestedPartDel
                            GO
PRINT 'Running accountId 1 and table [Produto_Parte_RequiredPart]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_Parte_RequiredPart

                            CREATE TABLE #TempProduto_Parte_RequiredPart
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_Parte_RequiredPart (Id)
                            SELECT  [PPR].Id
                            FROM [Produto_Parte_RequiredPart] PPR INNER JOIN [Produto_Parte] PP ON PPR.[PartId] = PP.[Id] INNER JOIN [Produto] P ON PP.[ID_Produto] = P.[ID]
                            WHERE [P].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_Parte_RequiredPartDel
                            CREATE TABLE #TempProduto_Parte_RequiredPartDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_Parte_RequiredPart))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_Parte_RequiredPartDel

                                INSERT #TempProduto_Parte_RequiredPartDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_Parte_RequiredPart
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_Parte_RequiredPartDel
                                DELETE PPR
                                FROM [Produto_Parte_RequiredPart] PPR INNER JOIN #TempProduto_Parte_RequiredPartDel TempProduto_Parte_RequiredPartDel ON [PPR].ID = TempProduto_Parte_RequiredPartDel.Id
                                WHERE [PPR].ID >= @MinId AND [PPR].ID <= @MaxId
                                        
                                DELETE #TempProduto_Parte_RequiredPart
                                FROM #TempProduto_Parte_RequiredPart TempProduto_Parte_RequiredPart INNER JOIN #TempProduto_Parte_RequiredPartDel TempProduto_Parte_RequiredPartDel ON TempProduto_Parte_RequiredPart.ID = TempProduto_Parte_RequiredPartDel.Id
                            END
                            DROP TABLE #TempProduto_Parte_RequiredPart
                            DROP TABLE #TempProduto_Parte_RequiredPartDel
                            GO
PRINT 'Running accountId 1 and table [Produto_Parte_BlockedPart]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_Parte_BlockedPart

                            CREATE TABLE #TempProduto_Parte_BlockedPart
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_Parte_BlockedPart (Id)
                            SELECT  [PPB].Id
                            FROM [Produto_Parte_BlockedPart] PPB INNER JOIN [Produto_Parte] PP ON PPB.[PartId] = PP.[Id] INNER JOIN [Produto] P ON PP.[ID_Produto] = P.[ID]
                            WHERE [P].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_Parte_BlockedPartDel
                            CREATE TABLE #TempProduto_Parte_BlockedPartDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_Parte_BlockedPart))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_Parte_BlockedPartDel

                                INSERT #TempProduto_Parte_BlockedPartDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_Parte_BlockedPart
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_Parte_BlockedPartDel
                                DELETE PPB
                                FROM [Produto_Parte_BlockedPart] PPB INNER JOIN #TempProduto_Parte_BlockedPartDel TempProduto_Parte_BlockedPartDel ON [PPB].ID = TempProduto_Parte_BlockedPartDel.Id
                                WHERE [PPB].ID >= @MinId AND [PPB].ID <= @MaxId
                                        
                                DELETE #TempProduto_Parte_BlockedPart
                                FROM #TempProduto_Parte_BlockedPart TempProduto_Parte_BlockedPart INNER JOIN #TempProduto_Parte_BlockedPartDel TempProduto_Parte_BlockedPartDel ON TempProduto_Parte_BlockedPart.ID = TempProduto_Parte_BlockedPartDel.Id
                            END
                            DROP TABLE #TempProduto_Parte_BlockedPart
                            DROP TABLE #TempProduto_Parte_BlockedPartDel
                            GO
PRINT 'Running accountId 1 and table [Produto_Parte]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_Parte

                            CREATE TABLE #TempProduto_Parte
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_Parte (Id)
                            SELECT  [PP].Id
                            FROM [Produto_Parte] PP INNER JOIN [Produto] P ON PP.[ID_Produto] = P.[ID]
                            WHERE [P].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_ParteDel
                            CREATE TABLE #TempProduto_ParteDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_Parte))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_ParteDel

                                INSERT #TempProduto_ParteDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_Parte
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_ParteDel
                                DELETE PP
                                FROM [Produto_Parte] PP INNER JOIN #TempProduto_ParteDel TempProduto_ParteDel ON [PP].ID = TempProduto_ParteDel.Id
                                WHERE [PP].ID >= @MinId AND [PP].ID <= @MaxId
                                        
                                DELETE #TempProduto_Parte
                                FROM #TempProduto_Parte TempProduto_Parte INNER JOIN #TempProduto_ParteDel TempProduto_ParteDel ON TempProduto_Parte.ID = TempProduto_ParteDel.Id
                            END
                            DROP TABLE #TempProduto_Parte
                            DROP TABLE #TempProduto_ParteDel
                            GO
PRINT 'Running accountId 1 and table [Produto_List_Product]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_List_Product

                            CREATE TABLE #TempProduto_List_Product
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_List_Product (Id)
                            SELECT  [PLP].Id
                            FROM [Produto_List_Product] PLP INNER JOIN [Produto] P ON PLP.[ProductId] = P.[ID]
                            WHERE [P].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_List_ProductDel
                            CREATE TABLE #TempProduto_List_ProductDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_List_Product))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_List_ProductDel

                                INSERT #TempProduto_List_ProductDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_List_Product
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_List_ProductDel
                                DELETE PLP
                                FROM [Produto_List_Product] PLP INNER JOIN #TempProduto_List_ProductDel TempProduto_List_ProductDel ON [PLP].ID = TempProduto_List_ProductDel.Id
                                WHERE [PLP].ID >= @MinId AND [PLP].ID <= @MaxId
                                        
                                DELETE #TempProduto_List_Product
                                FROM #TempProduto_List_Product TempProduto_List_Product INNER JOIN #TempProduto_List_ProductDel TempProduto_List_ProductDel ON TempProduto_List_Product.ID = TempProduto_List_ProductDel.Id
                            END
                            DROP TABLE #TempProduto_List_Product
                            DROP TABLE #TempProduto_List_ProductDel
                            GO
PRINT 'Running accountId 1 and table [Produto]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto

                            CREATE TABLE #TempProduto
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto (Id)
                            SELECT  [Produto].Id
                            FROM [Produto] Produto
                            WHERE [Produto].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProdutoDel
                            CREATE TABLE #TempProdutoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto))
                            BEGIN
                                TRUNCATE TABLE #TempProdutoDel

                                INSERT #TempProdutoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProdutoDel
                                DELETE Produto
                                FROM [Produto] Produto INNER JOIN #TempProdutoDel TempProdutoDel ON [Produto].ID = TempProdutoDel.Id
                                WHERE [Produto].ID >= @MinId AND [Produto].ID <= @MaxId
                                        
                                DELETE #TempProduto
                                FROM #TempProduto TempProduto INNER JOIN #TempProdutoDel TempProdutoDel ON TempProduto.ID = TempProdutoDel.Id
                            END
                            DROP TABLE #TempProduto
                            DROP TABLE #TempProdutoDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_SupportAccess_Request_Notification]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_SupportAccess_Request_Notification

                            CREATE TABLE #TempPloomes_Cliente_SupportAccess_Request_Notification
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_SupportAccess_Request_Notification (Id)
                            SELECT  [PSRN].Id
                            FROM [Ploomes_Cliente_SupportAccess_Request_Notification] PSRN INNER JOIN [Ploomes_Cliente_SupportAccess_Request] PCSR ON PSRN.[RequestId] = PCSR.[Id]
                            WHERE [PCSR].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_SupportAccess_Request_NotificationDel
                            CREATE TABLE #TempPloomes_Cliente_SupportAccess_Request_NotificationDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_SupportAccess_Request_Notification))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_SupportAccess_Request_NotificationDel

                                INSERT #TempPloomes_Cliente_SupportAccess_Request_NotificationDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_SupportAccess_Request_Notification
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_SupportAccess_Request_NotificationDel
                                DELETE PSRN
                                FROM [Ploomes_Cliente_SupportAccess_Request_Notification] PSRN INNER JOIN #TempPloomes_Cliente_SupportAccess_Request_NotificationDel TempPloomes_Cliente_SupportAccess_Request_NotificationDel ON [PSRN].ID = TempPloomes_Cliente_SupportAccess_Request_NotificationDel.Id
                                WHERE [PSRN].ID >= @MinId AND [PSRN].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_SupportAccess_Request_Notification
                                FROM #TempPloomes_Cliente_SupportAccess_Request_Notification TempPloomes_Cliente_SupportAccess_Request_Notification INNER JOIN #TempPloomes_Cliente_SupportAccess_Request_NotificationDel TempPloomes_Cliente_SupportAccess_Request_NotificationDel ON TempPloomes_Cliente_SupportAccess_Request_Notification.ID = TempPloomes_Cliente_SupportAccess_Request_NotificationDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_SupportAccess_Request_Notification
                            DROP TABLE #TempPloomes_Cliente_SupportAccess_Request_NotificationDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_SupportAccess_Request]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_SupportAccess_Request

                            CREATE TABLE #TempPloomes_Cliente_SupportAccess_Request
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_SupportAccess_Request (Id)
                            SELECT  [Ploomes_Cliente_SupportAccess_Request].Id
                            FROM [Ploomes_Cliente_SupportAccess_Request] Ploomes_Cliente_SupportAccess_Request
                            WHERE [Ploomes_Cliente_SupportAccess_Request].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_SupportAccess_RequestDel
                            CREATE TABLE #TempPloomes_Cliente_SupportAccess_RequestDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_SupportAccess_Request))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_SupportAccess_RequestDel

                                INSERT #TempPloomes_Cliente_SupportAccess_RequestDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_SupportAccess_Request
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_SupportAccess_RequestDel
                                DELETE Ploomes_Cliente_SupportAccess_Request
                                FROM [Ploomes_Cliente_SupportAccess_Request] Ploomes_Cliente_SupportAccess_Request INNER JOIN #TempPloomes_Cliente_SupportAccess_RequestDel TempPloomes_Cliente_SupportAccess_RequestDel ON [Ploomes_Cliente_SupportAccess_Request].ID = TempPloomes_Cliente_SupportAccess_RequestDel.Id
                                WHERE [Ploomes_Cliente_SupportAccess_Request].ID >= @MinId AND [Ploomes_Cliente_SupportAccess_Request].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_SupportAccess_Request
                                FROM #TempPloomes_Cliente_SupportAccess_Request TempPloomes_Cliente_SupportAccess_Request INNER JOIN #TempPloomes_Cliente_SupportAccess_RequestDel TempPloomes_Cliente_SupportAccess_RequestDel ON TempPloomes_Cliente_SupportAccess_Request.ID = TempPloomes_Cliente_SupportAccess_RequestDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_SupportAccess_Request
                            DROP TABLE #TempPloomes_Cliente_SupportAccess_RequestDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Pagamento]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Pagamento

                            CREATE TABLE #TempPloomes_Cliente_Pagamento
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Pagamento (Id)
                            SELECT  [Ploomes_Cliente_Pagamento].Id
                            FROM [Ploomes_Cliente_Pagamento] Ploomes_Cliente_Pagamento
                            WHERE [Ploomes_Cliente_Pagamento].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_PagamentoDel
                            CREATE TABLE #TempPloomes_Cliente_PagamentoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Pagamento))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_PagamentoDel

                                INSERT #TempPloomes_Cliente_PagamentoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Pagamento
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_PagamentoDel
                                DELETE Ploomes_Cliente_Pagamento
                                FROM [Ploomes_Cliente_Pagamento] Ploomes_Cliente_Pagamento INNER JOIN #TempPloomes_Cliente_PagamentoDel TempPloomes_Cliente_PagamentoDel ON [Ploomes_Cliente_Pagamento].ID = TempPloomes_Cliente_PagamentoDel.Id
                                WHERE [Ploomes_Cliente_Pagamento].ID >= @MinId AND [Ploomes_Cliente_Pagamento].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Pagamento
                                FROM #TempPloomes_Cliente_Pagamento TempPloomes_Cliente_Pagamento INNER JOIN #TempPloomes_Cliente_PagamentoDel TempPloomes_Cliente_PagamentoDel ON TempPloomes_Cliente_Pagamento.ID = TempPloomes_Cliente_PagamentoDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Pagamento
                            DROP TABLE #TempPloomes_Cliente_PagamentoDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Module_Partners]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Module_Partners

                            CREATE TABLE #TempPloomes_Cliente_Module_Partners
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Module_Partners (Id)
                            SELECT  [Ploomes_Cliente_Module_Partners].Id
                            FROM [Ploomes_Cliente_Module_Partners] Ploomes_Cliente_Module_Partners
                            WHERE [Ploomes_Cliente_Module_Partners].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_Module_PartnersDel
                            CREATE TABLE #TempPloomes_Cliente_Module_PartnersDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Module_Partners))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_Module_PartnersDel

                                INSERT #TempPloomes_Cliente_Module_PartnersDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Module_Partners
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_Module_PartnersDel
                                DELETE Ploomes_Cliente_Module_Partners
                                FROM [Ploomes_Cliente_Module_Partners] Ploomes_Cliente_Module_Partners INNER JOIN #TempPloomes_Cliente_Module_PartnersDel TempPloomes_Cliente_Module_PartnersDel ON [Ploomes_Cliente_Module_Partners].ID = TempPloomes_Cliente_Module_PartnersDel.Id
                                WHERE [Ploomes_Cliente_Module_Partners].ID >= @MinId AND [Ploomes_Cliente_Module_Partners].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Module_Partners
                                FROM #TempPloomes_Cliente_Module_Partners TempPloomes_Cliente_Module_Partners INNER JOIN #TempPloomes_Cliente_Module_PartnersDel TempPloomes_Cliente_Module_PartnersDel ON TempPloomes_Cliente_Module_Partners.ID = TempPloomes_Cliente_Module_PartnersDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Module_Partners
                            DROP TABLE #TempPloomes_Cliente_Module_PartnersDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Module]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Module

                            CREATE TABLE #TempPloomes_Cliente_Module
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Module (Id)
                            SELECT  [Ploomes_Cliente_Module].Id
                            FROM [Ploomes_Cliente_Module] Ploomes_Cliente_Module
                            WHERE [Ploomes_Cliente_Module].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_ModuleDel
                            CREATE TABLE #TempPloomes_Cliente_ModuleDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Module))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_ModuleDel

                                INSERT #TempPloomes_Cliente_ModuleDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Module
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_ModuleDel
                                DELETE Ploomes_Cliente_Module
                                FROM [Ploomes_Cliente_Module] Ploomes_Cliente_Module INNER JOIN #TempPloomes_Cliente_ModuleDel TempPloomes_Cliente_ModuleDel ON [Ploomes_Cliente_Module].ID = TempPloomes_Cliente_ModuleDel.Id
                                WHERE [Ploomes_Cliente_Module].ID >= @MinId AND [Ploomes_Cliente_Module].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Module
                                FROM #TempPloomes_Cliente_Module TempPloomes_Cliente_Module INNER JOIN #TempPloomes_Cliente_ModuleDel TempPloomes_Cliente_ModuleDel ON TempPloomes_Cliente_Module.ID = TempPloomes_Cliente_ModuleDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Module
                            DROP TABLE #TempPloomes_Cliente_ModuleDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Integration_MappedField_Option]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_MappedField_Option

                            CREATE TABLE #TempPloomes_Cliente_Integration_MappedField_Option
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Integration_MappedField_Option (Id)
                            SELECT  [PIMO].Id
                            FROM [Ploomes_Cliente_Integration_MappedField_Option] PIMO INNER JOIN [Ploomes_Cliente_Integration_MappedField] PCIM ON PIMO.[AccountIntegrationMappedFieldId] = PCIM.[Id] INNER JOIN [Ploomes_Cliente_Integration] PCI ON PCIM.[AccountIntegrationId] = PCI.[Id]
                            WHERE [PCI].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_MappedField_OptionDel
                            CREATE TABLE #TempPloomes_Cliente_Integration_MappedField_OptionDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Integration_MappedField_Option))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_Integration_MappedField_OptionDel

                                INSERT #TempPloomes_Cliente_Integration_MappedField_OptionDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Integration_MappedField_Option
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_Integration_MappedField_OptionDel
                                DELETE PIMO
                                FROM [Ploomes_Cliente_Integration_MappedField_Option] PIMO INNER JOIN #TempPloomes_Cliente_Integration_MappedField_OptionDel TempPloomes_Cliente_Integration_MappedField_OptionDel ON [PIMO].ID = TempPloomes_Cliente_Integration_MappedField_OptionDel.Id
                                WHERE [PIMO].ID >= @MinId AND [PIMO].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Integration_MappedField_Option
                                FROM #TempPloomes_Cliente_Integration_MappedField_Option TempPloomes_Cliente_Integration_MappedField_Option INNER JOIN #TempPloomes_Cliente_Integration_MappedField_OptionDel TempPloomes_Cliente_Integration_MappedField_OptionDel ON TempPloomes_Cliente_Integration_MappedField_Option.ID = TempPloomes_Cliente_Integration_MappedField_OptionDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Integration_MappedField_Option
                            DROP TABLE #TempPloomes_Cliente_Integration_MappedField_OptionDel
                            GO
PRINT 'Running accountId 1 and table [Usuario_Perfil_AccountIntegrationPermission]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempUsuario_Perfil_AccountIntegrationPermission

                            CREATE TABLE #TempUsuario_Perfil_AccountIntegrationPermission
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempUsuario_Perfil_AccountIntegrationPermission (Id)
                            SELECT  [UPA].Id
                            FROM [Usuario_Perfil_AccountIntegrationPermission] UPA INNER JOIN [Ploomes_Cliente_Integration] PCI ON UPA.[AccountIntegrationId] = PCI.[Id]
                            WHERE [PCI].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempUsuario_Perfil_AccountIntegrationPermissionDel
                            CREATE TABLE #TempUsuario_Perfil_AccountIntegrationPermissionDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempUsuario_Perfil_AccountIntegrationPermission))
                            BEGIN
                                TRUNCATE TABLE #TempUsuario_Perfil_AccountIntegrationPermissionDel

                                INSERT #TempUsuario_Perfil_AccountIntegrationPermissionDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempUsuario_Perfil_AccountIntegrationPermission
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempUsuario_Perfil_AccountIntegrationPermissionDel
                                DELETE UPA
                                FROM [Usuario_Perfil_AccountIntegrationPermission] UPA INNER JOIN #TempUsuario_Perfil_AccountIntegrationPermissionDel TempUsuario_Perfil_AccountIntegrationPermissionDel ON [UPA].ID = TempUsuario_Perfil_AccountIntegrationPermissionDel.Id
                                WHERE [UPA].ID >= @MinId AND [UPA].ID <= @MaxId
                                        
                                DELETE #TempUsuario_Perfil_AccountIntegrationPermission
                                FROM #TempUsuario_Perfil_AccountIntegrationPermission TempUsuario_Perfil_AccountIntegrationPermission INNER JOIN #TempUsuario_Perfil_AccountIntegrationPermissionDel TempUsuario_Perfil_AccountIntegrationPermissionDel ON TempUsuario_Perfil_AccountIntegrationPermission.ID = TempUsuario_Perfil_AccountIntegrationPermissionDel.Id
                            END
                            DROP TABLE #TempUsuario_Perfil_AccountIntegrationPermission
                            DROP TABLE #TempUsuario_Perfil_AccountIntegrationPermissionDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Integration_Webhook]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_Webhook

                            CREATE TABLE #TempPloomes_Cliente_Integration_Webhook
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Integration_Webhook (Id)
                            SELECT  [PCIW].Id
                            FROM [Ploomes_Cliente_Integration_Webhook] PCIW INNER JOIN [Ploomes_Cliente_Integration] PCI ON PCIW.[AccountIntegrationId] = PCI.[Id]
                            WHERE [PCI].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_WebhookDel
                            CREATE TABLE #TempPloomes_Cliente_Integration_WebhookDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Integration_Webhook))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_Integration_WebhookDel

                                INSERT #TempPloomes_Cliente_Integration_WebhookDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Integration_Webhook
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_Integration_WebhookDel
                                DELETE PCIW
                                FROM [Ploomes_Cliente_Integration_Webhook] PCIW INNER JOIN #TempPloomes_Cliente_Integration_WebhookDel TempPloomes_Cliente_Integration_WebhookDel ON [PCIW].ID = TempPloomes_Cliente_Integration_WebhookDel.Id
                                WHERE [PCIW].ID >= @MinId AND [PCIW].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Integration_Webhook
                                FROM #TempPloomes_Cliente_Integration_Webhook TempPloomes_Cliente_Integration_Webhook INNER JOIN #TempPloomes_Cliente_Integration_WebhookDel TempPloomes_Cliente_Integration_WebhookDel ON TempPloomes_Cliente_Integration_Webhook.ID = TempPloomes_Cliente_Integration_WebhookDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Integration_Webhook
                            DROP TABLE #TempPloomes_Cliente_Integration_WebhookDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Integration_MappedField]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_MappedField

                            CREATE TABLE #TempPloomes_Cliente_Integration_MappedField
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Integration_MappedField (Id)
                            SELECT  [PCIM].Id
                            FROM [Ploomes_Cliente_Integration_MappedField] PCIM INNER JOIN [Ploomes_Cliente_Integration] PCI ON PCIM.[AccountIntegrationId] = PCI.[Id]
                            WHERE [PCI].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_MappedFieldDel
                            CREATE TABLE #TempPloomes_Cliente_Integration_MappedFieldDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Integration_MappedField))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_Integration_MappedFieldDel

                                INSERT #TempPloomes_Cliente_Integration_MappedFieldDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Integration_MappedField
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_Integration_MappedFieldDel
                                DELETE PCIM
                                FROM [Ploomes_Cliente_Integration_MappedField] PCIM INNER JOIN #TempPloomes_Cliente_Integration_MappedFieldDel TempPloomes_Cliente_Integration_MappedFieldDel ON [PCIM].ID = TempPloomes_Cliente_Integration_MappedFieldDel.Id
                                WHERE [PCIM].ID >= @MinId AND [PCIM].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Integration_MappedField
                                FROM #TempPloomes_Cliente_Integration_MappedField TempPloomes_Cliente_Integration_MappedField INNER JOIN #TempPloomes_Cliente_Integration_MappedFieldDel TempPloomes_Cliente_Integration_MappedFieldDel ON TempPloomes_Cliente_Integration_MappedField.ID = TempPloomes_Cliente_Integration_MappedFieldDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Integration_MappedField
                            DROP TABLE #TempPloomes_Cliente_Integration_MappedFieldDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Integration_Field_Value]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_Field_Value

                            CREATE TABLE #TempPloomes_Cliente_Integration_Field_Value
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Integration_Field_Value (Id)
                            SELECT  [PCIF].Id
                            FROM [Ploomes_Cliente_Integration_Field_Value] PCIF INNER JOIN [Ploomes_Cliente_Integration] PCI ON PCIF.[AccountIntegrationId] = PCI.[Id]
                            WHERE [PCI].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_Field_ValueDel
                            CREATE TABLE #TempPloomes_Cliente_Integration_Field_ValueDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Integration_Field_Value))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_Integration_Field_ValueDel

                                INSERT #TempPloomes_Cliente_Integration_Field_ValueDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Integration_Field_Value
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_Integration_Field_ValueDel
                                DELETE PCIF
                                FROM [Ploomes_Cliente_Integration_Field_Value] PCIF INNER JOIN #TempPloomes_Cliente_Integration_Field_ValueDel TempPloomes_Cliente_Integration_Field_ValueDel ON [PCIF].ID = TempPloomes_Cliente_Integration_Field_ValueDel.Id
                                WHERE [PCIF].ID >= @MinId AND [PCIF].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Integration_Field_Value
                                FROM #TempPloomes_Cliente_Integration_Field_Value TempPloomes_Cliente_Integration_Field_Value INNER JOIN #TempPloomes_Cliente_Integration_Field_ValueDel TempPloomes_Cliente_Integration_Field_ValueDel ON TempPloomes_Cliente_Integration_Field_Value.ID = TempPloomes_Cliente_Integration_Field_ValueDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Integration_Field_Value
                            DROP TABLE #TempPloomes_Cliente_Integration_Field_ValueDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Integration_DynamicMappedField]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_DynamicMappedField

                            CREATE TABLE #TempPloomes_Cliente_Integration_DynamicMappedField
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Integration_DynamicMappedField (Id)
                            SELECT  [PCID].Id
                            FROM [Ploomes_Cliente_Integration_DynamicMappedField] PCID INNER JOIN [Ploomes_Cliente_Integration] PCI ON PCID.[AccountIntegrationId] = PCI.[Id]
                            WHERE [PCI].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_DynamicMappedFieldDel
                            CREATE TABLE #TempPloomes_Cliente_Integration_DynamicMappedFieldDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Integration_DynamicMappedField))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_Integration_DynamicMappedFieldDel

                                INSERT #TempPloomes_Cliente_Integration_DynamicMappedFieldDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Integration_DynamicMappedField
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_Integration_DynamicMappedFieldDel
                                DELETE PCID
                                FROM [Ploomes_Cliente_Integration_DynamicMappedField] PCID INNER JOIN #TempPloomes_Cliente_Integration_DynamicMappedFieldDel TempPloomes_Cliente_Integration_DynamicMappedFieldDel ON [PCID].ID = TempPloomes_Cliente_Integration_DynamicMappedFieldDel.Id
                                WHERE [PCID].ID >= @MinId AND [PCID].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Integration_DynamicMappedField
                                FROM #TempPloomes_Cliente_Integration_DynamicMappedField TempPloomes_Cliente_Integration_DynamicMappedField INNER JOIN #TempPloomes_Cliente_Integration_DynamicMappedFieldDel TempPloomes_Cliente_Integration_DynamicMappedFieldDel ON TempPloomes_Cliente_Integration_DynamicMappedField.ID = TempPloomes_Cliente_Integration_DynamicMappedFieldDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Integration_DynamicMappedField
                            DROP TABLE #TempPloomes_Cliente_Integration_DynamicMappedFieldDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Integration_CustomField]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_CustomField

                            CREATE TABLE #TempPloomes_Cliente_Integration_CustomField
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Integration_CustomField (Id)
                            SELECT  [PCIC].Id
                            FROM [Ploomes_Cliente_Integration_CustomField] PCIC INNER JOIN [Ploomes_Cliente_Integration] PCI ON PCIC.[AccountIntegrationId] = PCI.[Id]
                            WHERE [PCI].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration_CustomFieldDel
                            CREATE TABLE #TempPloomes_Cliente_Integration_CustomFieldDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Integration_CustomField))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_Integration_CustomFieldDel

                                INSERT #TempPloomes_Cliente_Integration_CustomFieldDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Integration_CustomField
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_Integration_CustomFieldDel
                                DELETE PCIC
                                FROM [Ploomes_Cliente_Integration_CustomField] PCIC INNER JOIN #TempPloomes_Cliente_Integration_CustomFieldDel TempPloomes_Cliente_Integration_CustomFieldDel ON [PCIC].ID = TempPloomes_Cliente_Integration_CustomFieldDel.Id
                                WHERE [PCIC].ID >= @MinId AND [PCIC].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Integration_CustomField
                                FROM #TempPloomes_Cliente_Integration_CustomField TempPloomes_Cliente_Integration_CustomField INNER JOIN #TempPloomes_Cliente_Integration_CustomFieldDel TempPloomes_Cliente_Integration_CustomFieldDel ON TempPloomes_Cliente_Integration_CustomField.ID = TempPloomes_Cliente_Integration_CustomFieldDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Integration_CustomField
                            DROP TABLE #TempPloomes_Cliente_Integration_CustomFieldDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Integration]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Integration

                            CREATE TABLE #TempPloomes_Cliente_Integration
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Integration (Id)
                            SELECT  [Ploomes_Cliente_Integration].Id
                            FROM [Ploomes_Cliente_Integration] Ploomes_Cliente_Integration
                            WHERE [Ploomes_Cliente_Integration].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_IntegrationDel
                            CREATE TABLE #TempPloomes_Cliente_IntegrationDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Integration))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_IntegrationDel

                                INSERT #TempPloomes_Cliente_IntegrationDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Integration
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_IntegrationDel
                                DELETE Ploomes_Cliente_Integration
                                FROM [Ploomes_Cliente_Integration] Ploomes_Cliente_Integration INNER JOIN #TempPloomes_Cliente_IntegrationDel TempPloomes_Cliente_IntegrationDel ON [Ploomes_Cliente_Integration].ID = TempPloomes_Cliente_IntegrationDel.Id
                                WHERE [Ploomes_Cliente_Integration].ID >= @MinId AND [Ploomes_Cliente_Integration].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Integration
                                FROM #TempPloomes_Cliente_Integration TempPloomes_Cliente_Integration INNER JOIN #TempPloomes_Cliente_IntegrationDel TempPloomes_Cliente_IntegrationDel ON TempPloomes_Cliente_Integration.ID = TempPloomes_Cliente_IntegrationDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Integration
                            DROP TABLE #TempPloomes_Cliente_IntegrationDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Cancelamento_Motivo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Cancelamento_Motivo

                            CREATE TABLE #TempPloomes_Cliente_Cancelamento_Motivo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Cancelamento_Motivo (Id)
                            SELECT  [Ploomes_Cliente_Cancelamento_Motivo].Id
                            FROM [Ploomes_Cliente_Cancelamento_Motivo] Ploomes_Cliente_Cancelamento_Motivo
                            WHERE [Ploomes_Cliente_Cancelamento_Motivo].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_Cancelamento_MotivoDel
                            CREATE TABLE #TempPloomes_Cliente_Cancelamento_MotivoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Cancelamento_Motivo))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_Cancelamento_MotivoDel

                                INSERT #TempPloomes_Cliente_Cancelamento_MotivoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Cancelamento_Motivo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_Cancelamento_MotivoDel
                                DELETE Ploomes_Cliente_Cancelamento_Motivo
                                FROM [Ploomes_Cliente_Cancelamento_Motivo] Ploomes_Cliente_Cancelamento_Motivo INNER JOIN #TempPloomes_Cliente_Cancelamento_MotivoDel TempPloomes_Cliente_Cancelamento_MotivoDel ON [Ploomes_Cliente_Cancelamento_Motivo].ID = TempPloomes_Cliente_Cancelamento_MotivoDel.Id
                                WHERE [Ploomes_Cliente_Cancelamento_Motivo].ID >= @MinId AND [Ploomes_Cliente_Cancelamento_Motivo].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Cancelamento_Motivo
                                FROM #TempPloomes_Cliente_Cancelamento_Motivo TempPloomes_Cliente_Cancelamento_Motivo INNER JOIN #TempPloomes_Cliente_Cancelamento_MotivoDel TempPloomes_Cliente_Cancelamento_MotivoDel ON TempPloomes_Cliente_Cancelamento_Motivo.ID = TempPloomes_Cliente_Cancelamento_MotivoDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Cancelamento_Motivo
                            DROP TABLE #TempPloomes_Cliente_Cancelamento_MotivoDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente_Bloqueio]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente_Bloqueio

                            CREATE TABLE #TempPloomes_Cliente_Bloqueio
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente_Bloqueio (Id)
                            SELECT  [Ploomes_Cliente_Bloqueio].Id
                            FROM [Ploomes_Cliente_Bloqueio] Ploomes_Cliente_Bloqueio
                            WHERE [Ploomes_Cliente_Bloqueio].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_Cliente_BloqueioDel
                            CREATE TABLE #TempPloomes_Cliente_BloqueioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente_Bloqueio))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_Cliente_BloqueioDel

                                INSERT #TempPloomes_Cliente_BloqueioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente_Bloqueio
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_Cliente_BloqueioDel
                                DELETE Ploomes_Cliente_Bloqueio
                                FROM [Ploomes_Cliente_Bloqueio] Ploomes_Cliente_Bloqueio INNER JOIN #TempPloomes_Cliente_BloqueioDel TempPloomes_Cliente_BloqueioDel ON [Ploomes_Cliente_Bloqueio].ID = TempPloomes_Cliente_BloqueioDel.Id
                                WHERE [Ploomes_Cliente_Bloqueio].ID >= @MinId AND [Ploomes_Cliente_Bloqueio].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente_Bloqueio
                                FROM #TempPloomes_Cliente_Bloqueio TempPloomes_Cliente_Bloqueio INNER JOIN #TempPloomes_Cliente_BloqueioDel TempPloomes_Cliente_BloqueioDel ON TempPloomes_Cliente_Bloqueio.ID = TempPloomes_Cliente_BloqueioDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente_Bloqueio
                            DROP TABLE #TempPloomes_Cliente_BloqueioDel
                            GO
PRINT 'Running accountId 1 and table [Panel_Goal_AllowedUserProfile]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPanel_Goal_AllowedUserProfile

                            CREATE TABLE #TempPanel_Goal_AllowedUserProfile
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPanel_Goal_AllowedUserProfile (Id)
                            SELECT  [PGA].Id
                            FROM [Panel_Goal_AllowedUserProfile] PGA INNER JOIN [Panel_Goal] PG ON PGA.[PanelId] = PG.[Id]
                            WHERE [PG].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPanel_Goal_AllowedUserProfileDel
                            CREATE TABLE #TempPanel_Goal_AllowedUserProfileDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPanel_Goal_AllowedUserProfile))
                            BEGIN
                                TRUNCATE TABLE #TempPanel_Goal_AllowedUserProfileDel

                                INSERT #TempPanel_Goal_AllowedUserProfileDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPanel_Goal_AllowedUserProfile
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPanel_Goal_AllowedUserProfileDel
                                DELETE PGA
                                FROM [Panel_Goal_AllowedUserProfile] PGA INNER JOIN #TempPanel_Goal_AllowedUserProfileDel TempPanel_Goal_AllowedUserProfileDel ON [PGA].ID = TempPanel_Goal_AllowedUserProfileDel.Id
                                WHERE [PGA].ID >= @MinId AND [PGA].ID <= @MaxId
                                        
                                DELETE #TempPanel_Goal_AllowedUserProfile
                                FROM #TempPanel_Goal_AllowedUserProfile TempPanel_Goal_AllowedUserProfile INNER JOIN #TempPanel_Goal_AllowedUserProfileDel TempPanel_Goal_AllowedUserProfileDel ON TempPanel_Goal_AllowedUserProfile.ID = TempPanel_Goal_AllowedUserProfileDel.Id
                            END
                            DROP TABLE #TempPanel_Goal_AllowedUserProfile
                            DROP TABLE #TempPanel_Goal_AllowedUserProfileDel
                            GO
PRINT 'Running accountId 1 and table [Panel_Goal_AllowedUser]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPanel_Goal_AllowedUser

                            CREATE TABLE #TempPanel_Goal_AllowedUser
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPanel_Goal_AllowedUser (Id)
                            SELECT  [PGA].Id
                            FROM [Panel_Goal_AllowedUser] PGA INNER JOIN [Panel_Goal] PG ON PGA.[PanelId] = PG.[Id]
                            WHERE [PG].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPanel_Goal_AllowedUserDel
                            CREATE TABLE #TempPanel_Goal_AllowedUserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPanel_Goal_AllowedUser))
                            BEGIN
                                TRUNCATE TABLE #TempPanel_Goal_AllowedUserDel

                                INSERT #TempPanel_Goal_AllowedUserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPanel_Goal_AllowedUser
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPanel_Goal_AllowedUserDel
                                DELETE PGA
                                FROM [Panel_Goal_AllowedUser] PGA INNER JOIN #TempPanel_Goal_AllowedUserDel TempPanel_Goal_AllowedUserDel ON [PGA].ID = TempPanel_Goal_AllowedUserDel.Id
                                WHERE [PGA].ID >= @MinId AND [PGA].ID <= @MaxId
                                        
                                DELETE #TempPanel_Goal_AllowedUser
                                FROM #TempPanel_Goal_AllowedUser TempPanel_Goal_AllowedUser INNER JOIN #TempPanel_Goal_AllowedUserDel TempPanel_Goal_AllowedUserDel ON TempPanel_Goal_AllowedUser.ID = TempPanel_Goal_AllowedUserDel.Id
                            END
                            DROP TABLE #TempPanel_Goal_AllowedUser
                            DROP TABLE #TempPanel_Goal_AllowedUserDel
                            GO
PRINT 'Running accountId 1 and table [Panel_Goal_AllowedTeam]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPanel_Goal_AllowedTeam

                            CREATE TABLE #TempPanel_Goal_AllowedTeam
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPanel_Goal_AllowedTeam (Id)
                            SELECT  [PGA].Id
                            FROM [Panel_Goal_AllowedTeam] PGA INNER JOIN [Panel_Goal] PG ON PGA.[PanelId] = PG.[Id]
                            WHERE [PG].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPanel_Goal_AllowedTeamDel
                            CREATE TABLE #TempPanel_Goal_AllowedTeamDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPanel_Goal_AllowedTeam))
                            BEGIN
                                TRUNCATE TABLE #TempPanel_Goal_AllowedTeamDel

                                INSERT #TempPanel_Goal_AllowedTeamDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPanel_Goal_AllowedTeam
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPanel_Goal_AllowedTeamDel
                                DELETE PGA
                                FROM [Panel_Goal_AllowedTeam] PGA INNER JOIN #TempPanel_Goal_AllowedTeamDel TempPanel_Goal_AllowedTeamDel ON [PGA].ID = TempPanel_Goal_AllowedTeamDel.Id
                                WHERE [PGA].ID >= @MinId AND [PGA].ID <= @MaxId
                                        
                                DELETE #TempPanel_Goal_AllowedTeam
                                FROM #TempPanel_Goal_AllowedTeam TempPanel_Goal_AllowedTeam INNER JOIN #TempPanel_Goal_AllowedTeamDel TempPanel_Goal_AllowedTeamDel ON TempPanel_Goal_AllowedTeam.ID = TempPanel_Goal_AllowedTeamDel.Id
                            END
                            DROP TABLE #TempPanel_Goal_AllowedTeam
                            DROP TABLE #TempPanel_Goal_AllowedTeamDel
                            GO
PRINT 'Running accountId 1 and table [Panel_Goal]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPanel_Goal

                            CREATE TABLE #TempPanel_Goal
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPanel_Goal (Id)
                            SELECT  [Panel_Goal].Id
                            FROM [Panel_Goal] Panel_Goal
                            WHERE [Panel_Goal].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPanel_GoalDel
                            CREATE TABLE #TempPanel_GoalDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPanel_Goal))
                            BEGIN
                                TRUNCATE TABLE #TempPanel_GoalDel

                                INSERT #TempPanel_GoalDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPanel_Goal
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPanel_GoalDel
                                DELETE Panel_Goal
                                FROM [Panel_Goal] Panel_Goal INNER JOIN #TempPanel_GoalDel TempPanel_GoalDel ON [Panel_Goal].ID = TempPanel_GoalDel.Id
                                WHERE [Panel_Goal].ID >= @MinId AND [Panel_Goal].ID <= @MaxId
                                        
                                DELETE #TempPanel_Goal
                                FROM #TempPanel_Goal TempPanel_Goal INNER JOIN #TempPanel_GoalDel TempPanel_GoalDel ON TempPanel_Goal.ID = TempPanel_GoalDel.Id
                            END
                            DROP TABLE #TempPanel_Goal
                            DROP TABLE #TempPanel_GoalDel
                            GO
PRINT 'Running accountId 1 and table [Panel_Chart_Type_Language_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPanel_Chart_Type_Language_Account

                            CREATE TABLE #TempPanel_Chart_Type_Language_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPanel_Chart_Type_Language_Account (Id)
                            SELECT  [Panel_Chart_Type_Language_Account].Id
                            FROM [Panel_Chart_Type_Language_Account] Panel_Chart_Type_Language_Account
                            WHERE [Panel_Chart_Type_Language_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPanel_Chart_Type_Language_AccountDel
                            CREATE TABLE #TempPanel_Chart_Type_Language_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPanel_Chart_Type_Language_Account))
                            BEGIN
                                TRUNCATE TABLE #TempPanel_Chart_Type_Language_AccountDel

                                INSERT #TempPanel_Chart_Type_Language_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPanel_Chart_Type_Language_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPanel_Chart_Type_Language_AccountDel
                                DELETE Panel_Chart_Type_Language_Account
                                FROM [Panel_Chart_Type_Language_Account] Panel_Chart_Type_Language_Account INNER JOIN #TempPanel_Chart_Type_Language_AccountDel TempPanel_Chart_Type_Language_AccountDel ON [Panel_Chart_Type_Language_Account].ID = TempPanel_Chart_Type_Language_AccountDel.Id
                                WHERE [Panel_Chart_Type_Language_Account].ID >= @MinId AND [Panel_Chart_Type_Language_Account].ID <= @MaxId
                                        
                                DELETE #TempPanel_Chart_Type_Language_Account
                                FROM #TempPanel_Chart_Type_Language_Account TempPanel_Chart_Type_Language_Account INNER JOIN #TempPanel_Chart_Type_Language_AccountDel TempPanel_Chart_Type_Language_AccountDel ON TempPanel_Chart_Type_Language_Account.ID = TempPanel_Chart_Type_Language_AccountDel.Id
                            END
                            DROP TABLE #TempPanel_Chart_Type_Language_Account
                            DROP TABLE #TempPanel_Chart_Type_Language_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Panel_Chart_Metric]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPanel_Chart_Metric

                            CREATE TABLE #TempPanel_Chart_Metric
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPanel_Chart_Metric (Id)
                            SELECT  [PCM].Id
                            FROM [Panel_Chart_Metric] PCM INNER JOIN [Panel_Chart] PC ON PCM.[ChartId] = PC.[Id] INNER JOIN [Panel] P ON PC.[PanelId] = P.[Id] 
                            WHERE [P].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPanel_Chart_MetricDel
                            CREATE TABLE #TempPanel_Chart_MetricDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPanel_Chart_Metric))
                            BEGIN
                                TRUNCATE TABLE #TempPanel_Chart_MetricDel

                                INSERT #TempPanel_Chart_MetricDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPanel_Chart_Metric
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPanel_Chart_MetricDel
                                DELETE PCM
                                FROM [Panel_Chart_Metric] PCM INNER JOIN #TempPanel_Chart_MetricDel TempPanel_Chart_MetricDel ON [PCM].ID = TempPanel_Chart_MetricDel.Id
                                WHERE [PCM].ID >= @MinId AND [PCM].ID <= @MaxId
                                        
                                DELETE #TempPanel_Chart_Metric
                                FROM #TempPanel_Chart_Metric TempPanel_Chart_Metric INNER JOIN #TempPanel_Chart_MetricDel TempPanel_Chart_MetricDel ON TempPanel_Chart_Metric.ID = TempPanel_Chart_MetricDel.Id
                            END
                            DROP TABLE #TempPanel_Chart_Metric
                            DROP TABLE #TempPanel_Chart_MetricDel
                            GO
PRINT 'Running accountId 1 and table [Panel_Chart]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPanel_Chart

                            CREATE TABLE #TempPanel_Chart
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPanel_Chart (Id)
                            SELECT  [PC].Id
                            FROM [Panel_Chart] PC INNER JOIN [Panel] P ON PC.[PanelId] = P.[Id] 
                            WHERE [P].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPanel_ChartDel
                            CREATE TABLE #TempPanel_ChartDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPanel_Chart))
                            BEGIN
                                TRUNCATE TABLE #TempPanel_ChartDel

                                INSERT #TempPanel_ChartDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPanel_Chart
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPanel_ChartDel
                                DELETE PC
                                FROM [Panel_Chart] PC INNER JOIN #TempPanel_ChartDel TempPanel_ChartDel ON [PC].ID = TempPanel_ChartDel.Id
                                WHERE [PC].ID >= @MinId AND [PC].ID <= @MaxId
                                        
                                DELETE #TempPanel_Chart
                                FROM #TempPanel_Chart TempPanel_Chart INNER JOIN #TempPanel_ChartDel TempPanel_ChartDel ON TempPanel_Chart.ID = TempPanel_ChartDel.Id
                            END
                            DROP TABLE #TempPanel_Chart
                            DROP TABLE #TempPanel_ChartDel
                            GO
PRINT 'Running accountId 1 and table [Panel]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPanel

                            CREATE TABLE #TempPanel
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPanel (Id)
                            SELECT  [Panel].Id
                            FROM [Panel] Panel
                            WHERE [Panel].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPanelDel
                            CREATE TABLE #TempPanelDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPanel))
                            BEGIN
                                TRUNCATE TABLE #TempPanelDel

                                INSERT #TempPanelDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPanel
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPanelDel
                                DELETE Panel
                                FROM [Panel] Panel INNER JOIN #TempPanelDel TempPanelDel ON [Panel].ID = TempPanelDel.Id
                                WHERE [Panel].ID >= @MinId AND [Panel].ID <= @MaxId
                                        
                                DELETE #TempPanel
                                FROM #TempPanel TempPanel INNER JOIN #TempPanelDel TempPanelDel ON TempPanel.ID = TempPanelDel.Id
                            END
                            DROP TABLE #TempPanel
                            DROP TABLE #TempPanelDel
                            GO
PRINT 'Running accountId 1 and table [OtherPropertyLog]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOtherPropertyLog

                            CREATE TABLE #TempOtherPropertyLog
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOtherPropertyLog (Id)
                            SELECT  [OtherPropertyLog].Id
                            FROM [OtherPropertyLog] OtherPropertyLog
                            WHERE [OtherPropertyLog].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOtherPropertyLogDel
                            CREATE TABLE #TempOtherPropertyLogDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOtherPropertyLog))
                            BEGIN
                                TRUNCATE TABLE #TempOtherPropertyLogDel

                                INSERT #TempOtherPropertyLogDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOtherPropertyLog
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOtherPropertyLogDel
                                DELETE OtherPropertyLog
                                FROM [OtherPropertyLog] OtherPropertyLog INNER JOIN #TempOtherPropertyLogDel TempOtherPropertyLogDel ON [OtherPropertyLog].ID = TempOtherPropertyLogDel.Id
                                WHERE [OtherPropertyLog].ID >= @MinId AND [OtherPropertyLog].ID <= @MaxId
                                        
                                DELETE #TempOtherPropertyLog
                                FROM #TempOtherPropertyLog TempOtherPropertyLog INNER JOIN #TempOtherPropertyLogDel TempOtherPropertyLogDel ON TempOtherPropertyLog.ID = TempOtherPropertyLogDel.Id
                            END
                            DROP TABLE #TempOtherPropertyLog
                            DROP TABLE #TempOtherPropertyLogDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Status]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Status

                            CREATE TABLE #TempOportunidade_Status
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Status (Id)
                            SELECT  [Oportunidade_Status].Id
                            FROM [Oportunidade_Status] Oportunidade_Status
                            WHERE [Oportunidade_Status].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_StatusDel
                            CREATE TABLE #TempOportunidade_StatusDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Status))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_StatusDel

                                INSERT #TempOportunidade_StatusDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Status
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_StatusDel
                                DELETE Oportunidade_Status
                                FROM [Oportunidade_Status] Oportunidade_Status INNER JOIN #TempOportunidade_StatusDel TempOportunidade_StatusDel ON [Oportunidade_Status].ID = TempOportunidade_StatusDel.Id
                                WHERE [Oportunidade_Status].ID >= @MinId AND [Oportunidade_Status].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Status
                                FROM #TempOportunidade_Status TempOportunidade_Status INNER JOIN #TempOportunidade_StatusDel TempOportunidade_StatusDel ON TempOportunidade_Status.ID = TempOportunidade_StatusDel.Id
                            END
                            DROP TABLE #TempOportunidade_Status
                            DROP TABLE #TempOportunidade_StatusDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_MotivoPerda]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_MotivoPerda

                            CREATE TABLE #TempOportunidade_MotivoPerda
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_MotivoPerda (Id)
                            SELECT  [Oportunidade_MotivoPerda].Id
                            FROM [Oportunidade_MotivoPerda] Oportunidade_MotivoPerda
                            WHERE [Oportunidade_MotivoPerda].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_MotivoPerdaDel
                            CREATE TABLE #TempOportunidade_MotivoPerdaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_MotivoPerda))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_MotivoPerdaDel

                                INSERT #TempOportunidade_MotivoPerdaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_MotivoPerda
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_MotivoPerdaDel
                                DELETE Oportunidade_MotivoPerda
                                FROM [Oportunidade_MotivoPerda] Oportunidade_MotivoPerda INNER JOIN #TempOportunidade_MotivoPerdaDel TempOportunidade_MotivoPerdaDel ON [Oportunidade_MotivoPerda].ID = TempOportunidade_MotivoPerdaDel.Id
                                WHERE [Oportunidade_MotivoPerda].ID >= @MinId AND [Oportunidade_MotivoPerda].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_MotivoPerda
                                FROM #TempOportunidade_MotivoPerda TempOportunidade_MotivoPerda INNER JOIN #TempOportunidade_MotivoPerdaDel TempOportunidade_MotivoPerdaDel ON TempOportunidade_MotivoPerda.ID = TempOportunidade_MotivoPerdaDel.Id
                            END
                            DROP TABLE #TempOportunidade_MotivoPerda
                            DROP TABLE #TempOportunidade_MotivoPerdaDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Funil_Tabela]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Funil_Tabela

                            CREATE TABLE #TempOportunidade_Funil_Tabela
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Funil_Tabela (Id)
                            SELECT  [OFT].Id
                            FROM [Oportunidade_Funil_Tabela] OFT INNER JOIN [Oportunidade_Funil] F ON OFT.[ID_Funil] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_Funil_TabelaDel
                            CREATE TABLE #TempOportunidade_Funil_TabelaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Funil_Tabela))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_Funil_TabelaDel

                                INSERT #TempOportunidade_Funil_TabelaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Funil_Tabela
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_Funil_TabelaDel
                                DELETE OFT
                                FROM [Oportunidade_Funil_Tabela] OFT INNER JOIN #TempOportunidade_Funil_TabelaDel TempOportunidade_Funil_TabelaDel ON [OFT].ID = TempOportunidade_Funil_TabelaDel.Id
                                WHERE [OFT].ID >= @MinId AND [OFT].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Funil_Tabela
                                FROM #TempOportunidade_Funil_Tabela TempOportunidade_Funil_Tabela INNER JOIN #TempOportunidade_Funil_TabelaDel TempOportunidade_Funil_TabelaDel ON TempOportunidade_Funil_Tabela.ID = TempOportunidade_Funil_TabelaDel.Id
                            END
                            DROP TABLE #TempOportunidade_Funil_Tabela
                            DROP TABLE #TempOportunidade_Funil_TabelaDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Funil_Permissao_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Funil_Permissao_Usuario

                            CREATE TABLE #TempOportunidade_Funil_Permissao_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Funil_Permissao_Usuario (Id)
                            SELECT  [OFPU].Id
                            FROM [Oportunidade_Funil_Permissao_Usuario] OFPU INNER JOIN [Oportunidade_Funil] F ON OFPU.[ID_Funil] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_Funil_Permissao_UsuarioDel
                            CREATE TABLE #TempOportunidade_Funil_Permissao_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Funil_Permissao_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_Funil_Permissao_UsuarioDel

                                INSERT #TempOportunidade_Funil_Permissao_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Funil_Permissao_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_Funil_Permissao_UsuarioDel
                                DELETE OFPU
                                FROM [Oportunidade_Funil_Permissao_Usuario] OFPU INNER JOIN #TempOportunidade_Funil_Permissao_UsuarioDel TempOportunidade_Funil_Permissao_UsuarioDel ON [OFPU].ID = TempOportunidade_Funil_Permissao_UsuarioDel.Id
                                WHERE [OFPU].ID >= @MinId AND [OFPU].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Funil_Permissao_Usuario
                                FROM #TempOportunidade_Funil_Permissao_Usuario TempOportunidade_Funil_Permissao_Usuario INNER JOIN #TempOportunidade_Funil_Permissao_UsuarioDel TempOportunidade_Funil_Permissao_UsuarioDel ON TempOportunidade_Funil_Permissao_Usuario.ID = TempOportunidade_Funil_Permissao_UsuarioDel.Id
                            END
                            DROP TABLE #TempOportunidade_Funil_Permissao_Usuario
                            DROP TABLE #TempOportunidade_Funil_Permissao_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Funil_Permissao_Equipe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Funil_Permissao_Equipe

                            CREATE TABLE #TempOportunidade_Funil_Permissao_Equipe
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Funil_Permissao_Equipe (Id)
                            SELECT  [OFPE].Id
                            FROM [Oportunidade_Funil_Permissao_Equipe] OFPE INNER JOIN [Oportunidade_Funil] F ON OFPE.[ID_Funil] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_Funil_Permissao_EquipeDel
                            CREATE TABLE #TempOportunidade_Funil_Permissao_EquipeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Funil_Permissao_Equipe))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_Funil_Permissao_EquipeDel

                                INSERT #TempOportunidade_Funil_Permissao_EquipeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Funil_Permissao_Equipe
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_Funil_Permissao_EquipeDel
                                DELETE OFPE
                                FROM [Oportunidade_Funil_Permissao_Equipe] OFPE INNER JOIN #TempOportunidade_Funil_Permissao_EquipeDel TempOportunidade_Funil_Permissao_EquipeDel ON [OFPE].ID = TempOportunidade_Funil_Permissao_EquipeDel.Id
                                WHERE [OFPE].ID >= @MinId AND [OFPE].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Funil_Permissao_Equipe
                                FROM #TempOportunidade_Funil_Permissao_Equipe TempOportunidade_Funil_Permissao_Equipe INNER JOIN #TempOportunidade_Funil_Permissao_EquipeDel TempOportunidade_Funil_Permissao_EquipeDel ON TempOportunidade_Funil_Permissao_Equipe.ID = TempOportunidade_Funil_Permissao_EquipeDel.Id
                            END
                            DROP TABLE #TempOportunidade_Funil_Permissao_Equipe
                            DROP TABLE #TempOportunidade_Funil_Permissao_EquipeDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Funil_AllowedPipeline]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Funil_AllowedPipeline

                            CREATE TABLE #TempOportunidade_Funil_AllowedPipeline
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Funil_AllowedPipeline (Id)
                            SELECT  [OFA].Id
                            FROM [Oportunidade_Funil_AllowedPipeline] OFA INNER JOIN [Oportunidade_Funil] F ON OFA.[PipelineId] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_Funil_AllowedPipelineDel
                            CREATE TABLE #TempOportunidade_Funil_AllowedPipelineDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Funil_AllowedPipeline))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_Funil_AllowedPipelineDel

                                INSERT #TempOportunidade_Funil_AllowedPipelineDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Funil_AllowedPipeline
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_Funil_AllowedPipelineDel
                                DELETE OFA
                                FROM [Oportunidade_Funil_AllowedPipeline] OFA INNER JOIN #TempOportunidade_Funil_AllowedPipelineDel TempOportunidade_Funil_AllowedPipelineDel ON [OFA].ID = TempOportunidade_Funil_AllowedPipelineDel.Id
                                WHERE [OFA].ID >= @MinId AND [OFA].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Funil_AllowedPipeline
                                FROM #TempOportunidade_Funil_AllowedPipeline TempOportunidade_Funil_AllowedPipeline INNER JOIN #TempOportunidade_Funil_AllowedPipelineDel TempOportunidade_Funil_AllowedPipelineDel ON TempOportunidade_Funil_AllowedPipeline.ID = TempOportunidade_Funil_AllowedPipelineDel.Id
                            END
                            DROP TABLE #TempOportunidade_Funil_AllowedPipeline
                            DROP TABLE #TempOportunidade_Funil_AllowedPipelineDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Funil_AllowedDocumentTemplate]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Funil_AllowedDocumentTemplate

                            CREATE TABLE #TempOportunidade_Funil_AllowedDocumentTemplate
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Funil_AllowedDocumentTemplate (Id)
                            SELECT  [OFA].Id
                            FROM [Oportunidade_Funil_AllowedDocumentTemplate] OFA INNER JOIN [Oportunidade_Funil] F ON OFA.[PipelineId] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_Funil_AllowedDocumentTemplateDel
                            CREATE TABLE #TempOportunidade_Funil_AllowedDocumentTemplateDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Funil_AllowedDocumentTemplate))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_Funil_AllowedDocumentTemplateDel

                                INSERT #TempOportunidade_Funil_AllowedDocumentTemplateDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Funil_AllowedDocumentTemplate
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_Funil_AllowedDocumentTemplateDel
                                DELETE OFA
                                FROM [Oportunidade_Funil_AllowedDocumentTemplate] OFA INNER JOIN #TempOportunidade_Funil_AllowedDocumentTemplateDel TempOportunidade_Funil_AllowedDocumentTemplateDel ON [OFA].ID = TempOportunidade_Funil_AllowedDocumentTemplateDel.Id
                                WHERE [OFA].ID >= @MinId AND [OFA].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Funil_AllowedDocumentTemplate
                                FROM #TempOportunidade_Funil_AllowedDocumentTemplate TempOportunidade_Funil_AllowedDocumentTemplate INNER JOIN #TempOportunidade_Funil_AllowedDocumentTemplateDel TempOportunidade_Funil_AllowedDocumentTemplateDel ON TempOportunidade_Funil_AllowedDocumentTemplate.ID = TempOportunidade_Funil_AllowedDocumentTemplateDel.Id
                            END
                            DROP TABLE #TempOportunidade_Funil_AllowedDocumentTemplate
                            DROP TABLE #TempOportunidade_Funil_AllowedDocumentTemplateDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Funil]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Funil

                            CREATE TABLE #TempOportunidade_Funil
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Funil (Id)
                            SELECT  [Oportunidade_Funil].Id
                            FROM [Oportunidade_Funil] Oportunidade_Funil
                            WHERE [Oportunidade_Funil].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_FunilDel
                            CREATE TABLE #TempOportunidade_FunilDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Funil))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_FunilDel

                                INSERT #TempOportunidade_FunilDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Funil
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_FunilDel
                                DELETE Oportunidade_Funil
                                FROM [Oportunidade_Funil] Oportunidade_Funil INNER JOIN #TempOportunidade_FunilDel TempOportunidade_FunilDel ON [Oportunidade_Funil].ID = TempOportunidade_FunilDel.Id
                                WHERE [Oportunidade_Funil].ID >= @MinId AND [Oportunidade_Funil].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Funil
                                FROM #TempOportunidade_Funil TempOportunidade_Funil INNER JOIN #TempOportunidade_FunilDel TempOportunidade_FunilDel ON TempOportunidade_Funil.ID = TempOportunidade_FunilDel.Id
                            END
                            DROP TABLE #TempOportunidade_Funil
                            DROP TABLE #TempOportunidade_FunilDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Valor_Historico]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Valor_Historico

                            CREATE TABLE #TempOportunidade_Valor_Historico
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Valor_Historico (Id)
                            SELECT  [OVH].Id
                            FROM [Oportunidade_Valor_Historico] OVH INNER JOIN [Oportunidade] O ON OVH.[ID_Oportunidade] = O.[ID]
                            WHERE [O].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_Valor_HistoricoDel
                            CREATE TABLE #TempOportunidade_Valor_HistoricoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Valor_Historico))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_Valor_HistoricoDel

                                INSERT #TempOportunidade_Valor_HistoricoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Valor_Historico
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_Valor_HistoricoDel
                                DELETE OVH
                                FROM [Oportunidade_Valor_Historico] OVH INNER JOIN #TempOportunidade_Valor_HistoricoDel TempOportunidade_Valor_HistoricoDel ON [OVH].ID = TempOportunidade_Valor_HistoricoDel.Id
                                WHERE [OVH].ID >= @MinId AND [OVH].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Valor_Historico
                                FROM #TempOportunidade_Valor_Historico TempOportunidade_Valor_Historico INNER JOIN #TempOportunidade_Valor_HistoricoDel TempOportunidade_Valor_HistoricoDel ON TempOportunidade_Valor_Historico.ID = TempOportunidade_Valor_HistoricoDel.Id
                            END
                            DROP TABLE #TempOportunidade_Valor_Historico
                            DROP TABLE #TempOportunidade_Valor_HistoricoDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Status_Historico]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Status_Historico

                            CREATE TABLE #TempOportunidade_Status_Historico
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Status_Historico (Id)
                            SELECT  [OSH].Id
                            FROM [Oportunidade_Status_Historico] OSH INNER JOIN [Oportunidade] O ON OSH.[ID_Oportunidade] = O.[ID]
                            WHERE [O].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_Status_HistoricoDel
                            CREATE TABLE #TempOportunidade_Status_HistoricoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Status_Historico))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_Status_HistoricoDel

                                INSERT #TempOportunidade_Status_HistoricoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Status_Historico
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_Status_HistoricoDel
                                DELETE OSH
                                FROM [Oportunidade_Status_Historico] OSH INNER JOIN #TempOportunidade_Status_HistoricoDel TempOportunidade_Status_HistoricoDel ON [OSH].ID = TempOportunidade_Status_HistoricoDel.Id
                                WHERE [OSH].ID >= @MinId AND [OSH].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Status_Historico
                                FROM #TempOportunidade_Status_Historico TempOportunidade_Status_Historico INNER JOIN #TempOportunidade_Status_HistoricoDel TempOportunidade_Status_HistoricoDel ON TempOportunidade_Status_Historico.ID = TempOportunidade_Status_HistoricoDel.Id
                            END
                            DROP TABLE #TempOportunidade_Status_Historico
                            DROP TABLE #TempOportunidade_Status_HistoricoDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Produto]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Produto

                            CREATE TABLE #TempOportunidade_Produto
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Produto (Id)
                            SELECT  [OP].Id
                            FROM [Oportunidade_Produto] OP INNER JOIN [Oportunidade] O ON OP.[ID_Oportunidade] = O.[ID]
                            WHERE [O].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_ProdutoDel
                            CREATE TABLE #TempOportunidade_ProdutoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Produto))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_ProdutoDel

                                INSERT #TempOportunidade_ProdutoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Produto
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_ProdutoDel
                                DELETE OP
                                FROM [Oportunidade_Produto] OP INNER JOIN #TempOportunidade_ProdutoDel TempOportunidade_ProdutoDel ON [OP].ID = TempOportunidade_ProdutoDel.Id
                                WHERE [OP].ID >= @MinId AND [OP].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Produto
                                FROM #TempOportunidade_Produto TempOportunidade_Produto INNER JOIN #TempOportunidade_ProdutoDel TempOportunidade_ProdutoDel ON TempOportunidade_Produto.ID = TempOportunidade_ProdutoDel.Id
                            END
                            DROP TABLE #TempOportunidade_Produto
                            DROP TABLE #TempOportunidade_ProdutoDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_ContactProduct]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_ContactProduct

                            CREATE TABLE #TempOportunidade_ContactProduct
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_ContactProduct (Id)
                            SELECT  [OC].Id
                            FROM [Oportunidade_ContactProduct] OC INNER JOIN [Oportunidade] O ON OC.[DealId] = O.[ID]
                            WHERE [O].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_ContactProductDel
                            CREATE TABLE #TempOportunidade_ContactProductDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_ContactProduct))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_ContactProductDel

                                INSERT #TempOportunidade_ContactProductDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_ContactProduct
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_ContactProductDel
                                DELETE OC
                                FROM [Oportunidade_ContactProduct] OC INNER JOIN #TempOportunidade_ContactProductDel TempOportunidade_ContactProductDel ON [OC].ID = TempOportunidade_ContactProductDel.Id
                                WHERE [OC].ID >= @MinId AND [OC].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_ContactProduct
                                FROM #TempOportunidade_ContactProduct TempOportunidade_ContactProduct INNER JOIN #TempOportunidade_ContactProductDel TempOportunidade_ContactProductDel ON TempOportunidade_ContactProduct.ID = TempOportunidade_ContactProductDel.Id
                            END
                            DROP TABLE #TempOportunidade_ContactProduct
                            DROP TABLE #TempOportunidade_ContactProductDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Status_Oportunidade]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Status_Oportunidade

                            CREATE TABLE #TempOportunidade_Status_Oportunidade
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Status_Oportunidade (Id)
                            SELECT  [OSO].Id
                            FROM [Oportunidade_Status_Oportunidade] OSO INNER JOIN [Oportunidade] O ON OSO.[ID_Oportunidade] = O.[ID]
                            WHERE [O].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_Status_OportunidadeDel
                            CREATE TABLE #TempOportunidade_Status_OportunidadeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Status_Oportunidade))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_Status_OportunidadeDel

                                INSERT #TempOportunidade_Status_OportunidadeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Status_Oportunidade
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_Status_OportunidadeDel
                                DELETE OSO
                                FROM [Oportunidade_Status_Oportunidade] OSO INNER JOIN #TempOportunidade_Status_OportunidadeDel TempOportunidade_Status_OportunidadeDel ON [OSO].ID = TempOportunidade_Status_OportunidadeDel.Id
                                WHERE [OSO].ID >= @MinId AND [OSO].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Status_Oportunidade
                                FROM #TempOportunidade_Status_Oportunidade TempOportunidade_Status_Oportunidade INNER JOIN #TempOportunidade_Status_OportunidadeDel TempOportunidade_Status_OportunidadeDel ON TempOportunidade_Status_Oportunidade.ID = TempOportunidade_Status_OportunidadeDel.Id
                            END
                            DROP TABLE #TempOportunidade_Status_Oportunidade
                            DROP TABLE #TempOportunidade_Status_OportunidadeDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade

                            CREATE TABLE #TempOportunidade
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade (Id)
                            SELECT  [Oportunidade].Id
                            FROM [Oportunidade] Oportunidade
                            WHERE [Oportunidade].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidadeDel
                            CREATE TABLE #TempOportunidadeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidadeDel

                                INSERT #TempOportunidadeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidadeDel
                                DELETE Oportunidade
                                FROM [Oportunidade] Oportunidade INNER JOIN #TempOportunidadeDel TempOportunidadeDel ON [Oportunidade].ID = TempOportunidadeDel.Id
                                WHERE [Oportunidade].ID >= @MinId AND [Oportunidade].ID <= @MaxId
                                        
                                DELETE #TempOportunidade
                                FROM #TempOportunidade TempOportunidade INNER JOIN #TempOportunidadeDel TempOportunidadeDel ON TempOportunidade.ID = TempOportunidadeDel.Id
                            END
                            DROP TABLE #TempOportunidade
                            DROP TABLE #TempOportunidadeDel
                            GO
PRINT 'Running accountId 1 and table [Notificacao_Tipo_Entidade_Cultura_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempNotificacao_Tipo_Entidade_Cultura_Account

                            CREATE TABLE #TempNotificacao_Tipo_Entidade_Cultura_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempNotificacao_Tipo_Entidade_Cultura_Account (Id)
                            SELECT  [Notificacao_Tipo_Entidade_Cultura_Account].Id
                            FROM [Notificacao_Tipo_Entidade_Cultura_Account] Notificacao_Tipo_Entidade_Cultura_Account
                            WHERE [Notificacao_Tipo_Entidade_Cultura_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempNotificacao_Tipo_Entidade_Cultura_AccountDel
                            CREATE TABLE #TempNotificacao_Tipo_Entidade_Cultura_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempNotificacao_Tipo_Entidade_Cultura_Account))
                            BEGIN
                                TRUNCATE TABLE #TempNotificacao_Tipo_Entidade_Cultura_AccountDel

                                INSERT #TempNotificacao_Tipo_Entidade_Cultura_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempNotificacao_Tipo_Entidade_Cultura_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempNotificacao_Tipo_Entidade_Cultura_AccountDel
                                DELETE Notificacao_Tipo_Entidade_Cultura_Account
                                FROM [Notificacao_Tipo_Entidade_Cultura_Account] Notificacao_Tipo_Entidade_Cultura_Account INNER JOIN #TempNotificacao_Tipo_Entidade_Cultura_AccountDel TempNotificacao_Tipo_Entidade_Cultura_AccountDel ON [Notificacao_Tipo_Entidade_Cultura_Account].ID = TempNotificacao_Tipo_Entidade_Cultura_AccountDel.Id
                                WHERE [Notificacao_Tipo_Entidade_Cultura_Account].ID >= @MinId AND [Notificacao_Tipo_Entidade_Cultura_Account].ID <= @MaxId
                                        
                                DELETE #TempNotificacao_Tipo_Entidade_Cultura_Account
                                FROM #TempNotificacao_Tipo_Entidade_Cultura_Account TempNotificacao_Tipo_Entidade_Cultura_Account INNER JOIN #TempNotificacao_Tipo_Entidade_Cultura_AccountDel TempNotificacao_Tipo_Entidade_Cultura_AccountDel ON TempNotificacao_Tipo_Entidade_Cultura_Account.ID = TempNotificacao_Tipo_Entidade_Cultura_AccountDel.Id
                            END
                            DROP TABLE #TempNotificacao_Tipo_Entidade_Cultura_Account
                            DROP TABLE #TempNotificacao_Tipo_Entidade_Cultura_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Notificacao_Tipo_Cultura_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempNotificacao_Tipo_Cultura_Account

                            CREATE TABLE #TempNotificacao_Tipo_Cultura_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempNotificacao_Tipo_Cultura_Account (Id)
                            SELECT  [Notificacao_Tipo_Cultura_Account].Id
                            FROM [Notificacao_Tipo_Cultura_Account] Notificacao_Tipo_Cultura_Account
                            WHERE [Notificacao_Tipo_Cultura_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempNotificacao_Tipo_Cultura_AccountDel
                            CREATE TABLE #TempNotificacao_Tipo_Cultura_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempNotificacao_Tipo_Cultura_Account))
                            BEGIN
                                TRUNCATE TABLE #TempNotificacao_Tipo_Cultura_AccountDel

                                INSERT #TempNotificacao_Tipo_Cultura_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempNotificacao_Tipo_Cultura_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempNotificacao_Tipo_Cultura_AccountDel
                                DELETE Notificacao_Tipo_Cultura_Account
                                FROM [Notificacao_Tipo_Cultura_Account] Notificacao_Tipo_Cultura_Account INNER JOIN #TempNotificacao_Tipo_Cultura_AccountDel TempNotificacao_Tipo_Cultura_AccountDel ON [Notificacao_Tipo_Cultura_Account].ID = TempNotificacao_Tipo_Cultura_AccountDel.Id
                                WHERE [Notificacao_Tipo_Cultura_Account].ID >= @MinId AND [Notificacao_Tipo_Cultura_Account].ID <= @MaxId
                                        
                                DELETE #TempNotificacao_Tipo_Cultura_Account
                                FROM #TempNotificacao_Tipo_Cultura_Account TempNotificacao_Tipo_Cultura_Account INNER JOIN #TempNotificacao_Tipo_Cultura_AccountDel TempNotificacao_Tipo_Cultura_AccountDel ON TempNotificacao_Tipo_Cultura_Account.ID = TempNotificacao_Tipo_Cultura_AccountDel.Id
                            END
                            DROP TABLE #TempNotificacao_Tipo_Cultura_Account
                            DROP TABLE #TempNotificacao_Tipo_Cultura_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Moeda]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempMoeda

                            CREATE TABLE #TempMoeda
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempMoeda (Id)
                            SELECT  [Moeda].Id
                            FROM [Moeda] Moeda
                            WHERE [Moeda].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempMoedaDel
                            CREATE TABLE #TempMoedaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempMoeda))
                            BEGIN
                                TRUNCATE TABLE #TempMoedaDel

                                INSERT #TempMoedaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempMoeda
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempMoedaDel
                                DELETE Moeda
                                FROM [Moeda] Moeda INNER JOIN #TempMoedaDel TempMoedaDel ON [Moeda].ID = TempMoedaDel.Id
                                WHERE [Moeda].ID >= @MinId AND [Moeda].ID <= @MaxId
                                        
                                DELETE #TempMoeda
                                FROM #TempMoeda TempMoeda INNER JOIN #TempMoedaDel TempMoedaDel ON TempMoeda.ID = TempMoedaDel.Id
                            END
                            DROP TABLE #TempMoeda
                            DROP TABLE #TempMoedaDel
                            GO
PRINT 'Running accountId 1 and table [Marcador_Item]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempMarcador_Item

                            CREATE TABLE #TempMarcador_Item
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempMarcador_Item (Id)
                            SELECT  [MI].Id
                            FROM [Marcador_Item] MI INNER JOIN [Marcador] M ON MI.[ID_Marcador] = M.[ID]
                            WHERE [M].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempMarcador_ItemDel
                            CREATE TABLE #TempMarcador_ItemDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempMarcador_Item))
                            BEGIN
                                TRUNCATE TABLE #TempMarcador_ItemDel

                                INSERT #TempMarcador_ItemDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempMarcador_Item
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempMarcador_ItemDel
                                DELETE MI
                                FROM [Marcador_Item] MI INNER JOIN #TempMarcador_ItemDel TempMarcador_ItemDel ON [MI].ID = TempMarcador_ItemDel.Id
                                WHERE [MI].ID >= @MinId AND [MI].ID <= @MaxId
                                        
                                DELETE #TempMarcador_Item
                                FROM #TempMarcador_Item TempMarcador_Item INNER JOIN #TempMarcador_ItemDel TempMarcador_ItemDel ON TempMarcador_Item.ID = TempMarcador_ItemDel.Id
                            END
                            DROP TABLE #TempMarcador_Item
                            DROP TABLE #TempMarcador_ItemDel
                            GO
PRINT 'Running accountId 1 and table [Marcador]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempMarcador

                            CREATE TABLE #TempMarcador
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempMarcador (Id)
                            SELECT  [Marcador].Id
                            FROM [Marcador] Marcador
                            WHERE [Marcador].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempMarcadorDel
                            CREATE TABLE #TempMarcadorDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempMarcador))
                            BEGIN
                                TRUNCATE TABLE #TempMarcadorDel

                                INSERT #TempMarcadorDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempMarcador
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempMarcadorDel
                                DELETE Marcador
                                FROM [Marcador] Marcador INNER JOIN #TempMarcadorDel TempMarcadorDel ON [Marcador].ID = TempMarcadorDel.Id
                                WHERE [Marcador].ID >= @MinId AND [Marcador].ID <= @MaxId
                                        
                                DELETE #TempMarcador
                                FROM #TempMarcador TempMarcador INNER JOIN #TempMarcadorDel TempMarcadorDel ON TempMarcador.ID = TempMarcadorDel.Id
                            END
                            DROP TABLE #TempMarcador
                            DROP TABLE #TempMarcadorDel
                            GO
PRINT 'Running accountId 1 and table [Lead_Status_Cultura_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempLead_Status_Cultura_Account

                            CREATE TABLE #TempLead_Status_Cultura_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempLead_Status_Cultura_Account (Id)
                            SELECT  [Lead_Status_Cultura_Account].Id
                            FROM [Lead_Status_Cultura_Account] Lead_Status_Cultura_Account
                            WHERE [Lead_Status_Cultura_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempLead_Status_Cultura_AccountDel
                            CREATE TABLE #TempLead_Status_Cultura_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempLead_Status_Cultura_Account))
                            BEGIN
                                TRUNCATE TABLE #TempLead_Status_Cultura_AccountDel

                                INSERT #TempLead_Status_Cultura_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempLead_Status_Cultura_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempLead_Status_Cultura_AccountDel
                                DELETE Lead_Status_Cultura_Account
                                FROM [Lead_Status_Cultura_Account] Lead_Status_Cultura_Account INNER JOIN #TempLead_Status_Cultura_AccountDel TempLead_Status_Cultura_AccountDel ON [Lead_Status_Cultura_Account].ID = TempLead_Status_Cultura_AccountDel.Id
                                WHERE [Lead_Status_Cultura_Account].ID >= @MinId AND [Lead_Status_Cultura_Account].ID <= @MaxId
                                        
                                DELETE #TempLead_Status_Cultura_Account
                                FROM #TempLead_Status_Cultura_Account TempLead_Status_Cultura_Account INNER JOIN #TempLead_Status_Cultura_AccountDel TempLead_Status_Cultura_AccountDel ON TempLead_Status_Cultura_Account.ID = TempLead_Status_Cultura_AccountDel.Id
                            END
                            DROP TABLE #TempLead_Status_Cultura_Account
                            DROP TABLE #TempLead_Status_Cultura_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Lead_Status]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempLead_Status

                            CREATE TABLE #TempLead_Status
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempLead_Status (Id)
                            SELECT  [Lead_Status].Id
                            FROM [Lead_Status] Lead_Status
                            WHERE [Lead_Status].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempLead_StatusDel
                            CREATE TABLE #TempLead_StatusDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempLead_Status))
                            BEGIN
                                TRUNCATE TABLE #TempLead_StatusDel

                                INSERT #TempLead_StatusDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempLead_Status
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempLead_StatusDel
                                DELETE Lead_Status
                                FROM [Lead_Status] Lead_Status INNER JOIN #TempLead_StatusDel TempLead_StatusDel ON [Lead_Status].ID = TempLead_StatusDel.Id
                                WHERE [Lead_Status].ID >= @MinId AND [Lead_Status].ID <= @MaxId
                                        
                                DELETE #TempLead_Status
                                FROM #TempLead_Status TempLead_Status INNER JOIN #TempLead_StatusDel TempLead_StatusDel ON TempLead_Status.ID = TempLead_StatusDel.Id
                            END
                            DROP TABLE #TempLead_Status
                            DROP TABLE #TempLead_StatusDel
                            GO
PRINT 'Running accountId 1 and table [Lead_MotivoDescarte]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempLead_MotivoDescarte

                            CREATE TABLE #TempLead_MotivoDescarte
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempLead_MotivoDescarte (Id)
                            SELECT  [Lead_MotivoDescarte].Id
                            FROM [Lead_MotivoDescarte] Lead_MotivoDescarte
                            WHERE [Lead_MotivoDescarte].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempLead_MotivoDescarteDel
                            CREATE TABLE #TempLead_MotivoDescarteDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempLead_MotivoDescarte))
                            BEGIN
                                TRUNCATE TABLE #TempLead_MotivoDescarteDel

                                INSERT #TempLead_MotivoDescarteDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempLead_MotivoDescarte
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempLead_MotivoDescarteDel
                                DELETE Lead_MotivoDescarte
                                FROM [Lead_MotivoDescarte] Lead_MotivoDescarte INNER JOIN #TempLead_MotivoDescarteDel TempLead_MotivoDescarteDel ON [Lead_MotivoDescarte].ID = TempLead_MotivoDescarteDel.Id
                                WHERE [Lead_MotivoDescarte].ID >= @MinId AND [Lead_MotivoDescarte].ID <= @MaxId
                                        
                                DELETE #TempLead_MotivoDescarte
                                FROM #TempLead_MotivoDescarte TempLead_MotivoDescarte INNER JOIN #TempLead_MotivoDescarteDel TempLead_MotivoDescarteDel ON TempLead_MotivoDescarte.ID = TempLead_MotivoDescarteDel.Id
                            END
                            DROP TABLE #TempLead_MotivoDescarte
                            DROP TABLE #TempLead_MotivoDescarteDel
                            GO
PRINT 'Running accountId 1 and table [Lead_Etiqueta_FiltroUsuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempLead_Etiqueta_FiltroUsuario

                            CREATE TABLE #TempLead_Etiqueta_FiltroUsuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempLead_Etiqueta_FiltroUsuario (Id)
                            SELECT  [LEF].Id
                            FROM [Lead_Etiqueta_FiltroUsuario] LEF INNER JOIN [Lead_Etiqueta] LE ON LEF.[ID_Etiqueta] = LE.[ID]
                            WHERE [LE].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempLead_Etiqueta_FiltroUsuarioDel
                            CREATE TABLE #TempLead_Etiqueta_FiltroUsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempLead_Etiqueta_FiltroUsuario))
                            BEGIN
                                TRUNCATE TABLE #TempLead_Etiqueta_FiltroUsuarioDel

                                INSERT #TempLead_Etiqueta_FiltroUsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempLead_Etiqueta_FiltroUsuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempLead_Etiqueta_FiltroUsuarioDel
                                DELETE LEF
                                FROM [Lead_Etiqueta_FiltroUsuario] LEF INNER JOIN #TempLead_Etiqueta_FiltroUsuarioDel TempLead_Etiqueta_FiltroUsuarioDel ON [LEF].ID = TempLead_Etiqueta_FiltroUsuarioDel.Id
                                WHERE [LEF].ID >= @MinId AND [LEF].ID <= @MaxId
                                        
                                DELETE #TempLead_Etiqueta_FiltroUsuario
                                FROM #TempLead_Etiqueta_FiltroUsuario TempLead_Etiqueta_FiltroUsuario INNER JOIN #TempLead_Etiqueta_FiltroUsuarioDel TempLead_Etiqueta_FiltroUsuarioDel ON TempLead_Etiqueta_FiltroUsuario.ID = TempLead_Etiqueta_FiltroUsuarioDel.Id
                            END
                            DROP TABLE #TempLead_Etiqueta_FiltroUsuario
                            DROP TABLE #TempLead_Etiqueta_FiltroUsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Lead_Etiqueta]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempLead_Etiqueta

                            CREATE TABLE #TempLead_Etiqueta
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempLead_Etiqueta (Id)
                            SELECT  [Lead_Etiqueta].Id
                            FROM [Lead_Etiqueta] Lead_Etiqueta
                            WHERE [Lead_Etiqueta].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempLead_EtiquetaDel
                            CREATE TABLE #TempLead_EtiquetaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempLead_Etiqueta))
                            BEGIN
                                TRUNCATE TABLE #TempLead_EtiquetaDel

                                INSERT #TempLead_EtiquetaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempLead_Etiqueta
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempLead_EtiquetaDel
                                DELETE Lead_Etiqueta
                                FROM [Lead_Etiqueta] Lead_Etiqueta INNER JOIN #TempLead_EtiquetaDel TempLead_EtiquetaDel ON [Lead_Etiqueta].ID = TempLead_EtiquetaDel.Id
                                WHERE [Lead_Etiqueta].ID >= @MinId AND [Lead_Etiqueta].ID <= @MaxId
                                        
                                DELETE #TempLead_Etiqueta
                                FROM #TempLead_Etiqueta TempLead_Etiqueta INNER JOIN #TempLead_EtiquetaDel TempLead_EtiquetaDel ON TempLead_Etiqueta.ID = TempLead_EtiquetaDel.Id
                            END
                            DROP TABLE #TempLead_Etiqueta
                            DROP TABLE #TempLead_EtiquetaDel
                            GO
PRINT 'Running accountId 1 and table [Lead_Usuario_Contador]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempLead_Usuario_Contador

                            CREATE TABLE #TempLead_Usuario_Contador
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempLead_Usuario_Contador (Id)
                            SELECT  [LUC].Id
                            FROM [Lead_Usuario_Contador] LUC INNER JOIN [Lead] L ON LUC.[ID_Lead] = L.[ID]
                            WHERE [L].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempLead_Usuario_ContadorDel
                            CREATE TABLE #TempLead_Usuario_ContadorDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempLead_Usuario_Contador))
                            BEGIN
                                TRUNCATE TABLE #TempLead_Usuario_ContadorDel

                                INSERT #TempLead_Usuario_ContadorDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempLead_Usuario_Contador
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempLead_Usuario_ContadorDel
                                DELETE LUC
                                FROM [Lead_Usuario_Contador] LUC INNER JOIN #TempLead_Usuario_ContadorDel TempLead_Usuario_ContadorDel ON [LUC].ID = TempLead_Usuario_ContadorDel.Id
                                WHERE [LUC].ID >= @MinId AND [LUC].ID <= @MaxId
                                        
                                DELETE #TempLead_Usuario_Contador
                                FROM #TempLead_Usuario_Contador TempLead_Usuario_Contador INNER JOIN #TempLead_Usuario_ContadorDel TempLead_Usuario_ContadorDel ON TempLead_Usuario_Contador.ID = TempLead_Usuario_ContadorDel.Id
                            END
                            DROP TABLE #TempLead_Usuario_Contador
                            DROP TABLE #TempLead_Usuario_ContadorDel
                            GO
PRINT 'Running accountId 1 and table [Lead_Telefone]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempLead_Telefone

                            CREATE TABLE #TempLead_Telefone
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempLead_Telefone (Id)
                            SELECT  [LT].Id
                            FROM [Lead_Telefone] LT INNER JOIN [Lead] L ON LT.[ID_Lead] = L.[ID]
                            WHERE [L].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempLead_TelefoneDel
                            CREATE TABLE #TempLead_TelefoneDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempLead_Telefone))
                            BEGIN
                                TRUNCATE TABLE #TempLead_TelefoneDel

                                INSERT #TempLead_TelefoneDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempLead_Telefone
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempLead_TelefoneDel
                                DELETE LT
                                FROM [Lead_Telefone] LT INNER JOIN #TempLead_TelefoneDel TempLead_TelefoneDel ON [LT].ID = TempLead_TelefoneDel.Id
                                WHERE [LT].ID >= @MinId AND [LT].ID <= @MaxId
                                        
                                DELETE #TempLead_Telefone
                                FROM #TempLead_Telefone TempLead_Telefone INNER JOIN #TempLead_TelefoneDel TempLead_TelefoneDel ON TempLead_Telefone.ID = TempLead_TelefoneDel.Id
                            END
                            DROP TABLE #TempLead_Telefone
                            DROP TABLE #TempLead_TelefoneDel
                            GO
PRINT 'Running accountId 1 and table [Lead_Obs]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempLead_Obs

                            CREATE TABLE #TempLead_Obs
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempLead_Obs (Id)
                            SELECT  [LO].Id
                            FROM [Lead_Obs] LO INNER JOIN [Lead] L ON LO.[ID_Lead] = L.[ID]
                            WHERE [L].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempLead_ObsDel
                            CREATE TABLE #TempLead_ObsDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempLead_Obs))
                            BEGIN
                                TRUNCATE TABLE #TempLead_ObsDel

                                INSERT #TempLead_ObsDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempLead_Obs
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempLead_ObsDel
                                DELETE LO
                                FROM [Lead_Obs] LO INNER JOIN #TempLead_ObsDel TempLead_ObsDel ON [LO].ID = TempLead_ObsDel.Id
                                WHERE [LO].ID >= @MinId AND [LO].ID <= @MaxId
                                        
                                DELETE #TempLead_Obs
                                FROM #TempLead_Obs TempLead_Obs INNER JOIN #TempLead_ObsDel TempLead_ObsDel ON TempLead_Obs.ID = TempLead_ObsDel.Id
                            END
                            DROP TABLE #TempLead_Obs
                            DROP TABLE #TempLead_ObsDel
                            GO
PRINT 'Running accountId 1 and table [Lead_Historico_Alteracao]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempLead_Historico_Alteracao

                            CREATE TABLE #TempLead_Historico_Alteracao
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempLead_Historico_Alteracao (Id)
                            SELECT  [LHA].Id
                            FROM [Lead_Historico_Alteracao] LHA INNER JOIN [Lead] L ON LHA.[ID_Lead] = L.[ID]
                            WHERE [L].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempLead_Historico_AlteracaoDel
                            CREATE TABLE #TempLead_Historico_AlteracaoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempLead_Historico_Alteracao))
                            BEGIN
                                TRUNCATE TABLE #TempLead_Historico_AlteracaoDel

                                INSERT #TempLead_Historico_AlteracaoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempLead_Historico_Alteracao
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempLead_Historico_AlteracaoDel
                                DELETE LHA
                                FROM [Lead_Historico_Alteracao] LHA INNER JOIN #TempLead_Historico_AlteracaoDel TempLead_Historico_AlteracaoDel ON [LHA].ID = TempLead_Historico_AlteracaoDel.Id
                                WHERE [LHA].ID >= @MinId AND [LHA].ID <= @MaxId
                                        
                                DELETE #TempLead_Historico_Alteracao
                                FROM #TempLead_Historico_Alteracao TempLead_Historico_Alteracao INNER JOIN #TempLead_Historico_AlteracaoDel TempLead_Historico_AlteracaoDel ON TempLead_Historico_Alteracao.ID = TempLead_Historico_AlteracaoDel.Id
                            END
                            DROP TABLE #TempLead_Historico_Alteracao
                            DROP TABLE #TempLead_Historico_AlteracaoDel
                            GO
PRINT 'Running accountId 1 and table [Lead]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempLead

                            CREATE TABLE #TempLead
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempLead (Id)
                            SELECT  [Lead].Id
                            FROM [Lead] Lead
                            WHERE [Lead].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempLeadDel
                            CREATE TABLE #TempLeadDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempLead))
                            BEGIN
                                TRUNCATE TABLE #TempLeadDel

                                INSERT #TempLeadDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempLead
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempLeadDel
                                DELETE Lead
                                FROM [Lead] Lead INNER JOIN #TempLeadDel TempLeadDel ON [Lead].ID = TempLeadDel.Id
                                WHERE [Lead].ID >= @MinId AND [Lead].ID <= @MaxId
                                        
                                DELETE #TempLead
                                FROM #TempLead TempLead INNER JOIN #TempLeadDel TempLeadDel ON TempLead.ID = TempLeadDel.Id
                            END
                            DROP TABLE #TempLead
                            DROP TABLE #TempLeadDel
                            GO
PRINT 'Running accountId 1 and table [Integration_Field_OptionsTable_Option_Language_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempIntegration_Field_OptionsTable_Option_Language_Account

                            CREATE TABLE #TempIntegration_Field_OptionsTable_Option_Language_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempIntegration_Field_OptionsTable_Option_Language_Account (Id)
                            SELECT  [Integration_Field_OptionsTable_Option_Language_Account].Id
                            FROM [Integration_Field_OptionsTable_Option_Language_Account] Integration_Field_OptionsTable_Option_Language_Account
                            WHERE [Integration_Field_OptionsTable_Option_Language_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempIntegration_Field_OptionsTable_Option_Language_AccountDel
                            CREATE TABLE #TempIntegration_Field_OptionsTable_Option_Language_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempIntegration_Field_OptionsTable_Option_Language_Account))
                            BEGIN
                                TRUNCATE TABLE #TempIntegration_Field_OptionsTable_Option_Language_AccountDel

                                INSERT #TempIntegration_Field_OptionsTable_Option_Language_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempIntegration_Field_OptionsTable_Option_Language_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempIntegration_Field_OptionsTable_Option_Language_AccountDel
                                DELETE Integration_Field_OptionsTable_Option_Language_Account
                                FROM [Integration_Field_OptionsTable_Option_Language_Account] Integration_Field_OptionsTable_Option_Language_Account INNER JOIN #TempIntegration_Field_OptionsTable_Option_Language_AccountDel TempIntegration_Field_OptionsTable_Option_Language_AccountDel ON [Integration_Field_OptionsTable_Option_Language_Account].ID = TempIntegration_Field_OptionsTable_Option_Language_AccountDel.Id
                                WHERE [Integration_Field_OptionsTable_Option_Language_Account].ID >= @MinId AND [Integration_Field_OptionsTable_Option_Language_Account].ID <= @MaxId
                                        
                                DELETE #TempIntegration_Field_OptionsTable_Option_Language_Account
                                FROM #TempIntegration_Field_OptionsTable_Option_Language_Account TempIntegration_Field_OptionsTable_Option_Language_Account INNER JOIN #TempIntegration_Field_OptionsTable_Option_Language_AccountDel TempIntegration_Field_OptionsTable_Option_Language_AccountDel ON TempIntegration_Field_OptionsTable_Option_Language_Account.ID = TempIntegration_Field_OptionsTable_Option_Language_AccountDel.Id
                            END
                            DROP TABLE #TempIntegration_Field_OptionsTable_Option_Language_Account
                            DROP TABLE #TempIntegration_Field_OptionsTable_Option_Language_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Integration_Field_Language_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempIntegration_Field_Language_Account

                            CREATE TABLE #TempIntegration_Field_Language_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempIntegration_Field_Language_Account (Id)
                            SELECT  [Integration_Field_Language_Account].Id
                            FROM [Integration_Field_Language_Account] Integration_Field_Language_Account
                            WHERE [Integration_Field_Language_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempIntegration_Field_Language_AccountDel
                            CREATE TABLE #TempIntegration_Field_Language_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempIntegration_Field_Language_Account))
                            BEGIN
                                TRUNCATE TABLE #TempIntegration_Field_Language_AccountDel

                                INSERT #TempIntegration_Field_Language_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempIntegration_Field_Language_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempIntegration_Field_Language_AccountDel
                                DELETE Integration_Field_Language_Account
                                FROM [Integration_Field_Language_Account] Integration_Field_Language_Account INNER JOIN #TempIntegration_Field_Language_AccountDel TempIntegration_Field_Language_AccountDel ON [Integration_Field_Language_Account].ID = TempIntegration_Field_Language_AccountDel.Id
                                WHERE [Integration_Field_Language_Account].ID >= @MinId AND [Integration_Field_Language_Account].ID <= @MaxId
                                        
                                DELETE #TempIntegration_Field_Language_Account
                                FROM #TempIntegration_Field_Language_Account TempIntegration_Field_Language_Account INNER JOIN #TempIntegration_Field_Language_AccountDel TempIntegration_Field_Language_AccountDel ON TempIntegration_Field_Language_Account.ID = TempIntegration_Field_Language_AccountDel.Id
                            END
                            DROP TABLE #TempIntegration_Field_Language_Account
                            DROP TABLE #TempIntegration_Field_Language_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Integration_DynamicMapEntity_Language_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempIntegration_DynamicMapEntity_Language_Account

                            CREATE TABLE #TempIntegration_DynamicMapEntity_Language_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempIntegration_DynamicMapEntity_Language_Account (Id)
                            SELECT  [Integration_DynamicMapEntity_Language_Account].Id
                            FROM [Integration_DynamicMapEntity_Language_Account] Integration_DynamicMapEntity_Language_Account
                            WHERE [Integration_DynamicMapEntity_Language_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempIntegration_DynamicMapEntity_Language_AccountDel
                            CREATE TABLE #TempIntegration_DynamicMapEntity_Language_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempIntegration_DynamicMapEntity_Language_Account))
                            BEGIN
                                TRUNCATE TABLE #TempIntegration_DynamicMapEntity_Language_AccountDel

                                INSERT #TempIntegration_DynamicMapEntity_Language_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempIntegration_DynamicMapEntity_Language_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempIntegration_DynamicMapEntity_Language_AccountDel
                                DELETE Integration_DynamicMapEntity_Language_Account
                                FROM [Integration_DynamicMapEntity_Language_Account] Integration_DynamicMapEntity_Language_Account INNER JOIN #TempIntegration_DynamicMapEntity_Language_AccountDel TempIntegration_DynamicMapEntity_Language_AccountDel ON [Integration_DynamicMapEntity_Language_Account].ID = TempIntegration_DynamicMapEntity_Language_AccountDel.Id
                                WHERE [Integration_DynamicMapEntity_Language_Account].ID >= @MinId AND [Integration_DynamicMapEntity_Language_Account].ID <= @MaxId
                                        
                                DELETE #TempIntegration_DynamicMapEntity_Language_Account
                                FROM #TempIntegration_DynamicMapEntity_Language_Account TempIntegration_DynamicMapEntity_Language_Account INNER JOIN #TempIntegration_DynamicMapEntity_Language_AccountDel TempIntegration_DynamicMapEntity_Language_AccountDel ON TempIntegration_DynamicMapEntity_Language_Account.ID = TempIntegration_DynamicMapEntity_Language_AccountDel.Id
                            END
                            DROP TABLE #TempIntegration_DynamicMapEntity_Language_Account
                            DROP TABLE #TempIntegration_DynamicMapEntity_Language_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Integracao_Oportunidade]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempIntegracao_Oportunidade

                            CREATE TABLE #TempIntegracao_Oportunidade
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempIntegracao_Oportunidade (Id)
                            SELECT  [Integracao_Oportunidade].Id
                            FROM [Integracao_Oportunidade] Integracao_Oportunidade
                            WHERE [Integracao_Oportunidade].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempIntegracao_OportunidadeDel
                            CREATE TABLE #TempIntegracao_OportunidadeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempIntegracao_Oportunidade))
                            BEGIN
                                TRUNCATE TABLE #TempIntegracao_OportunidadeDel

                                INSERT #TempIntegracao_OportunidadeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempIntegracao_Oportunidade
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempIntegracao_OportunidadeDel
                                DELETE Integracao_Oportunidade
                                FROM [Integracao_Oportunidade] Integracao_Oportunidade INNER JOIN #TempIntegracao_OportunidadeDel TempIntegracao_OportunidadeDel ON [Integracao_Oportunidade].ID = TempIntegracao_OportunidadeDel.Id
                                WHERE [Integracao_Oportunidade].ID >= @MinId AND [Integracao_Oportunidade].ID <= @MaxId
                                        
                                DELETE #TempIntegracao_Oportunidade
                                FROM #TempIntegracao_Oportunidade TempIntegracao_Oportunidade INNER JOIN #TempIntegracao_OportunidadeDel TempIntegracao_OportunidadeDel ON TempIntegracao_Oportunidade.ID = TempIntegracao_OportunidadeDel.Id
                            END
                            DROP TABLE #TempIntegracao_Oportunidade
                            DROP TABLE #TempIntegracao_OportunidadeDel
                            GO
PRINT 'Running accountId 1 and table [Informe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempInforme

                            CREATE TABLE #TempInforme
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempInforme (Id)
                            SELECT  [Informe].Id
                            FROM [Informe] Informe
                            WHERE [Informe].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempInformeDel
                            CREATE TABLE #TempInformeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempInforme))
                            BEGIN
                                TRUNCATE TABLE #TempInformeDel

                                INSERT #TempInformeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempInforme
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempInformeDel
                                DELETE Informe
                                FROM [Informe] Informe INNER JOIN #TempInformeDel TempInformeDel ON [Informe].ID = TempInformeDel.Id
                                WHERE [Informe].ID >= @MinId AND [Informe].ID <= @MaxId
                                        
                                DELETE #TempInforme
                                FROM #TempInforme TempInforme INNER JOIN #TempInformeDel TempInformeDel ON TempInforme.ID = TempInformeDel.Id
                            END
                            DROP TABLE #TempInforme
                            DROP TABLE #TempInformeDel
                            GO
PRINT 'Running accountId 1 and table [Importation_MappedField]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempImportation_MappedField

                            CREATE TABLE #TempImportation_MappedField
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempImportation_MappedField (Id)
                            SELECT  [IM].Id
                            FROM [Importation_MappedField] IM INNER JOIN [Importation] I ON IM.[ImportationId] = I.[Id]
                            WHERE [I].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempImportation_MappedFieldDel
                            CREATE TABLE #TempImportation_MappedFieldDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempImportation_MappedField))
                            BEGIN
                                TRUNCATE TABLE #TempImportation_MappedFieldDel

                                INSERT #TempImportation_MappedFieldDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempImportation_MappedField
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempImportation_MappedFieldDel
                                DELETE IM
                                FROM [Importation_MappedField] IM INNER JOIN #TempImportation_MappedFieldDel TempImportation_MappedFieldDel ON [IM].ID = TempImportation_MappedFieldDel.Id
                                WHERE [IM].ID >= @MinId AND [IM].ID <= @MaxId
                                        
                                DELETE #TempImportation_MappedField
                                FROM #TempImportation_MappedField TempImportation_MappedField INNER JOIN #TempImportation_MappedFieldDel TempImportation_MappedFieldDel ON TempImportation_MappedField.ID = TempImportation_MappedFieldDel.Id
                            END
                            DROP TABLE #TempImportation_MappedField
                            DROP TABLE #TempImportation_MappedFieldDel
                            GO
PRINT 'Running accountId 1 and table [Importation]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempImportation

                            CREATE TABLE #TempImportation
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempImportation (Id)
                            SELECT  [Importation].Id
                            FROM [Importation] Importation
                            WHERE [Importation].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempImportationDel
                            CREATE TABLE #TempImportationDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempImportation))
                            BEGIN
                                TRUNCATE TABLE #TempImportationDel

                                INSERT #TempImportationDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempImportation
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempImportationDel
                                DELETE Importation
                                FROM [Importation] Importation INNER JOIN #TempImportationDel TempImportationDel ON [Importation].ID = TempImportationDel.Id
                                WHERE [Importation].ID >= @MinId AND [Importation].ID <= @MaxId
                                        
                                DELETE #TempImportation
                                FROM #TempImportation TempImportation INNER JOIN #TempImportationDel TempImportationDel ON TempImportation.ID = TempImportationDel.Id
                            END
                            DROP TABLE #TempImportation
                            DROP TABLE #TempImportationDel
                            GO
PRINT 'Running accountId 1 and table [Importacao_Template_Entidade_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempImportacao_Template_Entidade_Account

                            CREATE TABLE #TempImportacao_Template_Entidade_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempImportacao_Template_Entidade_Account (Id)
                            SELECT  [Importacao_Template_Entidade_Account].Id
                            FROM [Importacao_Template_Entidade_Account] Importacao_Template_Entidade_Account
                            WHERE [Importacao_Template_Entidade_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempImportacao_Template_Entidade_AccountDel
                            CREATE TABLE #TempImportacao_Template_Entidade_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempImportacao_Template_Entidade_Account))
                            BEGIN
                                TRUNCATE TABLE #TempImportacao_Template_Entidade_AccountDel

                                INSERT #TempImportacao_Template_Entidade_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempImportacao_Template_Entidade_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempImportacao_Template_Entidade_AccountDel
                                DELETE Importacao_Template_Entidade_Account
                                FROM [Importacao_Template_Entidade_Account] Importacao_Template_Entidade_Account INNER JOIN #TempImportacao_Template_Entidade_AccountDel TempImportacao_Template_Entidade_AccountDel ON [Importacao_Template_Entidade_Account].ID = TempImportacao_Template_Entidade_AccountDel.Id
                                WHERE [Importacao_Template_Entidade_Account].ID >= @MinId AND [Importacao_Template_Entidade_Account].ID <= @MaxId
                                        
                                DELETE #TempImportacao_Template_Entidade_Account
                                FROM #TempImportacao_Template_Entidade_Account TempImportacao_Template_Entidade_Account INNER JOIN #TempImportacao_Template_Entidade_AccountDel TempImportacao_Template_Entidade_AccountDel ON TempImportacao_Template_Entidade_Account.ID = TempImportacao_Template_Entidade_AccountDel.Id
                            END
                            DROP TABLE #TempImportacao_Template_Entidade_Account
                            DROP TABLE #TempImportacao_Template_Entidade_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Importacao_Template_Cultura_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempImportacao_Template_Cultura_Account

                            CREATE TABLE #TempImportacao_Template_Cultura_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempImportacao_Template_Cultura_Account (Id)
                            SELECT  [Importacao_Template_Cultura_Account].Id
                            FROM [Importacao_Template_Cultura_Account] Importacao_Template_Cultura_Account
                            WHERE [Importacao_Template_Cultura_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempImportacao_Template_Cultura_AccountDel
                            CREATE TABLE #TempImportacao_Template_Cultura_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempImportacao_Template_Cultura_Account))
                            BEGIN
                                TRUNCATE TABLE #TempImportacao_Template_Cultura_AccountDel

                                INSERT #TempImportacao_Template_Cultura_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempImportacao_Template_Cultura_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempImportacao_Template_Cultura_AccountDel
                                DELETE Importacao_Template_Cultura_Account
                                FROM [Importacao_Template_Cultura_Account] Importacao_Template_Cultura_Account INNER JOIN #TempImportacao_Template_Cultura_AccountDel TempImportacao_Template_Cultura_AccountDel ON [Importacao_Template_Cultura_Account].ID = TempImportacao_Template_Cultura_AccountDel.Id
                                WHERE [Importacao_Template_Cultura_Account].ID >= @MinId AND [Importacao_Template_Cultura_Account].ID <= @MaxId
                                        
                                DELETE #TempImportacao_Template_Cultura_Account
                                FROM #TempImportacao_Template_Cultura_Account TempImportacao_Template_Cultura_Account INNER JOIN #TempImportacao_Template_Cultura_AccountDel TempImportacao_Template_Cultura_AccountDel ON TempImportacao_Template_Cultura_Account.ID = TempImportacao_Template_Cultura_AccountDel.Id
                            END
                            DROP TABLE #TempImportacao_Template_Cultura_Account
                            DROP TABLE #TempImportacao_Template_Cultura_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Imagem]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempImagem

                            CREATE TABLE #TempImagem
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempImagem (Id)
                            SELECT  [Imagem].Id
                            FROM [Imagem] Imagem
                            WHERE [Imagem].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempImagemDel
                            CREATE TABLE #TempImagemDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempImagem))
                            BEGIN
                                TRUNCATE TABLE #TempImagemDel

                                INSERT #TempImagemDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempImagem
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempImagemDel
                                DELETE Imagem
                                FROM [Imagem] Imagem INNER JOIN #TempImagemDel TempImagemDel ON [Imagem].ID = TempImagemDel.Id
                                WHERE [Imagem].ID >= @MinId AND [Imagem].ID <= @MaxId
                                        
                                DELETE #TempImagem
                                FROM #TempImagem TempImagem INNER JOIN #TempImagemDel TempImagemDel ON TempImagem.ID = TempImagemDel.Id
                            END
                            DROP TABLE #TempImagem
                            DROP TABLE #TempImagemDel
                            GO
PRINT 'Running accountId 1 and table [Goal_Ordination]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempGoal_Ordination

                            CREATE TABLE #TempGoal_Ordination
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempGoal_Ordination (Id)
                            SELECT  [O].Id
                            FROM [Goal_Ordination] O INNER JOIN [Goal] G ON O.[GoalId] = G.[Id]
                            WHERE [G].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempGoal_OrdinationDel
                            CREATE TABLE #TempGoal_OrdinationDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempGoal_Ordination))
                            BEGIN
                                TRUNCATE TABLE #TempGoal_OrdinationDel

                                INSERT #TempGoal_OrdinationDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempGoal_Ordination
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempGoal_OrdinationDel
                                DELETE O
                                FROM [Goal_Ordination] O INNER JOIN #TempGoal_OrdinationDel TempGoal_OrdinationDel ON [O].ID = TempGoal_OrdinationDel.Id
                                WHERE [O].ID >= @MinId AND [O].ID <= @MaxId
                                        
                                DELETE #TempGoal_Ordination
                                FROM #TempGoal_Ordination TempGoal_Ordination INNER JOIN #TempGoal_OrdinationDel TempGoal_OrdinationDel ON TempGoal_Ordination.ID = TempGoal_OrdinationDel.Id
                            END
                            DROP TABLE #TempGoal_Ordination
                            DROP TABLE #TempGoal_OrdinationDel
                            GO
PRINT 'Running accountId 1 and table [Goal_Interval_Goal]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempGoal_Interval_Goal

                            CREATE TABLE #TempGoal_Interval_Goal
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempGoal_Interval_Goal (Id)
                            SELECT  [GIG].Id
                            FROM [Goal_Interval_Goal] GIG INNER JOIN [Goal] G ON GIG.[GoalId] = G.[Id]
                            WHERE [G].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempGoal_Interval_GoalDel
                            CREATE TABLE #TempGoal_Interval_GoalDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempGoal_Interval_Goal))
                            BEGIN
                                TRUNCATE TABLE #TempGoal_Interval_GoalDel

                                INSERT #TempGoal_Interval_GoalDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempGoal_Interval_Goal
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempGoal_Interval_GoalDel
                                DELETE GIG
                                FROM [Goal_Interval_Goal] GIG INNER JOIN #TempGoal_Interval_GoalDel TempGoal_Interval_GoalDel ON [GIG].ID = TempGoal_Interval_GoalDel.Id
                                WHERE [GIG].ID >= @MinId AND [GIG].ID <= @MaxId
                                        
                                DELETE #TempGoal_Interval_Goal
                                FROM #TempGoal_Interval_Goal TempGoal_Interval_Goal INNER JOIN #TempGoal_Interval_GoalDel TempGoal_Interval_GoalDel ON TempGoal_Interval_Goal.ID = TempGoal_Interval_GoalDel.Id
                            END
                            DROP TABLE #TempGoal_Interval_Goal
                            DROP TABLE #TempGoal_Interval_GoalDel
                            GO
PRINT 'Running accountId 1 and table [Goal_DesignatedUser]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempGoal_DesignatedUser

                            CREATE TABLE #TempGoal_DesignatedUser
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempGoal_DesignatedUser (Id)
                            SELECT  [GD].Id
                            FROM [Goal_DesignatedUser] GD INNER JOIN [Goal] G ON GD.[GoalId] = G.[Id]
                            WHERE [G].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempGoal_DesignatedUserDel
                            CREATE TABLE #TempGoal_DesignatedUserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempGoal_DesignatedUser))
                            BEGIN
                                TRUNCATE TABLE #TempGoal_DesignatedUserDel

                                INSERT #TempGoal_DesignatedUserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempGoal_DesignatedUser
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempGoal_DesignatedUserDel
                                DELETE GD
                                FROM [Goal_DesignatedUser] GD INNER JOIN #TempGoal_DesignatedUserDel TempGoal_DesignatedUserDel ON [GD].ID = TempGoal_DesignatedUserDel.Id
                                WHERE [GD].ID >= @MinId AND [GD].ID <= @MaxId
                                        
                                DELETE #TempGoal_DesignatedUser
                                FROM #TempGoal_DesignatedUser TempGoal_DesignatedUser INNER JOIN #TempGoal_DesignatedUserDel TempGoal_DesignatedUserDel ON TempGoal_DesignatedUser.ID = TempGoal_DesignatedUserDel.Id
                            END
                            DROP TABLE #TempGoal_DesignatedUser
                            DROP TABLE #TempGoal_DesignatedUserDel
                            GO
PRINT 'Running accountId 1 and table [Goal_DesignatedTeam]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempGoal_DesignatedTeam

                            CREATE TABLE #TempGoal_DesignatedTeam
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempGoal_DesignatedTeam (Id)
                            SELECT  [GD].Id
                            FROM [Goal_DesignatedTeam] GD INNER JOIN [Goal] G ON GD.[GoalId] = G.[Id]
                            WHERE [G].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempGoal_DesignatedTeamDel
                            CREATE TABLE #TempGoal_DesignatedTeamDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempGoal_DesignatedTeam))
                            BEGIN
                                TRUNCATE TABLE #TempGoal_DesignatedTeamDel

                                INSERT #TempGoal_DesignatedTeamDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempGoal_DesignatedTeam
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempGoal_DesignatedTeamDel
                                DELETE GD
                                FROM [Goal_DesignatedTeam] GD INNER JOIN #TempGoal_DesignatedTeamDel TempGoal_DesignatedTeamDel ON [GD].ID = TempGoal_DesignatedTeamDel.Id
                                WHERE [GD].ID >= @MinId AND [GD].ID <= @MaxId
                                        
                                DELETE #TempGoal_DesignatedTeam
                                FROM #TempGoal_DesignatedTeam TempGoal_DesignatedTeam INNER JOIN #TempGoal_DesignatedTeamDel TempGoal_DesignatedTeamDel ON TempGoal_DesignatedTeam.ID = TempGoal_DesignatedTeamDel.Id
                            END
                            DROP TABLE #TempGoal_DesignatedTeam
                            DROP TABLE #TempGoal_DesignatedTeamDel
                            GO
PRINT 'Running accountId 1 and table [Goal_AllowedUser]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempGoal_AllowedUser

                            CREATE TABLE #TempGoal_AllowedUser
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempGoal_AllowedUser (Id)
                            SELECT  [GA].Id
                            FROM [Goal_AllowedUser] GA INNER JOIN [Goal] G ON GA.[GoalId] = G.[Id]
                            WHERE [G].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempGoal_AllowedUserDel
                            CREATE TABLE #TempGoal_AllowedUserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempGoal_AllowedUser))
                            BEGIN
                                TRUNCATE TABLE #TempGoal_AllowedUserDel

                                INSERT #TempGoal_AllowedUserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempGoal_AllowedUser
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempGoal_AllowedUserDel
                                DELETE GA
                                FROM [Goal_AllowedUser] GA INNER JOIN #TempGoal_AllowedUserDel TempGoal_AllowedUserDel ON [GA].ID = TempGoal_AllowedUserDel.Id
                                WHERE [GA].ID >= @MinId AND [GA].ID <= @MaxId
                                        
                                DELETE #TempGoal_AllowedUser
                                FROM #TempGoal_AllowedUser TempGoal_AllowedUser INNER JOIN #TempGoal_AllowedUserDel TempGoal_AllowedUserDel ON TempGoal_AllowedUser.ID = TempGoal_AllowedUserDel.Id
                            END
                            DROP TABLE #TempGoal_AllowedUser
                            DROP TABLE #TempGoal_AllowedUserDel
                            GO
PRINT 'Running accountId 1 and table [Goal_AllowedTeam]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempGoal_AllowedTeam

                            CREATE TABLE #TempGoal_AllowedTeam
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempGoal_AllowedTeam (Id)
                            SELECT  [GA].Id
                            FROM [Goal_AllowedTeam] GA INNER JOIN [Goal] G ON GA.[GoalId] = G.[Id]
                            WHERE [G].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempGoal_AllowedTeamDel
                            CREATE TABLE #TempGoal_AllowedTeamDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempGoal_AllowedTeam))
                            BEGIN
                                TRUNCATE TABLE #TempGoal_AllowedTeamDel

                                INSERT #TempGoal_AllowedTeamDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempGoal_AllowedTeam
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempGoal_AllowedTeamDel
                                DELETE GA
                                FROM [Goal_AllowedTeam] GA INNER JOIN #TempGoal_AllowedTeamDel TempGoal_AllowedTeamDel ON [GA].ID = TempGoal_AllowedTeamDel.Id
                                WHERE [GA].ID >= @MinId AND [GA].ID <= @MaxId
                                        
                                DELETE #TempGoal_AllowedTeam
                                FROM #TempGoal_AllowedTeam TempGoal_AllowedTeam INNER JOIN #TempGoal_AllowedTeamDel TempGoal_AllowedTeamDel ON TempGoal_AllowedTeam.ID = TempGoal_AllowedTeamDel.Id
                            END
                            DROP TABLE #TempGoal_AllowedTeam
                            DROP TABLE #TempGoal_AllowedTeamDel
                            GO
PRINT 'Running accountId 1 and table [Goal]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempGoal

                            CREATE TABLE #TempGoal
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempGoal (Id)
                            SELECT  [Goal].Id
                            FROM [Goal] Goal
                            WHERE [Goal].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempGoalDel
                            CREATE TABLE #TempGoalDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempGoal))
                            BEGIN
                                TRUNCATE TABLE #TempGoalDel

                                INSERT #TempGoalDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempGoal
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempGoalDel
                                DELETE Goal
                                FROM [Goal] Goal INNER JOIN #TempGoalDel TempGoalDel ON [Goal].ID = TempGoalDel.Id
                                WHERE [Goal].ID >= @MinId AND [Goal].ID <= @MaxId
                                        
                                DELETE #TempGoal
                                FROM #TempGoal TempGoal INNER JOIN #TempGoalDel TempGoalDel ON TempGoal.ID = TempGoalDel.Id
                            END
                            DROP TABLE #TempGoal
                            DROP TABLE #TempGoalDel
                            GO
PRINT 'Running accountId 1 and table [Formulario_Secao_Language]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFormulario_Secao_Language

                            CREATE TABLE #TempFormulario_Secao_Language
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFormulario_Secao_Language (Id)
                            SELECT  [FSL].Id
                            FROM [Formulario_Secao_Language] FSL INNER JOIN [Formulario_Secao] FS ON FS.[Id] = FSL.[SectionId] INNER JOIN [Formulario] F ON FS.[ID_Formulario] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFormulario_Secao_LanguageDel
                            CREATE TABLE #TempFormulario_Secao_LanguageDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFormulario_Secao_Language))
                            BEGIN
                                TRUNCATE TABLE #TempFormulario_Secao_LanguageDel

                                INSERT #TempFormulario_Secao_LanguageDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFormulario_Secao_Language
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFormulario_Secao_LanguageDel
                                DELETE FSL
                                FROM [Formulario_Secao_Language] FSL INNER JOIN #TempFormulario_Secao_LanguageDel TempFormulario_Secao_LanguageDel ON [FSL].ID = TempFormulario_Secao_LanguageDel.Id
                                WHERE [FSL].ID >= @MinId AND [FSL].ID <= @MaxId
                                        
                                DELETE #TempFormulario_Secao_Language
                                FROM #TempFormulario_Secao_Language TempFormulario_Secao_Language INNER JOIN #TempFormulario_Secao_LanguageDel TempFormulario_Secao_LanguageDel ON TempFormulario_Secao_Language.ID = TempFormulario_Secao_LanguageDel.Id
                            END
                            DROP TABLE #TempFormulario_Secao_Language
                            DROP TABLE #TempFormulario_Secao_LanguageDel
                            GO
PRINT 'Running accountId 1 and table [Formulario_Secao_AllowedUserProfile]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFormulario_Secao_AllowedUserProfile

                            CREATE TABLE #TempFormulario_Secao_AllowedUserProfile
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFormulario_Secao_AllowedUserProfile (Id)
                            SELECT  [FSA].Id
                            FROM [Formulario_Secao_AllowedUserProfile] FSA INNER JOIN [Formulario_Secao] FS ON FS.[Id] = FSA.[SectionId] INNER JOIN [Formulario] F ON FS.[ID_Formulario] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFormulario_Secao_AllowedUserProfileDel
                            CREATE TABLE #TempFormulario_Secao_AllowedUserProfileDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFormulario_Secao_AllowedUserProfile))
                            BEGIN
                                TRUNCATE TABLE #TempFormulario_Secao_AllowedUserProfileDel

                                INSERT #TempFormulario_Secao_AllowedUserProfileDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFormulario_Secao_AllowedUserProfile
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFormulario_Secao_AllowedUserProfileDel
                                DELETE FSA
                                FROM [Formulario_Secao_AllowedUserProfile] FSA INNER JOIN #TempFormulario_Secao_AllowedUserProfileDel TempFormulario_Secao_AllowedUserProfileDel ON [FSA].ID = TempFormulario_Secao_AllowedUserProfileDel.Id
                                WHERE [FSA].ID >= @MinId AND [FSA].ID <= @MaxId
                                        
                                DELETE #TempFormulario_Secao_AllowedUserProfile
                                FROM #TempFormulario_Secao_AllowedUserProfile TempFormulario_Secao_AllowedUserProfile INNER JOIN #TempFormulario_Secao_AllowedUserProfileDel TempFormulario_Secao_AllowedUserProfileDel ON TempFormulario_Secao_AllowedUserProfile.ID = TempFormulario_Secao_AllowedUserProfileDel.Id
                            END
                            DROP TABLE #TempFormulario_Secao_AllowedUserProfile
                            DROP TABLE #TempFormulario_Secao_AllowedUserProfileDel
                            GO
PRINT 'Running accountId 1 and table [Formulario_Secao_AllowedUser]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFormulario_Secao_AllowedUser

                            CREATE TABLE #TempFormulario_Secao_AllowedUser
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFormulario_Secao_AllowedUser (Id)
                            SELECT  [FSA].Id
                            FROM [Formulario_Secao_AllowedUser] FSA INNER JOIN [Formulario_Secao] FS ON FS.[Id] = FSA.[SectionId] INNER JOIN [Formulario] F ON FS.[ID_Formulario] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFormulario_Secao_AllowedUserDel
                            CREATE TABLE #TempFormulario_Secao_AllowedUserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFormulario_Secao_AllowedUser))
                            BEGIN
                                TRUNCATE TABLE #TempFormulario_Secao_AllowedUserDel

                                INSERT #TempFormulario_Secao_AllowedUserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFormulario_Secao_AllowedUser
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFormulario_Secao_AllowedUserDel
                                DELETE FSA
                                FROM [Formulario_Secao_AllowedUser] FSA INNER JOIN #TempFormulario_Secao_AllowedUserDel TempFormulario_Secao_AllowedUserDel ON [FSA].ID = TempFormulario_Secao_AllowedUserDel.Id
                                WHERE [FSA].ID >= @MinId AND [FSA].ID <= @MaxId
                                        
                                DELETE #TempFormulario_Secao_AllowedUser
                                FROM #TempFormulario_Secao_AllowedUser TempFormulario_Secao_AllowedUser INNER JOIN #TempFormulario_Secao_AllowedUserDel TempFormulario_Secao_AllowedUserDel ON TempFormulario_Secao_AllowedUser.ID = TempFormulario_Secao_AllowedUserDel.Id
                            END
                            DROP TABLE #TempFormulario_Secao_AllowedUser
                            DROP TABLE #TempFormulario_Secao_AllowedUserDel
                            GO
PRINT 'Running accountId 1 and table [Formulario_Secao_AllowedTeam]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFormulario_Secao_AllowedTeam

                            CREATE TABLE #TempFormulario_Secao_AllowedTeam
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFormulario_Secao_AllowedTeam (Id)
                            SELECT  [FSA].Id
                            FROM [Formulario_Secao_AllowedTeam] FSA INNER JOIN [Formulario_Secao] FS ON FS.[Id] = FSA.[SectionId] INNER JOIN [Formulario] F ON FS.[ID_Formulario] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFormulario_Secao_AllowedTeamDel
                            CREATE TABLE #TempFormulario_Secao_AllowedTeamDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFormulario_Secao_AllowedTeam))
                            BEGIN
                                TRUNCATE TABLE #TempFormulario_Secao_AllowedTeamDel

                                INSERT #TempFormulario_Secao_AllowedTeamDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFormulario_Secao_AllowedTeam
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFormulario_Secao_AllowedTeamDel
                                DELETE FSA
                                FROM [Formulario_Secao_AllowedTeam] FSA INNER JOIN #TempFormulario_Secao_AllowedTeamDel TempFormulario_Secao_AllowedTeamDel ON [FSA].ID = TempFormulario_Secao_AllowedTeamDel.Id
                                WHERE [FSA].ID >= @MinId AND [FSA].ID <= @MaxId
                                        
                                DELETE #TempFormulario_Secao_AllowedTeam
                                FROM #TempFormulario_Secao_AllowedTeam TempFormulario_Secao_AllowedTeam INNER JOIN #TempFormulario_Secao_AllowedTeamDel TempFormulario_Secao_AllowedTeamDel ON TempFormulario_Secao_AllowedTeam.ID = TempFormulario_Secao_AllowedTeamDel.Id
                            END
                            DROP TABLE #TempFormulario_Secao_AllowedTeam
                            DROP TABLE #TempFormulario_Secao_AllowedTeamDel
                            GO
PRINT 'Running accountId 1 and table [Formulario_Secao]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFormulario_Secao

                            CREATE TABLE #TempFormulario_Secao
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFormulario_Secao (Id)
                            SELECT  [FS].Id
                            FROM [Formulario_Secao] FS INNER JOIN [Formulario] F ON FS.[ID_Formulario] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFormulario_SecaoDel
                            CREATE TABLE #TempFormulario_SecaoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFormulario_Secao))
                            BEGIN
                                TRUNCATE TABLE #TempFormulario_SecaoDel

                                INSERT #TempFormulario_SecaoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFormulario_Secao
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFormulario_SecaoDel
                                DELETE FS
                                FROM [Formulario_Secao] FS INNER JOIN #TempFormulario_SecaoDel TempFormulario_SecaoDel ON [FS].ID = TempFormulario_SecaoDel.Id
                                WHERE [FS].ID >= @MinId AND [FS].ID <= @MaxId
                                        
                                DELETE #TempFormulario_Secao
                                FROM #TempFormulario_Secao TempFormulario_Secao INNER JOIN #TempFormulario_SecaoDel TempFormulario_SecaoDel ON TempFormulario_Secao.ID = TempFormulario_SecaoDel.Id
                            END
                            DROP TABLE #TempFormulario_Secao
                            DROP TABLE #TempFormulario_SecaoDel
                            GO
PRINT 'Running accountId 1 and table [Formulario_Campo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFormulario_Campo

                            CREATE TABLE #TempFormulario_Campo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFormulario_Campo (Id)
                            SELECT  [FC].Id
                            FROM [Formulario_Campo] FC INNER JOIN [Formulario] F ON FC.[ID_Formulario] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFormulario_CampoDel
                            CREATE TABLE #TempFormulario_CampoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFormulario_Campo))
                            BEGIN
                                TRUNCATE TABLE #TempFormulario_CampoDel

                                INSERT #TempFormulario_CampoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFormulario_Campo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFormulario_CampoDel
                                DELETE FC
                                FROM [Formulario_Campo] FC INNER JOIN #TempFormulario_CampoDel TempFormulario_CampoDel ON [FC].ID = TempFormulario_CampoDel.Id
                                WHERE [FC].ID >= @MinId AND [FC].ID <= @MaxId
                                        
                                DELETE #TempFormulario_Campo
                                FROM #TempFormulario_Campo TempFormulario_Campo INNER JOIN #TempFormulario_CampoDel TempFormulario_CampoDel ON TempFormulario_Campo.ID = TempFormulario_CampoDel.Id
                            END
                            DROP TABLE #TempFormulario_Campo
                            DROP TABLE #TempFormulario_CampoDel
                            GO
PRINT 'Running accountId 1 and table [Formulario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFormulario

                            CREATE TABLE #TempFormulario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFormulario (Id)
                            SELECT  [Formulario].Id
                            FROM [Formulario] Formulario
                            WHERE [Formulario].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFormularioDel
                            CREATE TABLE #TempFormularioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFormulario))
                            BEGIN
                                TRUNCATE TABLE #TempFormularioDel

                                INSERT #TempFormularioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFormulario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFormularioDel
                                DELETE Formulario
                                FROM [Formulario] Formulario INNER JOIN #TempFormularioDel TempFormularioDel ON [Formulario].ID = TempFormularioDel.Id
                                WHERE [Formulario].ID >= @MinId AND [Formulario].ID <= @MaxId
                                        
                                DELETE #TempFormulario
                                FROM #TempFormulario TempFormulario INNER JOIN #TempFormularioDel TempFormularioDel ON TempFormulario.ID = TempFormularioDel.Id
                            END
                            DROP TABLE #TempFormulario
                            DROP TABLE #TempFormularioDel
                            GO
PRINT 'Running accountId 1 and table [FiltroGeral_Campo_Valor]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFiltroGeral_Campo_Valor

                            CREATE TABLE #TempFiltroGeral_Campo_Valor
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFiltroGeral_Campo_Valor (Id)
                            SELECT  [FCV].Id
                            FROM [FiltroGeral_Campo_Valor] FCV INNER JOIN [FiltroGeral_Campo] FC ON FCV.[ID_FiltroCampo] = FC.[ID] INNER JOIN [FiltroGeral] F ON FC.[ID_Filtro] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFiltroGeral_Campo_ValorDel
                            CREATE TABLE #TempFiltroGeral_Campo_ValorDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFiltroGeral_Campo_Valor))
                            BEGIN
                                TRUNCATE TABLE #TempFiltroGeral_Campo_ValorDel

                                INSERT #TempFiltroGeral_Campo_ValorDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFiltroGeral_Campo_Valor
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFiltroGeral_Campo_ValorDel
                                DELETE FCV
                                FROM [FiltroGeral_Campo_Valor] FCV INNER JOIN #TempFiltroGeral_Campo_ValorDel TempFiltroGeral_Campo_ValorDel ON [FCV].ID = TempFiltroGeral_Campo_ValorDel.Id
                                WHERE [FCV].ID >= @MinId AND [FCV].ID <= @MaxId
                                        
                                DELETE #TempFiltroGeral_Campo_Valor
                                FROM #TempFiltroGeral_Campo_Valor TempFiltroGeral_Campo_Valor INNER JOIN #TempFiltroGeral_Campo_ValorDel TempFiltroGeral_Campo_ValorDel ON TempFiltroGeral_Campo_Valor.ID = TempFiltroGeral_Campo_ValorDel.Id
                            END
                            DROP TABLE #TempFiltroGeral_Campo_Valor
                            DROP TABLE #TempFiltroGeral_Campo_ValorDel
                            GO
PRINT 'Running accountId 1 and table [FiltroGeral_Campo_Campo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFiltroGeral_Campo_Campo

                            CREATE TABLE #TempFiltroGeral_Campo_Campo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFiltroGeral_Campo_Campo (Id)
                            SELECT  [FCC].Id
                            FROM [FiltroGeral_Campo_Campo] FCC INNER JOIN [FiltroGeral_Campo] FC ON FCC.[ID_FiltroCampo] = FC.[ID] INNER JOIN [FiltroGeral] F ON FC.[ID_Filtro] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFiltroGeral_Campo_CampoDel
                            CREATE TABLE #TempFiltroGeral_Campo_CampoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFiltroGeral_Campo_Campo))
                            BEGIN
                                TRUNCATE TABLE #TempFiltroGeral_Campo_CampoDel

                                INSERT #TempFiltroGeral_Campo_CampoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFiltroGeral_Campo_Campo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFiltroGeral_Campo_CampoDel
                                DELETE FCC
                                FROM [FiltroGeral_Campo_Campo] FCC INNER JOIN #TempFiltroGeral_Campo_CampoDel TempFiltroGeral_Campo_CampoDel ON [FCC].ID = TempFiltroGeral_Campo_CampoDel.Id
                                WHERE [FCC].ID >= @MinId AND [FCC].ID <= @MaxId
                                        
                                DELETE #TempFiltroGeral_Campo_Campo
                                FROM #TempFiltroGeral_Campo_Campo TempFiltroGeral_Campo_Campo INNER JOIN #TempFiltroGeral_Campo_CampoDel TempFiltroGeral_Campo_CampoDel ON TempFiltroGeral_Campo_Campo.ID = TempFiltroGeral_Campo_CampoDel.Id
                            END
                            DROP TABLE #TempFiltroGeral_Campo_Campo
                            DROP TABLE #TempFiltroGeral_Campo_CampoDel
                            GO
PRINT 'Running accountId 1 and table [FiltroGeral_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFiltroGeral_Usuario

                            CREATE TABLE #TempFiltroGeral_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFiltroGeral_Usuario (Id)
                            SELECT  [FU].Id
                            FROM [FiltroGeral_Usuario] FU INNER JOIN [FiltroGeral] F ON FU.[ID_Filtro] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFiltroGeral_UsuarioDel
                            CREATE TABLE #TempFiltroGeral_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFiltroGeral_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempFiltroGeral_UsuarioDel

                                INSERT #TempFiltroGeral_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFiltroGeral_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFiltroGeral_UsuarioDel
                                DELETE FU
                                FROM [FiltroGeral_Usuario] FU INNER JOIN #TempFiltroGeral_UsuarioDel TempFiltroGeral_UsuarioDel ON [FU].ID = TempFiltroGeral_UsuarioDel.Id
                                WHERE [FU].ID >= @MinId AND [FU].ID <= @MaxId
                                        
                                DELETE #TempFiltroGeral_Usuario
                                FROM #TempFiltroGeral_Usuario TempFiltroGeral_Usuario INNER JOIN #TempFiltroGeral_UsuarioDel TempFiltroGeral_UsuarioDel ON TempFiltroGeral_Usuario.ID = TempFiltroGeral_UsuarioDel.Id
                            END
                            DROP TABLE #TempFiltroGeral_Usuario
                            DROP TABLE #TempFiltroGeral_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [FiltroGeral_Permissao_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFiltroGeral_Permissao_Usuario

                            CREATE TABLE #TempFiltroGeral_Permissao_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFiltroGeral_Permissao_Usuario (Id)
                            SELECT  [FPU].Id
                            FROM [FiltroGeral_Permissao_Usuario] FPU INNER JOIN [FiltroGeral] F ON FPU.[ID_Filtro] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFiltroGeral_Permissao_UsuarioDel
                            CREATE TABLE #TempFiltroGeral_Permissao_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFiltroGeral_Permissao_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempFiltroGeral_Permissao_UsuarioDel

                                INSERT #TempFiltroGeral_Permissao_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFiltroGeral_Permissao_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFiltroGeral_Permissao_UsuarioDel
                                DELETE FPU
                                FROM [FiltroGeral_Permissao_Usuario] FPU INNER JOIN #TempFiltroGeral_Permissao_UsuarioDel TempFiltroGeral_Permissao_UsuarioDel ON [FPU].ID = TempFiltroGeral_Permissao_UsuarioDel.Id
                                WHERE [FPU].ID >= @MinId AND [FPU].ID <= @MaxId
                                        
                                DELETE #TempFiltroGeral_Permissao_Usuario
                                FROM #TempFiltroGeral_Permissao_Usuario TempFiltroGeral_Permissao_Usuario INNER JOIN #TempFiltroGeral_Permissao_UsuarioDel TempFiltroGeral_Permissao_UsuarioDel ON TempFiltroGeral_Permissao_Usuario.ID = TempFiltroGeral_Permissao_UsuarioDel.Id
                            END
                            DROP TABLE #TempFiltroGeral_Permissao_Usuario
                            DROP TABLE #TempFiltroGeral_Permissao_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [FiltroGeral_Permissao_Equipe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFiltroGeral_Permissao_Equipe

                            CREATE TABLE #TempFiltroGeral_Permissao_Equipe
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFiltroGeral_Permissao_Equipe (Id)
                            SELECT  [FPE].Id
                            FROM [FiltroGeral_Permissao_Equipe] FPE INNER JOIN [FiltroGeral] F ON FPE.[ID_Filtro] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFiltroGeral_Permissao_EquipeDel
                            CREATE TABLE #TempFiltroGeral_Permissao_EquipeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFiltroGeral_Permissao_Equipe))
                            BEGIN
                                TRUNCATE TABLE #TempFiltroGeral_Permissao_EquipeDel

                                INSERT #TempFiltroGeral_Permissao_EquipeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFiltroGeral_Permissao_Equipe
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFiltroGeral_Permissao_EquipeDel
                                DELETE FPE
                                FROM [FiltroGeral_Permissao_Equipe] FPE INNER JOIN #TempFiltroGeral_Permissao_EquipeDel TempFiltroGeral_Permissao_EquipeDel ON [FPE].ID = TempFiltroGeral_Permissao_EquipeDel.Id
                                WHERE [FPE].ID >= @MinId AND [FPE].ID <= @MaxId
                                        
                                DELETE #TempFiltroGeral_Permissao_Equipe
                                FROM #TempFiltroGeral_Permissao_Equipe TempFiltroGeral_Permissao_Equipe INNER JOIN #TempFiltroGeral_Permissao_EquipeDel TempFiltroGeral_Permissao_EquipeDel ON TempFiltroGeral_Permissao_Equipe.ID = TempFiltroGeral_Permissao_EquipeDel.Id
                            END
                            DROP TABLE #TempFiltroGeral_Permissao_Equipe
                            DROP TABLE #TempFiltroGeral_Permissao_EquipeDel
                            GO
PRINT 'Running accountId 1 and table [FiltroGeral_Campo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFiltroGeral_Campo

                            CREATE TABLE #TempFiltroGeral_Campo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFiltroGeral_Campo (Id)
                            SELECT  [FC].Id
                            FROM [FiltroGeral_Campo] FC INNER JOIN [FiltroGeral] F ON FC.[ID_Filtro] = F.[ID]
                            WHERE [F].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFiltroGeral_CampoDel
                            CREATE TABLE #TempFiltroGeral_CampoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFiltroGeral_Campo))
                            BEGIN
                                TRUNCATE TABLE #TempFiltroGeral_CampoDel

                                INSERT #TempFiltroGeral_CampoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFiltroGeral_Campo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFiltroGeral_CampoDel
                                DELETE FC
                                FROM [FiltroGeral_Campo] FC INNER JOIN #TempFiltroGeral_CampoDel TempFiltroGeral_CampoDel ON [FC].ID = TempFiltroGeral_CampoDel.Id
                                WHERE [FC].ID >= @MinId AND [FC].ID <= @MaxId
                                        
                                DELETE #TempFiltroGeral_Campo
                                FROM #TempFiltroGeral_Campo TempFiltroGeral_Campo INNER JOIN #TempFiltroGeral_CampoDel TempFiltroGeral_CampoDel ON TempFiltroGeral_Campo.ID = TempFiltroGeral_CampoDel.Id
                            END
                            DROP TABLE #TempFiltroGeral_Campo
                            DROP TABLE #TempFiltroGeral_CampoDel
                            GO
PRINT 'Running accountId 1 and table [FiltroGeral]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempFiltroGeral

                            CREATE TABLE #TempFiltroGeral
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempFiltroGeral (Id)
                            SELECT  [FiltroGeral].Id
                            FROM [FiltroGeral] FiltroGeral
                            WHERE [FiltroGeral].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFiltroGeralDel
                            CREATE TABLE #TempFiltroGeralDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempFiltroGeral))
                            BEGIN
                                TRUNCATE TABLE #TempFiltroGeralDel

                                INSERT #TempFiltroGeralDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempFiltroGeral
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFiltroGeralDel
                                DELETE FiltroGeral
                                FROM [FiltroGeral] FiltroGeral INNER JOIN #TempFiltroGeralDel TempFiltroGeralDel ON [FiltroGeral].ID = TempFiltroGeralDel.Id
                                WHERE [FiltroGeral].ID >= @MinId AND [FiltroGeral].ID <= @MaxId
                                        
                                DELETE #TempFiltroGeral
                                FROM #TempFiltroGeral TempFiltroGeral INNER JOIN #TempFiltroGeralDel TempFiltroGeralDel ON TempFiltroGeral.ID = TempFiltroGeralDel.Id
                            END
                            DROP TABLE #TempFiltroGeral
                            DROP TABLE #TempFiltroGeralDel
                            GO
PRINT 'Running accountId 1 and table [Field]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempField

                            CREATE TABLE #TempField
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempField (Id)
                            SELECT  [Field].Id
                            FROM [Field] Field
                            WHERE [Field].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempFieldDel
                            CREATE TABLE #TempFieldDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempField))
                            BEGIN
                                TRUNCATE TABLE #TempFieldDel

                                INSERT #TempFieldDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempField
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempFieldDel
                                DELETE Field
                                FROM [Field] Field INNER JOIN #TempFieldDel TempFieldDel ON [Field].ID = TempFieldDel.Id
                                WHERE [Field].ID >= @MinId AND [Field].ID <= @MaxId
                                        
                                DELETE #TempField
                                FROM #TempField TempField INNER JOIN #TempFieldDel TempFieldDel ON TempField.ID = TempFieldDel.Id
                            END
                            DROP TABLE #TempField
                            DROP TABLE #TempFieldDel
                            GO
PRINT 'Running accountId 1 and table [External_Shared_Keys_RelatedPerson]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempExternal_Shared_Keys_RelatedPerson

                            CREATE TABLE #TempExternal_Shared_Keys_RelatedPerson
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempExternal_Shared_Keys_RelatedPerson (Id)
                            SELECT  [External_Shared_Keys_RelatedPerson].Id
                            FROM [External_Shared_Keys_RelatedPerson] External_Shared_Keys_RelatedPerson
                            WHERE [External_Shared_Keys_RelatedPerson].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempExternal_Shared_Keys_RelatedPersonDel
                            CREATE TABLE #TempExternal_Shared_Keys_RelatedPersonDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempExternal_Shared_Keys_RelatedPerson))
                            BEGIN
                                TRUNCATE TABLE #TempExternal_Shared_Keys_RelatedPersonDel

                                INSERT #TempExternal_Shared_Keys_RelatedPersonDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempExternal_Shared_Keys_RelatedPerson
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempExternal_Shared_Keys_RelatedPersonDel
                                DELETE External_Shared_Keys_RelatedPerson
                                FROM [External_Shared_Keys_RelatedPerson] External_Shared_Keys_RelatedPerson INNER JOIN #TempExternal_Shared_Keys_RelatedPersonDel TempExternal_Shared_Keys_RelatedPersonDel ON [External_Shared_Keys_RelatedPerson].ID = TempExternal_Shared_Keys_RelatedPersonDel.Id
                                WHERE [External_Shared_Keys_RelatedPerson].ID >= @MinId AND [External_Shared_Keys_RelatedPerson].ID <= @MaxId
                                        
                                DELETE #TempExternal_Shared_Keys_RelatedPerson
                                FROM #TempExternal_Shared_Keys_RelatedPerson TempExternal_Shared_Keys_RelatedPerson INNER JOIN #TempExternal_Shared_Keys_RelatedPersonDel TempExternal_Shared_Keys_RelatedPersonDel ON TempExternal_Shared_Keys_RelatedPerson.ID = TempExternal_Shared_Keys_RelatedPersonDel.Id
                            END
                            DROP TABLE #TempExternal_Shared_Keys_RelatedPerson
                            DROP TABLE #TempExternal_Shared_Keys_RelatedPersonDel
                            GO
PRINT 'Running accountId 1 and table [External_Shared_Keys_Quote]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempExternal_Shared_Keys_Quote

                            CREATE TABLE #TempExternal_Shared_Keys_Quote
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempExternal_Shared_Keys_Quote (Id)
                            SELECT  [External_Shared_Keys_Quote].Id
                            FROM [External_Shared_Keys_Quote] External_Shared_Keys_Quote
                            WHERE [External_Shared_Keys_Quote].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempExternal_Shared_Keys_QuoteDel
                            CREATE TABLE #TempExternal_Shared_Keys_QuoteDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempExternal_Shared_Keys_Quote))
                            BEGIN
                                TRUNCATE TABLE #TempExternal_Shared_Keys_QuoteDel

                                INSERT #TempExternal_Shared_Keys_QuoteDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempExternal_Shared_Keys_Quote
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempExternal_Shared_Keys_QuoteDel
                                DELETE External_Shared_Keys_Quote
                                FROM [External_Shared_Keys_Quote] External_Shared_Keys_Quote INNER JOIN #TempExternal_Shared_Keys_QuoteDel TempExternal_Shared_Keys_QuoteDel ON [External_Shared_Keys_Quote].ID = TempExternal_Shared_Keys_QuoteDel.Id
                                WHERE [External_Shared_Keys_Quote].ID >= @MinId AND [External_Shared_Keys_Quote].ID <= @MaxId
                                        
                                DELETE #TempExternal_Shared_Keys_Quote
                                FROM #TempExternal_Shared_Keys_Quote TempExternal_Shared_Keys_Quote INNER JOIN #TempExternal_Shared_Keys_QuoteDel TempExternal_Shared_Keys_QuoteDel ON TempExternal_Shared_Keys_Quote.ID = TempExternal_Shared_Keys_QuoteDel.Id
                            END
                            DROP TABLE #TempExternal_Shared_Keys_Quote
                            DROP TABLE #TempExternal_Shared_Keys_QuoteDel
                            GO
PRINT 'Running accountId 1 and table [External_Shared_Keys_Order]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempExternal_Shared_Keys_Order

                            CREATE TABLE #TempExternal_Shared_Keys_Order
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempExternal_Shared_Keys_Order (Id)
                            SELECT  [External_Shared_Keys_Order].Id
                            FROM [External_Shared_Keys_Order] External_Shared_Keys_Order
                            WHERE [External_Shared_Keys_Order].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempExternal_Shared_Keys_OrderDel
                            CREATE TABLE #TempExternal_Shared_Keys_OrderDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempExternal_Shared_Keys_Order))
                            BEGIN
                                TRUNCATE TABLE #TempExternal_Shared_Keys_OrderDel

                                INSERT #TempExternal_Shared_Keys_OrderDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempExternal_Shared_Keys_Order
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempExternal_Shared_Keys_OrderDel
                                DELETE External_Shared_Keys_Order
                                FROM [External_Shared_Keys_Order] External_Shared_Keys_Order INNER JOIN #TempExternal_Shared_Keys_OrderDel TempExternal_Shared_Keys_OrderDel ON [External_Shared_Keys_Order].ID = TempExternal_Shared_Keys_OrderDel.Id
                                WHERE [External_Shared_Keys_Order].ID >= @MinId AND [External_Shared_Keys_Order].ID <= @MaxId
                                        
                                DELETE #TempExternal_Shared_Keys_Order
                                FROM #TempExternal_Shared_Keys_Order TempExternal_Shared_Keys_Order INNER JOIN #TempExternal_Shared_Keys_OrderDel TempExternal_Shared_Keys_OrderDel ON TempExternal_Shared_Keys_Order.ID = TempExternal_Shared_Keys_OrderDel.Id
                            END
                            DROP TABLE #TempExternal_Shared_Keys_Order
                            DROP TABLE #TempExternal_Shared_Keys_OrderDel
                            GO
PRINT 'Running accountId 1 and table [External_Shared_Keys_Document]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempExternal_Shared_Keys_Document

                            CREATE TABLE #TempExternal_Shared_Keys_Document
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempExternal_Shared_Keys_Document (Id)
                            SELECT  [External_Shared_Keys_Document].Id
                            FROM [External_Shared_Keys_Document] External_Shared_Keys_Document
                            WHERE [External_Shared_Keys_Document].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempExternal_Shared_Keys_DocumentDel
                            CREATE TABLE #TempExternal_Shared_Keys_DocumentDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempExternal_Shared_Keys_Document))
                            BEGIN
                                TRUNCATE TABLE #TempExternal_Shared_Keys_DocumentDel

                                INSERT #TempExternal_Shared_Keys_DocumentDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempExternal_Shared_Keys_Document
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempExternal_Shared_Keys_DocumentDel
                                DELETE External_Shared_Keys_Document
                                FROM [External_Shared_Keys_Document] External_Shared_Keys_Document INNER JOIN #TempExternal_Shared_Keys_DocumentDel TempExternal_Shared_Keys_DocumentDel ON [External_Shared_Keys_Document].ID = TempExternal_Shared_Keys_DocumentDel.Id
                                WHERE [External_Shared_Keys_Document].ID >= @MinId AND [External_Shared_Keys_Document].ID <= @MaxId
                                        
                                DELETE #TempExternal_Shared_Keys_Document
                                FROM #TempExternal_Shared_Keys_Document TempExternal_Shared_Keys_Document INNER JOIN #TempExternal_Shared_Keys_DocumentDel TempExternal_Shared_Keys_DocumentDel ON TempExternal_Shared_Keys_Document.ID = TempExternal_Shared_Keys_DocumentDel.Id
                            END
                            DROP TABLE #TempExternal_Shared_Keys_Document
                            DROP TABLE #TempExternal_Shared_Keys_DocumentDel
                            GO
PRINT 'Running accountId 1 and table [Equipe_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempEquipe_Usuario

                            CREATE TABLE #TempEquipe_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempEquipe_Usuario (Id)
                            SELECT  [EU].Id
                            FROM [Equipe_Usuario] EU INNER JOIN [Equipe] E ON EU.[ID_Equipe] = E.[ID]
                            WHERE [E].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempEquipe_UsuarioDel
                            CREATE TABLE #TempEquipe_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempEquipe_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempEquipe_UsuarioDel

                                INSERT #TempEquipe_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempEquipe_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempEquipe_UsuarioDel
                                DELETE EU
                                FROM [Equipe_Usuario] EU INNER JOIN #TempEquipe_UsuarioDel TempEquipe_UsuarioDel ON [EU].ID = TempEquipe_UsuarioDel.Id
                                WHERE [EU].ID >= @MinId AND [EU].ID <= @MaxId
                                        
                                DELETE #TempEquipe_Usuario
                                FROM #TempEquipe_Usuario TempEquipe_Usuario INNER JOIN #TempEquipe_UsuarioDel TempEquipe_UsuarioDel ON TempEquipe_Usuario.ID = TempEquipe_UsuarioDel.Id
                            END
                            DROP TABLE #TempEquipe_Usuario
                            DROP TABLE #TempEquipe_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Tabela_Permissao_Equipe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTabela_Permissao_Equipe

                            CREATE TABLE #TempTabela_Permissao_Equipe
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTabela_Permissao_Equipe (Id)
                            SELECT  [TPE].Id
                            FROM [Tabela_Permissao_Equipe] TPE INNER JOIN [Equipe] E ON TPE.[ID_Equipe] = E.[ID]
                            WHERE [E].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTabela_Permissao_EquipeDel
                            CREATE TABLE #TempTabela_Permissao_EquipeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTabela_Permissao_Equipe))
                            BEGIN
                                TRUNCATE TABLE #TempTabela_Permissao_EquipeDel

                                INSERT #TempTabela_Permissao_EquipeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTabela_Permissao_Equipe
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTabela_Permissao_EquipeDel
                                DELETE TPE
                                FROM [Tabela_Permissao_Equipe] TPE INNER JOIN #TempTabela_Permissao_EquipeDel TempTabela_Permissao_EquipeDel ON [TPE].ID = TempTabela_Permissao_EquipeDel.Id
                                WHERE [TPE].ID >= @MinId AND [TPE].ID <= @MaxId
                                        
                                DELETE #TempTabela_Permissao_Equipe
                                FROM #TempTabela_Permissao_Equipe TempTabela_Permissao_Equipe INNER JOIN #TempTabela_Permissao_EquipeDel TempTabela_Permissao_EquipeDel ON TempTabela_Permissao_Equipe.ID = TempTabela_Permissao_EquipeDel.Id
                            END
                            DROP TABLE #TempTabela_Permissao_Equipe
                            DROP TABLE #TempTabela_Permissao_EquipeDel
                            GO
PRINT 'Running accountId 1 and table [Produto_Grupo_Permissao_Equipe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempProduto_Grupo_Permissao_Equipe

                            CREATE TABLE #TempProduto_Grupo_Permissao_Equipe
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempProduto_Grupo_Permissao_Equipe (Id)
                            SELECT  [PE].Id
                            FROM [Produto_Grupo_Permissao_Equipe] PE INNER JOIN [Equipe] E ON PE.[ID_Equipe] = E.[ID]
                            WHERE [E].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempProduto_Grupo_Permissao_EquipeDel
                            CREATE TABLE #TempProduto_Grupo_Permissao_EquipeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempProduto_Grupo_Permissao_Equipe))
                            BEGIN
                                TRUNCATE TABLE #TempProduto_Grupo_Permissao_EquipeDel

                                INSERT #TempProduto_Grupo_Permissao_EquipeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempProduto_Grupo_Permissao_Equipe
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempProduto_Grupo_Permissao_EquipeDel
                                DELETE PE
                                FROM [Produto_Grupo_Permissao_Equipe] PE INNER JOIN #TempProduto_Grupo_Permissao_EquipeDel TempProduto_Grupo_Permissao_EquipeDel ON [PE].ID = TempProduto_Grupo_Permissao_EquipeDel.Id
                                WHERE [PE].ID >= @MinId AND [PE].ID <= @MaxId
                                        
                                DELETE #TempProduto_Grupo_Permissao_Equipe
                                FROM #TempProduto_Grupo_Permissao_Equipe TempProduto_Grupo_Permissao_Equipe INNER JOIN #TempProduto_Grupo_Permissao_EquipeDel TempProduto_Grupo_Permissao_EquipeDel ON TempProduto_Grupo_Permissao_Equipe.ID = TempProduto_Grupo_Permissao_EquipeDel.Id
                            END
                            DROP TABLE #TempProduto_Grupo_Permissao_Equipe
                            DROP TABLE #TempProduto_Grupo_Permissao_EquipeDel
                            GO
PRINT 'Running accountId 1 and table [Permission_Team]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPermission_Team

                            CREATE TABLE #TempPermission_Team
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPermission_Team (Id)
                            SELECT  [PT].Id
                            FROM [Permission_Team] PT INNER JOIN [Equipe] E ON PT.TeamId = E.ID
                            WHERE [E].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPermission_TeamDel
                            CREATE TABLE #TempPermission_TeamDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPermission_Team))
                            BEGIN
                                TRUNCATE TABLE #TempPermission_TeamDel

                                INSERT #TempPermission_TeamDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPermission_Team
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPermission_TeamDel
                                DELETE PT
                                FROM [Permission_Team] PT INNER JOIN #TempPermission_TeamDel TempPermission_TeamDel ON [PT].ID = TempPermission_TeamDel.Id
                                WHERE [PT].ID >= @MinId AND [PT].ID <= @MaxId
                                        
                                DELETE #TempPermission_Team
                                FROM #TempPermission_Team TempPermission_Team INNER JOIN #TempPermission_TeamDel TempPermission_TeamDel ON TempPermission_Team.ID = TempPermission_TeamDel.Id
                            END
                            DROP TABLE #TempPermission_Team
                            DROP TABLE #TempPermission_TeamDel
                            GO
PRINT 'Running accountId 1 and table [Informe_Equipe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempInforme_Equipe

                            CREATE TABLE #TempInforme_Equipe
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempInforme_Equipe (Id)
                            SELECT  [IE].Id
                            FROM [Informe_Equipe] IE INNER JOIN [Equipe] E ON IE.[ID_Equipe] = E.[ID]
                            WHERE [E].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempInforme_EquipeDel
                            CREATE TABLE #TempInforme_EquipeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempInforme_Equipe))
                            BEGIN
                                TRUNCATE TABLE #TempInforme_EquipeDel

                                INSERT #TempInforme_EquipeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempInforme_Equipe
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempInforme_EquipeDel
                                DELETE IE
                                FROM [Informe_Equipe] IE INNER JOIN #TempInforme_EquipeDel TempInforme_EquipeDel ON [IE].ID = TempInforme_EquipeDel.Id
                                WHERE [IE].ID >= @MinId AND [IE].ID <= @MaxId
                                        
                                DELETE #TempInforme_Equipe
                                FROM #TempInforme_Equipe TempInforme_Equipe INNER JOIN #TempInforme_EquipeDel TempInforme_EquipeDel ON TempInforme_Equipe.ID = TempInforme_EquipeDel.Id
                            END
                            DROP TABLE #TempInforme_Equipe
                            DROP TABLE #TempInforme_EquipeDel
                            GO
PRINT 'Running accountId 1 and table [Equipe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempEquipe

                            CREATE TABLE #TempEquipe
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempEquipe (Id)
                            SELECT  [Equipe].Id
                            FROM [Equipe] Equipe
                            WHERE [Equipe].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempEquipeDel
                            CREATE TABLE #TempEquipeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempEquipe))
                            BEGIN
                                TRUNCATE TABLE #TempEquipeDel

                                INSERT #TempEquipeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempEquipe
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempEquipeDel
                                DELETE Equipe
                                FROM [Equipe] Equipe INNER JOIN #TempEquipeDel TempEquipeDel ON [Equipe].ID = TempEquipeDel.Id
                                WHERE [Equipe].ID >= @MinId AND [Equipe].ID <= @MaxId
                                        
                                DELETE #TempEquipe
                                FROM #TempEquipe TempEquipe INNER JOIN #TempEquipeDel TempEquipeDel ON TempEquipe.ID = TempEquipeDel.Id
                            END
                            DROP TABLE #TempEquipe
                            DROP TABLE #TempEquipeDel
                            GO
PRINT 'Running accountId 1 and table [Email_Template_SubjectVariable]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempEmail_Template_SubjectVariable

                            CREATE TABLE #TempEmail_Template_SubjectVariable
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempEmail_Template_SubjectVariable (Id)
                            SELECT  [ETS].Id
                            FROM [Email_Template_SubjectVariable] ETS INNER JOIN [Email_Template] ET ON ETS.[TemplateId] = ET.[ID]
                            WHERE [ET].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempEmail_Template_SubjectVariableDel
                            CREATE TABLE #TempEmail_Template_SubjectVariableDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempEmail_Template_SubjectVariable))
                            BEGIN
                                TRUNCATE TABLE #TempEmail_Template_SubjectVariableDel

                                INSERT #TempEmail_Template_SubjectVariableDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempEmail_Template_SubjectVariable
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempEmail_Template_SubjectVariableDel
                                DELETE ETS
                                FROM [Email_Template_SubjectVariable] ETS INNER JOIN #TempEmail_Template_SubjectVariableDel TempEmail_Template_SubjectVariableDel ON [ETS].ID = TempEmail_Template_SubjectVariableDel.Id
                                WHERE [ETS].ID >= @MinId AND [ETS].ID <= @MaxId
                                        
                                DELETE #TempEmail_Template_SubjectVariable
                                FROM #TempEmail_Template_SubjectVariable TempEmail_Template_SubjectVariable INNER JOIN #TempEmail_Template_SubjectVariableDel TempEmail_Template_SubjectVariableDel ON TempEmail_Template_SubjectVariable.ID = TempEmail_Template_SubjectVariableDel.Id
                            END
                            DROP TABLE #TempEmail_Template_SubjectVariable
                            DROP TABLE #TempEmail_Template_SubjectVariableDel
                            GO
PRINT 'Running accountId 1 and table [Email_Template_Permissao_Equipe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempEmail_Template_Permissao_Equipe

                            CREATE TABLE #TempEmail_Template_Permissao_Equipe
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempEmail_Template_Permissao_Equipe (Id)
                            SELECT  [ETPE].Id
                            FROM [Email_Template_Permissao_Equipe] ETPE INNER JOIN [Email_Template] ET ON ETPE.[ID_Template] = ET.[ID]
                            WHERE [ET].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempEmail_Template_Permissao_EquipeDel
                            CREATE TABLE #TempEmail_Template_Permissao_EquipeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempEmail_Template_Permissao_Equipe))
                            BEGIN
                                TRUNCATE TABLE #TempEmail_Template_Permissao_EquipeDel

                                INSERT #TempEmail_Template_Permissao_EquipeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempEmail_Template_Permissao_Equipe
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempEmail_Template_Permissao_EquipeDel
                                DELETE ETPE
                                FROM [Email_Template_Permissao_Equipe] ETPE INNER JOIN #TempEmail_Template_Permissao_EquipeDel TempEmail_Template_Permissao_EquipeDel ON [ETPE].ID = TempEmail_Template_Permissao_EquipeDel.Id
                                WHERE [ETPE].ID >= @MinId AND [ETPE].ID <= @MaxId
                                        
                                DELETE #TempEmail_Template_Permissao_Equipe
                                FROM #TempEmail_Template_Permissao_Equipe TempEmail_Template_Permissao_Equipe INNER JOIN #TempEmail_Template_Permissao_EquipeDel TempEmail_Template_Permissao_EquipeDel ON TempEmail_Template_Permissao_Equipe.ID = TempEmail_Template_Permissao_EquipeDel.Id
                            END
                            DROP TABLE #TempEmail_Template_Permissao_Equipe
                            DROP TABLE #TempEmail_Template_Permissao_EquipeDel
                            GO
PRINT 'Running accountId 1 and table [Email_Template_Permissao_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempEmail_Template_Permissao_Usuario

                            CREATE TABLE #TempEmail_Template_Permissao_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempEmail_Template_Permissao_Usuario (Id)
                            SELECT  [ETPU].Id
                            FROM [Email_Template_Permissao_Usuario] ETPU INNER JOIN [Email_Template] ET ON ETPU.[ID_Template] = ET.[ID]
                            WHERE [ET].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempEmail_Template_Permissao_UsuarioDel
                            CREATE TABLE #TempEmail_Template_Permissao_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempEmail_Template_Permissao_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempEmail_Template_Permissao_UsuarioDel

                                INSERT #TempEmail_Template_Permissao_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempEmail_Template_Permissao_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempEmail_Template_Permissao_UsuarioDel
                                DELETE ETPU
                                FROM [Email_Template_Permissao_Usuario] ETPU INNER JOIN #TempEmail_Template_Permissao_UsuarioDel TempEmail_Template_Permissao_UsuarioDel ON [ETPU].ID = TempEmail_Template_Permissao_UsuarioDel.Id
                                WHERE [ETPU].ID >= @MinId AND [ETPU].ID <= @MaxId
                                        
                                DELETE #TempEmail_Template_Permissao_Usuario
                                FROM #TempEmail_Template_Permissao_Usuario TempEmail_Template_Permissao_Usuario INNER JOIN #TempEmail_Template_Permissao_UsuarioDel TempEmail_Template_Permissao_UsuarioDel ON TempEmail_Template_Permissao_Usuario.ID = TempEmail_Template_Permissao_UsuarioDel.Id
                            END
                            DROP TABLE #TempEmail_Template_Permissao_Usuario
                            DROP TABLE #TempEmail_Template_Permissao_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Email_Template]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempEmail_Template

                            CREATE TABLE #TempEmail_Template
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempEmail_Template (Id)
                            SELECT  [Email_Template].Id
                            FROM [Email_Template] Email_Template
                            WHERE [Email_Template].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempEmail_TemplateDel
                            CREATE TABLE #TempEmail_TemplateDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempEmail_Template))
                            BEGIN
                                TRUNCATE TABLE #TempEmail_TemplateDel

                                INSERT #TempEmail_TemplateDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempEmail_Template
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempEmail_TemplateDel
                                DELETE Email_Template
                                FROM [Email_Template] Email_Template INNER JOIN #TempEmail_TemplateDel TempEmail_TemplateDel ON [Email_Template].ID = TempEmail_TemplateDel.Id
                                WHERE [Email_Template].ID >= @MinId AND [Email_Template].ID <= @MaxId
                                        
                                DELETE #TempEmail_Template
                                FROM #TempEmail_Template TempEmail_Template INNER JOIN #TempEmail_TemplateDel TempEmail_TemplateDel ON TempEmail_Template.ID = TempEmail_TemplateDel.Id
                            END
                            DROP TABLE #TempEmail_Template
                            DROP TABLE #TempEmail_TemplateDel
                            GO
PRINT 'Running accountId 1 and table [Document_Product_Part]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDocument_Product_Part

                            CREATE TABLE #TempDocument_Product_Part
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDocument_Product_Part (Id)
                            SELECT  [DPP].Id
                            FROM [Document_Product_Part] DPP INNER JOIN [Document_Product]  DP ON DPP.[DocumentProductId] = DP.[ID] INNER JOIN [Document] D ON DP.[DocumentId] = D.[Id]
                            WHERE [D].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDocument_Product_PartDel
                            CREATE TABLE #TempDocument_Product_PartDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDocument_Product_Part))
                            BEGIN
                                TRUNCATE TABLE #TempDocument_Product_PartDel

                                INSERT #TempDocument_Product_PartDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDocument_Product_Part
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDocument_Product_PartDel
                                DELETE DPP
                                FROM [Document_Product_Part] DPP INNER JOIN #TempDocument_Product_PartDel TempDocument_Product_PartDel ON [DPP].ID = TempDocument_Product_PartDel.Id
                                WHERE [DPP].ID >= @MinId AND [DPP].ID <= @MaxId
                                        
                                DELETE #TempDocument_Product_Part
                                FROM #TempDocument_Product_Part TempDocument_Product_Part INNER JOIN #TempDocument_Product_PartDel TempDocument_Product_PartDel ON TempDocument_Product_Part.ID = TempDocument_Product_PartDel.Id
                            END
                            DROP TABLE #TempDocument_Product_Part
                            DROP TABLE #TempDocument_Product_PartDel
                            GO
PRINT 'Running accountId 1 and table [Document_Product]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDocument_Product

                            CREATE TABLE #TempDocument_Product
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDocument_Product (Id)
                            SELECT  [Document_Product].Id
                            FROM [Document_Product] Document_Product
                            WHERE [Document_Product].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDocument_ProductDel
                            CREATE TABLE #TempDocument_ProductDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDocument_Product))
                            BEGIN
                                TRUNCATE TABLE #TempDocument_ProductDel

                                INSERT #TempDocument_ProductDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDocument_Product
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDocument_ProductDel
                                DELETE Document_Product
                                FROM [Document_Product] Document_Product INNER JOIN #TempDocument_ProductDel TempDocument_ProductDel ON [Document_Product].ID = TempDocument_ProductDel.Id
                                WHERE [Document_Product].ID >= @MinId AND [Document_Product].ID <= @MaxId
                                        
                                DELETE #TempDocument_Product
                                FROM #TempDocument_Product TempDocument_Product INNER JOIN #TempDocument_ProductDel TempDocument_ProductDel ON TempDocument_Product.ID = TempDocument_ProductDel.Id
                            END
                            DROP TABLE #TempDocument_Product
                            DROP TABLE #TempDocument_ProductDel
                            GO
PRINT 'Running accountId 1 and table [Document_Page]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDocument_Page

                            CREATE TABLE #TempDocument_Page
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDocument_Page (Id)
                            SELECT  [DP].Id
                            FROM [Document_Page] DP INNER JOIN [Document] D ON DP.[DocumentId] = D.[Id]
                            WHERE [D].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDocument_PageDel
                            CREATE TABLE #TempDocument_PageDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDocument_Page))
                            BEGIN
                                TRUNCATE TABLE #TempDocument_PageDel

                                INSERT #TempDocument_PageDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDocument_Page
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDocument_PageDel
                                DELETE DP
                                FROM [Document_Page] DP INNER JOIN #TempDocument_PageDel TempDocument_PageDel ON [DP].ID = TempDocument_PageDel.Id
                                WHERE [DP].ID >= @MinId AND [DP].ID <= @MaxId
                                        
                                DELETE #TempDocument_Page
                                FROM #TempDocument_Page TempDocument_Page INNER JOIN #TempDocument_PageDel TempDocument_PageDel ON TempDocument_Page.ID = TempDocument_PageDel.Id
                            END
                            DROP TABLE #TempDocument_Page
                            DROP TABLE #TempDocument_PageDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Revisao_Aceita_Historico]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Revisao_Aceita_Historico

                            CREATE TABLE #TempCotacao_Revisao_Aceita_Historico
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Revisao_Aceita_Historico (Id)
                            SELECT  [CRAH].Id
                            FROM [Cotacao_Revisao_Aceita_Historico] CRAH INNER JOIN [Document] D ON CRAH.[ID_Documento] = D.ID
                            WHERE [D].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Revisao_Aceita_HistoricoDel
                            CREATE TABLE #TempCotacao_Revisao_Aceita_HistoricoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Revisao_Aceita_Historico))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Revisao_Aceita_HistoricoDel

                                INSERT #TempCotacao_Revisao_Aceita_HistoricoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Revisao_Aceita_Historico
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Revisao_Aceita_HistoricoDel
                                DELETE CRAH
                                FROM [Cotacao_Revisao_Aceita_Historico] CRAH INNER JOIN #TempCotacao_Revisao_Aceita_HistoricoDel TempCotacao_Revisao_Aceita_HistoricoDel ON [CRAH].ID = TempCotacao_Revisao_Aceita_HistoricoDel.Id
                                WHERE [CRAH].ID >= @MinId AND [CRAH].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Revisao_Aceita_Historico
                                FROM #TempCotacao_Revisao_Aceita_Historico TempCotacao_Revisao_Aceita_Historico INNER JOIN #TempCotacao_Revisao_Aceita_HistoricoDel TempCotacao_Revisao_Aceita_HistoricoDel ON TempCotacao_Revisao_Aceita_Historico.ID = TempCotacao_Revisao_Aceita_HistoricoDel.Id
                            END
                            DROP TABLE #TempCotacao_Revisao_Aceita_Historico
                            DROP TABLE #TempCotacao_Revisao_Aceita_HistoricoDel
                            GO
PRINT 'Running accountId 1 and table [Document_Query]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDocument_Query

                            CREATE TABLE #TempDocument_Query
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDocument_Query (Id)
                            SELECT  [DQ].Id
                            FROM [Document_Query] DQ INNER JOIN [Document] D ON DQ.[DocumentId] = D.[Id]
                            WHERE [D].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDocument_QueryDel
                            CREATE TABLE #TempDocument_QueryDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDocument_Query))
                            BEGIN
                                TRUNCATE TABLE #TempDocument_QueryDel

                                INSERT #TempDocument_QueryDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDocument_Query
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDocument_QueryDel
                                DELETE DQ
                                FROM [Document_Query] DQ INNER JOIN #TempDocument_QueryDel TempDocument_QueryDel ON [DQ].ID = TempDocument_QueryDel.Id
                                WHERE [DQ].ID >= @MinId AND [DQ].ID <= @MaxId
                                        
                                DELETE #TempDocument_Query
                                FROM #TempDocument_Query TempDocument_Query INNER JOIN #TempDocument_QueryDel TempDocument_QueryDel ON TempDocument_Query.ID = TempDocument_QueryDel.Id
                            END
                            DROP TABLE #TempDocument_Query
                            DROP TABLE #TempDocument_QueryDel
                            GO
PRINT 'Running accountId 1 and table [Document_Section]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDocument_Section

                            CREATE TABLE #TempDocument_Section
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDocument_Section (Id)
                            SELECT  [DS].Id
                            FROM [Document_Section] DS INNER JOIN [Document] D ON DS.[DocumentId] = D.[Id]
                            WHERE [D].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDocument_SectionDel
                            CREATE TABLE #TempDocument_SectionDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDocument_Section))
                            BEGIN
                                TRUNCATE TABLE #TempDocument_SectionDel

                                INSERT #TempDocument_SectionDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDocument_Section
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDocument_SectionDel
                                DELETE DS
                                FROM [Document_Section] DS INNER JOIN #TempDocument_SectionDel TempDocument_SectionDel ON [DS].ID = TempDocument_SectionDel.Id
                                WHERE [DS].ID >= @MinId AND [DS].ID <= @MaxId
                                        
                                DELETE #TempDocument_Section
                                FROM #TempDocument_Section TempDocument_Section INNER JOIN #TempDocument_SectionDel TempDocument_SectionDel ON TempDocument_Section.ID = TempDocument_SectionDel.Id
                            END
                            DROP TABLE #TempDocument_Section
                            DROP TABLE #TempDocument_SectionDel
                            GO
PRINT 'Running accountId 1 and table [Document_Installment]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDocument_Installment

                            CREATE TABLE #TempDocument_Installment
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDocument_Installment (Id)
                            SELECT  [DI].Id
                            FROM [Document_Installment] DI INNER JOIN [Document] D ON DI.[DocumentId] = D.[Id]
                            WHERE [D].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDocument_InstallmentDel
                            CREATE TABLE #TempDocument_InstallmentDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDocument_Installment))
                            BEGIN
                                TRUNCATE TABLE #TempDocument_InstallmentDel

                                INSERT #TempDocument_InstallmentDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDocument_Installment
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDocument_InstallmentDel
                                DELETE DI
                                FROM [Document_Installment] DI INNER JOIN #TempDocument_InstallmentDel TempDocument_InstallmentDel ON [DI].ID = TempDocument_InstallmentDel.Id
                                WHERE [DI].ID >= @MinId AND [DI].ID <= @MaxId
                                        
                                DELETE #TempDocument_Installment
                                FROM #TempDocument_Installment TempDocument_Installment INNER JOIN #TempDocument_InstallmentDel TempDocument_InstallmentDel ON TempDocument_Installment.ID = TempDocument_InstallmentDel.Id
                            END
                            DROP TABLE #TempDocument_Installment
                            DROP TABLE #TempDocument_InstallmentDel
                            GO
PRINT 'Running accountId 1 and table [Document_Approval]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDocument_Approval

                            CREATE TABLE #TempDocument_Approval
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDocument_Approval (Id)
                            SELECT  [DA].Id
                            FROM [Document_Approval] DA INNER JOIN [Document] D ON DA.[DocumentId] = D.[Id]
                            WHERE [D].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDocument_ApprovalDel
                            CREATE TABLE #TempDocument_ApprovalDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDocument_Approval))
                            BEGIN
                                TRUNCATE TABLE #TempDocument_ApprovalDel

                                INSERT #TempDocument_ApprovalDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDocument_Approval
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDocument_ApprovalDel
                                DELETE DA
                                FROM [Document_Approval] DA INNER JOIN #TempDocument_ApprovalDel TempDocument_ApprovalDel ON [DA].ID = TempDocument_ApprovalDel.Id
                                WHERE [DA].ID >= @MinId AND [DA].ID <= @MaxId
                                        
                                DELETE #TempDocument_Approval
                                FROM #TempDocument_Approval TempDocument_Approval INNER JOIN #TempDocument_ApprovalDel TempDocument_ApprovalDel ON TempDocument_Approval.ID = TempDocument_ApprovalDel.Id
                            END
                            DROP TABLE #TempDocument_Approval
                            DROP TABLE #TempDocument_ApprovalDel
                            GO
PRINT 'Running accountId 1 and table [Document]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDocument

                            CREATE TABLE #TempDocument
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDocument (Id)
                            SELECT  [Document].Id
                            FROM [Document] Document
                            WHERE [Document].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDocumentDel
                            CREATE TABLE #TempDocumentDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDocument))
                            BEGIN
                                TRUNCATE TABLE #TempDocumentDel

                                INSERT #TempDocumentDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDocument
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDocumentDel
                                DELETE Document
                                FROM [Document] Document INNER JOIN #TempDocumentDel TempDocumentDel ON [Document].ID = TempDocumentDel.Id
                                WHERE [Document].ID >= @MinId AND [Document].ID <= @MaxId
                                        
                                DELETE #TempDocument
                                FROM #TempDocument TempDocument INNER JOIN #TempDocumentDel TempDocumentDel ON TempDocument.ID = TempDocumentDel.Id
                            END
                            DROP TABLE #TempDocument
                            DROP TABLE #TempDocumentDel
                            GO
PRINT 'Running accountId 1 and table [Departamento]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDepartamento

                            CREATE TABLE #TempDepartamento
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDepartamento (Id)
                            SELECT  [Departamento].Id
                            FROM [Departamento] Departamento
                            WHERE [Departamento].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDepartamentoDel
                            CREATE TABLE #TempDepartamentoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDepartamento))
                            BEGIN
                                TRUNCATE TABLE #TempDepartamentoDel

                                INSERT #TempDepartamentoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDepartamento
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDepartamentoDel
                                DELETE Departamento
                                FROM [Departamento] Departamento INNER JOIN #TempDepartamentoDel TempDepartamentoDel ON [Departamento].ID = TempDepartamentoDel.Id
                                WHERE [Departamento].ID >= @MinId AND [Departamento].ID <= @MaxId
                                        
                                DELETE #TempDepartamento
                                FROM #TempDepartamento TempDepartamento INNER JOIN #TempDepartamentoDel TempDepartamentoDel ON TempDepartamento.ID = TempDepartamentoDel.Id
                            END
                            DROP TABLE #TempDepartamento
                            DROP TABLE #TempDepartamentoDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Revisao_Tabela_Produto_Parte]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Revisao_Tabela_Produto_Parte

                            CREATE TABLE #TempCotacao_Revisao_Tabela_Produto_Parte
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Revisao_Tabela_Produto_Parte (Id)
                            SELECT  [CRTPP].Id
                            FROM [Cotacao_Revisao_Tabela_Produto_Parte] CRTPP INNER JOIN [Cotacao_Revisao_Tabela_Produto] CRTP ON CRTPP.[ID_RevisaoTabelaProduto] = CRTP.[ID]
                            WHERE [CRTP].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Revisao_Tabela_Produto_ParteDel
                            CREATE TABLE #TempCotacao_Revisao_Tabela_Produto_ParteDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Revisao_Tabela_Produto_Parte))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Revisao_Tabela_Produto_ParteDel

                                INSERT #TempCotacao_Revisao_Tabela_Produto_ParteDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Revisao_Tabela_Produto_Parte
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Revisao_Tabela_Produto_ParteDel
                                DELETE CRTPP
                                FROM [Cotacao_Revisao_Tabela_Produto_Parte] CRTPP INNER JOIN #TempCotacao_Revisao_Tabela_Produto_ParteDel TempCotacao_Revisao_Tabela_Produto_ParteDel ON [CRTPP].ID = TempCotacao_Revisao_Tabela_Produto_ParteDel.Id
                                WHERE [CRTPP].ID >= @MinId AND [CRTPP].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Revisao_Tabela_Produto_Parte
                                FROM #TempCotacao_Revisao_Tabela_Produto_Parte TempCotacao_Revisao_Tabela_Produto_Parte INNER JOIN #TempCotacao_Revisao_Tabela_Produto_ParteDel TempCotacao_Revisao_Tabela_Produto_ParteDel ON TempCotacao_Revisao_Tabela_Produto_Parte.ID = TempCotacao_Revisao_Tabela_Produto_ParteDel.Id
                            END
                            DROP TABLE #TempCotacao_Revisao_Tabela_Produto_Parte
                            DROP TABLE #TempCotacao_Revisao_Tabela_Produto_ParteDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Revisao_Tabela_Produto]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Revisao_Tabela_Produto

                            CREATE TABLE #TempCotacao_Revisao_Tabela_Produto
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Revisao_Tabela_Produto (Id)
                            SELECT  [Cotacao_Revisao_Tabela_Produto].Id
                            FROM [Cotacao_Revisao_Tabela_Produto] Cotacao_Revisao_Tabela_Produto
                            WHERE [Cotacao_Revisao_Tabela_Produto].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Revisao_Tabela_ProdutoDel
                            CREATE TABLE #TempCotacao_Revisao_Tabela_ProdutoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Revisao_Tabela_Produto))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Revisao_Tabela_ProdutoDel

                                INSERT #TempCotacao_Revisao_Tabela_ProdutoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Revisao_Tabela_Produto
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Revisao_Tabela_ProdutoDel
                                DELETE Cotacao_Revisao_Tabela_Produto
                                FROM [Cotacao_Revisao_Tabela_Produto] Cotacao_Revisao_Tabela_Produto INNER JOIN #TempCotacao_Revisao_Tabela_ProdutoDel TempCotacao_Revisao_Tabela_ProdutoDel ON [Cotacao_Revisao_Tabela_Produto].ID = TempCotacao_Revisao_Tabela_ProdutoDel.Id
                                WHERE [Cotacao_Revisao_Tabela_Produto].ID >= @MinId AND [Cotacao_Revisao_Tabela_Produto].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Revisao_Tabela_Produto
                                FROM #TempCotacao_Revisao_Tabela_Produto TempCotacao_Revisao_Tabela_Produto INNER JOIN #TempCotacao_Revisao_Tabela_ProdutoDel TempCotacao_Revisao_Tabela_ProdutoDel ON TempCotacao_Revisao_Tabela_Produto.ID = TempCotacao_Revisao_Tabela_ProdutoDel.Id
                            END
                            DROP TABLE #TempCotacao_Revisao_Tabela_Produto
                            DROP TABLE #TempCotacao_Revisao_Tabela_ProdutoDel
                            GO
PRINT 'Running accountId 1 and table [Document_Page]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDocument_Page

                            CREATE TABLE #TempDocument_Page
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDocument_Page (Id)
                            SELECT  [DP].Id
                            FROM [Document_Page] DP INNER JOIN [Cotacao_Revisao] CR ON DP.[QuoteId] = CR.[Id]
                            WHERE [CR].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDocument_PageDel
                            CREATE TABLE #TempDocument_PageDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDocument_Page))
                            BEGIN
                                TRUNCATE TABLE #TempDocument_PageDel

                                INSERT #TempDocument_PageDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDocument_Page
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDocument_PageDel
                                DELETE DP
                                FROM [Document_Page] DP INNER JOIN #TempDocument_PageDel TempDocument_PageDel ON [DP].ID = TempDocument_PageDel.Id
                                WHERE [DP].ID >= @MinId AND [DP].ID <= @MaxId
                                        
                                DELETE #TempDocument_Page
                                FROM #TempDocument_Page TempDocument_Page INNER JOIN #TempDocument_PageDel TempDocument_PageDel ON TempDocument_Page.ID = TempDocument_PageDel.Id
                            END
                            DROP TABLE #TempDocument_Page
                            DROP TABLE #TempDocument_PageDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Revisao_Tabela]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Revisao_Tabela

                            CREATE TABLE #TempCotacao_Revisao_Tabela
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Revisao_Tabela (Id)
                            SELECT  [CRT].Id
                            FROM [Cotacao_Revisao_Tabela] CRT INNER JOIN [Cotacao_Revisao] CR ON CRT.[ID_Revisao] = CR.[ID]
                            WHERE [CR].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Revisao_TabelaDel
                            CREATE TABLE #TempCotacao_Revisao_TabelaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Revisao_Tabela))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Revisao_TabelaDel

                                INSERT #TempCotacao_Revisao_TabelaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Revisao_Tabela
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Revisao_TabelaDel
                                DELETE CRT
                                FROM [Cotacao_Revisao_Tabela] CRT INNER JOIN #TempCotacao_Revisao_TabelaDel TempCotacao_Revisao_TabelaDel ON [CRT].ID = TempCotacao_Revisao_TabelaDel.Id
                                WHERE [CRT].ID >= @MinId AND [CRT].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Revisao_Tabela
                                FROM #TempCotacao_Revisao_Tabela TempCotacao_Revisao_Tabela INNER JOIN #TempCotacao_Revisao_TabelaDel TempCotacao_Revisao_TabelaDel ON TempCotacao_Revisao_Tabela.ID = TempCotacao_Revisao_TabelaDel.Id
                            END
                            DROP TABLE #TempCotacao_Revisao_Tabela
                            DROP TABLE #TempCotacao_Revisao_TabelaDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Revisao_Query]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Revisao_Query

                            CREATE TABLE #TempCotacao_Revisao_Query
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Revisao_Query (Id)
                            SELECT  [CRQ].Id
                            FROM [Cotacao_Revisao_Query] CRQ INNER JOIN [Cotacao_Revisao] CR ON CRQ.[QuoteId] = CR.ID
                            WHERE [CR].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Revisao_QueryDel
                            CREATE TABLE #TempCotacao_Revisao_QueryDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Revisao_Query))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Revisao_QueryDel

                                INSERT #TempCotacao_Revisao_QueryDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Revisao_Query
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Revisao_QueryDel
                                DELETE CRQ
                                FROM [Cotacao_Revisao_Query] CRQ INNER JOIN #TempCotacao_Revisao_QueryDel TempCotacao_Revisao_QueryDel ON [CRQ].ID = TempCotacao_Revisao_QueryDel.Id
                                WHERE [CRQ].ID >= @MinId AND [CRQ].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Revisao_Query
                                FROM #TempCotacao_Revisao_Query TempCotacao_Revisao_Query INNER JOIN #TempCotacao_Revisao_QueryDel TempCotacao_Revisao_QueryDel ON TempCotacao_Revisao_Query.ID = TempCotacao_Revisao_QueryDel.Id
                            END
                            DROP TABLE #TempCotacao_Revisao_Query
                            DROP TABLE #TempCotacao_Revisao_QueryDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Revisao_Parcela]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Revisao_Parcela

                            CREATE TABLE #TempCotacao_Revisao_Parcela
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Revisao_Parcela (Id)
                            SELECT  [CRP].Id
                            FROM [Cotacao_Revisao_Parcela] CRP INNER JOIN [Cotacao_Revisao] CR ON CRP.ID_Revisao = CR.ID 
                            WHERE [CR].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Revisao_ParcelaDel
                            CREATE TABLE #TempCotacao_Revisao_ParcelaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Revisao_Parcela))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Revisao_ParcelaDel

                                INSERT #TempCotacao_Revisao_ParcelaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Revisao_Parcela
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Revisao_ParcelaDel
                                DELETE CRP
                                FROM [Cotacao_Revisao_Parcela] CRP INNER JOIN #TempCotacao_Revisao_ParcelaDel TempCotacao_Revisao_ParcelaDel ON [CRP].ID = TempCotacao_Revisao_ParcelaDel.Id
                                WHERE [CRP].ID >= @MinId AND [CRP].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Revisao_Parcela
                                FROM #TempCotacao_Revisao_Parcela TempCotacao_Revisao_Parcela INNER JOIN #TempCotacao_Revisao_ParcelaDel TempCotacao_Revisao_ParcelaDel ON TempCotacao_Revisao_Parcela.ID = TempCotacao_Revisao_ParcelaDel.Id
                            END
                            DROP TABLE #TempCotacao_Revisao_Parcela
                            DROP TABLE #TempCotacao_Revisao_ParcelaDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Revisao_Aprovacao_Historico]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Revisao_Aprovacao_Historico

                            CREATE TABLE #TempCotacao_Revisao_Aprovacao_Historico
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Revisao_Aprovacao_Historico (Id)
                            SELECT  [CRAH].Id
                            FROM [Cotacao_Revisao_Aprovacao_Historico] CRAH INNER JOIN [Cotacao_Revisao] CR ON CRAH.[ID_Revisao] = CR.ID
                            WHERE [CR].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Revisao_Aprovacao_HistoricoDel
                            CREATE TABLE #TempCotacao_Revisao_Aprovacao_HistoricoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Revisao_Aprovacao_Historico))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Revisao_Aprovacao_HistoricoDel

                                INSERT #TempCotacao_Revisao_Aprovacao_HistoricoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Revisao_Aprovacao_Historico
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Revisao_Aprovacao_HistoricoDel
                                DELETE CRAH
                                FROM [Cotacao_Revisao_Aprovacao_Historico] CRAH INNER JOIN #TempCotacao_Revisao_Aprovacao_HistoricoDel TempCotacao_Revisao_Aprovacao_HistoricoDel ON [CRAH].ID = TempCotacao_Revisao_Aprovacao_HistoricoDel.Id
                                WHERE [CRAH].ID >= @MinId AND [CRAH].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Revisao_Aprovacao_Historico
                                FROM #TempCotacao_Revisao_Aprovacao_Historico TempCotacao_Revisao_Aprovacao_Historico INNER JOIN #TempCotacao_Revisao_Aprovacao_HistoricoDel TempCotacao_Revisao_Aprovacao_HistoricoDel ON TempCotacao_Revisao_Aprovacao_Historico.ID = TempCotacao_Revisao_Aprovacao_HistoricoDel.Id
                            END
                            DROP TABLE #TempCotacao_Revisao_Aprovacao_Historico
                            DROP TABLE #TempCotacao_Revisao_Aprovacao_HistoricoDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Revisao_Aceita_Historico]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Revisao_Aceita_Historico

                            CREATE TABLE #TempCotacao_Revisao_Aceita_Historico
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Revisao_Aceita_Historico (Id)
                            SELECT  [CRAH].Id
                            FROM [Cotacao_Revisao_Aceita_Historico] CRAH INNER JOIN [Cotacao_Revisao] CR ON CRAH.[ID_Revisao] = CR.ID
                            WHERE [CR].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Revisao_Aceita_HistoricoDel
                            CREATE TABLE #TempCotacao_Revisao_Aceita_HistoricoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Revisao_Aceita_Historico))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Revisao_Aceita_HistoricoDel

                                INSERT #TempCotacao_Revisao_Aceita_HistoricoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Revisao_Aceita_Historico
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Revisao_Aceita_HistoricoDel
                                DELETE CRAH
                                FROM [Cotacao_Revisao_Aceita_Historico] CRAH INNER JOIN #TempCotacao_Revisao_Aceita_HistoricoDel TempCotacao_Revisao_Aceita_HistoricoDel ON [CRAH].ID = TempCotacao_Revisao_Aceita_HistoricoDel.Id
                                WHERE [CRAH].ID >= @MinId AND [CRAH].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Revisao_Aceita_Historico
                                FROM #TempCotacao_Revisao_Aceita_Historico TempCotacao_Revisao_Aceita_Historico INNER JOIN #TempCotacao_Revisao_Aceita_HistoricoDel TempCotacao_Revisao_Aceita_HistoricoDel ON TempCotacao_Revisao_Aceita_Historico.ID = TempCotacao_Revisao_Aceita_HistoricoDel.Id
                            END
                            DROP TABLE #TempCotacao_Revisao_Aceita_Historico
                            DROP TABLE #TempCotacao_Revisao_Aceita_HistoricoDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao

                            CREATE TABLE #TempCotacao
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao (Id)
                            SELECT  [C].Id
                            FROM [Cotacao] C INNER JOIN [Cotacao_Revisao] CR ON C.ID_UltimaRevisao = CR.ID 
                            WHERE [CR].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacaoDel
                            CREATE TABLE #TempCotacaoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao))
                            BEGIN
                                TRUNCATE TABLE #TempCotacaoDel

                                INSERT #TempCotacaoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacaoDel
                                DELETE C
                                FROM [Cotacao] C INNER JOIN #TempCotacaoDel TempCotacaoDel ON [C].ID = TempCotacaoDel.Id
                                WHERE [C].ID >= @MinId AND [C].ID <= @MaxId
                                        
                                DELETE #TempCotacao
                                FROM #TempCotacao TempCotacao INNER JOIN #TempCotacaoDel TempCotacaoDel ON TempCotacao.ID = TempCotacaoDel.Id
                            END
                            DROP TABLE #TempCotacao
                            DROP TABLE #TempCotacaoDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Revisao]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Revisao

                            CREATE TABLE #TempCotacao_Revisao
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Revisao (Id)
                            SELECT  [Cotacao_Revisao].Id
                            FROM [Cotacao_Revisao] Cotacao_Revisao
                            WHERE [Cotacao_Revisao].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_RevisaoDel
                            CREATE TABLE #TempCotacao_RevisaoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Revisao))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_RevisaoDel

                                INSERT #TempCotacao_RevisaoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Revisao
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_RevisaoDel
                                DELETE Cotacao_Revisao
                                FROM [Cotacao_Revisao] Cotacao_Revisao INNER JOIN #TempCotacao_RevisaoDel TempCotacao_RevisaoDel ON [Cotacao_Revisao].ID = TempCotacao_RevisaoDel.Id
                                WHERE [Cotacao_Revisao].ID >= @MinId AND [Cotacao_Revisao].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Revisao
                                FROM #TempCotacao_Revisao TempCotacao_Revisao INNER JOIN #TempCotacao_RevisaoDel TempCotacao_RevisaoDel ON TempCotacao_Revisao.ID = TempCotacao_RevisaoDel.Id
                            END
                            DROP TABLE #TempCotacao_Revisao
                            DROP TABLE #TempCotacao_RevisaoDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Modelo_Bloco]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Modelo_Bloco

                            CREATE TABLE #TempCotacao_Modelo_Bloco
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Modelo_Bloco (Id)
                            SELECT  [Cotacao_Modelo_Bloco].Id
                            FROM [Cotacao_Modelo_Bloco] Cotacao_Modelo_Bloco
                            WHERE [Cotacao_Modelo_Bloco].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Modelo_BlocoDel
                            CREATE TABLE #TempCotacao_Modelo_BlocoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Modelo_Bloco))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Modelo_BlocoDel

                                INSERT #TempCotacao_Modelo_BlocoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Modelo_Bloco
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Modelo_BlocoDel
                                DELETE Cotacao_Modelo_Bloco
                                FROM [Cotacao_Modelo_Bloco] Cotacao_Modelo_Bloco INNER JOIN #TempCotacao_Modelo_BlocoDel TempCotacao_Modelo_BlocoDel ON [Cotacao_Modelo_Bloco].ID = TempCotacao_Modelo_BlocoDel.Id
                                WHERE [Cotacao_Modelo_Bloco].ID >= @MinId AND [Cotacao_Modelo_Bloco].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Modelo_Bloco
                                FROM #TempCotacao_Modelo_Bloco TempCotacao_Modelo_Bloco INNER JOIN #TempCotacao_Modelo_BlocoDel TempCotacao_Modelo_BlocoDel ON TempCotacao_Modelo_Bloco.ID = TempCotacao_Modelo_BlocoDel.Id
                            END
                            DROP TABLE #TempCotacao_Modelo_Bloco
                            DROP TABLE #TempCotacao_Modelo_BlocoDel
                            GO
PRINT 'Running accountId 1 and table [Document_Page]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempDocument_Page

                            CREATE TABLE #TempDocument_Page
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempDocument_Page (Id)
                            SELECT  [DP].Id
                            FROM [Document_Page] DP INNER JOIN [Cotacao_Modelo] M ON DP.[DocumentTemplateId] = M.[Id]
                            WHERE [M].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempDocument_PageDel
                            CREATE TABLE #TempDocument_PageDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempDocument_Page))
                            BEGIN
                                TRUNCATE TABLE #TempDocument_PageDel

                                INSERT #TempDocument_PageDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempDocument_Page
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempDocument_PageDel
                                DELETE DP
                                FROM [Document_Page] DP INNER JOIN #TempDocument_PageDel TempDocument_PageDel ON [DP].ID = TempDocument_PageDel.Id
                                WHERE [DP].ID >= @MinId AND [DP].ID <= @MaxId
                                        
                                DELETE #TempDocument_Page
                                FROM #TempDocument_Page TempDocument_Page INNER JOIN #TempDocument_PageDel TempDocument_PageDel ON TempDocument_Page.ID = TempDocument_PageDel.Id
                            END
                            DROP TABLE #TempDocument_Page
                            DROP TABLE #TempDocument_PageDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Modelo_Permissao_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Modelo_Permissao_Usuario

                            CREATE TABLE #TempCotacao_Modelo_Permissao_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Modelo_Permissao_Usuario (Id)
                            SELECT  [CMPU].Id
                            FROM [Cotacao_Modelo_Permissao_Usuario] CMPU INNER JOIN [Cotacao_Modelo] M ON CMPU.[ID_Modelo] = M.[ID]
                            WHERE [M].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Modelo_Permissao_UsuarioDel
                            CREATE TABLE #TempCotacao_Modelo_Permissao_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Modelo_Permissao_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Modelo_Permissao_UsuarioDel

                                INSERT #TempCotacao_Modelo_Permissao_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Modelo_Permissao_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Modelo_Permissao_UsuarioDel
                                DELETE CMPU
                                FROM [Cotacao_Modelo_Permissao_Usuario] CMPU INNER JOIN #TempCotacao_Modelo_Permissao_UsuarioDel TempCotacao_Modelo_Permissao_UsuarioDel ON [CMPU].ID = TempCotacao_Modelo_Permissao_UsuarioDel.Id
                                WHERE [CMPU].ID >= @MinId AND [CMPU].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Modelo_Permissao_Usuario
                                FROM #TempCotacao_Modelo_Permissao_Usuario TempCotacao_Modelo_Permissao_Usuario INNER JOIN #TempCotacao_Modelo_Permissao_UsuarioDel TempCotacao_Modelo_Permissao_UsuarioDel ON TempCotacao_Modelo_Permissao_Usuario.ID = TempCotacao_Modelo_Permissao_UsuarioDel.Id
                            END
                            DROP TABLE #TempCotacao_Modelo_Permissao_Usuario
                            DROP TABLE #TempCotacao_Modelo_Permissao_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Modelo_Permissao_Equipe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Modelo_Permissao_Equipe

                            CREATE TABLE #TempCotacao_Modelo_Permissao_Equipe
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Modelo_Permissao_Equipe (Id)
                            SELECT  [CMPE].Id
                            FROM [Cotacao_Modelo_Permissao_Equipe] CMPE INNER JOIN [Cotacao_Modelo] M ON CMPE.[ID_Modelo] = M.[ID]
                            WHERE [M].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Modelo_Permissao_EquipeDel
                            CREATE TABLE #TempCotacao_Modelo_Permissao_EquipeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Modelo_Permissao_Equipe))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Modelo_Permissao_EquipeDel

                                INSERT #TempCotacao_Modelo_Permissao_EquipeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Modelo_Permissao_Equipe
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Modelo_Permissao_EquipeDel
                                DELETE CMPE
                                FROM [Cotacao_Modelo_Permissao_Equipe] CMPE INNER JOIN #TempCotacao_Modelo_Permissao_EquipeDel TempCotacao_Modelo_Permissao_EquipeDel ON [CMPE].ID = TempCotacao_Modelo_Permissao_EquipeDel.Id
                                WHERE [CMPE].ID >= @MinId AND [CMPE].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Modelo_Permissao_Equipe
                                FROM #TempCotacao_Modelo_Permissao_Equipe TempCotacao_Modelo_Permissao_Equipe INNER JOIN #TempCotacao_Modelo_Permissao_EquipeDel TempCotacao_Modelo_Permissao_EquipeDel ON TempCotacao_Modelo_Permissao_Equipe.ID = TempCotacao_Modelo_Permissao_EquipeDel.Id
                            END
                            DROP TABLE #TempCotacao_Modelo_Permissao_Equipe
                            DROP TABLE #TempCotacao_Modelo_Permissao_EquipeDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Modelo_FileNameVariable]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Modelo_FileNameVariable

                            CREATE TABLE #TempCotacao_Modelo_FileNameVariable
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Modelo_FileNameVariable (Id)
                            SELECT  [CMF].Id
                            FROM [Cotacao_Modelo_FileNameVariable] CMF INNER JOIN [Cotacao_Modelo] M ON CMF.[TemplateId] = M.[ID]
                            WHERE [M].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Modelo_FileNameVariableDel
                            CREATE TABLE #TempCotacao_Modelo_FileNameVariableDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Modelo_FileNameVariable))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Modelo_FileNameVariableDel

                                INSERT #TempCotacao_Modelo_FileNameVariableDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Modelo_FileNameVariable
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Modelo_FileNameVariableDel
                                DELETE CMF
                                FROM [Cotacao_Modelo_FileNameVariable] CMF INNER JOIN #TempCotacao_Modelo_FileNameVariableDel TempCotacao_Modelo_FileNameVariableDel ON [CMF].ID = TempCotacao_Modelo_FileNameVariableDel.Id
                                WHERE [CMF].ID >= @MinId AND [CMF].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Modelo_FileNameVariable
                                FROM #TempCotacao_Modelo_FileNameVariable TempCotacao_Modelo_FileNameVariable INNER JOIN #TempCotacao_Modelo_FileNameVariableDel TempCotacao_Modelo_FileNameVariableDel ON TempCotacao_Modelo_FileNameVariable.ID = TempCotacao_Modelo_FileNameVariableDel.Id
                            END
                            DROP TABLE #TempCotacao_Modelo_FileNameVariable
                            DROP TABLE #TempCotacao_Modelo_FileNameVariableDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Modelo_Query]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Modelo_Query

                            CREATE TABLE #TempCotacao_Modelo_Query
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Modelo_Query (Id)
                            SELECT  [CMQ].Id
                            FROM [Cotacao_Modelo_Query] CMQ INNER JOIN [Cotacao_Modelo] M ON CMQ.[TemplateId] = M.[ID]
                            WHERE [M].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Modelo_QueryDel
                            CREATE TABLE #TempCotacao_Modelo_QueryDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Modelo_Query))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Modelo_QueryDel

                                INSERT #TempCotacao_Modelo_QueryDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Modelo_Query
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Modelo_QueryDel
                                DELETE CMQ
                                FROM [Cotacao_Modelo_Query] CMQ INNER JOIN #TempCotacao_Modelo_QueryDel TempCotacao_Modelo_QueryDel ON [CMQ].ID = TempCotacao_Modelo_QueryDel.Id
                                WHERE [CMQ].ID >= @MinId AND [CMQ].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Modelo_Query
                                FROM #TempCotacao_Modelo_Query TempCotacao_Modelo_Query INNER JOIN #TempCotacao_Modelo_QueryDel TempCotacao_Modelo_QueryDel ON TempCotacao_Modelo_Query.ID = TempCotacao_Modelo_QueryDel.Id
                            END
                            DROP TABLE #TempCotacao_Modelo_Query
                            DROP TABLE #TempCotacao_Modelo_QueryDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Modelo_Campo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Modelo_Campo

                            CREATE TABLE #TempCotacao_Modelo_Campo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Modelo_Campo (Id)
                            SELECT  [CMC].Id
                            FROM [Cotacao_Modelo_Campo] CMC INNER JOIN [Cotacao_Modelo] M ON CMC.[ID_Modelo] = M.[ID]
                            WHERE [M].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_Modelo_CampoDel
                            CREATE TABLE #TempCotacao_Modelo_CampoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Modelo_Campo))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_Modelo_CampoDel

                                INSERT #TempCotacao_Modelo_CampoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Modelo_Campo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_Modelo_CampoDel
                                DELETE CMC
                                FROM [Cotacao_Modelo_Campo] CMC INNER JOIN #TempCotacao_Modelo_CampoDel TempCotacao_Modelo_CampoDel ON [CMC].ID = TempCotacao_Modelo_CampoDel.Id
                                WHERE [CMC].ID >= @MinId AND [CMC].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Modelo_Campo
                                FROM #TempCotacao_Modelo_Campo TempCotacao_Modelo_Campo INNER JOIN #TempCotacao_Modelo_CampoDel TempCotacao_Modelo_CampoDel ON TempCotacao_Modelo_Campo.ID = TempCotacao_Modelo_CampoDel.Id
                            END
                            DROP TABLE #TempCotacao_Modelo_Campo
                            DROP TABLE #TempCotacao_Modelo_CampoDel
                            GO
PRINT 'Running accountId 1 and table [Cotacao_Modelo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCotacao_Modelo

                            CREATE TABLE #TempCotacao_Modelo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCotacao_Modelo (Id)
                            SELECT  [Cotacao_Modelo].Id
                            FROM [Cotacao_Modelo] Cotacao_Modelo
                            WHERE [Cotacao_Modelo].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCotacao_ModeloDel
                            CREATE TABLE #TempCotacao_ModeloDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCotacao_Modelo))
                            BEGIN
                                TRUNCATE TABLE #TempCotacao_ModeloDel

                                INSERT #TempCotacao_ModeloDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCotacao_Modelo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCotacao_ModeloDel
                                DELETE Cotacao_Modelo
                                FROM [Cotacao_Modelo] Cotacao_Modelo INNER JOIN #TempCotacao_ModeloDel TempCotacao_ModeloDel ON [Cotacao_Modelo].ID = TempCotacao_ModeloDel.Id
                                WHERE [Cotacao_Modelo].ID >= @MinId AND [Cotacao_Modelo].ID <= @MaxId
                                        
                                DELETE #TempCotacao_Modelo
                                FROM #TempCotacao_Modelo TempCotacao_Modelo INNER JOIN #TempCotacao_ModeloDel TempCotacao_ModeloDel ON TempCotacao_Modelo.ID = TempCotacao_ModeloDel.Id
                            END
                            DROP TABLE #TempCotacao_Modelo
                            DROP TABLE #TempCotacao_ModeloDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Telefone]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Telefone

                            CREATE TABLE #TempCliente_Telefone
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Telefone (Id)
                            SELECT  [Cliente_Telefone].Id
                            FROM [Cliente_Telefone] Cliente_Telefone
                            WHERE [Cliente_Telefone].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_TelefoneDel
                            CREATE TABLE #TempCliente_TelefoneDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Telefone))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_TelefoneDel

                                INSERT #TempCliente_TelefoneDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Telefone
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_TelefoneDel
                                DELETE Cliente_Telefone
                                FROM [Cliente_Telefone] Cliente_Telefone INNER JOIN #TempCliente_TelefoneDel TempCliente_TelefoneDel ON [Cliente_Telefone].ID = TempCliente_TelefoneDel.Id
                                WHERE [Cliente_Telefone].ID >= @MinId AND [Cliente_Telefone].ID <= @MaxId
                                        
                                DELETE #TempCliente_Telefone
                                FROM #TempCliente_Telefone TempCliente_Telefone INNER JOIN #TempCliente_TelefoneDel TempCliente_TelefoneDel ON TempCliente_Telefone.ID = TempCliente_TelefoneDel.Id
                            END
                            DROP TABLE #TempCliente_Telefone
                            DROP TABLE #TempCliente_TelefoneDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Status]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Status

                            CREATE TABLE #TempCliente_Status
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Status (Id)
                            SELECT  [Cliente_Status].Id
                            FROM [Cliente_Status] Cliente_Status
                            WHERE [Cliente_Status].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_StatusDel
                            CREATE TABLE #TempCliente_StatusDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Status))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_StatusDel

                                INSERT #TempCliente_StatusDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Status
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_StatusDel
                                DELETE Cliente_Status
                                FROM [Cliente_Status] Cliente_Status INNER JOIN #TempCliente_StatusDel TempCliente_StatusDel ON [Cliente_Status].ID = TempCliente_StatusDel.Id
                                WHERE [Cliente_Status].ID >= @MinId AND [Cliente_Status].ID <= @MaxId
                                        
                                DELETE #TempCliente_Status
                                FROM #TempCliente_Status TempCliente_Status INNER JOIN #TempCliente_StatusDel TempCliente_StatusDel ON TempCliente_Status.ID = TempCliente_StatusDel.Id
                            END
                            DROP TABLE #TempCliente_Status
                            DROP TABLE #TempCliente_StatusDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Segmento]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Segmento

                            CREATE TABLE #TempCliente_Segmento
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Segmento (Id)
                            SELECT  [Cliente_Segmento].Id
                            FROM [Cliente_Segmento] Cliente_Segmento
                            WHERE [Cliente_Segmento].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_SegmentoDel
                            CREATE TABLE #TempCliente_SegmentoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Segmento))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_SegmentoDel

                                INSERT #TempCliente_SegmentoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Segmento
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_SegmentoDel
                                DELETE Cliente_Segmento
                                FROM [Cliente_Segmento] Cliente_Segmento INNER JOIN #TempCliente_SegmentoDel TempCliente_SegmentoDel ON [Cliente_Segmento].ID = TempCliente_SegmentoDel.Id
                                WHERE [Cliente_Segmento].ID >= @MinId AND [Cliente_Segmento].ID <= @MaxId
                                        
                                DELETE #TempCliente_Segmento
                                FROM #TempCliente_Segmento TempCliente_Segmento INNER JOIN #TempCliente_SegmentoDel TempCliente_SegmentoDel ON TempCliente_Segmento.ID = TempCliente_SegmentoDel.Id
                            END
                            DROP TABLE #TempCliente_Segmento
                            DROP TABLE #TempCliente_SegmentoDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Relacao]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Relacao

                            CREATE TABLE #TempCliente_Relacao
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Relacao (Id)
                            SELECT  [Cliente_Relacao].Id
                            FROM [Cliente_Relacao] Cliente_Relacao
                            WHERE [Cliente_Relacao].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_RelacaoDel
                            CREATE TABLE #TempCliente_RelacaoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Relacao))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_RelacaoDel

                                INSERT #TempCliente_RelacaoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Relacao
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_RelacaoDel
                                DELETE Cliente_Relacao
                                FROM [Cliente_Relacao] Cliente_Relacao INNER JOIN #TempCliente_RelacaoDel TempCliente_RelacaoDel ON [Cliente_Relacao].ID = TempCliente_RelacaoDel.Id
                                WHERE [Cliente_Relacao].ID >= @MinId AND [Cliente_Relacao].ID <= @MaxId
                                        
                                DELETE #TempCliente_Relacao
                                FROM #TempCliente_Relacao TempCliente_Relacao INNER JOIN #TempCliente_RelacaoDel TempCliente_RelacaoDel ON TempCliente_Relacao.ID = TempCliente_RelacaoDel.Id
                            END
                            DROP TABLE #TempCliente_Relacao
                            DROP TABLE #TempCliente_RelacaoDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_QtdFuncionarios]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_QtdFuncionarios

                            CREATE TABLE #TempCliente_QtdFuncionarios
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_QtdFuncionarios (Id)
                            SELECT  [Cliente_QtdFuncionarios].Id
                            FROM [Cliente_QtdFuncionarios] Cliente_QtdFuncionarios
                            WHERE [Cliente_QtdFuncionarios].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_QtdFuncionariosDel
                            CREATE TABLE #TempCliente_QtdFuncionariosDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_QtdFuncionarios))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_QtdFuncionariosDel

                                INSERT #TempCliente_QtdFuncionariosDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_QtdFuncionarios
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_QtdFuncionariosDel
                                DELETE Cliente_QtdFuncionarios
                                FROM [Cliente_QtdFuncionarios] Cliente_QtdFuncionarios INNER JOIN #TempCliente_QtdFuncionariosDel TempCliente_QtdFuncionariosDel ON [Cliente_QtdFuncionarios].ID = TempCliente_QtdFuncionariosDel.Id
                                WHERE [Cliente_QtdFuncionarios].ID >= @MinId AND [Cliente_QtdFuncionarios].ID <= @MaxId
                                        
                                DELETE #TempCliente_QtdFuncionarios
                                FROM #TempCliente_QtdFuncionarios TempCliente_QtdFuncionarios INNER JOIN #TempCliente_QtdFuncionariosDel TempCliente_QtdFuncionariosDel ON TempCliente_QtdFuncionarios.ID = TempCliente_QtdFuncionariosDel.Id
                            END
                            DROP TABLE #TempCliente_QtdFuncionarios
                            DROP TABLE #TempCliente_QtdFuncionariosDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Produto]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Produto

                            CREATE TABLE #TempCliente_Produto
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Produto (Id)
                            SELECT  [Cliente_Produto].Id
                            FROM [Cliente_Produto] Cliente_Produto
                            WHERE [Cliente_Produto].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_ProdutoDel
                            CREATE TABLE #TempCliente_ProdutoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Produto))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_ProdutoDel

                                INSERT #TempCliente_ProdutoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Produto
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_ProdutoDel
                                DELETE Cliente_Produto
                                FROM [Cliente_Produto] Cliente_Produto INNER JOIN #TempCliente_ProdutoDel TempCliente_ProdutoDel ON [Cliente_Produto].ID = TempCliente_ProdutoDel.Id
                                WHERE [Cliente_Produto].ID >= @MinId AND [Cliente_Produto].ID <= @MaxId
                                        
                                DELETE #TempCliente_Produto
                                FROM #TempCliente_Produto TempCliente_Produto INNER JOIN #TempCliente_ProdutoDel TempCliente_ProdutoDel ON TempCliente_Produto.ID = TempCliente_ProdutoDel.Id
                            END
                            DROP TABLE #TempCliente_Produto
                            DROP TABLE #TempCliente_ProdutoDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Origem]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Origem

                            CREATE TABLE #TempCliente_Origem
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Origem (Id)
                            SELECT  [Cliente_Origem].Id
                            FROM [Cliente_Origem] Cliente_Origem
                            WHERE [Cliente_Origem].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_OrigemDel
                            CREATE TABLE #TempCliente_OrigemDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Origem))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_OrigemDel

                                INSERT #TempCliente_OrigemDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Origem
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_OrigemDel
                                DELETE Cliente_Origem
                                FROM [Cliente_Origem] Cliente_Origem INNER JOIN #TempCliente_OrigemDel TempCliente_OrigemDel ON [Cliente_Origem].ID = TempCliente_OrigemDel.Id
                                WHERE [Cliente_Origem].ID >= @MinId AND [Cliente_Origem].ID <= @MaxId
                                        
                                DELETE #TempCliente_Origem
                                FROM #TempCliente_Origem TempCliente_Origem INNER JOIN #TempCliente_OrigemDel TempCliente_OrigemDel ON TempCliente_Origem.ID = TempCliente_OrigemDel.Id
                            END
                            DROP TABLE #TempCliente_Origem
                            DROP TABLE #TempCliente_OrigemDel
                            GO
PRINT 'Running accountId 1 and table [Oportunidade_Cliente]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempOportunidade_Cliente

                            CREATE TABLE #TempOportunidade_Cliente
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempOportunidade_Cliente (Id)
                            SELECT  [OP].Id
                            FROM [Oportunidade_Cliente] OP INNER JOIN [Cliente] C ON OP.[ID_Cliente] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempOportunidade_ClienteDel
                            CREATE TABLE #TempOportunidade_ClienteDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempOportunidade_Cliente))
                            BEGIN
                                TRUNCATE TABLE #TempOportunidade_ClienteDel

                                INSERT #TempOportunidade_ClienteDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempOportunidade_Cliente
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempOportunidade_ClienteDel
                                DELETE OP
                                FROM [Oportunidade_Cliente] OP INNER JOIN #TempOportunidade_ClienteDel TempOportunidade_ClienteDel ON [OP].ID = TempOportunidade_ClienteDel.Id
                                WHERE [OP].ID >= @MinId AND [OP].ID <= @MaxId
                                        
                                DELETE #TempOportunidade_Cliente
                                FROM #TempOportunidade_Cliente TempOportunidade_Cliente INNER JOIN #TempOportunidade_ClienteDel TempOportunidade_ClienteDel ON TempOportunidade_Cliente.ID = TempOportunidade_ClienteDel.Id
                            END
                            DROP TABLE #TempOportunidade_Cliente
                            DROP TABLE #TempOportunidade_ClienteDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_ParentContact]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_ParentContact

                            CREATE TABLE #TempCliente_ParentContact
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_ParentContact (Id)
                            SELECT  [CP].Id
                            FROM [Cliente_ParentContact] CP INNER JOIN [Cliente] C ON C.[ID] = CP.[ContactId]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_ParentContactDel
                            CREATE TABLE #TempCliente_ParentContactDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_ParentContact))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_ParentContactDel

                                INSERT #TempCliente_ParentContactDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_ParentContact
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_ParentContactDel
                                DELETE CP
                                FROM [Cliente_ParentContact] CP INNER JOIN #TempCliente_ParentContactDel TempCliente_ParentContactDel ON [CP].ID = TempCliente_ParentContactDel.Id
                                WHERE [CP].ID >= @MinId AND [CP].ID <= @MaxId
                                        
                                DELETE #TempCliente_ParentContact
                                FROM #TempCliente_ParentContact TempCliente_ParentContact INNER JOIN #TempCliente_ParentContactDel TempCliente_ParentContactDel ON TempCliente_ParentContact.ID = TempCliente_ParentContactDel.Id
                            END
                            DROP TABLE #TempCliente_ParentContact
                            DROP TABLE #TempCliente_ParentContactDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Status_Historico]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Status_Historico

                            CREATE TABLE #TempCliente_Status_Historico
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Status_Historico (Id)
                            SELECT  [CSH].Id
                            FROM [Cliente_Status_Historico] CSH INNER JOIN [Cliente] C ON CSH.[ID_Cliente] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_Status_HistoricoDel
                            CREATE TABLE #TempCliente_Status_HistoricoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Status_Historico))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_Status_HistoricoDel

                                INSERT #TempCliente_Status_HistoricoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Status_Historico
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_Status_HistoricoDel
                                DELETE CSH
                                FROM [Cliente_Status_Historico] CSH INNER JOIN #TempCliente_Status_HistoricoDel TempCliente_Status_HistoricoDel ON [CSH].ID = TempCliente_Status_HistoricoDel.Id
                                WHERE [CSH].ID >= @MinId AND [CSH].ID <= @MaxId
                                        
                                DELETE #TempCliente_Status_Historico
                                FROM #TempCliente_Status_Historico TempCliente_Status_Historico INNER JOIN #TempCliente_Status_HistoricoDel TempCliente_Status_HistoricoDel ON TempCliente_Status_Historico.ID = TempCliente_Status_HistoricoDel.Id
                            END
                            DROP TABLE #TempCliente_Status_Historico
                            DROP TABLE #TempCliente_Status_HistoricoDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Endereco]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Endereco

                            CREATE TABLE #TempCliente_Endereco
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Endereco (Id)
                            SELECT  [CE].Id
                            FROM [Cliente_Endereco] CE INNER JOIN  [Cliente] C ON CE.[ID_Cliente] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_EnderecoDel
                            CREATE TABLE #TempCliente_EnderecoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Endereco))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_EnderecoDel

                                INSERT #TempCliente_EnderecoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Endereco
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_EnderecoDel
                                DELETE CE
                                FROM [Cliente_Endereco] CE INNER JOIN #TempCliente_EnderecoDel TempCliente_EnderecoDel ON [CE].ID = TempCliente_EnderecoDel.Id
                                WHERE [CE].ID >= @MinId AND [CE].ID <= @MaxId
                                        
                                DELETE #TempCliente_Endereco
                                FROM #TempCliente_Endereco TempCliente_Endereco INNER JOIN #TempCliente_EnderecoDel TempCliente_EnderecoDel ON TempCliente_Endereco.ID = TempCliente_EnderecoDel.Id
                            END
                            DROP TABLE #TempCliente_Endereco
                            DROP TABLE #TempCliente_EnderecoDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Empresa]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Empresa

                            CREATE TABLE #TempCliente_Empresa
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Empresa (Id)
                            SELECT  [CE].Id
                            FROM [Cliente_Empresa] CE INNER JOIN  [Cliente] C ON CE.[ID_Cliente] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_EmpresaDel
                            CREATE TABLE #TempCliente_EmpresaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Empresa))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_EmpresaDel

                                INSERT #TempCliente_EmpresaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Empresa
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_EmpresaDel
                                DELETE CE
                                FROM [Cliente_Empresa] CE INNER JOIN #TempCliente_EmpresaDel TempCliente_EmpresaDel ON [CE].ID = TempCliente_EmpresaDel.Id
                                WHERE [CE].ID >= @MinId AND [CE].ID <= @MaxId
                                        
                                DELETE #TempCliente_Empresa
                                FROM #TempCliente_Empresa TempCliente_Empresa INNER JOIN #TempCliente_EmpresaDel TempCliente_EmpresaDel ON TempCliente_Empresa.ID = TempCliente_EmpresaDel.Id
                            END
                            DROP TABLE #TempCliente_Empresa
                            DROP TABLE #TempCliente_EmpresaDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Contato]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Contato

                            CREATE TABLE #TempCliente_Contato
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Contato (Id)
                            SELECT  [CC].Id
                            FROM [Cliente_Contato] CC INNER JOIN  [Cliente] C ON CC.[ID_Cliente] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_ContatoDel
                            CREATE TABLE #TempCliente_ContatoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Contato))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_ContatoDel

                                INSERT #TempCliente_ContatoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Contato
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_ContatoDel
                                DELETE CC
                                FROM [Cliente_Contato] CC INNER JOIN #TempCliente_ContatoDel TempCliente_ContatoDel ON [CC].ID = TempCliente_ContatoDel.Id
                                WHERE [CC].ID >= @MinId AND [CC].ID <= @MaxId
                                        
                                DELETE #TempCliente_Contato
                                FROM #TempCliente_Contato TempCliente_Contato INNER JOIN #TempCliente_ContatoDel TempCliente_ContatoDel ON TempCliente_Contato.ID = TempCliente_ContatoDel.Id
                            END
                            DROP TABLE #TempCliente_Contato
                            DROP TABLE #TempCliente_ContatoDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Company]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Company

                            CREATE TABLE #TempCliente_Company
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Company (Id)
                            SELECT  [CC].Id
                            FROM [Cliente_Company] CC INNER JOIN  [Cliente] C ON CC.[CompanyId] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_CompanyDel
                            CREATE TABLE #TempCliente_CompanyDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Company))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_CompanyDel

                                INSERT #TempCliente_CompanyDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Company
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_CompanyDel
                                DELETE CC
                                FROM [Cliente_Company] CC INNER JOIN #TempCliente_CompanyDel TempCliente_CompanyDel ON [CC].ID = TempCliente_CompanyDel.Id
                                WHERE [CC].ID >= @MinId AND [CC].ID <= @MaxId
                                        
                                DELETE #TempCliente_Company
                                FROM #TempCliente_Company TempCliente_Company INNER JOIN #TempCliente_CompanyDel TempCliente_CompanyDel ON TempCliente_Company.ID = TempCliente_CompanyDel.Id
                            END
                            DROP TABLE #TempCliente_Company
                            DROP TABLE #TempCliente_CompanyDel
                            GO
PRINT 'Running accountId 1 and table [Cliente_Colaborador_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente_Colaborador_Usuario

                            CREATE TABLE #TempCliente_Colaborador_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente_Colaborador_Usuario (Id)
                            SELECT  [CCU].Id
                            FROM [Cliente_Colaborador_Usuario] CCU INNER JOIN [Cliente] C ON CCU.[ID_Cliente] = C.ID
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCliente_Colaborador_UsuarioDel
                            CREATE TABLE #TempCliente_Colaborador_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente_Colaborador_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempCliente_Colaborador_UsuarioDel

                                INSERT #TempCliente_Colaborador_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente_Colaborador_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCliente_Colaborador_UsuarioDel
                                DELETE CCU
                                FROM [Cliente_Colaborador_Usuario] CCU INNER JOIN #TempCliente_Colaborador_UsuarioDel TempCliente_Colaborador_UsuarioDel ON [CCU].ID = TempCliente_Colaborador_UsuarioDel.Id
                                WHERE [CCU].ID >= @MinId AND [CCU].ID <= @MaxId
                                        
                                DELETE #TempCliente_Colaborador_Usuario
                                FROM #TempCliente_Colaborador_Usuario TempCliente_Colaborador_Usuario INNER JOIN #TempCliente_Colaborador_UsuarioDel TempCliente_Colaborador_UsuarioDel ON TempCliente_Colaborador_Usuario.ID = TempCliente_Colaborador_UsuarioDel.Id
                            END
                            DROP TABLE #TempCliente_Colaborador_Usuario
                            DROP TABLE #TempCliente_Colaborador_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Cliente]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCliente

                            CREATE TABLE #TempCliente
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCliente (Id)
                            SELECT  [Cliente].Id
                            FROM [Cliente] Cliente
                            WHERE [Cliente].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempClienteDel
                            CREATE TABLE #TempClienteDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCliente))
                            BEGIN
                                TRUNCATE TABLE #TempClienteDel

                                INSERT #TempClienteDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCliente
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempClienteDel
                                DELETE Cliente
                                FROM [Cliente] Cliente INNER JOIN #TempClienteDel TempClienteDel ON [Cliente].ID = TempClienteDel.Id
                                WHERE [Cliente].ID >= @MinId AND [Cliente].ID <= @MaxId
                                        
                                DELETE #TempCliente
                                FROM #TempCliente TempCliente INNER JOIN #TempClienteDel TempClienteDel ON TempCliente.ID = TempClienteDel.Id
                            END
                            DROP TABLE #TempCliente
                            DROP TABLE #TempClienteDel
                            GO
PRINT 'Running accountId 1 and table [Cidade]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCidade

                            CREATE TABLE #TempCidade
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCidade (Id)
                            SELECT  [Cidade].Id
                            FROM [Cidade] Cidade
                            WHERE [Cidade].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCidadeDel
                            CREATE TABLE #TempCidadeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCidade))
                            BEGIN
                                TRUNCATE TABLE #TempCidadeDel

                                INSERT #TempCidadeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCidade
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCidadeDel
                                DELETE Cidade
                                FROM [Cidade] Cidade INNER JOIN #TempCidadeDel TempCidadeDel ON [Cidade].ID = TempCidadeDel.Id
                                WHERE [Cidade].ID >= @MinId AND [Cidade].ID <= @MaxId
                                        
                                DELETE #TempCidade
                                FROM #TempCidade TempCidade INNER JOIN #TempCidadeDel TempCidadeDel ON TempCidade.ID = TempCidadeDel.Id
                            END
                            DROP TABLE #TempCidade
                            DROP TABLE #TempCidadeDel
                            GO
PRINT 'Running accountId 1 and table [Checklist_Field_User]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempChecklist_Field_User

                            CREATE TABLE #TempChecklist_Field_User
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempChecklist_Field_User (Id)
                            SELECT  [CFU].Id
                            FROM [Checklist_Field_User] CFU INNER JOIN [Checklist_Field] CF ON CFU.[ChecklistFieldId] = CF.[Id] INNER JOIN [Checklist] C ON CF.[ChecklistId] = C.[Id]
                            WHERE [C].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempChecklist_Field_UserDel
                            CREATE TABLE #TempChecklist_Field_UserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempChecklist_Field_User))
                            BEGIN
                                TRUNCATE TABLE #TempChecklist_Field_UserDel

                                INSERT #TempChecklist_Field_UserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempChecklist_Field_User
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempChecklist_Field_UserDel
                                DELETE CFU
                                FROM [Checklist_Field_User] CFU INNER JOIN #TempChecklist_Field_UserDel TempChecklist_Field_UserDel ON [CFU].ID = TempChecklist_Field_UserDel.Id
                                WHERE [CFU].ID >= @MinId AND [CFU].ID <= @MaxId
                                        
                                DELETE #TempChecklist_Field_User
                                FROM #TempChecklist_Field_User TempChecklist_Field_User INNER JOIN #TempChecklist_Field_UserDel TempChecklist_Field_UserDel ON TempChecklist_Field_User.ID = TempChecklist_Field_UserDel.Id
                            END
                            DROP TABLE #TempChecklist_Field_User
                            DROP TABLE #TempChecklist_Field_UserDel
                            GO
PRINT 'Running accountId 1 and table [Checklist_Field_Condition]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempChecklist_Field_Condition

                            CREATE TABLE #TempChecklist_Field_Condition
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempChecklist_Field_Condition (Id)
                            SELECT  [CFC].Id
                            FROM [Checklist_Field_Condition] CFC INNER JOIN [Checklist_Field] CF ON CFC.[ChecklistFieldId] = CF.[Id] INNER JOIN [Checklist] C ON CF.[ChecklistId] = C.[Id]
                            WHERE [C].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempChecklist_Field_ConditionDel
                            CREATE TABLE #TempChecklist_Field_ConditionDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempChecklist_Field_Condition))
                            BEGIN
                                TRUNCATE TABLE #TempChecklist_Field_ConditionDel

                                INSERT #TempChecklist_Field_ConditionDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempChecklist_Field_Condition
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempChecklist_Field_ConditionDel
                                DELETE CFC
                                FROM [Checklist_Field_Condition] CFC INNER JOIN #TempChecklist_Field_ConditionDel TempChecklist_Field_ConditionDel ON [CFC].ID = TempChecklist_Field_ConditionDel.Id
                                WHERE [CFC].ID >= @MinId AND [CFC].ID <= @MaxId
                                        
                                DELETE #TempChecklist_Field_Condition
                                FROM #TempChecklist_Field_Condition TempChecklist_Field_Condition INNER JOIN #TempChecklist_Field_ConditionDel TempChecklist_Field_ConditionDel ON TempChecklist_Field_Condition.ID = TempChecklist_Field_ConditionDel.Id
                            END
                            DROP TABLE #TempChecklist_Field_Condition
                            DROP TABLE #TempChecklist_Field_ConditionDel
                            GO
PRINT 'Running accountId 1 and table [Checklist_Field]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempChecklist_Field

                            CREATE TABLE #TempChecklist_Field
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempChecklist_Field (Id)
                            SELECT  [CF].Id
                            FROM [Checklist_Field] CF INNER JOIN [Checklist] C ON CF.[ChecklistId] = C.[Id]
                            WHERE [C].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempChecklist_FieldDel
                            CREATE TABLE #TempChecklist_FieldDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempChecklist_Field))
                            BEGIN
                                TRUNCATE TABLE #TempChecklist_FieldDel

                                INSERT #TempChecklist_FieldDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempChecklist_Field
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempChecklist_FieldDel
                                DELETE CF
                                FROM [Checklist_Field] CF INNER JOIN #TempChecklist_FieldDel TempChecklist_FieldDel ON [CF].ID = TempChecklist_FieldDel.Id
                                WHERE [CF].ID >= @MinId AND [CF].ID <= @MaxId
                                        
                                DELETE #TempChecklist_Field
                                FROM #TempChecklist_Field TempChecklist_Field INNER JOIN #TempChecklist_FieldDel TempChecklist_FieldDel ON TempChecklist_Field.ID = TempChecklist_FieldDel.Id
                            END
                            DROP TABLE #TempChecklist_Field
                            DROP TABLE #TempChecklist_FieldDel
                            GO
PRINT 'Running accountId 1 and table [Checklist]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempChecklist

                            CREATE TABLE #TempChecklist
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempChecklist (Id)
                            SELECT  [Checklist].Id
                            FROM [Checklist] Checklist
                            WHERE [Checklist].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempChecklistDel
                            CREATE TABLE #TempChecklistDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempChecklist))
                            BEGIN
                                TRUNCATE TABLE #TempChecklistDel

                                INSERT #TempChecklistDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempChecklist
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempChecklistDel
                                DELETE Checklist
                                FROM [Checklist] Checklist INNER JOIN #TempChecklistDel TempChecklistDel ON [Checklist].ID = TempChecklistDel.Id
                                WHERE [Checklist].ID >= @MinId AND [Checklist].ID <= @MaxId
                                        
                                DELETE #TempChecklist
                                FROM #TempChecklist TempChecklist INNER JOIN #TempChecklistDel TempChecklistDel ON TempChecklist.ID = TempChecklistDel.Id
                            END
                            DROP TABLE #TempChecklist
                            DROP TABLE #TempChecklistDel
                            GO
PRINT 'Running accountId 1 and table [Chat]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempChat

                            CREATE TABLE #TempChat
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempChat (Id)
                            SELECT  [Chat].Id
                            FROM [Chat] Chat
                            WHERE [Chat].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempChatDel
                            CREATE TABLE #TempChatDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempChat))
                            BEGIN
                                TRUNCATE TABLE #TempChatDel

                                INSERT #TempChatDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempChat
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempChatDel
                                DELETE Chat
                                FROM [Chat] Chat INNER JOIN #TempChatDel TempChatDel ON [Chat].ID = TempChatDel.Id
                                WHERE [Chat].ID >= @MinId AND [Chat].ID <= @MaxId
                                        
                                DELETE #TempChat
                                FROM #TempChat TempChat INNER JOIN #TempChatDel TempChatDel ON TempChat.ID = TempChatDel.Id
                            END
                            DROP TABLE #TempChat
                            DROP TABLE #TempChatDel
                            GO
PRINT 'Running accountId 1 and table [Cargo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCargo

                            CREATE TABLE #TempCargo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCargo (Id)
                            SELECT  [Cargo].Id
                            FROM [Cargo] Cargo
                            WHERE [Cargo].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCargoDel
                            CREATE TABLE #TempCargoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCargo))
                            BEGIN
                                TRUNCATE TABLE #TempCargoDel

                                INSERT #TempCargoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCargo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCargoDel
                                DELETE Cargo
                                FROM [Cargo] Cargo INNER JOIN #TempCargoDel TempCargoDel ON [Cargo].ID = TempCargoDel.Id
                                WHERE [Cargo].ID >= @MinId AND [Cargo].ID <= @MaxId
                                        
                                DELETE #TempCargo
                                FROM #TempCargo TempCargo INNER JOIN #TempCargoDel TempCargoDel ON TempCargo.ID = TempCargoDel.Id
                            END
                            DROP TABLE #TempCargo
                            DROP TABLE #TempCargoDel
                            GO
PRINT 'Running accountId 1 and table [CampoFixo2_Cultura_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampoFixo2_Cultura_Account

                            CREATE TABLE #TempCampoFixo2_Cultura_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampoFixo2_Cultura_Account (Id)
                            SELECT  [CampoFixo2_Cultura_Account].Id
                            FROM [CampoFixo2_Cultura_Account] CampoFixo2_Cultura_Account
                            WHERE [CampoFixo2_Cultura_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampoFixo2_Cultura_AccountDel
                            CREATE TABLE #TempCampoFixo2_Cultura_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampoFixo2_Cultura_Account))
                            BEGIN
                                TRUNCATE TABLE #TempCampoFixo2_Cultura_AccountDel

                                INSERT #TempCampoFixo2_Cultura_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampoFixo2_Cultura_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampoFixo2_Cultura_AccountDel
                                DELETE CampoFixo2_Cultura_Account
                                FROM [CampoFixo2_Cultura_Account] CampoFixo2_Cultura_Account INNER JOIN #TempCampoFixo2_Cultura_AccountDel TempCampoFixo2_Cultura_AccountDel ON [CampoFixo2_Cultura_Account].ID = TempCampoFixo2_Cultura_AccountDel.Id
                                WHERE [CampoFixo2_Cultura_Account].ID >= @MinId AND [CampoFixo2_Cultura_Account].ID <= @MaxId
                                        
                                DELETE #TempCampoFixo2_Cultura_Account
                                FROM #TempCampoFixo2_Cultura_Account TempCampoFixo2_Cultura_Account INNER JOIN #TempCampoFixo2_Cultura_AccountDel TempCampoFixo2_Cultura_AccountDel ON TempCampoFixo2_Cultura_Account.ID = TempCampoFixo2_Cultura_AccountDel.Id
                            END
                            DROP TABLE #TempCampoFixo2_Cultura_Account
                            DROP TABLE #TempCampoFixo2_Cultura_AccountDel
                            GO
PRINT 'Running accountId 1 and table [CampoFixo2_ClientePloomes_Formula_Variavel]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampoFixo2_ClientePloomes_Formula_Variavel

                            CREATE TABLE #TempCampoFixo2_ClientePloomes_Formula_Variavel
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampoFixo2_ClientePloomes_Formula_Variavel (Id)
                            SELECT  [CCFV].Id
                            FROM [CampoFixo2_ClientePloomes_Formula_Variavel] CCFV INNER JOIN [CampoFixo2_ClientePloomes_Formula] CCF ON CCFV.[ID_Formula] = CCF.[ID]
                            WHERE [CCF].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampoFixo2_ClientePloomes_Formula_VariavelDel
                            CREATE TABLE #TempCampoFixo2_ClientePloomes_Formula_VariavelDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampoFixo2_ClientePloomes_Formula_Variavel))
                            BEGIN
                                TRUNCATE TABLE #TempCampoFixo2_ClientePloomes_Formula_VariavelDel

                                INSERT #TempCampoFixo2_ClientePloomes_Formula_VariavelDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampoFixo2_ClientePloomes_Formula_Variavel
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampoFixo2_ClientePloomes_Formula_VariavelDel
                                DELETE CCFV
                                FROM [CampoFixo2_ClientePloomes_Formula_Variavel] CCFV INNER JOIN #TempCampoFixo2_ClientePloomes_Formula_VariavelDel TempCampoFixo2_ClientePloomes_Formula_VariavelDel ON [CCFV].ID = TempCampoFixo2_ClientePloomes_Formula_VariavelDel.Id
                                WHERE [CCFV].ID >= @MinId AND [CCFV].ID <= @MaxId
                                        
                                DELETE #TempCampoFixo2_ClientePloomes_Formula_Variavel
                                FROM #TempCampoFixo2_ClientePloomes_Formula_Variavel TempCampoFixo2_ClientePloomes_Formula_Variavel INNER JOIN #TempCampoFixo2_ClientePloomes_Formula_VariavelDel TempCampoFixo2_ClientePloomes_Formula_VariavelDel ON TempCampoFixo2_ClientePloomes_Formula_Variavel.ID = TempCampoFixo2_ClientePloomes_Formula_VariavelDel.Id
                            END
                            DROP TABLE #TempCampoFixo2_ClientePloomes_Formula_Variavel
                            DROP TABLE #TempCampoFixo2_ClientePloomes_Formula_VariavelDel
                            GO
PRINT 'Running accountId 1 and table [CampoFixo2_ClientePloomes_Formula]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampoFixo2_ClientePloomes_Formula

                            CREATE TABLE #TempCampoFixo2_ClientePloomes_Formula
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampoFixo2_ClientePloomes_Formula (Id)
                            SELECT  [CampoFixo2_ClientePloomes_Formula].Id
                            FROM [CampoFixo2_ClientePloomes_Formula] CampoFixo2_ClientePloomes_Formula
                            WHERE [CampoFixo2_ClientePloomes_Formula].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampoFixo2_ClientePloomes_FormulaDel
                            CREATE TABLE #TempCampoFixo2_ClientePloomes_FormulaDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampoFixo2_ClientePloomes_Formula))
                            BEGIN
                                TRUNCATE TABLE #TempCampoFixo2_ClientePloomes_FormulaDel

                                INSERT #TempCampoFixo2_ClientePloomes_FormulaDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampoFixo2_ClientePloomes_Formula
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampoFixo2_ClientePloomes_FormulaDel
                                DELETE CampoFixo2_ClientePloomes_Formula
                                FROM [CampoFixo2_ClientePloomes_Formula] CampoFixo2_ClientePloomes_Formula INNER JOIN #TempCampoFixo2_ClientePloomes_FormulaDel TempCampoFixo2_ClientePloomes_FormulaDel ON [CampoFixo2_ClientePloomes_Formula].ID = TempCampoFixo2_ClientePloomes_FormulaDel.Id
                                WHERE [CampoFixo2_ClientePloomes_Formula].ID >= @MinId AND [CampoFixo2_ClientePloomes_Formula].ID <= @MaxId
                                        
                                DELETE #TempCampoFixo2_ClientePloomes_Formula
                                FROM #TempCampoFixo2_ClientePloomes_Formula TempCampoFixo2_ClientePloomes_Formula INNER JOIN #TempCampoFixo2_ClientePloomes_FormulaDel TempCampoFixo2_ClientePloomes_FormulaDel ON TempCampoFixo2_ClientePloomes_Formula.ID = TempCampoFixo2_ClientePloomes_FormulaDel.Id
                            END
                            DROP TABLE #TempCampoFixo2_ClientePloomes_Formula
                            DROP TABLE #TempCampoFixo2_ClientePloomes_FormulaDel
                            GO
PRINT 'Running accountId 1 and table [CampoFixo2_ClientePloomes_ResponsePath]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampoFixo2_ClientePloomes_ResponsePath

                            CREATE TABLE #TempCampoFixo2_ClientePloomes_ResponsePath
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampoFixo2_ClientePloomes_ResponsePath (Id)
                            SELECT  [CCR].Id
                            FROM [CampoFixo2_ClientePloomes_ResponsePath] CCR INNER JOIN [CampoFixo2_ClientePloomes] CC ON CCR.FieldId = CC.ID
                            WHERE [CC].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampoFixo2_ClientePloomes_ResponsePathDel
                            CREATE TABLE #TempCampoFixo2_ClientePloomes_ResponsePathDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampoFixo2_ClientePloomes_ResponsePath))
                            BEGIN
                                TRUNCATE TABLE #TempCampoFixo2_ClientePloomes_ResponsePathDel

                                INSERT #TempCampoFixo2_ClientePloomes_ResponsePathDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampoFixo2_ClientePloomes_ResponsePath
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampoFixo2_ClientePloomes_ResponsePathDel
                                DELETE CCR
                                FROM [CampoFixo2_ClientePloomes_ResponsePath] CCR INNER JOIN #TempCampoFixo2_ClientePloomes_ResponsePathDel TempCampoFixo2_ClientePloomes_ResponsePathDel ON [CCR].ID = TempCampoFixo2_ClientePloomes_ResponsePathDel.Id
                                WHERE [CCR].ID >= @MinId AND [CCR].ID <= @MaxId
                                        
                                DELETE #TempCampoFixo2_ClientePloomes_ResponsePath
                                FROM #TempCampoFixo2_ClientePloomes_ResponsePath TempCampoFixo2_ClientePloomes_ResponsePath INNER JOIN #TempCampoFixo2_ClientePloomes_ResponsePathDel TempCampoFixo2_ClientePloomes_ResponsePathDel ON TempCampoFixo2_ClientePloomes_ResponsePath.ID = TempCampoFixo2_ClientePloomes_ResponsePathDel.Id
                            END
                            DROP TABLE #TempCampoFixo2_ClientePloomes_ResponsePath
                            DROP TABLE #TempCampoFixo2_ClientePloomes_ResponsePathDel
                            GO
PRINT 'Running accountId 1 and table [CampoFixo2_ClientePloomes]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampoFixo2_ClientePloomes

                            CREATE TABLE #TempCampoFixo2_ClientePloomes
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampoFixo2_ClientePloomes (Id)
                            SELECT  [CampoFixo2_ClientePloomes].Id
                            FROM [CampoFixo2_ClientePloomes] CampoFixo2_ClientePloomes
                            WHERE [CampoFixo2_ClientePloomes].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampoFixo2_ClientePloomesDel
                            CREATE TABLE #TempCampoFixo2_ClientePloomesDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampoFixo2_ClientePloomes))
                            BEGIN
                                TRUNCATE TABLE #TempCampoFixo2_ClientePloomesDel

                                INSERT #TempCampoFixo2_ClientePloomesDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampoFixo2_ClientePloomes
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampoFixo2_ClientePloomesDel
                                DELETE CampoFixo2_ClientePloomes
                                FROM [CampoFixo2_ClientePloomes] CampoFixo2_ClientePloomes INNER JOIN #TempCampoFixo2_ClientePloomesDel TempCampoFixo2_ClientePloomesDel ON [CampoFixo2_ClientePloomes].ID = TempCampoFixo2_ClientePloomesDel.Id
                                WHERE [CampoFixo2_ClientePloomes].ID >= @MinId AND [CampoFixo2_ClientePloomes].ID <= @MaxId
                                        
                                DELETE #TempCampoFixo2_ClientePloomes
                                FROM #TempCampoFixo2_ClientePloomes TempCampoFixo2_ClientePloomes INNER JOIN #TempCampoFixo2_ClientePloomesDel TempCampoFixo2_ClientePloomesDel ON TempCampoFixo2_ClientePloomes.ID = TempCampoFixo2_ClientePloomesDel.Id
                            END
                            DROP TABLE #TempCampoFixo2_ClientePloomes
                            DROP TABLE #TempCampoFixo2_ClientePloomesDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Vinculo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Vinculo

                            CREATE TABLE #TempCampo_Vinculo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Vinculo (Id)
                            SELECT  [Campo_Vinculo].Id
                            FROM [Campo_Vinculo] Campo_Vinculo
                            WHERE [Campo_Vinculo].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_VinculoDel
                            CREATE TABLE #TempCampo_VinculoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Vinculo))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_VinculoDel

                                INSERT #TempCampo_VinculoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Vinculo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_VinculoDel
                                DELETE Campo_Vinculo
                                FROM [Campo_Vinculo] Campo_Vinculo INNER JOIN #TempCampo_VinculoDel TempCampo_VinculoDel ON [Campo_Vinculo].ID = TempCampo_VinculoDel.Id
                                WHERE [Campo_Vinculo].ID >= @MinId AND [Campo_Vinculo].ID <= @MaxId
                                        
                                DELETE #TempCampo_Vinculo
                                FROM #TempCampo_Vinculo TempCampo_Vinculo INNER JOIN #TempCampo_VinculoDel TempCampo_VinculoDel ON TempCampo_Vinculo.ID = TempCampo_VinculoDel.Id
                            END
                            DROP TABLE #TempCampo_Vinculo
                            DROP TABLE #TempCampo_VinculoDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Account

                            CREATE TABLE #TempCampo_Valor_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Account (Id)
                            SELECT  [Campo_Valor_Account].Id
                            FROM [Campo_Valor_Account] Campo_Valor_Account
                            WHERE [Campo_Valor_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_AccountDel
                            CREATE TABLE #TempCampo_Valor_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Account))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_AccountDel

                                INSERT #TempCampo_Valor_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_AccountDel
                                DELETE Campo_Valor_Account
                                FROM [Campo_Valor_Account] Campo_Valor_Account INNER JOIN #TempCampo_Valor_AccountDel TempCampo_Valor_AccountDel ON [Campo_Valor_Account].ID = TempCampo_Valor_AccountDel.Id
                                WHERE [Campo_Valor_Account].ID >= @MinId AND [Campo_Valor_Account].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Account
                                FROM #TempCampo_Valor_Account TempCampo_Valor_Account INNER JOIN #TempCampo_Valor_AccountDel TempCampo_Valor_AccountDel ON TempCampo_Valor_Account.ID = TempCampo_Valor_AccountDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Account
                            DROP TABLE #TempCampo_Valor_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Campo_TabelaEstrangeira_Valor]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_TabelaEstrangeira_Valor

                            CREATE TABLE #TempCampo_TabelaEstrangeira_Valor
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_TabelaEstrangeira_Valor (Id)
                            SELECT  [CTV].Id
                            FROM [Campo_TabelaEstrangeira_Valor] CTV INNER JOIN [Campo_TabelaEstrangeira] CT ON CTV.[ID_Tabela] = CT.[ID]
                            WHERE [CT].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_TabelaEstrangeira_ValorDel
                            CREATE TABLE #TempCampo_TabelaEstrangeira_ValorDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_TabelaEstrangeira_Valor))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_TabelaEstrangeira_ValorDel

                                INSERT #TempCampo_TabelaEstrangeira_ValorDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_TabelaEstrangeira_Valor
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_TabelaEstrangeira_ValorDel
                                DELETE CTV
                                FROM [Campo_TabelaEstrangeira_Valor] CTV INNER JOIN #TempCampo_TabelaEstrangeira_ValorDel TempCampo_TabelaEstrangeira_ValorDel ON [CTV].ID = TempCampo_TabelaEstrangeira_ValorDel.Id
                                WHERE [CTV].ID >= @MinId AND [CTV].ID <= @MaxId
                                        
                                DELETE #TempCampo_TabelaEstrangeira_Valor
                                FROM #TempCampo_TabelaEstrangeira_Valor TempCampo_TabelaEstrangeira_Valor INNER JOIN #TempCampo_TabelaEstrangeira_ValorDel TempCampo_TabelaEstrangeira_ValorDel ON TempCampo_TabelaEstrangeira_Valor.ID = TempCampo_TabelaEstrangeira_ValorDel.Id
                            END
                            DROP TABLE #TempCampo_TabelaEstrangeira_Valor
                            DROP TABLE #TempCampo_TabelaEstrangeira_ValorDel
                            GO
PRINT 'Running accountId 1 and table [Campo_TabelaEstrangeira]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_TabelaEstrangeira

                            CREATE TABLE #TempCampo_TabelaEstrangeira
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_TabelaEstrangeira (Id)
                            SELECT  [Campo_TabelaEstrangeira].Id
                            FROM [Campo_TabelaEstrangeira] Campo_TabelaEstrangeira
                            WHERE [Campo_TabelaEstrangeira].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_TabelaEstrangeiraDel
                            CREATE TABLE #TempCampo_TabelaEstrangeiraDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_TabelaEstrangeira))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_TabelaEstrangeiraDel

                                INSERT #TempCampo_TabelaEstrangeiraDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_TabelaEstrangeira
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_TabelaEstrangeiraDel
                                DELETE Campo_TabelaEstrangeira
                                FROM [Campo_TabelaEstrangeira] Campo_TabelaEstrangeira INNER JOIN #TempCampo_TabelaEstrangeiraDel TempCampo_TabelaEstrangeiraDel ON [Campo_TabelaEstrangeira].ID = TempCampo_TabelaEstrangeiraDel.Id
                                WHERE [Campo_TabelaEstrangeira].ID >= @MinId AND [Campo_TabelaEstrangeira].ID <= @MaxId
                                        
                                DELETE #TempCampo_TabelaEstrangeira
                                FROM #TempCampo_TabelaEstrangeira TempCampo_TabelaEstrangeira INNER JOIN #TempCampo_TabelaEstrangeiraDel TempCampo_TabelaEstrangeiraDel ON TempCampo_TabelaEstrangeira.ID = TempCampo_TabelaEstrangeiraDel.Id
                            END
                            DROP TABLE #TempCampo_TabelaEstrangeira
                            DROP TABLE #TempCampo_TabelaEstrangeiraDel
                            GO
PRINT 'Running accountId 1 and table [Tabela_FieldEntityReadCustom]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempTabela_FieldEntityReadCustom

                            CREATE TABLE #TempTabela_FieldEntityReadCustom
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempTabela_FieldEntityReadCustom (Id)
                            SELECT  [TF].Id
                            FROM [Tabela_FieldEntityReadCustom] TF INNER JOIN [Campo_Tabela_Read_Custom] CTRC ON TF.[FieldEntityReadCustomId] = CTRC.[ID]
                            WHERE [CTRC].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempTabela_FieldEntityReadCustomDel
                            CREATE TABLE #TempTabela_FieldEntityReadCustomDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempTabela_FieldEntityReadCustom))
                            BEGIN
                                TRUNCATE TABLE #TempTabela_FieldEntityReadCustomDel

                                INSERT #TempTabela_FieldEntityReadCustomDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempTabela_FieldEntityReadCustom
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempTabela_FieldEntityReadCustomDel
                                DELETE TF
                                FROM [Tabela_FieldEntityReadCustom] TF INNER JOIN #TempTabela_FieldEntityReadCustomDel TempTabela_FieldEntityReadCustomDel ON [TF].ID = TempTabela_FieldEntityReadCustomDel.Id
                                WHERE [TF].ID >= @MinId AND [TF].ID <= @MaxId
                                        
                                DELETE #TempTabela_FieldEntityReadCustom
                                FROM #TempTabela_FieldEntityReadCustom TempTabela_FieldEntityReadCustom INNER JOIN #TempTabela_FieldEntityReadCustomDel TempTabela_FieldEntityReadCustomDel ON TempTabela_FieldEntityReadCustom.ID = TempTabela_FieldEntityReadCustomDel.Id
                            END
                            DROP TABLE #TempTabela_FieldEntityReadCustom
                            DROP TABLE #TempTabela_FieldEntityReadCustomDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Tabela_Read_Custom_FieldPath]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Tabela_Read_Custom_FieldPath

                            CREATE TABLE #TempCampo_Tabela_Read_Custom_FieldPath
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Tabela_Read_Custom_FieldPath (Id)
                            SELECT  [CTRCF].Id
                            FROM [Campo_Tabela_Read_Custom_FieldPath] CTRCF INNER JOIN [Campo_Tabela_Read_Custom] CTRC ON CTRCF.[FieldEntityReadCustomId] = CTRC.[ID]
                            WHERE [CTRC].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Tabela_Read_Custom_FieldPathDel
                            CREATE TABLE #TempCampo_Tabela_Read_Custom_FieldPathDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Tabela_Read_Custom_FieldPath))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Tabela_Read_Custom_FieldPathDel

                                INSERT #TempCampo_Tabela_Read_Custom_FieldPathDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Tabela_Read_Custom_FieldPath
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Tabela_Read_Custom_FieldPathDel
                                DELETE CTRCF
                                FROM [Campo_Tabela_Read_Custom_FieldPath] CTRCF INNER JOIN #TempCampo_Tabela_Read_Custom_FieldPathDel TempCampo_Tabela_Read_Custom_FieldPathDel ON [CTRCF].ID = TempCampo_Tabela_Read_Custom_FieldPathDel.Id
                                WHERE [CTRCF].ID >= @MinId AND [CTRCF].ID <= @MaxId
                                        
                                DELETE #TempCampo_Tabela_Read_Custom_FieldPath
                                FROM #TempCampo_Tabela_Read_Custom_FieldPath TempCampo_Tabela_Read_Custom_FieldPath INNER JOIN #TempCampo_Tabela_Read_Custom_FieldPathDel TempCampo_Tabela_Read_Custom_FieldPathDel ON TempCampo_Tabela_Read_Custom_FieldPath.ID = TempCampo_Tabela_Read_Custom_FieldPathDel.Id
                            END
                            DROP TABLE #TempCampo_Tabela_Read_Custom_FieldPath
                            DROP TABLE #TempCampo_Tabela_Read_Custom_FieldPathDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Tabela_Read_Custom]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Tabela_Read_Custom

                            CREATE TABLE #TempCampo_Tabela_Read_Custom
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Tabela_Read_Custom (Id)
                            SELECT  [Campo_Tabela_Read_Custom].Id
                            FROM [Campo_Tabela_Read_Custom] Campo_Tabela_Read_Custom
                            WHERE [Campo_Tabela_Read_Custom].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Tabela_Read_CustomDel
                            CREATE TABLE #TempCampo_Tabela_Read_CustomDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Tabela_Read_Custom))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Tabela_Read_CustomDel

                                INSERT #TempCampo_Tabela_Read_CustomDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Tabela_Read_Custom
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Tabela_Read_CustomDel
                                DELETE Campo_Tabela_Read_Custom
                                FROM [Campo_Tabela_Read_Custom] Campo_Tabela_Read_Custom INNER JOIN #TempCampo_Tabela_Read_CustomDel TempCampo_Tabela_Read_CustomDel ON [Campo_Tabela_Read_Custom].ID = TempCampo_Tabela_Read_CustomDel.Id
                                WHERE [Campo_Tabela_Read_Custom].ID >= @MinId AND [Campo_Tabela_Read_Custom].ID <= @MaxId
                                        
                                DELETE #TempCampo_Tabela_Read_Custom
                                FROM #TempCampo_Tabela_Read_Custom TempCampo_Tabela_Read_Custom INNER JOIN #TempCampo_Tabela_Read_CustomDel TempCampo_Tabela_Read_CustomDel ON TempCampo_Tabela_Read_Custom.ID = TempCampo_Tabela_Read_CustomDel.Id
                            END
                            DROP TABLE #TempCampo_Tabela_Read_Custom
                            DROP TABLE #TempCampo_Tabela_Read_CustomDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Tabela_LastUpdate]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Tabela_LastUpdate

                            CREATE TABLE #TempCampo_Tabela_LastUpdate
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Tabela_LastUpdate (Id)
                            SELECT  [Campo_Tabela_LastUpdate].Id
                            FROM [Campo_Tabela_LastUpdate] Campo_Tabela_LastUpdate
                            WHERE [Campo_Tabela_LastUpdate].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Tabela_LastUpdateDel
                            CREATE TABLE #TempCampo_Tabela_LastUpdateDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Tabela_LastUpdate))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Tabela_LastUpdateDel

                                INSERT #TempCampo_Tabela_LastUpdateDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Tabela_LastUpdate
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Tabela_LastUpdateDel
                                DELETE Campo_Tabela_LastUpdate
                                FROM [Campo_Tabela_LastUpdate] Campo_Tabela_LastUpdate INNER JOIN #TempCampo_Tabela_LastUpdateDel TempCampo_Tabela_LastUpdateDel ON [Campo_Tabela_LastUpdate].ID = TempCampo_Tabela_LastUpdateDel.Id
                                WHERE [Campo_Tabela_LastUpdate].ID >= @MinId AND [Campo_Tabela_LastUpdate].ID <= @MaxId
                                        
                                DELETE #TempCampo_Tabela_LastUpdate
                                FROM #TempCampo_Tabela_LastUpdate TempCampo_Tabela_LastUpdate INNER JOIN #TempCampo_Tabela_LastUpdateDel TempCampo_Tabela_LastUpdateDel ON TempCampo_Tabela_LastUpdate.ID = TempCampo_Tabela_LastUpdateDel.Id
                            END
                            DROP TABLE #TempCampo_Tabela_LastUpdate
                            DROP TABLE #TempCampo_Tabela_LastUpdateDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Tabela_ClientePloomes]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Tabela_ClientePloomes

                            CREATE TABLE #TempCampo_Tabela_ClientePloomes
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Tabela_ClientePloomes (Id)
                            SELECT  [Campo_Tabela_ClientePloomes].Id
                            FROM [Campo_Tabela_ClientePloomes] Campo_Tabela_ClientePloomes
                            WHERE [Campo_Tabela_ClientePloomes].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Tabela_ClientePloomesDel
                            CREATE TABLE #TempCampo_Tabela_ClientePloomesDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Tabela_ClientePloomes))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Tabela_ClientePloomesDel

                                INSERT #TempCampo_Tabela_ClientePloomesDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Tabela_ClientePloomes
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Tabela_ClientePloomesDel
                                DELETE Campo_Tabela_ClientePloomes
                                FROM [Campo_Tabela_ClientePloomes] Campo_Tabela_ClientePloomes INNER JOIN #TempCampo_Tabela_ClientePloomesDel TempCampo_Tabela_ClientePloomesDel ON [Campo_Tabela_ClientePloomes].ID = TempCampo_Tabela_ClientePloomesDel.Id
                                WHERE [Campo_Tabela_ClientePloomes].ID >= @MinId AND [Campo_Tabela_ClientePloomes].ID <= @MaxId
                                        
                                DELETE #TempCampo_Tabela_ClientePloomes
                                FROM #TempCampo_Tabela_ClientePloomes TempCampo_Tabela_ClientePloomes INNER JOIN #TempCampo_Tabela_ClientePloomesDel TempCampo_Tabela_ClientePloomesDel ON TempCampo_Tabela_ClientePloomes.ID = TempCampo_Tabela_ClientePloomesDel.Id
                            END
                            DROP TABLE #TempCampo_Tabela_ClientePloomes
                            DROP TABLE #TempCampo_Tabela_ClientePloomesDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Permissao_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Permissao_Usuario

                            CREATE TABLE #TempCampo_Permissao_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Permissao_Usuario (Id)
                            SELECT  [Campo_Permissao_Usuario].Id
                            FROM [Campo_Permissao_Usuario] Campo_Permissao_Usuario
                            WHERE [Campo_Permissao_Usuario].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Permissao_UsuarioDel
                            CREATE TABLE #TempCampo_Permissao_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Permissao_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Permissao_UsuarioDel

                                INSERT #TempCampo_Permissao_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Permissao_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Permissao_UsuarioDel
                                DELETE Campo_Permissao_Usuario
                                FROM [Campo_Permissao_Usuario] Campo_Permissao_Usuario INNER JOIN #TempCampo_Permissao_UsuarioDel TempCampo_Permissao_UsuarioDel ON [Campo_Permissao_Usuario].ID = TempCampo_Permissao_UsuarioDel.Id
                                WHERE [Campo_Permissao_Usuario].ID >= @MinId AND [Campo_Permissao_Usuario].ID <= @MaxId
                                        
                                DELETE #TempCampo_Permissao_Usuario
                                FROM #TempCampo_Permissao_Usuario TempCampo_Permissao_Usuario INNER JOIN #TempCampo_Permissao_UsuarioDel TempCampo_Permissao_UsuarioDel ON TempCampo_Permissao_Usuario.ID = TempCampo_Permissao_UsuarioDel.Id
                            END
                            DROP TABLE #TempCampo_Permissao_Usuario
                            DROP TABLE #TempCampo_Permissao_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Permissao_Required_UserProfile]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Permissao_Required_UserProfile

                            CREATE TABLE #TempCampo_Permissao_Required_UserProfile
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Permissao_Required_UserProfile (Id)
                            SELECT  [Campo_Permissao_Required_UserProfile].Id
                            FROM [Campo_Permissao_Required_UserProfile] Campo_Permissao_Required_UserProfile
                            WHERE [Campo_Permissao_Required_UserProfile].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Permissao_Required_UserProfileDel
                            CREATE TABLE #TempCampo_Permissao_Required_UserProfileDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Permissao_Required_UserProfile))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Permissao_Required_UserProfileDel

                                INSERT #TempCampo_Permissao_Required_UserProfileDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Permissao_Required_UserProfile
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Permissao_Required_UserProfileDel
                                DELETE Campo_Permissao_Required_UserProfile
                                FROM [Campo_Permissao_Required_UserProfile] Campo_Permissao_Required_UserProfile INNER JOIN #TempCampo_Permissao_Required_UserProfileDel TempCampo_Permissao_Required_UserProfileDel ON [Campo_Permissao_Required_UserProfile].ID = TempCampo_Permissao_Required_UserProfileDel.Id
                                WHERE [Campo_Permissao_Required_UserProfile].ID >= @MinId AND [Campo_Permissao_Required_UserProfile].ID <= @MaxId
                                        
                                DELETE #TempCampo_Permissao_Required_UserProfile
                                FROM #TempCampo_Permissao_Required_UserProfile TempCampo_Permissao_Required_UserProfile INNER JOIN #TempCampo_Permissao_Required_UserProfileDel TempCampo_Permissao_Required_UserProfileDel ON TempCampo_Permissao_Required_UserProfile.ID = TempCampo_Permissao_Required_UserProfileDel.Id
                            END
                            DROP TABLE #TempCampo_Permissao_Required_UserProfile
                            DROP TABLE #TempCampo_Permissao_Required_UserProfileDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Permissao_Required_User]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Permissao_Required_User

                            CREATE TABLE #TempCampo_Permissao_Required_User
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Permissao_Required_User (Id)
                            SELECT  [Campo_Permissao_Required_User].Id
                            FROM [Campo_Permissao_Required_User] Campo_Permissao_Required_User
                            WHERE [Campo_Permissao_Required_User].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Permissao_Required_UserDel
                            CREATE TABLE #TempCampo_Permissao_Required_UserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Permissao_Required_User))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Permissao_Required_UserDel

                                INSERT #TempCampo_Permissao_Required_UserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Permissao_Required_User
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Permissao_Required_UserDel
                                DELETE Campo_Permissao_Required_User
                                FROM [Campo_Permissao_Required_User] Campo_Permissao_Required_User INNER JOIN #TempCampo_Permissao_Required_UserDel TempCampo_Permissao_Required_UserDel ON [Campo_Permissao_Required_User].ID = TempCampo_Permissao_Required_UserDel.Id
                                WHERE [Campo_Permissao_Required_User].ID >= @MinId AND [Campo_Permissao_Required_User].ID <= @MaxId
                                        
                                DELETE #TempCampo_Permissao_Required_User
                                FROM #TempCampo_Permissao_Required_User TempCampo_Permissao_Required_User INNER JOIN #TempCampo_Permissao_Required_UserDel TempCampo_Permissao_Required_UserDel ON TempCampo_Permissao_Required_User.ID = TempCampo_Permissao_Required_UserDel.Id
                            END
                            DROP TABLE #TempCampo_Permissao_Required_User
                            DROP TABLE #TempCampo_Permissao_Required_UserDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Permissao_Required_Team]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Permissao_Required_Team

                            CREATE TABLE #TempCampo_Permissao_Required_Team
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Permissao_Required_Team (Id)
                            SELECT  [Campo_Permissao_Required_Team].Id
                            FROM [Campo_Permissao_Required_Team] Campo_Permissao_Required_Team
                            WHERE [Campo_Permissao_Required_Team].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Permissao_Required_TeamDel
                            CREATE TABLE #TempCampo_Permissao_Required_TeamDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Permissao_Required_Team))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Permissao_Required_TeamDel

                                INSERT #TempCampo_Permissao_Required_TeamDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Permissao_Required_Team
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Permissao_Required_TeamDel
                                DELETE Campo_Permissao_Required_Team
                                FROM [Campo_Permissao_Required_Team] Campo_Permissao_Required_Team INNER JOIN #TempCampo_Permissao_Required_TeamDel TempCampo_Permissao_Required_TeamDel ON [Campo_Permissao_Required_Team].ID = TempCampo_Permissao_Required_TeamDel.Id
                                WHERE [Campo_Permissao_Required_Team].ID >= @MinId AND [Campo_Permissao_Required_Team].ID <= @MaxId
                                        
                                DELETE #TempCampo_Permissao_Required_Team
                                FROM #TempCampo_Permissao_Required_Team TempCampo_Permissao_Required_Team INNER JOIN #TempCampo_Permissao_Required_TeamDel TempCampo_Permissao_Required_TeamDel ON TempCampo_Permissao_Required_Team.ID = TempCampo_Permissao_Required_TeamDel.Id
                            END
                            DROP TABLE #TempCampo_Permissao_Required_Team
                            DROP TABLE #TempCampo_Permissao_Required_TeamDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Permissao_PerfilUsuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Permissao_PerfilUsuario

                            CREATE TABLE #TempCampo_Permissao_PerfilUsuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Permissao_PerfilUsuario (Id)
                            SELECT  [Campo_Permissao_PerfilUsuario].Id
                            FROM [Campo_Permissao_PerfilUsuario] Campo_Permissao_PerfilUsuario
                            WHERE [Campo_Permissao_PerfilUsuario].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Permissao_PerfilUsuarioDel
                            CREATE TABLE #TempCampo_Permissao_PerfilUsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Permissao_PerfilUsuario))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Permissao_PerfilUsuarioDel

                                INSERT #TempCampo_Permissao_PerfilUsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Permissao_PerfilUsuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Permissao_PerfilUsuarioDel
                                DELETE Campo_Permissao_PerfilUsuario
                                FROM [Campo_Permissao_PerfilUsuario] Campo_Permissao_PerfilUsuario INNER JOIN #TempCampo_Permissao_PerfilUsuarioDel TempCampo_Permissao_PerfilUsuarioDel ON [Campo_Permissao_PerfilUsuario].ID = TempCampo_Permissao_PerfilUsuarioDel.Id
                                WHERE [Campo_Permissao_PerfilUsuario].ID >= @MinId AND [Campo_Permissao_PerfilUsuario].ID <= @MaxId
                                        
                                DELETE #TempCampo_Permissao_PerfilUsuario
                                FROM #TempCampo_Permissao_PerfilUsuario TempCampo_Permissao_PerfilUsuario INNER JOIN #TempCampo_Permissao_PerfilUsuarioDel TempCampo_Permissao_PerfilUsuarioDel ON TempCampo_Permissao_PerfilUsuario.ID = TempCampo_Permissao_PerfilUsuarioDel.Id
                            END
                            DROP TABLE #TempCampo_Permissao_PerfilUsuario
                            DROP TABLE #TempCampo_Permissao_PerfilUsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Permissao_Exhibition_UserProfile]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Permissao_Exhibition_UserProfile

                            CREATE TABLE #TempCampo_Permissao_Exhibition_UserProfile
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Permissao_Exhibition_UserProfile (Id)
                            SELECT  [Campo_Permissao_Exhibition_UserProfile].Id
                            FROM [Campo_Permissao_Exhibition_UserProfile] Campo_Permissao_Exhibition_UserProfile
                            WHERE [Campo_Permissao_Exhibition_UserProfile].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Permissao_Exhibition_UserProfileDel
                            CREATE TABLE #TempCampo_Permissao_Exhibition_UserProfileDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Permissao_Exhibition_UserProfile))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Permissao_Exhibition_UserProfileDel

                                INSERT #TempCampo_Permissao_Exhibition_UserProfileDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Permissao_Exhibition_UserProfile
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Permissao_Exhibition_UserProfileDel
                                DELETE Campo_Permissao_Exhibition_UserProfile
                                FROM [Campo_Permissao_Exhibition_UserProfile] Campo_Permissao_Exhibition_UserProfile INNER JOIN #TempCampo_Permissao_Exhibition_UserProfileDel TempCampo_Permissao_Exhibition_UserProfileDel ON [Campo_Permissao_Exhibition_UserProfile].ID = TempCampo_Permissao_Exhibition_UserProfileDel.Id
                                WHERE [Campo_Permissao_Exhibition_UserProfile].ID >= @MinId AND [Campo_Permissao_Exhibition_UserProfile].ID <= @MaxId
                                        
                                DELETE #TempCampo_Permissao_Exhibition_UserProfile
                                FROM #TempCampo_Permissao_Exhibition_UserProfile TempCampo_Permissao_Exhibition_UserProfile INNER JOIN #TempCampo_Permissao_Exhibition_UserProfileDel TempCampo_Permissao_Exhibition_UserProfileDel ON TempCampo_Permissao_Exhibition_UserProfile.ID = TempCampo_Permissao_Exhibition_UserProfileDel.Id
                            END
                            DROP TABLE #TempCampo_Permissao_Exhibition_UserProfile
                            DROP TABLE #TempCampo_Permissao_Exhibition_UserProfileDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Permissao_Exhibition_User]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Permissao_Exhibition_User

                            CREATE TABLE #TempCampo_Permissao_Exhibition_User
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Permissao_Exhibition_User (Id)
                            SELECT  [Campo_Permissao_Exhibition_User].Id
                            FROM [Campo_Permissao_Exhibition_User] Campo_Permissao_Exhibition_User
                            WHERE [Campo_Permissao_Exhibition_User].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Permissao_Exhibition_UserDel
                            CREATE TABLE #TempCampo_Permissao_Exhibition_UserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Permissao_Exhibition_User))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Permissao_Exhibition_UserDel

                                INSERT #TempCampo_Permissao_Exhibition_UserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Permissao_Exhibition_User
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Permissao_Exhibition_UserDel
                                DELETE Campo_Permissao_Exhibition_User
                                FROM [Campo_Permissao_Exhibition_User] Campo_Permissao_Exhibition_User INNER JOIN #TempCampo_Permissao_Exhibition_UserDel TempCampo_Permissao_Exhibition_UserDel ON [Campo_Permissao_Exhibition_User].ID = TempCampo_Permissao_Exhibition_UserDel.Id
                                WHERE [Campo_Permissao_Exhibition_User].ID >= @MinId AND [Campo_Permissao_Exhibition_User].ID <= @MaxId
                                        
                                DELETE #TempCampo_Permissao_Exhibition_User
                                FROM #TempCampo_Permissao_Exhibition_User TempCampo_Permissao_Exhibition_User INNER JOIN #TempCampo_Permissao_Exhibition_UserDel TempCampo_Permissao_Exhibition_UserDel ON TempCampo_Permissao_Exhibition_User.ID = TempCampo_Permissao_Exhibition_UserDel.Id
                            END
                            DROP TABLE #TempCampo_Permissao_Exhibition_User
                            DROP TABLE #TempCampo_Permissao_Exhibition_UserDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Permissao_Exhibition_Team]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Permissao_Exhibition_Team

                            CREATE TABLE #TempCampo_Permissao_Exhibition_Team
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Permissao_Exhibition_Team (Id)
                            SELECT  [Campo_Permissao_Exhibition_Team].Id
                            FROM [Campo_Permissao_Exhibition_Team] Campo_Permissao_Exhibition_Team
                            WHERE [Campo_Permissao_Exhibition_Team].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Permissao_Exhibition_TeamDel
                            CREATE TABLE #TempCampo_Permissao_Exhibition_TeamDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Permissao_Exhibition_Team))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Permissao_Exhibition_TeamDel

                                INSERT #TempCampo_Permissao_Exhibition_TeamDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Permissao_Exhibition_Team
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Permissao_Exhibition_TeamDel
                                DELETE Campo_Permissao_Exhibition_Team
                                FROM [Campo_Permissao_Exhibition_Team] Campo_Permissao_Exhibition_Team INNER JOIN #TempCampo_Permissao_Exhibition_TeamDel TempCampo_Permissao_Exhibition_TeamDel ON [Campo_Permissao_Exhibition_Team].ID = TempCampo_Permissao_Exhibition_TeamDel.Id
                                WHERE [Campo_Permissao_Exhibition_Team].ID >= @MinId AND [Campo_Permissao_Exhibition_Team].ID <= @MaxId
                                        
                                DELETE #TempCampo_Permissao_Exhibition_Team
                                FROM #TempCampo_Permissao_Exhibition_Team TempCampo_Permissao_Exhibition_Team INNER JOIN #TempCampo_Permissao_Exhibition_TeamDel TempCampo_Permissao_Exhibition_TeamDel ON TempCampo_Permissao_Exhibition_Team.ID = TempCampo_Permissao_Exhibition_TeamDel.Id
                            END
                            DROP TABLE #TempCampo_Permissao_Exhibition_Team
                            DROP TABLE #TempCampo_Permissao_Exhibition_TeamDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Permissao_Equipe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Permissao_Equipe

                            CREATE TABLE #TempCampo_Permissao_Equipe
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Permissao_Equipe (Id)
                            SELECT  [Campo_Permissao_Equipe].Id
                            FROM [Campo_Permissao_Equipe] Campo_Permissao_Equipe
                            WHERE [Campo_Permissao_Equipe].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Permissao_EquipeDel
                            CREATE TABLE #TempCampo_Permissao_EquipeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Permissao_Equipe))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Permissao_EquipeDel

                                INSERT #TempCampo_Permissao_EquipeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Permissao_Equipe
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Permissao_EquipeDel
                                DELETE Campo_Permissao_Equipe
                                FROM [Campo_Permissao_Equipe] Campo_Permissao_Equipe INNER JOIN #TempCampo_Permissao_EquipeDel TempCampo_Permissao_EquipeDel ON [Campo_Permissao_Equipe].ID = TempCampo_Permissao_EquipeDel.Id
                                WHERE [Campo_Permissao_Equipe].ID >= @MinId AND [Campo_Permissao_Equipe].ID <= @MaxId
                                        
                                DELETE #TempCampo_Permissao_Equipe
                                FROM #TempCampo_Permissao_Equipe TempCampo_Permissao_Equipe INNER JOIN #TempCampo_Permissao_EquipeDel TempCampo_Permissao_EquipeDel ON TempCampo_Permissao_Equipe.ID = TempCampo_Permissao_EquipeDel.Id
                            END
                            DROP TABLE #TempCampo_Permissao_Equipe
                            DROP TABLE #TempCampo_Permissao_EquipeDel
                            GO
PRINT 'Running accountId 1 and table [Campo_MappedField]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_MappedField

                            CREATE TABLE #TempCampo_MappedField
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_MappedField (Id)
                            SELECT  [Campo_MappedField].Id
                            FROM [Campo_MappedField] Campo_MappedField
                            WHERE [Campo_MappedField].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_MappedFieldDel
                            CREATE TABLE #TempCampo_MappedFieldDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_MappedField))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_MappedFieldDel

                                INSERT #TempCampo_MappedFieldDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_MappedField
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_MappedFieldDel
                                DELETE Campo_MappedField
                                FROM [Campo_MappedField] Campo_MappedField INNER JOIN #TempCampo_MappedFieldDel TempCampo_MappedFieldDel ON [Campo_MappedField].ID = TempCampo_MappedFieldDel.Id
                                WHERE [Campo_MappedField].ID >= @MinId AND [Campo_MappedField].ID <= @MaxId
                                        
                                DELETE #TempCampo_MappedField
                                FROM #TempCampo_MappedField TempCampo_MappedField INNER JOIN #TempCampo_MappedFieldDel TempCampo_MappedFieldDel ON TempCampo_MappedField.ID = TempCampo_MappedFieldDel.Id
                            END
                            DROP TABLE #TempCampo_MappedField
                            DROP TABLE #TempCampo_MappedFieldDel
                            GO
PRINT 'Running accountId 1 and table [Campo_GoogleSheets_Variavel]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_GoogleSheets_Variavel

                            CREATE TABLE #TempCampo_GoogleSheets_Variavel
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_GoogleSheets_Variavel (Id)
                            SELECT  [CGV].Id
                            FROM [Campo_GoogleSheets_Variavel] CGV INNER JOIN [Campo_GoogleSheets] CG ON CGV.ID_Integracao = CG.ID INNER JOIN [Campo] C ON CG.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_GoogleSheets_VariavelDel
                            CREATE TABLE #TempCampo_GoogleSheets_VariavelDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_GoogleSheets_Variavel))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_GoogleSheets_VariavelDel

                                INSERT #TempCampo_GoogleSheets_VariavelDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_GoogleSheets_Variavel
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_GoogleSheets_VariavelDel
                                DELETE CGV
                                FROM [Campo_GoogleSheets_Variavel] CGV INNER JOIN #TempCampo_GoogleSheets_VariavelDel TempCampo_GoogleSheets_VariavelDel ON [CGV].ID = TempCampo_GoogleSheets_VariavelDel.Id
                                WHERE [CGV].ID >= @MinId AND [CGV].ID <= @MaxId
                                        
                                DELETE #TempCampo_GoogleSheets_Variavel
                                FROM #TempCampo_GoogleSheets_Variavel TempCampo_GoogleSheets_Variavel INNER JOIN #TempCampo_GoogleSheets_VariavelDel TempCampo_GoogleSheets_VariavelDel ON TempCampo_GoogleSheets_Variavel.ID = TempCampo_GoogleSheets_VariavelDel.Id
                            END
                            DROP TABLE #TempCampo_GoogleSheets_Variavel
                            DROP TABLE #TempCampo_GoogleSheets_VariavelDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Anexo_Item]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Anexo_Item

                            CREATE TABLE #TempCampo_Valor_Anexo_Item
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Anexo_Item (Id)
                            SELECT  [CVAI].Id
                            FROM [Campo_Valor_Anexo_Item] CVAI INNER JOIN [Campo] C ON CVAI.[FieldId] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Anexo_ItemDel
                            CREATE TABLE #TempCampo_Valor_Anexo_ItemDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Anexo_Item))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Anexo_ItemDel

                                INSERT #TempCampo_Valor_Anexo_ItemDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Anexo_Item
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Anexo_ItemDel
                                DELETE CVAI
                                FROM [Campo_Valor_Anexo_Item] CVAI INNER JOIN #TempCampo_Valor_Anexo_ItemDel TempCampo_Valor_Anexo_ItemDel ON [CVAI].ID = TempCampo_Valor_Anexo_ItemDel.Id
                                WHERE [CVAI].ID >= @MinId AND [CVAI].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Anexo_Item
                                FROM #TempCampo_Valor_Anexo_Item TempCampo_Valor_Anexo_Item INNER JOIN #TempCampo_Valor_Anexo_ItemDel TempCampo_Valor_Anexo_ItemDel ON TempCampo_Valor_Anexo_Item.ID = TempCampo_Valor_Anexo_ItemDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Anexo_Item
                            DROP TABLE #TempCampo_Valor_Anexo_ItemDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Usuario]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Usuario

                            CREATE TABLE #TempCampo_Valor_Usuario
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Usuario (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Usuario] CV INNER JOIN [Campo] C ON CV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_UsuarioDel
                            CREATE TABLE #TempCampo_Valor_UsuarioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Usuario))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_UsuarioDel

                                INSERT #TempCampo_Valor_UsuarioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Usuario
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_UsuarioDel
                                DELETE CV
                                FROM [Campo_Valor_Usuario] CV INNER JOIN #TempCampo_Valor_UsuarioDel TempCampo_Valor_UsuarioDel ON [CV].ID = TempCampo_Valor_UsuarioDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Usuario
                                FROM #TempCampo_Valor_Usuario TempCampo_Valor_Usuario INNER JOIN #TempCampo_Valor_UsuarioDel TempCampo_Valor_UsuarioDel ON TempCampo_Valor_Usuario.ID = TempCampo_Valor_UsuarioDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Usuario
                            DROP TABLE #TempCampo_Valor_UsuarioDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Task]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Task

                            CREATE TABLE #TempCampo_Valor_Task
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Task (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Task] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_TaskDel
                            CREATE TABLE #TempCampo_Valor_TaskDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Task))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_TaskDel

                                INSERT #TempCampo_Valor_TaskDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Task
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_TaskDel
                                DELETE CV
                                FROM [Campo_Valor_Task] CV INNER JOIN #TempCampo_Valor_TaskDel TempCampo_Valor_TaskDel ON [CV].ID = TempCampo_Valor_TaskDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Task
                                FROM #TempCampo_Valor_Task TempCampo_Valor_Task INNER JOIN #TempCampo_Valor_TaskDel TempCampo_Valor_TaskDel ON TempCampo_Valor_Task.ID = TempCampo_Valor_TaskDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Task
                            DROP TABLE #TempCampo_Valor_TaskDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Relatorio]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Relatorio

                            CREATE TABLE #TempCampo_Valor_Relatorio
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Relatorio (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Relatorio]  CV INNER JOIN [Campo] C ON CV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_RelatorioDel
                            CREATE TABLE #TempCampo_Valor_RelatorioDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Relatorio))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_RelatorioDel

                                INSERT #TempCampo_Valor_RelatorioDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Relatorio
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_RelatorioDel
                                DELETE CV
                                FROM [Campo_Valor_Relatorio] CV INNER JOIN #TempCampo_Valor_RelatorioDel TempCampo_Valor_RelatorioDel ON [CV].ID = TempCampo_Valor_RelatorioDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Relatorio
                                FROM #TempCampo_Valor_Relatorio TempCampo_Valor_Relatorio INNER JOIN #TempCampo_Valor_RelatorioDel TempCampo_Valor_RelatorioDel ON TempCampo_Valor_Relatorio.ID = TempCampo_Valor_RelatorioDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Relatorio
                            DROP TABLE #TempCampo_Valor_RelatorioDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_RelatedPerson]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_RelatedPerson

                            CREATE TABLE #TempCampo_Valor_RelatedPerson
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_RelatedPerson (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_RelatedPerson] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_RelatedPersonDel
                            CREATE TABLE #TempCampo_Valor_RelatedPersonDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_RelatedPerson))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_RelatedPersonDel

                                INSERT #TempCampo_Valor_RelatedPersonDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_RelatedPerson
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_RelatedPersonDel
                                DELETE CV
                                FROM [Campo_Valor_RelatedPerson] CV INNER JOIN #TempCampo_Valor_RelatedPersonDel TempCampo_Valor_RelatedPersonDel ON [CV].ID = TempCampo_Valor_RelatedPersonDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_RelatedPerson
                                FROM #TempCampo_Valor_RelatedPerson TempCampo_Valor_RelatedPerson INNER JOIN #TempCampo_Valor_RelatedPersonDel TempCampo_Valor_RelatedPersonDel ON TempCampo_Valor_RelatedPerson.ID = TempCampo_Valor_RelatedPersonDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_RelatedPerson
                            DROP TABLE #TempCampo_Valor_RelatedPersonDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Quote_Section]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Quote_Section

                            CREATE TABLE #TempCampo_Valor_Quote_Section
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Quote_Section (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Quote_Section] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Quote_SectionDel
                            CREATE TABLE #TempCampo_Valor_Quote_SectionDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Quote_Section))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Quote_SectionDel

                                INSERT #TempCampo_Valor_Quote_SectionDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Quote_Section
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Quote_SectionDel
                                DELETE CV
                                FROM [Campo_Valor_Quote_Section] CV INNER JOIN #TempCampo_Valor_Quote_SectionDel TempCampo_Valor_Quote_SectionDel ON [CV].ID = TempCampo_Valor_Quote_SectionDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Quote_Section
                                FROM #TempCampo_Valor_Quote_Section TempCampo_Valor_Quote_Section INNER JOIN #TempCampo_Valor_Quote_SectionDel TempCampo_Valor_Quote_SectionDel ON TempCampo_Valor_Quote_Section.ID = TempCampo_Valor_Quote_SectionDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Quote_Section
                            DROP TABLE #TempCampo_Valor_Quote_SectionDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Quote_Product_Part]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Quote_Product_Part

                            CREATE TABLE #TempCampo_Valor_Quote_Product_Part
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Quote_Product_Part (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Quote_Product_Part]  CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Quote_Product_PartDel
                            CREATE TABLE #TempCampo_Valor_Quote_Product_PartDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Quote_Product_Part))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Quote_Product_PartDel

                                INSERT #TempCampo_Valor_Quote_Product_PartDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Quote_Product_Part
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Quote_Product_PartDel
                                DELETE CV
                                FROM [Campo_Valor_Quote_Product_Part] CV INNER JOIN #TempCampo_Valor_Quote_Product_PartDel TempCampo_Valor_Quote_Product_PartDel ON [CV].ID = TempCampo_Valor_Quote_Product_PartDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Quote_Product_Part
                                FROM #TempCampo_Valor_Quote_Product_Part TempCampo_Valor_Quote_Product_Part INNER JOIN #TempCampo_Valor_Quote_Product_PartDel TempCampo_Valor_Quote_Product_PartDel ON TempCampo_Valor_Quote_Product_Part.ID = TempCampo_Valor_Quote_Product_PartDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Quote_Product_Part
                            DROP TABLE #TempCampo_Valor_Quote_Product_PartDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Quote_Product]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Quote_Product

                            CREATE TABLE #TempCampo_Valor_Quote_Product
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Quote_Product (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Quote_Product] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Quote_ProductDel
                            CREATE TABLE #TempCampo_Valor_Quote_ProductDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Quote_Product))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Quote_ProductDel

                                INSERT #TempCampo_Valor_Quote_ProductDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Quote_Product
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Quote_ProductDel
                                DELETE CV
                                FROM [Campo_Valor_Quote_Product] CV INNER JOIN #TempCampo_Valor_Quote_ProductDel TempCampo_Valor_Quote_ProductDel ON [CV].ID = TempCampo_Valor_Quote_ProductDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Quote_Product
                                FROM #TempCampo_Valor_Quote_Product TempCampo_Valor_Quote_Product INNER JOIN #TempCampo_Valor_Quote_ProductDel TempCampo_Valor_Quote_ProductDel ON TempCampo_Valor_Quote_Product.ID = TempCampo_Valor_Quote_ProductDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Quote_Product
                            DROP TABLE #TempCampo_Valor_Quote_ProductDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Quote_Installment]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Quote_Installment

                            CREATE TABLE #TempCampo_Valor_Quote_Installment
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Quote_Installment (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Quote_Installment] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Quote_InstallmentDel
                            CREATE TABLE #TempCampo_Valor_Quote_InstallmentDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Quote_Installment))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Quote_InstallmentDel

                                INSERT #TempCampo_Valor_Quote_InstallmentDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Quote_Installment
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Quote_InstallmentDel
                                DELETE CV
                                FROM [Campo_Valor_Quote_Installment] CV INNER JOIN #TempCampo_Valor_Quote_InstallmentDel TempCampo_Valor_Quote_InstallmentDel ON [CV].ID = TempCampo_Valor_Quote_InstallmentDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Quote_Installment
                                FROM #TempCampo_Valor_Quote_Installment TempCampo_Valor_Quote_Installment INNER JOIN #TempCampo_Valor_Quote_InstallmentDel TempCampo_Valor_Quote_InstallmentDel ON TempCampo_Valor_Quote_Installment.ID = TempCampo_Valor_Quote_InstallmentDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Quote_Installment
                            DROP TABLE #TempCampo_Valor_Quote_InstallmentDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_ProdutoGrupo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_ProdutoGrupo

                            CREATE TABLE #TempCampo_Valor_ProdutoGrupo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_ProdutoGrupo (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_ProdutoGrupo] CV INNER JOIN [Campo] C ON CV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_ProdutoGrupoDel
                            CREATE TABLE #TempCampo_Valor_ProdutoGrupoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_ProdutoGrupo))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_ProdutoGrupoDel

                                INSERT #TempCampo_Valor_ProdutoGrupoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_ProdutoGrupo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_ProdutoGrupoDel
                                DELETE CV
                                FROM [Campo_Valor_ProdutoGrupo] CV INNER JOIN #TempCampo_Valor_ProdutoGrupoDel TempCampo_Valor_ProdutoGrupoDel ON [CV].ID = TempCampo_Valor_ProdutoGrupoDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_ProdutoGrupo
                                FROM #TempCampo_Valor_ProdutoGrupo TempCampo_Valor_ProdutoGrupo INNER JOIN #TempCampo_Valor_ProdutoGrupoDel TempCampo_Valor_ProdutoGrupoDel ON TempCampo_Valor_ProdutoGrupo.ID = TempCampo_Valor_ProdutoGrupoDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_ProdutoGrupo
                            DROP TABLE #TempCampo_Valor_ProdutoGrupoDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Produto]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Produto

                            CREATE TABLE #TempCampo_Valor_Produto
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Produto (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Produto] CV INNER JOIN [Campo] C ON CV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_ProdutoDel
                            CREATE TABLE #TempCampo_Valor_ProdutoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Produto))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_ProdutoDel

                                INSERT #TempCampo_Valor_ProdutoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Produto
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_ProdutoDel
                                DELETE CV
                                FROM [Campo_Valor_Produto] CV INNER JOIN #TempCampo_Valor_ProdutoDel TempCampo_Valor_ProdutoDel ON [CV].ID = TempCampo_Valor_ProdutoDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Produto
                                FROM #TempCampo_Valor_Produto TempCampo_Valor_Produto INNER JOIN #TempCampo_Valor_ProdutoDel TempCampo_Valor_ProdutoDel ON TempCampo_Valor_Produto.ID = TempCampo_Valor_ProdutoDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Produto
                            DROP TABLE #TempCampo_Valor_ProdutoDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Product_Part]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Product_Part

                            CREATE TABLE #TempCampo_Valor_Product_Part
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Product_Part (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Product_Part] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Product_PartDel
                            CREATE TABLE #TempCampo_Valor_Product_PartDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Product_Part))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Product_PartDel

                                INSERT #TempCampo_Valor_Product_PartDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Product_Part
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Product_PartDel
                                DELETE CV
                                FROM [Campo_Valor_Product_Part] CV INNER JOIN #TempCampo_Valor_Product_PartDel TempCampo_Valor_Product_PartDel ON [CV].ID = TempCampo_Valor_Product_PartDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Product_Part
                                FROM #TempCampo_Valor_Product_Part TempCampo_Valor_Product_Part INNER JOIN #TempCampo_Valor_Product_PartDel TempCampo_Valor_Product_PartDel ON TempCampo_Valor_Product_Part.ID = TempCampo_Valor_Product_PartDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Product_Part
                            DROP TABLE #TempCampo_Valor_Product_PartDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Product_List]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Product_List

                            CREATE TABLE #TempCampo_Valor_Product_List
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Product_List (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Product_List] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Product_ListDel
                            CREATE TABLE #TempCampo_Valor_Product_ListDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Product_List))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Product_ListDel

                                INSERT #TempCampo_Valor_Product_ListDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Product_List
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Product_ListDel
                                DELETE CV
                                FROM [Campo_Valor_Product_List] CV INNER JOIN #TempCampo_Valor_Product_ListDel TempCampo_Valor_Product_ListDel ON [CV].ID = TempCampo_Valor_Product_ListDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Product_List
                                FROM #TempCampo_Valor_Product_List TempCampo_Valor_Product_List INNER JOIN #TempCampo_Valor_Product_ListDel TempCampo_Valor_Product_ListDel ON TempCampo_Valor_Product_List.ID = TempCampo_Valor_Product_ListDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Product_List
                            DROP TABLE #TempCampo_Valor_Product_ListDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Product_Family]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Product_Family

                            CREATE TABLE #TempCampo_Valor_Product_Family
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Product_Family (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Product_Family] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Product_FamilyDel
                            CREATE TABLE #TempCampo_Valor_Product_FamilyDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Product_Family))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Product_FamilyDel

                                INSERT #TempCampo_Valor_Product_FamilyDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Product_Family
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Product_FamilyDel
                                DELETE CV
                                FROM [Campo_Valor_Product_Family] CV INNER JOIN #TempCampo_Valor_Product_FamilyDel TempCampo_Valor_Product_FamilyDel ON [CV].ID = TempCampo_Valor_Product_FamilyDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Product_Family
                                FROM #TempCampo_Valor_Product_Family TempCampo_Valor_Product_Family INNER JOIN #TempCampo_Valor_Product_FamilyDel TempCampo_Valor_Product_FamilyDel ON TempCampo_Valor_Product_Family.ID = TempCampo_Valor_Product_FamilyDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Product_Family
                            DROP TABLE #TempCampo_Valor_Product_FamilyDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Order_Section]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Order_Section

                            CREATE TABLE #TempCampo_Valor_Order_Section
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Order_Section (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Order_Section] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Order_SectionDel
                            CREATE TABLE #TempCampo_Valor_Order_SectionDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Order_Section))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Order_SectionDel

                                INSERT #TempCampo_Valor_Order_SectionDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Order_Section
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Order_SectionDel
                                DELETE CV
                                FROM [Campo_Valor_Order_Section] CV INNER JOIN #TempCampo_Valor_Order_SectionDel TempCampo_Valor_Order_SectionDel ON [CV].ID = TempCampo_Valor_Order_SectionDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Order_Section
                                FROM #TempCampo_Valor_Order_Section TempCampo_Valor_Order_Section INNER JOIN #TempCampo_Valor_Order_SectionDel TempCampo_Valor_Order_SectionDel ON TempCampo_Valor_Order_Section.ID = TempCampo_Valor_Order_SectionDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Order_Section
                            DROP TABLE #TempCampo_Valor_Order_SectionDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Order_Product_Part]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Order_Product_Part

                            CREATE TABLE #TempCampo_Valor_Order_Product_Part
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Order_Product_Part (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Order_Product_Part] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Order_Product_PartDel
                            CREATE TABLE #TempCampo_Valor_Order_Product_PartDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Order_Product_Part))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Order_Product_PartDel

                                INSERT #TempCampo_Valor_Order_Product_PartDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Order_Product_Part
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Order_Product_PartDel
                                DELETE CV
                                FROM [Campo_Valor_Order_Product_Part] CV INNER JOIN #TempCampo_Valor_Order_Product_PartDel TempCampo_Valor_Order_Product_PartDel ON [CV].ID = TempCampo_Valor_Order_Product_PartDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Order_Product_Part
                                FROM #TempCampo_Valor_Order_Product_Part TempCampo_Valor_Order_Product_Part INNER JOIN #TempCampo_Valor_Order_Product_PartDel TempCampo_Valor_Order_Product_PartDel ON TempCampo_Valor_Order_Product_Part.ID = TempCampo_Valor_Order_Product_PartDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Order_Product_Part
                            DROP TABLE #TempCampo_Valor_Order_Product_PartDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Order_Product]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Order_Product

                            CREATE TABLE #TempCampo_Valor_Order_Product
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Order_Product (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Order_Product] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Order_ProductDel
                            CREATE TABLE #TempCampo_Valor_Order_ProductDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Order_Product))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Order_ProductDel

                                INSERT #TempCampo_Valor_Order_ProductDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Order_Product
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Order_ProductDel
                                DELETE CV
                                FROM [Campo_Valor_Order_Product] CV INNER JOIN #TempCampo_Valor_Order_ProductDel TempCampo_Valor_Order_ProductDel ON [CV].ID = TempCampo_Valor_Order_ProductDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Order_Product
                                FROM #TempCampo_Valor_Order_Product TempCampo_Valor_Order_Product INNER JOIN #TempCampo_Valor_Order_ProductDel TempCampo_Valor_Order_ProductDel ON TempCampo_Valor_Order_Product.ID = TempCampo_Valor_Order_ProductDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Order_Product
                            DROP TABLE #TempCampo_Valor_Order_ProductDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Order_Installment]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Order_Installment

                            CREATE TABLE #TempCampo_Valor_Order_Installment
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Order_Installment (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Order_Installment] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Order_InstallmentDel
                            CREATE TABLE #TempCampo_Valor_Order_InstallmentDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Order_Installment))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Order_InstallmentDel

                                INSERT #TempCampo_Valor_Order_InstallmentDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Order_Installment
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Order_InstallmentDel
                                DELETE CV
                                FROM [Campo_Valor_Order_Installment] CV INNER JOIN #TempCampo_Valor_Order_InstallmentDel TempCampo_Valor_Order_InstallmentDel ON [CV].ID = TempCampo_Valor_Order_InstallmentDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Order_Installment
                                FROM #TempCampo_Valor_Order_Installment TempCampo_Valor_Order_Installment INNER JOIN #TempCampo_Valor_Order_InstallmentDel TempCampo_Valor_Order_InstallmentDel ON TempCampo_Valor_Order_Installment.ID = TempCampo_Valor_Order_InstallmentDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Order_Installment
                            DROP TABLE #TempCampo_Valor_Order_InstallmentDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Order]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Order

                            CREATE TABLE #TempCampo_Valor_Order
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Order (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Order] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_OrderDel
                            CREATE TABLE #TempCampo_Valor_OrderDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Order))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_OrderDel

                                INSERT #TempCampo_Valor_OrderDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Order
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_OrderDel
                                DELETE CV
                                FROM [Campo_Valor_Order] CV INNER JOIN #TempCampo_Valor_OrderDel TempCampo_Valor_OrderDel ON [CV].ID = TempCampo_Valor_OrderDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Order
                                FROM #TempCampo_Valor_Order TempCampo_Valor_Order INNER JOIN #TempCampo_Valor_OrderDel TempCampo_Valor_OrderDel ON TempCampo_Valor_Order.ID = TempCampo_Valor_OrderDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Order
                            DROP TABLE #TempCampo_Valor_OrderDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Oportunidade]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Oportunidade

                            CREATE TABLE #TempCampo_Valor_Oportunidade
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Oportunidade (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Oportunidade] CV INNER JOIN [Campo] C ON CV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_OportunidadeDel
                            CREATE TABLE #TempCampo_Valor_OportunidadeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Oportunidade))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_OportunidadeDel

                                INSERT #TempCampo_Valor_OportunidadeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Oportunidade
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_OportunidadeDel
                                DELETE CV
                                FROM [Campo_Valor_Oportunidade] CV INNER JOIN #TempCampo_Valor_OportunidadeDel TempCampo_Valor_OportunidadeDel ON [CV].ID = TempCampo_Valor_OportunidadeDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Oportunidade
                                FROM #TempCampo_Valor_Oportunidade TempCampo_Valor_Oportunidade INNER JOIN #TempCampo_Valor_OportunidadeDel TempCampo_Valor_OportunidadeDel ON TempCampo_Valor_Oportunidade.ID = TempCampo_Valor_OportunidadeDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Oportunidade
                            DROP TABLE #TempCampo_Valor_OportunidadeDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Lead]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Lead

                            CREATE TABLE #TempCampo_Valor_Lead
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Lead (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Lead] CV INNER JOIN [Campo] C ON CV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_LeadDel
                            CREATE TABLE #TempCampo_Valor_LeadDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Lead))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_LeadDel

                                INSERT #TempCampo_Valor_LeadDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Lead
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_LeadDel
                                DELETE CV
                                FROM [Campo_Valor_Lead] CV INNER JOIN #TempCampo_Valor_LeadDel TempCampo_Valor_LeadDel ON [CV].ID = TempCampo_Valor_LeadDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Lead
                                FROM #TempCampo_Valor_Lead TempCampo_Valor_Lead INNER JOIN #TempCampo_Valor_LeadDel TempCampo_Valor_LeadDel ON TempCampo_Valor_Lead.ID = TempCampo_Valor_LeadDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Lead
                            DROP TABLE #TempCampo_Valor_LeadDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Equipe]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Equipe

                            CREATE TABLE #TempCampo_Valor_Equipe
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Equipe (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Equipe] CV INNER JOIN [Campo] C ON CV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_EquipeDel
                            CREATE TABLE #TempCampo_Valor_EquipeDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Equipe))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_EquipeDel

                                INSERT #TempCampo_Valor_EquipeDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Equipe
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_EquipeDel
                                DELETE CV
                                FROM [Campo_Valor_Equipe] CV INNER JOIN #TempCampo_Valor_EquipeDel TempCampo_Valor_EquipeDel ON [CV].ID = TempCampo_Valor_EquipeDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Equipe
                                FROM #TempCampo_Valor_Equipe TempCampo_Valor_Equipe INNER JOIN #TempCampo_Valor_EquipeDel TempCampo_Valor_EquipeDel ON TempCampo_Valor_Equipe.ID = TempCampo_Valor_EquipeDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Equipe
                            DROP TABLE #TempCampo_Valor_EquipeDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Email]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Email

                            CREATE TABLE #TempCampo_Valor_Email
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Email (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Email] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_CLientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_EmailDel
                            CREATE TABLE #TempCampo_Valor_EmailDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Email))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_EmailDel

                                INSERT #TempCampo_Valor_EmailDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Email
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_EmailDel
                                DELETE CV
                                FROM [Campo_Valor_Email] CV INNER JOIN #TempCampo_Valor_EmailDel TempCampo_Valor_EmailDel ON [CV].ID = TempCampo_Valor_EmailDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Email
                                FROM #TempCampo_Valor_Email TempCampo_Valor_Email INNER JOIN #TempCampo_Valor_EmailDel TempCampo_Valor_EmailDel ON TempCampo_Valor_Email.ID = TempCampo_Valor_EmailDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Email
                            DROP TABLE #TempCampo_Valor_EmailDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_DocumentProduct]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_DocumentProduct

                            CREATE TABLE #TempCampo_Valor_DocumentProduct
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_DocumentProduct (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_DocumentProduct] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_DocumentProductDel
                            CREATE TABLE #TempCampo_Valor_DocumentProductDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_DocumentProduct))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_DocumentProductDel

                                INSERT #TempCampo_Valor_DocumentProductDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_DocumentProduct
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_DocumentProductDel
                                DELETE CV
                                FROM [Campo_Valor_DocumentProduct] CV INNER JOIN #TempCampo_Valor_DocumentProductDel TempCampo_Valor_DocumentProductDel ON [CV].ID = TempCampo_Valor_DocumentProductDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_DocumentProduct
                                FROM #TempCampo_Valor_DocumentProduct TempCampo_Valor_DocumentProduct INNER JOIN #TempCampo_Valor_DocumentProductDel TempCampo_Valor_DocumentProductDel ON TempCampo_Valor_DocumentProduct.ID = TempCampo_Valor_DocumentProductDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_DocumentProduct
                            DROP TABLE #TempCampo_Valor_DocumentProductDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Document_Section]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Document_Section

                            CREATE TABLE #TempCampo_Valor_Document_Section
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Document_Section (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Document_Section] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Document_SectionDel
                            CREATE TABLE #TempCampo_Valor_Document_SectionDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Document_Section))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Document_SectionDel

                                INSERT #TempCampo_Valor_Document_SectionDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Document_Section
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Document_SectionDel
                                DELETE CV
                                FROM [Campo_Valor_Document_Section] CV INNER JOIN #TempCampo_Valor_Document_SectionDel TempCampo_Valor_Document_SectionDel ON [CV].ID = TempCampo_Valor_Document_SectionDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Document_Section
                                FROM #TempCampo_Valor_Document_Section TempCampo_Valor_Document_Section INNER JOIN #TempCampo_Valor_Document_SectionDel TempCampo_Valor_Document_SectionDel ON TempCampo_Valor_Document_Section.ID = TempCampo_Valor_Document_SectionDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Document_Section
                            DROP TABLE #TempCampo_Valor_Document_SectionDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Document_Product_Part]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Document_Product_Part

                            CREATE TABLE #TempCampo_Valor_Document_Product_Part
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Document_Product_Part (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Document_Product_Part] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Document_Product_PartDel
                            CREATE TABLE #TempCampo_Valor_Document_Product_PartDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Document_Product_Part))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Document_Product_PartDel

                                INSERT #TempCampo_Valor_Document_Product_PartDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Document_Product_Part
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Document_Product_PartDel
                                DELETE CV
                                FROM [Campo_Valor_Document_Product_Part] CV INNER JOIN #TempCampo_Valor_Document_Product_PartDel TempCampo_Valor_Document_Product_PartDel ON [CV].ID = TempCampo_Valor_Document_Product_PartDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Document_Product_Part
                                FROM #TempCampo_Valor_Document_Product_Part TempCampo_Valor_Document_Product_Part INNER JOIN #TempCampo_Valor_Document_Product_PartDel TempCampo_Valor_Document_Product_PartDel ON TempCampo_Valor_Document_Product_Part.ID = TempCampo_Valor_Document_Product_PartDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Document_Product_Part
                            DROP TABLE #TempCampo_Valor_Document_Product_PartDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Document_Installment]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Document_Installment

                            CREATE TABLE #TempCampo_Valor_Document_Installment
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Document_Installment (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Document_Installment] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Document_InstallmentDel
                            CREATE TABLE #TempCampo_Valor_Document_InstallmentDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Document_Installment))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Document_InstallmentDel

                                INSERT #TempCampo_Valor_Document_InstallmentDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Document_Installment
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Document_InstallmentDel
                                DELETE CV
                                FROM [Campo_Valor_Document_Installment] CV INNER JOIN #TempCampo_Valor_Document_InstallmentDel TempCampo_Valor_Document_InstallmentDel ON [CV].ID = TempCampo_Valor_Document_InstallmentDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Document_Installment
                                FROM #TempCampo_Valor_Document_Installment TempCampo_Valor_Document_Installment INNER JOIN #TempCampo_Valor_Document_InstallmentDel TempCampo_Valor_Document_InstallmentDel ON TempCampo_Valor_Document_Installment.ID = TempCampo_Valor_Document_InstallmentDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Document_Installment
                            DROP TABLE #TempCampo_Valor_Document_InstallmentDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Document]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Document

                            CREATE TABLE #TempCampo_Valor_Document
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Document (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Document] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_DocumentDel
                            CREATE TABLE #TempCampo_Valor_DocumentDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Document))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_DocumentDel

                                INSERT #TempCampo_Valor_DocumentDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Document
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_DocumentDel
                                DELETE CV
                                FROM [Campo_Valor_Document] CV INNER JOIN #TempCampo_Valor_DocumentDel TempCampo_Valor_DocumentDel ON [CV].ID = TempCampo_Valor_DocumentDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Document
                                FROM #TempCampo_Valor_Document TempCampo_Valor_Document INNER JOIN #TempCampo_Valor_DocumentDel TempCampo_Valor_DocumentDel ON TempCampo_Valor_Document.ID = TempCampo_Valor_DocumentDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Document
                            DROP TABLE #TempCampo_Valor_DocumentDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Cotacao]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Cotacao

                            CREATE TABLE #TempCampo_Valor_Cotacao
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Cotacao (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Cotacao] CV INNER JOIN [Campo] C ON CV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_CotacaoDel
                            CREATE TABLE #TempCampo_Valor_CotacaoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Cotacao))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_CotacaoDel

                                INSERT #TempCampo_Valor_CotacaoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Cotacao
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_CotacaoDel
                                DELETE CV
                                FROM [Campo_Valor_Cotacao] CV INNER JOIN #TempCampo_Valor_CotacaoDel TempCampo_Valor_CotacaoDel ON [CV].ID = TempCampo_Valor_CotacaoDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Cotacao
                                FROM #TempCampo_Valor_Cotacao TempCampo_Valor_Cotacao INNER JOIN #TempCampo_Valor_CotacaoDel TempCampo_Valor_CotacaoDel ON TempCampo_Valor_Cotacao.ID = TempCampo_Valor_CotacaoDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Cotacao
                            DROP TABLE #TempCampo_Valor_CotacaoDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_ContactProduct]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_ContactProduct

                            CREATE TABLE #TempCampo_Valor_ContactProduct
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_ContactProduct (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_ContactProduct] CV INNER JOIN [Campo] C ON CV.[FieldId] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_ContactProductDel
                            CREATE TABLE #TempCampo_Valor_ContactProductDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_ContactProduct))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_ContactProductDel

                                INSERT #TempCampo_Valor_ContactProductDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_ContactProduct
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_ContactProductDel
                                DELETE CV
                                FROM [Campo_Valor_ContactProduct] CV INNER JOIN #TempCampo_Valor_ContactProductDel TempCampo_Valor_ContactProductDel ON [CV].ID = TempCampo_Valor_ContactProductDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_ContactProduct
                                FROM #TempCampo_Valor_ContactProduct TempCampo_Valor_ContactProduct INNER JOIN #TempCampo_Valor_ContactProductDel TempCampo_Valor_ContactProductDel ON TempCampo_Valor_ContactProduct.ID = TempCampo_Valor_ContactProductDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_ContactProduct
                            DROP TABLE #TempCampo_Valor_ContactProductDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Cliente]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Cliente

                            CREATE TABLE #TempCampo_Valor_Cliente
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Cliente (Id)
                            SELECT  [CV].Id
                            FROM [Campo_Valor_Cliente] CV INNER JOIN [Campo] C ON CV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_ClienteDel
                            CREATE TABLE #TempCampo_Valor_ClienteDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Cliente))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_ClienteDel

                                INSERT #TempCampo_Valor_ClienteDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Cliente
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_ClienteDel
                                DELETE CV
                                FROM [Campo_Valor_Cliente] CV INNER JOIN #TempCampo_Valor_ClienteDel TempCampo_Valor_ClienteDel ON [CV].ID = TempCampo_Valor_ClienteDel.Id
                                WHERE [CV].ID >= @MinId AND [CV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Cliente
                                FROM #TempCampo_Valor_Cliente TempCampo_Valor_Cliente INNER JOIN #TempCampo_Valor_ClienteDel TempCampo_Valor_ClienteDel ON TempCampo_Valor_Cliente.ID = TempCampo_Valor_ClienteDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Cliente
                            DROP TABLE #TempCampo_Valor_ClienteDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Language]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Language

                            CREATE TABLE #TempCampo_Language
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Language (Id)
                            SELECT  [CL].Id
                            FROM [Campo_Language] CL INNER JOIN [Campo] C ON CL.FieldId = C.ID
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_LanguageDel
                            CREATE TABLE #TempCampo_LanguageDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Language))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_LanguageDel

                                INSERT #TempCampo_LanguageDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Language
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_LanguageDel
                                DELETE CL
                                FROM [Campo_Language] CL INNER JOIN #TempCampo_LanguageDel TempCampo_LanguageDel ON [CL].ID = TempCampo_LanguageDel.Id
                                WHERE [CL].ID >= @MinId AND [CL].ID <= @MaxId
                                        
                                DELETE #TempCampo_Language
                                FROM #TempCampo_Language TempCampo_Language INNER JOIN #TempCampo_LanguageDel TempCampo_LanguageDel ON TempCampo_Language.ID = TempCampo_LanguageDel.Id
                            END
                            DROP TABLE #TempCampo_Language
                            DROP TABLE #TempCampo_LanguageDel
                            GO
PRINT 'Running accountId 1 and table [Campo_ResponsePath]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_ResponsePath

                            CREATE TABLE #TempCampo_ResponsePath
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_ResponsePath (Id)
                            SELECT  [CR].Id
                            FROM [Campo_ResponsePath] CR INNER JOIN [Campo] C ON CR.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_ResponsePathDel
                            CREATE TABLE #TempCampo_ResponsePathDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_ResponsePath))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_ResponsePathDel

                                INSERT #TempCampo_ResponsePathDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_ResponsePath
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_ResponsePathDel
                                DELETE CR
                                FROM [Campo_ResponsePath] CR INNER JOIN #TempCampo_ResponsePathDel TempCampo_ResponsePathDel ON [CR].ID = TempCampo_ResponsePathDel.Id
                                WHERE [CR].ID >= @MinId AND [CR].ID <= @MaxId
                                        
                                DELETE #TempCampo_ResponsePath
                                FROM #TempCampo_ResponsePath TempCampo_ResponsePath INNER JOIN #TempCampo_ResponsePathDel TempCampo_ResponsePathDel ON TempCampo_ResponsePath.ID = TempCampo_ResponsePathDel.Id
                            END
                            DROP TABLE #TempCampo_ResponsePath
                            DROP TABLE #TempCampo_ResponsePathDel
                            GO
PRINT 'Running accountId 1 and table [Campo_GoogleSheets]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_GoogleSheets

                            CREATE TABLE #TempCampo_GoogleSheets
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_GoogleSheets (Id)
                            SELECT  [CG].Id
                            FROM [Campo_GoogleSheets] CG INNER JOIN [Campo] C ON CG.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_GoogleSheetsDel
                            CREATE TABLE #TempCampo_GoogleSheetsDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_GoogleSheets))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_GoogleSheetsDel

                                INSERT #TempCampo_GoogleSheetsDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_GoogleSheets
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_GoogleSheetsDel
                                DELETE CG
                                FROM [Campo_GoogleSheets] CG INNER JOIN #TempCampo_GoogleSheetsDel TempCampo_GoogleSheetsDel ON [CG].ID = TempCampo_GoogleSheetsDel.Id
                                WHERE [CG].ID >= @MinId AND [CG].ID <= @MaxId
                                        
                                DELETE #TempCampo_GoogleSheets
                                FROM #TempCampo_GoogleSheets TempCampo_GoogleSheets INNER JOIN #TempCampo_GoogleSheetsDel TempCampo_GoogleSheetsDel ON TempCampo_GoogleSheets.ID = TempCampo_GoogleSheetsDel.Id
                            END
                            DROP TABLE #TempCampo_GoogleSheets
                            DROP TABLE #TempCampo_GoogleSheetsDel
                            GO
PRINT 'Running accountId 1 and table [Campo_FormulaExterna_Variavel]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_FormulaExterna_Variavel

                            CREATE TABLE #TempCampo_FormulaExterna_Variavel
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_FormulaExterna_Variavel (Id)
                            SELECT  [CFV].Id
                            FROM [Campo_FormulaExterna_Variavel] CFV INNER JOIN [Campo] C ON CFV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_FormulaExterna_VariavelDel
                            CREATE TABLE #TempCampo_FormulaExterna_VariavelDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_FormulaExterna_Variavel))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_FormulaExterna_VariavelDel

                                INSERT #TempCampo_FormulaExterna_VariavelDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_FormulaExterna_Variavel
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_FormulaExterna_VariavelDel
                                DELETE CFV
                                FROM [Campo_FormulaExterna_Variavel] CFV INNER JOIN #TempCampo_FormulaExterna_VariavelDel TempCampo_FormulaExterna_VariavelDel ON [CFV].ID = TempCampo_FormulaExterna_VariavelDel.Id
                                WHERE [CFV].ID >= @MinId AND [CFV].ID <= @MaxId
                                        
                                DELETE #TempCampo_FormulaExterna_Variavel
                                FROM #TempCampo_FormulaExterna_Variavel TempCampo_FormulaExterna_Variavel INNER JOIN #TempCampo_FormulaExterna_VariavelDel TempCampo_FormulaExterna_VariavelDel ON TempCampo_FormulaExterna_Variavel.ID = TempCampo_FormulaExterna_VariavelDel.Id
                            END
                            DROP TABLE #TempCampo_FormulaExterna_Variavel
                            DROP TABLE #TempCampo_FormulaExterna_VariavelDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Formula_Variavel]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Formula_Variavel

                            CREATE TABLE #TempCampo_Formula_Variavel
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Formula_Variavel (Id)
                            SELECT  [CFV].Id
                            FROM [Campo_Formula_Variavel] CFV INNER JOIN [Campo] C ON CFV.[ID_Campo] = C.[ID]
                            WHERE [C].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Formula_VariavelDel
                            CREATE TABLE #TempCampo_Formula_VariavelDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Formula_Variavel))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Formula_VariavelDel

                                INSERT #TempCampo_Formula_VariavelDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Formula_Variavel
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Formula_VariavelDel
                                DELETE CFV
                                FROM [Campo_Formula_Variavel] CFV INNER JOIN #TempCampo_Formula_VariavelDel TempCampo_Formula_VariavelDel ON [CFV].ID = TempCampo_Formula_VariavelDel.Id
                                WHERE [CFV].ID >= @MinId AND [CFV].ID <= @MaxId
                                        
                                DELETE #TempCampo_Formula_Variavel
                                FROM #TempCampo_Formula_Variavel TempCampo_Formula_Variavel INNER JOIN #TempCampo_Formula_VariavelDel TempCampo_Formula_VariavelDel ON TempCampo_Formula_Variavel.ID = TempCampo_Formula_VariavelDel.Id
                            END
                            DROP TABLE #TempCampo_Formula_Variavel
                            DROP TABLE #TempCampo_Formula_VariavelDel
                            GO
PRINT 'Running accountId 1 and table [Campo]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo

                            CREATE TABLE #TempCampo
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo (Id)
                            SELECT  [Campo].Id
                            FROM [Campo] Campo
                            WHERE [Campo].[ID_ClientePloomes] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampoDel
                            CREATE TABLE #TempCampoDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo))
                            BEGIN
                                TRUNCATE TABLE #TempCampoDel

                                INSERT #TempCampoDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampoDel
                                DELETE Campo
                                FROM [Campo] Campo INNER JOIN #TempCampoDel TempCampoDel ON [Campo].ID = TempCampoDel.Id
                                WHERE [Campo].ID >= @MinId AND [Campo].ID <= @MaxId
                                        
                                DELETE #TempCampo
                                FROM #TempCampo TempCampo INNER JOIN #TempCampoDel TempCampoDel ON TempCampo.ID = TempCampoDel.Id
                            END
                            DROP TABLE #TempCampo
                            DROP TABLE #TempCampoDel
                            GO
PRINT 'Running accountId 1 and table [BulkProcedure_Action_Language_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempBulkProcedure_Action_Language_Account

                            CREATE TABLE #TempBulkProcedure_Action_Language_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempBulkProcedure_Action_Language_Account (Id)
                            SELECT  [BulkProcedure_Action_Language_Account].Id
                            FROM [BulkProcedure_Action_Language_Account] BulkProcedure_Action_Language_Account
                            WHERE [BulkProcedure_Action_Language_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempBulkProcedure_Action_Language_AccountDel
                            CREATE TABLE #TempBulkProcedure_Action_Language_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempBulkProcedure_Action_Language_Account))
                            BEGIN
                                TRUNCATE TABLE #TempBulkProcedure_Action_Language_AccountDel

                                INSERT #TempBulkProcedure_Action_Language_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempBulkProcedure_Action_Language_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempBulkProcedure_Action_Language_AccountDel
                                DELETE BulkProcedure_Action_Language_Account
                                FROM [BulkProcedure_Action_Language_Account] BulkProcedure_Action_Language_Account INNER JOIN #TempBulkProcedure_Action_Language_AccountDel TempBulkProcedure_Action_Language_AccountDel ON [BulkProcedure_Action_Language_Account].ID = TempBulkProcedure_Action_Language_AccountDel.Id
                                WHERE [BulkProcedure_Action_Language_Account].ID >= @MinId AND [BulkProcedure_Action_Language_Account].ID <= @MaxId
                                        
                                DELETE #TempBulkProcedure_Action_Language_Account
                                FROM #TempBulkProcedure_Action_Language_Account TempBulkProcedure_Action_Language_Account INNER JOIN #TempBulkProcedure_Action_Language_AccountDel TempBulkProcedure_Action_Language_AccountDel ON TempBulkProcedure_Action_Language_Account.ID = TempBulkProcedure_Action_Language_AccountDel.Id
                            END
                            DROP TABLE #TempBulkProcedure_Action_Language_Account
                            DROP TABLE #TempBulkProcedure_Action_Language_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Automation_Trigger_Language_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAutomation_Trigger_Language_Account

                            CREATE TABLE #TempAutomation_Trigger_Language_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAutomation_Trigger_Language_Account (Id)
                            SELECT  [Automation_Trigger_Language_Account].Id
                            FROM [Automation_Trigger_Language_Account] Automation_Trigger_Language_Account
                            WHERE [Automation_Trigger_Language_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAutomation_Trigger_Language_AccountDel
                            CREATE TABLE #TempAutomation_Trigger_Language_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAutomation_Trigger_Language_Account))
                            BEGIN
                                TRUNCATE TABLE #TempAutomation_Trigger_Language_AccountDel

                                INSERT #TempAutomation_Trigger_Language_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAutomation_Trigger_Language_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAutomation_Trigger_Language_AccountDel
                                DELETE Automation_Trigger_Language_Account
                                FROM [Automation_Trigger_Language_Account] Automation_Trigger_Language_Account INNER JOIN #TempAutomation_Trigger_Language_AccountDel TempAutomation_Trigger_Language_AccountDel ON [Automation_Trigger_Language_Account].ID = TempAutomation_Trigger_Language_AccountDel.Id
                                WHERE [Automation_Trigger_Language_Account].ID >= @MinId AND [Automation_Trigger_Language_Account].ID <= @MaxId
                                        
                                DELETE #TempAutomation_Trigger_Language_Account
                                FROM #TempAutomation_Trigger_Language_Account TempAutomation_Trigger_Language_Account INNER JOIN #TempAutomation_Trigger_Language_AccountDel TempAutomation_Trigger_Language_AccountDel ON TempAutomation_Trigger_Language_Account.ID = TempAutomation_Trigger_Language_AccountDel.Id
                            END
                            DROP TABLE #TempAutomation_Trigger_Language_Account
                            DROP TABLE #TempAutomation_Trigger_Language_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Automation_Log]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAutomation_Log

                            CREATE TABLE #TempAutomation_Log
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAutomation_Log (Id)
                            SELECT  [Automation_Log].Id
                            FROM [Automation_Log] Automation_Log
                            WHERE [Automation_Log].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAutomation_LogDel
                            CREATE TABLE #TempAutomation_LogDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAutomation_Log))
                            BEGIN
                                TRUNCATE TABLE #TempAutomation_LogDel

                                INSERT #TempAutomation_LogDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAutomation_Log
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAutomation_LogDel
                                DELETE Automation_Log
                                FROM [Automation_Log] Automation_Log INNER JOIN #TempAutomation_LogDel TempAutomation_LogDel ON [Automation_Log].ID = TempAutomation_LogDel.Id
                                WHERE [Automation_Log].ID >= @MinId AND [Automation_Log].ID <= @MaxId
                                        
                                DELETE #TempAutomation_Log
                                FROM #TempAutomation_Log TempAutomation_Log INNER JOIN #TempAutomation_LogDel TempAutomation_LogDel ON TempAutomation_Log.ID = TempAutomation_LogDel.Id
                            END
                            DROP TABLE #TempAutomation_Log
                            DROP TABLE #TempAutomation_LogDel
                            GO
PRINT 'Running accountId 1 and table [Automation_Action_Action_Language_Account]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAutomation_Action_Action_Language_Account

                            CREATE TABLE #TempAutomation_Action_Action_Language_Account
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAutomation_Action_Action_Language_Account (Id)
                            SELECT  [Automation_Action_Action_Language_Account].Id
                            FROM [Automation_Action_Action_Language_Account] Automation_Action_Action_Language_Account
                            WHERE [Automation_Action_Action_Language_Account].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAutomation_Action_Action_Language_AccountDel
                            CREATE TABLE #TempAutomation_Action_Action_Language_AccountDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAutomation_Action_Action_Language_Account))
                            BEGIN
                                TRUNCATE TABLE #TempAutomation_Action_Action_Language_AccountDel

                                INSERT #TempAutomation_Action_Action_Language_AccountDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAutomation_Action_Action_Language_Account
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAutomation_Action_Action_Language_AccountDel
                                DELETE Automation_Action_Action_Language_Account
                                FROM [Automation_Action_Action_Language_Account] Automation_Action_Action_Language_Account INNER JOIN #TempAutomation_Action_Action_Language_AccountDel TempAutomation_Action_Action_Language_AccountDel ON [Automation_Action_Action_Language_Account].ID = TempAutomation_Action_Action_Language_AccountDel.Id
                                WHERE [Automation_Action_Action_Language_Account].ID >= @MinId AND [Automation_Action_Action_Language_Account].ID <= @MaxId
                                        
                                DELETE #TempAutomation_Action_Action_Language_Account
                                FROM #TempAutomation_Action_Action_Language_Account TempAutomation_Action_Action_Language_Account INNER JOIN #TempAutomation_Action_Action_Language_AccountDel TempAutomation_Action_Action_Language_AccountDel ON TempAutomation_Action_Action_Language_Account.ID = TempAutomation_Action_Action_Language_AccountDel.Id
                            END
                            DROP TABLE #TempAutomation_Action_Action_Language_Account
                            DROP TABLE #TempAutomation_Action_Action_Language_AccountDel
                            GO
PRINT 'Running accountId 1 and table [Automation_Action_Field_FormulaVariable]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAutomation_Action_Field_FormulaVariable

                            CREATE TABLE #TempAutomation_Action_Field_FormulaVariable
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAutomation_Action_Field_FormulaVariable (Id)
                            SELECT  [AAFF].Id
                            FROM [Automation_Action_Field_FormulaVariable] AAFF INNER JOIN [Automation_Action_Field] AAF ON AAFF.[AutomationActionFieldId] = AAF.[Id] INNER JOIN [Automation_Action] AA ON AAF.[AutomationActionId] = AA.[Id] INNER JOIN [Automation] A ON AA.[AutomationId] = A.[Id]
                            WHERE [A].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAutomation_Action_Field_FormulaVariableDel
                            CREATE TABLE #TempAutomation_Action_Field_FormulaVariableDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAutomation_Action_Field_FormulaVariable))
                            BEGIN
                                TRUNCATE TABLE #TempAutomation_Action_Field_FormulaVariableDel

                                INSERT #TempAutomation_Action_Field_FormulaVariableDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAutomation_Action_Field_FormulaVariable
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAutomation_Action_Field_FormulaVariableDel
                                DELETE AAFF
                                FROM [Automation_Action_Field_FormulaVariable] AAFF INNER JOIN #TempAutomation_Action_Field_FormulaVariableDel TempAutomation_Action_Field_FormulaVariableDel ON [AAFF].ID = TempAutomation_Action_Field_FormulaVariableDel.Id
                                WHERE [AAFF].ID >= @MinId AND [AAFF].ID <= @MaxId
                                        
                                DELETE #TempAutomation_Action_Field_FormulaVariable
                                FROM #TempAutomation_Action_Field_FormulaVariable TempAutomation_Action_Field_FormulaVariable INNER JOIN #TempAutomation_Action_Field_FormulaVariableDel TempAutomation_Action_Field_FormulaVariableDel ON TempAutomation_Action_Field_FormulaVariable.ID = TempAutomation_Action_Field_FormulaVariableDel.Id
                            END
                            DROP TABLE #TempAutomation_Action_Field_FormulaVariable
                            DROP TABLE #TempAutomation_Action_Field_FormulaVariableDel
                            GO
PRINT 'Running accountId 1 and table [Automation_Email_Attachment]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAutomation_Email_Attachment

                            CREATE TABLE #TempAutomation_Email_Attachment
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAutomation_Email_Attachment (Id)
                            SELECT  [AEA].Id
                            FROM [Automation_Email_Attachment] AEA INNER JOIN [Automation_Email] AE ON AEA.[AutomationEmailId] = AE.[Id] INNER JOIN [Automation] A ON AE.[AutomationId] = A.[Id]
                            WHERE [A].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAutomation_Email_AttachmentDel
                            CREATE TABLE #TempAutomation_Email_AttachmentDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAutomation_Email_Attachment))
                            BEGIN
                                TRUNCATE TABLE #TempAutomation_Email_AttachmentDel

                                INSERT #TempAutomation_Email_AttachmentDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAutomation_Email_Attachment
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAutomation_Email_AttachmentDel
                                DELETE AEA
                                FROM [Automation_Email_Attachment] AEA INNER JOIN #TempAutomation_Email_AttachmentDel TempAutomation_Email_AttachmentDel ON [AEA].ID = TempAutomation_Email_AttachmentDel.Id
                                WHERE [AEA].ID >= @MinId AND [AEA].ID <= @MaxId
                                        
                                DELETE #TempAutomation_Email_Attachment
                                FROM #TempAutomation_Email_Attachment TempAutomation_Email_Attachment INNER JOIN #TempAutomation_Email_AttachmentDel TempAutomation_Email_AttachmentDel ON TempAutomation_Email_Attachment.ID = TempAutomation_Email_AttachmentDel.Id
                            END
                            DROP TABLE #TempAutomation_Email_Attachment
                            DROP TABLE #TempAutomation_Email_AttachmentDel
                            GO
PRINT 'Running accountId 1 and table [Automation_Action_Value]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAutomation_Action_Value

                            CREATE TABLE #TempAutomation_Action_Value
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAutomation_Action_Value (Id)
                            SELECT  [AAV].Id
                            FROM [Automation_Action_Value] AAV INNER JOIN [Automation_Action] AA ON AAV.[AutomationActionId] = AA.Id INNER JOIN [Automation] A ON AA.[AutomationId] = A.[Id]
                            WHERE [A].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAutomation_Action_ValueDel
                            CREATE TABLE #TempAutomation_Action_ValueDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAutomation_Action_Value))
                            BEGIN
                                TRUNCATE TABLE #TempAutomation_Action_ValueDel

                                INSERT #TempAutomation_Action_ValueDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAutomation_Action_Value
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAutomation_Action_ValueDel
                                DELETE AAV
                                FROM [Automation_Action_Value] AAV INNER JOIN #TempAutomation_Action_ValueDel TempAutomation_Action_ValueDel ON [AAV].ID = TempAutomation_Action_ValueDel.Id
                                WHERE [AAV].ID >= @MinId AND [AAV].ID <= @MaxId
                                        
                                DELETE #TempAutomation_Action_Value
                                FROM #TempAutomation_Action_Value TempAutomation_Action_Value INNER JOIN #TempAutomation_Action_ValueDel TempAutomation_Action_ValueDel ON TempAutomation_Action_Value.ID = TempAutomation_Action_ValueDel.Id
                            END
                            DROP TABLE #TempAutomation_Action_Value
                            DROP TABLE #TempAutomation_Action_ValueDel
                            GO
PRINT 'Running accountId 1 and table [Automation_Action_Field]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAutomation_Action_Field

                            CREATE TABLE #TempAutomation_Action_Field
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAutomation_Action_Field (Id)
                            SELECT  [AAF].Id
                            FROM [Automation_Action_Field] AAF INNER JOIN [Automation_Action] AA ON AAF.[AutomationActionId] = AA.[Id] INNER JOIN [Automation] A ON AA.[AutomationId] = A.[Id]
                            WHERE [A].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAutomation_Action_FieldDel
                            CREATE TABLE #TempAutomation_Action_FieldDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAutomation_Action_Field))
                            BEGIN
                                TRUNCATE TABLE #TempAutomation_Action_FieldDel

                                INSERT #TempAutomation_Action_FieldDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAutomation_Action_Field
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAutomation_Action_FieldDel
                                DELETE AAF
                                FROM [Automation_Action_Field] AAF INNER JOIN #TempAutomation_Action_FieldDel TempAutomation_Action_FieldDel ON [AAF].ID = TempAutomation_Action_FieldDel.Id
                                WHERE [AAF].ID >= @MinId AND [AAF].ID <= @MaxId
                                        
                                DELETE #TempAutomation_Action_Field
                                FROM #TempAutomation_Action_Field TempAutomation_Action_Field INNER JOIN #TempAutomation_Action_FieldDel TempAutomation_Action_FieldDel ON TempAutomation_Action_Field.ID = TempAutomation_Action_FieldDel.Id
                            END
                            DROP TABLE #TempAutomation_Action_Field
                            DROP TABLE #TempAutomation_Action_FieldDel
                            GO
PRINT 'Running accountId 1 and table [Automation_Email]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAutomation_Email

                            CREATE TABLE #TempAutomation_Email
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAutomation_Email (Id)
                            SELECT  [AE].Id
                            FROM [Automation_Email] AE INNER JOIN [Automation] A ON AE.[AutomationId] = A.[Id]
                            WHERE [A].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAutomation_EmailDel
                            CREATE TABLE #TempAutomation_EmailDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAutomation_Email))
                            BEGIN
                                TRUNCATE TABLE #TempAutomation_EmailDel

                                INSERT #TempAutomation_EmailDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAutomation_Email
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAutomation_EmailDel
                                DELETE AE
                                FROM [Automation_Email] AE INNER JOIN #TempAutomation_EmailDel TempAutomation_EmailDel ON [AE].ID = TempAutomation_EmailDel.Id
                                WHERE [AE].ID >= @MinId AND [AE].ID <= @MaxId
                                        
                                DELETE #TempAutomation_Email
                                FROM #TempAutomation_Email TempAutomation_Email INNER JOIN #TempAutomation_EmailDel TempAutomation_EmailDel ON TempAutomation_Email.ID = TempAutomation_EmailDel.Id
                            END
                            DROP TABLE #TempAutomation_Email
                            DROP TABLE #TempAutomation_EmailDel
                            GO
PRINT 'Running accountId 1 and table [Automation_Action]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAutomation_Action

                            CREATE TABLE #TempAutomation_Action
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAutomation_Action (Id)
                            SELECT  [AA].Id
                            FROM [Automation_Action] AA INNER JOIN [Automation] A ON AA.[AutomationId] = A.[Id]
                            WHERE [A].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAutomation_ActionDel
                            CREATE TABLE #TempAutomation_ActionDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAutomation_Action))
                            BEGIN
                                TRUNCATE TABLE #TempAutomation_ActionDel

                                INSERT #TempAutomation_ActionDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAutomation_Action
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAutomation_ActionDel
                                DELETE AA
                                FROM [Automation_Action] AA INNER JOIN #TempAutomation_ActionDel TempAutomation_ActionDel ON [AA].ID = TempAutomation_ActionDel.Id
                                WHERE [AA].ID >= @MinId AND [AA].ID <= @MaxId
                                        
                                DELETE #TempAutomation_Action
                                FROM #TempAutomation_Action TempAutomation_Action INNER JOIN #TempAutomation_ActionDel TempAutomation_ActionDel ON TempAutomation_Action.ID = TempAutomation_ActionDel.Id
                            END
                            DROP TABLE #TempAutomation_Action
                            DROP TABLE #TempAutomation_ActionDel
                            GO
PRINT 'Running accountId 1 and table [Automation]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAutomation

                            CREATE TABLE #TempAutomation
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAutomation (Id)
                            SELECT  [Automation].Id
                            FROM [Automation] Automation
                            WHERE [Automation].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAutomationDel
                            CREATE TABLE #TempAutomationDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAutomation))
                            BEGIN
                                TRUNCATE TABLE #TempAutomationDel

                                INSERT #TempAutomationDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAutomation
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAutomationDel
                                DELETE Automation
                                FROM [Automation] Automation INNER JOIN #TempAutomationDel TempAutomationDel ON [Automation].ID = TempAutomationDel.Id
                                WHERE [Automation].ID >= @MinId AND [Automation].ID <= @MaxId
                                        
                                DELETE #TempAutomation
                                FROM #TempAutomation TempAutomation INNER JOIN #TempAutomationDel TempAutomationDel ON TempAutomation.ID = TempAutomationDel.Id
                            END
                            DROP TABLE #TempAutomation
                            DROP TABLE #TempAutomationDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Item_Item]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Item_Item

                            CREATE TABLE #TempAnexo_Item_Item
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Item_Item (Id)
                            SELECT  [AII].Id
                            FROM [Anexo_Item_Item] AII INNER JOIN [Anexo_Item] AI ON AII.[BaseItemId] = AI.[Id] INNER JOIN [Anexo_Folder] AF ON AI.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Item_ItemDel
                            CREATE TABLE #TempAnexo_Item_ItemDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Item_Item))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Item_ItemDel

                                INSERT #TempAnexo_Item_ItemDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Item_Item
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Item_ItemDel
                                DELETE AII
                                FROM [Anexo_Item_Item] AII INNER JOIN #TempAnexo_Item_ItemDel TempAnexo_Item_ItemDel ON [AII].ID = TempAnexo_Item_ItemDel.Id
                                WHERE [AII].ID >= @MinId AND [AII].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Item_Item
                                FROM #TempAnexo_Item_Item TempAnexo_Item_Item INNER JOIN #TempAnexo_Item_ItemDel TempAnexo_Item_ItemDel ON TempAnexo_Item_Item.ID = TempAnexo_Item_ItemDel.Id
                            END
                            DROP TABLE #TempAnexo_Item_Item
                            DROP TABLE #TempAnexo_Item_ItemDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Item_Relation]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Item_Relation

                            CREATE TABLE #TempAnexo_Item_Relation
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Item_Relation (Id)
                            SELECT  [AIR].Id
                            FROM [Anexo_Item_Relation] AIR INNER JOIN [Anexo_Item] AI ON AIR.[AttachmentItemId] = AI.[Id] INNER JOIN [Anexo_Folder] AF ON AI.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Item_RelationDel
                            CREATE TABLE #TempAnexo_Item_RelationDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Item_Relation))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Item_RelationDel

                                INSERT #TempAnexo_Item_RelationDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Item_Relation
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Item_RelationDel
                                DELETE AIR
                                FROM [Anexo_Item_Relation] AIR INNER JOIN #TempAnexo_Item_RelationDel TempAnexo_Item_RelationDel ON [AIR].ID = TempAnexo_Item_RelationDel.Id
                                WHERE [AIR].ID >= @MinId AND [AIR].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Item_Relation
                                FROM #TempAnexo_Item_Relation TempAnexo_Item_Relation INNER JOIN #TempAnexo_Item_RelationDel TempAnexo_Item_RelationDel ON TempAnexo_Item_Relation.ID = TempAnexo_Item_RelationDel.Id
                            END
                            DROP TABLE #TempAnexo_Item_Relation
                            DROP TABLE #TempAnexo_Item_RelationDel
                            GO
PRINT 'Running accountId 1 and table [Campo_Valor_Anexo_Folder]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempCampo_Valor_Anexo_Folder

                            CREATE TABLE #TempCampo_Valor_Anexo_Folder
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempCampo_Valor_Anexo_Folder (Id)
                            SELECT  [CVAF].Id
                            FROM [Campo_Valor_Anexo_Folder] CVAF INNER JOIN [Anexo_Folder] AF ON CVAF.[AttachmentFolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempCampo_Valor_Anexo_FolderDel
                            CREATE TABLE #TempCampo_Valor_Anexo_FolderDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempCampo_Valor_Anexo_Folder))
                            BEGIN
                                TRUNCATE TABLE #TempCampo_Valor_Anexo_FolderDel

                                INSERT #TempCampo_Valor_Anexo_FolderDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempCampo_Valor_Anexo_Folder
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempCampo_Valor_Anexo_FolderDel
                                DELETE CVAF
                                FROM [Campo_Valor_Anexo_Folder] CVAF INNER JOIN #TempCampo_Valor_Anexo_FolderDel TempCampo_Valor_Anexo_FolderDel ON [CVAF].ID = TempCampo_Valor_Anexo_FolderDel.Id
                                WHERE [CVAF].ID >= @MinId AND [CVAF].ID <= @MaxId
                                        
                                DELETE #TempCampo_Valor_Anexo_Folder
                                FROM #TempCampo_Valor_Anexo_Folder TempCampo_Valor_Anexo_Folder INNER JOIN #TempCampo_Valor_Anexo_FolderDel TempCampo_Valor_Anexo_FolderDel ON TempCampo_Valor_Anexo_Folder.ID = TempCampo_Valor_Anexo_FolderDel.Id
                            END
                            DROP TABLE #TempCampo_Valor_Anexo_Folder
                            DROP TABLE #TempCampo_Valor_Anexo_FolderDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Item]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Item

                            CREATE TABLE #TempAnexo_Item
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Item (Id)
                            SELECT  [AI].Id
                            FROM [Anexo_Item] AI INNER JOIN [Anexo_Folder] AF ON AI.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_ItemDel
                            CREATE TABLE #TempAnexo_ItemDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Item))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_ItemDel

                                INSERT #TempAnexo_ItemDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Item
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_ItemDel
                                DELETE AI
                                FROM [Anexo_Item] AI INNER JOIN #TempAnexo_ItemDel TempAnexo_ItemDel ON [AI].ID = TempAnexo_ItemDel.Id
                                WHERE [AI].ID >= @MinId AND [AI].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Item
                                FROM #TempAnexo_Item TempAnexo_Item INNER JOIN #TempAnexo_ItemDel TempAnexo_ItemDel ON TempAnexo_Item.ID = TempAnexo_ItemDel.Id
                            END
                            DROP TABLE #TempAnexo_Item
                            DROP TABLE #TempAnexo_ItemDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder_Edition_AllowedUserProfile]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder_Edition_AllowedUserProfile

                            CREATE TABLE #TempAnexo_Folder_Edition_AllowedUserProfile
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder_Edition_AllowedUserProfile (Id)
                            SELECT  [AFA].Id
                            FROM [Anexo_Folder_Edition_AllowedUserProfile] AFA INNER JOIN [Anexo_Folder] AF ON AFA.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Folder_Edition_AllowedUserProfileDel
                            CREATE TABLE #TempAnexo_Folder_Edition_AllowedUserProfileDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder_Edition_AllowedUserProfile))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Folder_Edition_AllowedUserProfileDel

                                INSERT #TempAnexo_Folder_Edition_AllowedUserProfileDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder_Edition_AllowedUserProfile
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Folder_Edition_AllowedUserProfileDel
                                DELETE AFA
                                FROM [Anexo_Folder_Edition_AllowedUserProfile] AFA INNER JOIN #TempAnexo_Folder_Edition_AllowedUserProfileDel TempAnexo_Folder_Edition_AllowedUserProfileDel ON [AFA].ID = TempAnexo_Folder_Edition_AllowedUserProfileDel.Id
                                WHERE [AFA].ID >= @MinId AND [AFA].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder_Edition_AllowedUserProfile
                                FROM #TempAnexo_Folder_Edition_AllowedUserProfile TempAnexo_Folder_Edition_AllowedUserProfile INNER JOIN #TempAnexo_Folder_Edition_AllowedUserProfileDel TempAnexo_Folder_Edition_AllowedUserProfileDel ON TempAnexo_Folder_Edition_AllowedUserProfile.ID = TempAnexo_Folder_Edition_AllowedUserProfileDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder_Edition_AllowedUserProfile
                            DROP TABLE #TempAnexo_Folder_Edition_AllowedUserProfileDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder_Edition_AllowedUser]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder_Edition_AllowedUser

                            CREATE TABLE #TempAnexo_Folder_Edition_AllowedUser
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder_Edition_AllowedUser (Id)
                            SELECT  [AFA].Id
                            FROM [Anexo_Folder_Edition_AllowedUser] AFA INNER JOIN [Anexo_Folder] AF ON AFA.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Folder_Edition_AllowedUserDel
                            CREATE TABLE #TempAnexo_Folder_Edition_AllowedUserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder_Edition_AllowedUser))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Folder_Edition_AllowedUserDel

                                INSERT #TempAnexo_Folder_Edition_AllowedUserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder_Edition_AllowedUser
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Folder_Edition_AllowedUserDel
                                DELETE AFA
                                FROM [Anexo_Folder_Edition_AllowedUser] AFA INNER JOIN #TempAnexo_Folder_Edition_AllowedUserDel TempAnexo_Folder_Edition_AllowedUserDel ON [AFA].ID = TempAnexo_Folder_Edition_AllowedUserDel.Id
                                WHERE [AFA].ID >= @MinId AND [AFA].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder_Edition_AllowedUser
                                FROM #TempAnexo_Folder_Edition_AllowedUser TempAnexo_Folder_Edition_AllowedUser INNER JOIN #TempAnexo_Folder_Edition_AllowedUserDel TempAnexo_Folder_Edition_AllowedUserDel ON TempAnexo_Folder_Edition_AllowedUser.ID = TempAnexo_Folder_Edition_AllowedUserDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder_Edition_AllowedUser
                            DROP TABLE #TempAnexo_Folder_Edition_AllowedUserDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder_Edition_AllowedTeam]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder_Edition_AllowedTeam

                            CREATE TABLE #TempAnexo_Folder_Edition_AllowedTeam
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder_Edition_AllowedTeam (Id)
                            SELECT  [AFA].Id
                            FROM [Anexo_Folder_Edition_AllowedTeam] AFA INNER JOIN [Anexo_Folder] AF ON AFA.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Folder_Edition_AllowedTeamDel
                            CREATE TABLE #TempAnexo_Folder_Edition_AllowedTeamDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder_Edition_AllowedTeam))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Folder_Edition_AllowedTeamDel

                                INSERT #TempAnexo_Folder_Edition_AllowedTeamDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder_Edition_AllowedTeam
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Folder_Edition_AllowedTeamDel
                                DELETE AFA
                                FROM [Anexo_Folder_Edition_AllowedTeam] AFA INNER JOIN #TempAnexo_Folder_Edition_AllowedTeamDel TempAnexo_Folder_Edition_AllowedTeamDel ON [AFA].ID = TempAnexo_Folder_Edition_AllowedTeamDel.Id
                                WHERE [AFA].ID >= @MinId AND [AFA].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder_Edition_AllowedTeam
                                FROM #TempAnexo_Folder_Edition_AllowedTeam TempAnexo_Folder_Edition_AllowedTeam INNER JOIN #TempAnexo_Folder_Edition_AllowedTeamDel TempAnexo_Folder_Edition_AllowedTeamDel ON TempAnexo_Folder_Edition_AllowedTeam.ID = TempAnexo_Folder_Edition_AllowedTeamDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder_Edition_AllowedTeam
                            DROP TABLE #TempAnexo_Folder_Edition_AllowedTeamDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder_Deletion_AllowedUserProfile]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder_Deletion_AllowedUserProfile

                            CREATE TABLE #TempAnexo_Folder_Deletion_AllowedUserProfile
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder_Deletion_AllowedUserProfile (Id)
                            SELECT  [AFA].Id
                            FROM [Anexo_Folder_Deletion_AllowedUserProfile] AFA INNER JOIN [Anexo_Folder] AF ON AFA.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Folder_Deletion_AllowedUserProfileDel
                            CREATE TABLE #TempAnexo_Folder_Deletion_AllowedUserProfileDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder_Deletion_AllowedUserProfile))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Folder_Deletion_AllowedUserProfileDel

                                INSERT #TempAnexo_Folder_Deletion_AllowedUserProfileDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder_Deletion_AllowedUserProfile
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Folder_Deletion_AllowedUserProfileDel
                                DELETE AFA
                                FROM [Anexo_Folder_Deletion_AllowedUserProfile] AFA INNER JOIN #TempAnexo_Folder_Deletion_AllowedUserProfileDel TempAnexo_Folder_Deletion_AllowedUserProfileDel ON [AFA].ID = TempAnexo_Folder_Deletion_AllowedUserProfileDel.Id
                                WHERE [AFA].ID >= @MinId AND [AFA].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder_Deletion_AllowedUserProfile
                                FROM #TempAnexo_Folder_Deletion_AllowedUserProfile TempAnexo_Folder_Deletion_AllowedUserProfile INNER JOIN #TempAnexo_Folder_Deletion_AllowedUserProfileDel TempAnexo_Folder_Deletion_AllowedUserProfileDel ON TempAnexo_Folder_Deletion_AllowedUserProfile.ID = TempAnexo_Folder_Deletion_AllowedUserProfileDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder_Deletion_AllowedUserProfile
                            DROP TABLE #TempAnexo_Folder_Deletion_AllowedUserProfileDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder_Deletion_AllowedUser]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder_Deletion_AllowedUser

                            CREATE TABLE #TempAnexo_Folder_Deletion_AllowedUser
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder_Deletion_AllowedUser (Id)
                            SELECT  [AFA].Id
                            FROM [Anexo_Folder_Deletion_AllowedUser] AFA INNER JOIN [Anexo_Folder] AF ON AFA.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Folder_Deletion_AllowedUserDel
                            CREATE TABLE #TempAnexo_Folder_Deletion_AllowedUserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder_Deletion_AllowedUser))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Folder_Deletion_AllowedUserDel

                                INSERT #TempAnexo_Folder_Deletion_AllowedUserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder_Deletion_AllowedUser
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Folder_Deletion_AllowedUserDel
                                DELETE AFA
                                FROM [Anexo_Folder_Deletion_AllowedUser] AFA INNER JOIN #TempAnexo_Folder_Deletion_AllowedUserDel TempAnexo_Folder_Deletion_AllowedUserDel ON [AFA].ID = TempAnexo_Folder_Deletion_AllowedUserDel.Id
                                WHERE [AFA].ID >= @MinId AND [AFA].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder_Deletion_AllowedUser
                                FROM #TempAnexo_Folder_Deletion_AllowedUser TempAnexo_Folder_Deletion_AllowedUser INNER JOIN #TempAnexo_Folder_Deletion_AllowedUserDel TempAnexo_Folder_Deletion_AllowedUserDel ON TempAnexo_Folder_Deletion_AllowedUser.ID = TempAnexo_Folder_Deletion_AllowedUserDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder_Deletion_AllowedUser
                            DROP TABLE #TempAnexo_Folder_Deletion_AllowedUserDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder_Deletion_AllowedTeam]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder_Deletion_AllowedTeam

                            CREATE TABLE #TempAnexo_Folder_Deletion_AllowedTeam
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder_Deletion_AllowedTeam (Id)
                            SELECT  [AFA].Id
                            FROM [Anexo_Folder_Deletion_AllowedTeam] AFA INNER JOIN [Anexo_Folder] AF ON AFA.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Folder_Deletion_AllowedTeamDel
                            CREATE TABLE #TempAnexo_Folder_Deletion_AllowedTeamDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder_Deletion_AllowedTeam))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Folder_Deletion_AllowedTeamDel

                                INSERT #TempAnexo_Folder_Deletion_AllowedTeamDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder_Deletion_AllowedTeam
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Folder_Deletion_AllowedTeamDel
                                DELETE AFA
                                FROM [Anexo_Folder_Deletion_AllowedTeam] AFA INNER JOIN #TempAnexo_Folder_Deletion_AllowedTeamDel TempAnexo_Folder_Deletion_AllowedTeamDel ON [AFA].ID = TempAnexo_Folder_Deletion_AllowedTeamDel.Id
                                WHERE [AFA].ID >= @MinId AND [AFA].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder_Deletion_AllowedTeam
                                FROM #TempAnexo_Folder_Deletion_AllowedTeam TempAnexo_Folder_Deletion_AllowedTeam INNER JOIN #TempAnexo_Folder_Deletion_AllowedTeamDel TempAnexo_Folder_Deletion_AllowedTeamDel ON TempAnexo_Folder_Deletion_AllowedTeam.ID = TempAnexo_Folder_Deletion_AllowedTeamDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder_Deletion_AllowedTeam
                            DROP TABLE #TempAnexo_Folder_Deletion_AllowedTeamDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder_AllowedUserProfile]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder_AllowedUserProfile

                            CREATE TABLE #TempAnexo_Folder_AllowedUserProfile
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder_AllowedUserProfile (Id)
                            SELECT  [AFA].Id
                            FROM [Anexo_Folder_AllowedUserProfile] AFA INNER JOIN [Anexo_Folder] AF ON AFA.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Folder_AllowedUserProfileDel
                            CREATE TABLE #TempAnexo_Folder_AllowedUserProfileDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder_AllowedUserProfile))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Folder_AllowedUserProfileDel

                                INSERT #TempAnexo_Folder_AllowedUserProfileDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder_AllowedUserProfile
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Folder_AllowedUserProfileDel
                                DELETE AFA
                                FROM [Anexo_Folder_AllowedUserProfile] AFA INNER JOIN #TempAnexo_Folder_AllowedUserProfileDel TempAnexo_Folder_AllowedUserProfileDel ON [AFA].ID = TempAnexo_Folder_AllowedUserProfileDel.Id
                                WHERE [AFA].ID >= @MinId AND [AFA].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder_AllowedUserProfile
                                FROM #TempAnexo_Folder_AllowedUserProfile TempAnexo_Folder_AllowedUserProfile INNER JOIN #TempAnexo_Folder_AllowedUserProfileDel TempAnexo_Folder_AllowedUserProfileDel ON TempAnexo_Folder_AllowedUserProfile.ID = TempAnexo_Folder_AllowedUserProfileDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder_AllowedUserProfile
                            DROP TABLE #TempAnexo_Folder_AllowedUserProfileDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder_AllowedUser]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder_AllowedUser

                            CREATE TABLE #TempAnexo_Folder_AllowedUser
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder_AllowedUser (Id)
                            SELECT  [AFA].Id
                            FROM [Anexo_Folder_AllowedUser] AFA INNER JOIN [Anexo_Folder] AF ON AFA.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Folder_AllowedUserDel
                            CREATE TABLE #TempAnexo_Folder_AllowedUserDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder_AllowedUser))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Folder_AllowedUserDel

                                INSERT #TempAnexo_Folder_AllowedUserDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder_AllowedUser
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Folder_AllowedUserDel
                                DELETE AFA
                                FROM [Anexo_Folder_AllowedUser] AFA INNER JOIN #TempAnexo_Folder_AllowedUserDel TempAnexo_Folder_AllowedUserDel ON [AFA].ID = TempAnexo_Folder_AllowedUserDel.Id
                                WHERE [AFA].ID >= @MinId AND [AFA].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder_AllowedUser
                                FROM #TempAnexo_Folder_AllowedUser TempAnexo_Folder_AllowedUser INNER JOIN #TempAnexo_Folder_AllowedUserDel TempAnexo_Folder_AllowedUserDel ON TempAnexo_Folder_AllowedUser.ID = TempAnexo_Folder_AllowedUserDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder_AllowedUser
                            DROP TABLE #TempAnexo_Folder_AllowedUserDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder_AllowedTeam]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder_AllowedTeam

                            CREATE TABLE #TempAnexo_Folder_AllowedTeam
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder_AllowedTeam (Id)
                            SELECT  [AFA].Id
                            FROM [Anexo_Folder_AllowedTeam] AFA INNER JOIN [Anexo_Folder] AF ON AFA.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Folder_AllowedTeamDel
                            CREATE TABLE #TempAnexo_Folder_AllowedTeamDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder_AllowedTeam))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Folder_AllowedTeamDel

                                INSERT #TempAnexo_Folder_AllowedTeamDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder_AllowedTeam
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Folder_AllowedTeamDel
                                DELETE AFA
                                FROM [Anexo_Folder_AllowedTeam] AFA INNER JOIN #TempAnexo_Folder_AllowedTeamDel TempAnexo_Folder_AllowedTeamDel ON [AFA].ID = TempAnexo_Folder_AllowedTeamDel.Id
                                WHERE [AFA].ID >= @MinId AND [AFA].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder_AllowedTeam
                                FROM #TempAnexo_Folder_AllowedTeam TempAnexo_Folder_AllowedTeam INNER JOIN #TempAnexo_Folder_AllowedTeamDel TempAnexo_Folder_AllowedTeamDel ON TempAnexo_Folder_AllowedTeam.ID = TempAnexo_Folder_AllowedTeamDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder_AllowedTeam
                            DROP TABLE #TempAnexo_Folder_AllowedTeamDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder_Parent]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder_Parent

                            CREATE TABLE #TempAnexo_Folder_Parent
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder_Parent (Id)
                            SELECT  [AFP].Id
                            FROM [Anexo_Folder_Parent] AFP INNER JOIN [Anexo_Folder] AF ON AFP.[FolderId] = AF.[ID]
                            WHERE [AF].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_Folder_ParentDel
                            CREATE TABLE #TempAnexo_Folder_ParentDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder_Parent))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_Folder_ParentDel

                                INSERT #TempAnexo_Folder_ParentDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder_Parent
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_Folder_ParentDel
                                DELETE AFP
                                FROM [Anexo_Folder_Parent] AFP INNER JOIN #TempAnexo_Folder_ParentDel TempAnexo_Folder_ParentDel ON [AFP].ID = TempAnexo_Folder_ParentDel.Id
                                WHERE [AFP].ID >= @MinId AND [AFP].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder_Parent
                                FROM #TempAnexo_Folder_Parent TempAnexo_Folder_Parent INNER JOIN #TempAnexo_Folder_ParentDel TempAnexo_Folder_ParentDel ON TempAnexo_Folder_Parent.ID = TempAnexo_Folder_ParentDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder_Parent
                            DROP TABLE #TempAnexo_Folder_ParentDel
                            GO
PRINT 'Running accountId 1 and table [Anexo_Folder]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempAnexo_Folder

                            CREATE TABLE #TempAnexo_Folder
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempAnexo_Folder (Id)
                            SELECT  [Anexo_Folder].Id
                            FROM [Anexo_Folder] Anexo_Folder
                            WHERE [Anexo_Folder].[AccountId] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempAnexo_FolderDel
                            CREATE TABLE #TempAnexo_FolderDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempAnexo_Folder))
                            BEGIN
                                TRUNCATE TABLE #TempAnexo_FolderDel

                                INSERT #TempAnexo_FolderDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempAnexo_Folder
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempAnexo_FolderDel
                                DELETE Anexo_Folder
                                FROM [Anexo_Folder] Anexo_Folder INNER JOIN #TempAnexo_FolderDel TempAnexo_FolderDel ON [Anexo_Folder].ID = TempAnexo_FolderDel.Id
                                WHERE [Anexo_Folder].ID >= @MinId AND [Anexo_Folder].ID <= @MaxId
                                        
                                DELETE #TempAnexo_Folder
                                FROM #TempAnexo_Folder TempAnexo_Folder INNER JOIN #TempAnexo_FolderDel TempAnexo_FolderDel ON TempAnexo_Folder.ID = TempAnexo_FolderDel.Id
                            END
                            DROP TABLE #TempAnexo_Folder
                            DROP TABLE #TempAnexo_FolderDel
                            GO
PRINT 'Running accountId 1 and table [Ploomes_Cliente]'
DECLARE @AccountId INT = 1
 DROP TABLE IF EXISTS #TempPloomes_Cliente

                            CREATE TABLE #TempPloomes_Cliente
                            (
                                Id INT PRIMARY KEY
                            )

                            INSERT #TempPloomes_Cliente (Id)
                            SELECT  [PC].Id
                            FROM [Ploomes_Cliente] PC
                            WHERE [PC].[ID] = @AccountId
                                    
                            DROP TABLE IF EXISTS #TempPloomes_ClienteDel
                            CREATE TABLE #TempPloomes_ClienteDel
                            (
                                Id INT PRIMARY KEY
                            )

                            DECLARE @MaxId INT, @MinId INT
                            WHILE (EXISTS(SELECT 1 FROM #TempPloomes_Cliente))
                            BEGIN
                                TRUNCATE TABLE #TempPloomes_ClienteDel

                                INSERT #TempPloomes_ClienteDel (Id)
                                SELECT TOP 5000 ID
                                FROM #TempPloomes_Cliente
                                ORDER BY Id ASC
                                        
                                SELECT @MinId = min(id), @MaxId =  max(id)  From #TempPloomes_ClienteDel
                                DELETE PC
                                FROM [Ploomes_Cliente] PC INNER JOIN #TempPloomes_ClienteDel TempPloomes_ClienteDel ON [PC].ID = TempPloomes_ClienteDel.Id
                                WHERE [PC].ID >= @MinId AND [PC].ID <= @MaxId
                                        
                                DELETE #TempPloomes_Cliente
                                FROM #TempPloomes_Cliente TempPloomes_Cliente INNER JOIN #TempPloomes_ClienteDel TempPloomes_ClienteDel ON TempPloomes_Cliente.ID = TempPloomes_ClienteDel.Id
                            END
                            DROP TABLE #TempPloomes_Cliente
                            DROP TABLE #TempPloomes_ClienteDel
                            GO
