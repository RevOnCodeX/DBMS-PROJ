// ==============================================================================
// 10_create_maintenance.cypher
// Create Maintenance Nodes and Connect to Drone
// ==============================================================================

UNWIND [
  {
    Maintenance_ID: 801,
    Drone_ID: 201,
    Maintenance_Type: 'Sensor Calibration',
    Maintenance_Date: date('2026-01-05'),
    Maintenance_Status: 'COMPLETED',
    Maintenance_Description: 'Routine calibration'
  },
  {
    Maintenance_ID: 802,
    Drone_ID: 202,
    Maintenance_Type: 'Battery Check',
    Maintenance_Date: date('2026-02-10'),
    Maintenance_Status: 'COMPLETED',
    Maintenance_Description: 'Battery inspection'
  },
  {
    Maintenance_ID: 803,
    Drone_ID: 204,
    Maintenance_Type: 'Motor Repair',
    Maintenance_Date: date('2026-03-02'),
    Maintenance_Status: 'IN_PROGRESS',
    Maintenance_Description: 'Motor replacement'
  },
  {
    Maintenance_ID: 804,
    Drone_ID: 205,
    Maintenance_Type: 'Firmware Update',
    Maintenance_Date: date('2026-03-08'),
    Maintenance_Status: 'COMPLETED',
    Maintenance_Description: 'Software update'
  },
  {
    Maintenance_ID: 805,
    Drone_ID: 206,
    Maintenance_Type: 'Sensor Calibration',
    Maintenance_Date: date('2026-03-12'),
    Maintenance_Status: 'COMPLETED',
    Maintenance_Description: 'Sensor calibration'
  }
] AS row
MERGE (m:Maintenance {Maintenance_ID: row.Maintenance_ID})
SET m.Drone_ID = row.Drone_ID,
    m.Maintenance_Type = row.Maintenance_Type,
    m.Maintenance_Date = row.Maintenance_Date,
    m.Maintenance_Status = row.Maintenance_Status,
    m.Maintenance_Description = row.Maintenance_Description;

// Connect Drone to Maintenance (UNDERGOES)
MATCH (d:Drone)
MATCH (m:Maintenance)
WHERE d.Drone_ID = m.Drone_ID
MERGE (d)-[:UNDERGOES]->(m);
