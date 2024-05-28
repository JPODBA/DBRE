Use Ploomes_CRM
go 
drop index if exists  Relatorio.IX_Relatorio_ID_Cliente_DBA01      
drop index if exists  Relatorio.IX_Relatorio_ID_Oportunidade_DBA02 
--sp_helpindex 'Relatorio'
go 
----- Svw_Oportunidade --------------
drop index if exists  Cotacao.IX_Cotacao_Svw_Oportunidade_01                        
drop index if exists  Cotacao_Revisao.IX_Cotacao_Revisao_Svw_Oportunidade_02        
drop index if exists  Venda.IX_Venda_Svw_Oportunidade_01                            
drop index if exists  Document.IX_Document_Svw_Oportunidade_01                        
drop index if exists  Oportunidade_Colaborador_Usuario.IX_Oportunidade_Colaborador_Usuario_Svw_Oportunidade_01 
drop index if exists  Usuario_Responsavel.IX_Usuario_Responsavel_Svw_Oportunidade_01              

-- Svw_Cliente ----------------------

-- (Já tinha criado alguns para ela) 
drop index if exists  Document.IX_Document_Svw_Cliente01 

---- SVw_Ploomes_Cliente ---------------

drop index if exists  Ploomes_Cliente.IX_Ploomes_Cliente_SVw_Ploomes_Cliente_01 
drop index if exists RegraNegocio.IX_RegraNegocio_SVw_Ploomes_Cliente_01        
drop index if exists Cotacao.IX_Cotacao_SVw_Ploomes_Cliente_01                  
drop index if exists Oportunidade.IX_Oportunidade_SVw_Ploomes_Cliente_01        
drop index if exists Venda.IX_Venda_SVw_Ploomes_Cliente_01                      
drop index if exists Document.IX_Document_SVw_Ploomes_Cliente_01                
drop index if exists Integracao_TotalVoice.IX_Integracao_TotalVoice_SVw_Ploomes_Cliente_01            
drop index if exists Integracao_EmailMkt.IX_Integracao_EmailMkt_SVw_Ploomes_Cliente_01                
drop index if exists Integracao_EmailMkt_Sistema.IX_Integracao_EmailMkt_Sistema_SVw_Ploomes_Cliente_01
drop index if exists Usuario.IX_Usuario_SVw_Ploomes_Cliente_01                                        

--- SVw_Usuario ----------------------------

--Todos já estão convers 

--- SVw_Tarefa ---------------------------

drop index if exists  Relatorio.IX_Relatorio_SVw_Tarefa_01                 
drop index if exists  Tarefa_Conclusao.IX_Tarefa_Conclusao_SVw_Tarefa_01   
drop index if exists  Tarefa_Conclusao.IX_Tarefa_Conclusao_SVw_Tarefa_02   
drop index if exists  Usuario.IX_Usuario_SVw_Tarefa_01                     
drop index if exists  Usuario_Responsavel.IX_Usuario_Responsavel_SVw_Tarefa_01  
drop index if exists  Tarefa.IX_Tarefa_SVw_Tarefa_01                            
drop index if exists  Tarefa_Usuario.IX_Tarefa_Usuario_SVw_Tarefa_01             

--- SVw_Produto ----------------------------

-- Não alterou o plano de acesso. 
drop index if exists  Produto.IX_Produto_SVw_Produto_01