
# README: Healthcare Data Analysis with SAS

## Overview

This repository contains two SAS scripts for loading and analyzing healthcare data stored in Azure Blob Storage.

## Prerequisites

- **SAS Software**: Installed and configured.
- **Azure Blob Storage Access**: A valid SAS token.
- **Data File**: `Hospital_Data.csv` in Azure Blob Storage.
- **Directory Access**: Permissions to read/write in a specified directory.

## File Descriptions

### 1. `load_data.sas`

- **Purpose**: Reads the dataset from Azure Blob Storage, renames columns, and optionally saves the dataset.
- **Instructions**:
  1. Update the `filename` with your Azure Blob Storage URL and SAS token.
  2. Update the `libname` path for saving the dataset.
  3. Run the script in SAS.
  4. Verify the first 10 observations in the output.

### 2. `data_analysis.sas`

- **Purpose**: Performs data analysis on the loaded dataset, including categorizing, averaging, and identifying key metrics.
- **Instructions**:
  1. Ensure `load_data.sas` has been run.
  2. Update paths or references if needed.
  3. Run the script in SAS.
  4. Review the outputs for insights.

## Important Notes

- **SAS Token**: Ensure it’s valid; update if expired.
- **Directory Permissions**: Check read/write access.
- **SAS Environment**: Ensure all necessary libraries are available.

## Conclusion

These scripts allow you to load and analyze healthcare data from Azure Blob Storage using SAS. Follow the steps to gain insights from your dataset.
