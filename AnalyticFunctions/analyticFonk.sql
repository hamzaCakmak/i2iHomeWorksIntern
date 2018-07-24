--1-Departmandaki tüm çalýþan personelleri yanyana yazabilir misiniz?
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
    HIRE_DATE E GÖRE SIRALI 
    DEPARTMENT_ID göre gruplanmalý
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
    MAAS AYNI ISE KIDEME(ÝÞE GÝRÝÞ TARÝHÝ) GORE SIRALA
*/

SELECT
    emp.*
FROM
    employees emp
ORDER BY
    salary,
    hire_date; -- Q4
    
/
--  TÜM TABLOYU EMPLOYEES ILK 10 ÝÇÝN 1 DIGER 10 ÝÇÝN 2... YAZACAK. Sýralamayý EMPLOYEE_ID üzerinden yapabilir misiniz?

SELECT
    emp.*,
    NTILE(107 / 10) OVER( -- Q5 107 row num deðeri
        ORDER BY
            employee_id
    )
FROM
    employees emp; 

SELECT
    ROW_NUMBER() OVER(  -- buradan row numberý öðrenip 10 a bölerek her 10 lu için bir deðeri ntile ile verebiliriz.
        ORDER BY
            employee_id
    )
FROM
    employees emp; 
    
/
--  employees tablosu yýl içinde iþe baþlayan ilk personelleri listeleyebilir misiniz?

SELECT
    emp.*,
    MÝN(hire_date) OVER(
        PARTITION BY TO_CHAR(hire_date,'yyyy')
    ) fv
FROM
    employees emp; -- Q7
    
/
--  Her departmanda en yüksek ücret alan personel dýþýndaki tüm kayýtlar gelsin.

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
--  Her departmanda en yüksek ücret alan 2 personelin kayýtlarý gelsin. 

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