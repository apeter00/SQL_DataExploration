select *
from PortfolioProject..CovidDeaths$
order by 3,4


select *
from PortfolioProject..CovidVaccinations$
order by 3,4

select location,date, total_cases,new_cases,total_deaths, population
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

--View Death rates from Total cases in India

select location,date, total_cases,total_deaths, population , (total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths$
where location like '%india%'
order by 1,2

--View Infected Population Percentage in India
select location,date, total_cases, population , (total_cases/population)*100 as Population_Infected_Percentage
from PortfolioProject..CovidDeaths$
where location like '%india%'
order by 1,2

select location, population, MAX(total_cases) as Highest_Infection_Count, MAX(total_cases/population)*100 as Population_Infected_Percentage
from PortfolioProject..CovidDeaths$
where continent is not null
Group by location, population
order by Population_Infected_Percentage desc

--Countries with highest Death Count by Population, change total_deaths colums from nvarchar(255) to int for calculations

Select location, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by Total_Death_Count desc



Select location, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by Total_Death_Count desc


--Total cases, deaths and Death Percenatge
Select SUM(new_cases) as total_Cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
order by 1,2


--Join two tables 

Select dea.continent, dea.location,dea.date, dea.population, vacc.new_vaccinations
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vacc	
	On dea.location = vacc.location
	and dea.date = vacc.date
where dea.continent is not null
order by 2,3


--Create a View 

Create View People_Vaccinated_RollingCount as
Select dea.continent, dea.location,dea.date, dea.population, vacc.new_vaccinations, SUM(cast(vacc.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as People_Vaccinated_RollingCount
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vacc	
	On dea.location = vacc.location
	and dea.date = vacc.date
where dea.continent is not null 
