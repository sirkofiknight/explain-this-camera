# 🚨 Troubleshooting Guide

## Common Error: "Analysis failed: Failed to fetch"

This error means the **frontend cannot connect to the backend**. Here's how to fix it:

---

## ✅ Step-by-Step Fix

### 1. **Check if Backend is Running**

Open a terminal and run:
```bash
curl http://localhost:8000/
```

**Expected output:**
```json
{
  "service": "Explain This Camera API",
  "status": "running",
  "version": "1.0.0"
}
```

**If you get an error**, the backend is NOT running. Continue to step 2.

---

### 2. **Start the Backend Server**

#### Option A: Using the startup script (Recommended)

```bash
cd backend
bash start.sh
```

#### Option B: Manual startup

```bash
cd backend

# Create virtual environment (first time only)
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies (first time only)
pip install -r requirements.txt

# Create .env file with your API key
echo "GEMINI_API_KEY=your_actual_key_here" > .env

# Start the server
uvicorn main:app --reload --port 8000
```

**You should see:**
```
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

---

### 3. **Verify Backend is Working**

In another terminal:
```bash
curl http://localhost:8000/
```

Or open in browser: http://localhost:8000

---

### 4. **Start the Frontend**

In a **NEW terminal** (keep backend running!):

```bash
cd frontend
python3 -m http.server 3000
```

Or use the startup script:
```bash
cd frontend
bash start.sh
```

---

### 5. **Open the Application**

Go to: **http://localhost:3000**

---

## 🔍 Still Not Working? Advanced Troubleshooting

### Error: "GEMINI_API_KEY not found"

**Fix:**
```bash
cd backend

# Create .env file
cat > .env << EOF
GEMINI_API_KEY=your_actual_api_key_here
EOF

# Restart backend server
```

**Get a FREE API key:** https://makersuite.google.com/app/apikey

---

### Error: "Port 8000 already in use"

**Fix:**
```bash
# Find what's using port 8000
lsof -i :8000

# Kill the process
kill -9 <PID>

# Or use a different port
uvicorn main:app --reload --port 8001
```

If you use port 8001, update `frontend/script.js`:
```javascript
const API_BASE_URL = 'http://localhost:8001';  // Change 8000 to 8001
```

---

### Error: "ModuleNotFoundError: No module named 'fastapi'"

**Fix:**
```bash
cd backend
source venv/bin/activate  # Make sure venv is activated!
pip install -r requirements.txt
```

---

### Error: CORS or "blocked by CORS policy"

**Fix:** Make sure you're using `http://localhost:3000`, not `http://127.0.0.1:3000`

If still broken, update `backend/main.py`:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://127.0.0.1:3000"],  # Add both
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

### Camera not working but API is fine

**Checks:**
- ✅ Grant camera permissions when browser asks
- ✅ Use `http://localhost:3000` (not `http://127.0.0.1:3000`)
- ✅ Close other apps using camera (Zoom, Skype, etc.)
- ✅ Try a different browser (Chrome works best)

---

## 🧪 Quick Test Script

Save this as `test_connection.sh` and run it:

```bash
#!/bin/bash

echo "🧪 Testing Explain This Camera Setup..."
echo ""

# Test backend
echo "1️⃣ Testing backend..."
BACKEND_RESPONSE=$(curl -s http://localhost:8000/ 2>&1)

if echo "$BACKEND_RESPONSE" | grep -q "Explain This Camera API"; then
    echo "   ✅ Backend is running!"
else
    echo "   ❌ Backend is NOT running!"
    echo "   Start it with: cd backend && bash start.sh"
fi

echo ""

# Test frontend
echo "2️⃣ Testing frontend..."
FRONTEND_RESPONSE=$(curl -s http://localhost:3000/ 2>&1)

if echo "$FRONTEND_RESPONSE" | grep -q "Explain This Camera"; then
    echo "   ✅ Frontend is running!"
else
    echo "   ❌ Frontend is NOT running!"
    echo "   Start it with: cd frontend && bash start.sh"
fi

echo ""

# Check .env file
echo "3️⃣ Checking API key..."
if [ -f "backend/.env" ]; then
    if grep -q "your_api_key_here" backend/.env; then
        echo "   ⚠️  .env file has placeholder key!"
        echo "   Get a real key at: https://makersuite.google.com/app/apikey"
    else
        echo "   ✅ .env file configured!"
    fi
else
    echo "   ❌ .env file not found!"
    echo "   Create it: cd backend && cp .env.example .env"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
```

---

## 📋 Complete Startup Checklist

- [ ] Backend server running on port 8000
- [ ] Frontend server running on port 3000
- [ ] `.env` file created with valid API key
- [ ] Virtual environment activated
- [ ] Dependencies installed
- [ ] Can access http://localhost:8000 (shows API info)
- [ ] Can access http://localhost:3000 (shows camera app)
- [ ] Camera permissions granted in browser

---

## 🆘 Emergency Reset

If everything is broken, start fresh:

```bash
# Stop all servers (Ctrl+C in each terminal)

# Clean up
cd backend
rm -rf venv
rm .env

# Start over
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
echo "GEMINI_API_KEY=your_key_here" > .env

# Start backend
uvicorn main:app --reload --port 8000

# In new terminal - start frontend
cd frontend
python3 -m http.server 3000
```

---

## 💡 Pro Tips

1. **Always keep TWO terminals open:**
   - Terminal 1: Backend server
   - Terminal 2: Frontend server

2. **Check backend logs** for detailed error messages

3. **Use browser DevTools** (F12) → Console tab to see frontend errors

4. **Test API directly** before trying the UI:
   ```bash
   curl http://localhost:8000/modes
   ```

---

## 🎯 Quick Reference

| Problem | Solution |
|---------|----------|
| "Failed to fetch" | Backend not running → Start it |
| "API key not configured" | Create `.env` file with key |
| "Port already in use" | Kill existing process or use different port |
| "Module not found" | Activate venv and install requirements |
| Camera not working | Grant permissions, use http://localhost |
| CORS error | Use localhost not 127.0.0.1 |

---

**Need more help?** Check:
- Backend logs (terminal running uvicorn)
- Browser console (F12 → Console)
- Network tab (F12 → Network) to see failed requests

---

**Still stuck?** The issue is 99% likely to be:
1. Backend not running
2. Wrong API key
3. Dependencies not installed

Go through the "Complete Startup Checklist" above!
