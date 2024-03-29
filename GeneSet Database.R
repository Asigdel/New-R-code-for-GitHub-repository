## Analysis bosTau annotation: GO


library(biomaRt)

database = useMart("ensembl")

genome = useDataset("btaurus_gene_ensembl", mart = database)

gene = getBM(c("ensembl_gene_id", "external_gene_name","go_id","name_1006"), mart = genome)

dim(gene); length(unique(gene$ensembl_gene_id)); length(unique(gene$go_id))


goName = unique(gene[,c(3,4)])

goName = goName[order(goName$go_id),]

goName = goName[-1,]


GO = goName$go_id

Name = goName$name_1006

genesGO = unique(subset(gene,go_id != "")$ensembl_gene_id)

N = length(total.genes[total.genes %in% genesGO])

S = length(sig.genes[sig.genes %in% genesGO])

out = data.frame(GO=character(),Name=character(),totalG=numeric(),sigG=numeric(),Pvalue=numeric())


for(i in 1:length(GO)){
  
  gENEs = subset(gene, go_id == GO[i])$ensembl_gene_id 
  
  m = length(total.genes[total.genes %in% gENEs])
  
  s = length(sig.genes[sig.genes %in% gENEs])
  
  M = matrix(c(s,S-s,m-s,N-m-S+s),byrow = 2, nrow = 2)
  
  Pval = round(fisher.test(M, alternative ="g")$p.value, digits = 3)
  
  tmp = data.frame(GO = GO[i], Name = Name[i], totalG = m, sigG = s, Pvalue = Pval)
  
  out = rbind(out,tmp)}


ot = subset(out,totalG > 4 & Pvalue < 0.05)

final = ot[order(ot$Pvalue),]