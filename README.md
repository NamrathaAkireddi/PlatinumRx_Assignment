PlatinumRx Data Analyst Assignment

This repository contains the complete solution for the PlatinumRx Data Analyst Assignment, implemented as per the given requirements.
The project demonstrates skills across SQL, Spreadsheet-based analysis, and Python scripting.

Project Structure

Data_Analyst_Assignment/
│
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql
│   ├── 02_Hotel_Queries.sql
│   ├── 03_Clinic_Schema_Setup.sql
│   └── 04_Clinic_Queries.sql
│
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx
│
├── Python/
│   ├── 01_Time_Converter.py
│   └── 02_Remove_Duplicates.py
│
└── README.md

Phase 1 — SQL

This section covers two systems:

1. Hotel Management System (Part A)

Files:

01_Hotel_Schema_Setup.sql – Table creation and sample inserts

02_Hotel_Queries.sql – Solutions for Questions 1–5

Tables:
users, bookings, items, booking_commercials

Concepts Used:

Joins

Aggregations

Window functions

Grouping and filtering

Ranking (ROW_NUMBER, DENSE_RANK)

Queries Implemented:

Last booked room per user

Total bill amount for bookings in Nov 2021

Bills > 1000 in Oct 2021

Most and least ordered items per month

Second-highest bill per month

2. Clinic Management System (Part B)

Files:

03_Clinic_Schema_Setup.sql

04_Clinic_Queries.sql

Tables:
clinics, customer, clinic_sales, expenses

Queries Implemented:

Revenue by sales channel

Top 10 customers by total spend

Month-wise revenue, expense, profit, and status

Most profitable clinic per city

Second least profitable clinic per state

All queries are written for MySQL 8.0, tested with strict SQL mode enabled (ONLY_FULL_GROUP_BY).

Phase 2 — Spreadsheets (Google Sheets)

File: Ticket_Analysis.xlsx
Sheets: ticket, feedbacks

Key Tasks Completed
1. Lookup created_at into feedbacks sheet

Formula used: =IFERROR(INDEX(ticket!$B:$B, MATCH($A2, ticket!$E:$E, 0)), "")

2. Calculate Same-Day Tickets

Helper column in ticket sheet: =IF(INT(B2)=INT(C2), 1, 0)

3. Calculate Same-Hour Tickets

Helper column: =IF((INT(B2)=INT(C2))*(HOUR(B2)=HOUR(C2)), 1, 0)

4. Outlet-wise counts

Using SUMIFS:
    =SUMIFS(ticket!$F:$F, ticket!$D:$D, outlet_id)
    =SUMIFS(ticket!$G:$G, ticket!$D:$D, outlet_id)

Phase 3 — Python
1. Time Conversion Script

File: 01_Time_Converter.py
Converts user-entered minutes into "X hrs Y minutes".

Enter total minutes: 130
2 hrs 10 minutes

2. Remove Duplicate Characters Script

File: 02_Remove_Duplicates.py
Removes duplicate characters from a user-entered string using only loops.

Enter a string: banana
ban


Both scripts follow assignment instructions and take input directly from the user.

Summary

SQL schemas and queries tested on MySQL Workbench 8.0

Excel formulas tested in both Excel and Google Sheets

Python scripts tested on Python 3.x

