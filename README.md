## 🛠 Tools & Technologies

- **Database:** MySQL
- **Language:** SQL
- **Platform:** GitHub (Version Control)

## 🎯 Project Objectives

- Import and inspect raw layoff data
- Remove duplicates and inconsistencies
- Handle missing/null values
- Standardize inconsistent formatting (case, spaces, etc.)
- Convert data types appropriately
- Make the data analysis-ready
  
## 🧼 Data Cleaning Steps

The following tasks were performed in `data_cleaning.sql`:

1. **Created staging table** from raw CSV
2. **Removed exact duplicates** using `ROW_NUMBER()` and CTEs
3. **Trimmed and standardized text** (company names, countries, stages)
4. **Handled NULL and empty values** in key fields
5. **Converted `date` column** from text to `DATE` type
6. **Removed or fixed outliers** (e.g., invalid percentages)
7. **Verified column types** and cleaned `industry`, `stage`, etc.
8. **Exported cleaned dataset** (optional) to `clean_data/`

## 📊 Sample Queries

```sql
-- Find companies with the highest total layoffs
SELECT company, SUM(total_laid_off) AS total
FROM layoff_staging
GROUP BY company
ORDER BY total DESC
LIMIT 10;

-- Monthly layoff trends
SELECT DATE_FORMAT(`date`, '%Y-%m') AS month, COUNT(*) AS layoffs
FROM layoff_staging
GROUP BY month
ORDER BY month;
