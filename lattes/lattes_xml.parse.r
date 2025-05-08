if(!library("xml2", lib.loc= "./libs", logical.return=TRUE, quietly=TRUE)){
    install.packages("xml2", lib="./libs", destDir = "./libs", repos = "http://cran.us.r-project.org")
    library("xml2", lib.loc= "./libs", logical.return=TRUE, quietly=TRUE)
}

xml <- read_xml("./static/cv_lattes.xml")
nodes <- xml_children(xml_find_all(xml, ".//PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO"))