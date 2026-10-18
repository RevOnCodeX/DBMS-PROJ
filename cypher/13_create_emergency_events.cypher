// ==============================================================================
// 13_create_emergency_events.cypher
// Create Emergency_Event Nodes and Connect to Drone and Mission
// ==============================================================================

UNWIND [
  {
    Event_ID: 1001,
    Drone_ID: 203,
    Mission_ID: 606,
    Emergency_Type: 'COMMUNICATION FAILURE',
    Emergency_Date: date('2026-02-20'),
    Emergency_Description: 'Signal lost',
    Resolution_Status: 'RESOLVED'
  },
  {
    Event_ID: 1002,
    Drone_ID: 206,
    Mission_ID: 612,
    Emergency_Type: 'EMERGENCY LANDING',
    Emergency_Date: date('2026-03-20'),
    Emergency_Description: 'Heavy rain',
    Resolution_Status: 'RESOLVED'
  },
  {
    Event_ID: 1003,
    Drone_ID: 204,
    Mission_ID: 608,
    Emergency_Type: 'BATTERY FAILURE',
    Emergency_Date: date('2026-03-01'),
    Emergency_Description: 'Low battery',
    Resolution_Status: 'RESOLVED'
  }
] AS row
MERGE (ee:Emergency_Event {Event_ID: row.Event_ID})
SET ee.Drone_ID = row.Drone_ID,
    ee.Mission_ID = row.Mission_ID,
    ee.Emergency_Type = row.Emergency_Type,
    ee.Emergency_Date = row.Emergency_Date,
    ee.Emergency_Description = row.Emergency_Description,
    ee.Resolution_Status = row.Resolution_Status;

// Connect Drone to Emergency_Event (GENERATES)
MATCH (d:Drone)
MATCH (ee:Emergency_Event)
WHERE d.Drone_ID = ee.Drone_ID
MERGE (d)-[:GENERATES]->(ee);

// Connect Mission to Emergency_Event (HAS_EMERGENCY_EVENT)
MATCH (m:Mission)
MATCH (ee:Emergency_Event)
WHERE m.Mission_ID = ee.Mission_ID
MERGE (m)-[:HAS_EMERGENCY_EVENT]->(ee);
