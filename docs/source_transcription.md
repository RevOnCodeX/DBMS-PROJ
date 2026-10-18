# Source Material Transcription Record

This document contains a line-by-line transcription of the primary source material:
1. **Handwritten Assignment (`dbms da-2.pdf`, Pages 1–5)**
2. **Executed Oracle SQL*Plus Database Screenshots (`Dbms DA2 ques 2 screenshots.pdf`, Pages 1–8)**

---

## Part 1: Handwritten Table Definitions (`dbms da-2.pdf`)

### Page 1
**Title:** DA - 2 (DBMS) | Aakshaj Srivastava | 25BAI1484

1. **Region:**
   `Create a table Region (Region-ID Number primary key, Region-Name Varchar(50), Region-Type Varchar(30), Location Varchar(100));`
2. **Fleet:**
   `Create table fleet (Fleet-ID Number Primary Key, Fleet-Name Varchar(50), Region-ID Number References Region(Region-ID), Fleet-type Varchar(30), Fleet-status Varchar(20));`
3. **Drone:**
   `Create table Drone (Drone-ID Number Primary Key, Drone-Model Varchar(20), Fleet-ID Number references Fleet(Fleet-ID), Payload-capacity Number, Battery-capacity Number, Drone-Type Varchar(20), Manufacture-Date Date);`
4. **Operator:**
   `Create table Operator (Operator-ID Number Primary Key, Licence-no Varchar(20), Certification-Date Date, Certification-Expiry Date, Pilot-Rating Varchar(20));`
5. **Human Pilot:**
   `Create Human-Pilot (Operator-ID Number Primary Key references Operator(Operator-ID), Licence-No Varchar(30), Certification-Expiry Date, Pilot-Rating Varchar(20));`
6. **AI Pilot:**
   `Create table AI-Operator (Operator-ID Number Primary Key references Operator(Operator-Id), AI-Version Varchar(30), Certification-status Varchar(30), Autonomy-level Varchar(30));`
7. **Drone-Operator-Assignment:**
   `Create table Drone-Operator-Assignment (Assignment-ID Number Primary Key, Drone-ID Number References Drone(Drone-ID), Operator-ID Number references Operator(Operator-ID), Assignment Date, Assignment Status Varchar(20), Missiontype Varchar(20));`

### Page 2
8. **GPS-Route:**
   `Create table GPS-Route (Route-ID Number Primary Key, Route-Name Varchar2(60), StartLocation Varchar(100), End-location Varchar2(100), Route-distance Number, Route-status Varchar2(20));`
9. **Mission:**
   `Create table Mission (Mission-ID Number Primary Key, Drone-ID Number references Drone(Drone-ID), Operator-ID Number references Operator(Operator-ID), Route-ID Number references GPS-Route(Route-ID), Mission-objective Varchar2(100), Mission-date Date, Weather Varchar2(100), Payload-Information Varchar2(100), Battery-Usage Number, Mission-status Varchar2(20));`
10. **Battery:**
    `Create Battery (Battery-ID Number primary key, Drone-ID Number references Drone(Drone-ID), Battery-Type Varchar(20), Battery-capacity Number, Current-level Number, Battery-status Varchar(20), Lastupdate Date);`
11. **Maintenance:**
    `Create table Maintenance (Maintenance-ID Number primary key, Drone-ID Number references Drone(Drone-ID), Maintenance-type Varchar(50), Maintenance-description Varchar2(200));`
12. **Charging Station:**
    `Create table Charging-Station (Station-ID Number primary key, Station name Varchar(50), Region-ID Number references Region(Region-ID), Charging-capacity Number, Station-status Varchar(20));`
13. **Charging Schedule:**
    `Create table Charging-Schedule (Station-ID Number references Charging-Station(Station-ID), Drone-ID Number references Drone(Drone-ID), Charging-status Varchar(20), Primary key (Station-ID, Drone-ID, Schedule-ID));`
14. **Emergency Event:**
    `Create table Emergency Event (Emergency-ID Number Primary Key, Drone-ID Number references Drone(Drone-ID), Mission-ID Number references Mission(Mission-ID), Emergency-desc Varchar2(200), Status Varchar2(50));`
15. **Flight-Permission:**
    `Create table Flight-Permission (Permission-ID Number primary key, Drone-ID Number references Drone(Drone-ID), Mission-ID number references Mission(Mission-ID), Expiry-date Date, Permission-status Varchar(20), Issuing Authority Varchar(100));`

---

## Part 2: Handwritten Sample Inserts (`dbms da-2.pdf`)

### Page 3
- **Region:**
  - `(1, 'Chennai', 'Urban', 'Tamil Nadu')`
  - `(2, 'Bangalore', 'Urban', 'Karnataka')`
  - `(3, 'Hyderabad', 'Urban', 'Telengana')`
  - `(4, 'Coimbatore', 'Industrial', 'Tamil Nadu')`
- **Fleet:**
  - `(101, 'Fleet A', 1, 'Delivery', 'Active')`
  - `(102, 'Fleet B', 2, 'Surveillance', 'Active')`
  - `(103, 'Fleet C', 3, 'Agriculture', 'Active')`
  - `(104, 'Fleet D', 4, 'Disaster', 'Active')`
- **Drone:**
  - `(201, 'DJI', 101, 10, 100, 'ACTIVE', 'Semi-Auto', '2024-01-10')`
  - `(202, 'DJI', 101, 15, 120, 'ACTIVE', 'Auto', '2024-03-10')`
  - `(203, 'SYE', 102, 8, 90, 'ACTIVE', 'Auto', '2023-10-10')`
  - `(204, 'Agaras T40', 103, 20, 150, 'ACTIVE', 'Semi-Auto', '2024-01-31')`
  - `(205, 'Parrot Anafi', 104, 5, 80, 'ACTIVE', 'Semi-Auto', '2024-01-24')`
- **Operator:**
  - `(301, 'Rahul', 'Human', '984513634', 'rahul@gmail.com', 'Certified')`
  - `(302, 'Priya', 'Human', '963125321', 'priya@gmail.com', 'Certified')`
  - `(303, 'Arun', 'Human', '701323612', 'arun@gmail.com', 'Certified')`
  - `(304, 'Drone-AI', '701383653', 'ai01@gmail.com', 'Certified')`
- **Human Pilot:**
  - `(301, 'LIC 301', '2024-01-01', '2027-01-01', 'Adv')`
  - `(302, 'LIC 302', '2024-02-01', '2027-02-01', 'Adv')`
  - `(303, 'LIC 303', '2024-03-01', '2027-03-01', 'Expert')`

### Page 4
- **Battery:**
  - `(701, 201, 'Lithium', 100, 80, 'NORMAL', '01-03-2026')`
  - `(702, 202, 'Lithium', 120, 65, 'NORMAL', '03-03-2026')`
  - `(703, 203, 'Lithium', 90, 45, 'NORMAL', '05-03-2026')`
  - `(704, 204, 'Lithium', 150, 25, 'LOW', '30-03-2026')`
  - `(705, 205, 'Lithium', 160, 98, 'FULL', '31-03-2026')`
- **Maintenance:**
  - `(801, 201, 'Sensor Calibration', '03-01-2026', 'COMPLETED', 'Routine calibration')`
  - `(802, 202, 'Battery Check', '04-01-2026', 'COMPLETED', 'Inspection')`
  - `(803, 203, 'Motor Repair', '06-01-2026', 'COMPLETED', 'Replacement')`
  - `(804, 204, 'Firmware Update', '07-01-2026', 'COMPLETED', 'Update')`
  - `(805, 205, 'Sensor Calibration', '10-01-2026', 'COMPLETED', 'Sensor calibration')`
- **Charging Station:**
  - `(901, 'Chennai', 1, 'Chennai', 4, 'AVAILABLE')`
  - `(902, 'Bangalore', 2, 'Bangalore', 3, 'AVAILABLE')`
  - `(903, 'Hyderabad', 3, 'Hyderabad', 4, 'AVAILABLE')`
  - `(904, 'Coimbatore', 4, 'Coimbatore', 2, 'AVAILABLE')`
- **Charging Schedule:**
  - `(901, 201, '20-03-2026', '9:00', '11:00', 'Completed')`
  - `(902, 202, '21-03-2026', '11:00', '12:00', 'Completed')`
  - `(903, 203, '21-03-2026', '12:00', '14:00', 'SCHEDULED')`
  - `(904, 204, '21-03-2026', '14:00', '16:00', 'SCHEDULED')`
  - `(905, 205, '23-03-2026', '16:00', '18:00', 'Completed')`

### Page 5
- **Emergency Event:**
  - `(1001, 203, 606, 'COMMS FAILURE', '2026-02-10', 'Signal lost', 'Resolved')`
  - `(1002, 206, 612, 'EMERGENCY LANDING', '2026-03-13', 'Resolved')`
  - `(1003, 204, 613, 'BATTERY FAILURE', '2026-04-13', 'Resolved')`
- **Flight Permissions:**
  - `(1101, 201, '10-10-2026', '31-12-2026', 'APPROVED', 'DGCA')`
  - `(1102, 301, '12-10-2026', '31-12-2027', 'APPROVED', 'DGCA')`
  - `(1103, 302, '13-12-2026', '31-12-2027', 'APPROVED', 'DGCA')`
  - `(1104, 303, '14-12-2026', '31-12-2027', 'APPROVED', 'DGCA')`
  - `(1105, 304, '16-12-2026', '31-12-2027', 'APPROVED', 'DGCA')`

---

## Part 3: Verified Executed Oracle SQL*Plus Database (`Dbms DA2 ques 2 screenshots.pdf`)

The second document shows the actual executed, error-free database tables:

1. **`DRONE` Table (6 records):**
   - 201: DJI M30, Fleet: 101, Cap: 10/100, ACTIVE, Semi-Autonomous, 10-JAN-24
   - 202: DJI M350, Fleet: 101, Cap: 15/120, ACTIVE, Autonomous, 15-MAR-24
   - 203: Skydio X2, Fleet: 102, Cap: 8/90, ACTIVE, Autonomous, 20-JUN-23
   - 204: Agras T40, Fleet: 103, Cap: 20/150, MAINTENANCE, Semi-Autonomous, 12-FEB-24
   - 205: Autel EVO, Fleet: 103, Cap: 12/110, ACTIVE, Autonomous, 05-NOV-23
   - 206: Parrot Anafi, Fleet: 104, Cap: 5/80, ACTIVE, Semi-Autonomous, 18-MAY-24

2. **`OPERATOR` Table (5 records):**
   - 301: Rahul, HUMAN, 9876543210, rahul@gmail.com, CERTIFIED
   - 302: Priya, HUMAN, 9876543211, priya@gmail.com, CERTIFIED
   - 303: Arun, HUMAN, 9876543212, arun@gmail.com, CERTIFIED
   - 304: DroneAI-01, AI, 9876543213, ai01@drone.com, CERTIFIED
   - 305: DroneAI-02, AI, 9876543214, ai02@drone.com, CERTIFIED

3. **`HUMAN_PILOT` Table (3 records):**
   - 301: LIC101, 01-JAN-24, 01-JAN-27, Advanced
   - 302: LIC102, 01-FEB-24, 01-FEB-27, Advanced
   - 303: LIC103, 01-MAR-24, 01-MAR-27, Expert

4. **`AI_OPERATOR` Table (2 records):**
   - 304: AI-2.1, CERTIFIED, HIGH
   - 305: AI-3.0, CERTIFIED, FULL

5. **`DRONE_OPERATOR_ASSIGNMENT` Table (6 records):**
   - 401: Drone 201, Operator 301, 10-JAN-26, COMPLETED, Delivery
   - 402: Drone 202, Operator 304, 12-JAN-26, ACTIVE, Surveillance
   - 403: Drone 203, Operator 302, 15-JAN-26, COMPLETED, Surveillance
   - 404: Drone 204, Operator 305, 18-JAN-26, ACTIVE, Agriculture
   - 405: Drone 205, Operator 303, 20-JAN-26, COMPLETED, Agriculture
   - 406: Drone 206, Operator 301, 22-JAN-26, ACTIVE, Disaster

6. **`MISSION` Table (12 records):**
   - 601: Drone 201, Op 301, Route 501, Package Delivery, 01-FEB-26, Clear, Medical Package, 20, COMPLETED
   - 602: Drone 201, Op 301, Route 501, Package Delivery, 05-FEB-26, Cloudy, Food Package, 25, COMPLETED
   - 603: Drone 202, Op 304, Route 501, Aerial Survey, 08-FEB-26, Clear, Camera, 30, COMPLETED
   - 604: Drone 202, Op 304, Route 502, Aerial Survey, 12-FEB-26, Windy, Camera, 35, COMPLETED
   - 605: Drone 203, Op 302, Route 502, Surveillance, 15-FEB-26, Clear, Camera, 20, COMPLETED
   - 606: Drone 203, Op 302, Route 503, Surveillance, 20-FEB-26, Cloudy, Camera, 25, COMPLETED
   - 607: Drone 203, Op 302, Route 503, Surveillance, 25-FEB-26, Clear, Camera, 30, COMPLETED
   - 608: Drone 204, Op 305, Route 504, Crop Monitoring, 01-MAR-26, Clear, Sensors, 40, COMPLETED
   - 609: Drone 205, Op 303, Route 504, Crop Monitoring, 05-MAR-26, Clear, Sensors, 25, COMPLETED
   - 610: Drone 205, Op 303, Route 504, Crop Monitoring, 10-MAR-26, Cloudy, Sensors, 30, COMPLETED
   - 611: Drone 205, Op 303, Route 504, Crop Monitoring, 15-MAR-26, Clear, Sensors, 35, COMPLETED
   - 612: Drone 206, Op 301, Route 503, Disaster Survey, 20-MAR-26, Rainy, Camera, 20, COMPLETED

7. **`BATTERY` Table (6 records):**
   - 701: Drone 201, Lithium, 100, 80, NORMAL, 20-MAR-26
   - 702: Drone 202, Lithium, 120, 65, NORMAL, 20-MAR-26
   - 703: Drone 203, Lithium, 90, 45, NORMAL, 20-MAR-26
   - 704: Drone 204, Lithium, 150, 25, LOW, 20-MAR-26
   - 705: Drone 205, Lithium, 110, 90, FULL, 20-MAR-26
   - 706: Drone 206, Lithium, 80, 15, CRITICAL, 20-MAR-26

8. **`MAINTENANCE` Table (5 records):**
   - 801: Drone 201, Sensor Calibration, 05-JAN-26, COMPLETED, Routine calibration
   - 802: Drone 202, Battery Check, 10-FEB-26, COMPLETED, Battery inspection
   - 803: Drone 204, Motor Repair, 02-MAR-26, IN_PROGRESS, Motor replacement
   - 804: Drone 205, Firmware Update, 08-MAR-26, COMPLETED, Software update
   - 805: Drone 206, Sensor Calibration, 12-MAR-26, COMPLETED, Sensor calibration

9. **`CHARGING_STATION` Table (4 records):**
   - 901: Chennai Station, Region 1, Location Chennai, Cap 4, AVAILABLE
   - 902: Bengaluru Station, Region 2, Location Bengaluru, Cap 3, AVAILABLE
   - 903: Hyderabad Station, Region 3, Location Hyderabad, Cap 4, OCCUPIED
   - 904: Coimbatore Station, Region 4, Location Coimbatore, Cap 2, AVAILABLE

10. **`CHARGING_SCHEDULE` Table (5 records):**
    - Station 901, Drone 201, 21-MAR-26, 09:00, 11:00, COMPLETED
    - Station 901, Drone 202, 21-MAR-26, 11:00, 13:00, SCHEDULED
    - Station 902, Drone 203, 21-MAR-26, 10:00, 12:00, COMPLETED
    - Station 903, Drone 204, 21-MAR-26, 14:00, 16:00, SCHEDULED
    - Station 904, Drone 205, 21-MAR-26, 09:00, 11:00, COMPLETED

11. **`EMERGENCY_EVENT` Table (3 records):**
    - 1001: Drone 203, Mission 606, COMMUNICATION FAILURE, 20-FEB-26, Signal lost, RESOLVED
    - 1002: Drone 206, Mission 612, EMERGENCY LANDING, 20-MAR-26, Heavy rain, RESOLVED
    - 1003: Drone 204, Mission 608, BATTERY FAILURE, 01-MAR-26, Low battery, RESOLVED

12. **`FLIGHT_PERMISSION` Table (6 records):**
    - 1101: Drone 201, Mission 601, 25-JAN-26, 31-DEC-26, APPROVED, DGCA
    - 1102: Drone 202, Mission 603, 25-JAN-26, 31-DEC-26, APPROVED, DGCA
    - 1103: Drone 203, Mission 605, 25-JAN-26, 31-DEC-26, APPROVED, DGCA
    - 1104: Drone 204, Mission 608, 25-JAN-26, 31-DEC-26, APPROVED, DGCA
    - 1105: Drone 205, Mission 609, 25-JAN-26, 31-DEC-26, APPROVED, DGCA
    - 1106: Drone 206, Mission 612, 25-JAN-26, 31-DEC-26, APPROVED, DGCA
