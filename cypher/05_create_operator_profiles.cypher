// ==============================================================================
// 05_create_operator_profiles.cypher
// Create Human_Pilot and AI_Operator Nodes and Connect to Operator
// ==============================================================================

// 1. Create Human_Pilot Profile Nodes
UNWIND [
  {
    Operator_ID: 301,
    License_No: 'LIC101',
    Certification_Date: date('2024-01-01'),
    Certification_Expiry: date('2027-01-01'),
    Pilot_Rating: 'Advanced'
  },
  {
    Operator_ID: 302,
    License_No: 'LIC102',
    Certification_Date: date('2024-02-01'),
    Certification_Expiry: date('2027-02-01'),
    Pilot_Rating: 'Advanced'
  },
  {
    Operator_ID: 303,
    License_No: 'LIC103',
    Certification_Date: date('2024-03-01'),
    Certification_Expiry: date('2027-03-01'),
    Pilot_Rating: 'Expert'
  }
] AS row
MERGE (hp:Human_Pilot {Operator_ID: row.Operator_ID})
SET hp.License_No = row.License_No,
    hp.Certification_Date = row.Certification_Date,
    hp.Certification_Expiry = row.Certification_Expiry,
    hp.Pilot_Rating = row.Pilot_Rating;

// Connect Operator to Human_Pilot
MATCH (o:Operator)
MATCH (hp:Human_Pilot)
WHERE o.Operator_ID = hp.Operator_ID
MERGE (o)-[:HAS_HUMAN_PILOT_PROFILE]->(hp);

// 2. Create AI_Operator Profile Nodes
UNWIND [
  {
    Operator_ID: 304,
    AI_Version: 'AI-2.1',
    Certification_Status: 'CERTIFIED',
    Autonomy_Level: 'HIGH'
  },
  {
    Operator_ID: 305,
    AI_Version: 'AI-3.0',
    Certification_Status: 'CERTIFIED',
    Autonomy_Level: 'FULL'
  }
] AS row
MERGE (aio:AI_Operator {Operator_ID: row.Operator_ID})
SET aio.AI_Version = row.AI_Version,
    aio.Certification_Status = row.Certification_Status,
    aio.Autonomy_Level = row.Autonomy_Level;

// Connect Operator to AI_Operator
MATCH (o:Operator)
MATCH (aio:AI_Operator)
WHERE o.Operator_ID = aio.Operator_ID
MERGE (o)-[:HAS_AI_OPERATOR_PROFILE]->(aio);
