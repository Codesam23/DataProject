Select * 
From DataProject..CovidDeaths
order by 3,4

--Select * 
--From DataProject..CovidVaccinations
--order by 3,

--select data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From DataProject..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From DataProject..CovidDeaths
Where location like '%states%'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From DataProject..CovidDeaths
--Where location like '%states%'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
 
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From DataProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--Showing countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From DataProject..CovidDeaths
--Where location like '%states%'
Group by Location
order by TotalDeathCount desc

-- Showing contintents with the Highest Death Count per Population 

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From DataProject..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From DataProject..CovidDeaths
--Where location like '%states%'
where continent is not null
--Group by date
order by 1,2

--Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as
RollingPeopleVaccinated
From DataProject..CovidDeaths dea
Join DataProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where location like '%states%'
where dea.continent is not null
--Group by date
order by 2,3

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as
RollingPeopleVaccinated
From DataProject..CovidDeaths dea
Join DataProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where location like '%states%'
where dea.continent is not null
--Group by date
order by 2,3
  
  select *, (RollingPeopleVaccinated/Population)*100
  from #PercentPopulationVaccinated


  --Creating View to store data for later visualization

  create view PercentPopulationVaccinated as
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as
RollingPeopleVaccinated
From DataProject..CovidDeaths dea
Join DataProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where location like '%states%'
where dea.continent is not null
--Group by date
--order by 2,3


select *
from PercentPopulationVaccinated
 



