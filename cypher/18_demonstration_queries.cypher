// ==============================================================================
// 18_demonstration_queries.cypher
// Demonstration and Analytical Queries for Viva / College Practical Exam
// ==============================================================================

// ------------------------------------------------------------------------------
// Query 1: Display the Complete Drone Fleet with Fleet & Regional Placement
// ------------------------------------------------------------------------------
MATCH (r:Region)-[:CONTAINS]->(f:Fleet)-[:CONTAINS]->(d:Drone)
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       d.Drone_Type AS Type,
       d.Operational_Status AS Status,
       d.Payload_Capacity AS Payload_Kg,
       d.Battery_Capacity AS Battery_Units,
       f.Fleet_Name AS Fleet,
       f.Fleet_Type AS Fleet_Role,
       r.Region_Name AS Region,
       r.Location AS State
ORDER BY d.Drone_ID;

// ------------------------------------------------------------------------------
// Query 2: Display All Missions Performed by a Particular Drone (e.g. Drone 201)
// ------------------------------------------------------------------------------
MATCH (d:Drone {Drone_ID: 201})-[:PERFORMS]->(m:Mission)
OPTIONAL MATCH (m)-[:FOLLOWS]->(r:GPS_Route)
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       m.Mission_ID AS Mission_ID,
       m.Mission_Date AS Date,
       m.Mission_Objective AS Objective,
       r.Route_Name AS Route,
       m.Battery_Usage AS Battery_Used,
       m.Mission_Status AS Status
ORDER BY m.Mission_Date ASC;

// ------------------------------------------------------------------------------
// Query 3: Find the Operator Assigned to Each Mission
// ------------------------------------------------------------------------------
MATCH (m:Mission)<-[:ASSIGNED_TO]-(o:Operator)
RETURN m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       m.Mission_Date AS Date,
       o.Operator_ID AS Operator_ID,
       o.Operator_Name AS Operator_Name,
       o.Operator_Type AS Operator_Type,
       m.Mission_Status AS Status
ORDER BY m.Mission_ID;

// ------------------------------------------------------------------------------
// Query 4: Display the GPS Route for Every Mission
// ------------------------------------------------------------------------------
MATCH (m:Mission)-[:FOLLOWS]->(r:GPS_Route)
RETURN m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       r.Route_ID AS Route_ID,
       r.Route_Name AS Route_Name,
       r.Start_Location AS Start_Location,
       r.End_Location AS End_Location,
       r.Route_Distance AS Distance_Km,
       r.Route_Status AS Route_Status
ORDER BY m.Mission_ID;

// ------------------------------------------------------------------------------
// Query 5: Find All Drones with LOW or CRITICAL Battery Status
// ------------------------------------------------------------------------------
MATCH (d:Drone)-[:HAS_BATTERY_RECORD]->(b:Battery)
WHERE b.Battery_Status IN ['LOW', 'CRITICAL']
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       b.Battery_ID AS Battery_ID,
       b.Current_Level AS Current_Level_Pct,
       b.Battery_Capacity AS Capacity,
       b.Battery_Status AS Status,
       b.Last_Updated AS Last_Updated
ORDER BY b.Current_Level ASC;

// ------------------------------------------------------------------------------
// Query 6: Display Maintenance History Across All Drones
// ------------------------------------------------------------------------------
MATCH (d:Drone)-[:UNDERGOES]->(m:Maintenance)
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       m.Maintenance_ID AS Maintenance_ID,
       m.Maintenance_Type AS Service_Type,
       m.Maintenance_Date AS Service_Date,
       m.Maintenance_Status AS Status,
       m.Maintenance_Description AS Description
ORDER BY m.Maintenance_Date ASC;

// ------------------------------------------------------------------------------
// Query 7: Display Charging Schedules and Linked Stations
// ------------------------------------------------------------------------------
MATCH (cs:Charging_Station)-[:PROVIDES]->(csch:Charging_Schedule)<-[:SCHEDULED]-(d:Drone)
RETURN csch.Schedule_ID AS Schedule_ID,
       d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Drone_Model,
       cs.Station_ID AS Station_ID,
       cs.Station_Name AS Station_Name,
       cs.Location AS Station_Location,
       csch.Schedule_Date AS Date,
       csch.Start_Time AS Start_Time,
       csch.End_Time AS End_Time,
       csch.Charging_Status AS Status
ORDER BY csch.Schedule_ID;

// ------------------------------------------------------------------------------
// Query 8: Display Emergency Event History and Associated Missions
// ------------------------------------------------------------------------------
MATCH (d:Drone)-[:GENERATES]->(ee:Emergency_Event)
OPTIONAL MATCH (m:Mission)-[:HAS_EMERGENCY_EVENT]->(ee)
RETURN ee.Event_ID AS Event_ID,
       d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Drone_Model,
       m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       ee.Emergency_Type AS Event_Type,
       ee.Emergency_Date AS Event_Date,
       ee.Emergency_Description AS Description,
       ee.Resolution_Status AS Resolution
ORDER BY ee.Event_ID;

// ------------------------------------------------------------------------------
// Query 9: Display Flight Permissions Issued by Regulatory Authorities
// ------------------------------------------------------------------------------
MATCH (d:Drone)-[:HAS_FLIGHT_PERMISSION]->(fp:Flight_Permission)<-[:REQUIRES]-(m:Mission)
RETURN fp.Permission_ID AS Permission_ID,
       d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Drone_Model,
       m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       fp.Issuing_Authority AS Authority,
       fp.Issued_Date AS Issued_Date,
       fp.Expiry_Date AS Expiry_Date,
       fp.Permission_Status AS Status
ORDER BY fp.Permission_ID;

// ------------------------------------------------------------------------------
// Query 10: Missions Assigned to Human Pilots (with License & Rating)
// ------------------------------------------------------------------------------
MATCH (hp:Human_Pilot)<-[:HAS_HUMAN_PILOT_PROFILE]-(o:Operator)-[:ASSIGNED_TO]->(m:Mission)
RETURN o.Operator_ID AS Pilot_ID,
       o.Operator_Name AS Pilot_Name,
       hp.License_No AS License,
       hp.Pilot_Rating AS Rating,
       m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       m.Mission_Date AS Date,
       m.Mission_Status AS Status
ORDER BY o.Operator_ID, m.Mission_Date;

// ------------------------------------------------------------------------------
// Query 11: Missions Assigned to Autonomous AI Operators (with AI Specs)
// ------------------------------------------------------------------------------
MATCH (aio:AI_Operator)<-[:HAS_AI_OPERATOR_PROFILE]-(o:Operator)-[:ASSIGNED_TO]->(m:Mission)
RETURN o.Operator_ID AS AI_Operator_ID,
       o.Operator_Name AS AI_System_Name,
       aio.AI_Version AS AI_Version,
       aio.Autonomy_Level AS Autonomy_Level,
       m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       m.Mission_Date AS Date,
       m.Mission_Status AS Status
ORDER BY o.Operator_ID, m.Mission_Date;

// ------------------------------------------------------------------------------
// Query 12: Display 360-Degree Operational Graph for a Specific Drone (e.g. Drone 204)
// ------------------------------------------------------------------------------
MATCH (d:Drone {Drone_ID: 204})
OPTIONAL MATCH (d)-[:BELONGS_TO]->(f:Fleet)
OPTIONAL MATCH (d)-[:HAS_BATTERY_RECORD]->(b:Battery)
OPTIONAL MATCH (d)-[:UNDERGOES]->(maint:Maintenance)
OPTIONAL MATCH (d)-[:SCHEDULED]->(csch:Charging_Schedule)
OPTIONAL MATCH (d)-[:GENERATES]->(ee:Emergency_Event)
OPTIONAL MATCH (d)-[:PERFORMS]->(m:Mission)
OPTIONAL MATCH (d)-[:HAS_FLIGHT_PERMISSION]->(fp:Flight_Permission)
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       d.Operational_Status AS Status,
       f.Fleet_Name AS Fleet,
       b.Battery_Status AS Battery_Condition,
       b.Current_Level AS Battery_Level,
       maint.Maintenance_Type AS Ongoing_Service,
       maint.Maintenance_Status AS Service_Status,
       csch.Schedule_Date AS Next_Charging,
       ee.Emergency_Type AS Recent_Incident,
       count(DISTINCT m) AS Missions_Count,
       count(DISTINCT fp) AS Permissions_Count;

// ------------------------------------------------------------------------------
// Query 13: Operational Analytics - Mission Counts and Average Battery Usage by Objective
// ------------------------------------------------------------------------------
MATCH (m:Mission)
RETURN m.Mission_Objective AS Objective,
       count(m) AS Total_Missions,
       avg(m.Battery_Usage) AS Avg_Battery_Usage,
       min(m.Battery_Usage) AS Min_Battery_Usage,
       max(m.Battery_Usage) AS Max_Battery_Usage
ORDER BY Total_Missions DESC;

// ------------------------------------------------------------------------------
// Query 14: Find Drones with Incomplete or Pending Maintenance
// ------------------------------------------------------------------------------
MATCH (d:Drone)-[:UNDERGOES]->(m:Maintenance)
WHERE m.Maintenance_Status <> 'COMPLETED'
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       d.Operational_Status AS Drone_Operational_Status,
       m.Maintenance_ID AS Maintenance_ID,
       m.Maintenance_Type AS Service_Required,
       m.Maintenance_Status AS Current_Status,
       m.Maintenance_Description AS Details;

// ------------------------------------------------------------------------------
// Query 15: Critical Operations Monitor - Identify Drones and Missions Requiring Urgent Attention
// ------------------------------------------------------------------------------
MATCH (d:Drone)
OPTIONAL MATCH (d)-[:HAS_BATTERY_RECORD]->(b:Battery)
OPTIONAL MATCH (d)-[:UNDERGOES]->(maint:Maintenance)
OPTIONAL MATCH (d)-[:GENERATES]->(ee:Emergency_Event)
WHERE b.Battery_Status IN ['LOW', 'CRITICAL']
   OR maint.Maintenance_Status <> 'COMPLETED'
   OR ee.Event_ID IS NOT NULL
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       d.Operational_Status AS Status,
       coalesce(b.Battery_Status, 'OK') AS Battery_Alert,
       coalesce(b.Current_Level, 0) AS Battery_Pct,
       coalesce(maint.Maintenance_Status, 'None') AS Maintenance_Flag,
       coalesce(ee.Emergency_Type, 'None') AS Incident_Flag
ORDER BY d.Drone_ID;
