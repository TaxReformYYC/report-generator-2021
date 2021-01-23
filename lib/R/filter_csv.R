
# How do this factors impact an assessment?
unknownImpact <- c('Taxation.Status', 'Assessment.Class',
                   'Property.Type', 'Property.Use', 'Valuation.Approach',
                   'Market.Adjustment', 'Community', 'Market.Area', 'Sub.Neighbourhood.Code..SNC.',
                   'Sub.Market.Area', 'Influences', 'Land.Use.Designation', 'Building.Count',
                   'Building.Type.Structure', 'Year.of.Construction', 'Quality',
                   'Garage.Type', 'Features')


# These factors don't directly affect the assessment
noImpact <- c('Roll.Number', 'Location.Address')

# Load data
csvFile <- commandArgs(trailingOnly = TRUE)
data <- read.csv(csvFile, header=TRUE)

# Identify common factors
headers <- c()
identical <- c()
for (col in colnames(data)) {
  values = data[,col][!duplicated(data[,col])]
  if (length(values) == 1) {
    headers <- append(headers, col)
    identical <- append(identical, toString(values))
  }
}
commonFactors <- data.frame(headers, identical)

# Remove common factors
data <- data[,!(names(data) %in% commonFactors$headers)]

# Identify unknown factors
unknownFactors <- names(data[,names(data) %in% unknownImpact])

# Remove unknown factors from data set
data <- data[,!(names(data) %in% unknownFactors)]

# Remove irrelevant factors from data set, but preserve address for plot labels
rowNames <- data[,noImpact[2]]
data <- data[,!(names(data) %in% noImpact)]

# Label assessment records
rownames(data) <- rowNames

# Sum each property's lot size and total developed space
areaTotals <- rowSums(data[,-1])

# Isolate all assessed values
assessedValues <- data[,1]

# Remove the street names from the addresses
houseNumbers <- as.numeric(gsub("[^\\d]+", "", rowNames, perl=TRUE))

# Plot the best fit regression line
reg <- lm(assessedValues~areaTotals)

# Plot distances between points and the regression line
assessedDifferences <- residuals(reg)
adjustedValues <- predict(reg)

# Reconcile adjusted property values
discrepancies <- round(assessedDifferences/assessedValues*100, 2)
adjustedProperties <- data.frame(houseNumbers, assessedValues, adjustedValues, assessedDifferences, discrepancies)

print(adjustedProperties)
