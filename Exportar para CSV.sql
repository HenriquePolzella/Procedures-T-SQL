-- Habilitar xp_cmdshell se ainda não estiver habilitado
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

-- Criar a stored procedure
USE Ecommerce;
GO

CREATE OR ALTER PROCEDURE ExportToCSV
    @DatabaseName NVARCHAR(128),
    @SchemaName NVARCHAR(128),
    @TableName NVARCHAR(128),
    @FilePath NVARCHAR(256)
AS
BEGIN
    DECLARE @BCPCommand NVARCHAR(1000);
    
    SET @BCPCommand = 'bcp "' + @DatabaseName + '.' + @SchemaName + '.' + @TableName + '" out "' + @FilePath + '" -c -t, -T -S ' + @@SERVERNAME;
    
    EXEC xp_cmdshell @BCPCommand;
END
GO

-- Usar a stored procedure
EXEC ExportToCSV
    @DatabaseName = 'Ecommerce',
    @SchemaName = 'dbo',
    @TableName = 'Tabela',
    @FilePath = 'C:\Caminho\SeuArquivo.csv';