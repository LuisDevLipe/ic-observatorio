# install.packages(c("curl", "xml2", "xmlconvert"), repos = "https://cloud.r-project.org/")j
library("xml2", quietly = TRUE)
library("xmlconvert", quietly = TRUE)

file <- xml2::read_xml("./static/test.xml")
# file <- xml2::read_xml("./static/cv_lattes.xml", encoding = "ISO-8859-1")


node <- xml2::xml_find_all(file, ".//Participacao")
# node <- xml2::xml_find_all(file, ".//PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO")

# Create a data frame for the top level table Participacao with 1 column
TBL_participacao <- data.frame(matrix(ncol = 1, nrow = 0), stringsAsFactors = FALSE)
# Create a data frame for each of the 2nd level tables with corresponding columns
# Adding 'sequencia' as the first column for querying and joining later
TBL_dados_basicos <- data.frame(matrix(ncol = 2, nrow = 0), stringsAsFactors = FALSE)
TBL_detalhamento <- data.frame(matrix(ncol = 3, nrow = 0), stringsAsFactors = FALSE)
TBL_participantes <- data.frame(matrix(ncol = 3, nrow = 0), stringsAsFactors = FALSE)
# Create a data frame for the 3rd level tables with corresponding columns
TBL_area <- data.frame(matrix(ncol = 3, nrow = 0), stringsAsFactors = FALSE)

for (table in node) {
  # print(table)
  inner_nodes <- xml2::xml_children(table)
  table_name <- xml2::xml_name(table)
  table_attrs <- xml2::xml_attrs(table)
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
    # Every iteration will push the attributes of the inner table to the master table.
    TBL_participacao <- rbind(TBL_participacao, inner_table_attrs)

    # We will update the names of the columns in the master table
    # Get the children of the inner table and push to the 2nd level table,
    # we will also push the the attributes of the inner table to the 2nd level table
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
        # Push the attributes of the child table to the 2nd level table
        if (child_table_name == "Dados-basicos") {
          TBL_dados_basicos <- rbind(TBL_dados_basicos, c(inner_table_attrs, child_table_attrs))
        } else if (child_table_name == "Detalhamento") {
          TBL_detalhamento <- rbind(TBL_detalhamento, c(inner_table_attrs, child_table_attrs))
        } else if (child_table_name == "Participante") {
          TBL_participantes <- rbind(TBL_participantes, c(inner_table_attrs, child_table_attrs))
        }
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
          # Push the attributes of the bottom child table to the 3rd level table
          if (bottom_child_table_name == "Area") {
            TBL_area <- rbind(TBL_area, c(inner_table_attrs, bottom_child_table_attrs))
          }
        }
      }
    }
  }
}
# Set the column names for each table
colnames(TBL_participacao) <- c("sequencia")
colnames(TBL_dados_basicos) <- c("sequencia", "natureza")
colnames(TBL_detalhamento) <- c("sequencia", "nome", "sobrenome")
colnames(TBL_participantes) <- c("sequencia", "nome", "sobrenome")
colnames(TBL_area) <- c("sequencia", "codigo", "nome")

print("Master Table (TBL_participacao):")
print(TBL_participacao)
print("2nd Level Table (TBL_dados_basicos):")
print(TBL_dados_basicos)
print("2nd Level Table (TBL_detalhamento):")
print(TBL_detalhamento)
print("2nd Level Table (TBL_participantes):")
print(TBL_participantes)
print("3rd Level Table (TBL_area):")
print(TBL_area)

# Save each table to a csv file
write.csv(TBL_participacao, "./static/output/TBL_participacao.csv", row.names = FALSE)
write.csv(TBL_dados_basicos, "./static/output/TBL_dados_basicos.csv", row.names = FALSE)
write.csv(TBL_detalhamento, "./static/output/TBL_detalhamento.csv", row.names = FALSE)
write.csv(TBL_participantes, "./static/output/TBL_participantes.csv", row.names = FALSE)
write.csv(TBL_area, "./static/output/TBL_area.csv", row.names = FALSE)