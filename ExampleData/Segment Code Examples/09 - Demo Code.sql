-- Show Ola SQL Agent job

-- Ola scripts
USE [master]
GO
EXECUTE [dbo].[DatabaseBackup]
	@Databases = 'USER_DATABASES',
	@Directory = NULL,
	@BackupType = 'FULL',
	@Verify = 'Y',
	@CleanupTime = NULL,
	@CheckSum = 'Y',
	@LogToTable = 'Y',
	@BufferCount = 32,
	@MaxTransferSize = 2097152,
	@Compress = 'Y';
	
(21 seconds)


-- Minion Backup
USE [DBAdmin]
GO
select * from Minion.BackupTuningThresholds;

UPDATE Minion.BackupTuningThresholds
SET Compression = 1,
	BufferCount = 32,
	MaxTransferSize = 2097152
WHERE
	ID = 1;
	
-- Could also have other options for, say, larger databases
INSERT INTO Minion.BackupTuningThresholds
(
	DBName,
	BackupType,
	SpaceType,
	ThresholdMeasure,
	ThresholdValue,
	NumberOfFiles,
	Buffercount,
	MaxTransferSize,
	Compression,
	BlockSize,
	IsActive,
	Comment
)
VALUES
(
	'LargeDatabases',
	'All',
	'DataAndIndex',
	'GB',
	50,
	12,
	32,
	2097152,
	1,
	0,
	1,
	'Backup settings for larger databases'
);

EXEC Minion.BackupDB
	@DBName = 'AdventureWorks2012',
	@BackupType = 'Full',
	@StmtOnly = 1;

EXEC Minion.BackupMaster
	@DBType = 'User',
	@BackupType = 'Full';