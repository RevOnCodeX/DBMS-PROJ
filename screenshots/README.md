# Screenshots & Visual Verification Guide

This directory contains the visual artifacts and verification records for the **Drone Fleet Management Database in Neo4j**.

---

## 1. Source Database Terminal Screenshots

The PNG files in this directory (`screen_page_1.png` to `screen_page_8.png`) were extracted directly from the verified coursework submission (`Dbms DA2 ques 2 screenshots.pdf`).

- `screen_page_1.png`: Table schema `DESC` commands for `REGION`, `FLEET`, `DRONE`, `OPERATOR`, `HUMAN_PILOT`, `AI_OPERATOR`, `DRONE_OPERATOR_ASSIGNMENT`, and `GPS_ROUTE`.
- `screen_page_2.png`: Table schema `DESC` commands for `MISSION`, `BATTERY`, `MAINTENANCE`, `CHARGING_STATION`, `CHARGING_SCHEDULE`, `EMERGENCY_EVENT`, and `FLIGHT_PERMISSION`.
- `screen_page_3.png`: Query output `SELECT *` for `REGION`, `FLEET`, `DRONE`, `OPERATOR`, `HUMAN_PILOT`, `AI_OPERATOR`, `DRONE_OPERATOR_ASSIGNMENT`, and `GPS_ROUTE`.
- `screen_page_4.png`: Query output `SELECT *` for `BATTERY`, `MAINTENANCE`, `CHARGING_STATION`, `CHARGING_SCHEDULE`, `EMERGENCY_EVENT`, and `FLIGHT_PERMISSION`.
- `screen_page_5.png`: Complete query output `SELECT *` for `MISSION` (all 12 records) and DML verification.
- `screen_page_6.png` - `screen_page_8.png`: DML tests (INSERT, SELECT, UPDATE, DELETE) executed on test rows.

---

## 2. Generating Neo4j Graph Visualizations

To capture graph visualizations for your college practical exam or project report:

1. Open Neo4j Browser at: [http://localhost:7474](http://localhost:7474)
2. Log in with:
   - **Username:** `neo4j`
   - **Password:** `dronepassword`

### Recommended Cypher Queries for Visual Demonstration:

1. **Complete Database Overview (All Nodes & Relationships):**
   ```cypher
   MATCH (n) RETURN n LIMIT 100;
   ```

2. **Schema & Metamodel Graph Visualization:**
   ```cypher
   CALL db.schema.visualization();
   ```

3. **Drone 360-Degree Operational Network (Drone 204):**
   ```cypher
   MATCH (d:Drone {Drone_ID: 204})-[r]-(connected)
   RETURN d, r, connected;
   ```

4. **Drone Flight Missions & Operators Network:**
   ```cypher
   MATCH (o:Operator)-[r1:ASSIGNED_TO]->(m:Mission)<-[r2:PERFORMS]-(d:Drone)
   MATCH (m)-[r3:FOLLOWS]->(route:GPS_Route)
   RETURN o, r1, m, r2, d, r3, route;
   ```

5. **Regional Infrastructure & Fleets:**
   ```cypher
   MATCH (r:Region)-[:CONTAINS]->(f:Fleet)-[:CONTAINS]->(d:Drone)
   MATCH (r)-[:HAS_CHARGING_STATION]->(cs:Charging_Station)
   RETURN r, f, d, cs;
   ```

Use the **Export PNG** / **Export SVG** button in the top-right corner of each visualization cell in Neo4j Browser to save high-resolution screenshots.
