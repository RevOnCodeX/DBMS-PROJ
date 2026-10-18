// ==============================================================================
// 00_all_in_one_seed.cypher
// Drone Fleet Management Database in Neo4j
// Master Unified Seed Script (Constraints + Nodes + Relationships)
// Safe and Idempotent to run multiple times
// ==============================================================================

// ------------------------------------------------------------------------------
// PART 1: CONSTRAINTS
// ------------------------------------------------------------------------------
CREATE CONSTRAINT region_id_unique IF NOT EXISTS FOR (r:Region) REQUIRE r.Region_ID IS UNIQUE;
CREATE CONSTRAINT fleet_id_unique IF NOT EXISTS FOR (f:Fleet) REQUIRE f.Fleet_ID IS UNIQUE;
CREATE CONSTRAINT drone_id_unique IF NOT EXISTS FOR (d:Drone) REQUIRE d.Drone_ID IS UNIQUE;
CREATE CONSTRAINT operator_id_unique IF NOT EXISTS FOR (o:Operator) REQUIRE o.Operator_ID IS UNIQUE;
CREATE CONSTRAINT human_pilot_operator_id_unique IF NOT EXISTS FOR (hp:Human_Pilot) REQUIRE hp.Operator_ID IS UNIQUE;
CREATE CONSTRAINT ai_operator_operator_id_unique IF NOT EXISTS FOR (aio:AI_Operator) REQUIRE aio.Operator_ID IS UNIQUE;
CREATE CONSTRAINT assignment_id_unique IF NOT EXISTS FOR (doa:Drone_Operator_Assignment) REQUIRE doa.Assignment_ID IS UNIQUE;
CREATE CONSTRAINT route_id_unique IF NOT EXISTS FOR (gr:GPS_Route) REQUIRE gr.Route_ID IS UNIQUE;
CREATE CONSTRAINT mission_id_unique IF NOT EXISTS FOR (m:Mission) REQUIRE m.Mission_ID IS UNIQUE;
CREATE CONSTRAINT battery_id_unique IF NOT EXISTS FOR (b:Battery) REQUIRE b.Battery_ID IS UNIQUE;
CREATE CONSTRAINT maintenance_id_unique IF NOT EXISTS FOR (m:Maintenance) REQUIRE m.Maintenance_ID IS UNIQUE;
CREATE CONSTRAINT station_id_unique IF NOT EXISTS FOR (cs:Charging_Station) REQUIRE cs.Station_ID IS UNIQUE;
CREATE CONSTRAINT charging_schedule_id_unique IF NOT EXISTS FOR (csch:Charging_Schedule) REQUIRE csch.Schedule_ID IS UNIQUE;
CREATE CONSTRAINT emergency_event_id_unique IF NOT EXISTS FOR (ee:Emergency_Event) REQUIRE ee.Event_ID IS UNIQUE;
CREATE CONSTRAINT flight_permission_id_unique IF NOT EXISTS FOR (fp:Flight_Permission) REQUIRE fp.Permission_ID IS UNIQUE;
CREATE CONSTRAINT technician_id_unique IF NOT EXISTS FOR (t:Technician) REQUIRE t.Technician_ID IS UNIQUE;

// ------------------------------------------------------------------------------
// PART 2: REGIONS & FLEETS
// ------------------------------------------------------------------------------
UNWIND [
  {Region_ID: 1, Region_Name: 'Chennai', Region_Type: 'Urban', Location: 'Tamil Nadu'},
  {Region_ID: 2, Region_Name: 'Bengaluru', Region_Type: 'Urban', Location: 'Karnataka'},
  {Region_ID: 3, Region_Name: 'Hyderabad', Region_Type: 'Urban', Location: 'Telangana'},
  {Region_ID: 4, Region_Name: 'Coimbatore', Region_Type: 'Industrial', Location: 'Tamil Nadu'}
] AS row
MERGE (r:Region {Region_ID: row.Region_ID})
SET r.Region_Name = row.Region_Name,
    r.Region_Type = row.Region_Type,
    r.Location = row.Location;

UNWIND [
  {Fleet_ID: 101, Fleet_Name: 'Fleet-A', Region_ID: 1, Fleet_Type: 'Delivery', Fleet_Status: 'ACTIVE'},
  {Fleet_ID: 102, Fleet_Name: 'Fleet-B', Region_ID: 2, Fleet_Type: 'Surveillance', Fleet_Status: 'ACTIVE'},
  {Fleet_ID: 103, Fleet_Name: 'Fleet-C', Region_ID: 3, Fleet_Type: 'Agriculture', Fleet_Status: 'ACTIVE'},
  {Fleet_ID: 104, Fleet_Name: 'Fleet-D', Region_ID: 4, Fleet_Type: 'Disaster', Fleet_Status: 'ACTIVE'}
] AS row
MERGE (f:Fleet {Fleet_ID: row.Fleet_ID})
SET f.Fleet_Name = row.Fleet_Name,
    f.Region_ID = row.Region_ID,
    f.Fleet_Type = row.Fleet_Type,
    f.Fleet_Status = row.Fleet_Status;

// ------------------------------------------------------------------------------
// PART 3: DRONES
// ------------------------------------------------------------------------------
UNWIND [
  {Drone_ID: 201, Drone_Model: 'DJI M30', Fleet_ID: 101, Payload_Capacity: 10, Battery_Capacity: 100, Operational_Status: 'ACTIVE', Drone_Type: 'Semi-Autonomous', Manufacture_Date: date('2024-01-10')},
  {Drone_ID: 202, Drone_Model: 'DJI M350', Fleet_ID: 101, Payload_Capacity: 15, Battery_Capacity: 120, Operational_Status: 'ACTIVE', Drone_Type: 'Autonomous', Manufacture_Date: date('2024-03-15')},
  {Drone_ID: 203, Drone_Model: 'Skydio X2', Fleet_ID: 102, Payload_Capacity: 8, Battery_Capacity: 90, Operational_Status: 'ACTIVE', Drone_Type: 'Autonomous', Manufacture_Date: date('2023-06-20')},
  {Drone_ID: 204, Drone_Model: 'Agras T40', Fleet_ID: 103, Payload_Capacity: 20, Battery_Capacity: 150, Operational_Status: 'MAINTENANCE', Drone_Type: 'Semi-Autonomous', Manufacture_Date: date('2024-02-12')},
  {Drone_ID: 205, Drone_Model: 'Autel EVO', Fleet_ID: 103, Payload_Capacity: 12, Battery_Capacity: 110, Operational_Status: 'ACTIVE', Drone_Type: 'Autonomous', Manufacture_Date: date('2023-11-05')},
  {Drone_ID: 206, Drone_Model: 'Parrot Anafi', Fleet_ID: 104, Payload_Capacity: 5, Battery_Capacity: 80, Operational_Status: 'ACTIVE', Drone_Type: 'Semi-Autonomous', Manufacture_Date: date('2024-05-18')}
] AS row
MERGE (d:Drone {Drone_ID: row.Drone_ID})
SET d.Drone_Model = row.Drone_Model,
    d.Fleet_ID = row.Fleet_ID,
    d.Payload_Capacity = row.Payload_Capacity,
    d.Battery_Capacity = row.Battery_Capacity,
    d.Operational_Status = row.Operational_Status,
    d.Drone_Type = row.Drone_Type,
    d.Manufacture_Date = row.Manufacture_Date;

// ------------------------------------------------------------------------------
// PART 4: OPERATORS & SPECIALIZED PROFILES
// ------------------------------------------------------------------------------
UNWIND [
  {Operator_ID: 301, Operator_Name: 'Rahul', Operator_Type: 'HUMAN', Contact_No: '9876543210', Email: 'rahul@gmail.com', Certification_Status: 'CERTIFIED'},
  {Operator_ID: 302, Operator_Name: 'Priya', Operator_Type: 'HUMAN', Contact_No: '9876543211', Email: 'priya@gmail.com', Certification_Status: 'CERTIFIED'},
  {Operator_ID: 303, Operator_Name: 'Arun', Operator_Type: 'HUMAN', Contact_No: '9876543212', Email: 'arun@gmail.com', Certification_Status: 'CERTIFIED'},
  {Operator_ID: 304, Operator_Name: 'DroneAI-01', Operator_Type: 'AI', Contact_No: '9876543213', Email: 'ai01@drone.com', Certification_Status: 'CERTIFIED'},
  {Operator_ID: 305, Operator_Name: 'DroneAI-02', Operator_Type: 'AI', Contact_No: '9876543214', Email: 'ai02@drone.com', Certification_Status: 'CERTIFIED'}
] AS row
MERGE (o:Operator {Operator_ID: row.Operator_ID})
SET o.Operator_Name = row.Operator_Name,
    o.Operator_Type = row.Operator_Type,
    o.Contact_No = row.Contact_No,
    o.Email = row.Email,
    o.Certification_Status = row.Certification_Status;

UNWIND [
  {Operator_ID: 301, License_No: 'LIC101', Certification_Date: date('2024-01-01'), Certification_Expiry: date('2027-01-01'), Pilot_Rating: 'Advanced'},
  {Operator_ID: 302, License_No: 'LIC102', Certification_Date: date('2024-02-01'), Certification_Expiry: date('2027-02-01'), Pilot_Rating: 'Advanced'},
  {Operator_ID: 303, License_No: 'LIC103', Certification_Date: date('2024-03-01'), Certification_Expiry: date('2027-03-01'), Pilot_Rating: 'Expert'}
] AS row
MERGE (hp:Human_Pilot {Operator_ID: row.Operator_ID})
SET hp.License_No = row.License_No,
    hp.Certification_Date = row.Certification_Date,
    hp.Certification_Expiry = row.Certification_Expiry,
    hp.Pilot_Rating = row.Pilot_Rating;

UNWIND [
  {Operator_ID: 304, AI_Version: 'AI-2.1', Certification_Status: 'CERTIFIED', Autonomy_Level: 'HIGH'},
  {Operator_ID: 305, AI_Version: 'AI-3.0', Certification_Status: 'CERTIFIED', Autonomy_Level: 'FULL'}
] AS row
MERGE (aio:AI_Operator {Operator_ID: row.Operator_ID})
SET aio.AI_Version = row.AI_Version,
    aio.Certification_Status = row.Certification_Status,
    aio.Autonomy_Level = row.Autonomy_Level;

// ------------------------------------------------------------------------------
// PART 5: DRONE OPERATOR ASSIGNMENTS
// ------------------------------------------------------------------------------
UNWIND [
  {Assignment_ID: 401, Drone_ID: 201, Operator_ID: 301, Assignment_Date: date('2026-01-10'), Assignment_Status: 'COMPLETED', Mission_Type: 'Delivery'},
  {Assignment_ID: 402, Drone_ID: 202, Operator_ID: 304, Assignment_Date: date('2026-01-12'), Assignment_Status: 'ACTIVE', Mission_Type: 'Surveillance'},
  {Assignment_ID: 403, Drone_ID: 203, Operator_ID: 302, Assignment_Date: date('2026-01-15'), Assignment_Status: 'COMPLETED', Mission_Type: 'Surveillance'},
  {Assignment_ID: 404, Drone_ID: 204, Operator_ID: 305, Assignment_Date: date('2026-01-18'), Assignment_Status: 'ACTIVE', Mission_Type: 'Agriculture'},
  {Assignment_ID: 405, Drone_ID: 205, Operator_ID: 303, Assignment_Date: date('2026-01-20'), Assignment_Status: 'COMPLETED', Mission_Type: 'Agriculture'},
  {Assignment_ID: 406, Drone_ID: 206, Operator_ID: 301, Assignment_Date: date('2026-01-22'), Assignment_Status: 'ACTIVE', Mission_Type: 'Disaster'}
] AS row
MERGE (a:Drone_Operator_Assignment {Assignment_ID: row.Assignment_ID})
SET a.Drone_ID = row.Drone_ID,
    a.Operator_ID = row.Operator_ID,
    a.Assignment_Date = row.Assignment_Date,
    a.Assignment_Status = row.Assignment_Status,
    a.Mission_Type = row.Mission_Type;

// ------------------------------------------------------------------------------
// PART 6: GPS ROUTES
// ------------------------------------------------------------------------------
UNWIND [
  {Route_ID: 501, Route_Name: 'Chennai Route', Start_Location: 'Chennai', End_Location: 'Tambaram', Route_Distance: 25, Route_Status: 'ACTIVE'},
  {Route_ID: 502, Route_Name: 'Bengaluru Route', Start_Location: 'Bengaluru', End_Location: 'Whitefield', Route_Distance: 30, Route_Status: 'ACTIVE'},
  {Route_ID: 503, Route_Name: 'Hyderabad Route', Start_Location: 'Hyderabad', End_Location: 'Secunderabad', Route_Distance: 20, Route_Status: 'ACTIVE'},
  {Route_ID: 504, Route_Name: 'Coimbatore Route', Start_Location: 'Coimbatore', End_Location: 'Pollachi', Route_Distance: 35, Route_Status: 'ACTIVE'}
] AS row
MERGE (r:GPS_Route {Route_ID: row.Route_ID})
SET r.Route_Name = row.Route_Name,
    r.Start_Location = row.Start_Location,
    r.End_Location = row.End_Location,
    r.Route_Distance = row.Route_Distance,
    r.Route_Status = row.Route_Status;

// ------------------------------------------------------------------------------
// PART 7: MISSIONS
// ------------------------------------------------------------------------------
UNWIND [
  {Mission_ID: 601, Drone_ID: 201, Operator_ID: 301, Route_ID: 501, Mission_Objective: 'Package Delivery', Mission_Date: date('2026-02-01'), Weather_Conditions: 'Clear', Payload_Information: 'Medical Package', Battery_Usage: 20, Mission_Status: 'COMPLETED'},
  {Mission_ID: 602, Drone_ID: 201, Operator_ID: 301, Route_ID: 501, Mission_Objective: 'Package Delivery', Mission_Date: date('2026-02-05'), Weather_Conditions: 'Cloudy', Payload_Information: 'Food Package', Battery_Usage: 25, Mission_Status: 'COMPLETED'},
  {Mission_ID: 603, Drone_ID: 202, Operator_ID: 304, Route_ID: 501, Mission_Objective: 'Aerial Survey', Mission_Date: date('2026-02-08'), Weather_Conditions: 'Clear', Payload_Information: 'Camera', Battery_Usage: 30, Mission_Status: 'COMPLETED'},
  {Mission_ID: 604, Drone_ID: 202, Operator_ID: 304, Route_ID: 502, Mission_Objective: 'Aerial Survey', Mission_Date: date('2026-02-12'), Weather_Conditions: 'Windy', Payload_Information: 'Camera', Battery_Usage: 35, Mission_Status: 'COMPLETED'},
  {Mission_ID: 605, Drone_ID: 203, Operator_ID: 302, Route_ID: 502, Mission_Objective: 'Surveillance', Mission_Date: date('2026-02-15'), Weather_Conditions: 'Clear', Payload_Information: 'Camera', Battery_Usage: 20, Mission_Status: 'COMPLETED'},
  {Mission_ID: 606, Drone_ID: 203, Operator_ID: 302, Route_ID: 503, Mission_Objective: 'Surveillance', Mission_Date: date('2026-02-20'), Weather_Conditions: 'Cloudy', Payload_Information: 'Camera', Battery_Usage: 25, Mission_Status: 'COMPLETED'},
  {Mission_ID: 607, Drone_ID: 203, Operator_ID: 302, Route_ID: 503, Mission_Objective: 'Surveillance', Mission_Date: date('2026-02-25'), Weather_Conditions: 'Clear', Payload_Information: 'Camera', Battery_Usage: 30, Mission_Status: 'COMPLETED'},
  {Mission_ID: 608, Drone_ID: 204, Operator_ID: 305, Route_ID: 504, Mission_Objective: 'Crop Monitoring', Mission_Date: date('2026-03-01'), Weather_Conditions: 'Clear', Payload_Information: 'Sensors', Battery_Usage: 40, Mission_Status: 'COMPLETED'},
  {Mission_ID: 609, Drone_ID: 205, Operator_ID: 303, Route_ID: 504, Mission_Objective: 'Crop Monitoring', Mission_Date: date('2026-03-05'), Weather_Conditions: 'Clear', Payload_Information: 'Sensors', Battery_Usage: 25, Mission_Status: 'COMPLETED'},
  {Mission_ID: 610, Drone_ID: 205, Operator_ID: 303, Route_ID: 504, Mission_Objective: 'Crop Monitoring', Mission_Date: date('2026-03-10'), Weather_Conditions: 'Cloudy', Payload_Information: 'Sensors', Battery_Usage: 30, Mission_Status: 'COMPLETED'},
  {Mission_ID: 611, Drone_ID: 205, Operator_ID: 303, Route_ID: 504, Mission_Objective: 'Crop Monitoring', Mission_Date: date('2026-03-15'), Weather_Conditions: 'Clear', Payload_Information: 'Sensors', Battery_Usage: 35, Mission_Status: 'COMPLETED'},
  {Mission_ID: 612, Drone_ID: 206, Operator_ID: 301, Route_ID: 503, Mission_Objective: 'Disaster Survey', Mission_Date: date('2026-03-20'), Weather_Conditions: 'Rainy', Payload_Information: 'Camera', Battery_Usage: 20, Mission_Status: 'COMPLETED'}
] AS row
MERGE (m:Mission {Mission_ID: row.Mission_ID})
SET m.Drone_ID = row.Drone_ID,
    m.Operator_ID = row.Operator_ID,
    m.Route_ID = row.Route_ID,
    m.Mission_Objective = row.Mission_Objective,
    m.Mission_Date = row.Mission_Date,
    m.Weather_Conditions = row.Weather_Conditions,
    m.Payload_Information = row.Payload_Information,
    m.Battery_Usage = row.Battery_Usage,
    m.Mission_Status = row.Mission_Status;

// ------------------------------------------------------------------------------
// PART 8: BATTERIES
// ------------------------------------------------------------------------------
UNWIND [
  {Battery_ID: 701, Drone_ID: 201, Battery_Type: 'Lithium', Battery_Capacity: 100, Current_Level: 80, Battery_Status: 'NORMAL', Last_Updated: date('2026-03-20')},
  {Battery_ID: 702, Drone_ID: 202, Battery_Type: 'Lithium', Battery_Capacity: 120, Current_Level: 65, Battery_Status: 'NORMAL', Last_Updated: date('2026-03-20')},
  {Battery_ID: 703, Drone_ID: 203, Battery_Type: 'Lithium', Battery_Capacity: 90, Current_Level: 45, Battery_Status: 'NORMAL', Last_Updated: date('2026-03-20')},
  {Battery_ID: 704, Drone_ID: 204, Battery_Type: 'Lithium', Battery_Capacity: 150, Current_Level: 25, Battery_Status: 'LOW', Last_Updated: date('2026-03-20')},
  {Battery_ID: 705, Drone_ID: 205, Battery_Type: 'Lithium', Battery_Capacity: 110, Current_Level: 90, Battery_Status: 'FULL', Last_Updated: date('2026-03-20')},
  {Battery_ID: 706, Drone_ID: 206, Battery_Type: 'Lithium', Battery_Capacity: 80, Current_Level: 15, Battery_Status: 'CRITICAL', Last_Updated: date('2026-03-20')}
] AS row
MERGE (b:Battery {Battery_ID: row.Battery_ID})
SET b.Drone_ID = row.Drone_ID,
    b.Battery_Type = row.Battery_Type,
    b.Battery_Capacity = row.Battery_Capacity,
    b.Current_Level = row.Current_Level,
    b.Battery_Status = row.Battery_Status,
    b.Last_Updated = row.Last_Updated;

// ------------------------------------------------------------------------------
// PART 9: MAINTENANCE
// ------------------------------------------------------------------------------
UNWIND [
  {Maintenance_ID: 801, Drone_ID: 201, Maintenance_Type: 'Sensor Calibration', Maintenance_Date: date('2026-01-05'), Maintenance_Status: 'COMPLETED', Maintenance_Description: 'Routine calibration'},
  {Maintenance_ID: 802, Drone_ID: 202, Maintenance_Type: 'Battery Check', Maintenance_Date: date('2026-02-10'), Maintenance_Status: 'COMPLETED', Maintenance_Description: 'Battery inspection'},
  {Maintenance_ID: 803, Drone_ID: 204, Maintenance_Type: 'Motor Repair', Maintenance_Date: date('2026-03-02'), Maintenance_Status: 'IN_PROGRESS', Maintenance_Description: 'Motor replacement'},
  {Maintenance_ID: 804, Drone_ID: 205, Maintenance_Type: 'Firmware Update', Maintenance_Date: date('2026-03-08'), Maintenance_Status: 'COMPLETED', Maintenance_Description: 'Software update'},
  {Maintenance_ID: 805, Drone_ID: 206, Maintenance_Type: 'Sensor Calibration', Maintenance_Date: date('2026-03-12'), Maintenance_Status: 'COMPLETED', Maintenance_Description: 'Sensor calibration'}
] AS row
MERGE (maint:Maintenance {Maintenance_ID: row.Maintenance_ID})
SET maint.Drone_ID = row.Drone_ID,
    maint.Maintenance_Type = row.Maintenance_Type,
    maint.Maintenance_Date = row.Maintenance_Date,
    maint.Maintenance_Status = row.Maintenance_Status,
    maint.Maintenance_Description = row.Maintenance_Description;

// ------------------------------------------------------------------------------
// PART 10: CHARGING STATIONS & SCHEDULES
// ------------------------------------------------------------------------------
UNWIND [
  {Station_ID: 901, Station_Name: 'Chennai Station', Region_ID: 1, Location: 'Chennai', Charging_Capacity: 4, Station_Status: 'AVAILABLE'},
  {Station_ID: 902, Station_Name: 'Bengaluru Station', Region_ID: 2, Location: 'Bengaluru', Charging_Capacity: 3, Station_Status: 'AVAILABLE'},
  {Station_ID: 903, Station_Name: 'Hyderabad Station', Region_ID: 3, Location: 'Hyderabad', Charging_Capacity: 4, Station_Status: 'OCCUPIED'},
  {Station_ID: 904, Station_Name: 'Coimbatore Station', Region_ID: 4, Location: 'Coimbatore', Charging_Capacity: 2, Station_Status: 'AVAILABLE'}
] AS row
MERGE (cs:Charging_Station {Station_ID: row.Station_ID})
SET cs.Station_Name = row.Station_Name,
    cs.Region_ID = row.Region_ID,
    cs.Location = row.Location,
    cs.Charging_Capacity = row.Charging_Capacity,
    cs.Station_Status = row.Station_Status;

UNWIND [
  {Schedule_ID: 1, Draft_ID: 901, Station_ID: 901, Drone_ID: 201, Schedule_Date: date('2026-03-21'), Start_Time: '09:00', End_Time: '11:00', Charging_Status: 'COMPLETED'},
  {Schedule_ID: 2, Draft_ID: 902, Station_ID: 901, Drone_ID: 202, Schedule_Date: date('2026-03-21'), Start_Time: '11:00', End_Time: '13:00', Charging_Status: 'SCHEDULED'},
  {Schedule_ID: 3, Draft_ID: 903, Station_ID: 902, Drone_ID: 203, Schedule_Date: date('2026-03-21'), Start_Time: '10:00', End_Time: '12:00', Charging_Status: 'COMPLETED'},
  {Schedule_ID: 4, Draft_ID: 904, Station_ID: 903, Drone_ID: 204, Schedule_Date: date('2026-03-21'), Start_Time: '14:00', End_Time: '16:00', Charging_Status: 'SCHEDULED'},
  {Schedule_ID: 5, Draft_ID: 905, Station_ID: 904, Drone_ID: 205, Schedule_Date: date('2026-03-21'), Start_Time: '09:00', End_Time: '11:00', Charging_Status: 'COMPLETED'}
] AS row
MERGE (csch:Charging_Schedule {Schedule_ID: row.Schedule_ID})
SET csch.Draft_ID = row.Draft_ID,
    csch.Station_ID = row.Station_ID,
    csch.Drone_ID = row.Drone_ID,
    csch.Schedule_Date = row.Schedule_Date,
    csch.Start_Time = row.Start_Time,
    csch.End_Time = row.End_Time,
    csch.Charging_Status = row.Charging_Status;

// ------------------------------------------------------------------------------
// PART 11: EMERGENCY EVENTS
// ------------------------------------------------------------------------------
UNWIND [
  {Event_ID: 1001, Drone_ID: 203, Mission_ID: 606, Emergency_Type: 'COMMUNICATION FAILURE', Emergency_Date: date('2026-02-20'), Emergency_Description: 'Signal lost', Resolution_Status: 'RESOLVED'},
  {Event_ID: 1002, Drone_ID: 206, Mission_ID: 612, Emergency_Type: 'EMERGENCY LANDING', Emergency_Date: date('2026-03-20'), Emergency_Description: 'Heavy rain', Resolution_Status: 'RESOLVED'},
  {Event_ID: 1003, Drone_ID: 204, Mission_ID: 608, Emergency_Type: 'BATTERY FAILURE', Emergency_Date: date('2026-03-01'), Emergency_Description: 'Low battery', Resolution_Status: 'RESOLVED'}
] AS row
MERGE (ee:Emergency_Event {Event_ID: row.Event_ID})
SET ee.Drone_ID = row.Drone_ID,
    ee.Mission_ID = row.Mission_ID,
    ee.Emergency_Type = row.Emergency_Type,
    ee.Emergency_Date = row.Emergency_Date,
    ee.Emergency_Description = row.Emergency_Description,
    ee.Resolution_Status = row.Resolution_Status;

// ------------------------------------------------------------------------------
// PART 12: FLIGHT PERMISSIONS
// ------------------------------------------------------------------------------
UNWIND [
  {Permission_ID: 1101, Drone_ID: 201, Mission_ID: 601, Issued_Date: date('2026-01-25'), Expiry_Date: date('2026-12-31'), Permission_Status: 'APPROVED', Issuing_Authority: 'DGCA'},
  {Permission_ID: 1102, Drone_ID: 202, Mission_ID: 603, Issued_Date: date('2026-01-25'), Expiry_Date: date('2026-12-31'), Permission_Status: 'APPROVED', Issuing_Authority: 'DGCA'},
  {Permission_ID: 1103, Drone_ID: 203, Mission_ID: 605, Issued_Date: date('2026-01-25'), Expiry_Date: date('2026-12-31'), Permission_Status: 'APPROVED', Issuing_Authority: 'DGCA'},
  {Permission_ID: 1104, Drone_ID: 204, Mission_ID: 608, Issued_Date: date('2026-01-25'), Expiry_Date: date('2026-12-31'), Permission_Status: 'APPROVED', Issuing_Authority: 'DGCA'},
  {Permission_ID: 1105, Drone_ID: 205, Mission_ID: 609, Issued_Date: date('2026-01-25'), Expiry_Date: date('2026-12-31'), Permission_Status: 'APPROVED', Issuing_Authority: 'DGCA'},
  {Permission_ID: 1106, Drone_ID: 206, Mission_ID: 612, Issued_Date: date('2026-01-25'), Expiry_Date: date('2026-12-31'), Permission_Status: 'APPROVED', Issuing_Authority: 'DGCA'}
] AS row
MERGE (fp:Flight_Permission {Permission_ID: row.Permission_ID})
SET fp.Drone_ID = row.Drone_ID,
    fp.Mission_ID = row.Mission_ID,
    fp.Issued_Date = row.Issued_Date,
    fp.Expiry_Date = row.Expiry_Date,
    fp.Permission_Status = row.Permission_Status,
    fp.Issuing_Authority = row.Issuing_Authority;

// ------------------------------------------------------------------------------
// PART 13: CONNECT ALL GRAPH RELATIONSHIPS
// ------------------------------------------------------------------------------
// Region -> Fleet (CONTAINS)
MATCH (r:Region), (f:Fleet) WHERE f.Region_ID = r.Region_ID
MERGE (r)-[:CONTAINS]->(f);

// Fleet -> Drone (CONTAINS) & Drone -> Fleet (BELONGS_TO)
MATCH (f:Fleet), (d:Drone) WHERE d.Fleet_ID = f.Fleet_ID
MERGE (f)-[:CONTAINS]->(d)
MERGE (d)-[:BELONGS_TO]->(f);

// Operator Profiles
MATCH (o:Operator), (hp:Human_Pilot) WHERE o.Operator_ID = hp.Operator_ID
MERGE (o)-[:HAS_HUMAN_PILOT_PROFILE]->(hp);

MATCH (o:Operator), (aio:AI_Operator) WHERE o.Operator_ID = aio.Operator_ID
MERGE (o)-[:HAS_AI_OPERATOR_PROFILE]->(aio);

// Assignments
MATCH (d:Drone), (a:Drone_Operator_Assignment) WHERE d.Drone_ID = a.Drone_ID
MERGE (d)-[:HAS_ASSIGNMENT]->(a);

MATCH (o:Operator), (a:Drone_Operator_Assignment) WHERE o.Operator_ID = a.Operator_ID
MERGE (o)-[:HAS_ASSIGNMENT]->(a);

// Missions
MATCH (d:Drone), (m:Mission) WHERE d.Drone_ID = m.Drone_ID
MERGE (d)-[:PERFORMS]->(m)
MERGE (d)-[:HAS_MISSION]->(m);

MATCH (o:Operator), (m:Mission) WHERE o.Operator_ID = m.Operator_ID
MERGE (o)-[:ASSIGNED_TO]->(m);

MATCH (m:Mission), (r:GPS_Route) WHERE m.Route_ID = r.Route_ID
MERGE (m)-[:FOLLOWS]->(r)
MERGE (r)-[:USED_BY]->(m);

// Batteries
MATCH (d:Drone), (b:Battery) WHERE d.Drone_ID = b.Drone_ID
MERGE (d)-[:HAS_BATTERY_RECORD]->(b);

// Maintenance
MATCH (d:Drone), (maint:Maintenance) WHERE d.Drone_ID = maint.Drone_ID
MERGE (d)-[:UNDERGOES]->(maint);

// Stations & Schedules
MATCH (r:Region), (cs:Charging_Station) WHERE r.Region_ID = cs.Region_ID
MERGE (r)-[:HAS_CHARGING_STATION]->(cs);

MATCH (cs:Charging_Station), (csch:Charging_Schedule) WHERE cs.Station_ID = csch.Station_ID
MERGE (cs)-[:PROVIDES]->(csch);

MATCH (d:Drone), (csch:Charging_Schedule) WHERE d.Drone_ID = csch.Drone_ID
MERGE (d)-[:SCHEDULED]->(csch)
MERGE (d)-[:HAS_CHARGING_SCHEDULE]->(csch);

// Emergency Events
MATCH (d:Drone), (ee:Emergency_Event) WHERE d.Drone_ID = ee.Drone_ID
MERGE (d)-[:GENERATES]->(ee);

MATCH (m:Mission), (ee:Emergency_Event) WHERE m.Mission_ID = ee.Mission_ID
MERGE (m)-[:HAS_EMERGENCY_EVENT]->(ee);

// Flight Permissions
MATCH (m:Mission), (fp:Flight_Permission) WHERE m.Mission_ID = fp.Mission_ID
MERGE (m)-[:REQUIRES]->(fp);

MATCH (d:Drone), (fp:Flight_Permission) WHERE d.Drone_ID = fp.Drone_ID
MERGE (d)-[:HAS_FLIGHT_PERMISSION]->(fp);

RETURN "Master All-in-One Database Seed Completed Successfully!" AS Status;
