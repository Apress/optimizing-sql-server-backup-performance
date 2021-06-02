# Build a training dataset
set.seed(20191119)
randbackupstats <- backupstats[sample(nrow(backupstats)), ]

trainIndex <- caret::createDataPartition(randbackupstats$SecPerGB, p = 0.7, list = FALSE, times = 1)
train_data <- randbackupstats[trainIndex,]
test_data <- randbackupstats[-trainIndex,]

nrow(train_data)
nrow(test_data)

# Review the training dataset
head(train_data)

# Prep by creating an RMSE function and setting plot size
RMSE = function(m, o){
  sqrt(mean((m - o)^2))
}

# How we'll call the function
# RMSE(outcomes$Duration, outcomes$modelPred)

# Create a model
model2 <- randomForest::randomForest(SecPerGB ~ BlockSizeKB + MemoryUsageMB + FileCount + DatabaseSize + CompressBackup,
               data = train_data,
               ntree=2000,
               importance=TRUE
           )
		   
# Review importance
randomForest::importance(model2, scale=TRUE)

# Review model score
model2

# Generate predictions
modelPred2 <- predict(model2, test_data)

# Build out a dataframe to review results
outcomes2 <- cbind(test_data, as.data.frame(modelPred2))
outcomes2$PredictedDuration <- outcomes2$modelPred2 * outcomes2$DatabaseSize

outcomes2$BlockSizeKB <- NULL

head(outcomes2)

RMSE(outcomes2$Duration, outcomes2$PredictedDuration)

options(repr.plot.width=8, repr.plot.height=6)
ggplot(outcomes2, aes(x = Duration, y = PredictedDuration - Duration)) +
    geom_point()
