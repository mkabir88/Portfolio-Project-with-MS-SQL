Select *
from PortfolioProject..CovidDeaths
order by 3,2


Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Looking at the total cases and total deaths
-- Show the likelyhood of death if someone get infected with covid in this courntry

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as Death_percentage
from PortfolioProject..CovidDeaths
where location like '%Finland%'
order by 1,2

-- Looking at the total cases vs the polulation
-- Shows what percentage of population infected by covid

Select location, date, total_cases, population, (total_cases/population)* 100 as infection_percentage
from PortfolioProject..CovidDeaths
where location like '%Finland%'
order by 1,2

-- Looking at the countries with the hightst infection rate compared to population 

Select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))* 100 as PercentOfPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%Finland%'
Group by population, location
order by PercentOfPopulationInfected desc

-- Looking at the countries with the hightst death count compared to population 

Select location, Max(cast(total_deaths as int)) as TotalDeaths
from PortfolioProject..CovidDeaths
--where location like '%Finland%'
where continent is not null
Group by location
order by TotalDeaths desc

-- Looking at the continents with the hightes death count compared to population

Select continent, Max(cast(total_deaths as int)) as TotalDeaths
from PortfolioProject..CovidDeaths
--where location like '%Finland%'
where continent is not null
Group by continent
order by TotalDeaths desc

-- Global Numbers

Select date, sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)* 100 as Death_percentage
from PortfolioProject..CovidDeaths
--where location like '%Finland%'
where continent is not null
group by date
order by 1,2

-- The sum of total cases in the world 

Select sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)* 100 as Death_percentage
from PortfolioProject..CovidDeaths
--where location like '%Finland%'
where continent is not null
--group by date
order by 1,2

----------

select*
from PortfolioProject..CovidVaccinations

-- Joining needed tables
-- Looking at total population vs vaccination


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as SumOfVaccinatedPeople
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Use CTE

with PopvsVac (continent, location, date, population, new_vaccinations, SumOfVaccinatedPeople)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as SumOfVaccinatedPeople
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select*, (SumOfVaccinatedPeople/population)*100
from PopvsVac

-- Use Temp Table
Drop Table if exists #PercentageofPopulationVaccinated
Create Table #PercentageofPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
SumofvaccinatedPeople numeric
)
Insert into #PercentageofPopulationVaccinated 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as SumOfVaccinatedPeople
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
select*, (SumOfVaccinatedPeople/population)*100
from #PercentageofPopulationVaccinated

-- Creating view to store data for later visualizations

Create view PercentageofPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as SumOfVaccinatedPeople
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--Drop view if exists PercentageofPopulationVaccinated

select*
from PercentageofPopulationVaccinated







