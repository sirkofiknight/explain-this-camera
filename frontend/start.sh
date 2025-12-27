#!/bin/bash

# Explain This Camera - Frontend Startup Script

echo "🎨 Starting Explain This Camera Frontend..."
echo ""

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ Error: index.html not found!"
    echo "Please run this script from the frontend/ directory:"
    echo "  cd frontend"
    echo "  bash start.sh"
    exit 1
fi

echo "✅ Found frontend files"
echo "🎉 Starting HTTP server..."
echo "📡 Frontend will be available at: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop the server"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Start the server
python3 -m http.server 3000
