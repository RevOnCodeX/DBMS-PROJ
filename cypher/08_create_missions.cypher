// ==============================================================================
// 08_create_missions.cypher
// Create Mission Nodes and Connect to Drone, Operator, and GPS_Route
// ==============================================================================

UNWIND [
  {
    Mission_ID: 601,
    Drone_ID: 201,
    Operator_ID: 301,
    Route_ID: 501,
    Mission_Objective: 'Package Delivery',
    Mission_Date: date('2026-02-01'),
    Weather_Conditions: 'Clear',
    Payload_Information: 'Medical Package',
    Battery_Usage: 20,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 602,
    Drone_ID: 201,
    Operator_ID: 301,
    Route_ID: 501,
    Mission_Objective: 'Package Delivery',
    Mission_Date: date('2026-02-05'),
    Weather_Conditions: 'Cloudy',
    Payload_Information: 'Food Package',
    Battery_Usage: 25,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 603,
    Drone_ID: 202,
    Operator_ID: 304,
    Route_ID: 501,
    Mission_Objective: 'Aerial Survey',
    Mission_Date: date('2026-02-08'),
    Weather_Conditions: 'Clear',
    Payload_Information: 'Camera',
    Battery_Usage: 30,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 604,
    Drone_ID: 202,
    Operator_ID: 304,
    Route_ID: 502,
    Mission_Objective: 'Aerial Survey',
    Mission_Date: date('2026-02-12'),
    Weather_Conditions: 'Windy',
    Payload_Information: 'Camera',
    Battery_Usage: 35,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 605,
    Drone_ID: 203,
    Operator_ID: 302,
    Route_ID: 502,
    Mission_Objective: 'Surveillance',
    Mission_Date: date('2026-02-15'),
    Weather_Conditions: 'Clear',
    Payload_Information: 'Camera',
    Battery_Usage: 20,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 606,
    Drone_ID: 203,
    Operator_ID: 302,
    Route_ID: 503,
    Mission_Objective: 'Surveillance',
    Mission_Date: date('2026-02-20'),
    Weather_Conditions: 'Cloudy',
    Payload_Information: 'Camera',
    Battery_Usage: 25,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 607,
    Drone_ID: 203,
    Operator_ID: 302,
    Route_ID: 503,
    Mission_Objective: 'Surveillance',
    Mission_Date: date('2026-02-25'),
    Weather_Conditions: 'Clear',
    Payload_Information: 'Camera',
    Battery_Usage: 30,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 608,
    Drone_ID: 204,
    Operator_ID: 305,
    Route_ID: 504,
    Mission_Objective: 'Crop Monitoring',
    Mission_Date: date('2026-03-01'),
    Weather_Conditions: 'Clear',
    Payload_Information: 'Sensors',
    Battery_Usage: 40,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 609,
    Drone_ID: 205,
    Operator_ID: 303,
    Route_ID: 504,
    Mission_Objective: 'Crop Monitoring',
    Mission_Date: date('2026-03-05'),
    Weather_Conditions: 'Clear',
    Payload_Information: 'Sensors',
    Battery_Usage: 25,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 610,
    Drone_ID: 205,
    Operator_ID: 303,
    Route_ID: 504,
    Mission_Objective: 'Crop Monitoring',
    Mission_Date: date('2026-03-10'),
    Weather_Conditions: 'Cloudy',
    Payload_Information: 'Sensors',
    Battery_Usage: 30,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 611,
    Drone_ID: 205,
    Operator_ID: 303,
    Route_ID: 504,
    Mission_Objective: 'Crop Monitoring',
    Mission_Date: date('2026-03-15'),
    Weather_Conditions: 'Clear',
    Payload_Information: 'Sensors',
    Battery_Usage: 35,
    Mission_Status: 'COMPLETED'
  },
  {
    Mission_ID: 612,
    Drone_ID: 206,
    Operator_ID: 301,
    Route_ID: 503,
    Mission_Objective: 'Disaster Survey',
    Mission_Date: date('2026-03-20'),
    Weather_Conditions: 'Rainy',
    Payload_Information: 'Camera',
    Battery_Usage: 20,
    Mission_Status: 'COMPLETED'
  }
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

// Connect Drone to Mission (PERFORMS)
MATCH (d:Drone)
MATCH (m:Mission)
WHERE d.Drone_ID = m.Drone_ID
MERGE (d)-[:PERFORMS]->(m);

// Connect Operator to Mission (ASSIGNED_TO)
MATCH (o:Operator)
MATCH (m:Mission)
WHERE o.Operator_ID = m.Operator_ID
MERGE (o)-[:ASSIGNED_TO]->(m);

// Connect Mission to GPS_Route (FOLLOWS)
MATCH (m:Mission)
MATCH (r:GPS_Route)
WHERE m.Route_ID = r.Route_ID
MERGE (m)-[:FOLLOWS]->(r);
