// ==============================================================================
// 04_create_operators.cypher
// Create Operator Nodes with Idempotent MERGE
// ==============================================================================

UNWIND [
  {
    Operator_ID: 301,
    Operator_Name: 'Rahul',
    Operator_Type: 'HUMAN',
    Contact_No: '9876543210',
    Email: 'rahul@gmail.com',
    Certification_Status: 'CERTIFIED'
  },
  {
    Operator_ID: 302,
    Operator_Name: 'Priya',
    Operator_Type: 'HUMAN',
    Contact_No: '9876543211',
    Email: 'priya@gmail.com',
    Certification_Status: 'CERTIFIED'
  },
  {
    Operator_ID: 303,
    Operator_Name: 'Arun',
    Operator_Type: 'HUMAN',
    Contact_No: '9876543212',
    Email: 'arun@gmail.com',
    Certification_Status: 'CERTIFIED'
  },
  {
    Operator_ID: 304,
    Operator_Name: 'DroneAI-01',
    Operator_Type: 'AI',
    Contact_No: '9876543213',
    Email: 'ai01@drone.com',
    Certification_Status: 'CERTIFIED'
  },
  {
    Operator_ID: 305,
    Operator_Name: 'DroneAI-02',
    Operator_Type: 'AI',
    Contact_No: '9876543214',
    Email: 'ai02@drone.com',
    Certification_Status: 'CERTIFIED'
  }
] AS row
MERGE (o:Operator {Operator_ID: row.Operator_ID})
SET o.Operator_Name = row.Operator_Name,
    o.Operator_Type = row.Operator_Type,
    o.Contact_No = row.Contact_No,
    o.Email = row.Email,
    o.Certification_Status = row.Certification_Status;
