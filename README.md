# Flask Starter Kit (Fall 2026)

The starting point for your Flask projects in CBIS 4210 / CBIS 5210, from
Module 3 onward. Click **Use this template** on GitHub to make your own copy.

## It runs with no configuration

There is nothing to set up. No `.env`, no database, no keys. Clone it, install
the packages, run it:

```bash
python -m venv venv

# macOS / Linux
source venv/bin/activate
# Windows
venv\Scripts\activate

pip install -r requirements.txt
python app.py
```

Then open <http://127.0.0.1:5000>. Home, About and the error pages all work.
The Examples page will tell you it has no database yet - that is correct, and it
starts working in Module 4.

## What each file is

| File | What it does |
|---|---|
| `app.py` | The app itself: the Home and About pages, and where blueprints get registered |
| `templates/base.html` | The navigation bar and footer every page shares. **This is the file you edit to put your name on the site and change the navbar colour.** |
| `templates/index.html`, `about.html` | Your two content pages |
| `static/css/style.css` | Your styles. Almost empty on purpose |
| `Procfile`, `gunicorn.conf.py`, `runtime.txt` | How the class server runs your app. Leave these alone |
| `requirements.txt` | The packages your app needs |
| `.env.example` | A template for your own `.env`. Copy it when you need one |
| `blueprints/examples.py` | *(Module 4 onward)* A working example of Create/Read/Update/Delete |
| `database/` | *(Module 4 onward)* The connection code, plus `schema.sql` and `seed_data.sql` |

## Deploying

Two remotes, two different jobs. You need **both**.

| Remote | What it is for |
|---|---|
| `origin` | GitHub. Your code and its history. This is what gets graded |
| `dokku` | The class server. This is what makes the site live |

```bash
# once per project - the name must start with your netid, dots become dashes
ssh dokku@iscs2.gcsu.edu apps:create ava-dente-demo-03

# the server prints your URL and your git remote; add it
git remote add dokku dokku@iscs2.gcsu.edu:ava-dente-demo-03

# every time you want the live site updated
git push dokku main
```

Pushing to `origin` does **not** update your live site, and pushing to `dokku`
does not save your work to GitHub. Do both.

You can own ten apps and run four at a time. `ssh dokku@iscs2.gcsu.edu ps:stop
<app>` frees a running slot without destroying anything.

## Configuration

| Variable | What it does | If you leave it unset |
|---|---|---|
| `DATABASE_URL` | Your database connection string | The app runs; pages needing a database explain that there is not one yet |
| `FLASK_SECRET_KEY` | Signs session cookies | The app runs; anyone logged in is logged out on every restart |

Locally these go in `.env`. On the class server:

```bash
ssh dokku@iscs2.gcsu.edu config:set your-app-name DATABASE_URL=mysql://user:password@host:3306/dbname
```

Visit `/healthz` on your live site to check whether the server actually picked
your `DATABASE_URL` up.

`JAWSDB_URL` is also accepted, so an older project still works. You do not need it.

## Using the database

```python
from database import get_connection

conn = get_connection()
try:
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM examples WHERE id = %s", (example_id,))
    row = cursor.fetchone()
finally:
    conn.close()
```

Always use `%s` placeholders and pass the values separately. Building a query by
joining strings together is how SQL injection gets in, and it will cost you
marks.

Load `database/schema.sql` first, then `database/seed_data.sql`, using MySQL
Workbench or by asking Claude Code to run them against your `.env` connection.

## Removing the examples pages

When you build your own features, four things come out:

1. `blueprints/examples.py`
2. `templates/examples.html`
3. the `from blueprints.examples import examples_bp` and
   `app.register_blueprint(examples_bp)` lines in `app.py`
4. the Examples link in `templates/base.html`

## Troubleshooting

| Symptom | Cause |
|---|---|
| `ModuleNotFoundError: No module named 'gunicorn'` | `gunicorn` missing from `requirements.txt` |
| Deploy succeeds, site does not respond | `Procfile` misspelled - capital P, no file extension |
| "No database yet" page | Expected before Module 4. After that, `DATABASE_URL` is not set on the server |
| `Access denied` | Password is wrong, or it contains `@ / # +` and was not percent-encoded |
| Anything else | `ssh dokku@iscs2.gcsu.edu logs your-app-name` |

## What not to change

`Procfile`, `gunicorn.conf.py` and `runtime.txt` are tuned for the class
server's memory limit and pin the Python version so a build that works today
still works in November. Changing them is how a deploy stops working for
reasons that are hard to find.
