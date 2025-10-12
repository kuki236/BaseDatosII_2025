CREATE TABLESPACE hr_tablespace
DATAFILE 'C:\APP\SEBAS\PRODUCT\21C\ORADATA\XE\hr_data_01.dbf'
SIZE 50M
AUTOEXTEND ON
NEXT 5M
MAXSIZE 100M
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO
LOGGING;

CREATE TEMPORARY TABLESPACE temp_hr
TEMPFILE 'C:\APP\SEBAS\PRODUCT\21C\ORADATA\XE\temp_hr_01.dbf'
SIZE 20M
EXTENT MANAGEMENT LOCAL
UNIFORM SIZE 2M;

CREATE TABLE REGIONS (
    REGION_ID NUMBER PRIMARY KEY,
    REGION_NAME VARCHAR2(25) NOT NULL
) TABLESPACE hr_tablespace;

CREATE TABLE COUNTRIES (
    COUNTRY_ID CHAR(2) PRIMARY KEY,
    COUNTRY_NAME VARCHAR2(40) NOT NULL,
    REGION_ID NUMBER,
    CONSTRAINT fk_countries_regions FOREIGN KEY (REGION_ID) REFERENCES REGIONS(REGION_ID)
) TABLESPACE hr_tablespace;

CREATE TABLE LOCATIONS (
    LOCATION_ID NUMBER(4) PRIMARY KEY,
    STREET_ADDRESS VARCHAR2(40),
    POSTAL_CODE VARCHAR2(12),
    CITY VARCHAR2(30) NOT NULL,
    STATE_PROVINCE VARCHAR2(25),
    COUNTRY_ID CHAR(2),
    CONSTRAINT fk_locations_countries FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES(COUNTRY_ID)
) TABLESPACE hr_tablespace;

CREATE TABLE DEPARTMENTS (
    DEPARTMENT_ID NUMBER(4) PRIMARY KEY,
    DEPARTMENT_NAME VARCHAR2(30) NOT NULL,
    MANAGER_ID NUMBER(6),
    LOCATION_ID NUMBER(4),
    CONSTRAINT fk_departments_locations FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS(LOCATION_ID)
) TABLESPACE hr_tablespace;

CREATE TABLE JOBS (
    JOB_ID VARCHAR2(10) PRIMARY KEY,
    JOB_TITLE VARCHAR2(35) NOT NULL,
    MIN_SALARY NUMBER(6),
    MAX_SALARY NUMBER(6)
) TABLESPACE hr_tablespace;

CREATE TABLE EMPLOYEES (
    EMPLOYEE_ID NUMBER(6) PRIMARY KEY,
    FIRST_NAME VARCHAR2(20),
    LAST_NAME VARCHAR2(25) NOT NULL,
    EMAIL VARCHAR2(25) NOT NULL UNIQUE,
    PHONE_NUMBER VARCHAR2(20),
    HIRE_DATE DATE NOT NULL,
    JOB_ID VARCHAR2(10) NOT NULL,
    SALARY NUMBER(8,2) NOT NULL,
    COMMISSION_PCT NUMBER(2,2),
    MANAGER_ID NUMBER(6),
    DEPARTMENT_ID NUMBER(4),
    CONSTRAINT fk_employees_jobs FOREIGN KEY (JOB_ID) REFERENCES JOBS(JOB_ID),
    CONSTRAINT fk_employees_departments FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID),
    CONSTRAINT fk_employees_manager FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
) TABLESPACE hr_tablespace;

ALTER TABLE DEPARTMENTS ADD CONSTRAINT fk_departments_manager FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);

CREATE TABLE JOB_HISTORY (
    EMPLOYEE_ID NUMBER(6),
    START_DATE DATE,
    END_DATE DATE NOT NULL,
    JOB_ID VARCHAR2(10) NOT NULL,
    DEPARTMENT_ID NUMBER(4),
    CONSTRAINT pk_job_history PRIMARY KEY (EMPLOYEE_ID, START_DATE),
    CONSTRAINT fk_job_history_employee FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    CONSTRAINT fk_job_history_job FOREIGN KEY (JOB_ID) REFERENCES JOBS(JOB_ID),
    CONSTRAINT fk_job_history_department FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID)
) TABLESPACE hr_tablespace;

INSERT INTO REGIONS VALUES (1, 'Europe');
INSERT INTO REGIONS VALUES (2, 'Americas');
INSERT INTO REGIONS VALUES (3, 'Asia');
INSERT INTO REGIONS VALUES (4, 'Middle East and Africa');

INSERT INTO COUNTRIES VALUES ('US', 'United States of America', 2);
INSERT INTO COUNTRIES VALUES ('CA', 'Canada', 2);
INSERT INTO COUNTRIES VALUES ('UK', 'United Kingdom', 1);
INSERT INTO COUNTRIES VALUES ('DE', 'Germany', 1);
INSERT INTO COUNTRIES VALUES ('JP', 'Japan', 3);

INSERT INTO LOCATIONS VALUES (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO LOCATIONS VALUES (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO LOCATIONS VALUES (1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
INSERT INTO LOCATIONS VALUES (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
INSERT INTO LOCATIONS VALUES (2400, '8204 Arthur St', NULL, 'London', NULL, 'UK');

INSERT INTO JOBS VALUES ('AD_PRES', 'President', 20000, 40000);
INSERT INTO JOBS VALUES ('AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO JOBS VALUES ('IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO JOBS VALUES ('SA_REP', 'Sales Representative', 6000, 12000);
INSERT INTO JOBS VALUES ('ST_CLERK', 'Stock Clerk', 2000, 5000);

INSERT INTO EMPLOYEES VALUES (100, 'Steven', 'King', 'SKING', '515.123.4567', TO_DATE('2003-06-17', 'YYYY-MM-DD'), 'AD_PRES', 24000, NULL, NULL, NULL);
INSERT INTO EMPLOYEES VALUES (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', TO_DATE('2005-09-21', 'YYYY-MM-DD'), 'AD_VP', 17000, NULL, 100, NULL);
INSERT INTO EMPLOYEES VALUES (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', TO_DATE('2001-01-13', 'YYYY-MM-DD'), 'AD_VP', 17000, NULL, 100, NULL);
INSERT INTO EMPLOYEES VALUES (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', TO_DATE('2006-01-03', 'YYYY-MM-DD'), 'IT_PROG', 9000, NULL, 102, NULL);
INSERT INTO EMPLOYEES VALUES (104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', TO_DATE('2007-05-21', 'YYYY-MM-DD'), 'IT_PROG', 6000, NULL, 103, NULL);

INSERT INTO DEPARTMENTS VALUES (10, 'Administration', 100, 1700);
INSERT INTO DEPARTMENTS VALUES (20, 'Marketing', 101, 1800);
INSERT INTO DEPARTMENTS VALUES (50, 'Shipping', 102, 1500);
INSERT INTO DEPARTMENTS VALUES (60, 'IT', 103, 1400);
INSERT INTO DEPARTMENTS VALUES (80, 'Sales', 100, 2400);

UPDATE EMPLOYEES SET DEPARTMENT_ID = 10 WHERE EMPLOYEE_ID = 100;
UPDATE EMPLOYEES SET DEPARTMENT_ID = 20 WHERE EMPLOYEE_ID = 101;
UPDATE EMPLOYEES SET DEPARTMENT_ID = 60 WHERE EMPLOYEE_ID IN (102, 103, 104);

INSERT INTO JOB_HISTORY VALUES (102, TO_DATE('2001-01-13', 'YYYY-MM-DD'), TO_DATE('2006-07-24', 'YYYY-MM-DD'), 'IT_PROG', 60);
INSERT INTO JOB_HISTORY VALUES (101, TO_DATE('2005-09-21', 'YYYY-MM-DD'), TO_DATE('2007-03-27', 'YYYY-MM-DD'), 'SA_REP', 80);
INSERT INTO JOB_HISTORY VALUES (101, TO_DATE('2007-03-28', 'YYYY-MM-DD'), TO_DATE('2009-12-31', 'YYYY-MM-DD'), 'IT_PROG', 60);
INSERT INTO JOB_HISTORY VALUES (100, TO_DATE('2003-06-17', 'YYYY-MM-DD'), TO_DATE('2006-12-31', 'YYYY-MM-DD'), 'AD_VP', 10);

COMMIT;

CREATE OR REPLACE PACKAGE PKG_EMPLOYEE AS
    PROCEDURE crear_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_hire_date DATE,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    );
    
    PROCEDURE leer_employee(p_employee_id NUMBER);
    
    PROCEDURE actualizar_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    );
    
    PROCEDURE eliminar_employee(p_employee_id NUMBER);
    
    PROCEDURE listar_todos_employees;
    
    -- 3.1.1 Escriba un procedimiento que muestre el código de empleado, apellido y nombre, código de puesto actual y nombre de puesto actual, de los 4 empleados que más han rotado de puesto desde que ingresaron a la empresa.
    PROCEDURE empleados_mas_rotacion;
    
    -- 3.1.2 Escriba una función que muestre un resumen estadístico del número promedio de contrataciones por cada mes con respecto a todos los años que hay información en la base de datos.
    FUNCTION promedio_contrataciones_mes RETURN NUMBER;
    
    -- 3.1.3 Escriba un procedimiento que muestre la información de gastos en salario y estadística de empleados a nivel regional.
    PROCEDURE gastos_salarios_region;
    
    -- 3.1.4 Escriba una función para que calcule el tiempo de servicio de cada uno de sus empleados, para determinar el tiempo de vacaciones que le corresponde a cada empleado.
    FUNCTION calcular_vacaciones_empleados RETURN NUMBER;
    
END PKG_EMPLOYEE;
/

CREATE OR REPLACE PACKAGE BODY PKG_EMPLOYEE AS

    PROCEDURE crear_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_hire_date DATE,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    ) IS
    BEGIN
        INSERT INTO EMPLOYEES VALUES (
            p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
            p_hire_date, p_job_id, p_salary, p_commission_pct, p_manager_id, p_department_id
        );
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Empleado creado exitosamente: ' || p_employee_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: El empleado con ID ' || p_employee_id || ' ya existe.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al crear empleado: ' || SQLERRM);
    END crear_employee;
    
    PROCEDURE leer_employee(p_employee_id NUMBER) IS
        v_emp EMPLOYEES%ROWTYPE;
    BEGIN
        SELECT * INTO v_emp FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id;
        
        DBMS_OUTPUT.PUT_LINE('=== DATOS DEL EMPLEADO ===');
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_emp.FIRST_NAME || ' ' || v_emp.LAST_NAME);
        DBMS_OUTPUT.PUT_LINE('Email: ' || v_emp.EMAIL);
        DBMS_OUTPUT.PUT_LINE('Teléfono: ' || v_emp.PHONE_NUMBER);
        DBMS_OUTPUT.PUT_LINE('Fecha Contratación: ' || v_emp.HIRE_DATE);
        DBMS_OUTPUT.PUT_LINE('Puesto: ' || v_emp.JOB_ID);
        DBMS_OUTPUT.PUT_LINE('Salario: ' || v_emp.SALARY);
        DBMS_OUTPUT.PUT_LINE('Comisión: ' || NVL(TO_CHAR(v_emp.COMMISSION_PCT), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Manager: ' || NVL(TO_CHAR(v_emp.MANAGER_ID), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Departamento: ' || NVL(TO_CHAR(v_emp.DEPARTMENT_ID), 'N/A'));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: No existe empleado con ID ' || p_employee_id);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al leer empleado: ' || SQLERRM);
    END leer_employee;
    
    PROCEDURE actualizar_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    ) IS
    BEGIN
        UPDATE EMPLOYEES SET
            FIRST_NAME = p_first_name,
            LAST_NAME = p_last_name,
            EMAIL = p_email,
            PHONE_NUMBER = p_phone_number,
            JOB_ID = p_job_id,
            SALARY = p_salary,
            COMMISSION_PCT = p_commission_pct,
            MANAGER_ID = p_manager_id,
            DEPARTMENT_ID = p_department_id
        WHERE EMPLOYEE_ID = p_employee_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: No existe empleado con ID ' || p_employee_id);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Empleado actualizado exitosamente: ' || p_employee_id);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al actualizar empleado: ' || SQLERRM);
    END actualizar_employee;
    
    PROCEDURE eliminar_employee(p_employee_id NUMBER) IS
    BEGIN
        DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: No existe empleado con ID ' || p_employee_id);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Empleado eliminado exitosamente: ' || p_employee_id);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al eliminar empleado: ' || SQLERRM);
    END eliminar_employee;
    
    PROCEDURE listar_todos_employees IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== LISTA DE EMPLEADOS ===');
        FOR rec IN (SELECT * FROM EMPLOYEES ORDER BY EMPLOYEE_ID) LOOP
            DBMS_OUTPUT.PUT_LINE('ID: ' || rec.EMPLOYEE_ID || ', Nombre: ' || rec.FIRST_NAME || ' ' || rec.LAST_NAME || 
                               ', Puesto: ' || rec.JOB_ID || ', Salario: ' || rec.SALARY);
        END LOOP;
    END listar_todos_employees;
    
    -- 3.1.1 Escriba un procedimiento que muestre el código de empleado, apellido y nombre, código de puesto actual y nombre de puesto actual, de los 4 empleados que más han rotado de puesto desde que ingresaron a la empresa.
    PROCEDURE empleados_mas_rotacion IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== 4 EMPLEADOS CON MÁS ROTACIÓN DE PUESTOS ===');
        FOR rec IN (
            SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.FIRST_NAME, E.JOB_ID, J.JOB_TITLE, 
                   COUNT(JH.JOB_ID) AS NUM_CAMBIOS
            FROM EMPLOYEES E
            INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
            LEFT JOIN JOB_HISTORY JH ON E.EMPLOYEE_ID = JH.EMPLOYEE_ID
            GROUP BY E.EMPLOYEE_ID, E.LAST_NAME, E.FIRST_NAME, E.JOB_ID, J.JOB_TITLE
            ORDER BY NUM_CAMBIOS DESC
            FETCH FIRST 4 ROWS ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Empleado ID: ' || rec.EMPLOYEE_ID || 
                               ', Nombre: ' || rec.FIRST_NAME || ' ' || rec.LAST_NAME ||
                               ', Puesto Actual: ' || rec.JOB_ID || ' - ' || rec.JOB_TITLE ||
                               ', Cambios de Puesto: ' || rec.NUM_CAMBIOS);
        END LOOP;
    END empleados_mas_rotacion;
    
    -- 3.1.2 Escriba una función que muestre un resumen estadístico del número promedio de contrataciones por cada mes con respecto a todos los años que hay información en la base de datos.
    FUNCTION promedio_contrataciones_mes RETURN NUMBER IS
        v_total_meses NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PROMEDIO DE CONTRATACIONES POR MES ===');
        FOR rec IN (
            SELECT TO_CHAR(HIRE_DATE, 'Month') AS MES,
                   EXTRACT(MONTH FROM HIRE_DATE) AS MES_NUM,
                   COUNT(*) / COUNT(DISTINCT EXTRACT(YEAR FROM HIRE_DATE)) AS PROMEDIO_CONTRATACIONES
            FROM EMPLOYEES
            GROUP BY TO_CHAR(HIRE_DATE, 'Month'), EXTRACT(MONTH FROM HIRE_DATE)
            ORDER BY MES_NUM
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Mes: ' || TRIM(rec.MES) || 
                               ', Promedio Contrataciones: ' || ROUND(rec.PROMEDIO_CONTRATACIONES, 2));
            v_total_meses := v_total_meses + 1;
        END LOOP;
        
        RETURN v_total_meses;
    END promedio_contrataciones_mes;
    
    -- 3.1.3 Escriba un procedimiento que muestre la información de gastos en salario y estadística de empleados a nivel regional.
    PROCEDURE gastos_salarios_region IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== GASTOS EN SALARIOS Y ESTADÍSTICAS POR REGIÓN ===');
        FOR rec IN (
            SELECT R.REGION_NAME,
                   SUM(E.SALARY) AS SUMA_SALARIOS,
                   COUNT(E.EMPLOYEE_ID) AS CANTIDAD_EMPLEADOS,
                   MIN(E.HIRE_DATE) AS EMPLEADO_MAS_ANTIGUO
            FROM REGIONS R
            INNER JOIN COUNTRIES C ON R.REGION_ID = C.REGION_ID
            INNER JOIN LOCATIONS L ON C.COUNTRY_ID = L.COUNTRY_ID
            INNER JOIN DEPARTMENTS D ON L.LOCATION_ID = D.LOCATION_ID
            INNER JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
            GROUP BY R.REGION_NAME
            ORDER BY R.REGION_NAME
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Región: ' || rec.REGION_NAME ||
                               ', Suma Salarios: ' || rec.SUMA_SALARIOS ||
                               ', Cantidad Empleados: ' || rec.CANTIDAD_EMPLEADOS ||
                               ', Empleado Más Antiguo: ' || TO_CHAR(rec.EMPLEADO_MAS_ANTIGUO, 'DD-MON-YYYY'));
        END LOOP;
    END gastos_salarios_region;
    
    -- 3.1.4 Escriba una función para que calcule el tiempo de servicio de cada uno de sus empleados, para determinar el tiempo de vacaciones que le corresponde a cada empleado.
    FUNCTION calcular_vacaciones_empleados RETURN NUMBER IS
        v_monto_total NUMBER := 0;
        v_años_servicio NUMBER;
        v_meses_vacaciones NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== TIEMPO DE SERVICIO Y VACACIONES DE EMPLEADOS ===');
        FOR rec IN (
            SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, SALARY
            FROM EMPLOYEES
            ORDER BY EMPLOYEE_ID
        ) LOOP
            v_años_servicio := FLOOR(MONTHS_BETWEEN(SYSDATE, rec.HIRE_DATE) / 12);
            v_meses_vacaciones := v_años_servicio;
            v_monto_total := v_monto_total + (rec.SALARY * v_meses_vacaciones);
            
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || rec.FIRST_NAME || ' ' || rec.LAST_NAME ||
                               ', Años de Servicio: ' || v_años_servicio ||
                               ', Meses de Vacaciones: ' || v_meses_vacaciones ||
                               ', Monto Vacaciones: ' || (rec.SALARY * v_meses_vacaciones));
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('=== MONTO TOTAL PARA VACACIONES: ' || v_monto_total || ' ===');
        RETURN v_monto_total;
    END calcular_vacaciones_empleados;
    
END PKG_EMPLOYEE;
/

SET SERVEROUTPUT ON;

EXEC PKG_EMPLOYEE.listar_todos_employees;
EXEC PKG_EMPLOYEE.leer_employee(100);
EXEC PKG_EMPLOYEE.empleados_mas_rotacion;

DECLARE
    v_total_meses NUMBER;
BEGIN
    v_total_meses := PKG_EMPLOYEE.promedio_contrataciones_mes;
    DBMS_OUTPUT.PUT_LINE('Total de meses considerados: ' || v_total_meses);
END;
/

EXEC PKG_EMPLOYEE.gastos_salarios_region;

DECLARE
    v_monto_total NUMBER;
BEGIN
    v_monto_total := PKG_EMPLOYEE.calcular_vacaciones_empleados;
END;
/

-- 1111111
CREATE TABLE HORARIO (
    DIA_SEMANA VARCHAR2(10),
    TURNO VARCHAR2(10),
    HORA_INICIO TIMESTAMP,
    HORA_TERMINO TIMESTAMP,
    CONSTRAINT pk_horario PRIMARY KEY (DIA_SEMANA, TURNO),
    CONSTRAINT chk_dia_semana CHECK (DIA_SEMANA IN ('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')),
    CONSTRAINT chk_turno CHECK (TURNO IN ('Mañana', 'Tarde', 'Noche'))
) TABLESPACE hr_tablespace;

CREATE TABLE EMPLEADO_HORARIO (
    DIA_SEMANA VARCHAR2(10),
    TURNO VARCHAR2(10),
    EMPLOYEE_ID NUMBER(6),
    CONSTRAINT pk_empleado_horario PRIMARY KEY (DIA_SEMANA, TURNO, EMPLOYEE_ID),
    CONSTRAINT fk_emp_horario_horario FOREIGN KEY (DIA_SEMANA, TURNO) REFERENCES HORARIO(DIA_SEMANA, TURNO),
    CONSTRAINT fk_emp_horario_employee FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
) TABLESPACE hr_tablespace;

CREATE TABLE ASISTENCIA_EMPLEADO (
    EMPLOYEE_ID NUMBER(6),
    DIA_SEMANA VARCHAR2(10),
    FECHA_REAL DATE,
    HORA_INICIO_REAL TIMESTAMP,
    HORA_TERMINO_REAL TIMESTAMP,
    CONSTRAINT pk_asistencia PRIMARY KEY (EMPLOYEE_ID, FECHA_REAL),
    CONSTRAINT fk_asistencia_employee FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
) TABLESPACE hr_tablespace;

INSERT INTO HORARIO VALUES ('Lunes', 'Mañana', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('16:00:00', 'HH24:MI:SS'));
INSERT INTO HORARIO VALUES ('Lunes', 'Tarde', TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('22:00:00', 'HH24:MI:SS'));
INSERT INTO HORARIO VALUES ('Martes', 'Mañana', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('16:00:00', 'HH24:MI:SS'));
INSERT INTO HORARIO VALUES ('Martes', 'Tarde', TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('22:00:00', 'HH24:MI:SS'));
INSERT INTO HORARIO VALUES ('Miercoles', 'Mañana', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('16:00:00', 'HH24:MI:SS'));
INSERT INTO HORARIO VALUES ('Miercoles', 'Tarde', TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('22:00:00', 'HH24:MI:SS'));
INSERT INTO HORARIO VALUES ('Jueves', 'Mañana', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('16:00:00', 'HH24:MI:SS'));
INSERT INTO HORARIO VALUES ('Jueves', 'Tarde', TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('22:00:00', 'HH24:MI:SS'));
INSERT INTO HORARIO VALUES ('Viernes', 'Mañana', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('16:00:00', 'HH24:MI:SS'));
INSERT INTO HORARIO VALUES ('Viernes', 'Tarde', TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('22:00:00', 'HH24:MI:SS'));

INSERT INTO EMPLEADO_HORARIO VALUES ('Lunes', 'Mañana', 100);
INSERT INTO EMPLEADO_HORARIO VALUES ('Martes', 'Mañana', 100);
INSERT INTO EMPLEADO_HORARIO VALUES ('Miercoles', 'Mañana', 100);
INSERT INTO EMPLEADO_HORARIO VALUES ('Jueves', 'Mañana', 100);
INSERT INTO EMPLEADO_HORARIO VALUES ('Viernes', 'Mañana', 100);
INSERT INTO EMPLEADO_HORARIO VALUES ('Lunes', 'Tarde', 101);
INSERT INTO EMPLEADO_HORARIO VALUES ('Martes', 'Tarde', 101);
INSERT INTO EMPLEADO_HORARIO VALUES ('Miercoles', 'Tarde', 101);
INSERT INTO EMPLEADO_HORARIO VALUES ('Jueves', 'Tarde', 101);
INSERT INTO EMPLEADO_HORARIO VALUES ('Viernes', 'Tarde', 101);

INSERT INTO ASISTENCIA_EMPLEADO VALUES (100, 'Lunes', TO_DATE('2025-01-06', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-01-06 08:05:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-06 16:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ASISTENCIA_EMPLEADO VALUES (100, 'Martes', TO_DATE('2025-01-07', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-01-07 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-07 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ASISTENCIA_EMPLEADO VALUES (100, 'Miercoles', TO_DATE('2025-01-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-01-08 08:10:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-08 16:05:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ASISTENCIA_EMPLEADO VALUES (100, 'Jueves', TO_DATE('2025-01-09', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-01-09 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-09 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ASISTENCIA_EMPLEADO VALUES (100, 'Viernes', TO_DATE('2025-01-10', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-01-10 08:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-10 15:45:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ASISTENCIA_EMPLEADO VALUES (101, 'Lunes', TO_DATE('2025-01-06', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-01-06 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-06 22:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ASISTENCIA_EMPLEADO VALUES (101, 'Martes', TO_DATE('2025-01-07', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-01-07 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-07 22:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ASISTENCIA_EMPLEADO VALUES (101, 'Miercoles', TO_DATE('2025-01-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-01-08 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-08 22:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ASISTENCIA_EMPLEADO VALUES (101, 'Jueves', TO_DATE('2025-01-09', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-01-09 14:10:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-09 21:50:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ASISTENCIA_EMPLEADO VALUES (101, 'Viernes', TO_DATE('2025-01-10', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-01-10 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-10 22:00:00', 'YYYY-MM-DD HH24:MI:SS'));

COMMIT;

CREATE OR REPLACE PACKAGE PKG_EMPLOYEE AS
    PROCEDURE crear_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_hire_date DATE,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    );
    
    PROCEDURE leer_employee(p_employee_id NUMBER);
    
    PROCEDURE actualizar_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    );
    
    PROCEDURE eliminar_employee(p_employee_id NUMBER);
    
    PROCEDURE listar_todos_employees;
    
    PROCEDURE empleados_mas_rotacion;
    
    FUNCTION promedio_contrataciones_mes RETURN NUMBER;
    
    PROCEDURE gastos_salarios_region;
    
    FUNCTION calcular_vacaciones_empleados RETURN NUMBER;
    
    -- 3.1.5 Escriba una función que reciba como parámetro el código de un empleado, el número de mes y el número de año. Calcule la cantidad de horas que laboro en dicho mes.
    FUNCTION calcular_horas_laboradas(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_año NUMBER
    ) RETURN NUMBER;
    
    -- 3.1.6 Escriba una función que reciba como parámetro el código de un empleado, el número de mes y el número de año. Calcule la cantidad de horas que falto el empleado en base a la función anterior.
    FUNCTION calcular_horas_faltadas(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_año NUMBER
    ) RETURN NUMBER;
    
    -- 3.1.7 Escriba un procedimiento que reciba como parámetro el número del mes y el número de año. Calcule para cada empleado en dicho mes y año el monto de sueldo que le corresponde.
    PROCEDURE calcular_sueldos_mes(
        p_mes NUMBER,
        p_año NUMBER
    );
    
END PKG_EMPLOYEE;
/

CREATE OR REPLACE PACKAGE BODY PKG_EMPLOYEE AS

    PROCEDURE crear_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_hire_date DATE,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    ) IS
    BEGIN
        INSERT INTO EMPLOYEES VALUES (
            p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
            p_hire_date, p_job_id, p_salary, p_commission_pct, p_manager_id, p_department_id
        );
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Empleado creado exitosamente: ' || p_employee_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: El empleado con ID ' || p_employee_id || ' ya existe.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al crear empleado: ' || SQLERRM);
    END crear_employee;
    
    PROCEDURE leer_employee(p_employee_id NUMBER) IS
        v_emp EMPLOYEES%ROWTYPE;
    BEGIN
        SELECT * INTO v_emp FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id;
        
        DBMS_OUTPUT.PUT_LINE('=== DATOS DEL EMPLEADO ===');
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_emp.FIRST_NAME || ' ' || v_emp.LAST_NAME);
        DBMS_OUTPUT.PUT_LINE('Email: ' || v_emp.EMAIL);
        DBMS_OUTPUT.PUT_LINE('Teléfono: ' || v_emp.PHONE_NUMBER);
        DBMS_OUTPUT.PUT_LINE('Fecha Contratación: ' || v_emp.HIRE_DATE);
        DBMS_OUTPUT.PUT_LINE('Puesto: ' || v_emp.JOB_ID);
        DBMS_OUTPUT.PUT_LINE('Salario: ' || v_emp.SALARY);
        DBMS_OUTPUT.PUT_LINE('Comisión: ' || NVL(TO_CHAR(v_emp.COMMISSION_PCT), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Manager: ' || NVL(TO_CHAR(v_emp.MANAGER_ID), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Departamento: ' || NVL(TO_CHAR(v_emp.DEPARTMENT_ID), 'N/A'));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: No existe empleado con ID ' || p_employee_id);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al leer empleado: ' || SQLERRM);
    END leer_employee;
    
    PROCEDURE actualizar_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    ) IS
    BEGIN
        UPDATE EMPLOYEES SET
            FIRST_NAME = p_first_name,
            LAST_NAME = p_last_name,
            EMAIL = p_email,
            PHONE_NUMBER = p_phone_number,
            JOB_ID = p_job_id,
            SALARY = p_salary,
            COMMISSION_PCT = p_commission_pct,
            MANAGER_ID = p_manager_id,
            DEPARTMENT_ID = p_department_id
        WHERE EMPLOYEE_ID = p_employee_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: No existe empleado con ID ' || p_employee_id);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Empleado actualizado exitosamente: ' || p_employee_id);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al actualizar empleado: ' || SQLERRM);
    END actualizar_employee;
    
    PROCEDURE eliminar_employee(p_employee_id NUMBER) IS
    BEGIN
        DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: No existe empleado con ID ' || p_employee_id);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Empleado eliminado exitosamente: ' || p_employee_id);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al eliminar empleado: ' || SQLERRM);
    END eliminar_employee;
    
    PROCEDURE listar_todos_employees IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== LISTA DE EMPLEADOS ===');
        FOR rec IN (SELECT * FROM EMPLOYEES ORDER BY EMPLOYEE_ID) LOOP
            DBMS_OUTPUT.PUT_LINE('ID: ' || rec.EMPLOYEE_ID || ', Nombre: ' || rec.FIRST_NAME || ' ' || rec.LAST_NAME || 
                               ', Puesto: ' || rec.JOB_ID || ', Salario: ' || rec.SALARY);
        END LOOP;
    END listar_todos_employees;
    
    PROCEDURE empleados_mas_rotacion IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== 4 EMPLEADOS CON MÁS ROTACIÓN DE PUESTOS ===');
        FOR rec IN (
            SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.FIRST_NAME, E.JOB_ID, J.JOB_TITLE, 
                   COUNT(JH.JOB_ID) AS NUM_CAMBIOS
            FROM EMPLOYEES E
            INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
            LEFT JOIN JOB_HISTORY JH ON E.EMPLOYEE_ID = JH.EMPLOYEE_ID
            GROUP BY E.EMPLOYEE_ID, E.LAST_NAME, E.FIRST_NAME, E.JOB_ID, J.JOB_TITLE
            ORDER BY NUM_CAMBIOS DESC
            FETCH FIRST 4 ROWS ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Empleado ID: ' || rec.EMPLOYEE_ID || 
                               ', Nombre: ' || rec.FIRST_NAME || ' ' || rec.LAST_NAME ||
                               ', Puesto Actual: ' || rec.JOB_ID || ' - ' || rec.JOB_TITLE ||
                               ', Cambios de Puesto: ' || rec.NUM_CAMBIOS);
        END LOOP;
    END empleados_mas_rotacion;
    
    FUNCTION promedio_contrataciones_mes RETURN NUMBER IS
        v_total_meses NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PROMEDIO DE CONTRATACIONES POR MES ===');
        FOR rec IN (
            SELECT TO_CHAR(HIRE_DATE, 'Month') AS MES,
                   EXTRACT(MONTH FROM HIRE_DATE) AS MES_NUM,
                   COUNT(*) / COUNT(DISTINCT EXTRACT(YEAR FROM HIRE_DATE)) AS PROMEDIO_CONTRATACIONES
            FROM EMPLOYEES
            GROUP BY TO_CHAR(HIRE_DATE, 'Month'), EXTRACT(MONTH FROM HIRE_DATE)
            ORDER BY MES_NUM
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Mes: ' || TRIM(rec.MES) || 
                               ', Promedio Contrataciones: ' || ROUND(rec.PROMEDIO_CONTRATACIONES, 2));
            v_total_meses := v_total_meses + 1;
        END LOOP;
        
        RETURN v_total_meses;
    END promedio_contrataciones_mes;
    
    PROCEDURE gastos_salarios_region IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== GASTOS EN SALARIOS Y ESTADÍSTICAS POR REGIÓN ===');
        FOR rec IN (
            SELECT R.REGION_NAME,
                   SUM(E.SALARY) AS SUMA_SALARIOS,
                   COUNT(E.EMPLOYEE_ID) AS CANTIDAD_EMPLEADOS,
                   MIN(E.HIRE_DATE) AS EMPLEADO_MAS_ANTIGUO
            FROM REGIONS R
            INNER JOIN COUNTRIES C ON R.REGION_ID = C.REGION_ID
            INNER JOIN LOCATIONS L ON C.COUNTRY_ID = L.COUNTRY_ID
            INNER JOIN DEPARTMENTS D ON L.LOCATION_ID = D.LOCATION_ID
            INNER JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
            GROUP BY R.REGION_NAME
            ORDER BY R.REGION_NAME
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Región: ' || rec.REGION_NAME ||
                               ', Suma Salarios: ' || rec.SUMA_SALARIOS ||
                               ', Cantidad Empleados: ' || rec.CANTIDAD_EMPLEADOS ||
                               ', Empleado Más Antiguo: ' || TO_CHAR(rec.EMPLEADO_MAS_ANTIGUO, 'DD-MON-YYYY'));
        END LOOP;
    END gastos_salarios_region;
    
    FUNCTION calcular_vacaciones_empleados RETURN NUMBER IS
        v_monto_total NUMBER := 0;
        v_años_servicio NUMBER;
        v_meses_vacaciones NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== TIEMPO DE SERVICIO Y VACACIONES DE EMPLEADOS ===');
        FOR rec IN (
            SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, SALARY
            FROM EMPLOYEES
            ORDER BY EMPLOYEE_ID
        ) LOOP
            v_años_servicio := FLOOR(MONTHS_BETWEEN(SYSDATE, rec.HIRE_DATE) / 12);
            v_meses_vacaciones := v_años_servicio;
            v_monto_total := v_monto_total + (rec.SALARY * v_meses_vacaciones);
            
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || rec.FIRST_NAME || ' ' || rec.LAST_NAME ||
                               ', Años de Servicio: ' || v_años_servicio ||
                               ', Meses de Vacaciones: ' || v_meses_vacaciones ||
                               ', Monto Vacaciones: ' || (rec.SALARY * v_meses_vacaciones));
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('=== MONTO TOTAL PARA VACACIONES: ' || v_monto_total || ' ===');
        RETURN v_monto_total;
    END calcular_vacaciones_empleados;
    
    -- 3.1.5 Escriba una función que reciba como parámetro el código de un empleado, el número de mes y el número de año. Calcule la cantidad de horas que laboro en dicho mes.
    FUNCTION calcular_horas_laboradas(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_año NUMBER
    ) RETURN NUMBER IS
        v_total_horas NUMBER := 0;
        v_horas NUMBER;
    BEGIN
        FOR rec IN (
            SELECT HORA_INICIO_REAL, HORA_TERMINO_REAL
            FROM ASISTENCIA_EMPLEADO
            WHERE EMPLOYEE_ID = p_employee_id
            AND EXTRACT(MONTH FROM FECHA_REAL) = p_mes
            AND EXTRACT(YEAR FROM FECHA_REAL) = p_año
        ) LOOP
            v_horas := EXTRACT(HOUR FROM (rec.HORA_TERMINO_REAL - rec.HORA_INICIO_REAL)) +
                      EXTRACT(MINUTE FROM (rec.HORA_TERMINO_REAL - rec.HORA_INICIO_REAL)) / 60;
            v_total_horas := v_total_horas + v_horas;
        END LOOP;
        
        RETURN v_total_horas;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END calcular_horas_laboradas;
    
    -- 3.1.6 Escriba una función que reciba como parámetro el código de un empleado, el número de mes y el número de año. Calcule la cantidad de horas que falto el empleado en base a la función anterior.
    FUNCTION calcular_horas_faltadas(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_año NUMBER
    ) RETURN NUMBER IS
        v_horas_esperadas NUMBER := 0;
        v_horas_laboradas NUMBER := 0;
        v_horas_faltadas NUMBER := 0;
        v_primer_dia DATE;
        v_ultimo_dia DATE;
        v_fecha_actual DATE;
        v_dia_semana VARCHAR2(10);
    BEGIN
        v_primer_dia := TO_DATE(p_año || '-' || LPAD(p_mes, 2, '0') || '-01', 'YYYY-MM-DD');
        v_ultimo_dia := LAST_DAY(v_primer_dia);
        
        v_fecha_actual := v_primer_dia;
        WHILE v_fecha_actual <= v_ultimo_dia LOOP
            v_dia_semana := CASE TO_CHAR(v_fecha_actual, 'D')
                WHEN '2' THEN 'Lunes'
                WHEN '3' THEN 'Martes'
                WHEN '4' THEN 'Miercoles'
                WHEN '5' THEN 'Jueves'
                WHEN '6' THEN 'Viernes'
                WHEN '7' THEN 'Sabado'
                WHEN '1' THEN 'Domingo'
            END;
            
            FOR rec IN (
                SELECT H.HORA_INICIO, H.HORA_TERMINO
                FROM EMPLEADO_HORARIO EH
                INNER JOIN HORARIO H ON EH.DIA_SEMANA = H.DIA_SEMANA AND EH.TURNO = H.TURNO
                WHERE EH.EMPLOYEE_ID = p_employee_id
                AND EH.DIA_SEMANA = v_dia_semana
            ) LOOP
                v_horas_esperadas := v_horas_esperadas + 
                    (EXTRACT(HOUR FROM (rec.HORA_TERMINO - rec.HORA_INICIO)) +
                     EXTRACT(MINUTE FROM (rec.HORA_TERMINO - rec.HORA_INICIO)) / 60);
            END LOOP;
            
            v_fecha_actual := v_fecha_actual + 1;
        END LOOP;
        
        v_horas_laboradas := calcular_horas_laboradas(p_employee_id, p_mes, p_año);
        v_horas_faltadas := v_horas_esperadas - v_horas_laboradas;
        
        RETURN GREATEST(v_horas_faltadas, 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END calcular_horas_faltadas;
    
    -- 3.1.7 Escriba un procedimiento que reciba como parámetro el número del mes y el número de año. Calcule para cada empleado en dicho mes y año el monto de sueldo que le corresponde.
    PROCEDURE calcular_sueldos_mes(
        p_mes NUMBER,
        p_año NUMBER
    ) IS
        v_horas_laboradas NUMBER;
        v_horas_faltadas NUMBER;
        v_horas_esperadas NUMBER;
        v_salario_proporcional NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== REPORTE DE SUELDOS - MES: ' || p_mes || ' AÑO: ' || p_año || ' ===');
        DBMS_OUTPUT.PUT_LINE('');
        
        FOR emp IN (
            SELECT DISTINCT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.SALARY
            FROM EMPLOYEES E
            INNER JOIN EMPLEADO_HORARIO EH ON E.EMPLOYEE_ID = EH.EMPLOYEE_ID
            ORDER BY E.EMPLOYEE_ID
        ) LOOP
            v_horas_laboradas := calcular_horas_laboradas(emp.EMPLOYEE_ID, p_mes, p_año);
            v_horas_faltadas := calcular_horas_faltadas(emp.EMPLOYEE_ID, p_mes, p_año);
            v_horas_esperadas := v_horas_laboradas + v_horas_faltadas;
            
            IF v_horas_esperadas > 0 THEN
                v_salario_proporcional := emp.SALARY * (v_horas_laboradas / v_horas_esperadas);
            ELSE
                v_salario_proporcional := emp.SALARY;
            END IF;
            
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || emp.FIRST_NAME || ' ' || emp.LAST_NAME);
            DBMS_OUTPUT.PUT_LINE('  - Horas Esperadas: ' || ROUND(v_horas_esperadas, 2));
            DBMS_OUTPUT.PUT_LINE('  - Horas Laboradas: ' || ROUND(v_horas_laboradas, 2));
            DBMS_OUTPUT.PUT_LINE('  - Horas Faltadas: ' || ROUND(v_horas_faltadas, 2));
            DBMS_OUTPUT.PUT_LINE('  - Salario Base: ' || emp.SALARY);
            DBMS_OUTPUT.PUT_LINE('  - Salario a Pagar: ' || ROUND(v_salario_proporcional, 2));
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
    END calcular_sueldos_mes;
    
END PKG_EMPLOYEE;
/

SET SERVEROUTPUT ON;

DECLARE
    v_horas NUMBER;
BEGIN
    v_horas := PKG_EMPLOYEE.calcular_horas_laboradas(100, 1, 2025);
    DBMS_OUTPUT.PUT_LINE('Horas laboradas por empleado 100 en Enero 2025: ' || ROUND(v_horas, 2));
END;
/

DECLARE
    v_horas NUMBER;
BEGIN
    v_horas := PKG_EMPLOYEE.calcular_horas_faltadas(100, 1, 2025);
    DBMS_OUTPUT.PUT_LINE('Horas faltadas por empleado 100 en Enero 2025: ' || ROUND(v_horas, 2));
END;
/

EXEC PKG_EMPLOYEE.calcular_sueldos_mes(1, 2025);

-- 22222
CREATE TABLE CAPACITACION (
    CODIGO_CAPACITACION NUMBER PRIMARY KEY,
    NOMBRE_CAPACITACION VARCHAR2(100) NOT NULL,
    HORAS_CAPACITACION NUMBER NOT NULL,
    DESCRIPCION_CAPACITACION VARCHAR2(200)
) TABLESPACE hr_tablespace;

CREATE TABLE EMPLEADO_CAPACITACION (
    EMPLOYEE_ID NUMBER(6),
    CODIGO_CAPACITACION NUMBER,
    CONSTRAINT pk_empleado_capacitacion PRIMARY KEY (EMPLOYEE_ID, CODIGO_CAPACITACION),
    CONSTRAINT fk_emp_cap_employee FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    CONSTRAINT fk_emp_cap_capacitacion FOREIGN KEY (CODIGO_CAPACITACION) REFERENCES CAPACITACION(CODIGO_CAPACITACION)
) TABLESPACE hr_tablespace;

INSERT INTO CAPACITACION VALUES (1, 'Gestión de Proyectos con PMI', 40, 'Capacitación en metodologías de gestión de proyectos según el PMI');
INSERT INTO CAPACITACION VALUES (2, 'Liderazgo y Trabajo en Equipo', 20, 'Desarrollo de habilidades de liderazgo y gestión de equipos');
INSERT INTO CAPACITACION VALUES (3, 'Excel Avanzado', 16, 'Manejo avanzado de Excel: tablas dinámicas, macros y análisis de datos');
INSERT INTO CAPACITACION VALUES (4, 'Seguridad de la Información', 24, 'Principios de seguridad informática y protección de datos');
INSERT INTO CAPACITACION VALUES (5, 'Atención al Cliente', 12, 'Técnicas de atención y servicio al cliente');
INSERT INTO CAPACITACION VALUES (6, 'Programación en Python', 60, 'Curso completo de programación en Python desde básico hasta avanzado');
INSERT INTO CAPACITACION VALUES (7, 'Inteligencia Emocional', 16, 'Desarrollo de inteligencia emocional en el entorno laboral');
INSERT INTO CAPACITACION VALUES (8, 'Base de Datos Oracle', 48, 'Administración y programación en Oracle Database');
INSERT INTO CAPACITACION VALUES (9, 'Gestión del Tiempo', 8, 'Técnicas para mejorar la productividad y gestión del tiempo');
INSERT INTO CAPACITACION VALUES (10, 'Marketing Digital', 32, 'Estrategias de marketing digital y redes sociales');

INSERT INTO EMPLEADO_CAPACITACION VALUES (100, 1);
INSERT INTO EMPLEADO_CAPACITACION VALUES (100, 2);
INSERT INTO EMPLEADO_CAPACITACION VALUES (100, 9);
INSERT INTO EMPLEADO_CAPACITACION VALUES (101, 2);
INSERT INTO EMPLEADO_CAPACITACION VALUES (101, 5);
INSERT INTO EMPLEADO_CAPACITACION VALUES (101, 7);
INSERT INTO EMPLEADO_CAPACITACION VALUES (102, 6);
INSERT INTO EMPLEADO_CAPACITACION VALUES (102, 8);
INSERT INTO EMPLEADO_CAPACITACION VALUES (103, 3);
INSERT INTO EMPLEADO_CAPACITACION VALUES (103, 6);
INSERT INTO EMPLEADO_CAPACITACION VALUES (103, 8);
INSERT INTO EMPLEADO_CAPACITACION VALUES (104, 3);
INSERT INTO EMPLEADO_CAPACITACION VALUES (104, 4);
INSERT INTO EMPLEADO_CAPACITACION VALUES (104, 6);

COMMIT;

CREATE OR REPLACE PACKAGE PKG_EMPLOYEE AS
    PROCEDURE crear_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_hire_date DATE,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    );
    
    PROCEDURE leer_employee(p_employee_id NUMBER);
    
    PROCEDURE actualizar_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    );
    
    PROCEDURE eliminar_employee(p_employee_id NUMBER);
    
    PROCEDURE listar_todos_employees;
    
    PROCEDURE empleados_mas_rotacion;
    
    FUNCTION promedio_contrataciones_mes RETURN NUMBER;
    
    PROCEDURE gastos_salarios_region;
    
    FUNCTION calcular_vacaciones_empleados RETURN NUMBER;
    
    FUNCTION calcular_horas_laboradas(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_año NUMBER
    ) RETURN NUMBER;
    
    FUNCTION calcular_horas_faltadas(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_año NUMBER
    ) RETURN NUMBER;
    
    PROCEDURE calcular_sueldos_mes(
        p_mes NUMBER,
        p_año NUMBER
    );
    
    -- 3.1.1 Escriba una función que calcule la cantidad de horas totales que tiene cada empleado en las capacitaciones desarrolladas por la empresa.
    FUNCTION calcular_horas_capacitacion_empleado(
        p_employee_id NUMBER
    ) RETURN NUMBER;
    
    -- 3.1.2 Elabore un procedimiento que liste todas las capacitaciones desarrolladas por la empresa y muestre los nombres de los empleados junto con la cantidad total de horas que participo cada empleado en las capacitaciones.
    PROCEDURE listar_capacitaciones_empleados;
    
END PKG_EMPLOYEE;
/

CREATE OR REPLACE PACKAGE BODY PKG_EMPLOYEE AS

    PROCEDURE crear_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_hire_date DATE,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    ) IS
    BEGIN
        INSERT INTO EMPLOYEES VALUES (
            p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
            p_hire_date, p_job_id, p_salary, p_commission_pct, p_manager_id, p_department_id
        );
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Empleado creado exitosamente: ' || p_employee_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: El empleado con ID ' || p_employee_id || ' ya existe.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al crear empleado: ' || SQLERRM);
    END crear_employee;
    
    PROCEDURE leer_employee(p_employee_id NUMBER) IS
        v_emp EMPLOYEES%ROWTYPE;
    BEGIN
        SELECT * INTO v_emp FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id;
        
        DBMS_OUTPUT.PUT_LINE('=== DATOS DEL EMPLEADO ===');
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_emp.FIRST_NAME || ' ' || v_emp.LAST_NAME);
        DBMS_OUTPUT.PUT_LINE('Email: ' || v_emp.EMAIL);
        DBMS_OUTPUT.PUT_LINE('Teléfono: ' || v_emp.PHONE_NUMBER);
        DBMS_OUTPUT.PUT_LINE('Fecha Contratación: ' || v_emp.HIRE_DATE);
        DBMS_OUTPUT.PUT_LINE('Puesto: ' || v_emp.JOB_ID);
        DBMS_OUTPUT.PUT_LINE('Salario: ' || v_emp.SALARY);
        DBMS_OUTPUT.PUT_LINE('Comisión: ' || NVL(TO_CHAR(v_emp.COMMISSION_PCT), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Manager: ' || NVL(TO_CHAR(v_emp.MANAGER_ID), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Departamento: ' || NVL(TO_CHAR(v_emp.DEPARTMENT_ID), 'N/A'));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: No existe empleado con ID ' || p_employee_id);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al leer empleado: ' || SQLERRM);
    END leer_employee;
    
    PROCEDURE actualizar_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    ) IS
    BEGIN
        UPDATE EMPLOYEES SET
            FIRST_NAME = p_first_name,
            LAST_NAME = p_last_name,
            EMAIL = p_email,
            PHONE_NUMBER = p_phone_number,
            JOB_ID = p_job_id,
            SALARY = p_salary,
            COMMISSION_PCT = p_commission_pct,
            MANAGER_ID = p_manager_id,
            DEPARTMENT_ID = p_department_id
        WHERE EMPLOYEE_ID = p_employee_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: No existe empleado con ID ' || p_employee_id);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Empleado actualizado exitosamente: ' || p_employee_id);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al actualizar empleado: ' || SQLERRM);
    END actualizar_employee;
    
    PROCEDURE eliminar_employee(p_employee_id NUMBER) IS
    BEGIN
        DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: No existe empleado con ID ' || p_employee_id);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Empleado eliminado exitosamente: ' || p_employee_id);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al eliminar empleado: ' || SQLERRM);
    END eliminar_employee;
    
    PROCEDURE listar_todos_employees IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== LISTA DE EMPLEADOS ===');
        FOR rec IN (SELECT * FROM EMPLOYEES ORDER BY EMPLOYEE_ID) LOOP
            DBMS_OUTPUT.PUT_LINE('ID: ' || rec.EMPLOYEE_ID || ', Nombre: ' || rec.FIRST_NAME || ' ' || rec.LAST_NAME || 
                               ', Puesto: ' || rec.JOB_ID || ', Salario: ' || rec.SALARY);
        END LOOP;
    END listar_todos_employees;
    
    PROCEDURE empleados_mas_rotacion IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== 4 EMPLEADOS CON MÁS ROTACIÓN DE PUESTOS ===');
        FOR rec IN (
            SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.FIRST_NAME, E.JOB_ID, J.JOB_TITLE, 
                   COUNT(JH.JOB_ID) AS NUM_CAMBIOS
            FROM EMPLOYEES E
            INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
            LEFT JOIN JOB_HISTORY JH ON E.EMPLOYEE_ID = JH.EMPLOYEE_ID
            GROUP BY E.EMPLOYEE_ID, E.LAST_NAME, E.FIRST_NAME, E.JOB_ID, J.JOB_TITLE
            ORDER BY NUM_CAMBIOS DESC
            FETCH FIRST 4 ROWS ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Empleado ID: ' || rec.EMPLOYEE_ID || 
                               ', Nombre: ' || rec.FIRST_NAME || ' ' || rec.LAST_NAME ||
                               ', Puesto Actual: ' || rec.JOB_ID || ' - ' || rec.JOB_TITLE ||
                               ', Cambios de Puesto: ' || rec.NUM_CAMBIOS);
        END LOOP;
    END empleados_mas_rotacion;
    
    FUNCTION promedio_contrataciones_mes RETURN NUMBER IS
        v_total_meses NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PROMEDIO DE CONTRATACIONES POR MES ===');
        FOR rec IN (
            SELECT TO_CHAR(HIRE_DATE, 'Month') AS MES,
                   EXTRACT(MONTH FROM HIRE_DATE) AS MES_NUM,
                   COUNT(*) / COUNT(DISTINCT EXTRACT(YEAR FROM HIRE_DATE)) AS PROMEDIO_CONTRATACIONES
            FROM EMPLOYEES
            GROUP BY TO_CHAR(HIRE_DATE, 'Month'), EXTRACT(MONTH FROM HIRE_DATE)
            ORDER BY MES_NUM
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Mes: ' || TRIM(rec.MES) || 
                               ', Promedio Contrataciones: ' || ROUND(rec.PROMEDIO_CONTRATACIONES, 2));
            v_total_meses := v_total_meses + 1;
        END LOOP;
        
        RETURN v_total_meses;
    END promedio_contrataciones_mes;
    
    PROCEDURE gastos_salarios_region IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== GASTOS EN SALARIOS Y ESTADÍSTICAS POR REGIÓN ===');
        FOR rec IN (
            SELECT R.REGION_NAME,
                   SUM(E.SALARY) AS SUMA_SALARIOS,
                   COUNT(E.EMPLOYEE_ID) AS CANTIDAD_EMPLEADOS,
                   MIN(E.HIRE_DATE) AS EMPLEADO_MAS_ANTIGUO
            FROM REGIONS R
            INNER JOIN COUNTRIES C ON R.REGION_ID = C.REGION_ID
            INNER JOIN LOCATIONS L ON C.COUNTRY_ID = L.COUNTRY_ID
            INNER JOIN DEPARTMENTS D ON L.LOCATION_ID = D.LOCATION_ID
            INNER JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
            GROUP BY R.REGION_NAME
            ORDER BY R.REGION_NAME
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Región: ' || rec.REGION_NAME ||
                               ', Suma Salarios: ' || rec.SUMA_SALARIOS ||
                               ', Cantidad Empleados: ' || rec.CANTIDAD_EMPLEADOS ||
                               ', Empleado Más Antiguo: ' || TO_CHAR(rec.EMPLEADO_MAS_ANTIGUO, 'DD-MON-YYYY'));
        END LOOP;
    END gastos_salarios_region;
    
    FUNCTION calcular_vacaciones_empleados RETURN NUMBER IS
        v_monto_total NUMBER := 0;
        v_años_servicio NUMBER;
        v_meses_vacaciones NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== TIEMPO DE SERVICIO Y VACACIONES DE EMPLEADOS ===');
        FOR rec IN (
            SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, SALARY
            FROM EMPLOYEES
            ORDER BY EMPLOYEE_ID
        ) LOOP
            v_años_servicio := FLOOR(MONTHS_BETWEEN(SYSDATE, rec.HIRE_DATE) / 12);
            v_meses_vacaciones := v_años_servicio;
            v_monto_total := v_monto_total + (rec.SALARY * v_meses_vacaciones);
            
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || rec.FIRST_NAME || ' ' || rec.LAST_NAME ||
                               ', Años de Servicio: ' || v_años_servicio ||
                               ', Meses de Vacaciones: ' || v_meses_vacaciones ||
                               ', Monto Vacaciones: ' || (rec.SALARY * v_meses_vacaciones));
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('=== MONTO TOTAL PARA VACACIONES: ' || v_monto_total || ' ===');
        RETURN v_monto_total;
    END calcular_vacaciones_empleados;
    
    FUNCTION calcular_horas_laboradas(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_año NUMBER
    ) RETURN NUMBER IS
        v_total_horas NUMBER := 0;
        v_horas NUMBER;
    BEGIN
        FOR rec IN (
            SELECT HORA_INICIO_REAL, HORA_TERMINO_REAL
            FROM ASISTENCIA_EMPLEADO
            WHERE EMPLOYEE_ID = p_employee_id
            AND EXTRACT(MONTH FROM FECHA_REAL) = p_mes
            AND EXTRACT(YEAR FROM FECHA_REAL) = p_año
        ) LOOP
            v_horas := EXTRACT(HOUR FROM (rec.HORA_TERMINO_REAL - rec.HORA_INICIO_REAL)) +
                      EXTRACT(MINUTE FROM (rec.HORA_TERMINO_REAL - rec.HORA_INICIO_REAL)) / 60;
            v_total_horas := v_total_horas + v_horas;
        END LOOP;
        
        RETURN v_total_horas;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END calcular_horas_laboradas;
    
    FUNCTION calcular_horas_faltadas(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_año NUMBER
    ) RETURN NUMBER IS
        v_horas_esperadas NUMBER := 0;
        v_horas_laboradas NUMBER := 0;
        v_horas_faltadas NUMBER := 0;
        v_primer_dia DATE;
        v_ultimo_dia DATE;
        v_fecha_actual DATE;
        v_dia_semana VARCHAR2(10);
    BEGIN
        v_primer_dia := TO_DATE(p_año || '-' || LPAD(p_mes, 2, '0') || '-01', 'YYYY-MM-DD');
        v_ultimo_dia := LAST_DAY(v_primer_dia);
        
        v_fecha_actual := v_primer_dia;
        WHILE v_fecha_actual <= v_ultimo_dia LOOP
            v_dia_semana := CASE TO_CHAR(v_fecha_actual, 'D')
                WHEN '2' THEN 'Lunes'
                WHEN '3' THEN 'Martes'
                WHEN '4' THEN 'Miercoles'
                WHEN '5' THEN 'Jueves'
                WHEN '6' THEN 'Viernes'
                WHEN '7' THEN 'Sabado'
                WHEN '1' THEN 'Domingo'
            END;
            
            FOR rec IN (
                SELECT H.HORA_INICIO, H.HORA_TERMINO
                FROM EMPLEADO_HORARIO EH
                INNER JOIN HORARIO H ON EH.DIA_SEMANA = H.DIA_SEMANA AND EH.TURNO = H.TURNO
                WHERE EH.EMPLOYEE_ID = p_employee_id
                AND EH.DIA_SEMANA = v_dia_semana
            ) LOOP
                v_horas_esperadas := v_horas_esperadas + 
                    (EXTRACT(HOUR FROM (rec.HORA_TERMINO - rec.HORA_INICIO)) +
                     EXTRACT(MINUTE FROM (rec.HORA_TERMINO - rec.HORA_INICIO)) / 60);
            END LOOP;
            
            v_fecha_actual := v_fecha_actual + 1;
        END LOOP;
        
        v_horas_laboradas := calcular_horas_laboradas(p_employee_id, p_mes, p_año);
        v_horas_faltadas := v_horas_esperadas - v_horas_laboradas;
        
        RETURN GREATEST(v_horas_faltadas, 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END calcular_horas_faltadas;
    
    PROCEDURE calcular_sueldos_mes(
        p_mes NUMBER,
        p_año NUMBER
    ) IS
        v_horas_laboradas NUMBER;
        v_horas_faltadas NUMBER;
        v_horas_esperadas NUMBER;
        v_salario_proporcional NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== REPORTE DE SUELDOS - MES: ' || p_mes || ' AÑO: ' || p_año || ' ===');
        DBMS_OUTPUT.PUT_LINE('');
        
        FOR emp IN (
            SELECT DISTINCT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.SALARY
            FROM EMPLOYEES E
            INNER JOIN EMPLEADO_HORARIO EH ON E.EMPLOYEE_ID = EH.EMPLOYEE_ID
            ORDER BY E.EMPLOYEE_ID
        ) LOOP
            v_horas_laboradas := calcular_horas_laboradas(emp.EMPLOYEE_ID, p_mes, p_año);
            v_horas_faltadas := calcular_horas_faltadas(emp.EMPLOYEE_ID, p_mes, p_año);
            v_horas_esperadas := v_horas_laboradas + v_horas_faltadas;
            
            IF v_horas_esperadas > 0 THEN
                v_salario_proporcional := emp.SALARY * (v_horas_laboradas / v_horas_esperadas);
            ELSE
                v_salario_proporcional := emp.SALARY;
            END IF;
            
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || emp.FIRST_NAME || ' ' || emp.LAST_NAME);
            DBMS_OUTPUT.PUT_LINE('  - Horas Esperadas: ' || ROUND(v_horas_esperadas, 2));
            DBMS_OUTPUT.PUT_LINE('  - Horas Laboradas: ' || ROUND(v_horas_laboradas, 2));
            DBMS_OUTPUT.PUT_LINE('  - Horas Faltadas: ' || ROUND(v_horas_faltadas, 2));
            DBMS_OUTPUT.PUT_LINE('  - Salario Base: ' || emp.SALARY);
            DBMS_OUTPUT.PUT_LINE('  - Salario a Pagar: ' || ROUND(v_salario_proporcional, 2));
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
    END calcular_sueldos_mes;
    
    -- 3.1.1 Escriba una función que calcule la cantidad de horas totales que tiene cada empleado en las capacitaciones desarrolladas por la empresa.
    FUNCTION calcular_horas_capacitacion_empleado(
        p_employee_id NUMBER
    ) RETURN NUMBER IS
        v_total_horas NUMBER := 0;
    BEGIN
        SELECT NVL(SUM(C.HORAS_CAPACITACION), 0)
        INTO v_total_horas
        FROM EMPLEADO_CAPACITACION EC
        INNER JOIN CAPACITACION C ON EC.CODIGO_CAPACITACION = C.CODIGO_CAPACITACION
        WHERE EC.EMPLOYEE_ID = p_employee_id;
        
        RETURN v_total_horas;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RETURN 0;
    END calcular_horas_capacitacion_empleado;
    
    -- 3.1.2 Elabore un procedimiento que liste todas las capacitaciones desarrolladas por la empresa y muestre los nombres de los empleados junto con la cantidad total de horas que participo cada empleado en las capacitaciones.
    PROCEDURE listar_capacitaciones_empleados IS
        v_total_horas NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== REPORTE DE CAPACITACIONES POR EMPLEADO ===');
        DBMS_OUTPUT.PUT_LINE('');
        
        FOR emp IN (
            SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME
            FROM EMPLOYEES E
            WHERE EXISTS (
                SELECT 1 FROM EMPLEADO_CAPACITACION EC WHERE EC.EMPLOYEE_ID = E.EMPLOYEE_ID
            )
            ORDER BY E.EMPLOYEE_ID
        ) LOOP
            v_total_horas := calcular_horas_capacitacion_empleado(emp.EMPLOYEE_ID);
            
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || emp.FIRST_NAME || ' ' || emp.LAST_NAME || 
                               ' (ID: ' || emp.EMPLOYEE_ID || ')');
            DBMS_OUTPUT.PUT_LINE('Total de horas de capacitación: ' || v_total_horas);
            DBMS_OUTPUT.PUT_LINE('Capacitaciones cursadas:');
            
            FOR cap IN (
                SELECT C.NOMBRE_CAPACITACION, C.HORAS_CAPACITACION, C.DESCRIPCION_CAPACITACION
                FROM EMPLEADO_CAPACITACION EC
                INNER JOIN CAPACITACION C ON EC.CODIGO_CAPACITACION = C.CODIGO_CAPACITACION
                WHERE EC.EMPLOYEE_ID = emp.EMPLOYEE_ID
                ORDER BY C.NOMBRE_CAPACITACION
            ) LOOP
                DBMS_OUTPUT.PUT_LINE('  - ' || cap.NOMBRE_CAPACITACION || ' (' || cap.HORAS_CAPACITACION || ' horas)');
            END LOOP;
            
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('=== RANKING DE EMPLEADOS POR HORAS DE CAPACITACIÓN ===');
        DBMS_OUTPUT.PUT_LINE('');
        
        FOR ranking IN (
            SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, 
                   NVL(SUM(C.HORAS_CAPACITACION), 0) AS TOTAL_HORAS
            FROM EMPLOYEES E
            LEFT JOIN EMPLEADO_CAPACITACION EC ON E.EMPLOYEE_ID = EC.EMPLOYEE_ID
            LEFT JOIN CAPACITACION C ON EC.CODIGO_CAPACITACION = C.CODIGO_CAPACITACION
            GROUP BY E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME
            ORDER BY TOTAL_HORAS DESC, E.LAST_NAME
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || ranking.FIRST_NAME || ' ' || ranking.LAST_NAME || 
                               ' - Total Horas: ' || ranking.TOTAL_HORAS);
        END LOOP;
    END listar_capacitaciones_empleados;
    
END PKG_EMPLOYEE;
/

SET SERVEROUTPUT ON;

DECLARE
    v_horas NUMBER;
BEGIN
    v_horas := PKG_EMPLOYEE.calcular_horas_capacitacion_empleado(100);
    DBMS_OUTPUT.PUT_LINE('Horas totales de capacitación del empleado 100: ' || v_horas);
END;
/

EXEC PKG_EMPLOYEE.listar_capacitaciones_empleados;