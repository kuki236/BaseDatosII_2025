CREATE TABLESPACE suppliers_parts_ts
DATAFILE 'C:\APP\SEBAS\PRODUCT\21C\ORADATA\XE\suppliers_parts_01.dbf'
SIZE 50M
AUTOEXTEND ON
NEXT 5M
MAXSIZE 100M
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO
LOGGING;

CREATE TEMPORARY TABLESPACE temp_suppliers_parts
TEMPFILE 'C:\APP\SEBAS\PRODUCT\21C\ORADATA\XE\temp_suppliers_parts_01.dbf'
SIZE 20M
EXTENT MANAGEMENT LOCAL
UNIFORM SIZE 2M;

CREATE TABLE S (
    S# VARCHAR2(5) PRIMARY KEY,
    SNAME VARCHAR2(20) NOT NULL,
    STATUS NUMBER(3) NOT NULL,
    CITY VARCHAR2(20) NOT NULL
) TABLESPACE suppliers_parts_ts;

CREATE TABLE P (
    P# VARCHAR2(5) PRIMARY KEY,
    PNAME VARCHAR2(20) NOT NULL,
    COLOR VARCHAR2(10) NOT NULL,
    WEIGHT NUMBER(5,2) NOT NULL,
    CITY VARCHAR2(20) NOT NULL
) TABLESPACE suppliers_parts_ts;

CREATE TABLE J (
    J# VARCHAR2(5) PRIMARY KEY,
    JNAME VARCHAR2(20) NOT NULL,
    CITY VARCHAR2(20) NOT NULL
) TABLESPACE suppliers_parts_ts;

CREATE TABLE SP (
    S# VARCHAR2(5),
    P# VARCHAR2(5),
    QTY NUMBER(6) NOT NULL,
    CONSTRAINT pk_sp PRIMARY KEY (S#, P#),
    CONSTRAINT fk_sp_s FOREIGN KEY (S#) REFERENCES S(S#),
    CONSTRAINT fk_sp_p FOREIGN KEY (P#) REFERENCES P(P#)
) TABLESPACE suppliers_parts_ts;

CREATE TABLE SPJ (
    S# VARCHAR2(5),
    P# VARCHAR2(5),
    J# VARCHAR2(5),
    QTY NUMBER(6) NOT NULL,
    CONSTRAINT pk_spj PRIMARY KEY (S#, P#, J#),
    CONSTRAINT fk_spj_s FOREIGN KEY (S#) REFERENCES S(S#),
    CONSTRAINT fk_spj_p FOREIGN KEY (P#) REFERENCES P(P#),
    CONSTRAINT fk_spj_j FOREIGN KEY (J#) REFERENCES J(J#)
) TABLESPACE suppliers_parts_ts;

INSERT INTO S VALUES ('S1', 'Smith', 20, 'London');
INSERT INTO S VALUES ('S2', 'Jones', 10, 'Paris');
INSERT INTO S VALUES ('S3', 'Blake', 30, 'Paris');
INSERT INTO S VALUES ('S4', 'Clark', 20, 'London');
INSERT INTO S VALUES ('S5', 'Adams', 30, 'Athens');

INSERT INTO P VALUES ('P1', 'Nut', 'Red', 12, 'London');
INSERT INTO P VALUES ('P2', 'Bolt', 'Green', 17, 'Paris');
INSERT INTO P VALUES ('P3', 'Screw', 'Blue', 17, 'Rome');
INSERT INTO P VALUES ('P4', 'Screw', 'Red', 14, 'London');
INSERT INTO P VALUES ('P5', 'Cam', 'Blue', 12, 'Paris');
INSERT INTO P VALUES ('P6', 'Cog', 'Red', 19, 'London');

INSERT INTO J VALUES ('J1', 'Sorter', 'Paris');
INSERT INTO J VALUES ('J2', 'Display', 'Rome');
INSERT INTO J VALUES ('J3', 'OCR', 'Athens');
INSERT INTO J VALUES ('J4', 'Console', 'Athens');
INSERT INTO J VALUES ('J5', 'RAID', 'London');
INSERT INTO J VALUES ('J6', 'EDS', 'Oslo');
INSERT INTO J VALUES ('J7', 'Tape', 'London');

INSERT INTO SP VALUES ('S1', 'P1', 300);
INSERT INTO SP VALUES ('S1', 'P2', 200);
INSERT INTO SP VALUES ('S1', 'P3', 400);
INSERT INTO SP VALUES ('S1', 'P4', 200);
INSERT INTO SP VALUES ('S1', 'P5', 100);
INSERT INTO SP VALUES ('S1', 'P6', 100);
INSERT INTO SP VALUES ('S2', 'P1', 300);
INSERT INTO SP VALUES ('S2', 'P2', 400);
INSERT INTO SP VALUES ('S3', 'P2', 200);
INSERT INTO SP VALUES ('S4', 'P2', 200);
INSERT INTO SP VALUES ('S4', 'P4', 300);
INSERT INTO SP VALUES ('S4', 'P5', 400);

INSERT INTO SPJ VALUES ('S1', 'P1', 'J1', 200);
INSERT INTO SPJ VALUES ('S1', 'P1', 'J4', 700);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J1', 400);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J2', 200);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J3', 200);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J4', 500);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J5', 600);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J6', 400);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J7', 800);
INSERT INTO SPJ VALUES ('S2', 'P5', 'J2', 100);
INSERT INTO SPJ VALUES ('S3', 'P3', 'J1', 200);
INSERT INTO SPJ VALUES ('S3', 'P4', 'J2', 500);
INSERT INTO SPJ VALUES ('S4', 'P6', 'J3', 300);
INSERT INTO SPJ VALUES ('S4', 'P6', 'J7', 300);
INSERT INTO SPJ VALUES ('S5', 'P2', 'J2', 200);
INSERT INTO SPJ VALUES ('S5', 'P2', 'J4', 100);
INSERT INTO SPJ VALUES ('S5', 'P5', 'J5', 500);
INSERT INTO SPJ VALUES ('S5', 'P5', 'J7', 100);
INSERT INTO SPJ VALUES ('S5', 'P6', 'J2', 200);
INSERT INTO SPJ VALUES ('S5', 'P1', 'J4', 100);
INSERT INTO SPJ VALUES ('S5', 'P3', 'J4', 200);
INSERT INTO SPJ VALUES ('S5', 'P4', 'J4', 800);
INSERT INTO SPJ VALUES ('S5', 'P5', 'J4', 400);
INSERT INTO SPJ VALUES ('S5', 'P6', 'J4', 500);

COMMIT;

-- 4.1.1 Obtenga el color y ciudad para las partes que no son de París, con un peso mayor de diez.
CREATE OR REPLACE PROCEDURE SP_PARTES_NO_PARIS_PESO_MAYOR_10 IS
BEGIN
    FOR rec IN (
        SELECT P#, PNAME, COLOR, CITY, WEIGHT
        FROM P
        WHERE CITY != 'Paris' AND WEIGHT > 10
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Parte: ' || rec.P# || ', Nombre: ' || rec.PNAME || 
                           ', Color: ' || rec.COLOR || ', Ciudad: ' || rec.CITY || 
                           ', Peso: ' || rec.WEIGHT);
    END LOOP;
END;
/

-- 4.1.2 Para todas las partes, obtenga el número de parte y el peso de dichas partes en gramos.
CREATE OR REPLACE PROCEDURE SP_PARTES_PESO_GRAMOS IS
BEGIN
    FOR rec IN (
        SELECT P#, PNAME, WEIGHT AS WEIGHT_LIBRAS, ROUND(WEIGHT * 453.592, 2) AS WEIGHT_GRAMOS
        FROM P
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Parte: ' || rec.P# || ', Nombre: ' || rec.PNAME || 
                           ', Peso(lb): ' || rec.WEIGHT_LIBRAS || 
                           ', Peso(g): ' || rec.WEIGHT_GRAMOS);
    END LOOP;
END;
/

-- 4.1.3 Obtenga el detalle completo de todos los proveedores.
CREATE OR REPLACE PROCEDURE SP_DETALLE_PROVEEDORES IS
BEGIN
    FOR rec IN (
        SELECT S#, SNAME, STATUS, CITY
        FROM S
        ORDER BY S#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor: ' || rec.S# || ', Nombre: ' || rec.SNAME || 
                           ', Status: ' || rec.STATUS || ', Ciudad: ' || rec.CITY);
    END LOOP;
END;
/

-- 4.1.4 Obtenga todas las combinaciones de proveedores y partes para aquellos proveedores y partes co-localizados.
CREATE OR REPLACE PROCEDURE SP_PROVEEDORES_PARTES_COLOCALIZADOS IS
BEGIN
    FOR rec IN (
        SELECT S.S#, S.SNAME, P.P#, P.PNAME, S.CITY
        FROM S
        INNER JOIN P ON S.CITY = P.CITY
        ORDER BY S.CITY, S.S#, P.P#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor: ' || rec.S# || ' (' || rec.SNAME || 
                           '), Parte: ' || rec.P# || ' (' || rec.PNAME || 
                           '), Ciudad: ' || rec.CITY);
    END LOOP;
END;
/

-- 4.1.5 Obtenga todos los pares de nombres de ciudades de tal forma que el proveedor localizado en la primera ciudad del par abastece una parte almacenada en la segunda ciudad del par.
CREATE OR REPLACE PROCEDURE SP_CIUDADES_PROVEEDOR_PARTE IS
BEGIN
    FOR rec IN (
        SELECT DISTINCT S.CITY AS CIUDAD_PROVEEDOR, P.CITY AS CIUDAD_PARTE
        FROM S
        INNER JOIN SP ON S.S# = SP.S#
        INNER JOIN P ON SP.P# = P.P#
        ORDER BY S.CITY, P.CITY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Ciudad Proveedor: ' || rec.CIUDAD_PROVEEDOR || 
                           ' -> Ciudad Parte: ' || rec.CIUDAD_PARTE);
    END LOOP;
END;
/

-- 4.1.6 Obtenga todos los pares de número de proveedor tales que los dos proveedores del par estén co-localizados.
CREATE OR REPLACE PROCEDURE SP_PARES_PROVEEDORES_COLOCALIZADOS IS
BEGIN
    FOR rec IN (
        SELECT S1.S# AS PROVEEDOR1, S2.S# AS PROVEEDOR2, S1.CITY
        FROM S S1
        INNER JOIN S S2 ON S1.CITY = S2.CITY AND S1.S# < S2.S#
        ORDER BY S1.CITY, S1.S#, S2.S#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor 1: ' || rec.PROVEEDOR1 || 
                           ', Proveedor 2: ' || rec.PROVEEDOR2 || 
                           ', Ciudad: ' || rec.CITY);
    END LOOP;
END;
/

-- 4.1.7 Obtenga el número total de proveedores.
CREATE OR REPLACE FUNCTION FN_TOTAL_PROVEEDORES
RETURN NUMBER IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total FROM S;
    RETURN v_total;
END;
/

-- 4.1.8 Obtenga la cantidad mínima y la cantidad máxima para la parte P2.
CREATE OR REPLACE FUNCTION FN_MIN_MAX_CANTIDAD_P2(
    p_min OUT NUMBER,
    p_max OUT NUMBER
) RETURN VARCHAR2 IS
BEGIN
    SELECT NVL(MIN(QTY), 0), NVL(MAX(QTY), 0)
    INTO p_min, p_max
    FROM SP
    WHERE P# = 'P2';
    
    RETURN 'OK';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_min := 0;
        p_max := 0;
        RETURN 'NO_DATA';
END;
/

-- 4.1.9 Para cada parte abastecida, obtenga el número de parte y el total despachado.
CREATE OR REPLACE PROCEDURE SP_TOTAL_DESPACHADO_POR_PARTE IS
BEGIN
    FOR rec IN (
        SELECT P#, SUM(QTY) AS TOTAL_DESPACHADO
        FROM SP
        GROUP BY P#
        ORDER BY P#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Parte: ' || rec.P# || ', Total Despachado: ' || rec.TOTAL_DESPACHADO);
    END LOOP;
END;
/

-- 4.1.10 Obtenga el número de parte para todas las partes abastecidas por más de un proveedor.
CREATE OR REPLACE PROCEDURE SP_PARTES_MULTIPLES_PROVEEDORES IS
BEGIN
    FOR rec IN (
        SELECT P#, COUNT(DISTINCT S#) AS NUM_PROVEEDORES
        FROM SP
        GROUP BY P#
        HAVING COUNT(DISTINCT S#) > 1
        ORDER BY P#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Parte: ' || rec.P# || ', Proveedores: ' || rec.NUM_PROVEEDORES);
    END LOOP;
END;
/

-- 4.1.11 Obtenga el nombre de proveedor para todos los proveedores que abastecen la parte P2.
CREATE OR REPLACE PROCEDURE SP_PROVEEDORES_ABASTECEN_P2 IS
BEGIN
    FOR rec IN (
        SELECT DISTINCT S.S#, S.SNAME
        FROM S
        INNER JOIN SP ON S.S# = SP.S#
        WHERE SP.P# = 'P2'
        ORDER BY S.S#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor: ' || rec.S# || ', Nombre: ' || rec.SNAME);
    END LOOP;
END;
/

-- 4.1.12 Obtenga el nombre de proveedor de quienes abastecen por lo menos una parte.
CREATE OR REPLACE PROCEDURE SP_PROVEEDORES_ABASTECEN_ALGUNA_PARTE IS
BEGIN
    FOR rec IN (
        SELECT DISTINCT S.S#, S.SNAME
        FROM S
        INNER JOIN SP ON S.S# = SP.S#
        ORDER BY S.S#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor: ' || rec.S# || ', Nombre: ' || rec.SNAME);
    END LOOP;
END;
/

-- 4.1.13 Obtenga el número de proveedor para los proveedores con estado menor que el máximo valor de estado en la tabla S.
CREATE OR REPLACE PROCEDURE SP_PROVEEDORES_STATUS_MENOR_MAX IS
BEGIN
    FOR rec IN (
        SELECT S#, SNAME, STATUS
        FROM S
        WHERE STATUS < (SELECT MAX(STATUS) FROM S)
        ORDER BY S#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor: ' || rec.S# || ', Nombre: ' || rec.SNAME || 
                           ', Status: ' || rec.STATUS);
    END LOOP;
END;
/

-- 4.1.14 Obtenga el nombre de proveedor para los proveedores que abastecen la parte P2 (aplicar EXISTS en su solución).
CREATE OR REPLACE PROCEDURE SP_PROVEEDORES_P2_EXISTS IS
BEGIN
    FOR rec IN (
        SELECT S#, SNAME
        FROM S
        WHERE EXISTS (
            SELECT 1 FROM SP WHERE SP.S# = S.S# AND SP.P# = 'P2'
        )
        ORDER BY S#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor: ' || rec.S# || ', Nombre: ' || rec.SNAME);
    END LOOP;
END;
/

-- 4.1.15 Obtenga el nombre de proveedor para los proveedores que no abastecen la parte P2.
CREATE OR REPLACE PROCEDURE SP_PROVEEDORES_NO_ABASTECEN_P2 IS
BEGIN
    FOR rec IN (
        SELECT S#, SNAME
        FROM S
        WHERE S# NOT IN (
            SELECT S# FROM SP WHERE P# = 'P2'
        )
        ORDER BY S#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor: ' || rec.S# || ', Nombre: ' || rec.SNAME);
    END LOOP;
END;
/

-- 4.1.16 Obtenga el nombre de proveedor para los proveedores que abastecen todas las partes.
CREATE OR REPLACE PROCEDURE SP_PROVEEDORES_TODAS_PARTES IS
BEGIN
    FOR rec IN (
        SELECT S.S#, S.SNAME
        FROM S
        WHERE NOT EXISTS (
            SELECT P# FROM P
            WHERE NOT EXISTS (
                SELECT 1 FROM SP WHERE SP.S# = S.S# AND SP.P# = P.P#
            )
        )
        ORDER BY S.S#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor: ' || rec.S# || ', Nombre: ' || rec.SNAME);
    END LOOP;
END;
/

-- 4.1.17 Obtenga el número de parte para todas las partes que pesan más de 16 libras o son abastecidas por el proveedor S2, o cumplen con ambos criterios.
CREATE OR REPLACE PROCEDURE SP_PARTES_PESO_16_O_S2 IS
BEGIN
    FOR rec IN (
        SELECT DISTINCT P.P#, P.PNAME, P.WEIGHT
        FROM P
        LEFT JOIN SP ON P.P# = SP.P#
        WHERE P.WEIGHT > 16 OR SP.S# = 'S2'
        ORDER BY P.P#
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Parte: ' || rec.P# || ', Nombre: ' || rec.PNAME || 
                           ', Peso: ' || rec.WEIGHT);
    END LOOP;
END;
/

SET SERVEROUTPUT ON;

EXEC SP_PARTES_NO_PARIS_PESO_MAYOR_10;
EXEC SP_PARTES_PESO_GRAMOS;
EXEC SP_DETALLE_PROVEEDORES;
EXEC SP_PROVEEDORES_PARTES_COLOCALIZADOS;
EXEC SP_CIUDADES_PROVEEDOR_PARTE;
EXEC SP_PARES_PROVEEDORES_COLOCALIZADOS;

DECLARE
    v_total NUMBER;
BEGIN
    v_total := FN_TOTAL_PROVEEDORES;
    DBMS_OUTPUT.PUT_LINE('Total de proveedores: ' || v_total);
END;
/

DECLARE
    v_min NUMBER;
    v_max NUMBER;
    v_result VARCHAR2(20);
BEGIN
    v_result := FN_MIN_MAX_CANTIDAD_P2(v_min, v_max);
    DBMS_OUTPUT.PUT_LINE('Parte P2 - Cantidad Mínima: ' || v_min || ', Cantidad Máxima: ' || v_max);
END;
/

EXEC SP_TOTAL_DESPACHADO_POR_PARTE;
EXEC SP_PARTES_MULTIPLES_PROVEEDORES;
EXEC SP_PROVEEDORES_ABASTECEN_P2;
EXEC SP_PROVEEDORES_ABASTECEN_ALGUNA_PARTE;
EXEC SP_PROVEEDORES_STATUS_MENOR_MAX;
EXEC SP_PROVEEDORES_P2_EXISTS;
EXEC SP_PROVEEDORES_NO_ABASTECEN_P2;
EXEC SP_PROVEEDORES_TODAS_PARTES;
EXEC SP_PARTES_PESO_16_O_S2;


