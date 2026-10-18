#!/usr/bin/env bash
# ==============================================================================
# seed.sh - Automated Seed and Validation Script for Drone Fleet Database
# ==============================================================================

set -e

CONTAINER_NAME="${NEO4J_CONTAINER:-neo4j-drone}"
USER="${NEO4J_USER:-neo4j}"
PASSWORD="${NEO4J_PASSWORD:-dronepassword}"

echo "=================================================================="
echo "🚁 Seeding Drone Fleet Management Database in Neo4j..."
echo "=================================================================="

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "⚠️  Container '${CONTAINER_NAME}' is not running."
    echo "Starting container via docker-compose..."
    docker compose up -d
    echo "Waiting for Neo4j to initialize..."
    sleep 10
fi

# Run Master Seed Script
echo "📥 Executing cypher/00_all_in_one_seed.cypher..."
docker exec -i "${CONTAINER_NAME}" cypher-shell -u "${USER}" -p "${PASSWORD}" < cypher/00_all_in_one_seed.cypher

echo ""
echo "🔍 Running cypher/17_validation_queries.cypher..."
docker exec -i "${CONTAINER_NAME}" cypher-shell -u "${USER}" -p "${PASSWORD}" < cypher/17_validation_queries.cypher

echo ""
echo "=================================================================="
echo "✅ Database successfully seeded and verified!"
echo "🌐 Neo4j Browser: http://localhost:7474 (user: ${USER}, pass: ${PASSWORD})"
echo "🚀 Web Dashboard: Run 'PORT=5050 python3 server.py' then visit http://localhost:5050"
echo "=================================================================="
