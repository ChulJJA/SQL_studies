/*Q.1*/
create table Employee (
id int, name varchar(30), age int, salary int, 
primary key (id)
);

create table Dept (
id int, name varchar(30), budget float, 
primary key (id)
);

create table WorksIn (
E_id int, D_id int, percentTime float, 
primary key (E_id, D_id), 
foreign key (E_id) references Employee(id), 
foreign key (D_id) references Dept(id)
);

/*Q.2 - a*/
select distinct name
from Suppliers
join Catalog on Suppliers.id = Catalog.sid
join Parts on Catalog.pid = Parts.id
where Parts.color = 'red';

/*Q.2 - b*/
select distinct id
from Suppliers
join Catalog on Suppliers.id = Catalog.sid
join Parts on Catalog.pid = Parts.id
where Parts.color = 'red' or Suppliers.address = '123 College Ave';

/*Q.2 - c*/
select sid
from Catalog
join Parts on Catalog.pid = Parts.id
where Parts.color = 'red' or Parts.color = 'green'
group by Catalog.sid
having count(distinct Parts.color) = 2;

/*Q.2 - d*/
select sid
from Catalog
join Parts on Catalog.pid = Parts.id
group by Catalog.sid
having count (distinct case when Parts.color = 'red' then Parts.color end) = 1
or count (distinct case when Parts.color = 'green' then Parts.color end) = 1;

/*Q.2 - e*/
select pid
from Catalog
join Parts on Catalog.pid = Parts.id
join Suppliers on Catalog.sid = Suppliers.id
where Suppliers.name = 'Toshiba'
and Catalog.cost = (select max(cost) from Catalog where sid = Suppliers.id);

/*Q.3 - a*/
select name
from Students
join Takes on Students.id = Takes.sid
join Classes on Takes.cname = Classes.name and Classes.pid = (select id from Profs where name = 'Marie Curie')
where Students.level = 'JR';

/*Q.3 - b*/
select distinct cname
from Takes
where cname in (select name from Classes where room = 'Tillett 232')
or cname in (select cname from group by cname having count (distinct sid) >= 5);

/*Q.3 - c*/
select distinct name
from Profs
join Classes on Profs.id = Classes.pid
where not exists (select distinct room from Classes 
where not exists (select * from Classes as Classes2 where Classes2.room = Classes.room and Classes.pid = Profs.id));

/*Q.3 - d*/
select level, avg(age)
from Students
group by level;

/*Q.3 - e*/
select name, count(distinct Classes.name)
from Profs
join Classes on Profs.id = Classes.pid
where exists (select * from Classes where room = 'Tillett 232' and pid = Profs.id)
group by Profs.id;