import os
import uuid
from contextlib import closing
from datetime import date

import mysql.connector
from flask import Flask, flash, jsonify, redirect, render_template, request, session, url_for
from mysql.connector import Error


app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", "news-verification-system-secret")

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "127.0.0.1"),
    "port": int(os.getenv("DB_PORT", "3306")),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASSWORD", ""),
    "database": os.getenv("DB_NAME", "fakenewsdb"),
}

LOCKED_CONNECTIONS = {}


LATEST_VERIFICATION_JOIN = """
LEFT JOIN verification v
    ON v.news_id = n.news_id
    AND v.verification_id = (
        SELECT v2.verification_id
        FROM verification v2
        WHERE v2.news_id = n.news_id
        ORDER BY v2.verification_date DESC, v2.verification_id DESC
        LIMIT 1
    )
LEFT JOIN verifier vr
    ON vr.verifier_id = v.verifier_id
"""


def get_db_connection():
    return mysql.connector.connect(**DB_CONFIG)


def ensure_client_key():
    if "client_key" not in session:
        session["client_key"] = str(uuid.uuid4())
    return session["client_key"]


def dict_cursor(connection):
    return connection.cursor(dictionary=True)


def fetch_all(query, params=None):
    with closing(get_db_connection()) as connection:
        with closing(dict_cursor(connection)) as cursor:
            cursor.execute(query, params or ())
            return cursor.fetchall()


def fetch_one(query, params=None):
    with closing(get_db_connection()) as connection:
        with closing(dict_cursor(connection)) as cursor:
            cursor.execute(query, params or ())
            return cursor.fetchone()


def get_reference_data():
    categories = fetch_all(
        "SELECT category_id, category_name FROM category ORDER BY category_name"
    )
    verifiers = fetch_all(
        "SELECT verifier_id, verifier_name, organization FROM verifier ORDER BY verifier_name"
    )
    news_items = fetch_all(
        "SELECT news_id, title FROM news ORDER BY publish_date DESC, news_id DESC"
    )
    return categories, verifiers, news_items


def get_dashboard_data():
    total_news = fetch_one("SELECT COUNT(*) AS total_news FROM news")
    status_counts = fetch_one(
        f"""
        SELECT
            SUM(CASE WHEN COALESCE(v.status, 'Unverified') = 'Real' THEN 1 ELSE 0 END) AS real_count,
            SUM(CASE WHEN COALESCE(v.status, 'Unverified') = 'Fake' THEN 1 ELSE 0 END) AS fake_count,
            SUM(CASE WHEN v.status IS NULL THEN 1 ELSE 0 END) AS unverified_count
        FROM news n
        {LATEST_VERIFICATION_JOIN}
        """
    )
    category_distribution = fetch_all(
        """
        SELECT c.category_name, COUNT(n.news_id) AS total_news
        FROM category c
        LEFT JOIN news n ON n.category_id = c.category_id
        GROUP BY c.category_id, c.category_name
        ORDER BY total_news DESC, c.category_name
        """
    )
    recent_verifications = fetch_all(
        """
        SELECT
            v.verification_id,
            n.title,
            v.status,
            v.confidence_level,
            v.verification_date,
            vr.verifier_name,
            c.category_name
        FROM verification v
        JOIN news n ON n.news_id = v.news_id
        LEFT JOIN category c ON c.category_id = n.category_id
        LEFT JOIN verifier vr ON vr.verifier_id = v.verifier_id
        ORDER BY v.verification_date DESC, v.verification_id DESC
        LIMIT 6
        """
    )
    counters = fetch_one(
        """
        SELECT
            COUNT(*) AS total_verifications,
            COUNT(DISTINCT verifier_id) AS verifier_count,
            ROUND(AVG(confidence_level), 1) AS avg_confidence
        FROM verification
        """
    )

    return {
        "total_news": total_news["total_news"] if total_news else 0,
        "status_counts": status_counts or {"real_count": 0, "fake_count": 0, "unverified_count": 0},
        "category_distribution": category_distribution,
        "recent_verifications": recent_verifications,
        "counters": counters or {"total_verifications": 0, "verifier_count": 0, "avg_confidence": 0},
    }


def get_news_listing(filters):
    category_id = filters.get("category_id")
    status = filters.get("status")
    verifier_id = filters.get("verifier_id")

    conditions = []
    params = []

    if category_id:
        conditions.append("n.category_id = %s")
        params.append(category_id)
    if status:
        if status == "Unverified":
            conditions.append("v.status IS NULL")
        else:
            conditions.append("v.status = %s")
            params.append(status)
    if verifier_id:
        conditions.append("v.verifier_id = %s")
        params.append(verifier_id)

    where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""

    query = f"""
        SELECT
            n.news_id,
            n.title,
            n.content,
            n.language,
            n.publish_date,
            c.category_name,
            s.source_name,
            s.website_url,
            s.credibility_score,
            COALESCE(v.status, 'Unverified') AS verification_status,
            v.confidence_level,
            v.verification_date,
            vr.verifier_name,
            v.verification_id
        FROM news n
        LEFT JOIN category c ON c.category_id = n.category_id
        LEFT JOIN source s ON s.source_id = n.source_id
        {LATEST_VERIFICATION_JOIN}
        {where_clause}
        ORDER BY n.publish_date DESC, n.news_id DESC
    """
    return fetch_all(query, params)


def get_verification_records():
    return fetch_all(
        """
        SELECT
            v.verification_id,
            v.verification_date,
            v.status,
            v.confidence_level,
            v.remarks,
            v.news_id,
            n.title,
            vr.verifier_name,
            v.verifier_id
        FROM verification v
        JOIN news n ON n.news_id = v.news_id
        JOIN verifier vr ON vr.verifier_id = v.verifier_id
        ORDER BY v.verification_date DESC, v.verification_id DESC
        """
    )


def get_next_verification_id(cursor):
    cursor.execute("SELECT COALESCE(MAX(verification_id), 0) + 1 AS next_id FROM verification")
    row = cursor.fetchone()
    return row["next_id"]


@app.context_processor
def inject_globals():
    return {"current_year": date.today().year}


@app.route("/")
def index():
    return redirect(url_for("dashboard"))


@app.route("/dashboard")
def dashboard():
    data = get_dashboard_data()
    categories, verifiers, _ = get_reference_data()
    return render_template(
        "dashboard.html",
        page="dashboard",
        dashboard=data,
        categories=categories,
        verifiers=verifiers,
    )


@app.route("/news")
def news():
    filters = {
        "category_id": request.args.get("category_id", "").strip(),
        "status": request.args.get("status", "").strip(),
        "verifier_id": request.args.get("verifier_id", "").strip(),
    }
    items = get_news_listing(filters)
    categories, verifiers, _ = get_reference_data()
    return render_template(
        "news.html",
        page="news",
        items=items,
        filters=filters,
        categories=categories,
        verifiers=verifiers,
    )


@app.route("/verification", methods=["GET"])
def verification():
    categories, verifiers, news_items = get_reference_data()
    records = get_verification_records()
    lock_owner = ensure_client_key()
    return render_template(
        "verification.html",
        page="verification",
        verifications=records,
        categories=categories,
        verifiers=verifiers,
        news_items=news_items,
        locked_news_ids=[
            payload["news_id"]
            for payload in LOCKED_CONNECTIONS.values()
            if payload.get("owner") == lock_owner
        ],
    )


@app.route("/verification/add", methods=["POST"])
def add_verification():
    news_id = request.form.get("news_id", type=int)
    verifier_id = request.form.get("verifier_id", type=int)
    status = request.form.get("status", "").strip()
    confidence_level = request.form.get("confidence_level", type=int)
    remarks = request.form.get("remarks", "").strip() or None

    connection = None
    cursor = None
    try:
        connection = get_db_connection()
        connection.start_transaction()
        cursor = dict_cursor(connection)

        cursor.execute("SAVEPOINT before_verification_insert")
        cursor.execute(
            """
            SELECT verification_id
            FROM verification
            WHERE news_id = %s AND verifier_id = %s
            """,
            (news_id, verifier_id),
        )
        existing = cursor.fetchone()
        if existing:
            cursor.execute("ROLLBACK TO SAVEPOINT before_verification_insert")
            flash("A verification from this verifier already exists for that news record.", "warning")
            connection.rollback()
            return redirect(url_for("verification"))

        next_id = get_next_verification_id(cursor)
        cursor.execute(
            """
            INSERT INTO verification (
                verification_id,
                verification_date,
                status,
                confidence_level,
                remarks,
                news_id,
                verifier_id
            )
            VALUES (%s, CURDATE(), %s, %s, %s, %s, %s)
            """,
            (next_id, status, confidence_level, remarks, news_id, verifier_id),
        )
        connection.commit()
        flash("Verification record added successfully.", "success")
    except Error as exc:
        if connection:
            connection.rollback()
        flash(f"Unable to add verification: {exc}", "danger")
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()

    return redirect(url_for("verification"))


@app.route("/verification/update", methods=["POST"])
def update_verification():
    verification_id = request.form.get("verification_id", type=int)
    status = request.form.get("status", "").strip()
    confidence_level = request.form.get("confidence_level", type=int)
    remarks = request.form.get("remarks", "").strip() or None

    connection = None
    cursor = None
    try:
        connection = get_db_connection()
        connection.start_transaction()
        cursor = dict_cursor(connection)

        cursor.execute("SAVEPOINT before_verification_update")
        cursor.execute(
            """
            UPDATE verification
            SET status = %s,
                confidence_level = %s,
                remarks = %s,
                verification_date = CURDATE()
            WHERE verification_id = %s
            """,
            (status, confidence_level, remarks, verification_id),
        )
        if cursor.rowcount == 0:
            cursor.execute("ROLLBACK TO SAVEPOINT before_verification_update")
            connection.rollback()
            flash("Verification record was not found.", "warning")
            return redirect(url_for("verification"))

        connection.commit()
        flash("Verification status updated successfully.", "success")
    except Error as exc:
        if connection:
            connection.rollback()
        flash(f"Unable to update verification: {exc}", "danger")
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()

    return redirect(url_for("verification"))


@app.route("/verification/lock/<int:news_id>", methods=["POST"])
def lock_record(news_id):
    owner = ensure_client_key()
    lock_key = f"{owner}:{news_id}"

    if lock_key in LOCKED_CONNECTIONS:
        return jsonify({"ok": True, "message": "This record is already locked in your session."})

    temp_connection = None
    temp_cursor = None
    try:
        temp_connection = get_db_connection()
        temp_connection.start_transaction()
        temp_cursor = dict_cursor(temp_connection)
        temp_cursor.execute("SET SESSION innodb_lock_wait_timeout = 1")
        temp_cursor.execute(
            """
            SELECT verification_id, news_id, status
            FROM verification
            WHERE news_id = %s
            FOR UPDATE
            """,
            (news_id,),
        )
        row = temp_cursor.fetchone()
        if not row:
            temp_connection.rollback()
            temp_cursor.close()
            temp_connection.close()
            return jsonify(
                {"ok": False, "message": "No verification row exists yet for this news record."},
                404,
            )

        LOCKED_CONNECTIONS[lock_key] = {
            "owner": owner,
            "news_id": news_id,
            "connection": temp_connection,
            "cursor": temp_cursor,
        }
        return jsonify(
            {
                "ok": True,
                "message": "Row-level lock acquired. Open another browser session and try locking the same news record to see concurrency control.",
            }
        )
    except Error as exc:
        if temp_cursor:
            temp_cursor.close()
        if temp_connection:
            temp_connection.rollback()
            temp_connection.close()
        message = "Record locked by another user." if getattr(exc, "errno", None) == 1205 else str(exc)
        return jsonify({"ok": False, "message": message}, 409)


@app.route("/verification/unlock/<int:news_id>", methods=["POST"])
def unlock_record(news_id):
    owner = ensure_client_key()
    lock_key = f"{owner}:{news_id}"
    payload = LOCKED_CONNECTIONS.pop(lock_key, None)
    if not payload:
        return jsonify({"ok": False, "message": "No active lock was found for this session."}, 404)

    try:
        payload["connection"].commit()
    except Error:
        payload["connection"].rollback()
    finally:
        payload["cursor"].close()
        payload["connection"].close()

    return jsonify({"ok": True, "message": "Lock released successfully."})


@app.route("/verification/check-lock/<int:news_id>", methods=["POST"])
def check_lock(news_id):
    temp_connection = None
    temp_cursor = None
    try:
        temp_connection = get_db_connection()
        temp_connection.start_transaction()
        temp_cursor = dict_cursor(temp_connection)
        temp_cursor.execute("SET SESSION innodb_lock_wait_timeout = 1")
        temp_cursor.execute(
            """
            SELECT verification_id, news_id, status
            FROM verification
            WHERE news_id = %s
            FOR UPDATE
            """,
            (news_id,),
        )
        row = temp_cursor.fetchone()
        temp_connection.rollback()
        return jsonify(
            {
                "ok": True,
                "message": "Lock test passed. The row is currently free.",
                "record": row,
            }
        )
    except Error as exc:
        if temp_connection:
            temp_connection.rollback()
        message = "Record locked by another user." if getattr(exc, "errno", None) == 1205 else str(exc)
        return jsonify({"ok": False, "message": message}, 409)
    finally:
        if temp_cursor:
            temp_cursor.close()
        if temp_connection:
            temp_connection.close()


@app.route("/api/dashboard")
def dashboard_api():
    return jsonify(get_dashboard_data())


if __name__ == "__main__":
    app.run(debug=True)
