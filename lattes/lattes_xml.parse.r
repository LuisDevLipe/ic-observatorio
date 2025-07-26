# install.packages(c("curl", "xml2", "xmlconvert"), repos = "https://cloud.r-project.org/")j
library("xml2", quietly = TRUE)
library("xmlconvert", quietly = TRUE)

# df <- xml_to_df(file = "./static/cv_lattes.xml", records.tags = "PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO", fields = "tags")
# df

# file <- xml2::read_xml("./static/cv_lattes.xml")
file <- xml2::read_xml("./static/test.xml")

# xml <- xml2::xml_find_first(file, ".//PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO")
xml <- xml2::xml_find_first(file, ".//Participacao")
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
x_paths <- c()
for (i in seq_along(participacao_em_banca_children)) {
  x_paths[i] <- paste0(".//", participacao_em_banca_children[[i]])
}

attrs <- c()
children <- c()
for (i in seq_along(x_paths)) {
  x_path <- x_paths[i]
  attrs <- unique(extract_attrs(file, x_path))
  children <- unique(extract_children(xml2::xml_find_all(file, x_path)))
}

for (i in seq_along(x_paths)) {
  x_path <- x_paths[i]
  attrs <- unique(extract_attrs(file, x_path))
  print("-----------------------------------")
  print(paste0("attrs of ", x_path, ": "))
  print(paste(attrs, collapse = ", "))
  for (j in seq_along(children)) {
    child_x_path <- paste0(x_path, "/", children[j])
    current_x_path_children <- unique(extract_children(xml2::xml_find_all(file, child_x_path)))
    attrs <- unique(extract_attrs(file, child_x_path))
    print(paste0("attrs of child ", children[i], ": "))
    if (length(attrs) == 0) {
      print("No attributes found")
    } else {
      print(paste(attrs, collapse = ", ", recycle0 = FALSE))
    }
    if (length(current_x_path_children > 0)) {
      for (k in seq_along(current_x_path_children)) {
        grandchild_x_path <- paste0(child_x_path, "/", current_x_path_children[k])
        grandchild_attrs <- unique(extract_attrs(file, grandchild_x_path))
        print(paste0("attrs of grandchild ", grandchild_x_path, ": ", paste(grandchild_attrs, collapse = ", ")))
      }
    }
  }
  print("-----------------------------------")
}
print("++++++++++++++++++++++++++++++++++++++++=")
node <- xml2::xml_find_first(file, "//Participacao")
node_children <- xml2::xml_children(node)
# print(paste("Children of the Participacao node: ", node_children))
for (i in seq_along(node_children)) {
  attrs <- xml2::xml_attrs(node_children[[i]])
  print(paste(names(attrs), attrs, sep = ": "))
  for (j in seq_along(attrs)) {
    j_children <- xml2::xml_children(xml2::xml_fin)
    j_attrs <- xml2::xml_attrs(j_children)
    print(paste(names(j_attrs), j_attrs, sep = ": "))
  }
}
# Example usage
# df <- xmlconvert::xml_to_df(
#   file = "./static/cv_lattes.xml",
#   records.tags = "PARTICIPACAO-EM-BANCA-DE-MESTRADO",
#   fields = c("DADOS-BASICOS-DA-PARTICIPACAO-EM-BANCA-DE-MESTRADO", "DETALHAMENTO-DA-PARTICIPACAO-EM-BANCA-DE-MESTRADO", "INFORMACOES-ADICIONAIS")
# )
