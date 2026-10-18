// ==============================================================================
// 09_create_batteries.cypher
// Create Battery Nodes and Connect to Drone
// ==============================================================================

UNWIND [
  {
    Battery_ID: 701,
    Drone_ID: 201,
    Battery_Type: 'Lithium',
    Battery_Capacity: 100,
    Current_Level: 80,
    Battery_Status: 'NORMAL',
    Last_Updated: date('2026-03-20')
  },
  {
    Battery_ID: 702,
    Drone_ID: 202,
    Battery_Type: 'Lithium',
    Battery_Capacity: 120,
    Current_Level: 65,
    Battery_Status: 'NORMAL',
    Last_Updated: date('2026-03-20')
  },
  {
    Battery_ID: 703,
    Drone_ID: 203,
    Battery_Type: 'Lithium',
    Battery_Capacity: 90,
    Current_Level: 45,
    Battery_Status: 'NORMAL',
    Last_Updated: date('2026-03-20')
  },
  {
    Battery_ID: 704,
    Drone_ID: 204,
    Battery_Type: 'Lithium',
    Battery_Capacity: 150,
    Current_Level: 25,
    Battery_Status: 'LOW',
    Last_Updated: date('2026-03-20')
  },
  {
    Battery_ID: 705,
    Drone_ID: 205,
    Battery_Type: 'Lithium',
    Battery_Capacity: 110,
    Current_Level: 90,
    Battery_Status: 'FULL',
    Last_Updated: date('2026-03-20')
  },
  {
    Battery_ID: 706,
    Drone_ID: 206,
    Battery_Type: 'Lithium',
    Battery_Capacity: 80,
    Current_Level: 15,
    Battery_Status: 'CRITICAL',
    Last_Updated: date('2026-03-20')
  }
] AS row
MERGE (b:Battery {Battery_ID: row.Battery_ID})
SET b.Drone_ID = row.Drone_ID,
    b.Battery_Type = row.Battery_Type,
    b.Battery_Capacity = row.Battery_Capacity,
    b.Current_Level = row.Current_Level,
    b.Battery_Status = row.Battery_Status,
    b.Last_Updated = row.Last_Updated;

// Connect Drone to Battery (HAS_BATTERY_RECORD)
MATCH (d:Drone)
MATCH (b:Battery)
WHERE d.Drone_ID = b.Drone_ID
MERGE (d)-[:HAS_BATTERY_RECORD]->(b);
