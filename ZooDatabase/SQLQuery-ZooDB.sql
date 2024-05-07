--1. Using SQL Server create a database
--2. Define all primary keys, foreign keys and data 
--3. Populate the tables with sufficient data to adequately test all aspects of your queries.  
--4. Develop the SQL queries to satisfy the questions below

--No views should be employed here. While no question would require it you may use dynamic temporary tables as a technique.

--1. Show for each zoo the number of different species represented by its captive animals. 
select zoo, count(distinct.animal.species) as "Number of different species" from animal 
group by zoo

--2. List the zoo name, employee name and salary of each employee that is a world�s best expert in a species. Sequence the output by employee name within zoo name.
Select zoo, empname, salary from employee 
where empno in 
(select worldbestexpertempno from species)
order by zoo, empname

--3. List the detail of animals that are in captivity in any zoo and whose mother is currently in the "Garden Zoo" in Boston.
select * from animal
where motheranimalid in
(select animalid from animal
inner join zoo on animal.zoo = zoo.zooname 
where zoo = 'Garden Zoo' and
zoo.city = 'Boston')

--4. Show for each zoo in Canada a count of captive animals.  Sequence the output by highest to lowest count.
select zooname, count(animalid) as "Amount of Captive animals" from animal inner join
zoo on animal.zoo = zoo.zooname
where zoo.country = 'Canada'
group by zooname
Order by count(animalid) desc

--5. Show for each species a count of the experts that are employed by any zoos in the USA.
select speciesname, count(distinct EmpNo) as "Number of expert(s) employed in USA" from species 
inner join employee on species.speciesname = employee.speciesexpertise inner join zoo on employee.zoo = zoo.zooname
where zoo.country = 'USA'
Group by speciesname


--6. List the details for employees in any zoo in Canada that have either a salary of at least 75000 or are an expert in the Tiger species. Sequence the output by employee name.
select employee.* from employee inner join zoo on employee.zoo = zoo.zooname 
where country = 'Canada' and (salary >= 75000 or speciesexpertise = 'Tiger')
Order by empname

--7. List the details for all animals born in 2016 that belong to an endangered species (status = E). 
select animal.* from animal inner join species on animal.species = species.speciesname 
where year(dateofbirth) = 2016 and status = 'E'

--8. List the details for the zoos in China that have more than 2 animals that belong to the Panda species.
select * from zoo
where zooname in 
(select zooname from zoo inner join animal on zoo.zooname = animal.zoo where zoo.country = 'China' and species = 'Panda'
group by zooname 
having count(animalid) > 2)

--9. List the names, gender and salaries of all male employees that are the world�s best expert for a threatened species (status = T).
select empname, gender, salary from employee inner join species on employee.empno = species.WorldBestExpertEmpNo
where gender = 'M' and status = 'T'

--10. List the details of the zoo that has the employee with the highest salary in any zoo.
select zoo.* from zoo inner join employee on zoo.zooname = employee.zoo 
where employee.salary = (select max(salary) from employee)

--11. List the details for any species for which there animals held in any zoo in China.
select distinct.species.* from animal inner join zoo on animal.zoo = zoo.zooname inner join species on animal.species = species.speciesname
where country = 'china'

--12. List the details for the zoos that have animals belonging to more than 3 different species. Sequence the output alphabetically by zoo within city.
select distinct zoo.* from zoo inner join animal on zoo.zooname = animal.zoo 
where zoo in 
(select zoo from animal 
group by zoo
having count(distinct species) > 3)
order by zoo.city, zooname asc

 --13. List details for the animals that have a mother that is in a zoo that is different from their child's current zoo.
 select child.* from animal child inner join animal mother on child.motheranimalid = mother.animalid inner join zoo
 on child.zoo = zoo.zooname 
 where child.zoo != mother.zoo

--14. Show the name of any country that has the more than 2 zoos.
select country from zoo
group by country
having count (Distinct zooname) > 2

--15. List the species details for the species that have a world�s best expert working in a zoo that also has animals of that same species. Show each species only once.
select distinct.species.* from employee inner join species on employee.empno = species.WorldBestExpertEmpNo inner join zoo
on employee.zoo = zoo.zooname inner join animal on zoo.zooname = animal.zoo
where employee.speciesexpertise = animal.species


--16. List the details for the employee that has the lowest salary for an expert in the Tiger species.
select * from employee
where speciesexpertise = 'Tiger' and salary = (select min(salary) from employee where speciesexpertise = 'Tiger') 

--17. List the details for any endangered species for which there are more than 2 individual animals in total in Canadian zoos.
select * from species 
where status = 'E' and speciesname in 
(select species from animal inner join
zoo on zoo.zooname = animal.zoo
where country = 'Canada'
group by species
HAVING count(animalid) > 2)


--18. List the details of any zoo that has more than 2 Lions born in 2016.
Select * from zoo 
where zooname in 
(select zooname from zoo inner join animal on zoo.zooname = animal.zoo
where animal.species = 'Lion' and year(dateofbirth) = '2016'
group by zooname
having count(*)> 2)

  --19. Show the count of how many species experts are employed at the "Metro Zoo" in Toronto.
  select count(speciesexpertise) as "Number of Metro Zoo employed species experts" from zoo 
  inner join employee on zoo.zooname = employee.zoo 
  where zooname = 'Metro Zoo' and city = 'Toronto'
  

 --20 List the details of mothers that have more than 2 offspring in total in all Canadian zoos. 
 select * from animal
 where animalid in 
 (select mother.animalid from animal mother inner join animal child on mother.animalid = child.motheranimalid inner join zoo on child.zoo = zoo.zooname
 where country = 'Canada'
 group by mother.animalid
 having count(*) > 2)

