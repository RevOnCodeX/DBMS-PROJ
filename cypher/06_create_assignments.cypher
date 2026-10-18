// ==============================================================================
// 06_create_assignments.cypher
// Create Drone_Operator_Assignment Nodes and Connect to Drone and Operator
// ==============================================================================

UNWIND [
  {
    Assignment_ID: 401,
    Drone_ID: 201,
    Operator_ID: 301,
    Assignment_Date: date('2026-01-10'),
    Assignment_Status: 'COMPLETED',
    Mission_Type: 'Delivery'
  },
  {
    Assignment_ID: 402,
    Drone_ID: 202,
    Operator_ID: 304,
    Assignment_Date: date('2026-01-12'),
    Assignment_Status: 'ACTIVE',
    Mission_Type: 'Surveillance'
  },
  {
    Assignment_ID: 403,
    Drone_ID: 203,
    Operator_ID: 302,
    Assignment_Date: date('2026-01-15'),
    Assignment_Status: 'COMPLETED',
    Mission_Type: 'Surveillance'
  },
  {
    Assignment_ID: 404,
    Drone_ID: 204,
    Operator_ID: 305,
    Assignment_Date: date('2026-01-18'),
    Assignment_Status: 'ACTIVE',
    Mission_Type: 'Agriculture'
  },
  {
    Assignment_ID: 405,
    Drone_ID: 205,
    Operator_ID: 303,
    Assignment_Date: date('2026-01-20'),
    Assignment_Status: 'COMPLETED',
    Mission_Type: 'Agriculture'
  },
  {
    Assignment_ID: 406,
    Drone_ID: 206,
    Operator_ID: 301,
    Assignment_Date: date('2026-01-22'),
    Assignment_Status: 'ACTIVE',
    Mission_Type: 'Disaster'
  }
] AS row
MERGE (a:Drone_Operator_Assignment {Assignment_ID: row.Assignment_ID})
SET a.Drone_ID = row.Drone_ID,
    a.Operator_ID = row.Operator_ID,
    a.Assignment_Date = row.Assignment_Date,
    a.Assignment_Status = row.Assignment_Status,
    a.Mission_Type = row.Mission_Type;

// Connect Drone to Assignment
MATCH (d:Drone)
MATCH (a:Drone_Operator_Assignment)
WHERE d.Drone_ID = a.Drone_ID
MERGE (d)-[:HAS_ASSIGNMENT]->(a);

// Connect Operator to Assignment
MATCH (o:Operator)
MATCH (a:Drone_Operator_Assignment)
WHERE o.Operator_ID = a.Operator_ID
MERGE (o)-[:HAS_ASSIGNMENT]->(a);
