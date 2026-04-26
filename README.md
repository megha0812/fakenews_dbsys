# News Verification System

A full-stack DBMS-based Flask web application connected to the existing MySQL `fakenewsdb` schema without modifying table structure.

## Stack

- Backend: Flask
- Database connector: `mysql.connector`
- Frontend: HTML, CSS, JavaScript
- Charts: Chart.js

## Features

- Dashboard with total news count, verified vs fake pie chart, category-wise bar chart, and recent verifications
- News browsing in a modern card/grid UI
- Search and filter by category, status, and verifier
- Verification insert and update workflows using `COMMIT`, `ROLLBACK`, and `SAVEPOINT`
- Concurrency demonstration with `SELECT ... FOR UPDATE`
- Dark/light theme toggle, animated counters, glassmorphism cards, hover effects, and status badges

## Project Structure

```text
app.py
requirements.txt
templates/
  base.html
  dashboard.html
  news.html
  verification.html
static/
  css/style.css
  js/app.js
  js/charts.js
FakeNewsDB.sql
queries.sql
```

## Environment Variables

Set these before running if your MySQL credentials differ:

```powershell
$env:DB_HOST="127.0.0.1"
$env:DB_PORT="3306"
$env:DB_USER="root"
$env:DB_PASSWORD="your_password"
$env:DB_NAME="fakenewsdb"
$env:FLASK_SECRET_KEY="change-this-secret"
```

## Run

```powershell
pip install -r requirements.txt
python app.py
```

Open:

- `http://127.0.0.1:5000/dashboard`
- `http://127.0.0.1:5000/news`
- `http://127.0.0.1:5000/verification`

## Notes

- The app uses only `SELECT`, `INSERT`, and `UPDATE` against the existing database objects.
- No schema changes are performed by the application.
- For the locking demo, open the verification page in two browser sessions and test the same `news_id`.
