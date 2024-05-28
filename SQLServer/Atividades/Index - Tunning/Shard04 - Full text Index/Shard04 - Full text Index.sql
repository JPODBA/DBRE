use BA_DBA
go 
drop table if exists Teste_index_text
create table Teste_index_text (Id int unique not null, nome Varchar(10))
GO
CREATE FULLTEXT CATALOG TesteDeCatalogo AS DEFAULT;
go
CREATE FULLTEXT INDEX ON Teste_index_text (nome)
KEY INDEX Teste_NOI
WITH STOPLIST = SYSTEM;



CREATE FULLTEXT INDEX ON Teste_index_text (nome)
	KEY INDEX Teste_NOI
	ON TesteDeCatalogo
	WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
GO
