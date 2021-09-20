#2.1
alter table comisario add sueldo decimal(10,2);
#2.2
update comisario
set sueldo=sueldo*1.1
where comisario.sueldo<5000;
#2.3
update comisario
set sueldo=5000
where sueldo>=(50000/11) and sueldo<5000;