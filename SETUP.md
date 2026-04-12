# The FullPicture — Setup Guide

## What this build does
- Runs a local Flask app at `http://localhost:5000`
- Uses a redesigned reading interface with a deeper 8-question ideology quiz
- Links to real reporting from outlets such as The Guardian, NPR, Fox News, AP News, and KFF
- Stores signups, quiz results, comments, article views, and submissions in Excel

## Where the Excel data goes

The workbook now lives in:

`~/Desktop/Excel/fullpicture_data.xlsx`

If `~/Desktop/Excel` does not exist yet, the backend creates it automatically on first run.

If you already had a `fullpicture_data.xlsx` file inside the project folder, the backend copies it into the Desktop Excel folder the first time it starts.

## Install dependencies

```bash
pip3 install -r requirements.txt
```

## Run the app

```bash
python3 server.py
```

You should see output like:

```text
The FullPicture backend is running.
Data stored in: /Users/<you>/Desktop/Excel/fullpicture_data.xlsx
Open http://localhost:5000 in your browser.
```

## Account rules

New registrations enforce stronger minimum requirements:

- Username must start with a letter
- Username must be 3-24 characters
- Username can only use letters, numbers, `_`, and `-`
- Password must be at least 14 characters
- Password must include uppercase, lowercase, number, and symbol
- Password cannot contain spaces
- Password cannot contain the username or email name
- Password cannot use obvious sequences like `1234` or repeated characters

## What the Excel workbook stores

It contains these sheets:

| Sheet | What it stores |
| --- | --- |
| `Users` | Username, email, password hash, ideology, quiz scores, timestamps |
| `Sessions` | Login sessions and IP data |
| `Comments` | Article discussions and timestamps |
| `Views` | Article opens and timestamps |
| `Submissions` | Reader-submitted article ideas |

## Notes

- The site still has graceful frontend fallbacks if the backend is offline.
- For full persistence and Desktop Excel storage, run the Flask server.
- The generated workbook is ignored by git, so pushing the repo will only send the code.
