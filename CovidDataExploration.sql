SELECT *
FROM [Portfolio Project Covid]..COVIDDEATHS
ORDER BY 3,4 --location and date

--SELECT *
--FROM [Portfolio Project Covid]..CovidVaccinations
--ORDER BY 3,4 -- location and date

--Select data used in exploration

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project Covid]..[CovidDeaths]
Order by 1,2 -- iso_code and Country

--Death Rate comparison total_cases to total_deaths
--The probability of dying if you contract covid-19 sorted by country.

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as Mortality_Rate
FROM [Portfolio Project Covid]..[CovidDeaths]
Where location like '%china%'
Order by 1,2

--Looking at the infection rate per capita
--Try To compare mutiple countries

SELECT Location, date, total_cases, population, (total_cases/population) * 100 as Infection_Rate
FROM [Portfolio Project Covid]..[CovidDeaths]
Where Location like '%niger%'
Order by 1,2

-- Determining what percentage of the population has contracted covid-19 since the pandemic start

SELECT location, population, Max(total_cases) as RunningInfectionsTotal , MAX((total_cases/population)) * 100 as RunningInfectionRate
FROM [Portfolio Project Covid]..CovidDeaths
Group By  location,population
Order by RunningInfectionrate desc

--Highest Death Rate Per Country and Average PErcentage of popopualtion died from covid

SELECT Location, population, Max(cast(total_deaths as int)) as DeathCount, max(total_deaths)/population * 100 as CountryDeathRate
FROM [Portfolio Project Covid]..[CovidDeaths]
WHERE Continent is not null
Group by location, population
Order by CountryDeathRate desc

--- Total Deaths and Death Rate Per continent  '

SELECT location, population, Max(cast(total_deaths as int)) as DeathCount, max(total_deaths)/population * 100 as ContinentDeathRate
FROM [Portfolio Project Covid]..CovidDeaths
WHERE continent is null 
Group by location, population
Order by ContinentDeathRate desc

--Worlwide sum of Covid cases since the beginning of the pandemic

Select SUM(new_cases) as TotalCasesCovid, SUM(cast(new_deaths as int)) as TotalCovidDeaths,
SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as WorldwideMortality 
FROM [Portfolio Project Covid]..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 1, 2

--Ratio of people vaccinated vs unvaccinated segmented by location


SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
, sum(convert(float,vac.new_vaccinations)) OVER (Partition by death.location ORDER BY death.location, death.date) AS CummulativeVaccinations
FROM [Portfolio Project Covid]..CovidDeaths Death
FULL JOIN [Portfolio Project Covid]..CovidVaccinations Vac
	ON Death.date = Vac.date 
	AND Death.location = vac.location
WHERE death.continent is not null 
Order by 2,3

--Overflow Error Occured Above so used float

--Ratio of total vaccinations vs population segmented by location
--Some countries have administered more shots than total population we can infer
--that this may be a result of booster shots. 

WITH VacRatio (continent, location, date, population, new_vaccinations, CummulativeVaccinations)
as
(
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
, sum(convert(float,vac.new_vaccinations)) OVER (Partition by death.location ORDER BY death.location, death.date) AS CummulativeVaccinations
FROM [Portfolio Project Covid]..CovidDeaths Death
FULL JOIN [Portfolio Project Covid]..CovidVaccinations Vac
	ON Death.date = Vac.date 
	AND Death.location = vac.location
WHERE death.continent is not null 
)

SELECT *, ((CummulativeVaccinations/population) * 100) As #OfVaccinesVsPop
FROM VacRatio
--WHERE Location like '%France'
ORDER by 3

--TEMP Table Example Percent of Population Vaccinated
--DROP TABLE #RatioPopulationVaccinated -- if there are erros can drop table
CREATE TABLE #RatioOfPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
cummulativevaccinations numeric
)

Insert into #RatioOfPopulationVaccinated

SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
, sum(convert(float,vac.new_vaccinations)) OVER (Partition by death.location ORDER BY death.location, death.date) AS CummulativeVaccinations
FROM [Portfolio Project Covid]..CovidDeaths Death
FULL JOIN [Portfolio Project Covid]..CovidVaccinations Vac
	ON Death.date = Vac.date 
	AND Death.location = vac.location
WHERE death.continent is not null 

SELECT *, ((CummulativeVaccinations/population) * 100) AS #VaccineVsPop
FROM #RatioOfPopulationVaccinated





