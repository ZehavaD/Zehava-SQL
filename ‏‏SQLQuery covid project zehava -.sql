
SELECT *
FROM zehava..['owid-covid-data_CovidDeaths]
Where continent is not null
Order By 3,4 

--SELECT *
--FROM zehava..['owid-covid-data_CovidVaccinations]
--Order By 3,4 

--Select Data that i am going to be using 

Select location, date, total_cases_per_million, total_deaths_per_million, population
From zehava..['owid-covid-data_CovidDeaths]
Order By 1,2 

SELECT TOTAL_CASES_PER_MILLION, TOTAL_DEATHS_PER_MILLION, POPULATION, (POPULATION/1000000)* TOTAL_CASES_PER_MILLION AS TOTAL_CASES
FROM ZEHAVA..['OWID-COVID-DATA_COVIDDEATHS]


--looking at Total Cases vs Total Deats  ��� ���� ���� �� ������ ����� ���� ������ ��� ������ ����� 
--Shows likelihood of dying if you contract civind in your country - ���� �� ������� / ����� ���� ����� ������ ������� ������ ��� 

Select location ,date, total_deaths, (population/1000000)* total_cases_per_million as total_cases,((total_deaths)/((population/1000000)* total_cases_per_million))*100 as DeathsPrecentge 
From zehava..['owid-covid-data_CovidDeaths]
Where location like '%Israel%'  
Order By 1,2 

--looking at total cases vs population �� ������ ����� ���� ���������� ������ 
--shows what precentege of the population got covid- ���� �� ���� ����� ���������� ��� ���� ������� 

Select location ,date, population, (CONVERT(float, total_cases_per_million)/1000000)* population as total_cases, ((CONVERT(float, total_cases_per_million)/1000000)/(population))*100 as PrecentgePopulationInfected 
From zehava..['owid-covid-data_CovidDeaths]
Where location like '%Israel%' 
--Order By 1,2 

--Looking at countries with Highest Infection Rate compared to Population- ������ �� ����� ������ ������� ����� ���� ��������� 
Select location, population, Max(CONVERT(float, total_cases_per_million)/1000000)* population as HighestInfectionCount, Max((CONVERT(float, total_cases_per_million)/1000000)/(population))*100 as PrecentgePopulationInfected  
From zehava..['owid-covid-data_CovidDeaths]
--Where location like '%Israel%' 
Group By location, population
Order By PrecentgePopulationInfected desc

--Showing Countries with Highest Death Count per Population-   ���� ������ ���� ��� �� ��� ���� ������ ���� ���������� 
Select location, Max(cast (total_deaths as int)) as TotalDeathCount  --(���� ����� ���
From zehava..['owid-covid-data_CovidDeaths]
--Where location like '%Israel%'
Where continent is not null
Group By location
Order By TotalDeathCount desc

-- showing by continent 
Select continent, Max(cast (total_deaths as int)) as TotalDeathCount  --(���� ����� ���
From zehava..['owid-covid-data_CovidDeaths]
--Where location like '%Israel%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc



--Globel numbers  �� ���--- ���� ����� ��� �����.  ���� ���� ������� ������� ����� ���� �����  
Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/NULLIF (SUM(new_cases), 0) *100 as DeathPercentage
From zehava..['owid-covid-data_CovidDeaths]
--Where location like '%Israel%'
Where continent is not null
--Group by date
Order By 1,2 

--Looking at Total Population vs Vaccinations-- windows �������

-- ����� ��� ������ 
--
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated --����� ������� �� ����� �������
-- ��� ����� ������ �������?
-- ��� �� ������ ����� ������ �� ����� ����� ����� ��� ��� ������ ����� cte �� ���� ��� 
From zehava..['owid-covid-data_CovidDeaths] dea
join Zehava..['owid-covid-data_CovidVaccinations] vac
     on dea.location = vac.location
	 and dea.date = vac. date
Where dea.continent is not null  --and dea.location LIKE '%israel%'
Order by 2,3 

--USE CTE -- ���� �� �������� ����������� 

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)  
as
(
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated -- 
-- ��� ����� ������ �������?
-- ��� �� ������ ����� ������ �� ����� ����� ����� ��� ��� ������ ����� cte �� ���� ��� 
From zehava..['owid-covid-data_CovidDeaths] dea
join Zehava..['owid-covid-data_CovidVaccinations] vac
     on dea.location = vac.location
	 and dea.date = vac. date
Where dea.continent is not null
--Order by 2,3 
)
--
-- ���� ���������� ��� �������
Select*, (RollingPeopleVaccinated / NULLIF(Population, 0))*100 as VaccinationPercentage  
From  PopvsVac


--Creating view to store data for later visualizations
DROP VIEW IF EXISTS PrecetPopulationVaccinated

Create View precetPopulationVaccinated2 as
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated --����� ������� �� ����� �������
-- ��� ����� ������ �������?
-- ��� �� ������ ����� ������ �� ����� ����� ����� ��� ��� ������ ����� cte �� ���� ��� 
From zehava..['owid-covid-data_CovidDeaths] dea
join Zehava..['owid-covid-data_CovidVaccinations] vac
     on dea.location = vac.location
	 and dea.date = vac. date
--Where dea.continent is not null  --and dea.location LIKE '%israel%'
--Order by 2,3 
 

     



 

