## 0: Load the data in RStudio

# See where the working directory currently is
getwd()

# Set the working directory to the folder containing my dataset, and set df equal to the dataset
setwd("C:/Users/flippinuke/Desktop/Springboard")
df <- read.csv("refine_original.csv")
View(df)

## 1: Clean up brand names

# Make all strings lower case in df
df = as.data.frame(sapply(df, tolower))

# Set all columns with text to a character structure
df[, 1:6] <- sapply(df[, 1:6], as.character)

# Cut character strings in "Company" to only the first character
df$company <- strtrim(df$company, 1)

# In column "Company," based on first letter, transform to correct spelling of company names
df$company[df$company == "f"] <- "philips"
df$company[df$company == "p"] <- "philips"
df$company[df$company == "a"] <- "akzo"
df$company[df$company == "v"] <- "van houten"
df$company[df$company == "u"] <- "unilever"

## 2: Separate product code and number

df2 <- df %>% separate(Product.code...number, c("product_code", "product_number"))

## 3: Add product categories:

# Add column product_category, which currently will contain same values as product_code
# Interesting Note: Line 38 needs to be run twice. If you run it once, lines 41-44 produce an error when you run it.
# ... you can run line 38 twice in a row. Alternatively, run it once, then run lines 41-44 to see the error, and then run 38, 41:44 again and continue.
df2 <- transform(df2, product_category = product_code)

# transform again, as we did with the company columns earlier
df2$product_category[df2$product_category == "p"] <- "Smartphone"
df2$product_category[df2$product_category == "v"] <- "TV"
df2$product_category[df2$product_category == "x"] <- "Laptop"
df2$product_category[df2$product_category == "q"] <- "Tablet"

## 4: Add full address for geocoding

df3 <- unite(df2, "full_address", address, city, country, sep = ", ")
View(df3)

## 5: Create dummy variables for company and product category

# Add eight new columns using transform, set equal to either company or product code
df4 <- transform(df3, company_philips = company, company_akzo = company, 
                 company_van_houten = company, company_unilever = company, 
                 product_smartphone = product_code, product_tv = product_code, 
                 product_laptop = product_code, product_tablet = product_code)
# We see that new variables have been created as Factors

# Change newly created variables from Factors to characters using:
df4[, 7:14] <- sapply(df4[, 7:14], as.character)
# otherwise, the following code won't work:

# Set variables equal to either 1 or 0
df4$company_philips[df4$company_philips == "philips"] <- 1
df4$company_philips[df4$company_philips != "1"] <- 0

df4$company_akzo[df4$company_akzo == "akzo"] <- 1
df4$company_akzo[df4$company_akzo != "1"] <- 0

df4$company_van_houten[df4$company_van_houten == "van houten"] <- 1
df4$company_van_houten[df4$company_van_houten != "1"] <- 0

df4$company_unilever[df4$company_unilever == "unilever"] <- 1
df4$company_unilever[df4$company_unilever != "1"] <- 0

df4$product_smartphone[df4$product_smartphone == "p"] <- 1
df4$product_smartphone[df4$product_smartphone != "1"] <- 0

df4$product_tv[df4$product_tv == "v"] <- 1
df4$product_tv[df4$product_tv != "1"] <- 0

df4$product_laptop[df4$product_laptop == "x"] <- 1
df4$product_laptop[df4$product_laptop != "1"] <- 0

df4$product_tablet[df4$product_tablet == "q"] <- 1
df4$product_tablet[df4$product_tablet != "1"] <- 0

# Since it just makes sense, I turned columns 7:14 from type character to type integer
df4[, 7:14] <- sapply(df4[, 7:14], as.integer)
View(df4)
