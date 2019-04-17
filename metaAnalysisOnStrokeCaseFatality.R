library(gdata)
library(meta)

cleanedData = read.xls("/Users/burke/Documents/research/bpCog/nhanes/strokeCaseFatalityWorksheet.xlsx")
cleanedData$nEvent = trunc(cleanedData$mortality * cleanedData$N)
cleanedData = head(cleanedData,-1)

propMortality <- metaprop(event=nEvent, n=N, studlab=Study, data=cleanedData)
forest(propMortality)
