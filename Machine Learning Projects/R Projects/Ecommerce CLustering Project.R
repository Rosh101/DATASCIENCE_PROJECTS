#Selecting working Directory in my pc
setwd(choose.dir())
#Confirming the working directory path where Ecommrce Data Lies
getwd()

#install.packages("factoextra")--->example of installing necessary Libraries)
#Loading necessary Libraries
library(dplyr)
library(ggplot2)
library(cluster)
library(factoextra)
library(gridExtra)
library(purrr)

#Importing dataset from current working directory
data_ecom = read.csv("Ecommerce.csv")

#Viewing Dataset
View(data_ecom)
#Viewing first 6 rows of dataset in the console
head(data_ecom)

#Structure of the dataset
str(data_ecom)
#There is unnecessary column X with NA Values, Lets drop it
data_ecom <- subset(data_ecom,select=-X)

#We also saw  date data in the character format,lets change it to Date format
data_ecom$InvoiceDate <- as.Date(data_ecom$InvoiceDate, "%d-%B-%y")

#Lets recheck the columns and their structure, and view it again
str(data_ecom)
View(data_ecom)
# We can still see the NA values in the data, lets see its weight
na_count <-colSums(is.na(data_ecom))
na_count

# We have 135,080 missing Customer ID whcih is unique identifier.
# At this point, it's better to omit the data as we can't tag this transaction to right specific customer.
na.omit(data_ecom)

#Summary statistics of the dataset
summary(data_ecom)

#TotalSales & TotalUnitSales purchase by each customer
customerData <- data_ecom %>%
  select(CustomerID, Country, Quantity, UnitPrice) %>%
  group_by(CustomerID, Country) %>%
  summarise(TotalRevenue = sum(Quantity * UnitPrice),
            TotalItemsSold = sum(Quantity),
            .groups = 'drop')
View(customerData)

##TOPHIghly Valued Customers based on Revenue Generated
top_customers <- customerData %>% 
  arrange(desc(TotalRevenue)) %>% 
  slice(1:20)
View(top_customers)


#We remove CustomerID and Country Columns as these features are of Less Importance/ can result multicollinearity issue in analysis.
customerData <- customerData[-c(1:2)]

#Finding and Sorting Outliers
boxplot(customerData)

#Eliminating the outliers
library(dplyr)

customerData <- customerData %>%
  filter(between(TotalRevenue, quantile(TotalRevenue, 0.25) - 1.5 * IQR(TotalRevenue),
                 quantile(TotalRevenue, 0.75) + 1.5 * IQR(TotalRevenue))) %>%
  filter(between(TotalItemsSold, quantile(TotalItemsSold, 0.25) - 1.5 * IQR(TotalItemsSold),
                 quantile(TotalItemsSold, 0.75) + 1.5 * IQR(TotalItemsSold)))

#Lets Normalize the data as Sales Amount and Sales Units value has huge diff to compare without scaling
customerData_sc <-scale(customerData)
View(customerData_sc)

##KMeans Clustering
set.seed(42)

#Let's group the data into 5 cluster with k-means
km <-kmeans(customerData_sc,centers=5)
km
km$size

#Determining optimal clusters with Elbow Mwthod
set.seed(42)

# Compute total within-cluster sum of squares for k=1 to 10
wss_values <- map_dbl(1:10, ~kmeans(customerData_sc, ., nstart = 10)$tot.withinss)

# Plot WSS values vs. number of clusters
plot(1:10, wss_values, type = "b", pch = 19, frame = FALSE, 
     xlab = "Number of clusters (k)", ylab = "Total within-cluster sum of squares (WSS)")

###Looking at the plot we can say as per our K means graph 3 is the optimal number of clusters.
km <-kmeans(customerData_sc,centers=3)
km
km$size
str(km)

#Creating new column to specify the cluster
customerData_km <- cbind(customerData_sc,ClusterNum = km$cluster)
View(customerData_km)
     
#So, with k =3 , KMeans model is 81.6% confident to group new data to into distinct cluster.


##Hierarchical Clustering
cluster_h <- dist(customerData_Sc,method = "euclidian")
fit <- hclust(cluster_h,method = "ward.D")
groups <- cutree(fit, k = 3)
groups_factor <- as.factor(groups)
customerData_Hier <- cbind(customerData_sc, ClusterNum = groups_factor)
View(customerData_Hier)

# Dendogram
plot(fit)

# Silhouette analysis
silhouette <- silhouette(groups_factor, dist(customerData_Hier))
silhouette_df <- summary(silhouette)
silhouette_df$avg.width


###Identify the clustering algorithm that gives maximum accuracy and explains robust clusters.
#silhouette_df$avg.width is '0.499' which is positive and close to 1. 
#Hierarchical model could be furthered improved by changing the value of K.
#KMeans model with value of k=3 gives maximum accuracy, and is 81.6% confident to cluster new data to the similar clusters.
#Since, Kmeans of 3 provides the better customer clustering and should be considered to roll out the loyalty program.

View(customerData_km)

customerData_km <- as_tibble(customerData_km)

customerData_km <- customerData_km %>%
  mutate(TotalRevenue = TotalRevenue * sd(customerData$TotalRevenue) + mean(customerData$TotalRevenue),
         TotalItemsSold = TotalItemsSold * sd(customerData$TotalItemsSold) + mean(customerData$TotalItemsSold))
