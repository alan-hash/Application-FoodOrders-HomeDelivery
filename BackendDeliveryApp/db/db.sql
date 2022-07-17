USE delivery;

CREATE TABLE users(
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(180) NOT NULL UNIQUE,
    name VARCHAR(90) NOT NULL,
    lastname VARCHAR(90) NOT NULL,
    phone VARCHAR(90) NOT NULL UNIQUE,
    image VARCHAR(255) NULL,
    password VARCHAR(90) NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL
);

CREATE TABLE roles(
id bigint primary key auto_increment,
name varchar(90) NOT NULL unique,
image varchar(255) NULL,
route varchar(180) Not null,
created_at timestamp(0) Not Null,
updated_at timestamp(0) Not Null

);

INSERT INTO roles(
name,
route,
created_at,
updated_at

)
values(
'RESTAURANTE',
'/restaurant/orders/list',
'2022-07-13',
'2022-07-13'
);


INSERT INTO roles(
name,
route,
created_at,
updated_at

)
values(
'REPARTIDOR',
'/delivery/orders/list',
'2022-07-13',
'2022-07-13'
);



INSERT INTO roles(
name,
route,
created_at,
updated_at

)
values(
'CLIENTE',
'/client/products/list',
'2022-07-13',
'2022-07-13'
);

create table user_has_roles(
id_user BIGINT NOT NULL,
id_rol BIGINT NOT NULL,
created_at timestamp(0) Not Null,
updated_at timestamp(0) Not Null,

foreign key(id_user) references users(id) on update cascade ON delete cascade,
foreign key(id_rol) references roles(id) on update cascade ON delete cascade,
primary key(id_user, id_rol)

);
