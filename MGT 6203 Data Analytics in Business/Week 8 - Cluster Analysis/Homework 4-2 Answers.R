# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 8 - Cluster Analysis\\ShoppingVisits.csv", header = TRUE, sep=",")

# Q1
kmeans_model = kmeans(df, centers=3, nstart=20)
kmeans_model

# Q2 
scaled_df = scale(df)
scaled_kmeans_model = kmeans(scaled_df, centers=3, nstart=20)
scaled_kmeans_model

# Q3 
plot(df, col = kmeans_model$cluster)
plot(df, col = scaled_kmeans_model$cluster)

# Q4
## With scaling, the impact/contribution effect of visits is weighted 
## more heavily than unscaled mode

# Q5
scaled_kmeans_2_model = kmeans(scaled_df, centers=2, nstart=20)
scaled_kmeans_4_model = kmeans(scaled_df, centers=4, nstart=20)
scaled_kmeans_5_model = kmeans(scaled_df, centers=5, nstart=20)

# Q6
par(mfrow = c(2,2))

plot(df, col = scaled_kmeans_2_model$cluster)
plot(df, col = scaled_kmeans_model$cluster)
plot(df, col = scaled_kmeans_4_model$cluster)
plot(df, col = scaled_kmeans_5_model$cluster)

# Q7
## 5 clusters look the most appropriate with clear distinction of points between clusters

# Q8
library(cluster)
library(factoextra)
fviz_nbclust(scaled_df, kmeans, method = "wss", k.max=5)

# Q9
## 3 clusters, the elbow seems to be the most prominent there

# Q10
library(ggplot2)
library(ggdendro)
hclust_avg_model <- hclust(dist(scaled_df, method='euclidean'), method='average')

par(mfrow = c(1,1))
ggdendrogram(hclust_avg_model, rotate = FALSE, size = 2)
abline(h=1.8, col="red", lty=1)

# Q11
cutree(hclust_avg_model, k = 3)

# Q12
par(mfrow = c(1,2))
plot(df, col=scaled_kmeans_model$cluster, pch=20, main=paste('k-means with 3 clusters'))
plot(df, col=cutree(hclust_avg_model, k=3), pch=20, main=paste('hclust with 3 clusters (Average Linkage)'))

# Q13 
## Hierarchical clustering is less robust as clusters will change depending 
## on the distance and linkage measures chosen

# Q14
hclust_complete_model <- hclust(dist(scaled_df, method='euclidean'), method='complete')
hclust_single_model <- hclust(dist(scaled_df, method='euclidean'), method='single')
hclust_centroid_model <- hclust(dist(scaled_df, method='euclidean'), method='centroid')

par(mfrow = c(2,2))
plot(df, col=cutree(hclust_avg_model, k=3), pch=20, main=paste('Average'))
plot(df, col=cutree(hclust_complete_model, k=3), pch=20, main=paste('Complete'))
plot(df, col=cutree(hclust_single_model, k=3), pch=20, main=paste('Single'))
plot(df, col=cutree(hclust_centroid_model, k=3), pch=20, main=paste('Centroid'))

# Q15
## No they are not robust
## Single linkage has the least reasonable result as it only takes the
## closest distances between clusters

# Q16
## hierarchical clustering (average linkage) 3 clusters
## top-left: Large basket shoppers
## top-right: Frequent shoppers
## bottom: Low spending shoppers

# Q17
## Target Large basket shoppers, each visit the marketing efforts can 
## induce will result in a higher basket spend & therefore, revenue

