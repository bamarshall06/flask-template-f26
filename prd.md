# Product Requirements Document — _TODO: your app's name_

A PRD says **what** you are building and **why**, before anyone writes code.
It is the first of three documents, and the other two come from it:

| File | Who reads it | What it holds |
|---|---|---|
| `prd.md` (this file) | You, your instructor, Claude Code | The what and why: users, features, requirements |
| `CLAUDE.md` | Claude Code | How to work on this project: rules, structure, commands |
| `README.md` | People | What it is, how to set it up, how to run it |

**Replace every _TODO_ below.** A grader checks that this file is about *your*
app — a PRD that still reads like the template, or like someone else's
project, does not count. Keep it in plain language, and keep it true: when a
feature changes, change this file in the same commit.

---

## How to draft it with Gemini or ChatGPT

1. **Describe your idea** in plain language: who it is for and what it lets
   them do.
2. **Use a good prompt.** Start from this one and change the bracketed parts:

   > Create a Product Requirements Document (PRD) in Markdown for a web
   > application that [lets college students track their assignments].
   > It will be built with Python and Flask, a MySQL database, and Bootstrap 5,
   > and deployed to a Dokku server. Include these sections: Project Overview,
   > Target Users, Key Features, Technical Requirements, User Stories, and
   > Non-Functional Requirements. Keep it concise and in plain language.

3. **Review and refine.** Read every line. Ask follow-up questions, ask for
   more or less detail, ask for user stories, cut features you will not build.
4. **Save it here**, replacing this template.
5. **Use it.** Write `CLAUDE.md` and `README.md` from it, and turn its Key
   Features into GitHub issues (`gh issue create`).

The AI drafts; you decide. You will be asked to explain anything in this file.

---

## 1. Project Overview

_TODO: What you are building and why, in two or three sentences._

## 2. Target Users

_TODO: Who will use it, and what they need from it._

## 3. Key Features

_TODO: A numbered list. Each feature specific enough to become one GitHub
issue — "users can add, edit and delete a task", not "task management"._

1. _TODO_

## 4. Technical Requirements

_TODO: The tech stack (Python / Flask, MySQL, Bootstrap 5, Dokku on iscs2),
the database tables and how they relate, and any external APIs — with the name
of the environment variable that holds each key. Never the key itself._

## 5. User Stories

_TODO: "As a [kind of user], I want to [do something] so that [reason]." At
least one per key feature._

- As a _TODO_, I want to _TODO_ so that _TODO_.

## 6. Non-Functional Requirements

_TODO: Security (passwords hashed, secrets only in environment variables),
performance, design and accessibility, and constraints such as the class
server's memory limit._
