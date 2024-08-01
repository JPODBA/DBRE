-- Habilitar opções avançadas de configuração
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

-- Habilitar o componente 'Agent XPs'
EXEC sp_configure 'Agent XPs', 1;
RECONFIGURE;