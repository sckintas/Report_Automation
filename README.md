# README

## Purpose
This script processes and analyzes raw data, extracts insights, and generates reports in Excel format using SQL Server functionalities. The script performs tasks such as:

1. Fetching data from remote databases using `OPENDATASOURCE`.
2. Processing data to calculate metrics like time differences and pour counts.
3. Writing processed data into structured Excel reports.

## Prerequisites

1. **SQL Server Configuration**:
   - Ensure that `xp_cmdshell` is enabled.
   - Configure `OPENDATASOURCE` to allow remote connections.
   - Set up the linked server login credentials with the `sp_addlinkedsrvlogin` command.

2. **Excel Driver**:
   - Install the `Microsoft.ACE.OLEDB.12.0` provider to enable writing data to Excel files.

3. **File Directories**:
   - Ensure the `@datadirectory` path is correctly set and accessible.
   - Provide a valid path for the `@filepath` variable to store the resulting Excel files.

## Configuration

### Remote Connection Setup
Run the following commands on the remote computer:

```sql
-- Enable remote server login
EXEC sp_addlinkedsrvlogin 'SERVER_NAME', 'FALSE', NULL, 'USER_NAME', 'PASSWORD';

-- Enable `OPENDATASOURCE` and configure options
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ad Hoc Distributed Queries', 1;
GO
RECONFIGURE;
GO
```

### Script Variables

- **`@datadirectory`**: Define the directory path containing the data files.
- **`@StartTime` and `@EndTime`**: Specify the time range for data extraction.
- **`@TimeAdded`**: Adjusts time zones, default set to `-6`.

### Temporary Tables
The script uses several temporary tables to store and process data, including:

- `@TEMPDATA_PC`: Stores initial raw data.
- `@TEMPDATA_IO`: Stores input-output events.
- `@TEMPDATAPOUR1`, `@TEMPDATAPOUR2`: Tracks pour-on and pour-off events.

## Script Execution

### Steps

1. **Initialize Temporary Tables**:
   Temporary tables are declared to store intermediate data.

2. **Fetch Data**:
   - Use `OPENDATASOURCE` to fetch data from the remote database.
   - Load data into the temporary tables for processing.

3. **Process Data**:
   - Calculate metrics like time differences, pour counts, and arrival intervals.
   - Use loops and conditional checks to process data rows iteratively.

4. **Export Data to Excel**:
   - Use `OPENROWSET` to export processed data into structured Excel files.
   - Append additional metadata like timestamps and filenames.

### Running the Script

- Load the script in your SQL Server Management Studio (SSMS).
- Set the necessary variables such as `@datadirectory` and `@StartTime`.
- Execute the script.

## Output

The script generates multiple Excel files as output, including:

- `4410$`, `4420$`, `4430$`, `4450$`, `4469$`: Contain processed tracking data.
- `Melts@...$`: Detailed melt-related records.
- `EXTRALINE_...$`: Extra line-specific details.

The files are saved in the directory specified by the `@filepath` variable.

## Troubleshooting

1. **Error with `OPENDATASOURCE`**:
   - Ensure the remote server is accessible and credentials are correct.

2. **Excel Export Issues**:
   - Verify that the `Microsoft.ACE.OLEDB.12.0` provider is installed.
   - Ensure the target directory for Excel files exists and is writable.

3. **Performance Issues**:
   - Increase `WAITFOR DELAY` values if the remote server is slow.
   - Optimize the `WHERE` clauses for large datasets.

## Notes
- This script assumes familiarity with SQL Server, temporary tables, and Excel export functionalities.
- Adjust the hardcoded conditions and filters (e.g., `MESSAGE` values) to fit your specific use case.

---


