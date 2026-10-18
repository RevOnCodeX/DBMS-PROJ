// ==============================================================================
// 12_create_charging_schedules.cypher
// Create Charging_Schedule Nodes and Connect to Charging_Station and Drone
// ==============================================================================

// Note on Identifier and Station_ID reconciliation:
// The handwritten draft on page 4 had values starting with 901..905.
// However, the executed SQL database (verified from Oracle terminal screenshot 4)
// reveals that the first column is STATION_ID (901, 901, 902, 903, 904)
// referencing valid stations 901 (Chennai), 902 (Bengaluru), 903 (Hyderabad), 904 (Coimbatore).
// To satisfy the entity inventory's Schedule_ID requirement while faithfully
// maintaining the verified Station_ID foreign keys, we assign stable Schedule_ID values (1..5)
// and connect each schedule to its proper Station and Drone.

UNWIND [
  {
    Schedule_ID: 1,
    Draft_ID: 901,
    Station_ID: 901,
    Drone_ID: 201,
    Schedule_Date: date('2026-03-21'),
    Start_Time: '09:00',
    End_Time: '11:00',
    Charging_Status: 'COMPLETED'
  },
  {
    Schedule_ID: 2,
    Draft_ID: 902,
    Station_ID: 901,
    Drone_ID: 202,
    Schedule_Date: date('2026-03-21'),
    Start_Time: '11:00',
    End_Time: '13:00',
    Charging_Status: 'SCHEDULED'
  },
  {
    Schedule_ID: 3,
    Draft_ID: 903,
    Station_ID: 902,
    Drone_ID: 203,
    Schedule_Date: date('2026-03-21'),
    Start_Time: '10:00',
    End_Time: '12:00',
    Charging_Status: 'COMPLETED'
  },
  {
    Schedule_ID: 4,
    Draft_ID: 904,
    Station_ID: 903,
    Drone_ID: 204,
    Schedule_Date: date('2026-03-21'),
    Start_Time: '14:00',
    End_Time: '16:00',
    Charging_Status: 'SCHEDULED'
  },
  {
    Schedule_ID: 5,
    Draft_ID: 905,
    Station_ID: 904,
    Drone_ID: 205,
    Schedule_Date: date('2026-03-21'),
    Start_Time: '09:00',
    End_Time: '11:00',
    Charging_Status: 'COMPLETED'
  }
] AS row
MERGE (csch:Charging_Schedule {Schedule_ID: row.Schedule_ID})
SET csch.Draft_ID = row.Draft_ID,
    csch.Station_ID = row.Station_ID,
    csch.Drone_ID = row.Drone_ID,
    csch.Schedule_Date = row.Schedule_Date,
    csch.Start_Time = row.Start_Time,
    csch.End_Time = row.End_Time,
    csch.Charging_Status = row.Charging_Status;

// Connect Charging_Station to Charging_Schedule (PROVIDES)
MATCH (cs:Charging_Station)
MATCH (csch:Charging_Schedule)
WHERE cs.Station_ID = csch.Station_ID
MERGE (cs)-[:PROVIDES]->(csch);

// Connect Drone to Charging_Schedule (SCHEDULED and HAS_CHARGING_SCHEDULE)
MATCH (d:Drone)
MATCH (csch:Charging_Schedule)
WHERE d.Drone_ID = csch.Drone_ID
MERGE (d)-[:SCHEDULED]->(csch)
MERGE (d)-[:HAS_CHARGING_SCHEDULE]->(csch);
