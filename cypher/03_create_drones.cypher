// ==============================================================================
// 03_create_drones.cypher
// Create Drone Nodes with Idempotent MERGE
// ==============================================================================

UNWIND [
  {
    Drone_ID: 201,
    Drone_Model: 'DJI M30',
    Fleet_ID: 101,
    Payload_Capacity: 10,
    Battery_Capacity: 100,
    Operational_Status: 'ACTIVE',
    Drone_Type: 'Semi-Autonomous',
    Manufacture_Date: date('2024-01-10')
  },
  {
    Drone_ID: 202,
    Drone_Model: 'DJI M350',
    Fleet_ID: 101,
    Payload_Capacity: 15,
    Battery_Capacity: 120,
    Operational_Status: 'ACTIVE',
    Drone_Type: 'Autonomous',
    Manufacture_Date: date('2024-03-15')
  },
  {
    Drone_ID: 203,
    Drone_Model: 'Skydio X2',
    Fleet_ID: 102,
    Payload_Capacity: 8,
    Battery_Capacity: 90,
    Operational_Status: 'ACTIVE',
    Drone_Type: 'Autonomous',
    Manufacture_Date: date('2023-06-20')
  },
  {
    Drone_ID: 204,
    Drone_Model: 'Agras T40',
    Fleet_ID: 103,
    Payload_Capacity: 20,
    Battery_Capacity: 150,
    Operational_Status: 'MAINTENANCE',
    Drone_Type: 'Semi-Autonomous',
    Manufacture_Date: date('2024-02-12')
  },
  {
    Drone_ID: 205,
    Drone_Model: 'Autel EVO',
    Fleet_ID: 103,
    Payload_Capacity: 12,
    Battery_Capacity: 110,
    Operational_Status: 'ACTIVE',
    Drone_Type: 'Autonomous',
    Manufacture_Date: date('2023-11-05')
  },
  {
    Drone_ID: 206,
    Drone_Model: 'Parrot Anafi',
    Fleet_ID: 104,
    Payload_Capacity: 5,
    Battery_Capacity: 80,
    Operational_Status: 'ACTIVE',
    Drone_Type: 'Semi-Autonomous',
    Manufacture_Date: date('2024-05-18')
  }
] AS row
MERGE (d:Drone {Drone_ID: row.Drone_ID})
SET d.Drone_Model = row.Drone_Model,
    d.Fleet_ID = row.Fleet_ID,
    d.Payload_Capacity = row.Payload_Capacity,
    d.Battery_Capacity = row.Battery_Capacity,
    d.Operational_Status = row.Operational_Status,
    d.Drone_Type = row.Drone_Type,
    d.Manufacture_Date = row.Manufacture_Date;
