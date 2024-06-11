-- Script de rollback do pacote deployment-2-4-2024
USE Ploomes_CRM

-- DOWN do UP 1
DELETE FROM Automation_AllowedEntity_Action where id in (71, 72, 73, 74)

-- DOWN do UP 2
ALTER TABLE [Integration_Field] DROP COLUMN [MaxValue]