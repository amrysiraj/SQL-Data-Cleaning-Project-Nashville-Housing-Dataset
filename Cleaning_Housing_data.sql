/*
Cleaning Housing data in SQL
*/


use [PortfolioProject];

select *
from [dbo].[HousingData];

-- Standardize Date Format

select SaleDate, CONVERT(date, SaleDate)
from [dbo].[HousingData];

alter table [dbo].[HousingData]
add SaleDateConverted Date;

update [dbo].[HousingData]
set SaleDateConverted =  CONVERT(date, SaleDate);

-- Populate Property Address data

Select *
From [dbo].[HousingData]
where PropertyAddress is null
order by ParcelID;

--checking for repeated ParcelID
--Populate NULL PropertyAddress values by matching records with the same ParcelID, as each ParcelID has a consistent PropertyAddress.
select 
ParcelID, count(*) as ParcelIDCount
from [dbo].[HousingData]
group by ParcelID
having count(*) > 1;

select ParcelID, PropertyAddress
from [dbo].[HousingData]
where ParcelID in 
(
	select ParcelID
	from [dbo].[HousingData]
	group by ParcelID
	having count(*) > 1
)
order by ParcelID;


select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].[HousingData] a
join [dbo].[HousingData] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null	;

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].[HousingData] a
join [dbo].[HousingData] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null	;


-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from [dbo].[HousingData]
--where PropertyAddress is null
order by ParcelID;


select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as City
from [dbo].[HousingData];

alter table [dbo].[HousingData]
add PropertySplitAddress nvarchar(255);

update [dbo].[HousingData]
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

alter table [dbo].[HousingData]
add PropertySplitCity nvarchar(255);

update [dbo].[HousingData]
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress));

select *
from [dbo].[HousingData];

--an alternative method where you can split a column by delimeter using PARSENAME() and REPLACE() function
select 
PARSENAME(replace(PropertyAddress, ',', '.'), 2) as PropertySplitAddress,
PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1) as PropertySplitCity
from [dbo].[HousingData];


alter table [dbo].[HousingData]
add OwnerSplitAddress nvarchar(255);

update [dbo].[HousingData]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

alter table [dbo].[HousingData]
add OwnerSplitCity nvarchar(255);

update [dbo].[HousingData]
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2);

alter table [dbo].[HousingData]
add OwnerSplitState nvarchar(255);

update [dbo].[HousingData]
set OwnerSplitState = parsename(replace((OwnerAddress), ',', '.'), 1);


-- Change Y and N to Yes and No in "Sold as Vacant" field

select 
distinct([SoldAsVacant]), count([SoldAsVacant])
from [dbo].[HousingData]
group by [SoldAsVacant]
order by 2;

select 
[SoldAsVacant],
case when [SoldAsVacant] = 'Y' then 'Yes' 
	 when [SoldAsVacant] = 'N' then 'No'
	 else [SoldAsVacant]
end 
from [dbo].[HousingData];

update [dbo].[HousingData]
set [SoldAsVacant] = case when [SoldAsVacant] = 'Y' then 'Yes' 
	                      when [SoldAsVacant] = 'N' then 'No'
	                      else [SoldAsVacant]
                     end ;

-- Remove Duplicates

with row_numCTE as
	(
select *,
ROW_NUMBER() over (partition by [ParcelID], [PropertyAddress], [SaleDate], [SalePrice], [LegalReference] , [OwnerName]   order by [UniqueID ]) as row_num
from [dbo].[HousingData]
	)

Delete 
from row_numCTE
where row_num > 1


-- Delete Unused Columns

Select *
From [dbo].[HousingData]


ALTER TABLE [dbo].[HousingData]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
