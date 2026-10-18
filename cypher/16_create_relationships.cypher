// ==============================================================================
// 16_create_relationships.cypher
// Master Relationship Builder
// Connects all Graph Nodes based on ER Design and Foreign Key Associations
// All relationships use idempotent MERGE
// ==============================================================================

// 1. Region -> Fleet (CONTAINS)
MATCH (r:Region)
MATCH (f:Fleet)
WHERE f.Region_ID = r.Region_ID
MERGE (r)-[:CONTAINS]->(f);

// 2. Fleet -> Drone (CONTAINS) & Drone -> Fleet (BELONGS_TO)
MATCH (f:Fleet)
MATCH (d:Drone)
WHERE d.Fleet_ID = f.Fleet_ID
MERGE (f)-[:CONTAINS]->(d)
MERGE (d)-[:BELONGS_TO]->(f);

// 3. Operator Specialization Profiles
// Operator -> Human_Pilot
MATCH (o:Operator)
MATCH (hp:Human_Pilot)
WHERE o.Operator_ID = hp.Operator_ID
MERGE (o)-[:HAS_HUMAN_PILOT_PROFILE]->(hp);

// Operator -> AI_Operator
MATCH (o:Operator)
MATCH (aio:AI_Operator)
WHERE o.Operator_ID = aio.Operator_ID
MERGE (o)-[:HAS_AI_OPERATOR_PROFILE]->(aio);

// 4. Drone Operator Assignments
// Drone -> Drone_Operator_Assignment
MATCH (d:Drone)
MATCH (a:Drone_Operator_Assignment)
WHERE d.Drone_ID = a.Drone_ID
MERGE (d)-[:HAS_ASSIGNMENT]->(a);

// Operator -> Drone_Operator_Assignment
MATCH (o:Operator)
MATCH (a:Drone_Operator_Assignment)
WHERE o.Operator_ID = a.Operator_ID
MERGE (o)-[:HAS_ASSIGNMENT]->(a);

// 5. Missions
// Drone -> Mission (PERFORMS and HAS_MISSION)
MATCH (d:Drone)
MATCH (m:Mission)
WHERE d.Drone_ID = m.Drone_ID
MERGE (d)-[:PERFORMS]->(m)
MERGE (d)-[:HAS_MISSION]->(m);

// Operator -> Mission (ASSIGNED_TO)
MATCH (o:Operator)
MATCH (m:Mission)
WHERE o.Operator_ID = m.Operator_ID
MERGE (o)-[:ASSIGNED_TO]->(m);

// Mission -> GPS_Route (FOLLOWS) & GPS_Route -> Mission (USED_BY)
MATCH (m:Mission)
MATCH (r:GPS_Route)
WHERE m.Route_ID = r.Route_ID
MERGE (m)-[:FOLLOWS]->(r)
MERGE (r)-[:USED_BY]->(m);

// 6. Drone -> Battery (HAS_BATTERY_RECORD)
MATCH (d:Drone)
MATCH (b:Battery)
WHERE d.Drone_ID = b.Drone_ID
MERGE (d)-[:HAS_BATTERY_RECORD]->(b);

// 7. Drone -> Maintenance (UNDERGOES)
MATCH (d:Drone)
MATCH (m:Maintenance)
WHERE d.Drone_ID = m.Drone_ID
MERGE (d)-[:UNDERGOES]->(m);

// 8. Charging Stations and Schedules
// Region -> Charging_Station (HAS_CHARGING_STATION)
MATCH (r:Region)
MATCH (cs:Charging_Station)
WHERE r.Region_ID = cs.Region_ID
MERGE (r)-[:HAS_CHARGING_STATION]->(cs);

// Charging_Station -> Charging_Schedule (PROVIDES)
MATCH (cs:Charging_Station)
MATCH (csch:Charging_Schedule)
WHERE cs.Station_ID = csch.Station_ID
MERGE (cs)-[:PROVIDES]->(csch);

// Drone -> Charging_Schedule (SCHEDULED and HAS_CHARGING_SCHEDULE)
MATCH (d:Drone)
MATCH (csch:Charging_Schedule)
WHERE d.Drone_ID = csch.Drone_ID
MERGE (d)-[:SCHEDULED]->(csch)
MERGE (d)-[:HAS_CHARGING_SCHEDULE]->(csch);

// 9. Emergency Events
// Drone -> Emergency_Event (GENERATES)
MATCH (d:Drone)
MATCH (ee:Emergency_Event)
WHERE d.Drone_ID = ee.Drone_ID
MERGE (d)-[:GENERATES]->(ee);

// Mission -> Emergency_Event (HAS_EMERGENCY_EVENT)
MATCH (m:Mission)
MATCH (ee:Emergency_Event)
WHERE m.Mission_ID = ee.Mission_ID
MERGE (m)-[:HAS_EMERGENCY_EVENT]->(ee);

// 10. Flight Permissions
// Mission -> Flight_Permission (REQUIRES)
MATCH (m:Mission)
MATCH (fp:Flight_Permission)
WHERE m.Mission_ID = fp.Mission_ID
MERGE (m)-[:REQUIRES]->(fp);

// Drone -> Flight_Permission (HAS_FLIGHT_PERMISSION)
MATCH (d:Drone)
MATCH (fp:Flight_Permission)
WHERE d.Drone_ID = fp.Drone_ID
MERGE (d)-[:HAS_FLIGHT_PERMISSION]->(fp);

RETURN "All master graph relationships successfully established!" AS Status;
