// ==============================================================================
// 07_create_routes.cypher
// Create GPS_Route Nodes with Idempotent MERGE
// ==============================================================================

UNWIND [
  {
    Route_ID: 501,
    Route_Name: 'Chennai Route',
    Start_Location: 'Chennai',
    End_Location: 'Tambaram',
    Route_Distance: 25,
    Route_Status: 'ACTIVE'
  },
  {
    Route_ID: 502,
    Route_Name: 'Bengaluru Route',
    Start_Location: 'Bengaluru',
    End_Location: 'Whitefield',
    Route_Distance: 30,
    Route_Status: 'ACTIVE'
  },
  {
    Route_ID: 503,
    Route_Name: 'Hyderabad Route',
    Start_Location: 'Hyderabad',
    End_Location: 'Secunderabad',
    Route_Distance: 20,
    Route_Status: 'ACTIVE'
  },
  {
    Route_ID: 504,
    Route_Name: 'Coimbatore Route',
    Start_Location: 'Coimbatore',
    End_Location: 'Pollachi',
    Route_Distance: 35,
    Route_Status: 'ACTIVE'
  }
] AS row
MERGE (r:GPS_Route {Route_ID: row.Route_ID})
SET r.Route_Name = row.Route_Name,
    r.Start_Location = row.Start_Location,
    r.End_Location = row.End_Location,
    r.Route_Distance = row.Route_Distance,
    r.Route_Status = row.Route_Status;
