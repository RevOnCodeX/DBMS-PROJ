// ==============================================================================
// 15_create_technicians.cypher
// Technician Node Schema & Connection Script
// ==============================================================================

// Source Verification Note:
// The ER diagram defines the Technician entity and the relationship (:Technician)-[:PERFORMS]->(:Maintenance).
// However, the handwritten SQL definitions and the executed Oracle database (Question 2)
// did not include sample insert statements or a relational table for Technician.
// As instructed by the assignment requirements, we do NOT fabricate artificial sample technicians.
// The uniqueness constraint for Technician is established in 01_constraints.cypher.
// Below is the standardized template for creating Technician nodes and linking them
// to Maintenance records whenever official data is provided.

/*
// Template for inserting verified technician data:
UNWIND [
  // {Technician_ID: 1201, Technician_Name: 'Name', Qualification: 'Avionics Cert', Contact_No: '9876543220', Email: 'tech1@drone.com', Maintenance_ID: 801}
] AS row
MERGE (t:Technician {Technician_ID: row.Technician_ID})
SET t.Technician_Name = row.Technician_Name,
    t.Qualification = row.Qualification,
    t.Contact_No = row.Contact_No,
    t.Email = row.Email;

// Connect Technician to Maintenance (PERFORMS)
MATCH (t:Technician)
MATCH (m:Maintenance)
WHERE t.Maintenance_ID = m.Maintenance_ID
MERGE (t)-[:PERFORMS]->(m);
*/

RETURN "Technician schema prepared; no sample records fabricated as per source verification" AS Status;
