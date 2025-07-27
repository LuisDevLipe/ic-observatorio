libs <- c("curl", "xml2", "RSQLite")
try({
  # Load necessary libraries
  sapply(libs, function(lib) {
    library(lib, character.only = TRUE, quietly = TRUE)
  })
})
# If the libraries are not installed, install them
if (any(!libs %in% installed.packages())) {
  install.packages(libs[!libs %in% installed.packages()])
  sapply(libs, function(lib) {
    library(lib, character.only = TRUE, quietly = TRUE)
  })
}

# Arquivo com o XML a ser lido
file <- xml2::read_xml("./static/cv_lattes.xml", encoding = "ISO-8859-1")
# Nó que contém as informações de participação em bancas
node <- xml2::xml_find_all(file, ".//PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO")

# Go the end of the file to se the save_as function
#---------------------------------------------------#

# Create a data frame for the top level table PARTICIPACAO-EM-BANCA-DE-MESTRADO/DOUTORADO/...
# With 2 columns: uuid and sequencia
TBL_participacao <- data.frame(matrix(ncol = 2, nrow = 0), stringsAsFactors = FALSE)

# Create a data frame for each of the 2nd level tables with corresponding columns
# Adding 1 extra column for uuid and 1 for sequencia, for querying and joining later.
TBL_dados_basicos <- data.frame(matrix(ncol = 11, nrow = 0), stringsAsFactors = FALSE)

TBL_detalhamento <- data.frame(matrix(ncol = 10, nrow = 0), stringsAsFactors = FALSE) # Already includes uuid and sequencia

TBL_participantes <- data.frame(matrix(ncol = 6, nrow = 0), stringsAsFactors = FALSE)

TBL_informacoes_adicionais <- data.frame(matrix(ncol = 4, nrow = 0), stringsAsFactors = FALSE)

TBL_setores_atividades <- data.frame(matrix(ncol = 3, nrow = 0), stringsAsFactors = FALSE)

TBL_palavras_chave <- data.frame(matrix(ncol = 3, nrow = 0), stringsAsFactors = FALSE)

# Create a data frame for the 3rd level tables with corresponding columns
# <master/>
#   <2nd level/>
#     <3rd level/>
TBL_area_conhecimento <- data.frame(matrix(ncol = 6, nrow = 0), stringsAsFactors = FALSE) # Already includes uuid and sequencia

# iterate over each node, there is only one node right at this level but we keep it generic if something ever changes.
for (table in node) {
  # Get the name of the table  ie the xml tag/node
  table_name <- xml2::xml_name(table)
  # get the table attributes, the data for the tables is in there.
  table_attrs <- xml2::xml_attrs(table)
  # get the inner nodes of the table, these are the nested tables
  inner_nodes <- xml2::xml_children(table)

  # Loop over the inner nodes/nested tables
  for (inner_table in inner_nodes) {
    # Get the name/tagname of the inner table
    inner_table_name <- xml2::xml_name(inner_table)
    # Get the attributes/data from the inner table
    inner_table_attrs <- xml2::xml_attrs(inner_table)
    # Print out the name and attributes
    print(paste(
      "Table:", inner_table_name,
      ": ", paste(names(inner_table_attrs),
        "values:", inner_table_attrs,
        collapse = ", "
      )
    ))
    # Generate a unique ID for the table
    table_id <- uuid::UUIDgenerate()
    # Every iteration will push the attributes of the inner table to the master table.
    # This table will have the uuid and sequencia.
    TBL_participacao <- rbind(TBL_participacao, c(table_id, inner_table_attrs))

    # Get the children of the 2nd level table and iterate over them
    inner_table_children <- xml2::xml_children(inner_table)
    for (child_table in inner_table_children) {
      # Check if the 2nd level table has children, thats because some of it has a 3rd level table nested inside.

      # If it has no children, we will just print the attributes of the child table
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
        # Push the attributes of the child table to the 2nd level table, each table will have the unique id of the parent table as well as the column "sequencia"
        # Furthermore, each child could have its own attributes, they represent different data, so we will push to individual tables.
        if (grepl("DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA", child_table_name, ignore.case = FALSE)) {
          TBL_dados_basicos <- rbind(TBL_dados_basicos, c(table_id, inner_table_attrs, child_table_attrs))
        } else if (grepl("DETALHAMENTO-DA-PARTICIPACAO-EM-BANCA", child_table_name, ignore.case = FALSE)) {
          TBL_detalhamento <- rbind(TBL_detalhamento, c(table_id, inner_table_attrs, child_table_attrs))
        } else if (child_table_name == "PARTICIPANTE-BANCA") {
          TBL_participantes <- rbind(TBL_participantes, c(table_id, inner_table_attrs, child_table_attrs))
        } else if (child_table_name == "INFORMACOES-ADICIONAIS") {
          TBL_informacoes_adicionais <- rbind(TBL_informacoes_adicionais, c(table_id, inner_table_attrs, child_table_attrs))
        } else if (child_table_name == "SETORES-DE-ATIVIDADE") {
          # This table has 3 attributes, sharing the same name, instead of creating 3 identical columns with different data
          # We will iterate over it and push each column to a new row.
          # This is a workaround to avoid having multiple columns with the same name.
          for (attr in child_table_attrs) {
             # if the attribute is empty, we will skip it
            if (attr == "") next
            TBL_setores_atividades <- rbind(TBL_setores_atividades, c(table_id, inner_table_attrs, attr))
          }
        } else if (child_table_name == "PALAVRAS-CHAVE") {
          # This table also has the same issue, it has 6 atributes representing the same attribute with differente data.
          # We will iterate over it and push each column to a new row.
          for (attr in child_table_attrs) {
            # if the attribute is empty, we will skip it
            if (attr == "") next
            TBL_palavras_chave <- rbind(TBL_palavras_chave, c(table_id, inner_table_attrs, attr))
          }
        }
      } else {
        # if the child has children, drill another level down
        # Get the bottom level child nodes
        child_table_children <- xml2::xml_children(child_table)
        # iterate over them
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
          # Theres only one 3rd level table, but we will check it to keep it safe and generic.
          if (grepl("AREA-DO-CONHECIMENTO", bottom_child_table_name)) {
            TBL_area_conhecimento <- rbind(TBL_area_conhecimento, c(table_id, inner_table_attrs, bottom_child_table_attrs))
          }
        }
      }
    }
  }
}
# Set the column names for each table
colnames(TBL_participacao) <- c("uuid", "sequencia")
colnames(TBL_dados_basicos) <- c("uuid", "sequencia", "natureza", "tipo", "titulo", "ano", "pais", "idioma", "homepage", "DOI", "titulo_ingles")
colnames(TBL_detalhamento) <- c("uuid", "sequencia", "nome_candidato", "codigo_instituicao", "nome_instituicao", "codigo_orgao", "nome_orgao", "codigo_curso", "nome_curso", "nome_curso_ingles")
colnames(TBL_participantes) <- c("uuid", "sequencia", "nome_completo", "nome_citacao", "ordem", "NRO_ID_CNPQ")
colnames(TBL_informacoes_adicionais) <- c("uuid", "sequencia", "descricao", "descricao_ingles")
colnames(TBL_setores_atividades) <- c("uuid", "sequencia", "setor_atividade")
colnames(TBL_palavras_chave) <- c("uuid", "sequencia", "palavra_chave")
colnames(TBL_area_conhecimento) <- c("uuid", "sequencia", "grande_area", "area", "subarea", "especialidade")

# Function to save the tables in the desired format
save_as <- function(format = "csv") {
  if (format == "csv") {
    # Save each table to a csv file
    write.csv(TBL_participacao, "./static/output/TBL_participacao.csv", row.names = FALSE)
    write.csv(TBL_dados_basicos, "./static/output/TBL_dados_basicos.csv", row.names = FALSE)
    write.csv(TBL_detalhamento, "./static/output/TBL_detalhamento.csv", row.names = FALSE)
    write.csv(TBL_participantes, "./static/output/TBL_participantes.csv", row.names = FALSE)
    write.csv(TBL_informacoes_adicionais, "./static/output/TBL_informacoes_adicionais.csv", row.names = FALSE)
    write.csv(TBL_setores_atividades, "./static/output/TBL_setores_atividades.csv", row.names = FALSE)
    write.csv(TBL_palavras_chave, "./static/output/TBL_palavras_chave.csv", row.names = FALSE)
    write.csv(TBL_area_conhecimento, "./static/output/TBL_area_conhecimento.csv", row.names = FALSE)
  } else if (format == "rsqlite") {
    # Save each table to a SQLite database
    db <- DBI::dbConnect(RSQLite::SQLite(), "./static/lattes.db")
    DBI::dbWriteTable(db, "TBL_participacao", TBL_participacao, overwrite = TRUE)
    DBI::dbWriteTable(db, "TBL_dados_basicos", TBL_dados_basicos, overwrite = TRUE)
    DBI::dbWriteTable(db, "TBL_detalhamento", TBL_detalhamento, overwrite = TRUE)
    DBI::dbWriteTable(db, "TBL_participantes", TBL_participantes, overwrite = TRUE)
    DBI::dbWriteTable(db, "TBL_informacoes_adicionais", TBL_informacoes_adicionais, overwrite = TRUE)
    DBI::dbWriteTable(db, "TBL_setores_atividades", TBL_setores_atividades, overwrite = TRUE)
    DBI::dbWriteTable(db, "TBL_palavras_chave", TBL_palavras_chave, overwrite = TRUE)
    DBI::dbWriteTable(db, "TBL_area_conhecimento", TBL_area_conhecimento, overwrite = TRUE)
    # Close the database connection
    DBI::dbDisconnect(db)
  }
}

save_as("csv")  # Save as CSV files
