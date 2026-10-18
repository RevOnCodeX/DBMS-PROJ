# Graph Data Dictionary: Drone Fleet Management Database

This data dictionary outlines the Neo4j Graph Data Model, detailing all 16 node labels, primary identifier properties, property data types, source SQL origins, and schema constraints.

---

## Node Labels & Property Specifications

### 1. `:Region`
- **Description:** Geographical zones where drone fleets and charging infrastructure are stationed.
- **Primary Identifier:** `Region_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Region_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 1, 2, 3, 4) |
  | `Region_Name` | String | NOT NULL | City name (Chennai, Bengaluru, Hyderabad, Coimbatore) |
  | `Region_Type` | String | Optional | Operational classification (Urban, Industrial) |
  | `Location` | String | Optional | State / geographic territory (Tamil Nadu, Karnataka, Telangana) |

---

### 2. `:Fleet`
- **Description:** Operational groupings of drones organized by mission purpose and assigned region.
- **Primary Identifier:** `Fleet_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Fleet_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 101, 102, 103, 104) |
  | `Fleet_Name` | String | NOT NULL | Fleet code / designation (Fleet-A, Fleet-B, etc.) |
  | `Region_ID` | Integer | FK to Region | Foreign key reference to operating region |
  | `Fleet_Type` | String | Optional | Domain role (Delivery, Surveillance, Agriculture, Disaster) |
  | `Fleet_Status` | String | Optional | Fleet operational state (ACTIVE, INACTIVE) |

---

### 3. `:Drone`
- **Description:** Individual aerial unmanned vehicles belonging to a fleet.
- **Primary Identifier:** `Drone_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Drone_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 201 to 206) |
  | `Drone_Model` | String | NOT NULL | Commercial model (DJI M30, Skydio X2, Agras T40, etc.) |
  | `Fleet_ID` | Integer | FK to Fleet | Foreign key to owning fleet |
  | `Payload_Capacity`| Float/Integer| In kilograms | Maximum carrying capacity (5 to 20 kg) |
  | `Battery_Capacity`| Float/Integer| In watt-hours/units | Battery rating (80 to 150 units) |
  | `Operational_Status`| String | In source SQL | Operational status (ACTIVE, MAINTENANCE) |
  | `Drone_Type` | String | In source SQL | Autonomy classification (Autonomous, Semi-Autonomous) |
  | `Manufacture_Date`| Date | Native Neo4j DATE | Commissioning date (e.g. 2024-01-10) |

---

### 4. `:Operator`
- **Description:** Certified human pilots and autonomous AI systems responsible for drone operations.
- **Primary Identifier:** `Operator_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Operator_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 301 to 305) |
  | `Operator_Name` | String | NOT NULL | Pilot name or AI software system name |
  | `Operator_Type` | String | NOT NULL | Operator category (HUMAN, AI) |
  | `Contact_No` | String | NOT NULL | 10-digit communication contact number |
  | `Email` | String | NOT NULL | Official contact email |
  | `Certification_Status`| String | NOT NULL | Certification status (CERTIFIED) |

---

### 5. `:Human_Pilot`
- **Description:** Specialized sub-profile for human pilots certified by aviation regulators.
- **Primary Identifier:** `Operator_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Operator_ID` | Integer | UNIQUE, FK to Operator | Identifier matching the parent Operator node |
  | `License_No` | String | NOT NULL | Aviation pilot license code (LIC101, LIC102, LIC103) |
  | `Certification_Date`| Date | Native Neo4j DATE | Issuance date of pilot license |
  | `Certification_Expiry`| Date | Native Neo4j DATE | Expiration date of pilot license |
  | `Pilot_Rating` | String | Proficiency level | Rating tier (Advanced, Expert) |

---

### 6. `:AI_Operator`
- **Description:** Specialized sub-profile for autonomous AI navigation and mission control systems.
- **Primary Identifier:** `Operator_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Operator_ID` | Integer | UNIQUE, FK to Operator | Identifier matching parent Operator node |
  | `AI_Version` | String | NOT NULL | AI software build version (AI-2.1, AI-3.0) |
  | `Certification_Status`| String | NOT NULL | Regulatory compliance flag (CERTIFIED) |
  | `Autonomy_Level` | String | Autonomy standard | Autonomy tier (HIGH, FULL) |

---

### 7. `:Drone_Operator_Assignment`
- **Description:** Explicit historical and active operational pairings between Drones and Operators.
- **Primary Identifier:** `Assignment_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Assignment_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 401 to 406) |
  | `Drone_ID` | Integer | FK to Drone | Assigned drone identifier |
  | `Operator_ID` | Integer | FK to Operator | Assigned pilot / AI operator identifier |
  | `Assignment_Date`| Date | Native Neo4j DATE | Date assignment was initiated |
  | `Assignment_Status`| String | NOT NULL | Status (ACTIVE, COMPLETED) |
  | `Mission_Type` | String | NOT NULL | Targeted mission sector (Delivery, Surveillance, etc.) |

---

### 8. `:GPS_Route`
- **Description:** Waypoint corridors and predefined flight paths for automated missions.
- **Primary Identifier:** `Route_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Route_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 501 to 504) |
  | `Route_Name` | String | NOT NULL | Route title (Chennai Route, Bengaluru Route, etc.) |
  | `Start_Location` | String | NOT NULL | Takeoff waypoint |
  | `End_Location` | String | NOT NULL | Destination waypoint |
  | `Route_Distance` | Float/Integer| Kilometers | Flight distance in kilometers (20 to 35 km) |
  | `Route_Status` | String | NOT NULL | Operational status (ACTIVE) |

---

### 9. `:Mission`
- **Description:** Actual flight sorties executed by a drone under operator supervision.
- **Primary Identifier:** `Mission_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Mission_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 601 to 612) |
  | `Drone_ID` | Integer | FK to Drone | Operating drone |
  | `Operator_ID` | Integer | FK to Operator | Supervising operator |
  | `Route_ID` | Integer | FK to GPS_Route | Flight corridor followed |
  | `Mission_Objective`| String | NOT NULL | Purpose (Package Delivery, Surveillance, etc.) |
  | `Mission_Date` | Date | Native Neo4j DATE | Date of flight execution |
  | `Weather_Conditions`| String | Atmospheric status | Weather state (Clear, Cloudy, Windy, Rainy) |
  | `Payload_Information`| String | Payload contents | Equipment or cargo carried (Sensors, Camera, etc.) |
  | `Battery_Usage` | Integer | Units consumed | Battery drain measured during flight |
  | `Mission_Status` | String | NOT NULL | Flight completion status (COMPLETED) |

---

### 10. `:Battery`
- **Description:** Physical telemetry and health logs of drone battery packs.
- **Primary Identifier:** `Battery_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Battery_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 701 to 706) |
  | `Drone_ID` | Integer | FK to Drone | Associated drone |
  | `Battery_Type` | String | NOT NULL | Chemical composition (Lithium) |
  | `Battery_Capacity`| Integer | Rated capacity | Total capacity rating (80 to 150) |
  | `Current_Level` | Integer | Percentage (%) | Current state of charge (15% to 90%) |
  | `Battery_Status` | String | NOT NULL | Health flag (NORMAL, LOW, FULL, CRITICAL) |
  | `Last_Updated` | Date | Native Neo4j DATE | Telemetry timestamp date |

---

### 11. `:Maintenance`
- **Description:** Service interventions, inspections, sensor calibrations, and repair logs.
- **Primary Identifier:** `Maintenance_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Maintenance_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 801 to 805) |
  | `Drone_ID` | Integer | FK to Drone | Serviced drone |
  | `Maintenance_Type`| String | NOT NULL | Service type (Sensor Calibration, Motor Repair, etc.) |
  | `Maintenance_Date`| Date | Native Neo4j DATE | Service execution date |
  | `Maintenance_Status`| String| NOT NULL | Service status (COMPLETED, IN_PROGRESS) |
  | `Maintenance_Description`| String| Service notes | Technical description of work performed |

---

### 12. `:Charging_Station`
- **Description:** Ground charging pads and depot power stations.
- **Primary Identifier:** `Station_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Station_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 901 to 904) |
  | `Station_Name` | String | NOT NULL | Station name (Chennai Station, etc.) |
  | `Region_ID` | Integer | FK to Region | Geographic region where installed |
  | `Location` | String | NOT NULL | Physical city / facility location |
  | `Charging_Capacity`| Integer | Simultaneous bays | Number of charging pads (2 to 4) |
  | `Station_Status`| String | Current readiness | Availability flag (AVAILABLE, OCCUPIED) |

---

### 13. `:Charging_Schedule`
- **Description:** Scheduled time-slot allocations for drones at ground charging stations.
- **Primary Identifier:** `Schedule_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Schedule_ID` | Integer | UNIQUE, NOT NULL | Synthetic graph primary key (1 to 5) |
  | `Draft_ID` | Integer | Handwritten draft | Reference identifier from handwritten draft (901–905) |
  | `Station_ID` | Integer | FK to Charging_Station| Verified charging station (901, 902, 903, 904) |
  | `Drone_ID` | Integer | FK to Drone | Scheduled drone (201 to 205) |
  | `Schedule_Date` | Date | Native Neo4j DATE | Scheduled charging date (e.g. 2026-03-21) |
  | `Start_Time` | String | 'HH:MM' format | Reserved start time (e.g. '09:00', '11:00') |
  | `End_Time` | String | 'HH:MM' format | Reserved end time (e.g. '11:00', '13:00') |
  | `Charging_Status`| String | NOT NULL | Slot state (COMPLETED, SCHEDULED) |

---

### 14. `:Emergency_Event`
- **Description:** Incident reports of inflight failures, forced landings, and battery anomalies.
- **Primary Identifier:** `Event_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Event_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 1001, 1002, 1003) |
  | `Drone_ID` | Integer | FK to Drone | Involved drone |
  | `Mission_ID` | Integer | FK to Mission | Active mission during failure |
  | `Emergency_Type` | String | NOT NULL | Incident category (COMMUNICATION FAILURE, etc.) |
  | `Emergency_Date` | Date | Native Neo4j DATE | Date of occurrence |
  | `Emergency_Description`| String| Details | Brief incident summary (Signal lost, Heavy rain, etc.) |
  | `Resolution_Status`| String| Incident outcome | Resolution state (RESOLVED) |

---

### 15. `:Flight_Permission`
- **Description:** Regulatory permits issued by aviation authorities (DGCA) authorizing missions.
- **Primary Identifier:** `Permission_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Permission_ID` | Integer | UNIQUE, NOT NULL | Primary identifier (e.g. 1101 to 1106) |
  | `Drone_ID` | Integer | FK to Drone | Authorized drone |
  | `Mission_ID` | Integer | FK to Mission | Specific authorized mission |
  | `Issued_Date` | Date | Native Neo4j DATE | Grant date |
  | `Expiry_Date` | Date | Native Neo4j DATE | Expiration date |
  | `Permission_Status`| String | Regulatory status | Approval state (APPROVED) |
  | `Issuing_Authority`| String| Issuing body | Government aviation body (DGCA) |

---

### 16. `:Technician`
- **Description:** Certified maintenance and avionics engineers. Defined in the ER model; schema and constraints are implemented, with zero artificial sample records fabricated.
- **Primary Identifier:** `Technician_ID` (Integer, Unique)
- **Properties:**
  | Property Name | Data Type | Constraint / Rule | Description |
  | :--- | :--- | :--- | :--- |
  | `Technician_ID` | Integer | UNIQUE, NOT NULL | Primary identifier |
  | `Technician_Name`| String | NOT NULL | Full name of technician |
  | `Qualification` | String | Optional | Engineering credential |
  | `Contact_No` | String | Optional | Telephone number |
  | `Email` | String | Optional | Contact email address |
