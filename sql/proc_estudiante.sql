////

CREATE VIEW universidad.consultas_notas AS 
(
	Select cod_e,cod_a, id_p, n1, n2, n3, coalesce(n1,0)*0.35+coalesce(n2,0)*.35+coalesce(n3,0)*.3 Promedio from universidad.estudiantes natural join universidad.inscribe 
)

create or replace function universidad.consultas_estudiante() returns setof universidad.consultas_notas as $body$
declare 
	r universidad.consultas_notas;
begin
for r in 

  SELECT cod_e AS codigo, cod_a AS codigo_asignatura, n1, n2, n3,promedio FROM universidad.consultas_notas where cod_e =  (SELECT CURRENT_USER::integer)

loop 
return next r;
end loop;
return;
end
$body$
language 'plpgsql';


select * from universidad.consultas_estudiante()
