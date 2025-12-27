# ⚡ Quick Start Guide

Get **Explain This Camera** running in 5 minutes!

---

## 🎯 Prerequisites Checklist

- [ ] Python 3.8 or higher installed
- [ ] Modern web browser (Chrome/Firefox/Safari)
- [ ] Webcam available
- [ ] Internet connection (for API calls)

---

## 📦 Step 1: Get a Gemini API Key (2 minutes)

1. Go to: https://makersuite.google.com/app/apikey
2. Sign in with Google account
3. Click "Create API Key"
4. Copy the key

**💡 It's FREE!** Gemini offers generous free tier - perfect for hackathons.

---

## 🚀 Step 2: Install & Setup (2 minutes)

```bash
# Navigate to project directory
cd explain-this-camera

# Set up Python backend
cd backend
python -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create .env file with your API key
echo "GEMINI_API_KEY=paste_your_key_here" > .env
# Or manually create .env file and add: GEMINI_API_KEY=your_key
```

---

## ▶️ Step 3: Run the Application (1 minute)

**Terminal 1 - Backend:**
```bash
cd backend
source venv/bin/activate  # If not already activated
uvicorn main:app --reload --port 8000
```

You should see:
```
INFO:     Uvicorn running on http://127.0.0.1:8000
INFO:     Application startup complete.
```

**Terminal 2 - Frontend:**
```bash
cd frontend
python -m http.server 3000
```

You should see:
```
Serving HTTP on 0.0.0.0 port 3000 (http://0.0.0.0:3000/) ...
```

---

## 🎮 Step 4: Use the Application

1. Open browser: http://localhost:3000
2. Click **"Start Camera"** and grant permissions
3. Point camera at an object
4. Select explanation mode (Kid/Student/Expert)
5. Click **"Explain What You See"**
6. Watch the magic! ✨

---

## 🐛 Troubleshooting

### "Module not found" error
```bash
# Make sure you're in the virtual environment
source venv/bin/activate  # macOS/Linux
# or
venv\Scripts\activate  # Windows

# Reinstall dependencies
pip install -r requirements.txt
```

### "Cannot connect to backend"
- Ensure backend is running on port 8000
- Check terminal for error messages
- Try: http://localhost:8000 in browser (should show API info)

### "API key not configured"
- Check `.env` file exists in `backend/` directory
- Verify format: `GEMINI_API_KEY=your_actual_key`
- No quotes, no spaces around `=`
- Restart backend server after creating `.env`

### Camera not working
- Grant camera permissions when prompted
- Close other apps using camera (Zoom, Skype, etc.)
- Try different browser
- Use http://localhost:3000 (not 127.0.0.1)

---

## ✅ Verification

Your setup is working if:

- ✅ Backend shows: "Uvicorn running on http://127.0.0.1:8000"
- ✅ Frontend loads at http://localhost:3000
- ✅ Camera preview shows live video
- ✅ "Explain What You See" button is enabled
- ✅ Clicking it produces an explanation

---

## 🎬 Ready to Demo?

Check out **DEMO_SCRIPT.md** for judge presentation tips!

---

## 🆘 Still Stuck?

1. Check full **README.md** for detailed troubleshooting
2. Verify all prerequisites are installed
3. Ensure no other services are using ports 8000 or 3000
4. Try restarting both servers

---

**You're all set! Now go win that hackathon! 🏆**
