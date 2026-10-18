# Cypher Scripts Directory Guide

This directory contains the complete Cypher script suite for the **Drone Fleet Management Database in Neo4j**. All scripts use idempotent `MERGE` statements so they can be re-executed multiple times without creating duplicate nodes or relationships.

---

## 1. Quick Execution Options

### Option A: Master Single-File Seed (Fastest)
Execute the unified master seed script that runs all constraints, nodes, and relationships in one operation:
```bash
docker exec -i neo4j-drone cypher-shell -u neo4j -p dronepassword < cypher/00_all_in_one_seed.cypher
```
Or paste the contents of [`00_all_in_one_seed.cypher`](00_all_in_one_seed.cypher) directly into the Neo4j Browser at [http://localhost:7474](http://localhost:7474).

### Option B: Step-by-Step Modular Execution
Execute scripts in the following exact sequence:
```bash
SCRIPTS=(
  "01_constraints.cypher"
  "02_create_regions_and_fleets.cypher"
  "03_create_drones.cypher"
  "04_create_operators.cypher"
  "05_create_operator_profiles.cypher"
  "06_create_assignments.cypher"
  "07_create_routes.cypher"
  "08_create_missions.cypher"
  "09_create_batteries.cypher"
  "10_create_maintenance.cypher"
  "11_create_charging_stations.cypher"
  "12_create_charging_schedules.cypher"
  "13_create_emergency_events.cypher"
  "14_create_flight_permissions.cypher"
  "15_create_technicians.cypher"
  "16_create_relationships.cypher"
  "17_validation_queries.cypher"
)

for script in "${SCRIPTS[@]}"; do
  echo "Executing cypher/${script}..."
  docker exec -i neo4j-drone cypher-shell -u neo4j -p dronepassword < "cypher/${script}"
done
```

---

## 2. Catalog of Cypher Files

| Filename | Purpose | Target Labels / Focus |
| :--- | :--- | :--- |
| [`00_all_in_one_seed.cypher`](00_all_in_one_seed.cypher) | **Master Unified Seed:** Idempotently creates all 16 constraints, 75 nodes, and 129 relationships. | All Entities & Edges |
| [`01_constraints.cypher`](01_constraints.cypher) | **Schema Constraints:** Declares unique index constraints on primary identifier properties for all 16 node labels. | All 16 Labels |
| [`02_create_regions_and_fleets.cypher`](02_create_regions_and_fleets.cypher) | **Regions & Fleets:** Creates 4 Region nodes and 4 Fleet nodes, linking them via `(:Region)-[:CONTAINS]->(:Fleet)`. | `:Region`, `:Fleet` |
| [`03_create_drones.cypher`](03_create_drones.cypher) | **Drone Fleet Inventory:** Inserts 6 physical drones (DJI M30, Skydio X2, Agras T40, etc.) with capacities and dates. | `:Drone` |
| [`04_create_operators.cypher`](04_create_operators.cypher) | **Base Operators:** Creates 5 Operator nodes (3 human pilots: Rahul, Priya, Arun; 2 AI controllers: DroneAI-01, DroneAI-02). | `:Operator` |
| [`05_create_operator_profiles.cypher`](05_create_operator_profiles.cypher) | **Specialized Profiles:** Creates 3 `:Human_Pilot` and 2 `:AI_Operator` nodes, connecting them to `:Operator`. | `:Human_Pilot`, `:AI_Operator` |
| [`06_create_assignments.cypher`](06_create_assignments.cypher) | **Operational Assignments:** Creates 6 `:Drone_Operator_Assignment` nodes and connects them to both Drones and Operators. | `:Drone_Operator_Assignment` |
| [`07_create_routes.cypher`](07_create_routes.cypher) | **Flight Corridors:** Inserts 4 `:GPS_Route` waypoints (Chennai, Bengaluru, Hyderabad, Coimbatore). | `:GPS_Route` |
| [`08_create_missions.cypher`](08_create_missions.cypher) | **Flight Missions:** Creates 12 `:Mission` nodes, linking them to Drone (`PERFORMS`), Operator (`ASSIGNED_TO`), and Route (`FOLLOWS`). | `:Mission` |
| [`09_create_batteries.cypher`](09_create_batteries.cypher) | **Battery Telemetry:** Inserts 6 `:Battery` nodes with charge percentages and status flags (`NORMAL`, `LOW`, `FULL`, `CRITICAL`). | `:Battery` |
| [`10_create_maintenance.cypher`](10_create_maintenance.cypher) | **Service Interventions:** Inserts 5 `:Maintenance` logs (sensor calibration, motor repair, firmware update). | `:Maintenance` |
| [`11_create_charging_stations.cypher`](11_create_charging_stations.cypher) | **Ground Infrastructure:** Inserts 4 `:Charging_Station` hubs and links them to regions. | `:Charging_Station` |
| [`12_create_charging_schedules.cypher`](12_create_charging_schedules.cypher) | **Charging Bookings:** Inserts 5 `:Charging_Schedule` nodes, linking them to stations (`PROVIDES`) and drones (`SCHEDULED`). | `:Charging_Schedule` |
| [`13_create_emergency_events.cypher`](13_create_emergency_events.cypher) | **Incident Reports:** Inserts 3 `:Emergency_Event` nodes, connecting them to Drones (`GENERATES`) and Missions. | `:Emergency_Event` |
| [`14_create_flight_permissions.cypher`](14_create_flight_permissions.cypher) | **Regulatory Clearances:** Inserts 6 DGCA `:Flight_Permission` nodes and connects them to Missions (`REQUIRES`) and Drones. | `:Flight_Permission` |
| [`15_create_technicians.cypher`](15_create_technicians.cypher) | **Technician Schema:** Verifies `:Technician` constraint and provides query templates without fabricating artificial records. | `:Technician` |
| [`16_create_relationships.cypher`](16_create_relationships.cypher) | **Master Relationship Builder:** Establishes all 20 directed relationship types across existing nodes. | Master Edges |
| [`17_validation_queries.cypher`](17_validation_queries.cypher) | **Integrity Audits:** 8 verification suites checking node counts, foreign key traversals, missing permissions, and zero-orphan checks. | Verification |
| [`18_demonstration_queries.cypher`](18_demonstration_queries.cypher) | **Viva Practical Demonstrations:** 15 analytical Cypher queries demonstrating graph querying power during evaluation. | Viva Demonstrations |

---

## 3. Demonstration Queries Summary (`18_demonstration_queries.cypher`)

1. **Complete Fleet Overview:** Shows drone models, capacities, fleet roles, and regional locations.
2. **Chronological Drone Missions:** Lists all sorties flown by Drone 201 in date order.
3. **Operator Mission Roster:** Finds human or AI operators assigned to each flight.
4. **GPS Flight Corridors:** Maps each mission to its predefined waypoint distance and start/end points.
5. **Battery Alert Monitor:** Filters for drones with `LOW` (Drone 204: 25%) or `CRITICAL` (Drone 206: 15%) battery levels.
6. **Maintenance History:** Chronological log of calibrations, inspections, and motor repairs.
7. **Charging Depot Allocations:** Maps charging slots at stations 901–904.
8. **In-Flight Incidents Log:** Details communications failures, forced landings, and battery alerts.
9. **DGCA Regulatory Clearances:** Details the 6 flight permissions with issue/expiry dates.
10. **Human Pilot Flights:** Filters missions commanded by licensed human pilots (Rahul, Priya, Arun) with ratings.
11. **Autonomous AI Flights:** Filters missions commanded by AI controllers with version and autonomy tier.
12. **360-Degree Drone Operational Network:** Full bounded neighborhood traversal around Drone 204.
13. **Mission Analytics:** Calculates mission count, average battery drain, and range by objective.
14. **Incomplete Maintenance Tracker:** Flags Drone 204 undergoing active `IN_PROGRESS` Motor Repair.
15. **Critical Operations Attention Monitor:** Combines battery, maintenance, and emergency anomalies into a unified situational monitor.
