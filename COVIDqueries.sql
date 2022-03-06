-- check COVIDdeaths data
select *
from COVIDProject..COVIDdeaths
order by 3, 4 -- order by location then date: 3rd and 4th columns in the table


-- check COVIDvaccinations data
select * 
from COVIDProject..COVIDvaccinations
order by 3, 4


--Select data to use
select location, date, total_cases, new_cases, total_deaths, population
from COVIDProject..COVIDdeaths
order by 1,2 -- order by location and date


-- looking at total cases vs total deaths in the UK
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
from COVIDProject..COVIDdeaths
where location like '%kingdom%'
order by 1, 2
-- death rate falls and stabalises around 1% in the UK


-- total cases vs population in the UK
select location, date, total_Cases, population, (total_cases/population)*100 as percentageOfPopInfected
from COVIDProject..COVIDdeaths
where location like '%kingdom%'
order by 2
-- as of january 2022 ~ 22% of the total UK population has been infected with coronavirus
-- might potentally be lower % due to total cases including reinfections 


-- which countries have the highest infection rates?
select location, MAX(total_Cases) as HighestAmountofCases, population, MAX((total_Cases/population))*100 as percentageofPopInfected
from COVIDProject..COVIDdeaths
where population > 50000000 -- filters for larger countries 
-- need to use group by when using aggregate functions such as MAX
group by Location, population
order by percentageofPopInfected desc
-- Andorra has the highest infection rate in the world with nearly 39% of its population having had the virus
-- filtering for countries with population > 50Million, the UK has the highest infection rate


-- which countries have the highest total death counts?
select location, MAX(cast(total_deaths as int)) as totalDeathCount
from COVIDProject..COVIDdeaths
where continent is not null
group by location
order by totalDeathCount desc
-- USA has the highest death count with followed, in order, by: Brazil, India, Russia, Mexico, Peru and the UK


-- which continents have the highest total death counts?
select continent, MAX(cast(total_deaths as int)) as totalDeathCount
from COVIDProject..COVIDdeaths
where continent is not null
Group by continent
order by totalDeathCount desc


-- which countries have the highest mortality rate from COVID (infections / deaths)
select location, MAX(total_cases) as totalCases, MAX(total_deaths) as totalDeaths, (MAX(total_deaths)/MAX(total_cases))*100 as deathRate
from COVIDProject..COVIDdeaths
group by location
order by deathRate desc

-- filtered for large countries, > 50M pop
select location, population, MAX(total_Cases) as totalCases, MAX(total_deaths) as totalDeaths, (MAX(total_deaths)/MAX(total_cases))*100 as deathRate
from COVIDProject..COVIDdeaths
where population > 50000000
group by location, population
order by deathRate desc


-- which countries have the highest % of population killed from COVID
select location, MAX(cast(total_deaths as int)) as totaldeaths, population, MAX((total_deaths/population))*100 as percentageofPopKilled
from COVIDProject..COVIDdeaths
group by location, population
order by percentageofPopKilled desc
-- Peru has the highest death rate in the world with 0.61% of total population killed by coronavirus 
-- results also showing continents, need to filter those out so just countries are shown
select location, MAX(cast(total_deaths as int)) as totaldeaths, population, MAX((total_deaths/population))*100 as percentageofPopKilled
from COVIDProject..COVIDdeaths
where continent is not null -- when location = a continent e.g. location = North America, continent column has null value. continent does NOT have null value when location = a country, therefore this where clause will filter out continents from location column
group by location, population
order by percentageofPopKilled desc
