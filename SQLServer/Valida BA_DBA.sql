Select count(1) from sys.tables having COUNT(1) < 22

-- Todos os Shards tem 22 tabelas, 2 a mais que as demais inst�ncias. Isso � devido ao Expurgo da Automation_Log que tem em todos, mas n�o nos demais. 