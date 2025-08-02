# Arguments for the merge function in R
# x, y
# data frames, or objects to be coerced to one.
# by, by.x, by.y
# specifications of the columns used for merging. See ‘Details’.
# all
# logical; all = L is shorthand for all.x = L and all.y = L, where L is either TRUE or FALSE.
# all.x
# logical; if TRUE, then extra rows will be added to the output, one for each row in x that has no matching row in y. These rows will have NAs in those columns that are usually filled with values from y. The default is FALSE, so that only rows with data from both x and y are included in the output.
# all.y
# logical; analogous to all.x.
# sort
# logical. Should the result be sorted on the by columns?
# suffixes
# a character vector of length 2 specifying the suffixes to be used for making unique the names of columns in the result which are not used for merging (appearing in by etc).
# no.dups
# logical indicating that suffixes are appended in more cases to avoid duplicated column names in the result. This was implicitly false before R version 3.5.0.
# incomparables
# values which cannot be matched. See match. This is intended to be used for merging on one column, so these are incomparable values of that column.
# …
# arguments to be passed to or from methods.

df1 <- data.frame(id = 1:4, value1 = c("A", "B", "C", "Z"))
df2 <- data.frame(id = 2:5, value2 = c("D", "E", "F", "Z"))
print("Original Data Frames:")
print(df1)
print(df2)

merged_df_outer <- merge(df1, df2, by = "id", all = TRUE)
print("Merged Data Frame: full outer join")
print(merged_df_outer)
merged_df_inner <- merge(df1, df2, by = "id", all = FALSE)
print("Merged Data Frame: inner join")
print(merged_df_inner)
merged_df_left <- merge(df1, df2, by = "id", all.x = TRUE)
print("Merged Data Frame: left join")
print(merged_df_left)
merged_df_right <- merge(df1, df2, by = "id", all.y = TRUE)
print("Merged Data Frame: right join")
print(merged_df_right)  
