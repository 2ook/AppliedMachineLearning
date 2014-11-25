#Question 1

library(AppliedPredictiveModeling)
library(caret)
data(AlzheimerDisease)

adData = data.frame(diagnosis,predictors)
testIndex = createDataPartition(diagnosis, p = 0.50,list=FALSE)
training = adData[-testIndex,]
testing = adData[testIndex,]

#Question 2

library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

library(ggplot2)

plot(training$CompressiveStrength, pch = 19)

library(Hmisc)
flyAshBin <- cut2(training$FlyAsh, g=5)
plot(training$CompressiveStrength, col = as.factor(flyAshBin))
table(flyAshBin)

#Question 3

library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

hist(training$Superplasticizer, col = 'red')
hist(log(training$Superplasticizer + 1), col = 'red')

#Question 4

library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

names(adData)[58:69]

preProc <- preProcess(adData[,58:69],method="pca",thresh = .90)
preProc

#Question 5

library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

preProc <- preProcess(training[,58:69],method="pca",thresh = 0.80)
trainPC <- predict(preProc,training[,58:69])
modelFit <- train(training$diagnosis ~ .,method="glm",data=trainPC)

testPC <- predict(preProc,testing[,58:69],)
confusionMatrix(testing$diagnosis,predict(modelFit,testPC))
