#1_a
create user 'jPerez'@'%' idintified by '1608';
create user 'aFernandez'@'%' idintified by '1608';

#1_b
use sakila;

grant insert, update on sakila.country to 'jPerez'@'%';
grant insert, update on sakila.country to 'aFernandez'@'%';

show grants for 'jPerez'@'%';
show grants for 'aFernandez'@'%';

#1_c
revoke update on sakila.country from 'jPerez'@'%';
revoke update on sakila.country from 'aFernandez'@'%';

show grants for 'jPerez'@'%';
show grants for 'aFernandez'@'%';

#1_d

grant create on sakila.* to 'jPerez'@'%';

#1_e

grant select on sakila.address to 'jPerez'@'%';
grant select on sakila.address to 'aFernandez'@'%';

select * from address where address_id = 1;
