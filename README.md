# Uber Data Analysis Dashboard - SQL, MariaDB and Power BI

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-Analysis-336791?style=for-the-badge)
![MariaDB](https://img.shields.io/badge/MariaDB-Local%20Database-003545?style=for-the-badge&logo=mariadb)
![Status](https://img.shields.io/badge/Status-Portfolio%20Project-success?style=for-the-badge)

## Project Summary

This project analyzes Uber-style ride booking data using SQL, MariaDB/MySQL and Power BI. The dashboard follows the full ride-booking journey: user searches, fare estimates, quote requests, received quotes, OTP entry and completed rides.

The final Power BI report contains multiple analysis pages covering executive KPIs, booking funnel performance, Berlin location analysis, driver performance, and payment/fare behavior.

## Dashboard Screenshots

### Overview

![Overview Dashboard](screenshots/overview.png)

The overview page summarizes the main business KPIs: completed trips, searches, fare estimates, quotes, driver earnings, conversion rate, and trip/fare trends by duration.

### Booking Funnel

![Booking Funnel Dashboard](screenshots/booking-funnel.png)

The booking funnel page explains how users move through the ride-booking journey from search to quote request, OTP entry, and completed trip.
It includes requested quotes, conversion percentage, an assembly slicer, and a funnel-style comparison of searches, completed trips, and OTP-entered rides.

### Location Analysis

![Location Analysis Dashboard](screenshots/location-analysis.png)

The location analysis page compares Berlin pickup areas, location-level searches, quote requests, estimates, received quotes, distance, total fare, conversion rate, and geocoded map points.
It highlights the top Berlin locations in a bar chart, shows detailed location metrics in a table, and plots the areas on the Berlin map.

### Driver's Performance

![Driver Performance Dashboard](screenshots/driver-performance.png)

The driver performance page highlights top drivers by total fare and summarizes total trips, driver earnings, average fare, and average distance.
It includes a driver slicer, KPI cards, and a driver performance bar chart ranked by fare.

### Payment and Fare Analysis

![Payment and Fare Analysis Dashboard](screenshots/payment-fare-analysis.png)

The payment and fare page shows trip and revenue distribution by payment method, including Credit Card, Debit Card, Bank Transfer, and Cash.
It includes payment-method filtering, total trips, driver earnings, average fare, max fare, a payment distribution donut chart, and a payment summary table.

## Report Pages

| Page | Purpose |
| --- | --- |
| `Overview` | Executive dashboard with searches, completed trips, driver earnings, conversion rate, trend charts, table and Berlin map |
| `Booking Funnel` | Shows how users move through search, estimate, quote, OTP and completed trip stages |
| `Location Analysis` | Compares Berlin pickup/location performance and shows geocoded map points |
| `Driver's Performance` | Ranks drivers by trips, fare, average fare, distance and performance metrics |
| `Payment and Fare Analysis` | Breaks down trips and revenue by payment method, fare and distance |

## Key Metrics

| Metric | Value |
| --- | ---: |
| Search / funnel records | 2,161 |
| Completed trips | 983 |
| Estimates generated | 1,758 |
| Quote requests | 1,455 |
| Quotes received | 1,277 |
| OTP entered | 983 |
| Total driver earnings | 751,343 |
| Average fare | 764.34 |
| Highest fare | 1,500 |
| Total distance | 14,148 km |
| Average distance | 14.39 km |
| Overall conversion rate | 45.49% |
| Active drivers | 30 |
| Active customers | 99 |
| Berlin locations | 37 |

## Business Questions Answered

- How many searches convert into completed trips?
- Where do users drop off in the booking funnel?
- Which Berlin areas generate the highest trip demand?
- Which drivers produce the most revenue?
- Which payment methods are used most often?
- How do fare and distance behave across completed trips?
- What are the highest-performing pickup locations and drivers?

## Main Insights

- The dashboard tracks 2,161 search records and 983 completed trips.
- Overall search-to-completed-trip conversion is 45.49%.
- Total driver earnings are 751,343, with an average fare of 764.34.
- Top pickup locations include Nikolassee, Treptow, Wedding, Schoneberg and Marzahn.
- Driver 12 is the top revenue-generating driver with 36,787 across 46 trips.
- Payment labels were standardized as Credit Card, Debit Card, Bank Transfer and Cash.
- Location labels were updated to explicit Berlin/Germany values for accurate Power BI map geocoding.

## Dataset

| File | Rows | Description |
| --- | ---: | --- |
| `trip_details.csv` | 2,161 | Booking funnel table with searches, estimates, quotes, cancellations, OTP entry and ride completion |
| `trips.csv` | 983 | Completed trip table with fare, distance, duration, driver, customer and location IDs |
| `assembly.csv` | 37 | Berlin location lookup using labels like `Mitte, Berlin, Germany` |
| `duration.csv` | 24 | Hourly duration/time bucket lookup |
| `payment.csv` | 4 | Payment lookup: Credit Card, Debit Card, Bank Transfer and Cash |
| `uber_database.db` | - | SQLite database version |
| `uber dashboard.pbix` | - | Power BI report file |

## Data Model

Recommended relationships in Power BI:

```text
assembly[ID]      -> trips[loc_from]
assembly[ID]      -> trip_details[loc_from]
payment[id]       -> trips[faremethod]
duration[id]      -> trips[duration]
trip_details[tripid] -> trips[tripid]
```

If a relationship cannot be created for payment method, the report can use a calculated column in `trips`:

```DAX
Payment Method =
SWITCH(
    'uber_database trips'[faremethod],
    1, "Credit Card",
    2, "Debit Card",
    3, "Bank Transfer",
    4, "Cash",
    "Unknown"
)
```

## Core DAX Measures

```DAX
Total Searches =
SUM('uber_database trip_details'[searches])

Completed Trips =
SUM('uber_database trip_details'[end_ride])

Conversion Rate =
DIVIDE([Completed Trips], [Total Searches], 0)

Total Trips =
COUNTROWS('uber_database trips')

Total Fare =
SUM('uber_database trips'[fare])

Average Fare =
AVERAGE('uber_database trips'[fare])

Average Distance =
AVERAGE('uber_database trips'[distance])

Max Fare =
MAX('uber_database trips'[fare])
```

Funnel stage measure:

```DAX
Funnel Value =
SWITCH(
    SELECTEDVALUE('Funnel Stages'[Stage]),
    "Searches", SUM('uber_database trip_details'[searches]),
    "Estimates", SUM('uber_database trip_details'[searches_got_estimate]),
    "Quote Requests", SUM('uber_database trip_details'[searches_for_quotes]),
    "Quotes Received", SUM('uber_database trip_details'[searches_got_quotes]),
    "OTP Entered", SUM('uber_database trip_details'[otp_entered]),
    "Completed Trips", SUM('uber_database trip_details'[end_ride])
)
```

## SQL Analysis

The SQL scripts cover:

- Overview KPIs
- Booking funnel counts
- Conversion rates
- Cancellation analysis
- Payment-method performance
- Driver ranking
- Berlin location analysis
- Fare, distance and duration analysis

Important SQL files:

| File | Purpose |
| --- | --- |
| `setup_mysql_database.sql` | Creates the MariaDB/MySQL database and imports all CSV files |
| `Uber Data Analysis Project By Using SQL and Power BI.sql` | MySQL analysis queries |
| `run_analysis.sql` | SQLite-compatible analysis script |
| `update_assembly_germany.sql` | Updates location labels to Berlin/Germany values |

## Local Database Setup

The project is configured to run with a local MariaDB server.

Connection details:

```text
Server: 127.0.0.1:3306
Database: uber_database
User: root
Password: root
```

Power Query connection example:

```powerquery
let
    Source = MySQL.Database("127.0.0.1:3306", "uber_database", [ReturnSingleDatabase=true]),
    trips = Source{[Schema="uber_database", Item="trips"]}[Data]
in
    trips
```

To start MariaDB after restarting the PC:

```powershell
powershell -ExecutionPolicy Bypass -File ".\start_mariadb.ps1"
```

To stop MariaDB:

```powershell
powershell -ExecutionPolicy Bypass -File ".\stop_mariadb.ps1"
```

To recreate the database from CSV files:

```sql
source setup_mysql_database.sql
```

## How To Open The Dashboard

1. Start MariaDB using `start_mariadb.ps1`.
2. Open `uber dashboard.pbix` in Power BI Desktop.
3. Refresh the report.
4. Use these credentials if prompted:

```text
User: root
Password: root
```

5. Navigate through the report pages:

```text
Overview
Booking Funnel
Location Analysis
Driver's Performance
Payment and Fare Analysis
```

## Project Structure

```text
.
|-- README.md
|-- screenshots/
|   |-- overview.png
|   |-- booking-funnel.png
|   |-- location-analysis.png
|   |-- driver-performance.png
|   `-- payment-fare-analysis.png
|-- uber dashboard.pbix
|-- uber dashboard.PNG
|-- trips.csv
|-- trip_details.csv
|-- assembly.csv
|-- duration.csv
|-- payment.csv
|-- uber_database.db
|-- setup_mysql_database.sql
|-- run_analysis.sql
|-- Uber Data Analysis Project By Using SQL and Power BI.sql
|-- update_assembly_germany.sql
|-- start_mariadb.ps1
`-- stop_mariadb.ps1
```

## Included Screenshots

The repository includes exported screenshots for each Power BI report page:

```text
screenshots/overview.png
screenshots/booking-funnel.png
screenshots/location-analysis.png
screenshots/driver-performance.png
screenshots/payment-fare-analysis.png
```

These screenshots are displayed in the Dashboard Screenshots section above.

## Tools Used

- Power BI Desktop
- MariaDB / MySQL connector
- SQL
- DAX
- Power Query
- CSV data modeling
- SQLite for portable analysis

## Author

**Arijeet Ghosal**  
Berlin, Germany

This project was created as a business intelligence portfolio project to demonstrate SQL analysis, data modeling, Power BI dashboard design, DAX measures and interactive reporting.
