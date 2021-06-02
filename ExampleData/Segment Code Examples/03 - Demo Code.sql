-- Initial backup settings
BACKUP DATABASE [WideWorldImporters]
TO DISK = N'G:\Backups\WideWorldImporters.bak'
WITH NOFORMAT, INIT;

-- 21.159 seconds

-- Try out some different backup settings
BACKUP DATABASE [WideWorldImporters]
    TO DISK = N'G:\Backups\WideWorldImporters1.bak',
    DISK = N'G:\Backups\WideWorldImporters2.bak'
WITH NOFORMAT, INIT,
    MAXTRANSFERSIZE = 2097152,
    BUFFERCOUNT = 50,
    BLOCKSIZE = 8192,
    COMPRESSION;

-- 7.13 seconds