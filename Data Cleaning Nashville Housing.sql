/* Data Cleaning in SQL
by Defika Alviani
dataset: github.com/AlexTheAnalyst/PortfolioProjects
*/

SELECT TOP 100 *
FROM SQLTutorial.dbo.NashvilleHousing


-- Standardize Date Format

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted=CONVERT(Date, SaleDate)

SELECT SaleDateConverted
FROM SQLTutorial.dbo.NashvilleHousing

--Populate property adress data
-- note: setiap parcel ID merepresentasikan unik property adress/ every parcel ID represent unique property adress
SELECT a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM SQLTutorial.dbo.NashvilleHousing a
JOIN SQLTutorial.dbo.NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM SQLTutorial.dbo.NashvilleHousing a
JOIN SQLTutorial.dbo.NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.UniqueID<>b.UniqueID

SELECT *
FROM SQLTutorial..NashvilleHousing
Where PropertyAddress IS NULL

SELECT *
FROM SQLTutorial..NashvilleHousing


--Breaking out adress into individual columns (Adress, City, State)
---we can use SUBSTRING or PARSENAME function
--Property Address
SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
FROM SQLTutorial..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

UPDATE NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM SQLTutorial..NashvilleHousing

--Owner Address
SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM SQLTutorial..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAdress Nvarchar(255),
	OwnerSplitCity Nvarchar(255),
	OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM SQLTutorial..NashvilleHousing


--Change Y & N to Yes & No in "Sold as Vacant" field
SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM SQLTutorial..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant='Y' THEN 'Yes'
		 WHEN SoldAsVacant='N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM SQLTutorial..NashvilleHousing

UPDATE SQLTutorial..NashvilleHousing
SET SoldAsVacant=CASE WHEN SoldAsVacant='Y' THEN 'Yes'
					 WHEN SoldAsVacant='N' THEN 'No'
					 ELSE SoldAsVacant
					 END


--Remove duplicates
WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
						UniqueID
						) row_num
	FROM SQLTutorial..NashvilleHousing)
DELETE
FROM RowNumCTE
WHERE row_num > 1

WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
						UniqueID
						) row_num
	FROM SQLTutorial..NashvilleHousing)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

SELECT *
FROM SQLTutorial..NashvilleHousing


--Delete Unused Column
ALTER TABLE SQLTutorial..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE SQLTutorial..NashvilleHousing
DROP COLUMN SaleDate

SELECT *
FROM SQLTutorial..NashvilleHousing
WHERE [UniqueID ] IS NULL