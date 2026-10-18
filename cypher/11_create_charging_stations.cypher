// ==============================================================================
// 11_create_charging_stations.cypher
// Create Charging_Station Nodes and Connect to Region
// ==============================================================================

UNWIND [
  {
    Station_ID: 901,
    Station_Name: 'Chennai Station',
    Region_ID: 1,
    Location: 'Chennai',
    Charging_Capacity: 4,
    Station_Status: 'AVAILABLE'
  },
  {
    Station_ID: 902,
    Station_Name: 'Bengaluru Station',
    Region_ID: 2,
    Location: 'Bengaluru',
    Charging_Capacity: 3,
    Station_Status: 'AVAILABLE'
  },
  {
    Station_ID: 903,
    Station_Name: 'Hyderabad Station',
    Region_ID: 3,
    Location: 'Hyderabad',
    Charging_Capacity: 4,
    Station_Status: 'OCCUPIED'
  },
  {
    Station_ID: 904,
    Station_Name: 'Coimbatore Station',
    Region_ID: 4,
    Location: 'Coimbatore',
    Charging_Capacity: 2,
    Station_Status: 'AVAILABLE'
  }
] AS row
MERGE (cs:Charging_Station {Station_ID: row.Station_ID})
SET cs.Station_Name = row.Station_Name,
    cs.Region_ID = row.Region_ID,
    cs.Location = row.Location,
    cs.Charging_Capacity = row.Charging_Capacity,
    cs.Station_Status = row.Station_Status;

// Connect Region to Charging_Station (Foreign Key: Station.Region_ID -> Region.Region_ID)
MATCH (r:Region)
MATCH (cs:Charging_Station)
WHERE r.Region_ID = cs.Region_ID
MERGE (r)-[:HAS_CHARGING_STATION]->(cs);
