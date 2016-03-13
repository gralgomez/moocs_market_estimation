#MOOCs Market measurement

#install.packages("WDI", dependencies = TRUE)
library(WDI)

#WDIsearch('internet') 

#World Population
# (248 x 4) [1240,] "SPPOPTOTL", "Population, millions"    
data_tot_pop = WDI(indicator="SP.POP.TOTL", start=2014, end=2014) #latest stand 2014
# (248 x 4) [11,] "IT.NET.USER.P3" "Internet users (per 1,000 people)"  

#Internet
#http://www.internetworldstats.com/stats.htm
data_internet100 = as.data.frame(WDI(indicator='IT.NET.USER.P2', country = 'all', start=2014, end=2014)) 
#latest stand 2014 / IT.NET.USER.P2" "Internet users (per 100 people))
# Calculate % and total amount of people in the internet in millions
data_internet100$IT.NET.USER.P2 <- as.numeric(data_internet100$IT.NET.USER.P2)*100 #total internet users

#Literacy
#http://www.uis.unesco.org/literacy/Pages/data-release-map-2013.aspx
# 248 x 4 "SE.ADT.LITR.ZS"       "Literacy rate, adult total (% of people ages 15 and above - 15+)"  
data_literacy = WDI(indicator="SE.ADT.LITR.ZS", start=2005, end=2010) #Not complete(!)


