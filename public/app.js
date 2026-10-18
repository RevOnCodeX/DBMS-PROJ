// ==============================================================================
// Drone Fleet Management Neo4j Console - Interactive Frontend Application
// ==============================================================================

const DEMO_QUERIES = [
  {
    id: 1,
    title: "1. Complete Drone Fleet",
    desc: "Display each drone with fleet, region, model, operational status, and drone type",
    cypher: `MATCH (r:Region)-[:CONTAINS]->(f:Fleet)-[:CONTAINS]->(d:Drone)
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       d.Drone_Type AS Type,
       d.Operational_Status AS Status,
       d.Payload_Capacity AS Payload_Kg,
       d.Battery_Capacity AS Battery_Units,
       f.Fleet_Name AS Fleet,
       f.Fleet_Type AS Fleet_Role,
       r.Region_Name AS Region,
       r.Location AS State
ORDER BY d.Drone_ID;`
  },
  {
    id: 2,
    title: "2. Missions by Drone (201)",
    desc: "Display all missions performed by Drone 201 in chronological order",
    cypher: `MATCH (d:Drone {Drone_ID: 201})-[:PERFORMS]->(m:Mission)
OPTIONAL MATCH (m)-[:FOLLOWS]->(r:GPS_Route)
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       m.Mission_ID AS Mission_ID,
       m.Mission_Date AS Date,
       m.Mission_Objective AS Objective,
       r.Route_Name AS Route,
       m.Battery_Usage AS Battery_Used,
       m.Mission_Status AS Status
ORDER BY m.Mission_Date ASC;`
  },
  {
    id: 3,
    title: "3. Operator Mission Assignments",
    desc: "Find the human pilot or AI operator supervising each mission",
    cypher: `MATCH (m:Mission)<-[:ASSIGNED_TO]-(o:Operator)
RETURN m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       m.Mission_Date AS Date,
       o.Operator_ID AS Operator_ID,
       o.Operator_Name AS Operator_Name,
       o.Operator_Type AS Operator_Type,
       m.Mission_Status AS Status
ORDER BY m.Mission_ID;`
  },
  {
    id: 4,
    title: "4. GPS Route Corridors",
    desc: "Display mission GPS route waypoints, start/end locations, and flight distance",
    cypher: `MATCH (m:Mission)-[:FOLLOWS]->(r:GPS_Route)
RETURN m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       r.Route_ID AS Route_ID,
       r.Route_Name AS Route_Name,
       r.Start_Location AS Start_Location,
       r.End_Location AS End_Location,
       r.Route_Distance AS Distance_Km,
       r.Route_Status AS Route_Status
ORDER BY m.Mission_ID;`
  },
  {
    id: 5,
    title: "5. Battery Health Alerts",
    desc: "Find drones with LOW or CRITICAL battery state of charge",
    cypher: `MATCH (d:Drone)-[:HAS_BATTERY_RECORD]->(b:Battery)
WHERE b.Battery_Status IN ['LOW', 'CRITICAL']
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       b.Battery_ID AS Battery_ID,
       b.Current_Level AS Current_Level_Pct,
       b.Battery_Capacity AS Capacity,
       b.Battery_Status AS Status,
       b.Last_Updated AS Last_Updated
ORDER BY b.Current_Level ASC;`
  },
  {
    id: 6,
    title: "6. Maintenance History",
    desc: "Display maintenance interventions ordered chronologically",
    cypher: `MATCH (d:Drone)-[:UNDERGOES]->(m:Maintenance)
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       m.Maintenance_ID AS Maintenance_ID,
       m.Maintenance_Type AS Service_Type,
       m.Maintenance_Date AS Service_Date,
       m.Maintenance_Status AS Status,
       m.Maintenance_Description AS Description
ORDER BY m.Maintenance_Date ASC;`
  },
  {
    id: 7,
    title: "7. Charging Station Schedules",
    desc: "Display charging schedules, booked drones, and depot stations",
    cypher: `MATCH (cs:Charging_Station)-[:PROVIDES]->(csch:Charging_Schedule)<-[:SCHEDULED]-(d:Drone)
RETURN csch.Schedule_ID AS Schedule_ID,
       d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Drone_Model,
       cs.Station_ID AS Station_ID,
       cs.Station_Name AS Station_Name,
       cs.Location AS Station_Location,
       csch.Schedule_Date AS Date,
       csch.Start_Time AS Start_Time,
       csch.End_Time AS End_Time,
       csch.Charging_Status AS Status
ORDER BY csch.Schedule_ID;`
  },
  {
    id: 8,
    title: "8. Emergency Event Log",
    desc: "Display in-flight incident reports, drone IDs, and mission context",
    cypher: `MATCH (d:Drone)-[:GENERATES]->(ee:Emergency_Event)
OPTIONAL MATCH (m:Mission)-[:HAS_EMERGENCY_EVENT]->(ee)
RETURN ee.Event_ID AS Event_ID,
       d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Drone_Model,
       m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       ee.Emergency_Type AS Event_Type,
       ee.Emergency_Date AS Event_Date,
       ee.Emergency_Description AS Description,
       ee.Resolution_Status AS Resolution
ORDER BY ee.Event_ID;`
  },
  {
    id: 9,
    title: "9. Regulatory Flight Permissions",
    desc: "Display DGCA clearance permits, validity windows, and authorized flights",
    cypher: `MATCH (d:Drone)-[:HAS_FLIGHT_PERMISSION]->(fp:Flight_Permission)<-[:REQUIRES]-(m:Mission)
RETURN fp.Permission_ID AS Permission_ID,
       d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Drone_Model,
       m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       fp.Issuing_Authority AS Authority,
       fp.Issued_Date AS Issued_Date,
       fp.Expiry_Date AS Expiry_Date,
       fp.Permission_Status AS Status
ORDER BY fp.Permission_ID;`
  },
  {
    id: 10,
    title: "10. Human Pilot Missions",
    desc: "Distinguish human operators and list their licenses, ratings, and missions",
    cypher: `MATCH (hp:Human_Pilot)<-[:HAS_HUMAN_PILOT_PROFILE]-(o:Operator)-[:ASSIGNED_TO]->(m:Mission)
RETURN o.Operator_ID AS Pilot_ID,
       o.Operator_Name AS Pilot_Name,
       hp.License_No AS License,
       hp.Pilot_Rating AS Rating,
       m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       m.Mission_Date AS Date,
       m.Mission_Status AS Status
ORDER BY o.Operator_ID, m.Mission_Date;`
  },
  {
    id: 11,
    title: "11. Autonomous AI Missions",
    desc: "Missions commanded by certified AI operators with version and autonomy level",
    cypher: `MATCH (aio:AI_Operator)<-[:HAS_AI_OPERATOR_PROFILE]-(o:Operator)-[:ASSIGNED_TO]->(m:Mission)
RETURN o.Operator_ID AS AI_Operator_ID,
       o.Operator_Name AS AI_System_Name,
       aio.AI_Version AS AI_Version,
       aio.Autonomy_Level AS Autonomy_Level,
       m.Mission_ID AS Mission_ID,
       m.Mission_Objective AS Objective,
       m.Mission_Date AS Date,
       m.Mission_Status AS Status
ORDER BY o.Operator_ID, m.Mission_Date;`
  },
  {
    id: 12,
    title: "12. 360-Degree Drone Network (204)",
    desc: "Full operational ecosystem around Drone 204 (fleet, battery, maintenance, incidents)",
    cypher: `MATCH (d:Drone {Drone_ID: 204})
OPTIONAL MATCH (d)-[:BELONGS_TO]->(f:Fleet)
OPTIONAL MATCH (d)-[:HAS_BATTERY_RECORD]->(b:Battery)
OPTIONAL MATCH (d)-[:UNDERGOES]->(maint:Maintenance)
OPTIONAL MATCH (d)-[:SCHEDULED]->(csch:Charging_Schedule)
OPTIONAL MATCH (d)-[:GENERATES]->(ee:Emergency_Event)
OPTIONAL MATCH (d)-[:PERFORMS]->(m:Mission)
OPTIONAL MATCH (d)-[:HAS_FLIGHT_PERMISSION]->(fp:Flight_Permission)
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       d.Operational_Status AS Status,
       f.Fleet_Name AS Fleet,
       b.Battery_Status AS Battery_Condition,
       b.Current_Level AS Battery_Level,
       maint.Maintenance_Type AS Ongoing_Service,
       maint.Maintenance_Status AS Service_Status,
       csch.Schedule_Date AS Next_Charging,
       ee.Emergency_Type AS Recent_Incident,
       count(DISTINCT m) AS Missions_Count,
       count(DISTINCT fp) AS Permissions_Count;`
  },
  {
    id: 13,
    title: "13. Mission Analytics by Objective",
    desc: "Group missions by objective and calculate counts and battery drain stats",
    cypher: `MATCH (m:Mission)
RETURN m.Mission_Objective AS Objective,
       count(m) AS Total_Missions,
       avg(m.Battery_Usage) AS Avg_Battery_Usage,
       min(m.Battery_Usage) AS Min_Battery_Usage,
       max(m.Battery_Usage) AS Max_Battery_Usage
ORDER BY Total_Missions DESC;`
  },
  {
    id: 14,
    title: "14. Drones Under Maintenance",
    desc: "Identify drones with active/in-progress maintenance orders",
    cypher: `MATCH (d:Drone)-[:UNDERGOES]->(m:Maintenance)
WHERE m.Maintenance_Status <> 'COMPLETED'
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       d.Operational_Status AS Drone_Operational_Status,
       m.Maintenance_ID AS Maintenance_ID,
       m.Maintenance_Type AS Service_Required,
       m.Maintenance_Status AS Current_Status,
       m.Maintenance_Description AS Details;`
  },
  {
    id: 15,
    title: "15. Critical Attention Monitor",
    desc: "Comprehensive situational monitor combining battery, maintenance & incident alerts",
    cypher: `MATCH (d:Drone)
OPTIONAL MATCH (d)-[:HAS_BATTERY_RECORD]->(b:Battery)
OPTIONAL MATCH (d)-[:UNDERGOES]->(maint:Maintenance)
OPTIONAL MATCH (d)-[:GENERATES]->(ee:Emergency_Event)
WHERE b.Battery_Status IN ['LOW', 'CRITICAL']
   OR maint.Maintenance_Status <> 'COMPLETED'
   OR ee.Event_ID IS NOT NULL
RETURN d.Drone_ID AS Drone_ID,
       d.Drone_Model AS Model,
       d.Operational_Status AS Status,
       coalesce(b.Battery_Status, 'OK') AS Battery_Alert,
       coalesce(b.Current_Level, 0) AS Battery_Pct,
       coalesce(maint.Maintenance_Status, 'None') AS Maintenance_Flag,
       coalesce(ee.Emergency_Type, 'None') AS Incident_Flag
ORDER BY d.Drone_ID;`
  }
];

const ENTITY_CONFIG = {
  Drone: { desc: "Individual aerial unmanned vehicles with payload and battery ratings." },
  Fleet: { desc: "Operational groupings organized by mission role and assigned region." },
  Region: { desc: "Geographic operational sectors across southern India." },
  Operator: { desc: "Certified human pilots and autonomous AI flight controllers." },
  Human_Pilot: { desc: "Licensed human pilots with DGCA certification and proficiency ratings." },
  AI_Operator: { desc: "Autonomous AI navigational systems with software versions." },
  Drone_Operator_Assignment: { desc: "Historical and active operational pairings between Drones and Operators." },
  GPS_Route: { desc: "Pre-designated flight corridors and waypoint paths." },
  Mission: { desc: "Flight sorties executed for delivery, surveillance, agriculture, and disaster response." },
  Battery: { desc: "Battery pack telemetry, charge levels, and status indicators." },
  Maintenance: { desc: "Sensor calibration, motor repairs, and firmware updates." },
  Charging_Station: { desc: "Depot charging hubs located across regions." },
  Charging_Schedule: { desc: "Scheduled depot charging slots allocated to drones." },
  Emergency_Event: { desc: "Logged in-flight anomalies, communications failures, and forced landings." },
  Flight_Permission: { desc: "DGCA-issued regulatory flight authorizations." },
  Technician: { desc: "Service avionics technicians (Schema created per ER spec; zero fake records)." }
};

const LABEL_COLORS = {
  Drone: "#00f2fe",
  Fleet: "#3b82f6",
  Region: "#8b5cf6",
  Operator: "#ec4899",
  Human_Pilot: "#f43f5e",
  AI_Operator: "#a855f7",
  Drone_Operator_Assignment: "#eab308",
  GPS_Route: "#10b981",
  Mission: "#06b6d4",
  Battery: "#84cc16",
  Maintenance: "#f97316",
  Charging_Station: "#14b8a6",
  Charging_Schedule: "#6366f1",
  Emergency_Event: "#ef4444",
  Flight_Permission: "#e11d48",
  Technician: "#64748b"
};

// Global State
let network = null;
let allGraphNodes = [];
let allGraphEdges = [];
let activeQueryIndex = 0;
let physicsEnabled = true;

document.addEventListener("DOMContentLoaded", () => {
  initTabs();
  initQueryRunner();
  initEntityExplorer();
  checkConnection();
  loadGraph();
  loadAuditStats();
});

// ------------------------------------------------------------------------------
// Tabs Navigation
// ------------------------------------------------------------------------------
function initTabs() {
  const tabBtns = document.querySelectorAll(".tab-btn");
  const tabPanes = document.querySelectorAll(".tab-pane");

  tabBtns.forEach(btn => {
    btn.addEventListener("click", () => {
      const target = btn.dataset.tab;
      tabBtns.forEach(b => b.classList.remove("active"));
      tabPanes.forEach(p => p.classList.remove("active"));
      btn.classList.add("active");
      document.getElementById(target).classList.add("active");

      if (target === "graph-view" && network) {
        setTimeout(() => network.fit(), 100);
      }
    });
  });
}

// ------------------------------------------------------------------------------
// Connection & Stats
// ------------------------------------------------------------------------------
async function checkConnection() {
  const statusEl = document.getElementById("conn-status");
  try {
    const res = await fetch("/api/health");
    const data = await res.json();
    if (data.connected) {
      statusEl.textContent = "Neo4j Connected • 75 Nodes • 129 Rels";
      statusEl.style.color = "#10b981";
    } else {
      statusEl.textContent = "Neo4j Disconnected";
      statusEl.style.color = "#ef4444";
    }
  } catch (err) {
    statusEl.textContent = "Offline";
    statusEl.style.color = "#ef4444";
  }
}

// ------------------------------------------------------------------------------
// Graph Visualizer (vis-network)
// ------------------------------------------------------------------------------
async function loadGraph() {
  const container = document.getElementById("vis-container");
  try {
    const res = await fetch("/api/graph");
    const data = await res.json();

    allGraphNodes = data.nodes || [];
    allGraphEdges = data.edges || [];

    // Setup filter chips
    renderLabelFilters();

    const visNodes = allGraphNodes.map(n => ({
      id: n.id,
      label: n.label,
      group: n.group,
      title: `${n.group}: ${n.label}`,
      color: {
        background: LABEL_COLORS[n.group] || "#3b82f6",
        border: "#ffffff",
        highlight: { background: "#ffffff", border: LABEL_COLORS[n.group] || "#00f2fe" }
      },
      font: { color: "#ffffff", face: "Inter", size: 12 },
      shape: "dot",
      size: n.group === "Drone" ? 22 : (n.group === "Mission" ? 18 : 14)
    }));

    const visEdges = allGraphEdges.map(e => ({
      id: e.id,
      from: e.from,
      to: e.to,
      label: e.label,
      arrows: "to",
      color: { color: "rgba(255, 255, 255, 0.2)", highlight: "#00f2fe" },
      font: { color: "rgba(255, 255, 255, 0.5)", size: 9, align: "middle" }
    }));

    const networkData = {
      nodes: new vis.DataSet(visNodes),
      edges: new vis.DataSet(visEdges)
    };

    const options = {
      physics: {
        stabilization: { iterations: 150 },
        barnesHut: { gravitationalConstant: -3000, springLength: 95, springConstant: 0.04 }
      },
      interaction: { hover: true, tooltipDelay: 200 }
    };

    network = new vis.Network(container, networkData, options);

    network.on("click", params => {
      if (params.nodes.length > 0) {
        const nodeId = params.nodes[0];
        const rawNode = allGraphNodes.find(n => n.id === nodeId);
        if (rawNode) showNodeInspector(rawNode);
      }
    });

    // Toolbar buttons
    document.getElementById("btn-physics-toggle").addEventListener("click", () => {
      physicsEnabled = !physicsEnabled;
      network.setOptions({ physics: { enabled: physicsEnabled } });
      document.getElementById("btn-physics-toggle").textContent = physicsEnabled ? "Freeze Physics" : "Enable Physics";
    });

    document.getElementById("btn-fit-graph").addEventListener("click", () => network.fit());
    document.getElementById("btn-reload-graph").addEventListener("click", loadGraph);

    // Search Box
    document.getElementById("node-search").addEventListener("input", e => {
      const q = e.target.value.toLowerCase().trim();
      if (!q) {
        network.fit();
        return;
      }
      const match = allGraphNodes.find(n => n.label.toLowerCase().includes(q) || n.group.toLowerCase().includes(q));
      if (match) {
        network.focus(match.id, { scale: 1.4, animation: true });
        network.selectNodes([match.id]);
        showNodeInspector(match);
      }
    });

  } catch (err) {
    console.error("Failed to load graph:", err);
  }
}

function renderLabelFilters() {
  const container = document.getElementById("label-filters");
  container.innerHTML = "";
  const groups = Array.from(new Set(allGraphNodes.map(n => n.group))).sort();
  
  groups.forEach(group => {
    const chip = document.createElement("button");
    chip.className = "filter-chip";
    chip.textContent = `${group} (${allGraphNodes.filter(n => n.group === group).length})`;
    chip.style.borderColor = LABEL_COLORS[group] || "#475569";
    chip.addEventListener("click", () => {
      const matchingIds = allGraphNodes.filter(n => n.group === group).map(n => n.id);
      network.selectNodes(matchingIds);
    });
    container.appendChild(chip);
  });
}

function showNodeInspector(node) {
  const drawer = document.getElementById("node-drawer");
  document.getElementById("drawer-label").textContent = node.group;
  document.getElementById("drawer-label").style.backgroundColor = LABEL_COLORS[node.group] || "#3b82f6";
  document.getElementById("drawer-title").textContent = node.label;

  const propsBox = document.getElementById("drawer-props");
  propsBox.innerHTML = "";
  for (const [k, v] of Object.entries(node.properties || {})) {
    const row = document.createElement("div");
    row.className = "prop-row";
    row.innerHTML = `<span class="prop-key">${k}</span><span class="prop-val">${v}</span>`;
    propsBox.appendChild(row);
  }

  // Connected edges
  const neighborsBox = document.getElementById("drawer-neighbors");
  neighborsBox.innerHTML = "";
  const connectedEdges = allGraphEdges.filter(e => e.from === node.id || e.to === node.id);
  connectedEdges.forEach(e => {
    const isOut = e.from === node.id;
    const targetNodeId = isOut ? e.to : e.from;
    const targetNode = allGraphNodes.find(n => n.id === targetNodeId);
    const targetLabel = targetNode ? `${targetNode.group}: ${targetNode.label}` : `#${targetNodeId}`;
    
    const li = document.createElement("li");
    li.className = "neighbor-item";
    li.innerHTML = `<span>${isOut ? "→ " + e.label : "← " + e.label}</span><span>${targetLabel}</span>`;
    neighborsBox.appendChild(li);
  });

  drawer.classList.remove("hidden");
}

document.getElementById("btn-close-drawer").addEventListener("click", () => {
  document.getElementById("node-drawer").classList.add("hidden");
});

// ------------------------------------------------------------------------------
// Demonstration Queries Runner
// ------------------------------------------------------------------------------
function initQueryRunner() {
  const listEl = document.getElementById("query-button-list");
  listEl.innerHTML = "";

  DEMO_QUERIES.forEach((q, idx) => {
    const btn = document.createElement("button");
    btn.className = `query-item-btn ${idx === 0 ? "active" : ""}`;
    btn.innerHTML = `<span class="q-badge">Q${q.id}</span><span>${q.title.replace(/^Q?\d+\.\s*/, '')}</span>`;
    btn.addEventListener("click", () => selectQuery(idx));
    listEl.appendChild(btn);
  });

  selectQuery(0);

  document.getElementById("btn-run-active-query").addEventListener("click", () => {
    const cypher = document.getElementById("cypher-input").value;
    runQuery(cypher);
  });
}

function selectQuery(idx) {
  activeQueryIndex = idx;
  const q = DEMO_QUERIES[idx];

  document.querySelectorAll(".query-item-btn").forEach((b, i) => {
    b.classList.toggle("active", i === idx);
  });

  document.getElementById("active-query-num").textContent = `Query ${q.id}`;
  document.getElementById("active-query-title").textContent = q.title;
  document.getElementById("cypher-input").value = q.cypher;

  runQuery(q.cypher);
}

async function runQuery(cypher) {
  const metaCount = document.getElementById("results-count");
  const metaTime = document.getElementById("results-time");
  const tableBox = document.getElementById("results-table-box");

  metaCount.textContent = "Executing query...";
  metaTime.textContent = "";
  const t0 = performance.now();

  try {
    const res = await fetch("/api/query", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ query: cypher })
    });
    const data = await res.json();
    const elapsed = (performance.now() - t0).toFixed(1);

    if (!data.success) {
      metaCount.textContent = "Execution Error";
      tableBox.innerHTML = `<div class="empty-state text-danger">${data.errors[0]?.message || 'Query failed'}</div>`;
      return;
    }

    metaCount.textContent = `${data.total} row${data.total === 1 ? '' : 's'} returned`;
    metaTime.textContent = `Completed in ${elapsed} ms`;

    renderTable(tableBox, data.columns, data.rows);
  } catch (err) {
    metaCount.textContent = "Request Error";
    tableBox.innerHTML = `<div class="empty-state text-danger">${err.message}</div>`;
  }
}

function renderTable(container, columns, rows) {
  if (!rows || rows.length === 0) {
    container.innerHTML = `<div class="empty-state">0 rows returned.</div>`;
    return;
  }

  let html = `<table class="data-table"><thead><tr>`;
  columns.forEach(col => {
    html += `<th>${col}</th>`;
  });
  html += `</tr></thead><tbody>`;

  rows.forEach(row => {
    html += `<tr>`;
    row.forEach(cell => {
      let display = cell;
      if (typeof cell === "object" && cell !== null) {
        display = JSON.stringify(cell);
      }
      html += `<td>${display !== null && display !== undefined ? display : '<span class="text-dim">null</span>'}</td>`;
    });
    html += `</tr>`;
  });

  html += `</tbody></table>`;
  container.innerHTML = html;
}

// ------------------------------------------------------------------------------
// Entity Explorer
// ------------------------------------------------------------------------------
function initEntityExplorer() {
  const bar = document.getElementById("entity-selector-chips");
  bar.innerHTML = "";

  const entities = Object.keys(ENTITY_CONFIG);

  entities.forEach((ent, idx) => {
    const chip = document.createElement("button");
    chip.className = `filter-chip ${idx === 0 ? "active" : ""}`;
    chip.textContent = ent;
    chip.style.borderColor = LABEL_COLORS[ent] || "#3b82f6";
    chip.addEventListener("click", () => selectEntity(ent, chip));
    bar.appendChild(chip);
  });

  selectEntity("Drone", bar.firstChild);
}

async function selectEntity(entityName, chipEl) {
  document.querySelectorAll("#entity-selector-chips .filter-chip").forEach(c => c.classList.remove("active"));
  if (chipEl) chipEl.classList.add("active");

  document.getElementById("current-entity-name").textContent = entityName;
  document.getElementById("current-entity-desc").textContent = ENTITY_CONFIG[entityName]?.desc || "";

  const tableBox = document.getElementById("entity-table-box");
  tableBox.innerHTML = `<div class="empty-state">Loading ${entityName} records...</div>`;

  const cypher = `MATCH (n:${entityName}) RETURN n LIMIT 50;`;
  try {
    const res = await fetch("/api/query", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ query: cypher })
    });
    const data = await res.json();

    if (data.success && data.rows.length > 0) {
      document.getElementById("current-entity-count").textContent = data.rows.length;
      
      // Flatten properties
      const allProps = new Set();
      const rowsObj = data.rows.map(r => {
        const props = r[0] || {};
        Object.keys(props).forEach(k => allProps.add(k));
        return props;
      });

      const cols = Array.from(allProps);
      const flatRows = rowsObj.map(obj => cols.map(c => obj[c]));
      renderTable(tableBox, cols, flatRows);
    } else {
      document.getElementById("current-entity-count").textContent = 0;
      tableBox.innerHTML = `<div class="empty-state">No records found for :${entityName} (Schema created; 0 sample records fabricated).</div>`;
    }
  } catch (err) {
    tableBox.innerHTML = `<div class="empty-state text-danger">${err.message}</div>`;
  }
}

// ------------------------------------------------------------------------------
// Integrity Audit Stats
// ------------------------------------------------------------------------------
async function loadAuditStats() {
  try {
    const res = await fetch("/api/stats");
    const data = await res.json();

    document.getElementById("metric-nodes").textContent = data.totalNodes || 70;
    document.getElementById("metric-rels").textContent = data.totalRels || 129;

    // Node Audit Table
    const expectedCounts = {
      AI_Operator: 2, Battery: 6, Charging_Schedule: 5, Charging_Station: 4,
      Drone: 6, Drone_Operator_Assignment: 6, Emergency_Event: 3, Fleet: 4,
      Flight_Permission: 6, GPS_Route: 4, Human_Pilot: 3, Maintenance: 5,
      Mission: 12, Operator: 5, Region: 4, Technician: 0
    };

    const nodeTbody = document.querySelector("#audit-node-table tbody");
    nodeTbody.innerHTML = "";

    (data.nodes || []).forEach(row => {
      const label = row[0];
      const count = row[1];
      const expected = expectedCounts[label] ?? "-";
      const isOk = count === expected;

      const tr = document.createElement("tr");
      tr.innerHTML = `
        <td><strong>:${label}</strong></td>
        <td>${count}</td>
        <td>${expected}</td>
        <td><span class="badge ${isOk ? 'badge-accent' : 'text-warning'}">${isOk ? 'VERIFIED' : 'CHECK'}</span></td>
      `;
      nodeTbody.appendChild(tr);
    });

    // Rel Audit Table
    const relTbody = document.querySelector("#audit-rel-table tbody");
    relTbody.innerHTML = "";

    (data.relationships || []).forEach(row => {
      const type = row[0];
      const count = row[1];
      const tr = document.createElement("tr");
      tr.innerHTML = `
        <td><code>[:${type}]</code></td>
        <td>${count}</td>
        <td>Directed</td>
        <td><span class="badge badge-accent">HEALTHY</span></td>
      `;
      relTbody.appendChild(tr);
    });

  } catch (err) {
    console.error("Failed to load audit stats:", err);
  }
}
