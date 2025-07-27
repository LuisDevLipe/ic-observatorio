# install.packages("uuid", repos = "https://cloud.r-project.org/")
library('uuid', quietly = TRUE)

id <- uuid::UUIDgenerate()
ids <- uuid::UUIDgenerate(n = 10)
print(id)
print(ids)

ids2 <- c()

for (i in c(1:10**7)){
    ids2[i] <- uuid::UUIDgenerate()
}

print(length(ids2))
print(length(unique(ids2)))