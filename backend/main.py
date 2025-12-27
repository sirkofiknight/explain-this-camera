"""
FastAPI backend for Explain This Camera.
Provides API endpoint for analyzing images with adaptive explanations.
"""

import os
import base64
from datetime import datetime
from typing import Literal
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import google.generativeai as genai
from dotenv import load_dotenv

from prompts import get_analysis_prompt, get_user_prompt
from camera import decode_base64_image, validate_image, prepare_image_for_api

# Load environment variables
load_dotenv()

# Initialize FastAPI app
app = FastAPI(
    title="Explain This Camera API",
    description="Adaptive real-time image explanation system",
    version="1.0.0"
)

# Enable CORS for local development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configure Gemini API
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    print("⚠️  WARNING: GEMINI_API_KEY not found in environment variables")
    print("Please create a .env file with your API key")
else:
    genai.configure(api_key=GEMINI_API_KEY)

# Request/Response Models
class AnalyzeRequest(BaseModel):
    image: str  # Base64 encoded image
    mode: Literal["kid", "student", "expert"]

class AnalyzeResponse(BaseModel):
    explanation: str
    mode: str
    timestamp: str
    success: bool

# API Endpoints
@app.get("/")
async def root():
    """Health check endpoint."""
    return {
        "service": "Explain This Camera API",
        "status": "running",
        "version": "1.0.0",
        "endpoints": {
            "/analyze": "POST - Analyze image with adaptive explanation"
        }
    }

@app.post("/analyze", response_model=AnalyzeResponse)
async def analyze_image(request: AnalyzeRequest):
    """
    Analyze an image and return explanation based on selected mode.

    Args:
        request: AnalyzeRequest containing base64 image and explanation mode

    Returns:
        AnalyzeResponse with explanation and metadata
    """
    try:
        # Validate API key
        if not GEMINI_API_KEY:
            raise HTTPException(
                status_code=500,
                detail="API key not configured. Please add GEMINI_API_KEY to .env file"
            )

        # Decode and validate image
        try:
            image = decode_base64_image(request.image)
            is_valid, error_msg = validate_image(image)
            if not is_valid:
                raise HTTPException(status_code=400, detail=error_msg)
        except Exception as e:
            raise HTTPException(
                status_code=400,
                detail=f"Invalid image data: {str(e)}"
            )

        # Get the appropriate system prompt for the mode
        system_prompt = get_analysis_prompt(request.mode)
        user_prompt = get_user_prompt()

        # Initialize Gemini model
        model = genai.GenerativeModel(
            model_name="gemini-1.5-flash",
            system_instruction=system_prompt
        )

        # Prepare image for API
        clean_base64 = prepare_image_for_api(request.image)

        # Create image part for Gemini
        image_part = {
            "mime_type": "image/jpeg",
            "data": clean_base64
        }

        # Generate explanation
        response = model.generate_content([user_prompt, image_part])

        # Extract explanation text
        explanation = response.text

        return AnalyzeResponse(
            explanation=explanation,
            mode=request.mode,
            timestamp=datetime.now().isoformat(),
            success=True
        )

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error analyzing image: {str(e)}"
        )

@app.get("/modes")
async def get_modes():
    """
    Get available explanation modes and their descriptions.
    """
    return {
        "modes": [
            {
                "id": "kid",
                "name": "👶 Kid Mode",
                "description": "Simple, friendly explanations for children"
            },
            {
                "id": "student",
                "name": "🎓 Student Mode",
                "description": "Clear educational explanations with examples"
            },
            {
                "id": "expert",
                "name": "🧠 Expert Mode",
                "description": "Precise technical language for specialists"
            }
        ]
    }

# Run with: uvicorn main:app --reload --port 8000
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
