# library("xml2", quietly = TRUE)
library("xmlconvert", quietly = TRUE)

# df <- xml_to_df(file = "./static/cv_lattes.xml", records.tags = "PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO", fields = "tags")
# df

file <- xml2::read_xml("./static/cv_lattes.xml")

xml <- xml2::xml_find_first(file, ".//PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO")
## pegar todos os filhos
# unique(xml2::xml_children(xml))

# get all the unique children of the PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO
childs <- list()

for (i in 1:length(xml2::xml_children(xml))) {
  child <- xml2::xml_children(xml)[[i]]
  childs[[i]] <- xml2::xml_name(child)
}
unique(childs)

# Get all the entries of the PARTICIPACAO-EM-BANCA-DE-MESTRADO
dados_basicos_mestrado <- xml2::xml_find_all(file, ".//DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-MESTRADO")
dados_basicos_mestrado_attrs <- list()
# get only the properties names only
for (i in seq_along(dados_basicos_mestrado)) {
  attrs <- names(xml2::xml_attrs(dados_basicos_mestrado[[i]]))
  dados_basicos_mestrado_attrs[[i]] <- attrs
}
# Unique attributes of the DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-MESTRADO
# unique(unlist(dados_basicos_mestrado_attrs))


# get all the entries of the DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-DOUTORADO
dados_basicos_doutorado <- xml2::xml_find_all(file, ".//DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-DOUTORADO")
dados_basicos_doutorado_attrs <- list()

# get only the properties names only
for (i in seq_along(dados_basicos_doutorado)) {
  attrs <- names(xml2::xml_attrs(dados_basicos_doutorado[[i]]))
  dados_basicos_doutorado_attrs[[i]] <- attrs
}

# Unique attributes of the DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-DOUTORADO
# unique(unlist(dados_basicos_doutorado_attrs))


# get all the entries of the PARTICIPACAO-EM-BANCA-DE-EXAME-QUALIFICACAO

dados_basicos_exame_qualificacao <- xml2::xml_find_all(file, ".//DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-EXAME-QUALIFICACAO")
dados_basicos_exame_qualificacao_attrs <- list()
# get only the properties names only
for (i in seq_along(dados_basicos_exame_qualificacao)) {
  attrs <- names(xml2::xml_attrs(dados_basicos_exame_qualificacao[[i]]))
  dados_basicos_exame_qualificacao_attrs[[i]] <- attrs
}
# Unique attributes of the DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-EXAME-QUALIFICACAO
unique(unlist(dados_basicos_exame_qualificacao_attrs))


# get all the entries of the PARTICIPACAO-EM-BANCA-DE-APERFEICOAMENTO-ESPECIALIZACAO
dados_basicos_aperfeicoamento <- xml2::xml_find_all(file, ".//DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-APERFEICOAMENTO-ESPECIALIZACAO")
dados_basicos_aperfeicoamento_attrs <- list()
# get only the properties names only
for (i in seq_along(dados_basicos_aperfeicoamento)) {
  attrs <- names(xml2::xml_attrs(dados_basicos_aperfeicoamento[[i]]))
  dados_basicos_aperfeicoamento_attrs[[i]] <- attrs
}
# Unique attributes of the DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-APERFEICOAMENTO-ESPECIALIZACAO
unique(unlist(dados_basicos_aperfeicoamento_attrs))

