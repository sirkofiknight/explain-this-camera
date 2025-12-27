/**
 * Explain This Camera - Frontend JavaScript
 * Handles camera access, image capture, and API communication
 */

// Configuration
const API_BASE_URL = 'http://localhost:8000';

// DOM Elements
const camera = document.getElementById('camera');
const canvas = document.getElementById('canvas');
const cameraPlaceholder = document.getElementById('camera-placeholder');
const startCameraBtn = document.getElementById('start-camera-btn');
const stopCameraBtn = document.getElementById('stop-camera-btn');
const analyzeBtn = document.getElementById('analyze-btn');
const modeSelect = document.getElementById('mode');
const currentModeBadge = document.getElementById('current-mode');
const resultBox = document.getElementById('result');
const loadingBox = document.getElementById('loading');
const errorBox = document.getElementById('error');

// State
let stream = null;
let isAnalyzing = false;

// Mode display names
const MODE_NAMES = {
    'kid': '👶 Kid Mode',
    'student': '🎓 Student Mode',
    'expert': '🧠 Expert Mode'
};

/**
 * Initialize the application
 */
function init() {
    // Set up event listeners
    startCameraBtn.addEventListener('click', startCamera);
    stopCameraBtn.addEventListener('click', stopCamera);
    analyzeBtn.addEventListener('click', analyzeImage);
    modeSelect.addEventListener('change', updateModeDisplay);

    // Check API connectivity
    checkAPIConnection();
}

/**
 * Check if the backend API is running
 */
async function checkAPIConnection() {
    try {
        const response = await fetch(`${API_BASE_URL}/`);
        if (!response.ok) {
            showError('Backend API is not responding. Make sure the server is running.');
        }
    } catch (error) {
        showError('Cannot connect to backend. Please start the server with: cd backend && uvicorn main:app --reload');
    }
}

/**
 * Start the camera stream
 */
async function startCamera() {
    try {
        // Request camera access
        stream = await navigator.mediaDevices.getUserMedia({
            video: {
                width: { ideal: 1280 },
                height: { ideal: 720 },
                facingMode: 'environment'
            }
        });

        // Set stream to video element
        camera.srcObject = stream;
        camera.style.display = 'block';
        cameraPlaceholder.style.display = 'none';

        // Update UI
        startCameraBtn.style.display = 'none';
        stopCameraBtn.style.display = 'inline-block';
        analyzeBtn.disabled = false;

        hideError();
    } catch (error) {
        console.error('Error accessing camera:', error);
        showError('Could not access camera. Please ensure you have granted camera permissions.');
    }
}

/**
 * Stop the camera stream
 */
function stopCamera() {
    if (stream) {
        stream.getTracks().forEach(track => track.stop());
        stream = null;
    }

    camera.style.display = 'none';
    cameraPlaceholder.style.display = 'flex';
    startCameraBtn.style.display = 'inline-block';
    stopCameraBtn.style.display = 'none';
    analyzeBtn.disabled = true;
}

/**
 * Capture current frame from camera as base64
 */
function captureFrame() {
    // Set canvas dimensions to match video
    canvas.width = camera.videoWidth;
    canvas.height = camera.videoHeight;

    // Draw current video frame to canvas
    const context = canvas.getContext('2d');
    context.drawImage(camera, 0, 0, canvas.width, canvas.height);

    // Convert to base64 JPEG
    return canvas.toDataURL('image/jpeg', 0.8);
}

/**
 * Analyze the current camera frame
 */
async function analyzeImage() {
    if (isAnalyzing) return;

    try {
        isAnalyzing = true;
        analyzeBtn.disabled = true;

        // Show loading state
        resultBox.style.display = 'none';
        loadingBox.style.display = 'flex';
        hideError();

        // Capture frame
        const imageData = captureFrame();
        const mode = modeSelect.value;

        // Send to API
        const response = await fetch(`${API_BASE_URL}/analyze`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                image: imageData,
                mode: mode
            })
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.detail || 'Analysis failed');
        }

        const data = await response.json();

        // Display result
        displayResult(data.explanation, data.mode);

    } catch (error) {
        console.error('Analysis error:', error);
        showError(`Analysis failed: ${error.message}`);
        resultBox.style.display = 'block';
    } finally {
        isAnalyzing = false;
        analyzeBtn.disabled = false;
        loadingBox.style.display = 'none';
    }
}

/**
 * Display analysis result
 */
function displayResult(explanation, mode) {
    resultBox.innerHTML = `<p class="result-text">${escapeHtml(explanation)}</p>`;
    resultBox.style.display = 'block';
    currentModeBadge.textContent = MODE_NAMES[mode];
}

/**
 * Update mode display when selection changes
 */
function updateModeDisplay() {
    const mode = modeSelect.value;
    currentModeBadge.textContent = MODE_NAMES[mode];
}

/**
 * Show error message
 */
function showError(message) {
    errorBox.textContent = message;
    errorBox.style.display = 'block';
}

/**
 * Hide error message
 */
function hideError() {
    errorBox.style.display = 'none';
}

/**
 * Escape HTML to prevent XSS
 */
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

/**
 * Handle keyboard shortcuts
 */
document.addEventListener('keydown', (e) => {
    // Space or Enter to analyze (when camera is active)
    if ((e.key === ' ' || e.key === 'Enter') && !analyzeBtn.disabled && !isAnalyzing) {
        e.preventDefault();
        analyzeImage();
    }

    // Number keys to switch modes
    if (e.key === '1') {
        modeSelect.value = 'kid';
        updateModeDisplay();
    } else if (e.key === '2') {
        modeSelect.value = 'student';
        updateModeDisplay();
    } else if (e.key === '3') {
        modeSelect.value = 'expert';
        updateModeDisplay();
    }
});

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}
