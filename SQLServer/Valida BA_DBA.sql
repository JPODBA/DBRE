Select count(1) from sys.tables having COUNT(1) < 22

-- Todos os Shards tem 22 tabelas, 2 a mais que as demais instâncias. Isso é devido ao Expurgo da Automation_Log que tem em todos, mas não nos demais. 