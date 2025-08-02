own_list <- list('Luis', 'Felipe')
names(own_list) <- c('first_name', 'last_name')
own_vector <- c('Luis', 'Felipe')
names(own_vector) <- c('first_name', 'last_name')

print(own_list)
print(own_vector)
print('--------------')
print(names(own_list))
print(names(own_vector))
print('--------------')
print('first_name' %in% names(own_list))
print('first_name' %in% names(own_vector))
print('---------------')

added_own_list <- append(own_list, 'New Value', after = 1)
names(added_own_list)[2] <- 'added_key'
added_own_vector <- append(own_vector, 'New Value', after = 1)
names(added_own_vector)[2] <- 'added_key'
print(added_own_list)
print(added_own_vector)