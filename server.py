#!/usr/bin/env python3
"""
Drone Fleet Management Database - Web Server & API Bridge
Connects to Neo4j via HTTP REST API without requiring external dependencies.
"""

import os
import sys
import json
import base64
import urllib.request
import urllib.error
from http.server import SimpleHTTPRequestHandler, HTTPServer
import mimetypes

# Environment variables for Neo4j credentials
NEO4J_HOST = os.environ.get("NEO4J_HOST", "localhost")
NEO4J_PORT = os.environ.get("NEO4J_PORT", "7474")
NEO4J_URI = os.environ.get("NEO4J_URI", f"http://{NEO4J_HOST}:{NEO4J_PORT}")
NEO4J_USER = os.environ.get("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.environ.get("NEO4J_PASSWORD", "dronepassword")

SERVER_PORT = int(os.environ.get("PORT", "5000"))
PUBLIC_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "public")

def run_cypher(statement, parameters=None):
    url = f"{NEO4J_URI}/db/neo4j/tx/commit"
    auth_str = f"{NEO4J_USER}:{NEO4J_PASSWORD}"
    auth_b64 = base64.b64encode(auth_str.encode("utf-8")).decode("utf-8")
    
    payload = {
        "statements": [
            {
                "statement": statement,
                "parameters": parameters or {},
                "resultDataContents": ["row", "graph"]
            }
        ]
    }
    
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers={
        "Content-Type": "application/json",
        "Authorization": f"Basic {auth_b64}"
    })
    
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            resp_data = json.loads(resp.read().decode("utf-8"))
            if resp_data.get("errors"):
                return {"success": False, "errors": resp_data["errors"]}
            
            result = resp_data.get("results", [{}])[0]
            columns = result.get("columns", [])
            data_rows = result.get("data", [])
            
            rows = [item.get("row", []) for item in data_rows]
            graph_data = [item.get("graph", {}) for item in data_rows if "graph" in item]
            
            return {
                "success": True,
                "columns": columns,
                "rows": rows,
                "graph": graph_data,
                "total": len(rows)
            }
    except Exception as e:
        return {"success": False, "errors": [{"message": str(e)}]}

class DroneFleetHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=PUBLIC_DIR, **kwargs)

    def do_GET(self):
        if self.path == "/api/health":
            res = run_cypher("RETURN 1 AS status")
            self._send_json({"connected": res.get("success", False)})
            return
        
        elif self.path == "/api/stats":
            node_counts = run_cypher("MATCH (n) RETURN labels(n)[0] AS Entity, count(n) AS Total ORDER BY Entity")
            rel_counts = run_cypher("MATCH ()-[r]->() RETURN type(r) AS Relationship, count(r) AS Total ORDER BY Total DESC")
            total_nodes = run_cypher("MATCH (n) RETURN count(n) AS total")
            total_rels = run_cypher("MATCH ()-[r]->() RETURN count(r) AS total")
            
            self._send_json({
                "nodes": node_counts.get("rows", []),
                "relationships": rel_counts.get("rows", []),
                "totalNodes": total_nodes.get("rows", [[0]])[0][0] if total_nodes.get("success") else 0,
                "totalRels": total_rels.get("rows", [[0]])[0][0] if total_rels.get("success") else 0
            })
            return

        elif self.path == "/api/graph":
            cypher = """
            MATCH (n)
            OPTIONAL MATCH (n)-[r]->(m)
            RETURN n, r, m LIMIT 200
            """
            res = run_cypher(cypher)
            nodes_map = {}
            edges = []
            
            if res.get("success"):
                for g in res.get("graph", []):
                    for node in g.get("nodes", []):
                        nid = node.get("id")
                        if nid not in nodes_map:
                            lbl = node.get("labels", ["Entity"])[0]
                            props = node.get("properties", {})
                            # Pick display label
                            name = (props.get("Drone_Model") or 
                                    props.get("Operator_Name") or 
                                    props.get("Region_Name") or 
                                    props.get("Fleet_Name") or 
                                    props.get("Route_Name") or 
                                    props.get("Mission_Objective") or 
                                    props.get("Station_Name") or 
                                    props.get("Emergency_Type") or 
                                    f"{lbl} #{nid}")
                            nodes_map[nid] = {
                                "id": nid,
                                "label": name,
                                "group": lbl,
                                "properties": props
                            }
                    for rel in g.get("relationships", []):
                        edges.append({
                            "id": rel.get("id"),
                            "from": rel.get("startNode"),
                            "to": rel.get("endNode"),
                            "label": rel.get("type"),
                            "arrows": "to"
                        })
            
            self._send_json({
                "nodes": list(nodes_map.values()),
                "edges": edges
            })
            return

        return super().do_GET()

    def do_POST(self):
        if self.path == "/api/query":
            length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(length).decode("utf-8")
            try:
                data = json.loads(body)
                query = data.get("query", "").strip()
                result = run_cypher(query)
                self._send_json(result)
            except Exception as e:
                self._send_json({"success": False, "errors": [{"message": str(e)}]})
            return
        
        self.send_error(404, "Endpoint not found")

    def _send_json(self, data, status=200):
        content = json.dumps(data).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(content)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(content)

def main():
    os.makedirs(PUBLIC_DIR, exist_ok=True)
    server_address = ("0.0.0.0", SERVER_PORT)
    httpd = HTTPServer(server_address, DroneFleetHandler)
    print(f"🚀 Drone Fleet Neo4j Web Console running at http://localhost:{SERVER_PORT}")
    print(f"🔗 Connected to Neo4j at {NEO4J_URI} (User: {NEO4J_USER})")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer shutting down gracefully.")
        httpd.server_close()

if __name__ == "__main__":
    main()
