// ==============================================================================
// 02_create_regions_and_fleets.cypher
// Create Region and Fleet Nodes with Idempotent MERGE
// ==============================================================================

// 1. Create Regions
UNWIND [
  {Region_ID: 1, Region_Name: 'Chennai', Region_Type: 'Urban', Location: 'Tamil Nadu'},
  {Region_ID: 2, Region_Name: 'Bengaluru', Region_Type: 'Urban', Location: 'Karnataka'},
  {Region_ID: 3, Region_Name: 'Hyderabad', Region_Type: 'Urban', Location: 'Telangana'},
  {Region_ID: 4, Region_Name: 'Coimbatore', Region_Type: 'Industrial', Location: 'Tamil Nadu'}
] AS row
MERGE (r:Region {Region_ID: row.Region_ID})
SET r.Region_Name = row.Region_Name,
    r.Region_Type = row.Region_Type,
    r.Location = row.Location;

// 2. Create Fleets
UNWIND [
  {Fleet_ID: 101, Fleet_Name: 'Fleet-A', Region_ID: 1, Fleet_Type: 'Delivery', Fleet_Status: 'ACTIVE'},
  {Fleet_ID: 102, Fleet_B: 'Fleet-B', Fleet_Name: 'Fleet-B', Region_ID: 2, Fleet_Type: 'Surveillance', Fleet_Status: 'ACTIVE'},
  {Fleet_ID: 103, Fleet_Name: 'Fleet-C', Region_ID: 3, Fleet_Type: 'Agriculture', Fleet_Status: 'ACTIVE'},
  {Fleet_ID: 104, Fleet_Name: 'Fleet-D', Region_ID: 4, Fleet_Type: 'Disaster', Fleet_Status: 'ACTIVE'}
] AS row
MERGE (f:Fleet {Fleet_ID: row.Fleet_ID})
SET f.Fleet_Name = row.Fleet_Name,
    f.Region_ID = row.Region_ID,
    f.Fleet_Type = row.Fleet_Type,
    f.Fleet_Status = row.Fleet_Status;

// 3. Connect Region to Fleet (Foreign Key: Fleet.Region_ID -> Region.Region_ID)
MATCH (r:Region)
MATCH (f:Fleet)
WHERE f.Region_ID = r.Region_ID
MERGE (r)-[:CONTAINS]->(f);
