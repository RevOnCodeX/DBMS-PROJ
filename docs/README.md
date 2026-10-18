# Documentation Directory Guide

This directory contains technical specifications, architectural diagrams, data dictionaries, and source reconciliation reports for the **Drone Fleet Management Database in Neo4j**.

---

## Document Index

### 1. [`data_dictionary.md`](data_dictionary.md) — Graph Data Dictionary
- **Purpose:** Comprehensive catalog of all 16 node labels in the Neo4j data model.
- **Contents:**
  - Node label specifications and descriptions.
  - Primary identifier properties and uniqueness constraints.
  - Property lists with native Neo4j data types (`Integer`, `String`, `Date`, `Float`).
  - Source SQL table origin and domain rules for every field.

### 2. [`er_relationship_mapping.md`](er_relationship_mapping.md) — ER to Graph Relationship Mapping
- **Purpose:** Architectural analysis of how relational foreign key associations were transformed into high-performance graph relationships.
- **Contents:**
  - Relational vs. Graph paradigm comparison (pointer-less JOINs vs. $O(1)$ index-free adjacency).
  - Table of 10 primary ER relationships (`CONTAINS`, `PERFORMS`, `ASSIGNED_TO`, `FOLLOWS`, `UNDERGOES`, `SCHEDULED`, `PROVIDES`, `GENERATES`, `REQUIRES`).
  - Table of 10 foreign key enhancement edges (`HAS_HUMAN_PILOT_PROFILE`, `HAS_AI_OPERATOR_PROFILE`, `HAS_ASSIGNMENT`, `HAS_BATTERY_RECORD`, etc.).
  - Cardinality analysis (1:N, N:1, 1:1) and edge traversal semantics.
  - Complete Mermaid diagram visualizing the full graph metamodel.

### 3. [`source_transcription.md`](source_transcription.md) — Source Material Transcription Record
- **Purpose:** Line-by-line transcription of both primary sources:
  1. **Handwritten Coursework Submission (`dbms da-2.pdf`, Pages 1–5):**
     - Table definitions 1–15 (`CREATE TABLE ...`).
     - Handwritten sample insert statements (`INSERT INTO ... VALUES (...)`).
  2. **Executed Oracle SQL\*Plus Database Screenshots (`Dbms DA2 ques 2 screenshots.pdf`, Pages 1–8):**
     - Terminal schema definitions (`DESC <TABLE>;`).
     - Terminal query outputs (`SELECT * FROM <TABLE>;`).
     - DML tests on sample test rows (Drone 207, Fleet 105, Operator 306, etc.).

### 4. [`discrepancies.md`](discrepancies.md) — Source Inconsistency & Discrepancy Reconciliation
- **Purpose:** Rigorous reconciliation of discrepancies between handwritten drafts and the executed Oracle SQL database.
- **Contents:**
  - **Charging Schedule:** Resolves handwritten draft numbering (901–905) vs. executed Oracle `STATION_ID` column (stations 901, 902, 903, 904).
  - **Flight Permission:** Reconciles mixed ID drafts with the executed terminal structure (`PERMISSION_ID`, `DRONE_ID`, `MISSION_ID`, `ISSUED_DATE`, `EXPIRY_DATE`).
  - **Technician Entity:** Preserves ER spec without fabricating artificial sample records.
  - **Maintenance 803:** Reconciles draft notes with the executed database where record 803 applies to Drone 204 with status `IN_PROGRESS` (Motor replacement).
  - **Battery Records:** Reconciles draft notes (5 batteries) with the executed terminal output (6 batteries, including Drone 206 with critical charge).
