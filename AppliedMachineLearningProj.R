library(caret)
library(randomForest)

train <- read.csv("pml-training.csv",colClasses="character")

for(i in 8:ncol(train)){
  print(sum(is.na(train[,i]))/nrow(train))
}

new.train <-train[,-7:-1]
new.train[new.train == "#DIV/0!"] <- NA
new.train[new.train == ""] <- NA

new.train <- new.train[,colSums(is.na(new.train))/nrow(new.train) < 0.9]

convert.magic <- function(obj,types){
  out <- lapply(1:length(obj),FUN = function(i){FUN1 <- switch(types[i],character = as.character,numeric = as.numeric,factor = as.factor); FUN1(obj[,i])})
  names(out) <- colnames(obj)
  as.data.frame(out)
}

new.train <- convert.magic(new.train,c(rep("numeric",ncol(new.train)-1),"factor"))

preProc <- preProcess(new.train[,-ncol(new.train)],method="pca",thresh = .90)
new.train.PCA <- predict(preProc,new.train[,-ncol(new.train)])

new.train <- cbind(new.train.PCA,new.train$classe)
names(new.train) <- c(names(new.train.PCA),"classe")

model <- randomForest(classe ~ .,data=new.train)

testPC <- predict(preProc,log10(testing[,-58]+1))
confusionMatrix(testing$type,predict(modelFit,testPC))

test <- read.csv("pml-testing.csv",colClasses="character")
new.test <-test[,c(-7:-1,-ncol(test))]
new.test[new.test == "#DIV/0!"] <- NA
new.test[new.test == ""] <- NA

new.test <- new.test[,colSums(is.na(new.test))/nrow(new.test) < 0.9]

new.test <- convert.magic(new.test,c(rep("numeric",ncol(new.test))))

new.test.PCA <- predict(preProc,new.test)

pv <- as.character(predict(model,newdata = new.test.PCA))

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

pml_write_files(pv)

library(knitr)
knit2html("AppliedMachineLearningProj.Rmd")