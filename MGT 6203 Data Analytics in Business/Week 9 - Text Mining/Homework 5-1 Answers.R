# Set seed for reproducibility
set.seed(31)

# Read data into a dataframe
df <- read.table("C:\\Users\\Clayton\\Documents\\Gatech\\MGT 6203 Data Analytics in Business\\Week 9 - Text Mining\\News.csv", header = TRUE, sep=",")

# Q1
library(tm)
library(SnowballC)
library(topicmodels)
library(wordcloud)

# Q2
corpus = Corpus(DataframeSource(df))

# Q3
clean_corpus = tm_map(corpus, stripWhitespace)
clean_corpus = tm_map(clean_corpus, removePunctuation)
clean_corpus = tm_map(clean_corpus, removeNumbers)
clean_corpus = tm_map(clean_corpus, removeWords, stopwords('english'))
clean_corpus = tm_map(clean_corpus, stemDocument)

# Q4 
dtm = DocumentTermMatrix(clean_corpus, control = list(bounds = list(global = c(3, Inf))))
dim(dtm)
nTerms(dtm)
nDocs(dtm)

## First Dimension is number of documents, second dimension is number of terms

# Q5
set.seed(1000)
tm = LDA(dtm, 20, method='Gibbs', control=list(iter=1000, verbose=50))

# Q6
result = posterior(tm)
beta = result$terms
dim(beta)
beta[, 1:5]
rowSums(beta)

theta = result$topics
dim(theta)
theta[1:5, ]
rowSums(theta)[1:10]

# Q7
terms(tm, 10)

# Q8
as.character(corpus[1082]$content)
barplot(theta[1082, ])
top_terms = sort(beta[4, ], decreasing=TRUE)[1:50]
wordcloud(names(top_terms), top_terms, random.order = FALSE)
top_terms

  