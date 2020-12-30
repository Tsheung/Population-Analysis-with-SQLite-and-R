##Goal: Analyzing the top 5 highest populations and the 5 lowest populations within the CIA Factbook Database 

###Loading Packages 
library(RSQLite)
library(DBI)
library(dplyr)
library(ggplot2)

###Connecting to Factbook Database 
getwd()
setwd("C:/Users/Toby/Documents")
connect <- dbConnect(SQLite(), "factbook.db" )
dbListTables(connect)

###Examine First 5 Rows of Facts Table within Factbook
dbGetQuery(connect, "SELECT * from facts LIMIT 5")

###Examine the Min Population within Facts Table 
dbGetQuery(connect, "Name, MIN(Population) from facts")

###Examine the Max Population within Facts Table
dbGetQuery(connect, "SELECT Name, MAX(Population) from facts")

#The results show 'World' as a country and its is considered the max population within the facts table. The population of 'World' is in the negative. It would be best to remove this record within the table so overall table is not affected by this outlier.

###Examine the Min Population Growth within Facts Table
dbGetQuery(connect, "SELECT Name, MIN(population_growth) from facts")

###Examine the Max Population Growth within Facts Table
dbGetQuery(connect, "SELECT Name, MAX(population_growth) from facts")

###Examine Population of Facts Table
dbGetQuery(connect, "SELECT Name, population from facts")

###Removal of 'World' as Population Max
dbGetQuery(connect, "SELECT Name, MAX(Population) from facts WHERE Name IS NOT 'World'")
#China becomes the country with the most people. This is most accurate than when the 'World' was considered the population max.


###Sorting Query to Show Top 5 Largest Populations
dbGetQuery(connect, "SELECT name, population from facts WHERE Name IS NOT 'World' AND population != 0 ORDER BY population DESC LIMIT 5")

ggplot(aes(x= name, y= population), data = mydataframe) + geom_bar(aes(fill = name),stat = 'identity') + ggtitle("Top 5 Countries' Populations of the World") + xlab("Highest Populated Countries") + ylab("Population Number") + scale_fill_discrete(name = "Countries")
#This bar graph shows that China and India has the most populations in the world. The European Union, United States and Indonesia trail behind the top two.


###Growth Rate of 5 of the Largest Populations
dbGetQuery(connect, "SELECT name, population, population_growth from facts WHERE Name IS NOT 'World' AND population != 0 ORDER BY population DESC LIMIT 5")

ggplot(aes(x= name, y = population_growth), data = plot3) + geom_bar(aes(fill = name), stat = 'identity') + ggtitle("Top 5 Growth Rates") + xlab("Highest Populated Countries") + ylab("Population Growth Rate") + scale_fill_discrete(name = "Countries")
#India, Indonesia and the United States have the highest growth rates among the five largest populations.


###Birth Rate of the Top 5 Largest Populations 
dbGetQuery(connect, "SELECT name, birth_rate, population from facts WHERE Name IS NOT 'World' AND population != 0 ORDER BY population DESC LIMIT 5")

ggplot(aes(x= name, y = birth_rate), data = plot5) + geom_bar(aes(fill = name), stat = 'identity') + ggtitle("Birth Rate of Countries") + xlab("Highest Populated Countries") + ylab("Birth Rate") + scale_fill_discrete(name = "Countries")
#Like the first two graphs, India has the highest birth rates. Indonesia, United States and China also have high birth rates. The European Union has the lowest birth rate among the five of them.


###Death Rate of the 5 Largest Populations
dbGetQuery(connect, "SELECT name, death_rate, population from facts WHERE Name IS NOT 'World' AND population != 0 ORDER BY population DESC LIMIT 5")

ggplot(aes(x= name, y = death_rate), data = plot6) + geom_bar(aes(fill = name), stat = 'identity') + ggtitle("Death Rate of Countries") + xlab("Highest Populated Countries") + ylab("Death Rate") + scale_fill_discrete(name = "Countries")
#The European Union has the highest death rate. United States, China and India have death rates trailing behind the EU. Indonesia is has the lowest death rates. 


###Result of the Top 5 Largest Populations
#~India's population will keep increasing due to high growth rate, high birth rates and low death rates

#~Indonesia's population will keep increasing due to high growth rates, high birth rates and low death rates. Currently, it is the fifth largest population in the world. In the future, may reach a higher ranking.  

#~The European Union's population will decrease due to low growth rates, low birth rates and high death rates. Perhaps it would be better to examine the individual countries within the EU instead of grouping them as a whole. 


###Sorting Query to Show 5 Smallest Populations
dbGetQuery(connect, "SELECT name, population from facts WHERE Name IS NOT 'World' AND population != 0 ORDER BY population LIMIT 5")

ggplot(aes(x= name, y= population), data = plot2) + geom_bar(aes(fill = name), stat = 'identity') + ggtitle("Lowest 5 Countries' Population of the World") + xlab("Lowest Populated Countries") + ylab("Population Number") + theme(axis.text.x = element_blank()) + scale_x_discrete(breaks=NULL) + scale_fill_discrete(name = "Countries")
#The Pitcairn Islands and the Cocos (Keeling) Islands have the smallest populations in the world.


###Growth Rate of 5 of the Smallest Populations
dbGetQuery(connect, "SELECT name, population, population_growth from facts WHERE Name IS NOT 'World' AND population != 0 ORDER BY population LIMIT 5")

ggplot(aes(x= name, y= population_growth), data = plot4) + geom_bar(aes(fill = name), stat = 'identity') + ggtitle("Lowest 5 Growth Rates") + xlab("Lowest Populated Countries") + ylab("Population Growth Rate") + theme(axis.text.x = element_blank()) + scale_x_discrete(breaks=NULL) + scale_fill_discrete(name = "Countries")
#Only Niue and Tokelau have data about it growth rates. Holy See (Vatican City), Cocos (Keeling) Islands and Pitcairn Islands do not have data on growth rates. 


###Birthrate of the Lowest 5 Populations
dbGetQuery(connect, "SELECT name, birth_rate, population from facts WHERE NAME IS NOT 'World' AND population != 0 ORDER BY population LIMIT 5")
#None of the five smallest populations have data on birth rates. 

###Death Rate of Lowest 5 Populations
dbGetQuery(connect, "SELECT name, death_rate, population from facts WHERE Name IS NOT 'World' AND population != 0 ORDER BY population LIMIT 5")
#Similarly, none of the populations have data on death rates. 


###Query Newest Lowest 5 Populations with Data on Growth Rates, Birth Rates and Death Rates 
dbGetQuery(connect, "SELECT name, population, birth_rate, death_rate, population_growth from facts WHERE Name IS NOT 'World' AND population != 0 AND birth_rate != 'NA' AND death_Rate != 'NA' AND population_growth != 'NA'ORDER BY population LIMIT 5")

dbGetQuery(connect, "SELECT name, population, birth_rate, death_rate, population_growth from facts WHERE Name IS NOT 'World' AND population != 0 AND birth_rate != 'NA' AND death_Rate != 'NA' AND population_growth != 'NA'ORDER BY population LIMIT 5")
#Since the previous five populations had missing data or no data on growth rate, birth rate or death rate, a new subset of five low populations were queried. These five populations do not have any missing data. These five populations will be considered as the lowest five populations.  


###Population of 5 of the Smallest Populations 
ggplot(aes(x = name, y = population), data = plot7) +geom_bar(aes(fill = name), stat = 'identity') +ggtitle("New Lowest 5 Populations") + xlab("Lowest Populated Countries") + ylab("Population Number") +
  theme(axis.text.x = element_blank()) + scale_x_discrete(breaks = NULL) + scale_fill_discrete(name = "Countries")
#Among the new subset, Nauru and Saint Helena, Ascension, and Tristan de Cunha has the highest population. Falkland Islands (Islas Malvinas) has the smallest population. 


###Population Growth of the 5 Smallest Populations
ggplot(aes(x = name, y = population_growth), data = plot7) +geom_bar(aes(fill = name),stat = 'identity') +ggtitle("New Population Growth") + xlab("Lowest Populated Countries") + ylab("Population Growth Rate") +
  theme(axis.text.x = element_blank()) + scale_x_discrete(breaks = NULL) + scale_fill_discrete(name = "Countries")  
#Represented in graph above, Falkland Islands (Islas Malvina) has the lowest growth rate of 0.01. Saint Helena, Ascension, and Tristan da Cunda is the second lowest population growth rate. Saint Pierre and Miquelon, Nauru are the highest two population growths. 


###Birth Rate of the 5 Smallest Populations
ggplot(aes(x = name, y = birth_rate), data = plot7) +geom_bar(aes(fill = name),stat = 'identity') + ggtitle("Birth Rate of Lowest 5 Countries") + xlab("Lowest Populated Countries") + ylab("Birth Rate") + theme(axis.text.x = element_blank()) + scale_x_discrete(breaks=NULL) + scale_fill_discrete(name = "Countries")
#Interestingly, Saint Pierre and Miquelon has the lowest birth rate. Saint Helena, Ascension, and Tristan da Cunha has the second lowest birth rate. The Falkland Islands (Islas Malvina) does not have the lowest birth rate. Naura has the highest birth rate.  


###Death Rate of the 5 Smallest Populations
ggplot(aes(x = name, y = death_rate), data = plot7) +geom_bar(aes(fill = name),stat = 'identity') +ggtitle("New Lowest 5 Death Rates") + xlab("Lowest Populated Countries") + ylab("Death Rate") + theme(axis.text.x = element_blank()) + scale_x_discrete(breaks=NULL) + scale_fill_discrete(name = "Countries")
#In the graph above, Saint Pierre and Miquelon and Saint Helena, Ascension, and Tristan da Cunhahas the two highest death rates. Falkland Islands (Islas Malvinas) has the lowest death rate. Naura has the death rate second to last.  


###Result of the 5 Smallest Populations
#~Naura has the highest population among the five populations. It has the second highest population growth, highest birth rate and second lowest death rate. Naura will most likely keep growing as a population. 

#~Saint Helena, Ascension, and Tristan da Cunha has the second highest population among the five. But its population growth is the second lowest, the birth rate is also second lowest and has the second highest death rate. It is most likely that Saint Helena, Ascension, and Tristan de Cunha will decrease in population as years past if these rates are constant. 

#~Saint Pierre and Miquelon has interesting rates. It has the lowest birth rates and the highest death rates. But it has the highest population growths. Its current population is in the middle. Even when examining the numbers, its death rate (9.72) is higher than its birth rate (7.42) and its population growth is (1.08). Other factors must be involved with these observations. 

#~Similarly, Falkland Islands (Islas Malvinas) is an interesting statistic. Its birth rate is in the middle (10.90) and death rate is the lowest (4.90). Yet its population growth is (0.01). There must be other factors to explain these observations.  

###Reference
#https://www.cia.gov/library/publications/the-world-factbook/











