CREATE TABLE public.autores (
	id_a int4 NOT NULL,
	nom_autor varchar(50) NULL,
	nacionalidad varchar(50) NULL DEFAULT 0,
	CONSTRAINT autores_pk PRIMARY KEY (id_a)
);


CREATE TABLE public.ejemplares (
	isbn numeric(14) NOT NULL,
	num_ej int4 NOT NULL
);


CREATE TABLE public.escribe (
	isbn int4 NOT NULL,
	id_a int4 NOT NULL,
	CONSTRAINT escribe_pk PRIMARY KEY (isbn, id_a)
);

