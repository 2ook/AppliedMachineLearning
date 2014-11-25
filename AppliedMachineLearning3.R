#Question 1

library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)

training = segmentationOriginal[segmentationOriginal$Case == "Train",]
testing = segmentationOriginal[segmentationOriginal$Case == "Test",]

set.seed(125)
modFit <- train(Class ~ .,method="rpart",data=training)

library(rattle)
fancyRpartPlot(modFit$finalModel)

#Question 3

library(pgmm)
data(olive)
olive = olive[,-1]

modFit <- train(Area ~ .,method="rpart",data=olive)
predict(modFit, newdata = as.data.frame(t(colMeans(olive))))

#Question 4

library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]

set.seed(13234)
modFit <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl,
                method="glm", 
                family = "binomial",
                data = trainSA)

predSA <- predict(modFit, newdata = testSA)
missClass <- function(values,prediction){
  sum(((prediction > 0.5)*1) != values)/length(values)
}

missClass(trainSA$chd, modFit$finalModel$fitted)
missClass(testSA$chd, predSA)

#Question 5

library(ElemStatLearn)
data(vowel.train)
data(vowel.test)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)

set.seed(33833)

modFit <- train(y ~ .,data = vowel.train , method="rf",prox=TRUE)
varImpPlot(modFit$finalModel)

