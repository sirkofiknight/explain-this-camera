#!/bin/bash

# Explain This Camera - Connection Test Script
# Run this to diagnose issues

echo "🧪 Testing Explain This Camera Setup..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Test backend
echo "1️⃣  Testing Backend (port 8000)..."
BACKEND_RESPONSE=$(curl -s http://localhost:8000/ 2>&1)

if echo "$BACKEND_RESPONSE" | grep -q "Explain This Camera API"; then
    echo "   ✅ Backend is running and responding!"
    echo "   Response: $(echo $BACKEND_RESPONSE | jq -r '.service' 2>/dev/null || echo 'API is up')"
else
    echo "   ❌ Backend is NOT running!"
    echo "   Fix: cd backend && bash start.sh"
    echo ""
    echo "   Or manually:"
    echo "   cd backend"
    echo "   source venv/bin/activate"
    echo "   uvicorn main:app --reload --port 8000"
fi

echo ""

# Test frontend
echo "2️⃣  Testing Frontend (port 3000)..."
FRONTEND_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/ 2>&1)

if [ "$FRONTEND_RESPONSE" = "200" ]; then
    echo "   ✅ Frontend is running!"
else
    echo "   ❌ Frontend is NOT running!"
    echo "   Fix: cd frontend && bash start.sh"
    echo ""
    echo "   Or manually:"
    echo "   cd frontend"
    echo "   python3 -m http.server 3000"
fi

echo ""

# Check .env file
echo "3️⃣  Checking API Key Configuration..."
if [ -f "backend/.env" ]; then
    if grep -q "your_api_key_here" backend/.env 2>/dev/null; then
        echo "   ⚠️  .env file has PLACEHOLDER key!"
        echo "   Fix:"
        echo "   1. Get a free key: https://makersuite.google.com/app/apikey"
        echo "   2. Edit backend/.env and replace placeholder"
    elif grep -q "GEMINI_API_KEY=" backend/.env 2>/dev/null; then
        echo "   ✅ .env file configured!"
    else
        echo "   ⚠️  .env file exists but may be empty"
        echo "   Add: GEMINI_API_KEY=your_key_here"
    fi
else
    echo "   ❌ .env file NOT found!"
    echo "   Fix:"
    echo "   cd backend"
    echo "   cp .env.example .env"
    echo "   # Edit .env and add your API key"
fi

echo ""

# Check Python dependencies
echo "4️⃣  Checking Python Dependencies..."
if [ -d "backend/venv" ]; then
    echo "   ✅ Virtual environment exists"

    # Check if fastapi is installed
    if backend/venv/bin/python -c "import fastapi" 2>/dev/null; then
        echo "   ✅ Dependencies installed"
    else
        echo "   ⚠️  Dependencies may not be installed"
        echo "   Fix:"
        echo "   cd backend"
        echo "   source venv/bin/activate"
        echo "   pip install -r requirements.txt"
    fi
else
    echo "   ❌ Virtual environment NOT found!"
    echo "   Fix:"
    echo "   cd backend"
    echo "   python3 -m venv venv"
    echo "   source venv/bin/activate"
    echo "   pip install -r requirements.txt"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Final summary
BACKEND_OK=$(echo "$BACKEND_RESPONSE" | grep -q "Explain This Camera API" && echo "yes" || echo "no")
FRONTEND_OK=$([ "$FRONTEND_RESPONSE" = "200" ] && echo "yes" || echo "no")

if [ "$BACKEND_OK" = "yes" ] && [ "$FRONTEND_OK" = "yes" ]; then
    echo "🎉 Everything looks good!"
    echo ""
    echo "✅ Backend running: http://localhost:8000"
    echo "✅ Frontend running: http://localhost:3000"
    echo ""
    echo "🚀 Ready to go! Open: http://localhost:3000"
else
    echo "⚠️  Some issues found. Follow the fixes above."
    echo ""
    echo "📚 For detailed help, see: TROUBLESHOOTING.md"
fi

echo ""
