/*
    scrip de rollback do deploy 23-11-2023
*/
USE Ploomes_CRM;
GO

-- Down do up 2
UPDATE CampoFixo2
SET Editavel = 1
WHERE ID = 1375