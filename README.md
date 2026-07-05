# SQL Data Cleaning Project – Nashville Housing Dataset

## Project Overview

This project demonstrates how to clean and prepare raw housing data using SQL Server. The Nashville Housing dataset contains missing values, inconsistent formatting, duplicate records, and combined address fields that require transformation before analysis. Throughout this project, I apply common SQL data cleaning techniques, including data standardization, null value handling, string manipulation, duplicate detection, and data transformation, to produce a cleaner, analysis-ready dataset.

---

## Dataset

**Dataset:** Nashville Housing Dataset

The dataset includes information such as:

- Parcel ID
- Property Address
- Owner Address
- Sale Date
- Sale Price
- Legal Reference
- Sold As Vacant

---

## Skills Demonstrated

- SQL Server (SSMS)
- Data Cleaning
- Data Transformation
- Data Standardization
- Self Joins
- Common Table Expressions (CTEs)
- Window Functions
- String Functions
- Table Alterations

---

## SQL Concepts Used

- `ALTER TABLE`
- `UPDATE`
- `CONVERT()`
- `ISNULL()`
- `SUBSTRING()`
- `CHARINDEX()`
- `REPLACE()`
- `PARSENAME()`
- `CASE`
- `ROW_NUMBER()`
- `PARTITION BY`
- Self Join
- CTE

---

## Cleaning Steps

### 1. Standardized Date Format

Converted the `SaleDate` column into a SQL `DATE` datatype for consistency.

---

### 2. Populated Missing Property Addresses

Filled missing `PropertyAddress` values by matching records with the same `ParcelID` using a self join.

---

### 3. Split Property Address

Separated the `PropertyAddress` column into:

- PropertySplitAddress
- PropertySplitCity

using `SUBSTRING()` and `CHARINDEX()`.

---

### 4. Split Owner Address

Separated the `OwnerAddress` column into:

- OwnerSplitAddress
- OwnerSplitCity
- OwnerSplitState

using `REPLACE()` and `PARSENAME()`.

---

### 5. Standardized Values

Converted the `SoldAsVacant` values from:

- Y → Yes
- N → No

using a `CASE` statement.

---

### 6. Identified Duplicate Records

Used `ROW_NUMBER()` with a Common Table Expression (CTE) to identify duplicate rows based on:

- ParcelID
- PropertyAddress
- SalePrice
- SaleDate
- LegalReference

---

### 7. Removed Unnecessary Columns

Dropped columns that were no longer required after the cleaning process.

---

## What I Learned

This project strengthened my understanding of:

- Cleaning real-world datasets using SQL
- String manipulation techniques
- Updating data with joins
- Working with CTEs and window functions
- Preparing datasets for reporting and analytics

---

## Technologies Used

- SQL Server
- SQL Server Management Studio (SSMS)

---

## Author

Sirajudeen Mohamed Amry
