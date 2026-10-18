# Web Console Directory Guide (`public/`)

This directory contains the frontend user interface for the **Drone Fleet Management Neo4j Console**.

---

## 1. File Structure

| Filename | Purpose | Description |
| :--- | :--- | :--- |
| [`index.html`](index.html) | **Main Single-Page App** | Semantic HTML5 structure featuring a glassmorphic top navigation bar and 5 modular functional views. |
| [`style.css`](style.css) | **Design System & Styles** | Dark-mode glassmorphic styling, curated color palettes, Google Fonts (`Outfit`, `Inter`, `JetBrains Mono`), and responsive layouts. |
| [`app.js`](app.js) | **Client Application Logic** | Integrates `vis-network.js` for physics-based graph interaction, client-side search, node inspection, and asynchronous REST execution of Cypher queries. |

---

## 2. Interactive Feature Highlights

1. **Interactive Graph Visualizer:**
   - Color-coded node badges by label (Drone, Fleet, Operator, Mission, Battery, etc.).
   - Physics-enabled drag-and-drop layout with stabilization and zoom controls.
   - Click-to-inspect slide-out drawer displaying all properties and direct relationships for any selected node.
   - Real-time search filter matching node names, models, and IDs.

2. **Demonstration & Viva Queries Tab:**
   - Roster of all 15 pre-configured college practical queries.
   - 1-click execution with real-time query latency measurement (ms).
   - Editable Cypher query box with syntax support and clean tabular rendering of results.

3. **Entity Explorer Tab:**
   - Selector chips for all 16 graph labels.
   - Dynamic table display of all properties for any selected entity.

4. **Integrity Audit Tab:**
   - Real-time metric cards showing total nodes, total relationships, orphan count, and operational alerts.
   - Live audit table comparing actual imported node counts against expected targets.

5. **Source Comparison Tab:**
   - Detailed side-by-side audit cards comparing handwritten draft notes with the executed Oracle SQL*Plus database.

---

## 3. How to Run the Web Application

From the root directory:
```bash
PORT=5050 python3 server.py
```
Then open your browser at: [http://localhost:5050](http://localhost:5050)
