
  -- select que a vivian fez pa nois  É PRA USAR ESSE
SELECT 
    CASE
        WHEN temperatura > 7 OR temperatura < 2 THEN 'Crítico'
        WHEN temperatura > 4.4 AND temperatura < 6.6 THEN 'Ideal'
        WHEN temperatura > 2.2 AND temperatura < 4.4 THEN 'Alerta'
        ELSE 'Outro'
    END AS status,
    DAYNAME(dataHoraRegistro) AS dia_semana,
    fkLocal
FROM
    registro
WHERE
    YEARWEEK(dataHoraRegistro) = YEARWEEK(CURDATE())
    group by fkLocal, dia_semana;
select fkLocal, DAYNAME(dataHoraRegistro) as 'dia_semana', count(temperatura) as statusCritico from registro where temperatura > 7 OR temperatura < 2 group by fkLocal, DAYNAME(dataHoraRegistro);

-- select visão semanal
SELECT r.temperatura, r.dataHoraRegistro, DATE_FORMAT(r.dataHoraRegistro, '%Y%m%d') AS dia
    FROM registro r
    JOIN (
      SELECT fkLocal, MAX(dataHoraRegistro) AS maxDataHoraRegistro
      FROM registro
      WHERE dataHoraRegistro >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
      GROUP BY fkLocal
    ) subquery
    ON r.fkLocal = subquery.fkLocal AND r.dataHoraRegistro = subquery.maxDataHoraRegistro
    WHERE r.dataHoraRegistro >= CURDATE()
    ORDER BY r.dataHoraRegistro DESC;        