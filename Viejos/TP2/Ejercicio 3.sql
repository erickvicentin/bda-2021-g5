create table if not exists BDA2021.sede 
(id int(8) auto_increment,
presupuesto float(10,2) not null,
nro_complejo int(8),
PRIMARY KEY(id)
);

create table if not exists BDA2021.complejo 
(id int(8) auto_increment,
id_sede int not null,
jefe varchar(30) not null,
localizacion varchar(30) not null,
area_total float(4,2),
PRIMARY KEY(id),
foreign key (id_sede) references sede(id)
);

create table if not exists BDA2021.area
(id int(30) auto_increment,
localizacion varchar(30),
primary key(id)
);

create table if not exists BDA2021.unideportivo
(id int references complejo,
primary key(id)
);

create table if not exists BDA2021.polideportivo
(id int references complejo,
primary key(id)
);

create table if not exists BDA2021.eventos
(id int(8) auto_increment,
id_complejo int not null,
fecha date not null,
nro_comisarios int(3) not null,
nro_participantes int(4) not null,
duracion time,
anunciamiento set(''),
primary key(id),
foreign key(id_complejo) references complejo(id)
);

create table if not exists BDA2021.comisario
(id int(4) auto_increment,
primary key(id)
);

create table if not exists BDA2021.juez
(id int references comisario,
primary key(id)
);

create table if not exists BDA2021.observador
(id int references comisario,
primary key(id)
);

create table if not exists BDA2021.participa
(id_evento int,
id_comisario int,
primary key(id_evento, id_comisario),
foreign key(id_evento) references comisario(id),
foreign key(id_comisario) references eventos(id)
);