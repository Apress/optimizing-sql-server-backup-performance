# Install-Module dbatools
Import-Module dbatools

# https://gist.github.com/letmaik/d650ee257a27df8eac0f71f17aa99765
function CartesianProduct {
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Hashtable]
        $values = @{ Foo = 1..5; Bar = 1..10}
    )
    $keys = @($values.GetEnumerator() | ForEach-Object { $_.Name })
    $result = @($values[$keys[0]] | ForEach-Object { @{ $keys[0] = $_ } })
    if ($keys.Length -gt 1) {
        foreach ($key in $keys[1..($keys.Length - 1)]) {
            $result = foreach ($entry in $result) {
                foreach ($value in $values[$key]) {
                    $entry + @{ $key = $value }
                }
            }
        }
    }
    $result
}

$InstanceName = "localhost"
$DatabaseName = "WideWorldImporters"

foreach ($entry in CartesianProduct @{ BlockSize = (0.5kb, 1kb, 2kb, 4kb, 8kb, 16kb, 32kb, 64kb); BufferCount = (7, 15, 30, 60, 128, 256, 512, 1024); MaxTransferSize = (64kb, 128kb, 256kb, 512kb, 1mb, 2mb, 4mb); FileCount = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12); CompressBackup = ($true, $false) }) {
  # Sample:  10,752 (8 * 8 * 7 * 12 * 2) possible entries. Let's get ~100 samples per database, so 1% of the total samples.
  $rand = Get-Random -Maximum 100
  # We are making a fair assumption that Get-Random is a uniformly distributed pseudo-random number generator.  Setting -Maximum 100 means we'll get a range from 0-99.
  if ($rand -gt 98) {
    if ($entry.CompressBackup) {
      Write-Host "Compress"
      $outcome = Backup-DbaDatabase -SqlInstance ($InstanceName) -BackupDirectory G:\Backups -Database ($DatabaseName) -Type Full -CopyOnly -CompressBackup -BufferCount ($entry.BufferCount) -FileCount ($entry.FileCount) -MaxTransferSize ($entry.MaxTransferSize) -BlockSize ($entry.BlockSize)
    }
    else {
      Write-Host "NoCompress"
      $outcome = Backup-DbaDatabase -SqlInstance ($InstanceName) -BackupDirectory G:\Backups -Database ($DatabaseName) -Type Full -CopyOnly -BufferCount ($entry.BufferCount) -FileCount ($entry.FileCount) -MaxTransferSize ($entry.MaxTransferSize) -BlockSize ($entry.BlockSize)
    }
  "$($entry.BlockSize),$($entry.Buffercount),$($entry.MaxTransferSize),$($entry.FileCount),$($entry.CompressBackup),$($outcome.Duration.TotalSeconds)" >> C:\Temp\PerfTest.txt
    Remove-Item G:\Backups\*
  }
}
