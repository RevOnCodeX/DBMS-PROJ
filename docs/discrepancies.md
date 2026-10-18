# Source Inconsistencies and Discrepancy Reconciliation Report

This document records all discrepancies identified between the **Handwritten Entity Inventory**, **ER Diagram**, **Handwritten SQL Table Definitions (`dbms da-2.pdf`)**, and the **Executed Oracle SQL*Plus Database Screenshots (`Dbms DA2 ques 2 screenshots.pdf`)**.

Per project requirements, no missing data has been silently invented, nor were rows deleted or identifiers altered. All discrepancies are transparently documented with their source evidence and rationale for the Neo4j graph implementation.

---

## 1. Charging Schedule Identifier vs Composite Foreign Key

- **Entity / Relationship Involved:** `Charging_Schedule`, `(:Charging_Station)-[:PROVIDES]->(:Charging_Schedule)`, `(:Drone)-[:SCHEDULED]->(:Charging_Schedule)`
- **Handwritten Entity Inventory:** Mentions `Schedule_ID` as a distinct primary key alongside `Station_ID`, `Drone_ID`, `Schedule_Date`, `Start_Time`, `End_Time`, `Charging_Status`.
- **ER Diagram:** Connects `Drone` to `Charging_Schedule` via `SCHEDULED` (1:N) and `Charging_Station` to `Charging_Schedule` via `PROVIDES` (1:N).
- **Handwritten SQL Definition (Page 2, Item 13):**
  ```sql
  Create table Charging-Schedule (
    Station-ID Number references Charging station(Station-ID),
    Drone-ID Number references drone(drone-ID),
    Charging-Status,
    Primary key (Station-ID, Drone-ID, Schedule-ID)
  );
  ```
  *(Note: `Schedule-ID` is included in the composite primary key syntax, but not listed in the initial column list).*
- **Handwritten Sample Inserts (Page 4, Item 13):**
  Contained 5 lines starting with `(901, 201, '20-03-2026', '9:00', '11:00', 'Completed')` through `(905, 205, ...)`. In this handwritten draft, the first column incremented sequentially from 901 to 905, but there is no station 905 in `Charging_Station` (only 901–904 exist).
- **Executed Oracle SQL Terminal (Screenshot Page 2 & Page 4):**
  - Schema definition in Oracle:
    - `STATION_ID NOT NULL NUMBER`
    - `DRONE_ID NOT NULL NUMBER`
    - `SCHEDULE_DATE NOT NULL DATE`
    - `START_TIME VARCHAR2(10)`
    - `END_TIME VARCHAR2(10)`
    - `CHARGING_STATUS VARCHAR2(20)`
    - Composite Primary Key: `(STATION_ID, DRONE_ID, SCHEDULE_DATE)`
  - Query output (`SELECT * FROM CHARGING_SCHEDULE;`):
    - `901 | 201 | 21-MAR-26 | 09:00 | 11:00 | COMPLETED`
    - `901 | 202 | 21-MAR-26 | 11:00 | 13:00 | SCHEDULED`
    - `902 | 203 | 21-MAR-26 | 10:00 | 12:00 | COMPLETED`
    - `903 | 204 | 21-MAR-26 | 14:00 | 16:00 | SCHEDULED`
    - `904 | 205 | 21-MAR-26 | 09:00 | 11:00 | COMPLETED`
- **Neo4j Implementation Interpretation:**
  The executed database proves that the first column is indeed `STATION_ID`, which accurately references existing Charging Stations: Station 901 (Chennai) hosts Drones 201 and 202 at different time slots, Station 902 (Bengaluru) hosts Drone 203, Station 903 (Hyderabad) hosts Drone 204, and Station 904 (Coimbatore) hosts Drone 205.
  To satisfy the graph requirement for a stable node identifier and Neo4j uniqueness constraint (`REQUIRE csch.Schedule_ID IS UNIQUE`), each node is assigned a unique `Schedule_ID` (1 through 5), while retaining `Draft_ID` (901–905), `Station_ID`, and `Drone_ID`. Neo4j relationships `(:Charging_Station)-[:PROVIDES]->(:Charging_Schedule)` and `(:Drone)-[:SCHEDULED]->(:Charging_Schedule)` are cleanly formed.
- **Uncertain / Missing Values:** None. The composite keys and station mappings are 100% verified from the database run.

---

## 2. Flight Permission: Permission_ID vs Mission_ID and Column Mappings

- **Entity / Relationship Involved:** `Flight_Permission`, `(:Mission)-[:REQUIRES]->(:Flight_Permission)`, `(:Drone)-[:HAS_FLIGHT_PERMISSION]->(:Flight_Permission)`
- **Handwritten Entity Inventory:** Lists attributes as `Permit_No`, `Mission_ID`, `Authority_Name`, `Approval_Status`, `Expiry_Date`. In some early notes, `Mission_ID` was considered as the primary key.
- **ER Diagram:** Depicts a 1:1 relationship between `Mission` and `Flight_Permission` via `REQUIRES`.
- **Handwritten SQL Definition (Page 2, Item 15):**
  Defines `permission-ID Number primary key`, `Drone-ID references Drone`, `Mission-ID references Mission`, `Expiry-date date`, `Permission-status`, `Issuing Authority`.
- **Handwritten Sample Inserts (Page 5):**
  Contained draft tuples with ambiguous second columns (`1101, 201...`, `1102, 301...`, `1103, 302...`, mixing Drone and Operator IDs).
- **Executed Oracle SQL Terminal (Screenshot Page 2 & Page 4):**
  - Confirms schema: `PERMISSION_ID` (PK), `DRONE_ID`, `MISSION_ID`, `ISSUED_DATE`, `EXPIRY_DATE`, `PERMISSION_STATUS`, `ISSUING_AUTHORITY`.
  - Executed data (`SELECT * FROM FLIGHT_PERMISSION;`):
    - `1101 | 201 | 601 | 25-JAN-26 | 31-DEC-26 | APPROVED | DGCA`
    - `1102 | 202 | 603 | 25-JAN-26 | 31-DEC-26 | APPROVED | DGCA`
    - `1103 | 203 | 605 | 25-JAN-26 | 31-DEC-26 | APPROVED | DGCA`
    - `1104 | 204 | 608 | 25-JAN-26 | 31-DEC-26 | APPROVED | DGCA`
    - `1105 | 205 | 609 | 25-JAN-26 | 31-DEC-26 | APPROVED | DGCA`
    - `1106 | 206 | 612 | 25-JAN-26 | 31-DEC-26 | APPROVED | DGCA`
- **Neo4j Implementation Interpretation:**
  `Permission_ID` is used as the unique primary identifier with a uniqueness constraint. The node maintains relationships to both the Drone (`(:Drone)-[:HAS_FLIGHT_PERMISSION]->(:Flight_Permission)`) and the Mission (`(:Mission)-[:REQUIRES]->(:Flight_Permission)`).
  Only 6 of the 12 missions have permissions (missions 601, 603, 605, 608, 609, 612), while missions 602, 604, 606, 607, 610, 611 do not. As required, no artificial permissions were fabricated for the remaining missions.
- **Uncertain / Missing Values:** None. Verified against terminal output.

---

## 3. Technician Entity and Maintenance Assignment

- **Entity / Relationship Involved:** `Technician`, `(:Technician)-[:PERFORMS]->(:Maintenance)`
- **Handwritten Entity Inventory & ER Diagram:**
  - Entity inventory mentions: `Technician_ID`, `Technician_Name`, `Qualification`, `Contact_No`, `Email`.
  - ER diagram shows relationship: `(:Technician)-[:PERFORMS]->(:Maintenance)` (1:N).
- **Handwritten SQL Definition & Inserts (`dbms da-2.pdf`):**
  - Page 1 & 2: No `CREATE TABLE Technician` statement was written.
  - Page 4: `Maintenance` table definition includes `Maintenance-ID`, `Drone-ID`, `Maintenance-type`, `Maintenance-description`. No `Technician_ID` column was declared.
- **Executed Oracle SQL Terminal (`Dbms DA2 ques 2 screenshots.pdf`):**
  - No `DESC TECHNICIAN;` or `SELECT * FROM TECHNICIAN;` exists in the Oracle execution.
- **Neo4j Implementation Interpretation:**
  As strictly mandated by the assignment guidelines ("If no Technician inserts exist, create the entity schema and constraints without fabricating sample people. Record that Technician sample data was not provided or could not be verified"):
  1. Uniqueness constraint `technician_id_unique` is created on `(:Technician {Technician_ID})`.
  2. The schema and Cypher query template are provided in `15_create_technicians.cypher`.
  3. Zero fabricated technician records were inserted into the database.
- **Uncertain / Missing Values:** Sample technician personal data was omitted in the source assignment.

---

## 4. Maintenance Record 803 Target Drone and Status

- **Entity / Relationship Involved:** `Maintenance` record 803, `(:Drone)-[:UNDERGOES]->(:Maintenance)`
- **Handwritten Draft (Page 4):**
  `Insert into Maintenance values (803, 203, 'Motor Repair', '06-01-2026', 'COMPLETED', 'Replacement')`
- **Executed Oracle SQL Terminal (Screenshot Page 4):**
  `803 | 204 | Motor Repair | 02-MAR-26 | IN_PROGRESS | Motor replacement`
- **Neo4j Implementation Interpretation:**
  The executed database version is preserved: Maintenance 803 is linked to Drone 204 with status `IN_PROGRESS`. This correlates with Drone 204's `Operational_Status` being `'MAINTENANCE'` (in `DRONE` table) and explains why Validation Query 6 and Demonstration Query 14 correctly flag Drone 204 as undergoing active maintenance.
- **Uncertain / Missing Values:** Resolved by executed database verification.

---

## 5. Battery Records Count and Drone 206 Battery Status

- **Entity / Relationship Involved:** `Battery`, `(:Drone)-[:HAS_BATTERY_RECORD]->(:Battery)`
- **Handwritten Draft (Page 4):**
  Contained 5 records (701 to 705) for drones 201 to 205. Drone 206 was missing a battery record on the handwritten page.
- **Executed Oracle SQL Terminal (Screenshot Page 4):**
  Contains 6 rows (`SELECT * FROM BATTERY;`):
  - Row 6: `706 | 206 | Lithium | 80 | 15 | CRITICAL | 20-MAR-26`
- **Neo4j Implementation Interpretation:**
  All 6 Battery nodes (701–706) are implemented and linked to their respective Drones (201–206). Drone 206 has a critical battery level (15%), which is verified in Validation Query 5 and Demonstration Query 5.
- **Uncertain / Missing Values:** Resolved completely.

---

## 6. Drone 202 Model and Manufacture Date

- **Entity / Relationship Involved:** `Drone` record 202
- **Handwritten Draft (Page 3):**
  Written as `(202, DJI, 101, 15, 120, 'ACTIVE', 'Auto', '2024-03-10')`
- **Executed Oracle SQL Terminal (Screenshot Page 3):**
  `202 | DJI M350 | 101 | 15 | 120 | ACTIVE | Autonomous | 15-MAR-24`
- **Neo4j Implementation Interpretation:**
  The precise model `DJI M350` and manufacture date `2024-03-15` from the verified database execution are preserved.
- **Uncertain / Missing Values:** Resolved.

---

## 7. Operator Contact Numbers & AI Operator Specialization

- **Entity / Relationship Involved:** `Operator`, `Human_Pilot`, `AI_Operator`
- **Handwritten Draft (Page 3):**
  Phone numbers had 9 digits (`984513634`, `963125321`, `701323612`, `701383653`).
- **Executed Oracle SQL Terminal (Screenshot Page 3):**
  Full 10-digit telephone numbers were used: `9876543210` to `9876543214`.
  Operator emails for AI systems are `ai01@drone.com` and `ai02@drone.com`.
- **Neo4j Implementation Interpretation:**
  Stored as strings `9876543210`..`9876543214` to preserve format without leading zero truncation.
  Specialized profiles `Human_Pilot` (for 301, 302, 303) and `AI_Operator` (for 304, 305) are maintained as separate node labels and connected to `Operator` nodes via `HAS_HUMAN_PILOT_PROFILE` and `HAS_AI_OPERATOR_PROFILE` relationships without merging or loss of identity.

---

## 8. GPS Route Estimated Time

- **Entity / Relationship Involved:** `GPS_Route`
- **ER Diagram:** Included an attribute `Estimated_Time`.
- **Handwritten SQL & Terminal Execution:** Neither the SQL table definitions nor the insert statements contained an `Estimated_Time` column.
- **Neo4j Implementation Interpretation:**
  Per prompt instructions ("Do not invent estimated travel times"), `Estimated_Time` is not fabricated. The node retains `Route_ID`, `Route_Name`, `Start_Location`, `End_Location`, `Route_Distance`, and `Route_Status`.
- **Uncertain / Missing Values:** Value omitted in source relational schema.
