# PulseRoute — Smart Ambulance System

A Flask + MySQL application for ambulance fleet visibility, public emergency requests, control-room dispatch, driver status updates and traffic assessment.

## Features
- Responsive public landing page and ambulance fleet cards
- Emergency request form saved to MySQL, with reference tracking page
- Admin login, pending queue, ambulance assignment and status updates
- Driver login and assigned-request progress updates
- Traffic congestion demo assessment
- PHPMyAdmin-compatible MySQL schema for XAMPP
- Sample ambulance records so you can see the fleet count immediately after setup

> **Safety / accuracy:** This application is not a monitored emergency dispatch service. It does not automatically call emergency services, provide real-time GPS tracking, consume live traffic feeds, or control real traffic signals. Traffic assessment is based on the available input data. For real emergencies in India, call 112.

## 1. Requirements
- Windows 10/11
- Python 3.10 or newer
- XAMPP with MySQL and phpMyAdmin
- VS Code (recommended)

## 2. Set up the database using XAMPP/phpMyAdmin
1. Open XAMPP Control Panel.
2. Click **Start** beside **Apache** and **MySQL**.
3. Open `http://localhost/phpmyadmin`.
4. Select **Import**.
5. Choose `database/schema.sql` from this project ZIP and click **Import/Go**.
6. You should see the `smart_ambulance` database and tables: `ambulances`, `emergency_requests`, and `users`.
7. Click the `ambulances` table → **Browse** to view the sample ambulance records. The dashboard total is calculated from this table.

Default XAMPP MySQL usually uses user `root` and an empty password. If your local MySQL has a password, update `.env`.

## 3. Set up Python
Open PowerShell in the extracted project folder:

```powershell
py -m venv venv
.\venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
```

If PowerShell blocks activation, use Command Prompt or run:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\venv\Scripts\Activate.ps1
```

Create your local environment file:
```powershell
Copy-Item .env.example .env
```
Open `.env` and confirm DB settings. Never upload `.env` or real credentials to GitHub.

## 4. Create staff logins
With XAMPP MySQL running and the schema imported, run:
```powershell
python create_demo_users.py
```
Staff accounts:
- Admin: `admin` / `Admin@123`
- Driver: `driver1` / `Driver@123`
- Driver: `driver2` / `Driver@123`

Change demo passwords before sharing/deployment. These are for demonstration only.

## 5. Run the project
```powershell
python app.py
```
Open `http://127.0.0.1:5000`.

### Usage flow
1. Open **Request Help** and submit an emergency with a location and contact number.
2. The request is saved in `emergency_requests`; the page shows its reference.
3. Open **Staff login** and sign in as admin.
4. In **Control Room**, choose an available ambulance and click **Assign**.
5. Sign out, then sign in as the driver account assigned to that ambulance.
6. Update the request to Accepted, En Route, Arrived or Completed.
7. Return to the overview or open phpMyAdmin to see the database values change.

## 6. Understanding the database
- `ambulances`: fleet number, driver, type, location and availability status
- `emergency_requests`: caller/patient information, request reference, priority, status and assigned ambulance
- `users`: password hashes, role and optional linked ambulance

The dashboard count comes from a SQL `COUNT(*)` query against `ambulances`; it is not hard-coded.

## 7. Deployment notes (Render)
The included setup targets local XAMPP/MySQL. **Render cannot connect to your computer's `localhost` XAMPP database.** For online deployment, use a managed cloud database accessible from Render, update the database connection code/config for that provider, set environment variables in Render, set `SECRET_KEY` to a long random value, and set `FLASK_DEBUG=false`. Do not expose phpMyAdmin publicly without strong security.

Suggested deployment sequence:
1. Push this project to a new GitHub repository (do not commit `.env` or `venv/`).
2. Create a managed cloud MySQL database (or adapt the app to a supported managed PostgreSQL service).
3. Apply `database/schema.sql` to that cloud database using its supported SQL client.
4. Create a Render **Web Service** connected to the repository.
5. Build command: `pip install -r requirements.txt`
6. Start command: `gunicorn app:app` (add `gunicorn` to `requirements.txt` before using this command).
7. Set environment variables (`DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `SECRET_KEY`, `FLASK_DEBUG=false`) using the cloud database's actual connection details.
8. Create staff users securely after deployment; do not leave demo credentials enabled on a public deployment.
9. Test the public request → admin assignment → driver status flow.

Deployment is not one-click because the local XAMPP database is not an online database. The cloud database must be configured before the online app can work.

## Project structure
```text
Smart_Ambulance_System_Pro/
├── app.py
├── create_demo_users.py
├── requirements.txt
├── .env.example
├── database/
│   └── schema.sql
├── templates/
│   ├── base.html
│   ├── index.html
│   ├── emergency.html
│   ├── track.html
│   ├── login.html
│   ├── admin.html
│   ├── driver.html
│   └── traffic.html
└── static/
    ├── style.css
    └── app.js
```


## Pickup and destination hospital selection
The emergency form now has separate pickup and destination-hospital fields. Type at least
three characters and choose a suggestion to save its coordinates. Suggestions are retrieved
from Photon using OpenStreetMap data; internet access is required and results depend on map
coverage. The tracking page displays pickup/destination markers and an OSRM driving route.
The app adds the required columns automatically to an existing MySQL `emergency_requests`
table when the emergency page is opened. The updated `database/schema.sql` also includes
these columns for a fresh database setup.
