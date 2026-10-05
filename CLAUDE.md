# Working in this project

This is a student project for CBIS 4210 / CBIS 5210 at Georgia College — a
Flask app deployed to a Dokku server called iscs2. Read this before writing or
changing anything here.

**The person you are helping is learning this, and is graded on understanding
it — not on the code existing.** They sit in-class code walkthroughs where they
explain their own project out loud. So when you change something, say in one or
two plain sentences what you changed and why it works. Do not refactor beyond
what was asked, do not introduce a pattern the project is not already using,
and do not do in three files what the project does in one. A student cannot
walk through code they have never seen the shape of.

## This project (from prd.md)

The student fills this section in from `prd.md` (Module 5 onward). If it still
says _TODO_, ask them what the project is rather than guessing, and point them
at `prd.md`. When `prd.md` and this section disagree, ask which one is right —
do not silently pick one.

- **What it is:** _TODO: one or two sentences from the PRD's Project Overview._
- **Who it is for:** _TODO: from Target Users._
- **Key features:** _TODO: the PRD's Key Features, one line each._
- **Tables:** _TODO: each table and what it relates to._
- **External APIs:** _TODO: each API and the environment variable holding its
  key — never the key itself._
- **Rules for this project:** _TODO: at least three conventions specific to
  this app, e.g. "every page that changes data requires login"._
- **Do not:** _TODO: at least two things Claude must not do here, e.g. "do not
  add a new table without asking"._

## Workflow

Work is planned in `prd.md` and tracked as GitHub issues. Follow it:

1. **Start from an issue.** `gh issue list` shows what is open. If the
   requested change has no issue, suggest creating one
   (`gh issue create`) before writing code.
2. **One branch per issue.** `git checkout -b feature-<short-name>` — or a
   worktree (`git worktree add ../<repo>-<short-name> feature-<short-name>`)
   when the student wants two sessions open at once. Never commit feature work
   straight to `main`.
3. **Merge back to `main`** when it works locally, then push to `origin` and
   `dokku`. Close the issue (`gh issue close <n>`, or `Closes #<n>` in the
   commit message), delete the branch, and `git worktree remove` the folder if
   there was one.
4. **Keep the documents true.** When a feature is added, changed or dropped,
   update `prd.md`, this file's "This project" section and `README.md` in the
   same commit. They are graded, and a stale one is worse than none.

## What this is

A Flask application: a Python program that runs on a server, decides what each
page says, and hands the browser finished HTML. The same kit is used from
Module 3 onward, so the layout below does not change from one module to the
next.

**Modules 3 has no database.** `DATABASE_URL`, `.env`, the `database/` folder
and the Examples page are all Module 4 onward. Until a `DATABASE_URL` exists
the app runs perfectly well without one, and the Examples page says so rather
than crashing. Do not "fix" that, and do not add a database to a project that
has not asked for one.

## Running it

Once per project:

```bash
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

Then every time:

```bash
source venv/bin/activate        # Windows: venv\Scripts\activate
python app.py
```

It serves <http://127.0.0.1:5000>. Leave it running while editing — Flask
reloads itself when a `.py` file is saved; a template or CSS change just needs
a browser refresh. `Ctrl-C` stops it.

If the prompt does not start with `(venv)` the activate line did not run, and
`python app.py` fails with `ModuleNotFoundError: No module named 'flask'`.
That is the single most common problem in this project. Check it first.

## What each file is

| File | What it does |
|---|---|
| `app.py` | The app: one function per page, each with an `@app.route` above it. Blueprints are registered here |
| `templates/base.html` | The navbar and footer every page shares. The student's name goes here, and one Bootstrap `bg-*` class sets the navbar colour |
| `templates/index.html`, `about.html` | The content pages. They `extend` base.html rather than repeating it |
| `static/css/style.css` | The student's styles. Almost empty on purpose |
| `requirements.txt` | The packages this app needs |
| `Procfile`, `gunicorn.conf.py`, `runtime.txt` | How the class server runs the app. **Do not change these** |
| `.env.example`, `database/`, `blueprints/examples.py` | Module 4 onward. Not used before then |
| `prd.md` | What the app is for and what it must do. Module 5 onward. The source for this file's "This project" section and for `README.md` |
| `.github/ISSUE_TEMPLATE/` | The shapes `gh issue create` offers: feature, bug, task |

**A route and a template are two halves of one page.** `app.py` decides *what*
the page says; the file in `templates/` decides *how it looks*. Changing the
wrong half produces no visible effect, and that is the most common confusion in
this project after the venv. When a change appears to do nothing, check which
half was edited.

## Layout

Flat. No `app/` package, no application factory, no ORM.

```
app.py            the Flask app: plain @app.route pages, and blueprint registration
database/         connection.py, plus schema.sql and seed_data.sql
blueprints/       one file per group of related pages
templates/        all Jinja templates, flat
static/css/       style.css
```

## Database

- Import it as `from database import get_connection`.
- `get_connection()` opens a **new** connection every call, and the caller
  closes it, in a `finally` block. Never cache one on `g`, never open one in a
  `before_request` hook.
- Use `conn.cursor(dictionary=True)` so rows come back as dicts. This project
  uses `mysql-connector-python`, not PyMySQL — `dictionary=True` is a
  `TypeError` on PyMySQL, so do not switch drivers.
- Use `%s` placeholders and pass the values as a tuple. Never build SQL with an
  f-string or string concatenation.
- Call `conn.commit()` after INSERT, UPDATE and DELETE.
- **Never add a "is the database configured?" check inside a route.** If there
  is no database, `get_connection()` raises `DatabaseNotConfigured` and `app.py`
  turns that into a friendly 503 page. That is deliberate: it keeps every
  blueprint clean enough to be copied as-is.

## Blueprints

- One file per feature: `blueprints/<thing>.py`.
- It defines `<thing>_bp = Blueprint("<thing>", __name__)`.
- Routes carry their own prefix (`@<thing>_bp.route("/<thing>")`), and `app.py`
  registers it with no `url_prefix`.
- Register it in `app.py`, and add a link in `templates/base.html`.
- When a new blueprint is asked for, base it on `blueprints/examples.py`. That
  file exists to be copied.

## Configuration

- Read environment variables inside functions, never at module import time.
- `DATABASE_URL` and `FLASK_SECRET_KEY` are the only two. Do not invent more
  without being asked.
- Never commit `.env`, and never put a password in a file git tracks.
  `.gitignore` already blocks `.env` — leave that line in place.

## Deploying

Two remotes, two different jobs, and **both** are needed every time.

| Remote | What it is for |
|---|---|
| `origin` | GitHub. The code and its history. This is what gets graded |
| `dokku` | The class server. This is what makes the site live |

The Dokku app name must **start with the student's netid, with dots turned into
dashes**. Signing in to iscs1 as `ava.dente` means apps named `ava-dente-…`.
An app name that does not start with their own netid is refused by the server.

```bash
# once per project
ssh dokku@iscs2.gcsu.edu apps:create ava-dente-demo-03
git remote add dokku dokku@iscs2.gcsu.edu:ava-dente-demo-03

# every time the live site should catch up
git add .
git commit -m "Add the routes"
git push origin main    # the code, to GitHub
git push dokku main     # the site, to the class server
```

Pushing to `origin` does not update the live site, and pushing to `dokku` does
not save the work to GitHub. Both, every time.

`/healthz` on the live site proves the app is up, and reports whether
`DATABASE_URL` was actually picked up — useful because students are not allowed
to run `config:show`. A student may own ten apps and run four at once;
`ssh dokku@iscs2.gcsu.edu ps:stop <app>` frees a running slot without
destroying anything.

## When something breaks

| What they see | What it means | What to do |
|---|---|---|
| `ModuleNotFoundError: No module named 'flask'` | The venv is not active | Look for `(venv)` in the prompt; re-run the activate line |
| `Address already in use` | An older `python app.py` is still running | `Ctrl-C` it, or close that terminal |
| `jinja2.exceptions.TemplateNotFound` | The name in `render_template(...)` does not match the file in `templates/` | Compare the two, including the `.html` |
| `Permission denied (publickey)` | Their SSH key is not registered on iscs2 yet | Module 1 Lesson 5; not a code problem |
| `repository ... does not exist` | `apps:create` was skipped, or the app name has dots instead of dashes | Check the name starts with their netid, dashes only |
| `Everything up-to-date`, but the site is unchanged | Nothing was committed | `git add .` then `git commit` first |
| Deploy succeeds, site does not respond | `Procfile` misspelled — capital P, no extension | Check the filename, not the contents |
| A "No database yet" page | Expected before Module 4 | Leave it alone. After Module 4, `DATABASE_URL` is not set on the server |
| `Access denied` from MySQL | Wrong password, or it contains `@ / # +` and was not percent-encoded | Percent-encode it (`@` becomes `%40`) |
| Anything else on the live site | — | `ssh dokku@iscs2.gcsu.edu logs <app-name>` |

## What not to change

`Procfile`, `gunicorn.conf.py` and `runtime.txt` are tuned for the class
server: a 256 MB container with half a CPU, and a pinned Python version so a
build that works in September still works in November. Changing them is how a
deploy stops working for reasons that are hard to find.

`requirements.txt` lists only what is actually imported. Do not add packages
speculatively, and do not run `pip freeze` into it.
