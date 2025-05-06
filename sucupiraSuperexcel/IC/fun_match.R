# função match()
v1 <- c('a','b','c','b')
v1
b <- c('b')

v_of_b_matches <- match(b,v1)
v_of_b_matches
# operador %in%

c <- b %in% v1
c