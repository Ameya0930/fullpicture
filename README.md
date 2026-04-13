# The FullPicture

Hosted site: [https://ameya0930.github.io/fullpicture/](https://ameya0930.github.io/fullpicture/)

## What it is

The FullPicture is a news-reading web app designed to compare political framing across outlets.

## Local backend

For the full Flask-backed version with Excel saving on Desktop, run:

```bash
python3 server.py
```

The backend stores workbook data at:

`~/Desktop/Excel/fullpicture_data.xlsx`

## GitHub Pages

The GitHub Pages build is a static frontend publish.
Backend-only features such as Flask sessions and Desktop Excel saving require the local server.
