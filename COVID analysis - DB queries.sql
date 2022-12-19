Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVacinations
--order by 3,4


-- Query Action=> Select data that we are going to use
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2


-- Query Action=> Total Cases vs Total Deaths (for a country)
-- A way to interpret the data is => There's __% chance to die if you get a covid +ve in a country. (Number used from DeathPercentage column)
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage  
From PortfolioProject..CovidDeaths
Where location like 'Canada'
and continent is not null
order by 1,2


-- Query Action => Total Cases vs Population 
-- Interpreting data => What %age of population has covid
Select location, date,population, total_cases,  (total_cases/population)*100 as PercentageOfInfectedPeople  
From PortfolioProject..CovidDeaths
Where location like 'Canada'
order by 1,2


-- Query action => Countries with highest infection rate compared to population
Select location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases)/population)*100 as PercentageOfInfectedPeople  
From PortfolioProject..CovidDeaths
Group by location, population
order by PercentageOfInfectedPeople desc


-- Query Action=> Countries with highest Death count per population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location 
order by TotalDeathCount desc


-- Query Action => Continents with highest Death count per population 
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Query Action => Global numbers of Deaths on a specific date

Select date, SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage   --total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage  
From PortfolioProject..CovidDeaths
where continent is not null
Group by date
order by 1,2


-- Query Action => Global numbers of Deaths in all
Select SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage   --total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage  
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Query Action => Total Population vs Vaccinations
	-- Get the rolling count, to get the total amount of people vaccinated, into a new column
	-- Create a temp table or CTE 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingCount_for_vaccinated_people
	, 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Using CTE
With Pop_vs_Vac (continent, location, date, population, New_Vaccination, RollingCount_for_vaccinated_people )
AS (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingCount_for_vaccinated_people
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select * , (RollingCount_for_vaccinated_people/population)*100
from Pop_vs_Vac


-- Using Temp Table 
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
--order by 2,3

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
--order by 2,3