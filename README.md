# 🚁 Drone Fleet Management Database — Neo4j Graph Implementation

<div align="center">

![Neo4j](https://img.shields.io/badge/Neo4j-5.x-blue?style=for-the-badge&logo=neo4j&logoColor=white)
![Cypher](https://img.shields.io/badge/Cypher-Query%20Language-4A90E2?style=for-the-badge)
![Python](https://img.shields.io/badge/Python-3.x-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete%20%26%20Verified-22c55e?style=for-the-badge)

**Database Systems — Design & Analysis II (DA-II)**  
**Student:** Aakshaj Srivastava &nbsp;|&nbsp; **Reg. No:** 25BAI1484  
**Technology:** Neo4j Community Edition v5 · Cypher Query Language

</div>

---

## 📖 Project Overview

This repository is the **complete, production-ready Neo4j graph database implementation** of a Drone Fleet Management System — originally designed as a relational SQL schema for a college DBMS assignment and then transformed into a full property graph model.

The system models a real-world logistics and aerial operations enterprise running multiple drone fleets across four cities in India. Every aspect of the operation is captured — from the physical drones and their batteries, to flight missions, GPS routes, human pilots, AI controllers, emergency incidents, maintenance records, regulatory permissions, and charging infrastructure.

### Why Neo4j Instead of SQL?

In a relational database, connecting data requires expensive `JOIN` operations across tables using foreign keys. In a graph database, relationships are **first-class citizens** stored as direct pointers between nodes — making traversal queries like *"Show me every mission flown by drones in Fleet-A that had a battery warning"* dramatically simpler and faster.

This project demonstrates the full transformation:
- **Relational foreign keys → Graph edges** (e.g. `Drone.Fleet_ID` → `(:Drone)-[:BELONGS_TO]->(:Fleet)`)
- **SQL JOINs → Cypher path traversals** (`MATCH (d:Drone)-[:PERFORMS]->(m:Mission)-[:FOLLOWS]->(r:GPS_Route)`)
- **Flat rows → Rich, connected property nodes** with native types (Dates, Integers, Floats)

---

## 🗺️ Operational Context

The system manages drone operations across **4 regional hubs** in South India:

| Region | City | Fleet | Drone Models |
|:---|:---|:---|:---|
| Region 1 | Chennai | Fleet-A | DJI M30 (201), DJI M350 (202) |
| Region 2 | Bengaluru | Fleet-B | Skydio X2 (203), Agras T40 (204) |
| Region 3 | Hyderabad | Fleet-C | Parrot Anafi (205) |
| Region 4 | Coimbatore | Fleet-D | DJI Mavic 3E (206) |

**Mission objectives** handled: Package Delivery · Aerial Surveillance · Agricultural Monitoring · Disaster Management

---

## 🔷 Graph Schema

### Node Labels — 16 Entity Types

| # | Label | Count | Description |
|:---:|:---|:---:|:---|
| 1 | `:Region` | 4 | Geographic operational hubs |
| 2 | `:Fleet` | 4 | Organizational fleet units |
| 3 | `:Drone` | 6 | Physical drone inventory with capacity & specs |
| 4 | `:Operator` | 5 | Base operator entity (human or AI) |
| 5 | `:Human_Pilot` | 3 | Licensed pilots — Rahul (LIC101), Priya (LIC102), Arun (LIC103) |
| 6 | `:AI_Operator` | 2 | Autonomous controllers — DroneAI-01, DroneAI-02 |
| 7 | `:Drone_Operator_Assignment` | 6 | Historical drone-operator pairings |
| 8 | `:GPS_Route` | 4 | Predefined flight corridors with waypoints |
| 9 | `:Mission` | 12 | Flight sorties with weather, payload, battery usage |
| 10 | `:Battery` | 6 | Battery telemetry — charge levels & health flags |
| 11 | `:Maintenance` | 5 | Service logs — calibrations, repairs, firmware updates |
| 12 | `:Charging_Station` | 4 | Ground depot recharging stations |
| 13 | `:Charging_Schedule` | 5 | Depot recharging bookings per drone |
| 14 | `:Emergency_Event` | 3 | In-flight incident reports |
| 15 | `:Flight_Permission` | 6 | DGCA regulatory clearances |
| 16 | `:Technician` | 0* | Avionics technicians (schema defined; no sample records fabricated) |
| | **Total** | **75 Nodes** | **Zero orphan records · 100% connectivity** |

### Relationship Types — 20 Directed Edge Types · 129 Total Edges

```
(:Region)          -[:CONTAINS]----------------> (:Fleet)
(:Fleet)           -[:CONTAINS]----------------> (:Drone)
(:Drone)           -[:BELONGS_TO]--------------> (:Fleet)
(:Drone)           -[:PERFORMS]----------------> (:Mission)
(:Operator)        -[:ASSIGNED_TO]-------------> (:Mission)
(:Mission)         -[:FOLLOWS]-----------------> (:GPS_Route)
(:Operator)        -[:HAS_HUMAN_PILOT_PROFILE]-> (:Human_Pilot)
(:Operator)        -[:HAS_AI_OPERATOR_PROFILE]-> (:AI_Operator)
(:Drone)           -[:HAS_ASSIGNMENT]----------> (:Drone_Operator_Assignment)
(:Operator)        -[:HAS_ASSIGNMENT]----------> (:Drone_Operator_Assignment)
(:Drone)           -[:HAS_BATTERY_RECORD]------> (:Battery)
(:Drone)           -[:UNDERGOES]--------------->  (:Maintenance)
(:Region)          -[:HAS_CHARGING_STATION]----> (:Charging_Station)
(:Charging_Station)-[:PROVIDES]----------------> (:Charging_Schedule)
(:Drone)           -[:SCHEDULED]--------------->  (:Charging_Schedule)
(:Drone)           -[:GENERATES]--------------->  (:Emergency_Event)
(:Mission)         -[:HAS_EMERGENCY_EVENT]-----> (:Emergency_Event)
(:Mission)         -[:REQUIRES]----------------> (:Flight_Permission)
(:Drone)           -[:HAS_FLIGHT_PERMISSION]---> (:Flight_Permission)
(:GPS_Route)       -[:USED_BY]-----------------> (:Mission)
```

---

## 📁 Project Structure — Every File Explained

```
dbms-project/
│
├── 📄 README.md                    ← You are here — master guide
├── 🐳 docker-compose.yml           ← 1-click Neo4j deployment (recommended)
├── 🛠️  seed.sh                     ← Automated database seeder script
├── 🔒 .gitignore                   ← Excludes .DS_Store, __pycache__, etc.
├── 🐍 server.py                    ← Python REST server bridging Neo4j & the web UI
│
├── 📂 cypher/                      ← All Cypher scripts (modular + unified)
│   ├── 📄 README.md                    ← Execution guide & script catalog
│   ├── ⚡ 00_all_in_one_seed.cypher   ← MASTER SEED — runs everything in one go
│   ├── 01_constraints.cypher          ← Uniqueness constraints for all 16 labels
│   ├── 02_create_regions_and_fleets.cypher
│   ├── 03_create_drones.cypher
│   ├── 04_create_operators.cypher
│   ├── 05_create_operator_profiles.cypher
│   ├── 06_create_assignments.cypher
│   ├── 07_create_routes.cypher
│   ├── 08_create_missions.cypher
│   ├── 09_create_batteries.cypher
│   ├── 10_create_maintenance.cypher
│   ├── 11_create_charging_stations.cypher
│   ├── 12_create_charging_schedules.cypher
│   ├── 13_create_emergency_events.cypher
│   ├── 14_create_flight_permissions.cypher
│   ├── 15_create_technicians.cypher
│   ├── 16_create_relationships.cypher  ← Builds ALL 129 directed edges
│   ├── 17_validation_queries.cypher    ← 8 integrity audit suites
│   └── 18_demonstration_queries.cypher ← 15 college viva queries
│
├── 📂 docs/                        ← Technical documentation
│   ├── 📄 README.md                    ← Documentation index
│   ├── data_dictionary.md             ← Every property, type, and constraint
│   ├── er_relationship_mapping.md     ← SQL → Graph transformation analysis
│   ├── source_transcription.md        ← Full transcription of handwritten notes
│   └── discrepancies.md              ← Source inconsistency reconciliation
│
├── 📂 public/                      ← Interactive web dashboard frontend
│   ├── 📄 README.md                    ← Web UI architecture guide
│   ├── index.html                     ← Main single-page application
│   ├── style.css                      ← Dark glassmorphic design system
│   └── app.js                         ← Graph visualizer & Cypher query runner
│
├── 📂 screenshots/                 ← Oracle SQL terminal verification images
│   ├── 📄 README.md                    ← Screenshot catalog & graph export guide
│   ├── screen_page_1.png              ← DESC output: REGION, FLEET, DRONE...
│   ├── screen_page_2.png              ← DESC output: MISSION, BATTERY...
│   ├── screen_page_3.png              ← SELECT * output: Tables 1–8
│   ├── screen_page_4.png              ← SELECT * output: Tables 9–15
│   ├── screen_page_5.png              ← SELECT * output: MISSION (all 12 rows)
│   ├── screen_page_6.png              ← DML test: INSERT, SELECT
│   ├── screen_page_7.png              ← DML test: UPDATE
│   └── screen_page_8.png              ← DML test: DELETE & final count
│
└── 📂 source_images/               ← Original handwritten assignment scans
    ├── 📄 README.md                    ← Page-by-page content guide
    ├── page_1.png                     ← Table definitions 1–7 (Region → GPS_Route)
    ├── page_2.png                     ← Table definitions 8–15 (Mission → Flight_Permission)
    ├── page_3.png                     ← Sample inserts: Region, Fleet, Drone, Operator, Pilot
    ├── page_4.png                     ← Sample inserts: Battery, Maintenance, Charging
    └── page_5.png                     ← Sample inserts: Emergency, Flight Permissions
```

---

## 🚀 Quick Start — Get the Database Running

### Option 1: Docker Compose (Easiest — 2 commands)

```bash
# 1. Start the Neo4j container
docker compose up -d

# 2. Seed the database with all 75 nodes and 129 relationships
./seed.sh
```

Then open Neo4j Browser at: **[http://localhost:7474](http://localhost:7474)**  
Login: `neo4j` / `dronepassword`

---

### Option 2: Docker Run (Manual)

```bash
# Start Neo4j container
docker run -d \
  --name neo4j-drone \
  -p 7474:7474 -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/dronepassword \
  neo4j:5-community

# Wait ~20 seconds for startup, then seed:
docker exec -i neo4j-drone cypher-shell \
  -u neo4j -p dronepassword \
  < cypher/00_all_in_one_seed.cypher
```

---

### Option 3: Neo4j Desktop / AuraDB

1. Create a new database with password `dronepassword`
2. Open the Cypher editor
3. Paste and execute `cypher/00_all_in_one_seed.cypher` in full

> **Note:** All insert statements use `MERGE`, so the seed script is **idempotent** — you can run it multiple times without duplicating data.

---

### Option 4: Interactive Web Dashboard

```bash
# From the project root:
PORT=5050 python3 server.py
```

Then open: **[http://localhost:5050](http://localhost:5050)**

Features:
- 🌐 **Physics-based graph visualizer** — drag, zoom, click any node to inspect all its properties
- ▶️ **1-click viva query runner** — execute all 15 demonstration queries with timing
- 🔍 **Entity explorer** — browse all nodes across any of the 16 labels
- ✅ **Live integrity audit** — real-time verification: node counts, zero orphans, relationship totals
- 📋 **Source comparison** — side-by-side handwritten vs. SQL database audit

---

## 🔍 Key Cypher Scripts Explained

### `00_all_in_one_seed.cypher` — The Master Script
This is the single most important file. It creates the entire database in one execution:
1. All 16 uniqueness constraints
2. All 75 nodes across 15 entity types
3. All 129 directed relationships across 20 relationship types

All statements use `MERGE` so the script is safe to re-run.

### `17_validation_queries.cypher` — Integrity Verification
Runs 8 audit checks:
- Total node count (expected: 75)
- Total relationship count (expected: 129)
- Orphan check (expected: 0)
- Missing flight permissions (6 missions without DGCA clearance — intentional, matches the source)
- Battery status distribution
- Maintenance status check

### `18_demonstration_queries.cypher` — College Viva Queries
15 analytical Cypher queries designed to demonstrate graph querying power:

| # | Query | What It Shows |
|:---:|:---|:---|
| Q1 | Complete fleet hierarchy | `Region → Fleet → Drone` path traversal |
| Q2 | Drone 201 mission history | Chronological sortie listing |
| Q3 | Operator–mission assignment | Human vs AI command roster |
| Q4 | GPS route waypoints | Distance and corridor details |
| Q5 | Battery alert monitor | Drones 204 (25% LOW) & 206 (15% CRITICAL) |
| Q6 | Maintenance history | All 5 service interventions |
| Q7 | Charging depot allocations | Station 901–904 bookings |
| Q8 | Emergency incident log | Comms failure, emergency landing, battery alert |
| Q9 | DGCA regulatory clearances | 6 approved flight permissions |
| Q10 | Human pilot flights | Rahul, Priya, Arun — license & rating |
| Q11 | AI autonomous flights | DroneAI-01, DroneAI-02 version info |
| Q12 | Drone 204 full network | 360° bounded neighborhood traversal |
| Q13 | Mission analytics | Avg battery drain & count by objective |
| Q14 | Active maintenance tracker | Drone 204 IN_PROGRESS Motor Repair |
| Q15 | Critical ops monitor | Combined battery + maintenance + incident flags |

---

## 📚 Documentation Guide

All four documents in `docs/` serve a specific purpose:

| Document | Purpose |
|:---|:---|
| [`data_dictionary.md`](docs/data_dictionary.md) | **Complete property catalog** — every node label, property name, data type (`Integer`, `String`, `Date`, `Float`), uniqueness constraints, and domain rules for all 16 entities |
| [`er_relationship_mapping.md`](docs/er_relationship_mapping.md) | **Architectural transformation analysis** — how each SQL foreign key became a graph edge, cardinality analysis (1:N, N:1), Mermaid metamodel diagram |
| [`source_transcription.md`](docs/source_transcription.md) | **Line-by-line transcription** of both primary sources: (1) handwritten coursework submission and (2) Oracle SQL\*Plus terminal output screenshots |
| [`discrepancies.md`](docs/discrepancies.md) | **Reconciliation report** — honest documentation of every difference found between the handwritten draft and the executed Oracle SQL database, with resolution decisions |

---

## ✅ Verified Graph Statistics

```
Total Nodes:         75
Total Relationships: 129
Orphan Nodes:        0   ← every node is connected
Constraint Checks:   16  ← one per entity label
```

**Node breakdown:**

```
Region: 4  Fleet: 4  Drone: 6  Operator: 5  Human_Pilot: 3  AI_Operator: 2
Drone_Operator_Assignment: 6  GPS_Route: 4  Mission: 12  Battery: 6
Maintenance: 5  Charging_Station: 4  Charging_Schedule: 5
Emergency_Event: 3  Flight_Permission: 6
```

---

## 🗒️ Source Reconciliation Highlights

Key discrepancies found between the handwritten assignment and the executed Oracle SQL database, resolved transparently:

1. **Charging Schedule Primary Key** — The handwritten draft lists `STATION_ID` values 901–905 as the first column. The executed Oracle database confirmed `STATION_ID` stores the station reference (901, 901, 902, 903, 904) — not a sequential schedule ID. In Neo4j, a separate `Schedule_ID` (1–5) is used with a unique constraint.

2. **Flight Permissions** — The executed database shows 6 permissions covering missions 601, 603, 605, 608, 609, 612. The remaining 6 missions do not have DGCA clearances. No fake permissions were fabricated — query 17 reports these gaps accurately.

3. **Technician Entity** — Present in the ER diagram but absent from all handwritten SQL `INSERT` statements. The constraint and node template are defined in `15_create_technicians.cypher` with zero artificial records.

4. **Battery Records** — Handwritten draft describes 5 batteries (701–705). The executed Oracle SQL database confirmed a 6th battery (706) for Drone 206 with `CRITICAL` charge at 15%.

---

## 🛠️ Technology Stack

| Component | Technology |
|:---|:---|
| **Graph Database** | Neo4j Community Edition v5 |
| **Query Language** | Cypher |
| **Deployment** | Docker / Docker Compose |
| **Web Server** | Python 3 — `http.server` + `neo4j` driver |
| **Graph Visualizer** | [vis-network.js](https://visjs.github.io/vis-network/docs/network/) |
| **Frontend** | Vanilla HTML5, CSS3 (glassmorphism), JavaScript |
| **Source Database** | Oracle SQL*Plus (original assignment) |

---

## 📜 Academic Context

> **Course:** Database Systems (DBMS)  
> **Assignment:** Design & Analysis — II (DA-II)  
> **Objective:** Design a relational schema, implement in Oracle SQL, then transform and re-implement in a NoSQL/Graph database, demonstrating an understanding of both paradigms.  
> **Completion:** Full implementation verified — 75 nodes, 129 edges, 15 viva queries, 8 validation suites, interactive web console, complete documentation.
