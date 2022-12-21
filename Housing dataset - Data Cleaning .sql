/*

Cleaning Data using SQL queries


Functions Used => Convert, ISNULL(), JOIN, SUBSTRING, CHARINDEX, PARSENAME, REPLACE, CASE statement, CTE, ROW_NUMBER, PARTITION BY, ORDER BY, DROP statements


My General Approach (For reference look at the commented sections for queries 2,3,5)
	1. Print out the whole dataset to look at columns
	2. Once identified what needs to be edited, write a simple query and see it as an output
	3. Once 100% sure with the result, then Alter the table


*/

Select *
From PortfolioProject..NashvilleHousingDataCleaning

----------------------------------------------------------------------------------------------------------------

-- 1. standardizing Sale Date format - Using Convert
	-- it's in date time format

Select SaleDateConverted, CONVERT(Date,SaleDate) as date
From PortfolioProject..NashvilleHousingDataCleaning

ALTER TABLE NashvilleHousingDataCleaning
ADD SaleDateConverted Date;

Update NashvilleHousingDataCleaning
SET saleDateConverted = CONVERT(Date,SaleDate)



----------------------------------------------------------------------------------------------------------------

-- 2. Populate NULL property address data - Using ISNULL(), JOIN

	-- Dataset has a replicated parcelID, with sometimes property address as NULL
	-- So we use parcelID as a point of reference to populate the PropertyAddress
	-- Dataset also has uniqueID, which are truly unique


-- First I found the correct rows to populate 

	--Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
	--From PortfolioProject..NashvilleHousingDataCleaning a

	--JOIN PortfolioProject..NashvilleHousingDataCleaning b
	--	on a.ParcelID = b.ParcelID	
	--	AND a.[UniqueID ]<>b.[UniqueID ] 
	--where a.PropertyAddress is null -- literally shows the rows we want to update



-- Now updating the required table 
	-- using the query we created above

update a-- While using Update with Join, use the table's alias name to prevent query from thrwoing error
SET PropertyAddress = ISNULL (a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousingDataCleaning a
JOIN PortfolioProject..NashvilleHousingDataCleaning b
	on a.ParcelID = b.ParcelID	-- we want rows with same parcelID's, cause they are for same house address
	AND a.[UniqueID ]<>b.[UniqueID ] -- This is to prevent getting rows with same UniqueID
where a.PropertyAddress is null



----------------------------------------------------------------------------------------------------------------

-- 3. Breaking Property Address into individual columns (address, City, State) - Using SUBSTRING, CHARINDEX

	-- Basically split the string/address with comma, and store it into a new column (like Split and store in C#)


--Dealing with Property Address column first - Using Substring

-- First we find an appropriate way to split stuff
	--SELECT
	--SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
	--SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
	--From PortfolioProject..NashvilleHousingDataCleaning

-- Add a column for Address
ALTER TABLE NashvilleHousingDataCleaning
ADD PropertySplitAddress NvarChar(255);

-- Add a column for City
ALTER TABLE NashvilleHousingDataCleaning
ADD PropertySplitCity NvarChar(255);


-- Then using previous query populate that column
Update NashvilleHousingDataCleaning
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

-- Then using previous query populate that column
Update NashvilleHousingDataCleaning
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



----------------------------------------------------------------------------------------------------------------

-- 4. Updating Owner Address - Using PARSENAME,REPLACE
	--Remember => PARSENAME only replaces '.'

Select OwnerAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),3) 
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject..NashvilleHousingDataCleaning


-- Add a column for OwnerAddress
ALTER TABLE NashvilleHousingDataCleaning
ADD OwnerSplitAddress NvarChar(255);

-- Add a column for OwnerCity
ALTER TABLE NashvilleHousingDataCleaning
ADD OwnerSplitCity NvarChar(255);

-- Add a column for OwnerState
ALTER TABLE NashvilleHousingDataCleaning
ADD OwnerSplitState NvarChar(255);


-- Then using previous query populate OwnerSplitAddress
Update NashvilleHousingDataCleaning
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 

-- Then using previous query populate OwnerSplitCity
Update NashvilleHousingDataCleaning
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

-- Then using previous query populate OwnerSplitState
Update NashvilleHousingDataCleaning
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)




----------------------------------------------------------------------------------------------------------------

-- 5. Change Y and N to Yes and No in "sold as Vacant" column - Using CASE statement

-- Find all the occurences, was just curious to see a total number
Select Distinct SoldAsVacant, Count ( SoldAsVacant)
From PortfolioProject..NashvilleHousingDataCleaning
Group by SoldAsVacant
Order by 2


-- Basic case statements worked out perfectly, therefore adding them to update
	--Select SoldAsVacant
	--, Case When SoldAsVacant = 'Y' THEN 'YES'
	--	   When SoldAsVacant ='N' THEN 'No'
	--	   Else SoldAsVacant
	--	End

	--From PortfolioProject..NashvilleHousingDataCleaning


-- Copied previous query to update the column

Update NashvilleHousingDataCleaning
SET SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'YES'
					When SoldAsVacant ='N' THEN 'No'
					Else SoldAsVacant
				   End



----------------------------------------------------------------------------------------------------------------

-- 6. Remove Duplicates -  Uses CTE, ROW_NUMBER, PARTITION BY, ORDER BY
	
	-- BEST PRACTISE -> Don't do it to Raw data, do it with your own copy

	-- First partiton by seperates everything, then sorts it by UniqueID, and then adds row_num, while resetting when there's a change
	-- In our case since we are finding duplicates, we will delete the one with row_num greater than 1, because that means the same entry
		-- depending on what we partitioned (comparing against) is already in the database

With RowNumCTE AS(
Select *
	,Row_NUMBER() OVER 
	(
		Partition By ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
						UniqueID
	) row_num

From PortfolioProject..NashvilleHousingDataCleaning
)
Select*
From RowNumCTE
Where row_num>1



----------------------------------------------------------------------------------------------------------------


-- 7. Delete Unused/Unwanted Columns - DROP statements

	--BEST PRACTISE -> Don't do it to Raw data, do it with your own copy


Select*
From PortfolioProject..NashvilleHousingDataCleaning 

Alter Table PortfolioProject..NashvilleHousingDataCleaning
DROP COLUMN PropertyAddress, OwnerAddress

Alter Table PortfolioProject..NashvilleHousingDataCleaning
DROP COLUMN SaleDate
