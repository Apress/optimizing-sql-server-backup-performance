# Install packages
if(!require(tidyverse)) {
  install.packages("tidyverse", repos = "http://cran.us.r-project.org")
  library(tidyverse)
}

if(!require(randomForest)) {
  install.packages("randomForest", repos = "http://cran.us.r-project.org")
  library(randomForest)
}

if(!require(caret)) {
  install.packages("caret", repos = "http://cran.us.r-project.org")
  library(caret)
}

if(!require(evtree)) {
    install.packages("evtree", repos = "http://cran.us.r-project.org")
    library(evtree)
}

# Retrieve data from files.  Make sure these files are in the correct location!
bac_31gb <- readr::read_delim("../data/BAC_31.73GB_PerfTest.csv", delim = ",",
  col_names = c("BlockSize", "BufferCount", "MaxTransferSize", "FileCount", "CompressBackup", "Duration"),
  col_types = cols(
      BlockSize = col_integer(),
      BufferCount = col_integer(),
      MaxTransferSize = col_integer(),
      FileCount = col_integer(),
	  CompressBackup = col_character(),
      Duration = col_integer()
))

bac_58gb <- readr::read_delim("../data/BAC_57.89GB_PerfTest.csv", delim = ",",
  col_names = c("BlockSize", "BufferCount", "MaxTransferSize", "FileCount", "CompressBackup", "Duration"),
  col_types = cols(
      BlockSize = col_integer(),
      BufferCount = col_integer(),
      MaxTransferSize = col_integer(),
      FileCount = col_integer(),
	  CompressBackup = col_character(),
      Duration = col_integer()
))

bac_89gb <- readr::read_delim("../data/BAC_89.24GB_PerfTest.csv", delim = ",",
  col_names = c("BlockSize", "BufferCount", "MaxTransferSize", "FileCount", "CompressBackup", "Duration"),
  col_types = cols(
      BlockSize = col_integer(),
      BufferCount = col_integer(),
      MaxTransferSize = col_integer(),
      FileCount = col_integer(),
	  CompressBackup = col_character(),
      Duration = col_integer()
))

bac_136gb <- readr::read_delim("../data/BAC_136GB_PerfTest.csv", delim = ",",
  col_names = c("BlockSize", "BufferCount", "MaxTransferSize", "FileCount", "CompressBackup", "Duration"),
  col_types = cols(
      BlockSize = col_integer(),
      BufferCount = col_integer(),
      MaxTransferSize = col_integer(),
      FileCount = col_integer(),
	  CompressBackup = col_character(),
      Duration = col_integer()
))

so_10gb <- readr::read_delim("../data/SO2010_10GB_PerfTest.csv", delim = ",",
  col_names = c("BlockSize", "BufferCount", "MaxTransferSize", "FileCount", "CompressBackup", "Duration"),
  col_types = cols(
      BlockSize = col_integer(),
      BufferCount = col_integer(),
      MaxTransferSize = col_integer(),
      FileCount = col_integer(),
	  CompressBackup = col_character(),
      Duration = col_integer()
))

so_50gb <- readr::read_delim("../data/SO2013_50GB_PerfTest.csv", delim = ",",
  col_names = c("BlockSize", "BufferCount", "MaxTransferSize", "FileCount", "CompressBackup", "Duration"),
  col_types = cols(
      BlockSize = col_integer(),
      BufferCount = col_integer(),
      MaxTransferSize = col_integer(),
      FileCount = col_integer(),
	  CompressBackup = col_character(),
      Duration = col_integer()
))

wwi_3gb <- readr::read_delim("../data/WWI_3GB_PerfTest.csv", delim = ",",
  col_names = c("BlockSize", "BufferCount", "MaxTransferSize", "FileCount", "CompressBackup", "Duration"),
  col_types = cols(
      BlockSize = col_integer(),
      BufferCount = col_integer(),
      MaxTransferSize = col_integer(),
      FileCount = col_integer(),
	  CompressBackup = col_character(),
      Duration = col_integer()
))

# Set database sizes
bac_31gb$DatabaseSize <- 31.73
bac_58gb$DatabaseSize <- 57.89
bac_89gb$DatabaseSize <- 89.24
bac_136gb$DatabaseSize <- 136.
so_10gb$DatabaseSize <- 10.
so_50gb$DatabaseSize <- 50.
wwi_3gb$DatabaseSize <- 3.7

# Combine together all of the datasets
backupstats <- rbind(bac_31gb, bac_58gb, bac_89gb, bac_136gb, so_10gb, so_50gb, wwi_3gb)

# Feature Engineering
backupstats$BlockSizeKB <- backupstats$BlockSize / 1024.0
backupstats$BlockSize <- NULL

backupstats$MemoryUsageMB <- (backupstats$MaxTransferSize / (1024.0 * 1024.0)) * backupstats$BufferCount
backupstats$BufferCount <- NULL
backupstats$MaxTransferSize <- NULL

backupstats$SecPerGB <- backupstats$Duration / backupstats$DatabaseSize
