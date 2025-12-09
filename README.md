<<<<<<< HEAD

# SQL MADA - Emergency Response Database System

## Project Overview
This project implements a comprehensive SQL Server database system for managing emergency response units such as volunteers, events, calls, branches, and vehicle types. The system supports dynamic tracking of responders, automatic transitions between active and inactive status based on certificate validity, response logging, and performance reporting — all with built-in procedures, triggers, views, and functions.

The project was developed as part of an academic final project to demonstrate real-world SQL database design and automation using T-SQL.

## Key Components
Normalized Tables: Responder data, events, vehicle types, branches, calls, response logs, and history tables.

Stored Procedures: Automate transitions of responders based on certificate expiration and recovery.

Triggers: Automatically update system state when responders become valid again.

Views & Functions: Support analytical queries, such as top responders, response times, and upcoming expirations.

Data Integrity: Enforced using foreign keys and controlled logic via procedures.

## Project Structure
 ```bash
SQL-MADA/
├── יצירת המסד-פרויקט איחוד הצלה.sql     # Script for creating tables and defining relationships
├── פרויקט סופי-פרוצדורות.sql           # Script for procedures, triggers, views, and functions
└── README.md                             # This documentation file
```

## Technologies Used
Database: Microsoft SQL Server

Language: T-SQL (Transact-SQL)

Tools: SQL Server Management Studio (SSMS), Git

Techniques: Views, Scalar/Table-valued functions, Cursors, Triggers, Exception handling

## Setup & Running
Open SQL Server Management Studio.

Run יצירת המסד-פרויקט איחוד הצלה.sql to create the database schema.

Run פרויקט סופי-פרוצדורות.sql to add logic (procedures, triggers, etc.).

Populate the tables with data manually or using INSERT statements.

Execute procedures and query views/functions to interact with the system.

## Usage Examples
Track responders with soon-to-expire certificates:

``` bash
SELECT * FROM dbo.tokef()
```

Identify calls with no response:

``` bash
SELECT * FROM dbo.not_in_call()
```
Get the responder with the highest number of responses:

``` bash
PRINT dbo.max_call()
```
Automatically deactivate expired responders:

``` bash
EXEC no_act
```
Reactivate valid responders (triggered by UPDATE):

``` bash
UPDATE no_active SET tokef = DATEADD(YEAR, 1, GETDATE()) WHERE idConan = 123456789
```
## Notes
Data integrity is preserved through foreign keys and stored logic.

The project supports automatic archiving of inactive responders and restoring them upon renewal.

Analytical functions such as average response time per branch and count of hard calls are included.

Fully customizable to fit other emergency services (e.g., fire, medical, police).

## License
This project is intended for educational and academic use only.

=======
# Mada
SQL-Query
>>>>>>> 1a556fa3c800fd06dbdb2657c9d5c4aaa8af0de3
