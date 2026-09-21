# Flask Starter Kit

The starting point for your Flask projects in CBIS 4210 / CBIS 5210. You take
something you have already built or planned, and build it as a real Flask
application: a Python program that runs on a server, decides what each page
says, and hands the browser finished HTML.

Same idea, different machine doing it. That swap is the point.

**No database to start with.** `DATABASE_URL`, `.env`, the `database/` folder,
the Examples page — all of that arrives in Module 4. Ignore it for now. The app
runs with no configuration at all.

Your module's lessons tell you what to build and when it is due. This file tells
you how to run it, where things live, and what to do when it breaks.

## Getting it running

Once per project, make a virtual environment and install the packages:

```bash
python -m venv venv

# macOS / Linux
source venv/bin/activate
# Windows
venv\Scripts\activate

pip install -r requirements.txt
```

Then, every time you work on it:

```bash
source venv/bin/activate    # Windows: venv\Scripts\activate
python app.py
```

Open <http://127.0.0.1:5000>. Home, About and the error pages all work.

Leave it running while you edit. Flask reloads itself when you save a `.py`
file; for a template or CSS change just reload the browser tab. `Ctrl-C` in the
terminal stops it.

If your prompt does not start with `(venv)`, the activate line did not run, and
`python app.py` will fail with `ModuleNotFoundError: No module named 'flask'`.

The Examples page says it has no database yet. That is correct — leave it alone
until Module 4.

## What each file is

| File | What it does |
|---|---|
| `app.py` | The app itself: one function per page, each with a `@app.route` above it. **Your routes go here** |
| `templates/base.html` | The navbar and footer every page shares. **Your name goes in it**, and one Bootstrap class sets the navbar colour |
| `templates/index.html`, `about.html` | Your content pages. They `extend` base.html rather than repeating it |
| `static/css/style.css` | Your styles. Almost empty on purpose |
| `requirements.txt` | The packages your app needs |
| `Procfile`, `gunicorn.conf.py`, `runtime.txt` | How the class server runs your app. Leave these alone |
| `CLAUDE.md` | The rules Claude Code follows in this project. Worth reading once |
| `.env.example`, `database/`, `blueprints/examples.py` | *Module 4 onward.* Not used yet |

A route and a template are two halves of one page. `app.py` decides *what* the
page says; the template in `templates/` decides *how it looks*. Change the
wrong half and nothing happens — that is the most common confusion in this
project, after the venv.

## Deploying

Two remotes, two different jobs. You need **both**.

| Remote | What it is for |
|---|---|
| `origin` | GitHub. Your code and its history. This is what gets graded |
| `dokku` | The class server. This is what makes the site live |

Your app name starts with your netid, dots turned into dashes. So if you sign
in to iscs1 as `ava.dente`, your app is `ava-dente-demo-03`. Use *your* name
below, not hers — the server refuses a name that is not yours.

```bash
# once per project
ssh dokku@iscs2.gcsu.edu apps:create ava-dente-demo-03

# the server prints your URL and your git remote; add it
git remote add dokku dokku@iscs2.gcsu.edu:ava-dente-demo-03
```

Then, every time you want the live site to catch up with your edits:

```bash
git add .
git commit -m "Add the routes"
git push origin main    # your code, to GitHub
git push dokku main     # your site, to the class server
```

Pushing to `origin` does **not** update your live site, and pushing to `dokku`
does not save your work to GitHub. Do both, every time.

Visit `/healthz` on your live site to prove the app is actually up. You can own
ten apps and run four at a time; `ssh dokku@iscs2.gcsu.edu ps:stop <app>` frees
a running slot without destroying anything.

## Using the database (Module 4 onward)

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

Always use `%s` placeholders and pass the values separately. Building a query
by joining strings together is how SQL injection gets in, and it will cost you
marks.

Load `database/schema.sql` first, then `database/seed_data.sql`.

| Variable | What it does | If you leave it unset |
|---|---|---|
| `DATABASE_URL` | Your database connection string | The app runs; pages needing a database explain that there is not one yet |
| `FLASK_SECRET_KEY` | Signs session cookies | The app runs; anyone logged in is logged out on every restart |

Locally these go in `.env`. On the class server:

```bash
ssh dokku@iscs2.gcsu.edu config:set your-app-name DATABASE_URL=mysql://user:password@host:3306/dbname
```

When you build your own features, four things come out: `blueprints/examples.py`,
`templates/examples.html`, the two `examples_bp` lines in `app.py`, and the
Examples link in `templates/base.html`.

## If something goes wrong

| What you see | What it means |
|---|---|
| `ModuleNotFoundError: No module named 'flask'` | The venv is not activated. Look for `(venv)` in your prompt |
| `Address already in use` | An older `python app.py` is still running. `Ctrl-C` it, or close that terminal |
| `jinja2.exceptions.TemplateNotFound` | The filename in `render_template(...)` does not match the file in `templates/` |
| `Permission denied (publickey)` | Your SSH key is not registered yet. See Module 1 Lesson 5 |
| `repository ... does not exist` | You skipped `apps:create`, or the app name has dots instead of dashes |
| `Everything up-to-date` but the site is unchanged | You committed nothing. Run `git add .` and `git commit` first |
| Deploy succeeds, site does not respond | `Procfile` misspelled — capital P, no file extension |
| `Access denied` from MySQL | Wrong password, or it contains `@ / # +` and was not percent-encoded (`@` becomes `%40`) |
| "No database yet" page | Expected before Module 4. After that, `DATABASE_URL` is not set on the server |
| Anything else | `ssh dokku@iscs2.gcsu.edu logs your-app-name` |

## What not to change

`Procfile`, `gunicorn.conf.py` and `runtime.txt` are tuned for the class
server's memory limit and pin the Python version, so a build that works today
still works in November. Changing them is how a deploy stops working for
reasons that are hard to find.

Never commit a `.env` file, and never put a password in a file that git tracks.
`.gitignore` already blocks `.env` — leave that line in place.
