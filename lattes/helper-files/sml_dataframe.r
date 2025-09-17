library("xml2", "xmlconvert", quietly = TRUE)

file <- xml2::read_xml("./static/test.xml")

persons <- xml2::xml_find_all(file, ".//Mestrado")

# print(persons)

for (i in seq_along(persons)) {
    person_data <- xml2::as_list(persons[[i]])
    sequencia <- c(names(person_data), attributes(person_data)$sequencia)
    # print(person_data)
    print(names(person_data))
    data_fields <- names(person_data)
    for (i in seq_along(data_fields)) {
        df <- xmlconvert::xml_to_df(
            persons[[i]],
            fields = "attributes",
            records.tags = data_fields[i],
        )
    }
}
