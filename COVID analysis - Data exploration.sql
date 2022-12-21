/*

Covid 19 Data exploration project 
Functions used => Joins, CTE's, Temp Table, Windows Functions, Aggregate functions, Creating Views, Converting Data types

*/
Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVacinations
--order by 3,4


-- 1. Query Action=> Select data that we are going to use

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2


-- 2. Query Action=> Total Cases vs Total Deaths (for a country)
	-- Shows likelihood of dying if you contract covid in your country
	
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage  
From PortfolioProject..CovidDeaths
Where location like 'Canada'
and continent is not null
order by 1,2


-- 3. Query Action => Total Cases vs Population 
	--  What percentage of population has covid
	
Select location, date,population, total_cases,  (total_cases/population)*100 as PercentageOfInfectedPeople  
From PortfolioProject..CovidDeaths
Where location like 'Canada'
order by 1,2


-- 4. Query action => Countries with highest infection rate compared to population

Select location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases)/population)*100 as PercentageOfInfectedPeople  
From PortfolioProject..CovidDeaths
Group by location, population
order by PercentageOfInfectedPeople desc


-- 5. Query Action=> Countries with highest Death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location 
order by TotalDeathCount desc


-- BREAKING THINGS DOWN BY CONTINENT

-- 6. Query Action => Continents with highest Death count per population 

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- 7. Query Action => Global numbers of Deaths on a specific date

Select date, SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage   --total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage  
From PortfolioProject..CovidDeaths
where continent is not null
Group by date
order by 1,2


--8. Query Action => Global numbers of Deaths in all

Select SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage   --total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage  
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


--9. Query Action => Total Population vs Vaccinations
	-- Percentage of population that has recieved at least one Vaccine 
	
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingCount_for_vaccinated_people
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--10. Query Action => Using CTE to perform calculations on Partition By in previous Query

With Pop_vs_Vac (continent, location, date, population, New_Vaccination, RollingCount_for_vaccinated_people )
AS (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingCount_for_vaccinated_people
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select * , (RollingCount_for_vaccinated_people/population)*100
from Pop_vs_Vac


-- 10. Query Action => Using Temp Table to perform calculations on Partition By in previous Query

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar (255),
Location nvarchar (255),
Date datetime, 
Population numeric,
New_Vaccination numeric,
RollingCount_for_vaccinated_people numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingCount_for_vaccinated_people
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select * , (RollingCount_for_vaccinated_people/population)*100
from #PercentPopulationVaccinated



-- Creating view to store data for later visualizations, from Total Population vs Vaccinations Query 
Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingCount_for_vaccinated_people
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
