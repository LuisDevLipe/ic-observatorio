# cbind()
v1 <- c(1,2,3)
v1
v2 <- c('a','b','c')
v2

v_binded <- rbind(v1,v2)
v_binded

colnames_for_v_binded <- c('c1','c2','c3')

colnames(v_binded) <- colnames_for_v_binded
v_binded

