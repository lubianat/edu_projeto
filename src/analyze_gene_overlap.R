# install.packages("WikidataR")
library("WikidataR")

# BiocManager::install("GeneOverlap")
library(GeneOverlap)


sparql_query = "
SELECT DISTINCT ?gene ?geneLabel ?disease ?diseaseLabel 
WHERE 
{
  VALUES ?disease { wd:Q41112 wd:Q131755 wd:Q42844}
  ?disease wdt:P2293 | ^wdt:P2293 ?gene .
  SERVICE wikibase:label { bd:serviceParam wikibase:language '[AUTO_LANGUAGE],en'. }
}

"
result <- query_wikidata(sparql_query)

list_of_genes_per_disease = list()

diseases <- unique(result$diseaseLabel)

for (disease in diseases){
  list_of_genes_per_disease[[disease]] <- c()
}


for (i in 1:nrow(result)){
  print(result[i,])
  disease_name <- as.character(result[i,"diseaseLabel"])
  gene_name <- as.character(result[i,"geneLabel"])
  list_of_genes_per_disease[[disease_name]] <- c(gene_name, list_of_genes_per_disease[[disease_name]])
}

gene_overlap_object <- newGOM(list_of_genes_per_disease,
                                      genome.size=20000)


drawHeatmap(gene_overlap_object)
