sum2 <- function(array,target){
  temp <- target - array
  result <- c()
  index1 <- c()
  index2 <- c()
  for (i in 1:length(array)) {
    for (j in 1:length(temp)){
      if (array[i] == temp[j]){
        result <- append(result,array[i])
        index1 <- append(index1,i)
        index2 <- append(index2,j)
      }
    }
  }
  cat(result,index1,index2)
}
