# install.packages(c("curl", "xml2", "xmlconvert"), repos = "https://cloud.r-project.org/")j
library("xml2", quietly = TRUE)
library("xmlconvert", quietly = TRUE)

file <- xml2::read_xml("./static/test.xml")
# file <- xml2::read_xml("./static/cv_lattes.xml", encoding = "ISO-8859-1")


node <- xml2::xml_find_all(file, ".//Participacao")
# node <- xml2::xml_find_all(file, ".//PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO")

empty_df <- data.frame(
  stringsAsFactors = FALSE,
  name = character(),
  value = character()
)
for (table in node) {
  # print(table)
  inner_nodes <- xml2::xml_children(table)
  table_name <- xml2::xml_name(table)
  table_attrs <- xml2::xml_attrs(table)
  # add columns
  empty_df <- cbind(empty_df, names(table_attrs))
  for (inner_table in inner_nodes) {
    # Get the name of the inner table
    inner_table_name <- xml2::xml_name(inner_table)
    # Get the attributes of the inner table
    inner_table_attrs <- xml2::xml_attrs(inner_table)
    # Print the name and attributes
    print(paste(
      "Table:", inner_table_name,
      ": ", paste(names(inner_table_attrs),
        "values:", inner_table_attrs,
        collapse = ", "
      )
    ))
    # Get the children of the inner table
    inner_table_children <- xml2::xml_children(inner_table)
    for (child_table in inner_table_children) {
      # Check if the child has children
      if (length(xml2::xml_children(child_table)) == 0) {
        # Get the name of the child table
        child_table_name <- xml2::xml_name(child_table)
        # Get the attributes of the child table
        child_table_attrs <- xml2::xml_attrs(child_table)
        # Print the name and attributes
        print(paste(
          "Child Table:", child_table_name,
          ":", paste(names(child_table_attrs),
            "value:", child_table_attrs,
            collapse = ", "
          )
        ))
      } else {
        # if the child has children, go deeper
        # bottom level child tables
        child_table_children <- xml2::xml_children(child_table)
        for (bottom_child_table in child_table_children) {
          # Get the name of the bottom child table
          bottom_child_table_name <- xml2::xml_name(bottom_child_table)
          # Get the attributes of the bottom child table
          bottom_child_table_attrs <- xml2::xml_attrs(bottom_child_table)
          # Print the name and attributes
          print(paste(
            "Bottom Child Table:", bottom_child_table_name,
            ":", paste(names(bottom_child_table_attrs),
              "value:", bottom_child_table_attrs,
              collapse = ", "
            )
          ))
        }

        # print(paste("row: ", row))
        print(empty_df)
      }
    }
  }
}
