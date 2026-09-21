# Rules for this project

Read this before writing or changing code here. This is a student project for
CBIS 4210 / CBIS 5210 at Georgia College, deployed to a Dokku server called
iscs2. Keep to the conventions below - the course lessons assume them, and work
is graded against them.

## Layout

Flat, no `app/` package, no application factory, no ORM.

```
app.py            the Flask app; plain @app.route pages and blueprint registration
database/         connection.py, plus schema.sql and seed_data.sql
blueprints/       one file per group of related pages
templates/        all Jinja templates, flat
static/css/       style.css
```

## Database

- Import it as `from database import get_connection`.
- `get_connection()` opens a **new** connection every call. The caller closes it,
  in a `finally` block. Never cache one on `g`, never open one in a
  `before_request` hook.
- Use `conn.cursor(dictionary=True)` so rows come back as dicts.
- Use `%s` placeholders and pass parameters as a tuple. Never build SQL with an
  f-string or string concatenation.
- Call `conn.commit()` after INSERT, UPDATE and DELETE.
- Never add a "is the database configured?" check inside a route. If there is no
  database, `get_connection()` raises `DatabaseNotConfigured` and `app.py` turns
  that into a friendly 503 page. That is deliberate, so that every blueprint
  stays clean enough to copy.

## Blueprints

- One file per feature: `blueprints/<thing>.py`.
- It defines `<thing>_bp = Blueprint("<thing>", __name__)`.
- Routes carry their own prefix (`@<thing>_bp.route("/<thing>")`), and
  `app.py` registers it with no `url_prefix`.
- Register it in `app.py`, and add a link in `templates/base.html`.

## Configuration

- Read environment variables inside functions, never at module import time.
- `DATABASE_URL` and `FLASK_SECRET_KEY` are the only two. Do not invent more
  without being asked.
- Never commit `.env`, and never put a password in a file that git tracks.

## Deployment

- `requirements.txt` lists only what is actually imported. Do not add packages
  speculatively, and do not run `pip freeze` into it.
- Do not change `Procfile`, `gunicorn.conf.py` or `runtime.txt`. They are tuned
  for a 256 MB container with half a CPU, and changing them breaks the deploy.
