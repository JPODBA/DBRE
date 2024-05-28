set nocount on
use Ploomes_CRM
go
Drop table if exists #Join
Create Table #Join (Id int) 
CREATE CLUSTERED INDEX DBA_PK ON #Join (ID)

--delete from BA_DBA.dbo.temp_delete_shankya
--Select count(1) from BA_DBA.dbo.temp_delete_shankya (nolock)

WHILE EXISTS (SELECT 1 FROM BA_DBA.dbo.temp_delete_shankya)
BEGIN

   	Print '---- INICIANDO ----------------------------------------------' 
	
		
   	-- Faz o insert de 1 ID na #Join ---------------------------------
		exec BA_DBA.dbo.pr_dba_cronometro
		Insert #Join 
		select top 1 id from BA_DBA..temp_delete_shankya 
		exec BA_DBA.dbo.pr_dba_cronometro 'Faz o insert de 1000 ID na #Join'
		-- Faz o insert de 1 ID na #Join ----------------------------------
		

		-- Delete  BA_DBA..temp_delete_shankya ---------------------------- 
		exec BA_DBA.dbo.pr_dba_cronometro
		DELETE D
		from BA_DBA..temp_delete_shankya D
		Join #Join j on j.id = D.id	
		Exec BA_DBA.dbo.pr_dba_cronometro 'Delete  BA_DBA..temp_delete_shankya'
		-- Delete  BA_DBA..temp_delete_shankya ---------------------------- 

		
		-- Delete ID_Usuario -----------------------------------------------
	  Exec BA_DBA.dbo.pr_dba_cronometro
    
		DELETE D
		from Usuario_Responsavel D 
		Join #Join   j on j.id = D.ID_Usuario	
		Exec BA_DBA.dbo.pr_dba_cronometro 'Delete ID_Usuario'
		-- Delete ID_Usuario -----------------------------------------------

		
		-- Delete ID_Responsavel -----------------------------------------------
		Exec BA_DBA.dbo.pr_dba_cronometro

		DELETE D
		from Usuario_Responsavel D 
		Join #Join   j on j.id = D.ID_Responsavel	
		Exec BA_DBA.dbo.pr_dba_cronometro 'Delete ID_Responsavel'
		-- Delete ID_Usuario -----------------------------------------------
				

		-- Delete da JOIN para não fazer de novo.
		Delete from #join
   	Print '---- Finalizado ----------------------------------------------' 
				
END

/**
-- 44.196.164
SELECT COUNT(u.ID_Usuario) 
FROM Usuario_Responsavel (NOLOCK)   u
JOIN BA_DBA.dbo.temp_delete_shankya t on t.id = u.ID_Usuario

---- 44.714.463
SELECT COUNT(u.ID_Responsavel) 
FROM Usuario_Responsavel (NOLOCK) u
JOIN BA_DBA.dbo.temp_delete_shankya t on t.id = u.ID_Responsavel


SELECT COUNT(u.ID_Responsavel) 
FROM Usuario_Responsavel (NOLOCK) u
JOIN BA_DBA.dbo.temp_delete_shankya (nolock) t on t.id = u.ID_Responsavel

SELECT COUNT(u.ID_Usuario) 
FROM Usuario_Responsavel (NOLOCK)   u
JOIN BA_DBA.dbo.temp_delete_shankya t (NOLOCK) on t.id = u.ID_Usuario
**/

