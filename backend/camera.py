"""
Camera utilities for image processing.
Note: In this implementation, the frontend handles camera capture.
This file contains utilities for image processing and validation.
"""

import base64
import io
from PIL import Image
from typing import Tuple

def decode_base64_image(base64_string: str) -> Image.Image:
    """
    Decode a base64 encoded image string into a PIL Image.

    Args:
        base64_string: Base64 encoded image (with or without data URI prefix)

    Returns:
        PIL Image object
    """
    # Remove data URI prefix if present
    if ',' in base64_string:
        base64_string = base64_string.split(',')[1]

    # Decode base64 to bytes
    image_bytes = base64.b64decode(base64_string)

    # Convert bytes to PIL Image
    image = Image.open(io.BytesIO(image_bytes))

    return image

def validate_image(image: Image.Image) -> Tuple[bool, str]:
    """
    Validate that the image meets basic requirements.

    Args:
        image: PIL Image object

    Returns:
        Tuple of (is_valid, error_message)
    """
    # Check image size (not too small, not too large)
    width, height = image.size

    if width < 100 or height < 100:
        return False, "Image too small (minimum 100x100 pixels)"

    if width > 4096 or height > 4096:
        return False, "Image too large (maximum 4096x4096 pixels)"

    # Check format
    if image.format not in ['JPEG', 'PNG', 'WEBP', None]:
        return False, f"Unsupported format: {image.format}"

    return True, ""

def prepare_image_for_api(base64_string: str) -> str:
    """
    Prepare image for vision API.

    Args:
        base64_string: Base64 encoded image

    Returns:
        Clean base64 string without data URI prefix
    """
    # Remove data URI prefix if present
    if ',' in base64_string:
        base64_string = base64_string.split(',')[1]

    return base64_string
