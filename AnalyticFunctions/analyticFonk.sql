--1-Departmandaki t�m �al��an personelleri yanyana yazabilir misiniz?
SELECT
    department_id,
    LISTAGG(emp.first_name
              || ' '
              || emp.last_name,',') WITHIN GROUP(
        ORDER BY
            emp.first_name
    ) AS employees
FROM
    employees emp
GROUP BY
    department_id; --Q1
    
/
/*  JOBID YE GORE GRUPLANACAK
    EMPID YE SIRALANACAK GORE HERKESIN KENDINDEN 1 ONCEKI VE 1 SONRAKI
    SALARY TOPLAMI BULUNACAK
*/

SELECT
    emp.*,
    SUM(salary) OVER(
        PARTITION BY job_id
        ORDER BY
            employee_id
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) num
FROM
    employees emp -- Q2
/
/*  TELEFON NO HERKESIN KENDINDEN BIR SONRAKI KISININ TELEFON NUMARASINI
    YANINA YAZIN
    HIRE_DATE E G�RE SIRALI 
    DEPARTMENT_ID g�re gruplanmal�
*/

SELECT
    emp.*,
    LEAD(phone_number,1) OVER(
        PARTITION BY department_id
        ORDER BY
            hire_date
    ) next_value
FROM
    employees emp --Q3
/
/*  MAASLARA GORE 1 DEN BASLAYARAK SIRALA EMPLOYEES TABLOSU ICINDE
    MAAS AYNI ISE KIDEME(��E G�R�� TAR�H�) GORE SIRALA
*/

SELECT
    emp.*
FROM
    employees emp
ORDER BY
    salary,
    hire_date; -- Q4
    
/
--  T�M TABLOYU EMPLOYEES ILK 10 ���N 1 DIGER 10 ���N 2... YAZACAK. S�ralamay� EMPLOYEE_ID �zerinden yapabilir misiniz?

SELECT
    emp.*,
    NTILE(107 / 10) OVER( -- Q5 107 row num de�eri
        ORDER BY
            employee_id
    )
FROM
    employees emp; 

SELECT
    ROW_NUMBER() OVER(  -- buradan row number� ��renip 10 a b�lerek her 10 lu i�in bir de�eri ntile ile verebiliriz.
        ORDER BY
            employee_id
    )
FROM
    employees emp; 
    
/
--  employees tablosu y�l i�inde i�e ba�layan ilk personelleri listeleyebilir misiniz?

SELECT
    emp.*,
    M�N(hire_date) OVER(
        PARTITION BY TO_CHAR(hire_date,'yyyy')
    ) fv
FROM
    employees emp; -- Q7
    
/
--  Her departmanda en y�ksek �cret alan personel d���ndaki t�m kay�tlar gelsin.

SELECT
    *
FROM
    (
        SELECT
            e.*,
            DENSE_RANK() OVER(
                PARTITION BY department_id
                ORDER BY
                    salary DESC
            ) AS rank
        FROM
            employees e
    )
WHERE
    rank > 1; --Q8
    
/
--  Her departmanda en y�ksek �cret alan 2 personelin kay�tlar� gelsin. 

SELECT
    *
FROM
    (
        SELECT
            e.*,
            DENSE_RANK() OVER(
                PARTITION BY department_id
                ORDER BY
                    salary DESC
            ) AS rank
        FROM
            employees e
    )
WHERE
    rank < 3; --Q9
    
/