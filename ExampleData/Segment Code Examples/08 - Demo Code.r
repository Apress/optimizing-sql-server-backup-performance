# Build an evolutionary tree
ev <- evtree(SecPerGB ~ BlockSizeKB + MemoryUsageMB + FileCount + DatabaseSize + CompressBackup,
             data = train_data, minbucket = 10, maxdepth = 4)
			 
# Review the results
options(repr.plot.width=8, repr.plot.height=6)
plot(ev)

# Display a treeview
ev

# Test out predictions
test_data$PredSecPerGB <- predict(ev, test_data)
test_data$PredDuration <- test_data$PredSecPerGB * test_data$DatabaseSize
test_data$BlockSizeKB <- NULL

# Show the first few predictions
test_data %>%
    select(FileCount, DatabaseSize, MemoryUsageMB, SecPerGB, Duration, PredSecPerGB, PredDuration) %>%
    head()
	
# Calculate root mean squared error (in seconds) to estimate how far off we are
RMSE(test_data$Duration, test_data$PredDuration)

# Plot durations versus predictions
options(repr.plot.width=8, repr.plot.height=6)
ggplot(test_data, aes(x = Duration, y = PredDuration - Duration)) +
    geom_point()