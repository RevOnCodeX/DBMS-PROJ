// ==============================================================================
// 01_constraints.cypher
// Drone Fleet Management Database in Neo4j
// Constraints & Schema Definitions
// ==============================================================================

// 1. Region
CREATE CONSTRAINT region_id_unique IF NOT EXISTS
FOR (r:Region) REQUIRE r.Region_ID IS UNIQUE;

// 2. Fleet
CREATE CONSTRAINT fleet_id_unique IF NOT EXISTS
FOR (f:Fleet) REQUIRE f.Fleet_ID IS UNIQUE;

// 3. Drone
CREATE CONSTRAINT drone_id_unique IF NOT EXISTS
FOR (d:Drone) REQUIRE d.Drone_ID IS UNIQUE;

// 4. Operator
CREATE CONSTRAINT operator_id_unique IF NOT EXISTS
FOR (o:Operator) REQUIRE o.Operator_ID IS UNIQUE;

// 5. Human_Pilot (Specialized profile associated with Operator)
CREATE CONSTRAINT human_pilot_operator_id_unique IF NOT EXISTS
FOR (hp:Human_Pilot) REQUIRE hp.Operator_ID IS UNIQUE;

// 6. AI_Operator (Specialized profile associated with Operator)
CREATE CONSTRAINT ai_operator_operator_id_unique IF NOT EXISTS
FOR (aio:AI_Operator) REQUIRE aio.Operator_ID IS UNIQUE;

// 7. Drone_Operator_Assignment
CREATE CONSTRAINT assignment_id_unique IF NOT EXISTS
FOR (doa:Drone_Operator_Assignment) REQUIRE doa.Assignment_ID IS UNIQUE;

// 8. GPS_Route
CREATE CONSTRAINT route_id_unique IF NOT EXISTS
FOR (gr:GPS_Route) REQUIRE gr.Route_ID IS UNIQUE;

// 9. Mission
CREATE CONSTRAINT mission_id_unique IF NOT EXISTS
FOR (m:Mission) REQUIRE m.Mission_ID IS UNIQUE;

// 10. Battery
CREATE CONSTRAINT battery_id_unique IF NOT EXISTS
FOR (b:Battery) REQUIRE b.Battery_ID IS UNIQUE;

// 11. Maintenance
CREATE CONSTRAINT maintenance_id_unique IF NOT EXISTS
FOR (m:Maintenance) REQUIRE m.Maintenance_ID IS UNIQUE;

// 12. Charging_Station
CREATE CONSTRAINT station_id_unique IF NOT EXISTS
FOR (cs:Charging_Station) REQUIRE cs.Station_ID IS UNIQUE;

// 13. Charging_Schedule
CREATE CONSTRAINT charging_schedule_id_unique IF NOT EXISTS
FOR (csch:Charging_Schedule) REQUIRE csch.Schedule_ID IS UNIQUE;

// 14. Emergency_Event
CREATE CONSTRAINT emergency_event_id_unique IF NOT EXISTS
FOR (ee:Emergency_Event) REQUIRE ee.Event_ID IS UNIQUE;

// 15. Flight_Permission
CREATE CONSTRAINT flight_permission_id_unique IF NOT EXISTS
FOR (fp:Flight_Permission) REQUIRE fp.Permission_ID IS UNIQUE;

// 16. Technician
CREATE CONSTRAINT technician_id_unique IF NOT EXISTS
FOR (t:Technician) REQUIRE t.Technician_ID IS UNIQUE;
