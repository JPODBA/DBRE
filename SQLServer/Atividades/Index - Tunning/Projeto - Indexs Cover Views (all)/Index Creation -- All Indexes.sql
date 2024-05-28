Use Ploomes_CRM
go 
CREATE NONCLUSTERED Index IX_Relatorio_ID_Cliente_DBA01 on Relatorio (ID_Cliente, Suspenso, ID desc) on [INDEX]
CREATE NONCLUSTERED Index IX_Relatorio_ID_Oportunidade_DBA02 on Relatorio (ID_oportunidade, Suspenso, ID desc) on [INDEX]
--sp_helpindex 'Relatorio'
go 
----- Svw_Oportunidade --------------
CREATE NONCLUSTERED Index IX_Cotacao_Svw_Oportunidade_01                          on Cotacao (ID, ID_Oportunidade, Suspenso, Codigo desc) on [INDEX]
CREATE NONCLUSTERED Index IX_Cotacao_Revisao_Svw_Oportunidade_02                  on Cotacao_Revisao (ID_Cotacao, ID_ClientePloomes, Suspenso, Numero desc) on [INDEX]
CREATE NONCLUSTERED Index IX_Venda_Svw_Oportunidade_01                            on Venda (ID_Oportunidade, Suspenso, ID desc) on [INDEX]
CREATE NONCLUSTERED Index IX_Document_Svw_Oportunidade_01                         on Document (DealId, Suspended, ID desc) on [INDEX]
CREATE NONCLUSTERED Index IX_Oportunidade_Colaborador_Usuario_Svw_Oportunidade_01 on Oportunidade_Colaborador_Usuario (ID_Oportunidade, ID_Usuario, Sistema) on [INDEX]
CREATE NONCLUSTERED Index IX_Usuario_Responsavel_Svw_Oportunidade_01              on Usuario_Responsavel (ID_Usuario, ID_Responsavel, ID_Tipo, ID_Item, ID desc) on [INDEX]

-- Svw_Cliente ----------------------

-- (Já tinha criado alguns para ela) 
CREATE NONCLUSTERED Index IX_Document_Svw_Cliente01 on Document (ContactId, Suspended, ID desc) on [INDEX]


---- SVw_Ploomes_Cliente ---------------

CREATE NONCLUSTERED Index IX_Ploomes_Cliente_SVw_Ploomes_Cliente_01             on Ploomes_Cliente (ID, ID_Plano) on [INDEX]
CREATE NONCLUSTERED Index IX_RegraNegocio_SVw_Ploomes_Cliente_01                on RegraNegocio (ID_ClientePloomes, Suspenso) on [INDEX]
CREATE NONCLUSTERED Index IX_Cotacao_SVw_Ploomes_Cliente_01                     on Cotacao (ID_Oportunidade, Suspenso) include (Codigo) on [INDEX]
CREATE NONCLUSTERED Index IX_Oportunidade_SVw_Ploomes_Cliente_01                on Oportunidade (ID, ID_ClientePloomes) on [INDEX]
CREATE NONCLUSTERED Index IX_Venda_SVw_Ploomes_Cliente_01                       on Venda (Suspenso, ID_ClientePloomes) include (Codigo) on [INDEX]
CREATE NONCLUSTERED Index IX_Document_SVw_Ploomes_Cliente_01                    on Document (Suspended, AccountId) include (DocumentNumber) on [INDEX]
CREATE NONCLUSTERED Index IX_Integracao_TotalVoice_SVw_Ploomes_Cliente_01       on Integracao_TotalVoice (ID_ClientePloomes, Suspenso) include (ID) on [INDEX]
CREATE NONCLUSTERED Index IX_Integracao_EmailMkt_SVw_Ploomes_Cliente_01         on Integracao_EmailMkt (ID, ID_ClientePloomes, ID_Sistema) include (ID) on [INDEX]
CREATE NONCLUSTERED Index IX_Integracao_EmailMkt_Sistema_SVw_Ploomes_Cliente_01 on Integracao_EmailMkt_Sistema (ID_Integracao_EmailMkt, Suspenso) on [INDEX]
CREATE NONCLUSTERED Index IX_Usuario_SVw_Ploomes_Cliente_01                     on Usuario (ID_ClientePloomes, Suspenso, Cortesia) on [INDEX]

--- SVw_Usuario ----------------------------

--Todos já estão convers 

--- SVw_Tarefa ---------------------------

CREATE NONCLUSTERED Index IX_Relatorio_SVw_Tarefa_01           on Relatorio (ID_TarefaConclusao, Suspenso, ID desc) on [INDEX]
CREATE NONCLUSTERED INDEX IX_Tarefa_Conclusao_SVw_Tarefa_01    on Tarefa_Conclusao ([ID_Tarefa],[ID_ClientePloomes]) INCLUDE ([DataRecorrencia],[Concluido],[ID_Cliente],[ID_Oportunidade],[OriginTaskId],[Pending])  on [INDEX]
CREATE NONCLUSTERED Index IX_Tarefa_Conclusao_SVw_Tarefa_02    on Tarefa_Conclusao (ID, ID_Tarefa) on [INDEX]
CREATE NONCLUSTERED Index IX_Usuario_SVw_Tarefa_01             on Usuario (ID_ClientePloomes, ID, IntegracaoNativa) on [INDEX]
CREATE NONCLUSTERED Index IX_Usuario_Responsavel_SVw_Tarefa_01 on Usuario_Responsavel (ID_Responsavel, ID_Tipo, ID_Usuario, ID_Item) on [INDEX]
CREATE NONCLUSTERED Index IX_Tarefa_SVw_Tarefa_01              on Tarefa (ID, Suspenso) on [INDEX]
CREATE NONCLUSTERED Index IX_Tarefa_Usuario_SVw_Tarefa_01      on Tarefa_Usuario (ID_Tarefa, ID_Usuario) on [INDEX]

--- SVw_Produto ----------------------------

-- Não alterou o plano de acesso. 
CREATE NONCLUSTERED Index IX_Produto_SVw_Produto_01 on Produto (ID_Grupo) on [INDEX]


---- SVw_Relatorio -------------------------
--Todos já estão convers 


---- SVw_Campo_Valor -------------------------
-- Avaliar 
CREATE NONCLUSTERED Index IX_Campo_Valor_SVw_Campo_Valor_01 on Campo_Valor (ID_Campo, AttachmentValueId, ContactValueId, ID_Produto, ID_UsuarioValor, ID_OpcaoValor) on [INDEX]