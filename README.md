# 📸 Explain This Camera

**An adaptive real-time camera system that explains what it sees at different understanding levels.**

Point your camera at anything, and get explanations tailored for Kids, Students, or Experts - powered by AI vision and prompt engineering.

---

## ⚡ **Quick Start (5 Minutes)**

```bash
# 1. Get FREE Gemini API key: https://makersuite.google.com/app/apikey

# 2. Start Backend (Terminal 1)
cd backend
bash start.sh  # This handles everything: venv, dependencies, .env check

# 3. Start Frontend (Terminal 2)
cd frontend
bash start.sh

# 4. Open http://localhost:3000 and start exploring!
```

**💡 Tip:** Run `./test_connection.sh` to diagnose any issues!

**🚨 Getting "Failed to fetch" error?** See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 🎯 Problem Statement

Current AI vision systems provide one-size-fits-all explanations. A child and an expert seeing the same object get the same technical description. This creates:

- **Accessibility gaps** - Complex explanations confuse beginners
- **Missed learning opportunities** - Experts want deeper technical insights
- **Poor user experience** - No adaptation to audience knowledge level

**Explain This Camera** solves this by dynamically adapting its language, depth, and tone based on the selected audience level.

---

## ✨ Why This is Unique

Unlike simple object detection or captioning tools, this system:

1. **Adaptive Explanations**: Same image, three completely different outputs
2. **Prompt Engineering Showcase**: No model training - pure prompt design
3. **Real-time Interaction**: Live camera feed with instant analysis
4. **Educational Value**: Demonstrates how AI can democratize knowledge
5. **Hackathon-Ready**: Simple tech stack, impressive demo, clear value prop

---

## 🧠 How It Works

```
┌─────────────┐      ┌──────────────┐      ┌─────────────────┐
│   Camera    │─────▶│  Frontend    │─────▶│    Backend      │
│  (WebRTC)   │      │  (Vanilla JS)│      │   (FastAPI)     │
└─────────────┘      └──────────────┘      └─────────────────┘
                             │                       │
                             │                       ▼
                             │              ┌─────────────────┐
                             │              │ Prompt Engine   │
                             │              │ (mode-specific) │
                             │              └─────────────────┘
                             │                       │
                             │                       ▼
                             │              ┌─────────────────┐
                             │◀─────────────│  Gemini Vision  │
                             │              │      API        │
                             ▼              └─────────────────┘
                     ┌──────────────┐
                     │   Display    │
                     │  Explanation │
                     └──────────────┘
```

### Step-by-Step Process:

1. **Camera Capture**: Browser accesses webcam via WebRTC
2. **Frame Extraction**: Current frame converted to base64 JPEG
3. **Mode Selection**: User chooses explanation level (Kid/Student/Expert)
4. **API Request**: Image + mode sent to FastAPI backend
5. **Prompt Engineering**: System prompt loaded based on mode
6. **Vision Analysis**: Gemini Vision API analyzes image with custom prompt
7. **Adaptive Response**: AI generates explanation matching selected mode
8. **Display**: Result shown in clean, readable format

---

## 🚀 Setup Instructions

### Prerequisites

- Python 3.8+
- Modern web browser (Chrome, Firefox, Safari)
- Google Gemini API key ([Get it free here](https://makersuite.google.com/app/apikey))

### Installation

```bash
# 1. Clone or download the project
cd explain-this-camera

# 2. Set up backend
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# 3. Configure API key
# Create .env file in backend/ directory
echo "GEMINI_API_KEY=your_api_key_here" > .env

# 4. Start backend server
uvicorn main:app --reload --port 8000
```

In a **separate terminal**:

```bash
# 5. Start frontend (simple HTTP server)
cd frontend
python -m http.server 3000
```

### Access the Application

Open your browser and navigate to:
```
http://localhost:3000
```

---

## 🎬 How to Demo (Under 2 Minutes)

### Setup (30 seconds)
1. Open `http://localhost:3000`
2. Click "Start Camera" and grant permissions
3. Point camera at an object (e.g., coffee cup, laptop, plant)

### Demo Flow (90 seconds)

**[0:00-0:15] - Introduction**
> "Meet Explain This Camera - an AI that adapts how it explains the world based on your knowledge level."

**[0:15-0:30] - Kid Mode**
- Select "👶 Kid Mode"
- Click "Explain What You See"
- Read result aloud (simple, friendly language)
> "Notice the simple words and friendly tone - perfect for a 5-year-old."

**[0:30-0:50] - Student Mode**
- Switch to "🎓 Student Mode"
- Click analyze again (same object!)
- Read result aloud (educational, with examples)
> "Same object, but now we get educational context and real-world examples."

**[0:50-1:15] - Expert Mode**
- Switch to "🧠 Expert Mode"
- Click analyze again
- Read result aloud (technical, precise)
> "And for experts, we get technical terminology and detailed specifications."

**[1:15-1:30] - Impact Statement**
> "One camera, three audiences. This shows how AI can make knowledge accessible to everyone - from curious kids to domain experts. All through prompt engineering, no model training required."

---

## 🎤 Judge Demo Script (30-60 seconds)

### Option 1: Quick Pitch (30s)

> "Hi! I built Explain This Camera to solve a simple problem: AI vision systems don't adapt to their audience.
>
> [Point camera at object]
>
> Watch this - I'll analyze this [object] three ways. In Kid Mode, it uses simple words a 5-year-old understands. In Student Mode, it gives educational context. In Expert Mode, it uses precise technical language.
>
> Same image, three completely different explanations. All through prompt engineering - no model training. This shows how AI can democratize knowledge for any audience."

### Option 2: Extended Demo (60s)

> "The problem: Current AI vision tools give everyone the same explanation, whether you're 5 or 50. That's bad for learning and accessibility.
>
> My solution: Explain This Camera. It's a real-time system that adapts its explanations to three different knowledge levels.
>
> [Demo Kid Mode] See? Simple, friendly words.
> [Demo Student Mode] Now educational with examples.
> [Demo Expert Mode] And technical precision for specialists.
>
> What makes this unique: It's not just object detection. It's adaptive communication. The same image produces completely different outputs based on the audience.
>
> The technology: I used prompt engineering - carefully designed system prompts for each mode. No model training, just smart prompting. This proves that with the right prompts, we can make AI accessible to everyone.
>
> Future potential: Imagine this in museums, classrooms, or accessibility tools - helping people learn at their level."

---

## 🛠️ Project Structure

```
explain-this-camera/
│
├── backend/
│   ├── main.py              # FastAPI server & API endpoints
│   ├── prompts.py           # Prompt engineering templates (CORE LOGIC)
│   ├── camera.py            # Image processing utilities
│   ├── requirements.txt     # Python dependencies
│   └── .env                 # API key (create this)
│
├── frontend/
│   ├── index.html           # Main UI structure
│   ├── style.css            # Styling and responsive design
│   └── script.js            # Camera logic & API communication
│
├── README.md                # This file
└── DEMO_SCRIPT.md          # Quick demo reference
```

---

## 🔑 Key Features Explained

### 1. **Prompt Engineering (The Magic)**

Located in `backend/prompts.py`, this file contains three carefully crafted system prompts:

- **Kid Mode**: "Use simple words...", "short sentences...", "make it fun..."
- **Student Mode**: "Clear educational language...", "include examples...", "balance simplicity with accuracy..."
- **Expert Mode**: "Precise technical terminology...", "information-dense...", "skip basic explanations..."

These prompts are the **entire difference** between modes - same model, different instructions.

### 2. **Real-Time Camera**

Frontend uses WebRTC (`getUserMedia`) to access the camera. Frames are captured on-demand and converted to base64 JPEG for API transmission.

### 3. **Clean Architecture**

- **Frontend**: Pure HTML/CSS/JS - no frameworks, easy to understand
- **Backend**: FastAPI for fast, modern Python APIs
- **AI**: Gemini Vision API - free tier, excellent vision capabilities

---

## 🎯 Technical Highlights for Judges

1. **Prompt Engineering Focus**: Demonstrates advanced prompting techniques
2. **Real-Time Processing**: Live camera feed with instant analysis
3. **Clean Code**: Well-structured, commented, production-ready
4. **User Experience**: Intuitive interface, clear value demonstration
5. **Hackathon-Appropriate**: Simple stack, easy to demo, high impact

---

## 🚧 Possible Future Improvements

### Short-term (Next Hackathon!)
- **Voice Output**: Text-to-speech for each mode
- **Comparison View**: Show all three modes side-by-side
- **History**: Save and compare previous explanations
- **More Modes**: Add "Teenager", "Grandparent", "Non-native speaker"

### Medium-term
- **Custom Modes**: Let users create their own explanation styles
- **Multi-language**: Explain in different languages
- **Image Upload**: Analyze uploaded images, not just camera
- **Accessibility**: Screen reader support, high contrast mode

### Long-term
- **Educational Platform**: Built-in quizzes based on explanations
- **AR Integration**: Overlay explanations on camera view
- **Collaboration**: Share and compare explanations with others
- **Fine-tuning**: Train custom models for specific domains (medical, art, etc.)

---

## 🧪 Testing the System

### Test with Different Objects

Try pointing the camera at:
- **Everyday objects**: Coffee cup, laptop, phone
- **Complex scenes**: Busy street, office desk, kitchen
- **Nature**: Plants, sky, pets
- **Text**: Books, signs, labels

Notice how the **same object** produces vastly different explanations across modes!

### Verification Checklist

- [ ] Kid mode uses simple language (no jargon)
- [ ] Student mode includes educational context
- [ ] Expert mode uses technical terminology
- [ ] Explanations are clearly different (not just length)
- [ ] Camera preview works smoothly
- [ ] Mode switching updates results immediately

---

## 🐛 Troubleshooting

### "Cannot connect to backend"
- Ensure backend server is running: `uvicorn main:app --reload --port 8000`
- Check that port 8000 is not in use
- Verify `API_BASE_URL` in `frontend/script.js` matches your backend

### "Could not access camera"
- Grant camera permissions in browser
- Check that no other application is using the camera
- Try using HTTPS (required for some browsers)
- Use `http://localhost` instead of `http://127.0.0.1`

### "API key not configured"
- Create `.env` file in `backend/` directory
- Add: `GEMINI_API_KEY=your_actual_api_key`
- Restart the backend server
- Get key from: https://makersuite.google.com/app/apikey

### "Analysis failed"
- Check API key is valid and has quota remaining
- Ensure image is not too large (auto-resized to reasonable size)
- Check backend logs for detailed error messages
- Verify internet connection (API requires online access)

---

## 📊 Technical Specifications

- **Backend**: Python 3.8+, FastAPI 0.104+, Google Gemini 1.5 Flash
- **Frontend**: Vanilla JavaScript (ES6+), HTML5, CSS3
- **Image Format**: JPEG, base64 encoded
- **API Protocol**: REST (JSON)
- **Camera**: WebRTC getUserMedia API
- **Deployment**: Local development server (easily deployable to cloud)

---

## 📝 License

This project is created for educational and hackathon purposes. Feel free to use, modify, and build upon it!

---

## 🙋 FAQ

**Q: Do I need to train any models?**
A: No! This uses prompt engineering with existing vision models.

**Q: Can I use a different vision API?**
A: Yes! Swap Gemini with OpenAI Vision, Claude Vision, or any other multimodal API.

**Q: Does it work offline?**
A: No - it requires internet for the vision API. But the architecture could support local models.

**Q: Can I deploy this online?**
A: Yes! Deploy backend to Heroku/Railway/Vercel, frontend to Netlify/Vercel. Just add CORS configuration.

**Q: How much does it cost to run?**
A: Gemini has a generous free tier. For a hackathon demo, cost is essentially $0.

---

## 🎉 Acknowledgments

Built with:
- [Google Gemini](https://deepmind.google/technologies/gemini/) - Vision AI
- [FastAPI](https://fastapi.tiangolo.com/) - Modern Python web framework
- [WebRTC](https://webrtc.org/) - Real-time camera access

---

## 📧 Contact & Feedback

Found a bug? Have an idea? Want to contribute?

This is a hackathon project - feedback welcome!

---

**Built for hackathons. Powered by curiosity. Made with ❤️**
