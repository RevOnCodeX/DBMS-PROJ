// ==============================================================================
// 17_validation_queries.cypher
// Validation and Integrity Checks for Drone Fleet Management Database
// ==============================================================================

// ------------------------------------------------------------------------------
// Validation 1: Count Nodes by Entity Label
// Expected Counts:
// Region: 4, Fleet: 4, Drone: 6, Operator: 5, Human_Pilot: 3, AI_Operator: 2,
// Drone_Operator_Assignment: 6, GPS_Route: 4, Mission: 12, Battery: 6,
// Maintenance: 5, Charging_Station: 4, Charging_Schedule: 5,
// Emergency_Event: 3, Flight_Permission: 6 (Total: 75 nodes)
// ------------------------------------------------------------------------------
MATCH (n)
RETURN labels(n)[0] AS Entity, count(n) AS Total
ORDER BY Entity;

// ------------------------------------------------------------------------------
// Validation 2: Verify Every Drone Belongs to a Fleet
// ------------------------------------------------------------------------------
MATCH (d:Drone)
OPTIONAL MATCH (f:Fleet)-[:CONTAINS]->(d)
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Drone_Model,
       d.Operational_Status AS Status,
       f.Fleet_ID AS Fleet_ID,
       f.Fleet_Name AS Fleet_Name
ORDER BY Drone_ID;

// ------------------------------------------------------------------------------
// Validation 3: Verify Missions, Associated Drones, and GPS Routes
// ------------------------------------------------------------------------------
MATCH (m:Mission)
OPTIONAL MATCH (d:Drone)-[:PERFORMS]->(m)
OPTIONAL MATCH (m)-[:FOLLOWS]->(r:GPS_Route)
RETURN m.Mission_ID AS Mission_ID,
       d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Drone_Model,
       r.Route_ID AS Route_ID,
       r.Route_Name AS Route_Name,
       m.Mission_Objective AS Objective,
       m.Mission_Status AS Status
ORDER BY Mission_ID;

// ------------------------------------------------------------------------------
// Validation 4: Identify Missions Without a Flight Permission
// ------------------------------------------------------------------------------
MATCH (m:Mission)
WHERE NOT EXISTS { MATCH (m)-[:REQUIRES]->(:Flight_Permission) }
RETURN m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       m.Mission_Date AS Date,
       m.Mission_Status AS Status
ORDER BY Mission_ID;

// ------------------------------------------------------------------------------
// Validation 5: Find Drones with LOW or CRITICAL Battery Status
// ------------------------------------------------------------------------------
MATCH (d:Drone)-[:HAS_BATTERY_RECORD]->(b:Battery)
WHERE b.Battery_Status IN ['LOW', 'CRITICAL']
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Drone_Model,
       b.Current_Level AS Current_Level,
       b.Battery_Status AS Battery_Status,
       b.Last_Updated AS Last_Updated
ORDER BY b.Current_Level ASC;

// ------------------------------------------------------------------------------
// Validation 6: Find Drones Requiring Maintenance (Status != 'COMPLETED')
// ------------------------------------------------------------------------------
MATCH (d:Drone)-[:UNDERGOES]->(m:Maintenance)
WHERE m.Maintenance_Status <> 'COMPLETED'
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Drone_Model,
       m.Maintenance_ID AS Maintenance_ID,
       m.Maintenance_Type AS Maintenance_Type,
       m.Maintenance_Status AS Maintenance_Status,
       m.Maintenance_Description AS Description;

// ------------------------------------------------------------------------------
// Validation 7: Verify Emergency Events and Their Links
// ------------------------------------------------------------------------------
MATCH (d:Drone)-[:GENERATES]->(e:Emergency_Event)
OPTIONAL MATCH (m:Mission)-[:HAS_EMERGENCY_EVENT]->(e)
RETURN e.Event_ID AS Event_ID,
       d.Drone_ID AS Drone_ID,
       m.Mission_ID AS Mission_ID,
       e.Emergency_Type AS Emergency_Type,
       e.Emergency_Date AS Event_Date,
       e.Resolution_Status AS Resolution_Status
ORDER BY Event_ID;

// ------------------------------------------------------------------------------
// Validation 8: Orphan Records Integrity Audit
// Each query should return 0 rows if graph integrity is complete
// ------------------------------------------------------------------------------

// 8a. Drones without Fleet
MATCH (d:Drone)
WHERE NOT EXISTS { MATCH (:Fleet)-[:CONTAINS]->(d) }
RETURN 'Drone without Fleet' AS Issue, d.Drone_ID AS ID;

// 8b. Missions without Drone
MATCH (m:Mission)
WHERE NOT EXISTS { MATCH (:Drone)-[:PERFORMS]->(m) }
RETURN 'Mission without Drone' AS Issue, m.Mission_ID AS ID;

// 8c. Missions without Operator
MATCH (m:Mission)
WHERE NOT EXISTS { MATCH (:Operator)-[:ASSIGNED_TO]->(m) }
RETURN 'Mission without Operator' AS Issue, m.Mission_ID AS ID;

// 8d. Missions without GPS Route
MATCH (m:Mission)
WHERE NOT EXISTS { MATCH (m)-[:FOLLOWS]->(:GPS_Route) }
RETURN 'Mission without GPS Route' AS Issue, m.Mission_ID AS ID;

// 8e. Battery records without Drone
MATCH (b:Battery)
WHERE NOT EXISTS { MATCH (:Drone)-[:HAS_BATTERY_RECORD]->(b) }
RETURN 'Battery without Drone' AS Issue, b.Battery_ID AS ID;

// 8f. Maintenance records without Drone
MATCH (m:Maintenance)
WHERE NOT EXISTS { MATCH (:Drone)-[:UNDERGOES]->(m) }
RETURN 'Maintenance without Drone' AS Issue, m.Maintenance_ID AS ID;

// 8g. Charging Schedules without Station or Drone
MATCH (csch:Charging_Schedule)
WHERE NOT EXISTS { MATCH (:Charging_Station)-[:PROVIDES]->(csch) }
   OR NOT EXISTS { MATCH (:Drone)-[:SCHEDULED]->(csch) }
RETURN 'Charging Schedule orphan' AS Issue, csch.Schedule_ID AS ID;

// 8h. Emergency Events without Drone or Mission
MATCH (ee:Emergency_Event)
WHERE NOT EXISTS { MATCH (:Drone)-[:GENERATES]->(ee) }
   OR NOT EXISTS { MATCH (:Mission)-[:HAS_EMERGENCY_EVENT]->(ee) }
RETURN 'Emergency Event orphan' AS Issue, ee.Event_ID AS ID;

// 8i. Flight Permissions without Mission or Drone
MATCH (fp:Flight_Permission)
WHERE NOT EXISTS { MATCH (:Mission)-[:REQUIRES]->(fp) }
   OR NOT EXISTS { MATCH (:Drone)-[:HAS_FLIGHT_PERMISSION]->(fp) }
RETURN 'Flight Permission orphan' AS Issue, fp.Permission_ID AS ID;

// 8j. Operator Profiles without Operator Node
MATCH (hp:Human_Pilot)
WHERE NOT EXISTS { MATCH (:Operator)-[:HAS_HUMAN_PILOT_PROFILE]->(hp) }
RETURN 'Human Pilot without Operator' AS Issue, hp.Operator_ID AS ID;

MATCH (aio:AI_Operator)
WHERE NOT EXISTS { MATCH (:Operator)-[:HAS_AI_OPERATOR_PROFILE]->(aio) }
RETURN 'AI Operator without Operator' AS Issue, aio.Operator_ID AS ID;

// 8k. Assignments without Drone or Operator
MATCH (a:Drone_Operator_Assignment)
WHERE NOT EXISTS { MATCH (:Drone)-[:HAS_ASSIGNMENT]->(a) }
   OR NOT EXISTS { MATCH (:Operator)-[:HAS_ASSIGNMENT]->(a) }
RETURN 'Assignment orphan' AS Issue, a.Assignment_ID AS ID;
