Select * from layoffs;
# creating a duplicate table to perform operations so that raw data stay safe
    create table layoff_staging
    like layoffs;
# inserting data in new table
	insert layoff_staging
    select* from layoffs;
    select * from layoff_staging;
# step 1 checking data types of table content
    Describe layoff_staging;
    Select * from layoff_staging limit 10;
# Step 2 Trim Whitespaces
    UPDATE layoff_staging
	SET company = TRIM(company),
    location = TRIM(location),
    industry = TRIM(industry),
    stage = TRIM(stage),
    country = TRIM(country);
# Step 3 Standardizing to make all text lower case to avoid case sensitivity
	UPDATE layoff_staging
	SET company = lower(company),
    location = lower(location),
    industry = lower(industry),
    stage = lower(stage),
    country = lower(country); 
# Step 4 Handle blank or null values
	select * from layoff_staging
    where company 	= ' '
    or location = ' '
    or industry=' '
    or stage = ' '
    or country=' ';
# All are null values no blank spaces if there were blank spaces we would convert them to null values
# Step 5 converting data types
	select distinct `date` from layoff_staging;
    update layoff_staging
    set `date` = str_to_date(`date`, '%m/%d/%Y');
    Alter table layoff_staging
    modify column `date` DATE;
    select distinct percentage_laid_off from layoff_staging;
    Alter table layoff_staging
    modify column percentage_laid_off decimal(5 , 2);
# Step 6 Removing dupliates since there is no unique id in table so we add one to make things easy to select and identify duplicates to delete them
Alter table layoff_staging add column id int primary key auto_increment;
Select * from layoff_staging;
 # finding and deleting duplicates
 With duplicate_cte As(
 select id,
 Row_number() over(partition by company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage, country, funds_raised_millions order by id)
as row_num from layoff_staging)
Delete from layoff_staging
where id in( select id from duplicate_cte
where row_num>1);
# now checking if there are any duplicates left which shouldnt be
With Check_duplicates as (
Select *, Row_number() over( partition by company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage, country, funds_raised_millions order by id)
as row_num from layoff_staging)
Select * from check_duplicates where row_num>1;
# Step 7 performing sanity checks 
Select * from layoff_staging
where total_laid_off <0;
Select * from layoff_staging
where total_laid_off = 0 and percentage_laid_off >0;
Select * from layoff_staging
where percentage_laid_off > 1;
Select * from layoff_staging
where `date` >  curdate();
Select * from layoff_staging
where company is null or industry is null or `date` is null;
Delete from layoff_staging
where industry is null or `date` is null;
# creating a clean table to put cleaned data in there
create table layoff_clean like layoff_staging;
insert layoff_clean
select* from layoff_staging;
select * from layoff_clean;
