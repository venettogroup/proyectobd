
-- Retorna la carrera de un estudiante,sirev para validar que el estudiante se encuebtre activo

CREATE OR REPLACE FUNCTION carrera_estudiante(codigo_estudiante integer)
  RETURNS integer AS
$carrera_estudiante$
declare c int;
declare consulta char(70);
begin
    -- Hay que repetir este if por cada facultad
	consulta := concat('select id_carr from estudiantes where cod_e =',codigo_estudiante); 
	select * from dblink('dbname=universidad user=postgres password=sa',consulta) 
	as (carr int)into c;
       RETURN c;
END
$carrera_estudiante$ LANGUAGE plpgsql;	

-- Verica un préstamo de lbros en la biblioteca,valida que el estudiante esté
-- inscrito en una carrera
CREATE OR REPLACE FUNCTION verificar_prestamo()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare 
begin 
	if (TG_OP = 'INSERT' ) then
		if carrera_estudiante(new.cod_e) is not null then
			return new;
		else 
			return null;
			end if;
	end if;
end
$function$;

-- Impide que se registre un préstamo para un estudiante no registrado
create trigger verificar_prestamo before insert or update on presta for each row execute procedure verificar_prestamo();
 

-- Inserta un préstamo en la base de datos
create or replace function insertar_prestamo(cod_estudiante int, isbn_p numeric, num_ej_p int )
returns void as $insertar_prestamo$
declare 
begin 
	insert into presta(cod_e,isbn,num_ej, fech_p) values (cod_estudiante,isbn_p, num_ej_p, now());
end
$insertar_prestamo$ language plpgsql;

-- Retorna  un préstamo en la base de datos 
create or replace function retornar_prestamo(cod_estudiante int, isbn_p numeric, num_ej_p int )
returns void as $verificar_estudiante$
declare 
begin 
	update  presta set
		fech_d = now()
	where 
		cod_e = cod_estudiante and
		isbn = isbn_p and
		num_ej = num_ej_p and
		fech_d is null;
end
$verificar_estudiante$ language plpgsql;
