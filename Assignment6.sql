/*
Alex Look
CSC 355 Section 402
11/11/20
*/

declare
    taxratePtr TAXRATES%rowtype;
    payrollInfoPtr PAYROLL%rowtype;
    
    -- cursor to traverse both tables
    cursor payrollcursor is SELECT * FROM PAYROLL;
    cursor taxcursor is SELECT * FROM TAXRATES;
    
    -- variable to calculate indvidual tax withheld per worker
    taxwithheld float:=0.0;
    
    -- worker salary minus tax total
    workesalaryminustax float:=0.0;
    
    -- total tax per every worker
    totaltaxwithheld float:=0.0;
begin    

    -- select to pick from the taxrates and display the tax rates high and low. salary limit as well
    SELECT *
    INTO taxratePtr
    FROM TAXRATES;
    dbms_output.put_line('Tax Rates: '||taxratePtr.LowRate||', '||taxratePtr.HighRate);
    dbms_output.put_line('Salary Limit: '||taxratePtr.Limit);
    
    
  for rate in taxcursor loop
  for payrollInfoPtr in payrollcursor loop
   -- for loop to check the amount is less than salarylimit if so then multiply by perecent, subtract the withheld and add to the total withheld amount 
     if (payrollInfoPtr.WorkerSalary <= rate.Limit) then
     taxwithheld := rate.lowrate *0.01 * payrollInfoPtr.WorkerSalary;
     workesalaryminustax:=payrollInfoPtr.WorkerSalary-taxwithheld;
     totaltaxwithheld:=taxwithheld+totaltaxwithheld;
     else
     
     -- the withheld with go to a higher amount of taxing and still do the same calculations with the salary tax withheld, and adding to the total tax withheld amount.
     taxwithheld :=  rate.lowrate *0.01 * rate.Limit + (payrollInfoPtr.WorkerSalary - rate.Limit) * rate.highrate *0.01;
     workesalaryminustax:=payrollInfoPtr.WorkerSalary-taxwithheld;
     totaltaxwithheld:=taxwithheld+totaltaxwithheld;
     end if;
     
     -- this will display indvidual worker's workerID, their high end salary, their indvivdual tax withheld, and their subracted low salary amount
     dbms_output.put_line(payrollInfoPtr.WorkerID || ': ' || payrollInfoPtr.WorkerSalary || ' ' || taxwithheld|| ' '||workesalaryminustax);
     end loop;
     end loop;
-- this with display the total amount of tax withheld for all workers in the system
  DBMS_OUTPUT.PUT_LINE('Total tax withheld: ' || totaltaxwithheld);
end;
/
