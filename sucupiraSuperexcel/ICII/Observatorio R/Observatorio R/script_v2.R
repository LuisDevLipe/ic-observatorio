options(pillar.sigfig = 5)

# setwd(path)
setwd(getwd())
# list excel files in the current directory
files <- list.files(file.path("Sucupira"), pattern = '*.xlsx', full.names = TRUE, recursive = TRUE)
files
excel_file_path <- files[1]
excel_file <- readxl::read_xlsx(excel_file_path)

finf <- file.info(files[1])
date <- as.Date(finf[['mtime']])
print(date)

# row_name <- rownames(excel_file)
col_names <- colnames(excel_file)
sheet_names <- readxl::excel_sheets(excel_file_path)
#class(col_names)
sheets_count <- length(sheet_names)

get_colnames_from_all_sheets <- function (col_names, sheet_names, excel_file_path) {
  col_names <- c()
  for (sheet in sheet_names) {
    temp_excel_file_reader <- readxl::read_excel(excel_file_path, sheet)
    col_names <- c(col_names, colnames(temp_excel_file_reader))
  }
return(col_names)
  
}

all_colnames_unique_filtered <- unique(get_colnames_from_all_sheets(col_names, sheet_names, excel_file_path))

vector_collumn_correspondence <- function(all_sheets_colnames,
                                                                                                                excel_file_path,
                                                                                                                sheet_name) {
  all_sheets_colnames_count <- length(all_sheets_colnames)
  excel_file_reader <- readxl::read_excel(excel_file_path, sheet_name)
  this_sheet_colnames <- colnames(excel_file_reader)
  # inicialmente a função iria adicionar zeros onde não houvesse compatibilidade
  # entretanto por hora será mais fácil inverter a dependência
  # devido ao funcionamento da função match.
  # o código pode ser otimizado, mas por enquanto, está mais legível dessa forma.
  
  # temp_vec <- rep(c(1),each=all_sheets_colnames_count)
  # invertendo o vetor acima...
  match_indicator <- 'presente'
  nomatch_indicator <- '-'
  temp_vec <- rep(c(nomatch_indicator), each = all_sheets_colnames_count)
  
  # será necessário refatorar, e renomear algumas partes do código para ficar coerente...
  for (col_name in this_sheet_colnames) {
    if (col_name %in% all_sheets_colnames) {
      col_pos <- match(col_name, all_sheets_colnames)
      temp_vec[col_pos] <- match_indicator
      next
    } else {
      # não haveria necessidade desse bloco.
      # mas pra mim será importante lembrar da diferença entre as linguagens
      # aqui a declaração next é equivalente ao continue em outras linguagens.
      # serve como documentação...
      next
    }
  }
  vector_for_zeros_at_nomatches_and_ones_at_matched_colnames <- temp_vec
  return(vector_for_zeros_at_nomatches_and_ones_at_matched_colnames)
}

# first_sheet <- create_vector_with_all_colnames_length_with_ones_when_the_colnames_are_present_in_the_current_sheet(all_colnames_unique_filtered,excel_file_path,1)
# second_sheet <- create_vector_with_all_colnames_length_with_ones_when_the_colnames_are_present_in_the_current_sheet(all_colnames_unique_filtered,excel_file_path,2)

# Agora que eu tenho uma função que retorna um vetor indicando as colunas que foram encontradas.
# Eu posso passar por uma função que junta os vetores em uma matriz com a ajuda da função rowbind.
# Após, posso adicionar os nomes das colunas e linhas, com as funções rownames e colnames.
bind_vectors_to_matrix <- function(sheets,
                                                               all_colnames_unique_filtered,
                                                               excel_file_path,
                                                               callback) {
  temp_vec <- c()
  excel_sheets <- sheets
  
  for (sheet in excel_sheets) {
    this_iteration_sheet <- callback(all_colnames_unique_filtered, excel_file_path, sheet)
    temp_vec <- rbind(temp_vec, this_iteration_sheet)
  }
  
  matrix_with_all_sheets <- temp_vec
  return(matrix_with_all_sheets)
  
}
matrix_final <- bind_vectors_to_matrix(
  sheet_names,
  all_colnames_unique_filtered,
  excel_file_path ,
  vector_collumn_correspondence
)
# adicionando o nome das colunas na matriz.
colnames(matrix_final) <- all_colnames_unique_filtered
# criar um dataframe a partir da matriz
# com os nomes das colunas e o nome das linhas e especificar o nome das linhas
tabela_indicando_as_colunas_presentes_em_cada_folha_da_tabela_de_entrada <- data.frame(matrix_final,
                                                                                       row.names = sheet_names)





# salvando em um arquivo xlsx previamente criado.
output_excel_file_path <- 'saida_conferencia_programa.xlsx'
write_to_file <- function (data, filepath) {
  openxlsx::write.xlsx(data,
                       file = filepath,
                       rowNames = TRUE,
                       overwrite = TRUE)
}
write_to_file(
  tabela_indicando_as_colunas_presentes_em_cada_folha_da_tabela_de_entrada,
  output_excel_file_path
)
