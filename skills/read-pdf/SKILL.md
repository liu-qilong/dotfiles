---
name: read-pdf
description: Read text content from PDF files reliably using Python libraries. Use when working with PDF files, extracting text from PDFs, summarizing PDF documents, or when PDF content needs to be processed as text.
---

# PDF to Text Conversion

## Quick Start

**Primary method:** Use `pypdf` for best text extraction quality.

Three ready-to-use scripts are available:
- `read_w_pypdf.py` - Using pypdf (recommended - best quality)
- `read_w_pdfplumber.py` - Using pdfplumber (backup option)
- `read_w_pypdf2.py` - Using PyPDF2 (legacy backup)

Usage: `python read_w_pypdf.py --pdf_path /path/to/file.pdf`


## Using the Scripts

### read_w_pypdf.py (Recommended)

Uses the `pypdf` library for best text extraction quality. Provides proper spacing, citation formatting, and handles line breaks correctly.

```bash
python read_w_pypdf.py --pdf_path /path/to/file.pdf
```

### read_w_pdfplumber.py (Backup)

Uses the `pdfplumber` library as a backup option. May have word concatenation issues with some PDFs.

```bash
python read_w_pdfplumber.py --pdf_path /path/to/file.pdf
```

### read_w_pypdf2.py (Legacy Backup)

Uses the `PyPDF2` library for compatibility with older systems. Use only if pypdf is unavailable.

```bash
python read_w_pypdf2.py --pdf_path /path/to/file.pdf
```

## Output Format

Extracted text should be:
- Preserved with original line breaks where possible
- Formatted as plain text
- Ready for further processing (summarization, analysis, etc.)

## Notes

- Scanned PDFs: Require OCR (not covered in this skill)
- Encrypted PDFs: May require password handling
- Complex layouts: May need specialized extraction (tables, forms)
