-- Tablespace permanente para HR
CREATE TABLESPACE HR_DATA_TRANS
DATAFILE 'C:\APP\SEBAS\PRODUCT\21C\ORADATA\XE\hr_data_trans_01.dbf'   
    SIZE 1M 
    AUTOEXTEND ON NEXT 5M MAXSIZE 10M
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO
LOGGING;

-- Tablespace temporal para HR
CREATE TEMPORARY TABLESPACE HR_TRANS_TEMP
TEMPFILE 'C:\APP\SEBAS\PRODUCT\21C\ORADATA\XE\temp_trans_hr.dbf'  
    SIZE 10M 
    AUTOEXTEND ON NEXT 5M MAXSIZE 50M
EXTENT MANAGEMENT LOCAL 
UNIFORM SIZE 2M;
-- Tabla Regions

CREATE TABLE Regions (
    REGION_ID NUMBER PRIMARY KEY,
    REGION_NAME VARCHAR2(50) NOT NULL
) TABLESPACE HR_DATA_TRANS;

-- Tabla Countries
CREATE TABLE Countries (
    COUNTRY_ID CHAR(2) PRIMARY KEY,
    COUNTRY_NAME VARCHAR2(60) NOT NULL,
    REGION_ID NUMBER,
    CONSTRAINT fk_countries_region FOREIGN KEY (REGION_ID) 
        REFERENCES Regions(REGION_ID)
) TABLESPACE HR_DATA_TRANS;

-- Tabla Locations
CREATE TABLE Locations (
    LOCATION_ID NUMBER PRIMARY KEY,
    STREET_ADDRESS VARCHAR2(100),
    POSTAL_CODE VARCHAR2(20),
    CITY VARCHAR2(50) NOT NULL,
    STATE_PROVINCE VARCHAR2(50),
    COUNTRY_ID CHAR(2),
    CONSTRAINT fk_locations_country FOREIGN KEY (COUNTRY_ID) 
        REFERENCES Countries(COUNTRY_ID)
) TABLESPACE HR_DATA_TRANS;

-- Tabla Departments
CREATE TABLE Departments (
    DEPARTMENT_ID NUMBER PRIMARY KEY,
    DEPARTMENT_NAME VARCHAR2(50) NOT NULL,
    MANAGER_ID NUMBER,
    LOCATION_ID NUMBER,
    CONSTRAINT fk_departments_location FOREIGN KEY (LOCATION_ID) 
        REFERENCES Locations(LOCATION_ID)
) TABLESPACE HR_DATA_TRANS;

-- Tabla Jobs
CREATE TABLE Jobs (
    JOB_ID VARCHAR2(10) PRIMARY KEY,
    JOB_TITLE VARCHAR2(50) NOT NULL,
    MIN_SALARY NUMBER,
    MAX_SALARY NUMBER
) TABLESPACE HR_DATA_TRANS;

-- Tabla Employees
CREATE TABLE Employees (
    EMPLOYEE_ID NUMBER PRIMARY KEY,
    FIRST_NAME VARCHAR2(50),
    LAST_NAME VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(100) NOT NULL UNIQUE,
    PHONE_NUMBER VARCHAR2(20),
    HIRE_DATE DATE NOT NULL,
    JOB_ID VARCHAR2(10) NOT NULL,
    SALARY NUMBER,
    COMMISSION_PCT NUMBER(2,2),
    MANAGER_ID NUMBER,
    DEPARTMENT_ID NUMBER,
    CONSTRAINT fk_employees_job FOREIGN KEY (JOB_ID) 
        REFERENCES Jobs(JOB_ID),
    CONSTRAINT fk_employees_department FOREIGN KEY (DEPARTMENT_ID) 
        REFERENCES Departments(DEPARTMENT_ID),
    CONSTRAINT fk_employees_manager FOREIGN KEY (MANAGER_ID) 
        REFERENCES Employees(EMPLOYEE_ID)
) TABLESPACE HR_DATA_TRANS;

-- Tabla Job_History
CREATE TABLE Job_History (
    EMPLOYEE_ID NUMBER,
    START_DATE DATE,
    END_DATE DATE NOT NULL,
    JOB_ID VARCHAR2(10) NOT NULL,
    DEPARTMENT_ID NUMBER,
    CONSTRAINT pk_job_history PRIMARY KEY (EMPLOYEE_ID, START_DATE),
    CONSTRAINT fk_jobhist_employee FOREIGN KEY (EMPLOYEE_ID) 
        REFERENCES Employees(EMPLOYEE_ID),
    CONSTRAINT fk_jobhist_job FOREIGN KEY (JOB_ID) 
        REFERENCES Jobs(JOB_ID),
    CONSTRAINT fk_jobhist_department FOREIGN KEY (DEPARTMENT_ID) 
        REFERENCES Departments(DEPARTMENT_ID)
) TABLESPACE HR_DATA_TRANS;

-- Agregar la foreign key de MANAGER_ID en Departments (después de crear Employees)
ALTER TABLE Departments 
ADD CONSTRAINT fk_departments_manager 
FOREIGN KEY (MANAGER_ID) REFERENCES Employees(EMPLOYEE_ID);


-------------------------------------------------------------------------------------------

-- Insertar Regions
INSERT INTO regions VALUES (1, 'Europe');
INSERT INTO regions VALUES (2, 'Americas');
INSERT INTO regions VALUES (3, 'Asia');
INSERT INTO regions VALUES (4, 'Middle East and Africa');

-- Insertar Countries
INSERT INTO countries VALUES ('US', 'United States of America', 2);
INSERT INTO countries VALUES ('CA', 'Canada', 2);
INSERT INTO countries VALUES ('UK', 'United Kingdom', 1);
INSERT INTO countries VALUES ('DE', 'Germany', 1);
INSERT INTO countries VALUES ('JP', 'Japan', 3);

-- Insertar Locations
INSERT INTO locations VALUES (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO locations VALUES (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO locations VALUES (1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
INSERT INTO locations VALUES (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
INSERT INTO locations VALUES (2400, '8204 Arthur St', NULL, 'London', NULL, 'UK');

-- Insertar Jobs
INSERT INTO jobs VALUES ('AD_PRES', 'President', 20000, 40000);
INSERT INTO jobs VALUES ('AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO jobs VALUES ('AD_ASST', 'Administration Assistant', 3000, 6000);
INSERT INTO jobs VALUES ('FI_MGR', 'Finance Manager', 8200, 16000);
INSERT INTO jobs VALUES ('FI_ACCOUNT', 'Accountant', 4200, 9000);
INSERT INTO jobs VALUES ('AC_MGR', 'Accounting Manager', 8200, 16000);
INSERT INTO jobs VALUES ('AC_ACCOUNT', 'Public Accountant', 4200, 9000);
INSERT INTO jobs VALUES ('SA_MAN', 'Sales Manager', 10000, 20000);
INSERT INTO jobs VALUES ('SA_REP', 'Sales Representative', 6000, 12000);
INSERT INTO jobs VALUES ('PU_MAN', 'Purchasing Manager', 8000, 15000);
INSERT INTO jobs VALUES ('ST_MAN', 'Stock Manager', 5500, 8500);
INSERT INTO jobs VALUES ('IT_PROG', 'Programmer', 4000, 10000);

-- Insertar Departments (sin manager_id por ahora)
INSERT INTO departments (department_id, department_name, manager_id, location_id) 
VALUES (10, 'Administration', NULL, 1700);
INSERT INTO departments (department_id, department_name, manager_id, location_id) 
VALUES (20, 'Marketing', NULL, 1800);
INSERT INTO departments (department_id, department_name, manager_id, location_id) 
VALUES (50, 'Shipping', NULL, 1500);
INSERT INTO departments (department_id, department_name, manager_id, location_id) 
VALUES (60, 'IT', NULL, 1400);
INSERT INTO departments (department_id, department_name, manager_id, location_id) 
VALUES (80, 'Sales', NULL, 2400);
INSERT INTO departments (department_id, department_name, manager_id, location_id) 
VALUES (90, 'Executive', NULL, 1700);
INSERT INTO departments (department_id, department_name, manager_id, location_id) 
VALUES (100, 'Finance', NULL, 1700);
INSERT INTO departments (department_id, department_name, manager_id, location_id) 
VALUES (110, 'Accounting', NULL, 1700);

-- Insertar Employees
INSERT INTO employees VALUES (100, 'Steven', 'King', 'SKING@company.com', '515.123.4567', 
    TO_DATE('17-06-2003', 'DD-MM-YYYY'), 'AD_PRES', 24000, NULL, NULL, 90);

INSERT INTO employees VALUES (101, 'Neena', 'Kochhar', 'NKOCHHAR@company.com', '515.123.4568', 
    TO_DATE('21-09-2005', 'DD-MM-YYYY'), 'AD_VP', 17000, NULL, 100, 90);

INSERT INTO employees VALUES (102, 'Lex', 'De Haan', 'LDEHAAN@company.com', '515.123.4569', 
    TO_DATE('13-01-2001', 'DD-MM-YYYY'), 'AD_VP', 17000, NULL, 100, 90);

INSERT INTO employees VALUES (103, 'Alexander', 'Hunold', 'AHUNOLD@company.com', '590.423.4567', 
    TO_DATE('03-01-2006', 'DD-MM-YYYY'), 'IT_PROG', 9000, NULL, 102, 60);

INSERT INTO employees VALUES (104, 'Bruce', 'Ernst', 'BERNST@company.com', '590.423.4568', 
    TO_DATE('21-05-2007', 'DD-MM-YYYY'), 'IT_PROG', 6000, NULL, 103, 60);

INSERT INTO employees VALUES (105, 'David', 'Austin', 'DAUSTIN@company.com', '590.423.4569', 
    TO_DATE('25-06-2005', 'DD-MM-YYYY'), 'IT_PROG', 4800, NULL, 103, 60);

INSERT INTO employees VALUES (106, 'Valli', 'Pataballa', 'VPATABAL@company.com', '590.423.4560', 
    TO_DATE('05-02-2006', 'DD-MM-YYYY'), 'IT_PROG', 4800, NULL, 103, 60);

INSERT INTO employees VALUES (107, 'Diana', 'Lorentz', 'DLORENTZ@company.com', '590.423.5567', 
    TO_DATE('07-02-2007', 'DD-MM-YYYY'), 'IT_PROG', 4200, NULL, 103, 60);

INSERT INTO employees VALUES (108, 'Nancy', 'Greenberg', 'NGREENBE@company.com', '515.124.4569', 
    TO_DATE('17-08-2002', 'DD-MM-YYYY'), 'FI_MGR', 12000, NULL, 101, 100);

INSERT INTO employees VALUES (109, 'Daniel', 'Faviet', 'DFAVIET@company.com', '515.124.4169', 
    TO_DATE('16-08-2002', 'DD-MM-YYYY'), 'FI_ACCOUNT', 9000, NULL, 108, 100);

INSERT INTO employees VALUES (110, 'John', 'Chen', 'JCHEN@company.com', '515.124.4269', 
    TO_DATE('28-09-2005', 'DD-MM-YYYY'), 'FI_ACCOUNT', 8200, NULL, 108, 100);

-- Employees del departamento 50 (Shipping)
INSERT INTO employees VALUES (120, 'Matthew', 'Weiss', 'MWEISS@company.com', '650.123.1234', 
    TO_DATE('18-07-2004', 'DD-MM-YYYY'), 'ST_MAN', 8000, NULL, 100, 50);

INSERT INTO employees VALUES (121, 'Adam', 'Fripp', 'AFRIPP@company.com', '650.123.2234', 
    TO_DATE('10-04-2005', 'DD-MM-YYYY'), 'ST_MAN', 8200, NULL, 100, 50);

INSERT INTO employees VALUES (122, 'Payam', 'Kaufling', 'PKAUFLIN@company.com', '650.123.3234', 
    TO_DATE('01-05-2003', 'DD-MM-YYYY'), 'ST_MAN', 7900, NULL, 100, 50);

-- Employees del departamento 80 (Sales)
INSERT INTO employees VALUES (145, 'John', 'Russell', 'JRUSSEL@company.com', '011.44.1344.429268', 
    TO_DATE('01-10-2004', 'DD-MM-YYYY'), 'SA_MAN', 14000, 0.40, 100, 80);

INSERT INTO employees VALUES (146, 'Karen', 'Partners', 'KPARTNER@company.com', '011.44.1344.467268', 
    TO_DATE('05-01-2005', 'DD-MM-YYYY'), 'SA_MAN', 13500, 0.30, 100, 80);

INSERT INTO employees VALUES (147, 'Alberto', 'Errazuriz', 'AERRAZUR@company.com', '011.44.1344.429278', 
    TO_DATE('10-03-2005', 'DD-MM-YYYY'), 'SA_MAN', 12000, 0.30, 100, 80);

INSERT INTO employees VALUES (148, 'Gerald', 'Cambrault', 'GCAMBRAU@company.com', '011.44.1344.619268', 
    TO_DATE('15-10-2007', 'DD-MM-YYYY'), 'SA_MAN', 11000, 0.30, 100, 80);

-- Actualizar manager_id en departments
UPDATE departments SET manager_id = 100 WHERE department_id = 90;
UPDATE departments SET manager_id = 103 WHERE department_id = 60;
UPDATE departments SET manager_id = 108 WHERE department_id = 100;
UPDATE departments SET manager_id = 145 WHERE department_id = 80;
UPDATE departments SET manager_id = 120 WHERE department_id = 50;

COMMIT;

-- ============================================================================
-- EJERCICIO 1 - Control básico de transacciones
-- ============================================================================

SET SERVEROUTPUT ON;

DECLARE
    v_count_dept90 NUMBER;
    v_count_dept60 NUMBER;
BEGIN
    -- Aumentar en un 10% el salario de los empleados del departamento 90
    UPDATE employees
    SET salary = salary * 1.10
    WHERE department_id = 90;
    
    v_count_dept90 := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Empleados actualizados en Dept 90: ' || v_count_dept90);
    
    -- Guardar un SAVEPOINT llamado punto1
    SAVEPOINT punto1;
    DBMS_OUTPUT.PUT_LINE('SAVEPOINT punto1 creado');
    
    -- Aumentar en un 5% el salario de los empleados del departamento 60
    UPDATE employees
    SET salary = salary * 1.05
    WHERE department_id = 60;
    
    v_count_dept60 := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Empleados actualizados en Dept 60: ' || v_count_dept60);
    
    -- Realizar un ROLLBACK parcial
    ROLLBACK TO punto1;
    DBMS_OUTPUT.PUT_LINE('ROLLBACK a punto1 ejecutado');
    
    -- Confirmar la transacción
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('COMMIT ejecutado - Transacción completada');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- ============================================================================


/*
PREGUNTAS EJERCICIO 1:
a. El departamento 90 mantuvo los cambios (10% de aumento).
b. El ROLLBACK parcial revirtió solo las modificaciones posteriores al SAVEPOINT.
c. Un ROLLBACK sin SAVEPOINT revierte toda la transacción.
*/


-- ============================================================================
-- EJERCICIO 2 - Bloqueos entre sesiones (CORREGIDO)
-- ============================================================================

/*
INSTRUCCIONES:
1. Abre DOS sesiones diferentes (por ejemplo, dos conexiones en SQL Developer)
2. Ejecuta los comandos en el orden indicado.
*/

-- SESIÓN 1:
SET SERVEROUTPUT ON;
BEGIN
    UPDATE employees
    SET salary = salary + 500
    WHERE employee_id = 103;

    DBMS_OUTPUT.PUT_LINE('Empleado 103 actualizado en Sesión 1');
    DBMS_OUTPUT.PUT_LINE('Transacción abierta - NO ejecutar COMMIT todavía.');
    DBMS_OUTPUT.PUT_LINE('Ve a la Sesión 2 e intenta actualizar el mismo empleado.');
END;
/

-- SESIÓN 2 (en otra ventana):
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Intentando actualizar empleado 103 desde Sesión 2...');
    
    UPDATE employees
    SET salary = salary + 300
    WHERE employee_id = 103;

    DBMS_OUTPUT.PUT_LINE('Actualización completada en Sesión 2');
    COMMIT;
END;
/

-- SESIÓN 1 (para liberar bloqueo):
BEGIN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ROLLBACK ejecutado en Sesión 1 - Bloqueo liberado.');
END;
/

-- CONSULTAS OPCIONALES (solo si tienes privilegios DBA)
-- Ver sesiones bloqueadas:
SELECT 
    s1.sid AS sesion_bloqueada,
    s1.username AS usuario_bloqueado,
    s1.blocking_session AS sesion_bloqueadora,
    s2.username AS usuario_bloqueador,
    o.object_name AS objeto_bloqueado
FROM v$session s1
LEFT JOIN v$session s2 ON s1.blocking_session = s2.sid
LEFT JOIN v$locked_object lo ON s1.sid = lo.session_id
LEFT JOIN dba_objects o ON lo.object_id = o.object_id
WHERE s1.blocking_session IS NOT NULL;

-- ============================================================================

/*
PREGUNTAS EJERCICIO 2:
a. La segunda sesión quedó bloqueada por el bloqueo exclusivo del UPDATE de la primera.
b. Los comandos COMMIT o ROLLBACK liberan los bloqueos.
c. Las vistas útiles son: V$LOCKED_OBJECT, V$LOCK, V$SESSION, DBA_BLOCKERS y DBA_WAITERS.
*/


-- ============================================================================
-- EJERCICIO 3 - Transacción controlada con bloque PL/SQL
-- ============================================================================

SET SERVEROUTPUT ON;

DECLARE
    v_employee_id employees.employee_id%TYPE := 104;
    v_old_dept_id employees.department_id%TYPE;
    v_new_dept_id employees.department_id%TYPE := 110;
    v_job_id employees.job_id%TYPE;
    v_dept_exists NUMBER;
BEGIN
    -- Verificar que el departamento destino existe
    SELECT COUNT(*) INTO v_dept_exists
    FROM departments
    WHERE department_id = v_new_dept_id;

    IF v_dept_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El departamento ' || v_new_dept_id || ' no existe.');
    END IF;

    -- Obtener info actual del empleado
    SELECT department_id, job_id INTO v_old_dept_id, v_job_id
    FROM employees
    WHERE employee_id = v_employee_id;

    DBMS_OUTPUT.PUT_LINE('Empleado ' || v_employee_id || ' - Dept actual: ' || v_old_dept_id || ' - Job: ' || v_job_id);

    -- Actualizar el departamento
    UPDATE employees
    SET department_id = v_new_dept_id
    WHERE employee_id = v_employee_id;

    DBMS_OUTPUT.PUT_LINE('Empleado transferido al departamento ' || v_new_dept_id);

    -- Insertar registro en JOB_HISTORY
    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (
        v_employee_id,
        (SELECT hire_date FROM employees WHERE employee_id = v_employee_id),
        SYSDATE,
        v_job_id,
        v_old_dept_id
    );

    DBMS_OUTPUT.PUT_LINE('Registro insertado en JOB_HISTORY');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transacción confirmada exitosamente.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Transacción revertida.');
END;
/

-- ============================================================================

/*
PREGUNTAS EJERCICIO 3:
a. Se debe garantizar atomicidad para que ambas operaciones (UPDATE e INSERT) se ejecuten juntas.
b. Si ocurre un error antes del COMMIT, se revierte toda la transacción.
c. La integridad se asegura con claves foráneas, transacciones atómicas y manejo de errores.
*/


-- ============================================================================
-- EJERCICIO 4 - SAVEPOINT y reversión parcial
-- ============================================================================

SET SERVEROUTPUT ON;

DECLARE
    v_count NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ESTADO INICIAL ===');
    FOR emp IN (
        SELECT department_id, COUNT(*) cant, AVG(salary) promedio
        FROM employees
        WHERE department_id IN (100, 80, 50)
        GROUP BY department_id
        ORDER BY department_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Dept ' || emp.department_id ||
                             ': ' || emp.cant || ' empleados, Salario promedio: ' || ROUND(emp.promedio, 2));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== INICIANDO TRANSACCIÓN ===');

    -- Aumento dept 100
    UPDATE employees
    SET salary = salary * 1.08
    WHERE department_id = 100;
    v_count := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Dept 100: ' || v_count || ' empleados aumentados 8%');
    SAVEPOINT A;

    -- Aumento dept 80
    UPDATE employees
    SET salary = salary * 1.05
    WHERE department_id = 80;
    v_count := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Dept 80: ' || v_count || ' empleados aumentados 5%');
    SAVEPOINT B;

    -- Eliminar dept 50
    DELETE FROM employees
    WHERE department_id = 50;
    v_count := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Dept 50: ' || v_count || ' empleados eliminados');

    -- Reversión parcial
    ROLLBACK TO B;
    DBMS_OUTPUT.PUT_LINE('ROLLBACK TO SAVEPOINT B ejecutado (Dept 50 restaurado)');

    -- Confirmar transacción
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('COMMIT ejecutado');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== ESTADO FINAL ===');

    FOR emp IN (
        SELECT department_id, COUNT(*) cant, AVG(salary) promedio
        FROM employees
        WHERE department_id IN (100, 80, 50)
        GROUP BY department_id
        ORDER BY department_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Dept ' || emp.department_id ||
                             ': ' || emp.cant || ' empleados, Salario promedio: ' || ROUND(emp.promedio, 2));
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Consulta para verificar resultados
SELECT department_id, COUNT(*) total_empleados,
       ROUND(AVG(salary), 2) salario_promedio,
       MIN(salary) salario_minimo,
       MAX(salary) salario_maximo
FROM employees
WHERE department_id IN (100, 80, 50)
GROUP BY department_id
ORDER BY department_id;
