#MOOCs Market measurement
setwd("~/Documents/Uni/MasterThesis/R")

library(WDI)
library(countrycode)
library(plyr)

# (Urban) World Population (TOT) ,(%)
#----------------------------------------------------------------------------
# data_tot_pop = WDI(indicator="SP.POP.TOTL", start=2014, end=2014) #latest stand 2014

# Urban Population (%)
urban_pop_tot = WDI(indicator = "SP.URB.TOTL", start = 2014, end = 2014)
urban_pop_rate = WDI(indicator = "SP.URB.TOTL.IN.ZS", start = 2014, end = 2014)# (%)SP.URB.TOTL.IN.ZS
urban_pop = merge(urban_pop_tot, urban_pop_rate, by = c("iso2c","country", "year"))

# Internet Penetration Rate (%)
#----------------------------------------------------------------------------
# WDI 2013 - Wikipedia - (https://en.wikipedia.org/wiki/List_of_countries_by_number_of_Internet_users)
wdi.internet.penetration <- as.data.frame(read.csv("~/Documents/Uni/MasterThesis/R/World_Internet_Penetration_index_2013.csv"))
#wdi.internet.penetration <- rename(wdi.internet.penetration, c("Country" = "country"))
wdi.internet.penetration$iso2c <- countrycode(wdi.internet.penetration$country, "country.name", "iso2c")

# Other Internet penetration figures
#----------------------------------------------------------------------------
# http://www.internetworldstats.com/stats.htm
#                                       WDI
# latest stand 2014 / IT.NET.USER.P2" "Internet users (per 100 people))
# data_internet100 = as.data.frame(WDI(indicator='IT.NET.USER.P2', country = 'all', start=2014, end=2014)) 
#                                       ITU
# http://www.itu.int/en/ITU-D/Statistics/Pages/stat/default.aspx
# individuals_internet.itu <- read.csv("~/Documents/Uni/MasterThesis/R/Individuals_Internet_2000-2014.csv")
# individuals_internet.itu$iso2c <- countrycode(individuals_internet.itu$X, "country.name", "iso2c")
#----------------------------------------------------------------------------

# Literacy Rate (%)
#----------------------------------------------------------------------------
# WDI data_literacy = WDI(indicator="SE.ADT.LITR.ZS", start=2010, end=2010) #Not complete(!)
# OECD countries not documented at the UNESCO report - check http://skills.oecd.org/skillsoutlook.html

# UNESCO - literacy 15+ both sexes 2015 (source: http://data.uis.unesco.org/) - Data extracted on 14 Mar 2016 12:25 UTC (GMT) from UIS.Stat
unesco.literacy <- as.data.frame(read.csv("~/Documents/Uni/MasterThesis/R/UNICEF_literacy_rate_15p_2015.csv", header = TRUE))
unesco.literacy <- rename(unesco.literacy, c("Country" = "country"))
unesco.literacy$iso2c <- countrycode(unesco.literacy$country, "country.name", "iso2c")

# English Proficency (Score)
#----------------------------------------------------------------------------
# EF EI - http://www.ef.edu/epi/
# Check also for Europe https://crell.jrc.ec.europa.eu/?q=article/eslc-database
# Some values have been inserted based on assumptions, For instance native speaking countries will be annotated wit hthe max value 
#and those listed as de_jure EN speaking countries with EN as no primary language will be annotated with the mean value
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 37.86   49.47   56.76   57.70   70.94   70.94      34 

en.proficency <- read.csv("~/Documents/Uni/MasterThesis/R/World_EN_proficency_index_2014-15.csv", header = TRUE)
en.proficency <- rename(en.proficency, c("Country" = "country"))
en.proficency$iso2c <- countrycode(en.proficency$country, "country.name", "iso2c")
en.proficency$EN_de_jure_pop <- NULL

# English - World English Speaking Index -
en.speakers <- read.csv("~/Documents/Uni/MasterThesis/R/World_EN_speaking_index.csv", header = TRUE, strip.white = TRUE)
en.speakers$iso2c <- countrycode(en.speakers$country, "country.name", "iso2c")
en.speakers$X <- NULL
en.speakers$X.1 <- NULL
en.speakers$iso2c.1 <- NULL
en.speakers$Notes <- NULL

en.overall <- merge(en.proficency, en.speakers, by = c("iso2c","country"), all.y = TRUE)
en.overall$Region <- countrycode(en.overall$country, "country.name", "region")
en.overall <- en.overall[,c(1,2,3,7,8,9,10,11,4,5,6)]

# Agreggating
#----------------------------------------------------------------------------
# Aggreagting data over their iso2c code which is standard.

# Urban Population (%) + Literacy rate (%) [241 x 5]
mooc.estimate.edu <- merge(urban_pop, unesco.literacy, by = c("iso2c","country"), all.y = TRUE)
mooc.estimate.edu$year <- NULL
mooc.estimate.edu <- mooc.estimate.edu[!(is.na(mooc.estimate.edu$iso2c) | mooc.estimate.edu$iso2c==""), ]

# Internet Penetration rate (%) + EN proficency (score) [214 x 10]
mooc.estimate.con <- merge(wdi.internet.penetration, en.proficency, by = c("iso2c","country"), all.x = TRUE)
mooc.estimate.con <- mooc.estimate.con[!(is.na(mooc.estimate.con$iso2c) | mooc.estimate.con$iso2c==""), ]

# MOOC Estimate Edu + MOOC Estimate Con [214 x 13]
mooc.estimate <- merge(mooc.estimate.con, mooc.estimate.edu, by = c("iso2c", "country"), all.x = TRUE)
mooc.estimate$Region <- countrycode(mooc.estimate$iso2c, "iso2c", "region")
mooc.estimate$Continent <- countrycode(mooc.estimate$iso2c, "iso2c", "continent")
mooc.estimate <- mooc.estimate[,c(1,2,7,14,11,12,3,4,5,6,13,8,9,10)]
