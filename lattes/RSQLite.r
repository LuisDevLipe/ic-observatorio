# install.packages("RSQLite", repos = "https://cloud.r-project.org/")
library("DBI")

db <- dbConnect(RSQLite::SQLite(), "./static/lattes.db")

sample_df <- data.frame(
  id = 1:5,
  name = c("Alice", "Bob", "Charlie", "David", "Eve"),
  age = c(25, 30, 35, 40, 45)
)

dbWriteTable(db, "sample_table", sample_df, overwrite = TRUE)

# Query the table to verify

result <- dbGetQuery(db, "SELECT * FROM sample_table")
print(result)

# Disconnect from the database
dbDisconnect(db)