#!/usr/bin/env python3
"""
Extract text from PDF files using pypdf.
"""
import argparse
import sys
from pypdf import PdfReader


def extract_text(pdf_path):
    """Extract text from PDF using pypdf."""
    try:
        reader = PdfReader(pdf_path)
        text_parts = []
        for page in reader.pages:
            page_text = page.extract_text()
            if page_text:
                text_parts.append(page_text)
        return "\n".join(text_parts)
    except Exception as e:
        print(f"Error reading PDF: {e}", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Extract text from PDF files using pypdf"
    )
    parser.add_argument(
        "--pdf_path",
        required=True,
        help="Path to the PDF file to extract text from"
    )

    args = parser.parse_args()

    text = extract_text(args.pdf_path)
    print(text)


if __name__ == "__main__":
    main()
