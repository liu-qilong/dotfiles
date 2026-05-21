#!/usr/bin/env python3
"""
Extract text from PDF files using PyPDF2.
"""
import argparse
import sys
import PyPDF2


def extract_text(pdf_path):
    """Extract text from PDF using PyPDF2."""
    try:
        with open(pdf_path, "rb") as file:
            reader = PyPDF2.PdfReader(file)
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
        description="Extract text from PDF files using PyPDF2"
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
