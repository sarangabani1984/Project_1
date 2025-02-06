USE DWH

select * from bronze.erp_cust_az12

insert into silver.erp_cust_az12 (cid, bdate, gen)
-- Select and transform records from bronze.erp_cust_az12
SELECT 
    -- Transform CID by removing 'NAS' prefix if present
    CASE 
        WHEN cid LIKE '%NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
        ELSE cid 
    END AS cid,
    
    -- Validate and transform birth date
    CASE 
        WHEN bdate > GETDATE() THEN NULL 
        ELSE bdate 
    END AS bdate,
    
    -- Transform gender to standardized values
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'n/a'
    END AS gen
FROM 
    bronze.erp_cust_az12;

