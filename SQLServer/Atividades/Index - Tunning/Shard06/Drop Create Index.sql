--sp_helpindex 'cliente'
--IX_Cliente_ID_ClientePloomes	nonclustered located on INDEX_03	ID_ClientePloomes, ID_Responsavel, ID_Tipo, ID_Status
--IX_Cliente_ID_ClientePloomes2	nonclustered located on INDEX_03	ID_ClientePloomes, ID_Responsavel, ID_Importacao

--sp_helpindex 'cliente'
/*
Drop index if exists cliente.IX_cliente_ClientePloomes_DBA04
Drop index if exists cliente.IX_Cliente_OrdemTarefas
ID_ClientePloomes, ID_Responsavel, Suspenso, Nome

CREATE NONCLUSTERED Index IX_cliente_ClientePloomes_DBA01 on cliente (ID, ID_ClientePloomes, ID_Responsavel, Suspenso) on [INDEX]
CREATE NONCLUSTERED Index IX_cliente_ClientePloomes_DBA02 on cliente (ID_ClientePloomes, ID_Responsavel, Suspenso) on [INDEX]
CREATE NONCLUSTERED Index IX_cliente_ClientePloomes_DBA03 on cliente (ID_ClientePloomes, ID_Responsavel) on [INDEX]
CREATE NONCLUSTERED Index IX_cliente_ClientePloomes_DBA04 on cliente (ID_ClientePloomes, Suspenso) include (id, ID_Responsavel) on [INDEX]
CREATE NONCLUSTERED Index IX_cliente_ClientePloomes_DBA05 on cliente (ID_ClientePloomes, ID_Responsavel, ID) on [INDEX]
CREATE NONCLUSTERED Index IX_cliente_ClientePloomes_DBA06 on cliente (Suspenso, ID_ClientePloomes, ID_Responsavel) on [INDEX]

CREATE NONCLUSTERED Index IX_cliente_ClientePloomes_DBA07 on cliente (ID, ID_ClientePloomes, ID_Responsavel) on [INDEX_02]
CREATE NONCLUSTERED Index IX_cliente_ClientePloomes_DBA08 on cliente (ID, ID_ClientePloomes) on [INDEX_02]

CREATE NONCLUSTERED Index IX_cliente_ClientePloomes_DBA09 on cliente (ID, ID_ClientePloomes) include (ID_Responsavel) on  [INDEX_02]