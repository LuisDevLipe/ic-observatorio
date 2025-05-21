# library("xml2", quietly = TRUE)
library("xmlconvert", quietly = TRUE)

# df <- xml_to_df(file = "./static/cv_lattes.xml", records.tags = "PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO", fields = "tags")
# df

file <- xml2::read_xml("./static/cv_lattes.xml")

xml <- xml2::xml_find_first(file, ".//PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO")
## pegar todos os filhos
# unique(xml2::xml_children(xml))

# Get all the children of a node

extract_children <- function(xml) {
  childs <- list()
  for (i in seq_along(xml2::xml_children(xml))) {
    childs[[i]] <- xml2::xml_name(xml2::xml_children(xml)[[i]])
  }
  return(childs)
}

# get the properties names only
extract_attrs <- function(file, x_path) {
  node <- xml2::xml_find_all(file, x_path)
  attrs <- list()
  for (i in seq_along(node)) {
    attr <- names(xml2::xml_attrs(node[[i]]))
    attrs[[i]] <- attr
  }
  return(attrs)
}

# get all the unique children of the PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO
# unique(extract_children(xml))

# Unique children of the each children node of the PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO
participacao_em_banca_children <- unique(extract_children(xml))
# for (i in seq_along(participacao_em_banca_children)) {
#   child <- participacao_em_banca_children[i]
#   x_path <- paste0(".//", child)
#   print(paste0("Unique children of ", child, ":"))
#   print(unique(extract_children(xml2::xml_find_all(file, x_path))))

# }
participacao_em_banca_children
# Get all the entries of the PARTICIPACAO-EM-BANCA-DE-MESTRADO
# Unique attributes of the DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-MESTRADO
unique(unlist(
  extract_attrs(
    file,
    ".//DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-MESTRADO"
  )
))

# Unique attributs of DETALHAMENTO-DA-PARTICIPACAO-EM-BANCA-DE-MESTRADO
unique(unlist(
  extract_attrs(
    file,
    ".//DETALHAMENTO-DA-PARTICIPACAO-EM-BANCA-DE-MESTRADO"
  )
))
# Unique attributes of the PARTICIPACAO-EM-BANCA-DE-MESTRADO
unique(unlist(
  extract_attrs(
    file,
    ".//PARTICIPACAO-EM-BANCA-DE-MESTRADO"
  )
))

# Unique attributes of the INFORMACOES-ADICIONAIS
unique(unlist(
  extract_attrs(
    file,
    ".//INFORMACOES-ADICIONAIS"
  )
))