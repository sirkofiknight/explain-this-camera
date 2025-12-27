#!/bin/bash

# Explain This Camera - Backend Startup Script
# This script helps you start the backend server correctly

echo "🚀 Starting Explain This Camera Backend..."
echo ""

# Check if we're in the right directory
if [ ! -f "main.py" ]; then
    echo "❌ Error: main.py not found!"
    echo "Please run this script from the backend/ directory:"
    echo "  cd backend"
    echo "  bash start.sh"
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Virtual environment not found. Creating one..."
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create virtual environment"
        echo "Make sure Python 3.8+ is installed"
        exit 1
    fi
    echo "✅ Virtual environment created"
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install -q -r requirements.txt
if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi
echo "✅ Dependencies installed"

# Check for .env file
if [ ! -f ".env" ]; then
    echo "⚠️  Warning: .env file not found!"
    echo ""
    echo "Please create a .env file with your Gemini API key:"
    echo "  1. Copy the example: cp .env.example .env"
    echo "  2. Edit .env and add your key: GEMINI_API_KEY=your_key_here"
    echo "  3. Get a free key at: https://makersuite.google.com/app/apikey"
    echo ""
    read -p "Press Enter to continue anyway (server will start but API calls will fail)..."
else
    # Check if API key is set
    if grep -q "your_api_key_here" .env; then
        echo "⚠️  Warning: .env file contains placeholder API key!"
        echo "Please edit .env and replace 'your_api_key_here' with your actual Gemini API key"
        echo "Get a free key at: https://makersuite.google.com/app/apikey"
        echo ""
        read -p "Press Enter to continue anyway (API calls will fail)..."
    else
        echo "✅ .env file found"
    fi
fi

echo ""
echo "🎉 Starting FastAPI server..."
echo "📡 Backend will be available at: http://localhost:8000"
echo "📚 API docs at: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop the server"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Start the server
uvicorn main:app --reload --port 8000 --host 0.0.0.0
