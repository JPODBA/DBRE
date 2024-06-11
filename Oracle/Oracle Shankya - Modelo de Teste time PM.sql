su - oracle
. oraenv
XE
sqlplus / as sysdba

SELECT name
FROM v$database;


SELECT DISTINCT owner AS schema_name
FROM dba_tables;


SELECT DISTINCT table_name, owner
FROM all_tables
WHERE table_name LIKE 'T%'
ORDER BY table_name;
