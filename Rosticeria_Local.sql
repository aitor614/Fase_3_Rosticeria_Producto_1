show databases;
Create database Rosticeria;

use Rosticeria;
create table Categoria (
	idCategoria int not null auto_increment,
	nombreCategoria varchar(50),
	primary key (idCategoria)
);

create table Proveedor (
	NIF varchar (9) not null,
	nombreEmpresa varchar(100),
	nombreContacto varchar(100),
	telefono varchar(50),
	dirección varchar(255),
	mail varchar(50),
	web varchar(100),
	registro varchar(50),
	idCategoria int not null,
	primary key (NIF),
	foreign key (idCategoria) references Categoria (idCategoria)
    on update cascade
);

create table Producto (
	Codigo_Producto int not null,
	nombre varchar(100) not null,
	unidad int not null,
	alertaStock int not null default 0,
	idCategoria int not null,
	primary key (Codigo_Producto),
	foreign key (idCategoria) references Categoria (idCategoria)
    on update cascade
);

create table Ingrediente (
	Codigo_Producto int not null,
    conservación enum ('Frigorífico', 'Congelador', 'Despensa'),
    primary key (Codigo_Producto),
    foreign key (Codigo_Producto) references Producto (Codigo_Producto)
    on delete cascade
    on update cascade
); 

create table Elaborado (
	Codigo_Producto int not null,
    primary key (Codigo_Producto), 
	foreign key (Codigo_Producto) references Producto (Codigo_Producto)
	on delete cascade
    on update cascade
);

create table Alergeno(
	alergeno varchar (50),
	primary key (alergeno)
);

create table Alergenos_Producto (
	Codigo_Producto int not null,
    alergeno varchar (50),
    foreign key (Codigo_Producto) references Producto (Codigo_Producto)
    on delete cascade
    on update cascade,
    foreign key (alergeno) references Alergeno (alergeno)
    on delete cascade
    on update cascade
);

create table Compras_Producto (
	primary key (fecha),
	Codigo_Producto int not null,
	NIF varchar (9) not null,
    fecha date,
    cantidad int not null,
    precio float,
    IVA float,
    caducidad date,
    foreign key (NIF) references Proveedor (NIF),
    foreign key (Codigo_Producto) references Producto (Codigo_Producto)
);

create table Donaciones (
	fecha date not null,
	primary key (fecha) 
);

create table Detalle_Donacion (
	linea int not null auto_increment,
	fecha date not null,
	Codigo_Producto int not null,
	cantidad float not null,
	observaciones text (500),
	primary key (linea),
	foreign key (fecha) references Donaciones (fecha)
    on delete cascade
    on update cascade,
	foreign key (Codigo_Producto) references Producto (Codigo_Producto)
);

create table Tipo_Platos (
	Id_Tipo int not null auto_increment,
	Tipo_De_Plato varchar (100),
	primary key (id_Tipo)
);

create table Plato (
	Codigo_Plato int not null,
	nombrePlato varchar (150) not null,
	Tipo_Plato int,
	elaboracion longtext,
	PVP float,
	En_Menu boolean,
	primary key (Codigo_Plato),
	foreign key (Tipo_Plato) references Tipo_Platos (id_Tipo)
    on delete set null
    on update cascade
);

create table Ingredientes_Plato (
	Codigo_Plato int not null,
    Codigo_Producto int not null,
    Cant_Bruta float,
    Cant_Neta float,
    unidad enum ('Kilogramos', 'Litros', 'Unidades'),
    foreign key (Codigo_Plato) references Plato (Codigo_Plato)
    on delete cascade
    on update cascade,
    foreign key (Codigo_Producto) references Ingrediente (Codigo_Producto)
    on delete cascade
    on update cascade
);

create table Comanda (
	Id_Comanda int not null,
    Fecha date,
    Mesa int,
    hora time,
    comensales int,
    ticket int,
    primary key (Id_Comanda)
);

create table Comanda_Platos (
	Id_Comanda int not null,
    Codigo_Plato int not null,
    cantidad int,
    PVP float,
    IVA float,
    foreign key (Id_Comanda) references Comanda (Id_Comanda)
    on delete cascade
    on update cascade,
    foreign key (Codigo_Plato) references Plato (Codigo_Plato)
	on delete no action
    on update cascade
);

create table Comanda_Elaborados (
	Id_Comanda int not null,
    Codigo_Producto int,
    cantidad int,
    PVP int,
    IVA int,
    foreign key (Id_Comanda) references Comanda (Id_Comanda)
    on delete cascade
    on update cascade,
    foreign key (Codigo_Producto) references Producto (Codigo_Producto)
     on delete no action
    on update cascade
);
/*modificaciones tabla*/
/*EJERCICIO 3*/
/*ejercicio 'A'*/
alter table Producto
modify column unidad enum ('Kilogramos', 'Litros', 'Unidades');

/*ejercicio 'B'*/
alter table Producto
add stock float,
add Precio_Compra float;

/*ejercicio 'C'*/
alter table Elaborado
add PVP float,
add IVA float;

/*ejercicio 'D'*/
alter table comanda
add  unique (Fecha);

alter table comanda
add  unique (hora);

alter table comanda
add  unique (Mesa);

/*ejercicio 'E'*/
create table Sala (
	numSala int not null,
    primary key (numSala)
);
alter table comanda
	add numSala int not null,
    add foreign key (numSala) references Sala (numSala);
    
alter table Comanda_Elaborados
	add numSala int not null,
    add foreign key (numSala) references Sala (numSala);
    
alter table Comanda_Platos
	add numSala int not null,
    add foreign key (numSala) references Sala (numSala);

/*ejercicio 'F'*/
alter table Ingredientes_Plato
add Porcentaje_Merma float;

/*EJERCICIO 4*/
insert into alergeno
values ('Altramuces'), ('Apio'), ('Moluscos'), ('Sésamo'), ('Gluten'), ('Pescado'), ('Sulfitos'), ('Mostaza'), ('Crustáceos'), ('Lactosa'), ('Huevo'), ('Soja'), ('FrutosSecos'), ('Cacahuetes');

/*EJERCICIO 5*/
insert into Categoria (nombreCategoria)
values ('Aceites_y_Vinagres'), ('Carnes_y_Aves'), ('Bebidas'), ('Cafés'), ('Elaborados'), ('Fruta_y_Verdura'), ('Pescados_y_Mariscos'), ('Conservas'), ('Elaborados'),
('Embutidos'), ('Especies'), ('Productos_Lácteos'), ('Ovoproductos'), ('Pan_y_Bollería'), ('Postres'), ('Harinas'), ('Salsas'), ('Semielaborados'), ('Sin Gluten'), ('Sin lactosa');

insert into Tipo_Platos (Tipo_De_Plato)
values ('Rostizados'), ('Salsas'), ('Ensaladas'), ('Acompañamientos'), ('Postres/Café'), ('Bebidas'), ('Combinados'), ('Pastas');

insert into Proveedor (NIF, nombreEmpresa, nombreContacto, telefono, dirección, mail, web, registro, idCategoria)
values 
('B65639155', 'BIRRA 365', null, '960 714 310 / 722 615 065', 'Jeronimo Monsoriu, 58, Valencia (Ciudad), Valencia', 'info@birra365.com', 'https://www.birra365.com', null, 3),
('A60177623', 'BOU Café', 'C. Gotor', '902 305 352', 'Calle Botánica 55, 08908, Hospitalet del Llobregat, Barcelona', 'tuopinion@cafesbou.com', 'http://www.cafesbou.com/index.php/es/', null, 4),
('A50090349', 'ALBERTO POLO DISTRIBUCIONES', 'A. Polo',	'976 57 49 09', 'Calle Río Ara 8, 50014, Zaragoza, Zaragoza', 'info@albertopolo.com', 'https://albertopolo.com/', null, 3),
('A58085135', 'CARNS B', 'J. Bigordà Alberni', '933 364 040 / 639 317 777', 'Longitudinal 10, núm. 60 Mercabarna, Barcelona', 'joaquim@carnsb.com', 'www.carnsb.com', null, 2),
('B23373624', 'INDUSTRIA AVICOLA SUREÑA', 'J.  Molina', '915 077 600 / 915 076 224 / 902 101 566', 'C/ Toledo 149 E Pa, 28005, Madrid, Madrid', 'info@inasur.es', 'www.inasur.es', null, 2),
('B85227635', 'RUBIATO PAREDES SL', 'J. Pedros Riasol', '916415512 / 607387265', 'Calle de los Cerrajeros, 6 y 8, 28923, Alcorcón, Madrid ', 'rubiatoparedes@rubiatoparedes.com', 'https://www.rubiatoparedes.com/', null, 2),
('A28647451', 'MAKRO', 'L. Piquer', '933 363 111', 'Carrer A, nª 1, Sector C, Polígono Industrial Zona Franca, 08040, Barcelona', 'atencionclientes.02@makro.es', 'https://www.makro.es/', null, 5),
('B73148793', 'AGRORIZAO', 'M. Agrorizao', '968 425 470 / 868 457 203 / 968 420 381', 'Carretera Nacional 340 (KM 614), 30850,  Totana, Murcia', 'ventas@agrorizao.com', 'www.agrorizao.com', null, 6),
('B87867834', 'CHEF FRUIT', 'J. Domingo', '910 57 81 36', 'Centro de Transportes de Madrid (ctm), CL EJE 6 2,28053, Madrid, Madrid', 'pedidos@chef-fruit.com', 'https://www.chef-fruit.com/', null, 6),
('B90307034', 'FRUTAS CUEVAS', 'J. Cuevas', '954 417 158 / 615 187 204', 'Polígono Pagusa Calle Labrador 47, 41007, Sevilla, Sevilla, Capital España', 'info@frutascuevas.es', 'https://www.frutascuevas.es/', null, 6),
('A58058868', 'HUEVERIAS BONET, S.A.', 'A. Bonet Pedret', '933 357 212', 'Transversal 8, núm. 48 Multiservei I', 'dbonet@dbonet.es', 'http://dbonet.es/', null, 13),
('A58241084', 'MONTSEC', 'J. del Castillo',	'938 498 799', 'Severo Ochoa, 36 - Pol. Ind. Font del Radium, 08403,  Granollers, Barcelona', 'info@comercialmontsec.com', 'http://www.comercialmontsec.com', null,  12),
('A01189364', 'ALAVESA DE PATATAS', 'J. Suárez Tascón', '945 400 429 / 691 423 566', 'Polígono industrial Lurgorri s/n Alegría-Dulantzi 01240 - Álava', 'alavesadepatatas@alavesadepatatas.com',
 'http://alavesadepatatas.com/', null, 7);

/*EJERCICIO 6*/
Insert into Producto (Codigo_Producto, nombre, unidad, idCategoria, stock, Precio_Compra)
values
(1, 'Lechuga', 'Unidades', 6, 500, 0.30),
(2, 'Tomate', 'Kilogramos', 6, 200, 1.2),
(3, 'Zanahoria', 'Kilogramos', 6, 250, 0.8),
(4, 'Olivas Verdes', 'Kilogramos',8 , 50, 1),
(5, 'Cebolla', 'Kilogramos', 6, 100, 0.4),
(6, 'Zumo de Piña', 'Unidades', 3, 500, 0.5),
(7, 'Arroz', 'Kilogramos', 19, 200, 0.5),
(8, 'Gambas', 'Kilogramos', 7, 50, 15),
(9, 'Sepia', 'Kilogramos', 7, 80, 13),
(10, 'Conejo', 'Kilogramos', 2, 150, 4),
(11, 'Judia Tierna', 'Kilogramos', 6, 110, 2),
(12, 'Alcachofa', 'Kilogramos', 6, 30, 0.4),
(13, 'Pimiento Rojo', 'Kilogramos', 6, 50, 0.3),
(14, 'Azafran', 'Kilogramos', 11, 10, 100),
(15, 'Rape', 'Kilogramos', 7, 60, 13),
(16, 'Pasta para Sopa', 'Kilogramos', 8, 50, 0.2),
(17, 'Puerro', 'Kilogramos', 6, 70, 0.2),
(18, 'Apio', 'Kilogramos', 6, 10, 0.1),
(19, 'Nabo', 'Kilogramos', 6, 40, 0.2),
(20, 'Piña', 'Kilogramos', 6, 50, 1.2),
(21, 'Jamon', 'Kilogramos', 10, 20, 40),
(22, 'Pan de Pages', 'Kilogramos', 16, 50, 1.5),
(23, 'Salchichon Iberico', 'Kilogramos', 10, 30, 20),
(24, 'Lubina', 'Kilogramos', 7, 50, 15),
(25, 'Tacos de Jamon', 'Kilogramos', 10, 20, 30),
(26, 'Butifarra de Escalivada', 'kilogramos', 2, 70, 2),
(27, 'Morro de Cerdo', 'Kilogramos', 2, 40, 2),
(28, 'Muslo de Pollo', 'Kilogramos', 2, 60, 2),
(29, 'Butifarra de Cerdo', 'Kilogramos', 2, 70, 2),
(30, 'Panceta de Cerdo','Kilogramos', 2, 50, 2),
(31, 'Alitas de Pollo', 'Kilogramos', 2, 50, 2),
(32, 'Barra de Pan', 'Unidades', 16, 200, 0.8),
(33, 'Huevos', 'Unidades', 13, 120, 0.1),
(34, 'Melon', 'Kilogramos', 6, 100, 3),
(35, 'Sandia', 'kilogramos', 6, 150, 2),
(36, 'Aceite', 'Litros', 1, 200, 4),
(37, 'Sal', 'Kilogramos', 11, 30, 0.9),
(38, 'Azucar', 'Kilogramos', 11, 30, 0.5),
(39, 'Vinagre', 'Litros', 1, 50, 3),
(40, 'Ajo', 'Kilogramos', 6, 10, 1),
(41, 'Patatas', 'Kilogramos', 6, 100, 2.5),
(42, 'Ketchup', 'Unidades', 17, 100, 1.5),
(43, 'Mayonesa', 'Unidades', 17, 100, 1.5),
(44, 'Cocacola', 'Unidades', 3, 200, 0.10),
(45, 'Aquarius', 'Unidades', 3, 150, 0.10),
(46, 'Cerveza', 'Unidades', 3, 300, 0.10),
(47, 'Vino', 'Unidades', 3, 200, 1.5),
(48, 'Gaseosa', 'Unidades', 3, 150, 0.50),
(49, 'Ensalada', null, 9, null, 5.5),
(50, 'Paella Mixta', null, 9, null, 15),
(51, 'Sopa de Rape',null, 9, null, 8),
(52, 'P,iña con Jamon', null, 9, null, 7),
(53,'Ensalada Verde', null, 9, null, 5.5),
(54,'Torrada de Salchichón Iberico', null, 9, null, 9),
(55, 'Lubina', null, 9, null, 13),
(56, 'Jamoncitos de Pavo Rustidos', null, 9, null, 10),
(57, 'Butifarra de Escalivada a la Brasa', null, 9, null, 10.5),
(58, 'Codornices a la Brasa', null, 9, null, 11),
(59, 'Muslo de Pollo a al Brasa', null, 9, null, 9.50),
(60, 'Butifarra a la Brasa', null, 9, null, 9.50),
(61, 'Panceta a la Brasa', null, 9, null, 9.5),
(62, 'Sepia a la Plancha', null, 9, null, 12.5),
(63, 'Alitas de Pollo', null, 9, null, 8.5),
(64, 'Nugets de Pollo', null, 9, null, 7),
(65, 'Alioli', null, 9, null, 0.5),
(66, 'Alitas de pollo', 'Kilogramos', 2, 150, 5),
(67, 'Café', 'Kilogramos', 4, 50, 1),
(68, 'Leche', 'Litros', 3, 500, 0.5),
(69, 'Café Solo', null,  4, null, 1.2),
(70, 'Café con Leche', null, 4, null, 1.2),
(71, 'Café Cortado', null, 4, null, 1.2),
(72, 'Coulant de Chocolate', 'Unidades', 15, 500, 5),
(73, 'Helado de Vainilla', 'Unidades', 15, 500, 3),
(74, 'Raja de Melón', null, 15, null, 2),
(75, 'Raja de Sandía', null, 15, null, 2),
(76, 'Flan de Huevo', 'Unidades', 15, 500, 3.5),
(77, 'Zumo de Piña (Venta)', 'Unidades', 3, 500, 2.5),
(78, 'Zumo de Melocoton', 'Unidades', 3, 500, 0.5),
(79, 'Zumo de Melocoton (Venta)', 'Unidades', 3, 500, 2.5),
(80,'Pavo', 'Kilogramos', 2, 100, 3),
(81, 'Codornices', 'Kilogramos', 2, 100, 4),
(82, 'Nugets de Pollo', 'Kilogramos', 2, 20, 2),
(83, 'Agua', 'Litros', 3, 500, 0.1),
(84, 'Agua (Venta)', 'Litros', 3, 500, 1.5),
(85, 'Cocacola (Venta)', 'Unidades', 3, 200, 2),
(86, 'Aquarius (Venta)', 'Unidades', 3, 150, 2),
(87, 'Cerveza (Venta)', 'Unidades', 3, 300, 2),
(88, 'Vino (Venta)', 'Unidades', 3, 200, 15),
(89, 'Gaseosa (Venta)', 'Unidades', 3, 150, 1);


insert into Plato (Codigo_Plato, nombrePlato, Tipo_Plato, elaboracion, PVP, En_Menu)
values
(1, 'Paella Mixta', 7, 'Preparamos la carne de la paella mixta. Calentamos el aceite en la paella.  
Seguidamente, añadimos el conejo y esperamos a que empiece a dorarse, dándole vueltas de vez en cuando. 
Una vez empiece a dorarse, procedemos a añadir las gambas, para que se vayan dorando. Hacemos el sofrito para la paella. 
A continuación, añadimos el tomate troceado y sofreímos. Luego las judías y alcachofas. Añadimos el ajo picado, lo revolvemos todo muy rápidamente y añadimos el caldo. 
Incorporamos el arroz de la paella. Dejamos cocer todo durante 20 minutos e incorporamos el arroz y sazonamos.Cocer la paella hasta que el arroz esté en su punto unos 20 minutos.' , 15, true),
(2, 'Sopa de Rape',7, 'Despiezar el rape para obtener la cola, espina central y cabeza, las partes más sabrosas. En una olla hervimos a fuego medio-alto 2 litros de agua junto con el rape, el puerro, apio y nabo. 
Cuando rompa a hervir, lo bajamos a fuego lento, sin sobrepasar la media hora de cocinado. Una vez tengamos el caldo preparado, lo pasamos por un colador para separar el caldo de los demás ingredientes. 
La carne de la cola del rape la aprovechamos y la añadimos de nuevo al caldo del rape. Trituramos el resto de verduras para obtener una mezcla homogénea sin grumos. 
Podemos pasar la mezcla por un colador chino y la añadimos al caldo del rape. Removemos y cocinamos unos minutos más para que la sopa se espese ligeramente.', 8, true),
(3, 'Piña con Jamon',7, 'Colocamos en un plato las rodajas de piña. Encima ponemos las lonchas de jamón.', 7, true),
(4, 'Ensalada Verde',3, 'Lavar muy bien todos los vegetales. En un bol profundo, trocear con las manos la lechuga (trozos pequeños más fáciles de servir y comer). 
Usar cualquier variedad de lechuga (temporada).  Cortar los tomates (temporada), zanahoria, cebolla y olivas verdes en taquitos pequeños. 
Para hacer la vinagreta, mezclar un poco de aceite con vinagre, sal y pimienta.' , 5.5, true),
(5, 'Torrada de Salchichón Iberico', 7, 'Preparamos salchichón ibérico de bellota, escoger un cuchillo que no tenga sierra y que esté bien afilado para hacer cortes limpios y de forma sencilla. 
El grosor del salchichón puede ser al gusto, se recomienda hacer lonchas de 1 centímetro para que queden bien ahumadas.
Preparamos el pan tostado con un cuchillo para pan con un borde dentado, cortar las rebanadas de pan para las tostas, de unos 5 centímetros de grosor. 
Tostar el pan sobre la rejilla caliente. Frotar un diente de ajo sobre ella y añadir un chorrito de aceite de oliva. 
Ahumar el salchichón en la brasa caliente, pero con las brasas casi apagadas, sobre la rejilla, colocar las láminas del salchichón, con un poco de aceite de oliva, 
y dejarlo ahumar brevemente hasta que esté el salchichón un poco fundido. Colocar el salchichón sobre la tostada y darle un toque de sal.', 9, true),
(6, 'Lubina', 7, 'Cortamos las patatas, añadimos un poco de sal, un chorrito de aceite y horneamos durante 15 minutos a 180 grados. 
Preparar la lubina abierta para asar, pincelamos el pescado con una pizca de aceite y lo metemos al horno sobre las patatas que ya están empezando a dorarse. 
Asamos el pescado a la misma temperatura unos 20 minutos. Si necesitamos cocer más las patatas, las dejamos otros 5 minutos al horno.', 13, true),
(7, 'Jamoncitos de Pavo Rustidos', 7, 'Salpimentar los muslos de pavo al gusto, realizaremos unos cortes transversales al pavo para ayudar a su cocción.  
Rociar de aceite. Poner sobre la parrilla de la brasa, dorar al gusto. Si se resecan, poner más aceite. Preparemos las patatas laminadas al horno durante 20 minutos, con un poco de sal.', 10, true),
(8, 'Butifarra de Escalivada a la Brasa', 7, 'Prepararemos unas buenas brasas. Pincharemos las butifarras, para que suelten la grasa a la hora de asarlas y las pondremos sobre unas parrillas, 
asándolas por todos los lados sin quemarlas. Serviremos las butifarras junto con la longaniza cortada en 4 trozos. 
Acompañarlo con la escalivada. Para la escalivada preparar los vegetales a la brasa hasta que estén bien rustidos.', 10.5, true),
(9, 'Codornices a la Brasa', 7, 'Abrir las codornices por la mitad y limpiar. Ponemos sal y extendemos en la parrilla. Dejar cocer despacio, sino se quemarán y quedarán duras. 
Cuando estén doradas por ambos lados, ponemos sal y aceite. Preparemos las patatas laminadas al horno durante 20 minutos, con un poco de sal.', 11, true),
(10, 'Muslo de Pollo a al Brasa', 7, 'Hacer unos cortes a los mulos para que queden bien hechos. Rociar de aceite y pimienta al gusto.  Poner sobre la parrilla de la brasa, dorar al gusto. 
Si se resecan, poner más aceite. Preparemos las patatas laminadas al horno durante 20 minutos, con un poco de sal.', 9.50, true),
(11, 'Butifarra a la Brasa', 7, 'Prepararemos unas buenas brasas. Pincharemos las butifarras, para que suelten la grasa a la hora de asarlas y las pondremos sobre unas parrillas, 
asándolas por todos los lados sin quemarlas. Serviremos las butifarras junto con la longaniza cortada en 4 trozos.', 9.50, true),
(12, 'Panceta a la Brasa', 7, 'Cogemos la panceta (a temperatura ambiente) y lo aderezamos con un poco de sal gruesa por los dos lados, posteriormente le añadiremos más en el momento de llevarlo a la parrilla. 
Untar aceite sobre la parrilla caliente para que no se pegue. Una vez tenemos la brasa uniforme, colocamos la carne sobre la parrilla dos minutos, hasta que quede dorada, añadir sal. 
Dar la vuelta a la carne, para que quede bien cocinada por ambos lados.  Preparemos las patatas laminadas al horno durante 20 minutos, con un poco de sal.', 9.5, true),
(13, 'Sepia a la Plancha', 7, 'Limpiar la sepia debajo del grifo, eliminar todos los restos del interior. Una vez limpia escurrir bien. 
Poner a la plancha o sartén ya previamente calentada, cuando esté dorada está lista para servir. Aderezar al gusto. Preparemos las patatas laminadas al horno durante 20 minutos, con un poco de sal.', 12.5, true),
(14, 'Alitas de Pollo', 7, 'Cortar las alitas en tres, siguiendo la articulación, retirar las partes sobrantes de piel y extender sobre la parrilla ya caliente. 
Asegurarse que queden doradas por ambos lados, si se resecan añadir aceite con una pizca de sal. Preparemos las patatas laminadas al horno durante 20 minutos, con un poco de sal.', 8.5, false),
(15, 'Nugets de Pollo',7, 'Freír los nuggets de pollo en la freidora hasta que queden dorados. Preparemos las patatas laminadas al horno durante 20 minutos, con un poco de sal.', 7, false),
(16, 'Alioli', 2, 'Pelar y cortar el ajo en rodajitas. Poner en la batidora el ajo junto al huevo y un buen chorro de aceite. Una pizca de sal. 
Comenzar a batir para preparar la emulsión. A medida que vaya ligando, añadiremos el resto del aceite, poco a poco. A más cantidad de aceite más espesor.', 0.5, true),
(17, 'Café Solo', 6, 'Hacer el cafe con la máquina para cafes expresos', 1.2, true),
(18, 'Café con Leche', 6, 'Hacer el cafe con la máquina para cafes expresos y añadir leche al gusto', 1.2, true),
(19, 'Café Cortado', 6, 'Hacer el cafe con la máquina para cafes expresos y añadir leche al gusto', 1.2, true),
(20, 'Coulant de Chocolate', 5, 'sin receta, lo compramos ya elaborado el proveedor', 5, true),
(21, 'Helado de Vainilla', 5, 'sin receta, lo compramos ya elaborado el proveedor', 3, true),
(22, 'Raja de Melón',5, 'Cortar una raja de melón', 2, true),
(23, 'Raja de Sandía', 5, 'Cortar una raja de Sandía', 2, true),
(24, 'Flan de Huevo', 5, 'sin receta, lo compramos ya elaborado el proveedor', 3.5, false);

insert into Ingrediente (Codigo_Producto, conservación)
values
(1, 'Frigorífico'), /*Lechuga*/
(2, 'Frigorífico' ), /*Tomate*/
(3, 'Frigorífico'), /*Zanahoria*/
(4, 'Despensa'), /*Olivas Verdes*/
(5, 'Frigorífico'), /*Cebolla*/
(7, 'Despensa'), /*Arroz*/
(8, 'Congelador'), /*Gambas*/
(9, 'Congelador'), /*Sepia*/
(10, 'Frigorífico'), /*Conejo*/
(11, 'Frigorífico'), /*Judia Tierna*/
(12, 'Frigorífico'), /*Alcachofa*/
(13, 'Frigorífico'), /*Pimiento Rojo*/
(14, 'Despensa'), /*Azafran*/
(15, 'Frigorífico'), /*Rape*/
(16, 'Despensa'), /*Pasta para Sopa*/
(17, 'Frigorífico'), /*Puerro*/
(18, 'Frigorífico'), /*Apio*/
(19, 'Frigorífico'), /*Nabo*/
(20, 'Frigorífico'), /*Piña*/
(21, 'Frigorífico'), /*Jamon*/
(22, 'Despensa'), /*Pan de Pages*/
(23, 'Frigorífico'), /*Salchichon Iberico*/
(24, 'Frigorífico'), /*Lubina*/
(25, 'Frigorífico'), /*Tacos de Jamon*/
(26, 'Frigorífico'), /*Butifarra de Escalivada*/
(27, 'Frigorífico'), /*Morro de Cerdo*/
(28, 'Frigorífico'), /*Muslo de Pollo*/
(29, 'Frigorífico'), /*Butifarra de Cerdo*/
(30, 'Frigorífico'), /*Panceta de Cerdo*/
(31, 'Frigorífico'), /*Alitas de Pollo*/
(32, 'Despensa'), /*Barra de Pan*/
(33, 'Frigorífico'), /*Huevos*/
(34, 'Frigorífico'), /*Melon*/
(35, 'Frigorífico'), /*Sandia*/
(36, 'Despensa'), /*Aceite*/
(37, 'Despensa'), /*Sal*/
(38, 'Despensa'), /*Azucar*/
(39, 'Despensa'), /*Vinagre*/
(40, 'Despensa'), /*Ajo*/
(41, 'Despensa'), /*Patatas*/
(42,'Frigorífico'), /*Ketchup*/
(43, 'Frigorífico'), /*Mayonesa*/
(44, 'Frigorífico'), /*Cococola*/
(45, 'Frigorífico'), /*Aquarius*/
(46, 'Frigorífico'), /*Cerveza*/
(47, 'Frigorífico'), /*Vino*/
(48, 'Frigorífico'), /*Gaseosa*/
(66, 'Frigorífico'), /*Alitas de Pollo*/
(67, 'Despensa'), /*Cafe*/
(68, 'Frigorífico'), /*Leche*/
(80, 'Frigorifico'), /*Pavo*/
(81, 'Frigorifico'), /*Codornices*/
(82, 'Frigorifico'), /*Nugets de Pollo*/
(83, 'Frigorífico'); /*Agua*/

insert into Ingredientes_Plato (Codigo_Plato, Codigo_Producto, Cant_Bruta, Cant_Neta, unidad, Porcentaje_Merma)
values
/* 1 Paella Mixta*/
(1, 7, 0.300, 0.250, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Arroz*/
(1, 2, 0.5, 0.4, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Tomate*/
(1, 10, 0.5, 0.5,'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Conejo*/
(1, 11, 0.2, 0.19, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Judia Tierna*/
(1, 12, 0.5, 0.2, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Alcachofa*/
(1, 14, 0.0001, 0.0001, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Azafran*/
(1, 8, 0.1, 0.06, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Gambas*/
(1, 13, 0.1, 0.09, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100),/*Pimiento Rojo*/
(1, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(1, 37, 0.001, 0.0009, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Azucar*/
(1, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/
(1, 40, 0.005, 0.0049, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Ajo*/

/* 2 Sopa de Rape*/
(2, 15, 2, 1.8, 'Kilogramos',(Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Rape*/
(2, 17, 1, 0.5, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Puerro*/
(2, 18, 0.04, 0.039, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Apio*/
(2, 19, 0.1, 0.08, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Nabo*/
(2, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/
(2, 37, 0.01, 0.009, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/

/* 3 Piña con Jamon*/
(3, 20, 0.5, 0.2, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Piña*/
(3, 21, 0.5, 0.49, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Jamon*/

/* 4 Ensalada Verde*/
(4, 1, 0.1, 0.09, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Lechuga*/
(4, 2, 0.3, 0.29, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Tomate*/
(4, 3, 0.3, 0.29, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Zanahoria*/
(4, 4, 0.01, 0.01, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Olivas Verdes*/
(4, 5, 0.3, 0.29, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Cebolla*/
(4, 37, 0.002, 0.0019, 'Kilogramos',(Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(4, 36, 0.005, 0.0049, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/
(4, 36, 0.005, 0.0049, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Vinagre*/

/* 5 Torrada de Salchichón Iberico*/
(5, 22, 0.1, 0.09, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Pan de Pages*/
(5, 2, 0.3, 0.29, 'Kilogramos' ,(Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Tomate*/
(5, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(5, 36, 0.005, 0.0049, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/
(5, 23, 0.3, 0.29, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Salchichon Iberico*/

/* 6 Lubina*/
(6, 24, 0.8, 0.6, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Lubina*/
(6, 41, 0.5, 0.45, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Patatas*/
(6, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(6, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/

/* 7 Jamoncitos de Pavo Rustidos*/
(7, 80, 0.5, 0.49, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Pavo*/
(7, 41, 0.5, 0.45, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Patatas*/
(7, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(7, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/

/* 8 Butifarra de Escalivada a la Brasa*/
(8, 26,  0.5, 0.49, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Butifarra de Escalivada*/
(8, 41, 0.5, 0.45, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Patatas*/
(8, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(8, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/

/* 9 Codornices a la Brasa*/
(9, 81,  0.5, 0.49, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Codornices*/
(9, 41, 0.5, 0.45, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Patatas*/
(9, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(9, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/

/* 10 Muslo de Pollo a al Brasa*/
(10, 28, 0.5, 0.49, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Muslo de Pollo*/
(10, 41, 0.5, 0.45, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Patatas*/
(10, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(10, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/

/* 11 Butifarra a la Brasa*/
(11, 29, 0.5, 0.49, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Butifarra de Cerdo*/
(11, 41, 0.5, 0.45, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Patatas*/
(11, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(11, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/

/* 12 Panceta a la Brasa*/
(12, 30, 0.5, 0.49, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Panceta de Cerdo*/
(12, 41, 0.5, 0.45, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Patatas*/
(12, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(12, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/

/* 13 Sepia a la Plancha*/
(13, 9, 0.5, 0.49, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sepia*/
(13, 41, 0.5, 0.45, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Patatas*/
(13, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(13, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/

/* 14 Alitas de Pollo*/
(14, 66, 0.5, 0.49, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Alitas de Pollo*/
(14, 41, 0.5, 0.45, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Patatas*/
(14, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(14, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/

/* 15 Nugets de Pollo*/
(15, 82, 0.5, 0.49, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Nugets*/
(15, 41, 0.5, 0.45, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Patatas*/
(15, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(15, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/


/* 16 Alioli*/
(15, 37, 0.002, 0.0019, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Sal*/
(1, 36, 0.02, 0.019, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Aceite*/
(1, 40, 0.005, 0.0049, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Ajo*/


/* 17 Café Solo*/
(17, 67, 0.005, 0.0049, 'Kilogramos',(Cant_Bruta - Cant_Neta) / Cant_Bruta * 100 ), /*Café*/
(17, 83, 0.1, 0.09, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Agua*/
(17, 37, 0.001, 0.0009, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Azucar*/

/* 18 Café con Leche*/
(18, 67, 0.08, 0.079, 'Kilogramos',(Cant_Bruta - Cant_Neta) / Cant_Bruta * 100 ), /*Café*/
(18, 83, 0.3, 0.29, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Agua*/
(18, 37, 0.001, 0.0009, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Azucar*/
(18, 68, 0.1, 0.1, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Leche*/

/* 19 Café Cortado*/
(19, 67, 0.005, 0.0049, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100 ), /*Café*/
(19, 83, 0.1, 0.09, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Agua*/
(19, 37, 0.001, 0.0009, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Azucar*/
(19, 68, 0.3, 0.29, 'Litros', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Leche*/

/* 22 Raja de Melon*/
(22, 34, 0.2, 0.18, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100), /*Melon*/

/* 23 Raja Sandía*/
(23, 35, 0.2, 0.18, 'Kilogramos', (Cant_Bruta - Cant_Neta) / Cant_Bruta * 100); /*Sandia*/

/* 20 Coulant de Chocolate*/
/* 21 Helado de Vainilla*/
/* 24 Flan de Huevo*/

insert into Elaborado (Codigo_Producto, PVP, IVA)
values
(49, 5.5, PVP * 0.21), /* Ensalada*/
(50, 15, PVP * 0.21), /*Paella Mixta*/
(51, 8, PVP * 0.21), /*Sopa de Rape*/
(52, 7, PVP * 0.21), /*Piña con Jamon */
(53, 5.5, PVP * 0.21), /*Ensalada Verde*/
(54, 9, PVP * 0.21), /*Torrada de Salchichón Iberico*/
(55, 13, PVP * 0.21), /*Lubina*/
(56, 10, PVP * 0.21), /*Jamoncitos de Pavo Rustidos*/
(57, 10.5, PVP * 0.21), /*Butifarra de Escalivada a la Brasa*/
(58, 11, PVP * 0.21), /*Codornices a la Brasa*/
(59, 9.50, PVP * 0.21), /*Muslo de Pollo a al Brasa */
(60, 9.50, PVP * 0.21), /*Butifarra a la Brasa*/
(61, 9.5, PVP * 0.21), /*Panceta a la Brasa*/
(62, 12.5, PVP * 0.21), /*Sepia a la Plancha*/
(63, 8.5, PVP * 0.21), /*Alitas de Pollo*/
(64, 7, PVP * 0.21), /*Nugets de Pollo*/
(65, 0.5, PVP * 0.21), /*Alioli */
(69, 1.2, PVP * 0.21), /*Café Solo*/
(70,  1.2, PVP * 0.21), /*Café con Leche*/
(71, 1.2, PVP * 0.21), /*Café Cortado*/
(72,  5, PVP * 0.21), /*Coulant de Chocolate*/
(73, 3, PVP * 0.21), /*Helado de Vainilla*/
(74, 2, PVP * 0.21), /*Raja de Melón*/
(75, 2, PVP * 0.21), /*Raja de Sandía*/
(76, 3.5, PVP * 0.21), /*Flan de Huevo*/
(77, 2.5, PVP * 0.21), /*Zumo de Piña (Venta)*/
(79, 2.5, PVP * 0.21), /*Zumo de Melocoton (Venta)*/
(84, 1.5, PVP * 0.21), /*Agua (Venta)*/
(85, 2, PVP * 0.21), /*Cocacola (Venta)*/
(86, 2, PVP * 0.21), /*Aquarius (Venta)*/
(87, 2, PVP * 0.21), /*Cerveza (Venta)*/
(88, 15, PVP * 0.21), /*Vino (Venta)*/
(89, 1, PVP * 0.21); /*Gaseosa (Venta)*/

insert into Alergenos_Producto (Codigo_Producto, alergeno)
values
(1, 'Sulfitos'), /*Lechuga*/
(2,'Sulfitos' ), /*Tomate*/
(3, 'Sulfitos'), /*Zanahoria*/
(4,'Sulfitos'), /*Olivas Verdes*/
(5, null ), /*Cebolla*/
(6, null ), /*Zumo de Piña*/
(7, null), /*Arroz*/
(8, 'Crustáceos'), /*Gambas*/
(9, 'Pescado'), /*Sepia*/
(10, 'Sulfitos'), /*Conejo*/
(11, 'Sulfitos'), /*Judia Tierna*/
(12, 'Sulfitos'), /*Alcachofa*/
(13, 'Sulfitos'), /*Pimiento Rojo*/
(14, null), /*Azafran*/
(15, 'Pescado'), /*Rape*/
(16, 'Gluten'), /*Pasta para Sopa*/
(17, 'Sulfitos'), /*Puerro*/
(18,'Apio'), /*Apio*/
(19, 'Sulfitos'), /*Nabo*/
(20, 'Sulfitos'), /*Piña*/
(21, 'Sulfitos'), /*Jamon*/
(22, 'Gluten'), /*Pan de Pages*/
(23, 'Sulfitos'), /*Salchichon Iberico*/
(24, 'Sulfitos'), /* Lubina*/
(25, 'Sulfitos'), /*Tacos de Jamon*/
(26, 'Sulfitos'), /*Butifarra de Escalivada*/
(27, 'Sulfitos'), /*Morro de Cerdo*/
(28, 'Sulfitos'), /* Muslo de Pollo*/
(29, 'Sulfitos'), /*Butifarra de Cerdo*/
(30, 'Sulfitos'), /*Panceta de Cerdo*/
(31, 'Sulfitos'), /*Alitas de Pollo*/
(32, 'Gluten'), /*Barra de Pan*/
(33, 'Huevo'), /*Huevos*/
(34, 'Sulfitos'), /*Melon*/
(35, 'Sulfitos'), /*Sandia*/
(36, null), /*Aceite*/
(37, null), /*Sal*/
(38, null), /*Azucar*/
(39, 'Sulfitos'), /*Vinagre*/
(40, 'Sulfitos'), /*Ajo*/
(41, 'Sulfitos'), /*Patatas*/
(42, null), /*Ketchup*/
(43, null), /*Mayonesa*/
(44, 'Sulfitos'), /*Cocacola*/
(45, 'Sulfitos'), /*Aquarius*/
(46, 'Sulfitos'), /*Cerveza*/
(47, 'Sulfitos'), /*Vino*/
(48, 'Sulfitos'), /*Gaseosa*/
(66, 'Sulfitos'), /*Alitas de pollo*/
(67, null), /*Café*/
(68, 'Lactosa'), /*Leche*/
(78, 'Sulfitos'), /*Zumo de Melocoton*/
(80, 'Sulfitos'), /*Pavo*/
(81, 'Sulfitos'), /*Codornices*/
(82, 'Sulfitos'), /*Nugets de Pollo*/
(83, null); /*Agua*/

/*EJERCICIO 7*/
insert into Sala (numSala)
values 
(1),
(2);

insert into Comanda (Id_Comanda, fecha, Mesa, hora, comensales, ticket, numSala)
values
(1, '2022-10-4', 2, '14:00:00', 2, 15, 1),
(2, '2022-10-5', 4, '14:03:00', 4, 16, 1),
(3, '2022-10-6', 5, '14:05:00', 3, 17, 1),
(4, '2022-10-7', 3, '14:10:00', 4, 18, 1),
(5, '2022-10-8', 1, '14:15:00', 2, 19, 1),
(6, '2022-10-9', 10, '14:20:00', 3, 20, 2),
(7, '2022-10-10', 8, '14:22:00', 2, 21, 2),
(8, '2022-10-11', 7, '14:28:00', 1, 22, 2),
(9, '2022-10-12', 9, '14:36:00', 6, 23, 2),
(10, '2022-10-13', 6, '14:40:00', 3, 24, 2);

insert into Comanda_Platos (Id_Comanda, Codigo_Plato, cantidad, PVP, IVA, numSala)
values
(1, 1, 2, 5.5 * cantidad, PVP* 0.21, 1), /*Paella*/
(1, 4, 2, 5.5 * cantidad, PVP* 0.21, 1), /*Ensalada Verde*/
(1, 20, 1, 5 * cantidad, PVP* 0.21, 1), /*Coulant*/
(1, 17, 1, 1.2 * cantidad, PVP* 0.21, 1), /*Café Solo*/
(1, 19, 1, 1.2 * cantidad, PVP* 0.21, 1), /*Café Cortado*/
(2, 4, 4, 5.5 * cantidad, PVP* 0.21, 1), /*Ensalada Verde*/
(2, 1, 1, 5.5 * cantidad, PVP* 0.21, 1), /*Paella*/
(2, 9, 2, 11 *cantidad, PVP* 0.21, 1), /*Codornices*/
(2, 10, 1, 9.5 * cantidad, PVP* 0.21, 1), /*Muslo de Pollo*/
(2, 21, 1, 3 * cantidad, PVP* 0.21, 1), /*Helado de Vainilla*/
(3, 5, 2, 9 * cantidad, PVP* 0.21, 1), /*Torradas de Salchichon*/
(3, 2, 1, 8 * cantidad, PVP* 0.21, 1), /*Sopa de Rape*/
(3, 11, 1, 7 * cantidad, PVP* 0.21, 1), /*Butifarra a la Brasa*/
(3, 10, 1, 7 * cantidad, PVP* 0.21, 1), /*Muslo de Pollo*/
(3, 24, 1, 3.5 * cantidad, PVP* 0.21, 1), /*Flan de Huevo*/
(3, 20, 1, 5 * cantidad, PVP* 0.21, 1), /*Coulant*/
(3, 21, 1, 3 * cantidad, PVP* 0.21, 1), /*Helado de Vainilla*/
(4, 2, 3, 8 * cantidad, PVP* 0.21, 1), /*Sopa de Rape*/
(4, 4, 2, 5.5 * cantidad, PVP* 0.21, 1), /*Ensalada Verde*/
(4, 10, 3, 9.5 * cantidad, PVP* 0.21, 1), /*Muslo de Pollo*/
(4, 13, 1, 12.5 * cantidad, PVP* 0.21, 1), /*Sepia a la Plancha*/
(4, 17, 4, 1.2 * cantidad, PVP* 0.21, 1), /*Café Solo*/
(5, 5, 1, 9 * cantidad, PVP* 0.21, 1), /*Torradas de Salchichon*/
(5, 3, 1, 7 * cantidad, PVP* 0.21, 1), /*Piña con Jamón*/
(5, 11, 1, 7 * cantidad, PVP* 0.21, 1), /*Butifarra a la Brasa*/
(5, 7, 1, 7 * cantidad, PVP* 0.21, 1), /*Jamoncitos de Pavo Rustidos*/
(5, 24, 1, 3.5 * cantidad, PVP* 0.21, 1), /*Flan de Huevo*/
(5, 21, 1, 3 * cantidad, PVP* 0.21, 1), /*Helado de Vainilla*/
(6, 4, 2, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(6, 5, 1, 9 * cantidad, PVP* 0.21, 2), /*Torradas de Salchichon*/
(6, 10, 1, 9.5 * cantidad, PVP* 0.21, 2), /*Muslo de Pollo*/
(6, 13, 1, 12.5 * cantidad, PVP* 0.21, 2), /*Sepia a la Plancha*/
(6, 8, 1, 7 * cantidad, PVP* 0.21, 2), /*Butifarra de Escalivada*/
(6, 20, 1, 5 * cantidad, PVP* 0.21, 2), /*Coulant*/
(6, 24, 1, 3.5 * cantidad, PVP* 0.21, 2), /*Flan de Huevo*/
(6, 22, 1, 5 * cantidad, PVP* 0.21, 2), /*Raja de Melón*/
(6, 18, 1, 1.2 * cantidad, PVP* 0.21, 2), /*Café con Leche*/
(6, 17, 2, 1.2 * cantidad, PVP* 0.21, 2), /*Café Solo*/
(7, 4, 1, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(7, 2, 1, 8 * cantidad, PVP* 0.21, 2), /*Sopa de Rape*/
(7, 1, 2, 5.5 * cantidad, PVP* 0.21, 2), /*Paella*/
(7, 4, 1, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(7, 19, 2, 1.2 * cantidad, PVP* 0.21, 2), /*Café Cortado*/
(8, 4, 1, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(8, 6, 1, 13 * cantidad, PVP* 0.21, 2), /*Lubina*/
(8, 20, 1, 5 * cantidad, PVP* 0.21, 2), /*Coulant*/
(8, 17, 1, 1.2 * cantidad, PVP* 0.21, 2), /*Café Solo*/
(9, 4, 3, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(9, 2, 3, 8 * cantidad, PVP* 0.21, 2), /*Sopa de Rape*/
(9, 1, 4, 5.5 * cantidad, PVP* 0.21, 2), /*Paella*/
(9, 14, 1, 8.5 * cantidad, PVP* 0.21, 2), /*Alitas*/
(9, 21, 1, 6 * cantidad, PVP* 0.21, 2), /*Helado de Vainilla*/
(10, 4, 1, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(10, 2, 1, 8 * cantidad, PVP* 0.21, 2), /*Sopa de Rape*/
(10, 3, 1, 7 * cantidad, PVP* 0.21, 2), /*Piña con Jamón*/
(10, 13, 1, 12.5 * cantidad, PVP* 0.21, 2), /*Sepia a la Plancha*/
(10, 11, 1, 7 * cantidad, PVP* 0.21, 2), /*Butifarra a la Brasa*/
(10, 22, 3, 5 * cantidad, PVP* 0.21, 2), /*Raja de Melón*/
(10, 17, 1, 1.2 * cantidad, PVP* 0.21, 2), /*Café Solo*/
(10, 19, 1, 1.2 * cantidad, PVP* 0.21, 2); /*Café Cortado*/

insert into Donaciones (fecha)
Values
('2022-09-01'),
('2022-09-02'),
('2022-09-03'),
('2022-09-04'),
('2022-09-05'),
('2022-09-06'),
('2022-09-07'),
('2022-09-08'),
('2022-09-09'),
('2022-09-20');

insert into Detalle_Donacion (fecha, Codigo_Producto, cantidad, observaciones)
values
('2022-09-01', 7, 2, 'Donamos Arroz'),
('2022-09-02', 16, 3, 'Donamos Pasta para Sopa'),
('2022-09-03', 3, 1, 'Donamos Zanahorias'),
('2022-09-04', 23, 2, 'Donamos Salchichon Iberico'),
('2022-09-05', 11, 3, 'Donamos Judia Tierna'),
('2022-09-06', 21, 0.5, 'Donamos Jamon'),
('2022-09-07', 28, 5, 'Donamos Muslos de Pollo'),
('2022-09-08', 33, 2, 'Donamos Huevos'),
('2022-09-09', 6, 20, 'Donamos Zumo de Piña'),
('2022-09-20', 31, 5, 'Donamos Alitas de Pollo');

insert into Compras_Producto (Codigo_Producto, NIF, fecha, cantidad, precio, IVA, caducidad)
values
(1, 'B90307034', '2022-08-20', 5, 0.3 * cantidad, precio * 0.21, '2022-08-30'), /*Lechuga*/
(7, 'A28647451', '2022-08-21', 15, 0.5 * cantidad, precio * 0.21, '2023-08-22'), /*Arroz*/
(28, 'A58085135', '2022-08-22', 10, 2 * cantidad, precio * 0.21, '2022-08-31'), /*Muslo de Mollo*/
(67, 'A60177623', '2022-08-23', 5, 1 * cantidad, precio * 0.21, '2022-08-30'), /*Café*/
(31, 'A58085135', '2022-08-24', 10, 2 * cantidad, precio * 0.21, '2022-08-31'), /*Alitas de Pollo*/
(44, 'A28647451', '2022-08-25', 200, 0.1 * cantidad, precio * 0.21, '2024-12-15'), /*Cocacola*/
(21, 'A58085135', '2022-08-26', 6, 40* cantidad, precio * 0.21, '2022-09-20'), /*Jamon*/
(5, 'B90307034', '2022-08-27', 3, 0.4 * cantidad, precio * 0.21, '2022-09-10'), /*Cebolla*/
(46, 'B65639155', '2022-08-28', 200, 0.10 * cantidad, precio * 0.21, '2024-11-11'), /*Cerveza*/
(41, 'A01189364', '2022-08-29', 8, 2.5 * cantidad, precio * 0.21, '2022-09-11'); /*Patatas*/

insert into Comanda_Elaborados (Id_Comanda, Codigo_Producto, cantidad, PVP, IVA, numSala)
values
(1, 50, 2, 5.5 * cantidad, PVP* 0.21, 1), /*Paella*/
(1, 49, 2, 5.5 * cantidad, PVP* 0.21, 1), /*Ensalada Verde*/
(1, 72, 1, 5 * cantidad, PVP* 0.21, 1), /*Coulant*/
(1, 69, 1, 1.2 * cantidad, PVP* 0.21, 1), /*Café Solo*/
(1, 71, 1, 1.2 * cantidad, PVP* 0.21, 1), /*Café Cortado*/
(2, 53, 4, 5.5 * cantidad, PVP* 0.21, 1), /*Ensalada Verde*/
(2, 50, 1, 5.5 * cantidad, PVP* 0.21, 1), /*Paella*/
(2, 58, 2, 11 * cantidad, PVP* 0.21, 1), /*Codornices*/
(2, 10, 1, 9.5 * cantidad, PVP* 0.21, 1), /*Muslo de Pollo*/
(2, 73, 1, 3 * cantidad, PVP* 0.21, 1), /*Helado de Vainilla*/
(3, 54, 2, 9 * cantidad, PVP* 0.21, 1), /*Torradas de Salchichon*/
(3, 51, 1, 8 * cantidad, PVP* 0.21, 1), /*Sopa de Rape*/
(3, 60, 1, 7 * cantidad, PVP* 0.21, 1), /*Butifarra a la Brasa*/
(3, 59, 1, 7 * cantidad, PVP* 0.21, 1), /*Muslo de Pollo*/
(3, 76, 1, 3.5 * cantidad, PVP* 0.21, 1), /*Flan de Huevo*/
(3, 72, 1, 5 * cantidad, PVP* 0.21, 1), /*Coulant*/
(3, 73, 1, 3 * cantidad, PVP* 0.21, 1), /*Helado de Vainilla*/
(4, 51, 3, 8 * cantidad, PVP* 0.21, 1), /*Sopa de Rape*/
(4, 53, 2, 5.5 * cantidad, PVP* 0.21, 1), /*Ensalada Verde*/
(4, 59, 3, 9.5 * cantidad, PVP* 0.21, 1), /*Muslo de Pollo*/
(4, 13, 1, 12.5 * cantidad, PVP* 0.21, 1), /*Sepia a la Plancha*/
(4, 69, 4, 1.2 * cantidad, PVP* 0.21, 1), /*Café Solo*/
(5, 54, 1, 9 * cantidad, PVP* 0.21, 1), /*Torradas de Salchichon*/
(5, 52, 1, 7 * cantidad, PVP* 0.21, 1), /*Piña con Jamón*/
(5, 60, 1, 7 * cantidad, PVP* 0.21, 1), /*Butifarra a la Brasa*/
(5, 56, 1, 7 * cantidad, PVP* 0.21, 1), /*Jamoncitos de Pavo Rustidos*/
(5, 76, 1, 3.5 * cantidad, PVP* 0.21, 1), /*Flan de Huevo*/
(5, 73, 1, 3 * cantidad, PVP* 0.21, 1), /*Helado de Vainilla*/
(6, 53, 2, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(6, 54, 1, 9 * cantidad, PVP* 0.21, 2), /*Torradas de Salchichon*/
(6, 59, 1, 9.5 * cantidad, PVP* 0.21, 2), /*Muslo de Pollo*/
(6, 62, 1, 12.5 * cantidad, PVP* 0.21, 2), /*Sepia a la Plancha*/
(6, 57, 1, 7 * cantidad, PVP* 0.21, 2), /*Butifarra de Escalivada*/
(6, 72, 1, 5 * cantidad, PVP* 0.21, 2), /*Coulant*/
(6, 76, 1, 3.5 * cantidad, PVP* 0.21, 2), /*Flan de Huevo*/
(6, 74, 1, 5 * cantidad, PVP* 0.21, 2), /*Raja de Melón*/
(6, 70, 1, 1.2 * cantidad, PVP* 0.21, 2), /*Café con Leche*/
(6, 69, 2, 1.2 * cantidad, PVP* 0.21, 2), /*Café Solo*/
(7, 53, 1, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(7, 51, 1, 8 * cantidad, PVP* 0.21, 2), /*Sopa de Rape*/
(7, 50, 2, 5.5 * cantidad, PVP* 0.21, 2), /*Paella*/
(7, 53, 1, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(7, 71, 2, 1.2 * cantidad, PVP* 0.21, 2), /*Café Cortado*/
(8, 53, 1, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(8, 55, 1, 13 * cantidad, PVP* 0.21, 2), /*Lubina*/
(8, 72, 1, 5 * cantidad, PVP* 0.21, 2), /*Coulant*/
(8, 69, 1, 1.2 * cantidad, PVP* 0.21, 2), /*Café Solo*/
(9, 53, 3, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(9, 51, 3, 8 * cantidad, PVP* 0.21, 2), /*Sopa de Rape*/
(9, 50, 4, 5.5 * cantidad, PVP* 0.21, 2), /*Paella*/
(9, 63, 1, 8.5 * cantidad, PVP* 0.21, 2), /*Alitas*/
(9, 73, 1, 6 * cantidad, PVP* 0.21, 2), /*Helado de Vainilla*/
(10, 53, 1, 5.5 * cantidad, PVP* 0.21, 2), /*Ensalada Verde*/
(10, 51, 1, 8 * cantidad, PVP* 0.21, 2), /*Sopa de Rape*/
(10, 52, 1, 7 * cantidad, PVP* 0.21, 2), /*Piña con Jamón*/
(10, 62, 1, 12.5 * cantidad, PVP* 0.21, 2), /*Sepia a la Plancha*/
(10, 60, 1, 7 * cantidad, PVP* 0.21, 2), /*Butifarra a la Brasa*/
(10, 74, 3, 5 * cantidad, PVP* 0.21, 2), /*Raja de Melón*/
(10, 69, 1, 1.2 * cantidad, PVP* 0.21, 2), /*Café Solo*/
(10, 71, 1, 1.2 * cantidad, PVP* 0.21, 2); /*Café Cortado*/







/*sentencias SELECT*/
select * from Proveedor;
select * from Producto;
select * from comanda;
select * from alergeno;
select * from Categoria;
select * from Tipo_Platos;
select * from Elaborado;
select * from Plato;
select* from Ingredientes_Plato;
select * from Comanda_Platos;

/*sentencias DELETE*/
delete from  producto 
where Codigo_Producto >= 1;

delete from  Ingredientes_Plato 
where Codigo_Plato >= 1;

delete from  Elaborado
where Codigo_Producto >= 1;

delete from  Comanda
where Id_Comanda >= 1;

delete from  Comanda_Platos
where Id_Comanda >= 1;

/*sentencias DROP*/
drop database rosticeria;
drop table proveedor;
drop table Alergenos_Producto;
drop table Donaciones;
drop table Detalle_Donacion;
drop table compras_Producto;
drop table elaborado;
drop table indrediente;
drop table producto;
drop table comanda;
drop table Comanda_Elaborados;
drop table Comanda_Platos;
drop table Sala;

