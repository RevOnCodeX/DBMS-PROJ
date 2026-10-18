// ==============================================================================
// 14_create_flight_permissions.cypher
// Create Flight_Permission Nodes and Connect to Mission and Drone
// ==============================================================================

UNWIND [
  {
    Permission_ID: 1101,
    Drone_ID: 201,
    Mission_ID: 601,
    Issued_Date: date('2026-01-25'),
    Expiry_Date: date('2026-12-31'),
    Permission_Status: 'APPROVED',
    Issuing_Authority: 'DGCA'
  },
  {
    Permission_ID: 1102,
    Drone_ID: 202,
    Mission_ID: 603,
    Issued_Date: date('2026-01-25'),
    Expiry_Date: date('2026-12-31'),
    Permission_Status: 'APPROVED',
    Issuing_Authority: 'DGCA'
  },
  {
    Permission_ID: 1103,
    Drone_ID: 203,
    Mission_ID: 605,
    Issued_Date: date('2026-01-25'),
    Expiry_Date: date('2026-12-31'),
    Permission_Status: 'APPROVED',
    Issuing_Authority: 'DGCA'
  },
  {
    Permission_ID: 1104,
    Drone_ID: 204,
    Mission_ID: 608,
    Issued_Date: date('2026-01-25'),
    Expiry_Date: date('2026-12-31'),
    Permission_Status: 'APPROVED',
    Issuing_Authority: 'DGCA'
  },
  {
    Permission_ID: 1105,
    Drone_ID: 205,
    Mission_ID: 609,
    Issued_Date: date('2026-01-25'),
    Expiry_Date: date('2026-12-31'),
    Permission_Status: 'APPROVED',
    Issuing_Authority: 'DGCA'
  },
  {
    Permission_ID: 1106,
    Drone_ID: 206,
    Mission_ID: 612,
    Issued_Date: date('2026-01-25'),
    Expiry_Date: date('2026-12-31'),
    Permission_Status: 'APPROVED',
    Issuing_Authority: 'DGCA'
  }
] AS row
MERGE (fp:Flight_Permission {Permission_ID: row.Permission_ID})
SET fp.Drone_ID = row.Drone_ID,
    fp.Mission_ID = row.Mission_ID,
    fp.Issued_Date = row.Issued_Date,
    fp.Expiry_Date = row.Expiry_Date,
    fp.Permission_Status = row.Permission_Status,
    fp.Issuing_Authority = row.Issuing_Authority;

// Connect Mission to Flight_Permission (REQUIRES)
MATCH (m:Mission)
MATCH (fp:Flight_Permission)
WHERE m.Mission_ID = fp.Mission_ID
MERGE (m)-[:REQUIRES]->(fp);

// Connect Drone to Flight_Permission (HAS_FLIGHT_PERMISSION)
MATCH (d:Drone)
MATCH (fp:Flight_Permission)
WHERE d.Drone_ID = fp.Drone_ID
MERGE (d)-[:HAS_FLIGHT_PERMISSION]->(fp);
