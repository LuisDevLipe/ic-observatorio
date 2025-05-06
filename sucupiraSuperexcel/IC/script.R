path <- "~/'Área de trabalho'/rstudio/IC"

options(pillar.sigfig = 5)
library('readxl')
excel_file_path <- 'conferencia_programa.xlsx'
excel_file <- read_excel(excel_file_path)

# row_name <- rownames(excel_file)
col_names <- colnames(excel_file)
sheet_names <- excel_sheets(excel_file_path)
#class(col_names)
sheets_count <- length(sheet_names)

get_colnames_from_all_sheets <- function (col_names, sheet_names, excel_file_path){
  col_names <- c()
  for(sheet in sheet_names){
    temp_excel_file_reader <-read_excel(excel_file_path, sheet)
    col_names <- c(col_names, colnames(temp_excel_file_reader))
  }
  unique_colnames_filter <- unique(col_names)
  return(unique_colnames_filter)
}

all_colnames_unique_filtered <- get_colnames_from_all_sheets(col_names, sheet_names, excel_file_path)

create_vector_with_all_colnames_length_with_ones_when_the_colnames_are_present_in_the_current_sheet <- function(all_sheets_colnames,excel_file_path,sheet_name){
  all_sheets_colnames_count <- length(all_sheets_colnames)
  excel_file_reader <- read_excel(excel_file_path, sheet_name)
  this_sheet_colnames <- colnames(excel_file_reader)
  # inicialmente a função iria adicionar zeros onde não houvesse compatibilidade
  # entretanto por hora será mais fácil inverter a dependência
  # devido ao funcionamento da função match.
  # o código pode ser otimizado, mas por enquanto, está mais legível dessa forma.
  
  # temp_vec <- rep(c(1),each=all_sheets_colnames_count)
  # invertendo o vetor acima...
  match_indicator <- 'presente'
  nomatch_indicator <- '-'
  temp_vec <- rep(c(nomatch_indicator), each=all_sheets_colnames_count)
  
  # será necessário refatorar, e renomear algumas partes do código para ficar coerente...
  for(col_name in this_sheet_colnames){
    if(col_name %in% all_sheets_colnames) {
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
bind_all_matched_vectors_of_all_sheets_in_a_matrix <- function(sheets,all_colnames_unique_filtered,excel_file_path,callback) {
  
  temp_vec <- c()
  excel_sheets <- sheets
  
  for(sheet in excel_sheets){
    this_iteration_sheet <- create_vector_with_all_colnames_length_with_ones_when_the_colnames_are_present_in_the_current_sheet(all_colnames_unique_filtered,excel_file_path,sheet)
    temp_vec <- rbind(temp_vec,this_iteration_sheet)
  }

  matrix_with_all_sheets <- temp_vec
  return(matrix_with_all_sheets)

}
matrix_with_all_sheets_sep_by_sheet_name_and_collumns <- bind_all_matched_vectors_of_all_sheets_in_a_matrix(sheet_names,all_colnames_unique_filtered,excel_file_path ,create_vector_with_all_colnames_length_with_ones_when_the_colnames_are_present_in_the_current_sheet())
# adicionando o nome das colunas na matriz.
colnames(matrix_with_all_sheets_sep_by_sheet_name_and_collumns) <- all_colnames_unique_filtered
# criar um dataframe a partir da matriz
# com os nomes das colunas e o nome das linhas e especificar o nome das linhas
tabela_indicando_as_colunas_presentes_em_cada_folha_da_tabela_de_entrada <- data.frame(matrix_with_all_sheets_sep_by_sheet_name_and_collumns,row.names = sheet_names)

# salvando em um arquivo xlsx previamente criado.
output_excel_file_path <- 'saida_conferencia_programa.xlsx'
write_to_file <- function (data,filepath){
  library('openxlsx')
    
  write.xlsx(data,
             file=filepath,
             rowNames=TRUE,
             overwrite=TRUE)
}
# write_to_file(tabela_indicando_as_colunas_presentes_em_cada_folha_da_tabela_de_entrada,excel_file_path)