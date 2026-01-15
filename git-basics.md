
# Git Basics for the Retro Game Project

This file explains the **bare minimum** Git concepts for our `retro-game` repo.

Our repo:

```text
retro-game/
│
├── game/               # Source of truth (only merge boss edits here)
├── people/             # Everyone's sandboxes (you live here)
└── lastyear/           # Old stuff / archives
```

---

## 1. What is going on?

- There is a **remote** copy on GitHub (the official project).
- You have a **local** copy on your computer.
- Your job:
  - **Pull** to get everyone else’s changes.
  - **Commit** to save your own changes locally.
  - **Push** to upload your commits to GitHub.

**Important:**  
You mostly stay in `people/<your-name>/assets/` and `people/<your-name>/src/`.  
The `game/` folder is the **source of truth**, and only the merge boss (or whoever they approve) edits it directly.

---

## 2. Where you should work

- Your main folders:
  - `people/amber/...`
  - `people/darren/...`
  - `people/evelyn/...`
  - `people/fahad/...`
  - `people/karina/...`
  - `people/sarah/...`
- Avoid editing `game/` unless you’ve been told to.
- `lastyear/` is just old/archive stuff; you generally don’t touch it.

This “sandbox” setup keeps conflicts rare and makes Git less scary.

---

## 3. Pull: “get everyone else’s stuff”

**When to use:**  
- Before you start work for the day.  
- Before you push your own changes.

### Command-line version

From the `retro-game/` folder:

```bash
git pull
```

or:

```bash
git pull origin main
```

### GUI version

In tools like GitHub Desktop, Sourcetree, GitKraken, VS Code, etc.:

- Look for a button labeled **Pull**, **Fetch & Pull**, or **Sync**.

### What it does

- Downloads new commits from GitHub.
- Merges them into your local branch so you’re up to date.

If you’re only changing files under `people/<your-name>/...`, you should rarely see conflicts when you pull.

---

## 4. `git pull --ff-only`: “only if it’s simple”

This is the “no surprise merges” version of pull.

```bash
git pull --ff-only
```

- Works **only** if Git can move your branch forward without creating a merge commit.
- If not, it stops and prints an error instead of making a messy history.

Good rule of thumb:

- Regular contributors can just use `git pull`.
- The merge boss (working in `game/` and on `main`) might prefer `git pull --ff-only` to keep the history clean.

---

## 5. Commit: “save point” on your machine

Commits are checkpoints for your work.

### Typical flow

1. Edit files in `people/<your-name>/...`.
2. Stage files:
   - Command line:
     ```bash
     git add people/<your-name>/assets/
     git add people/<your-name>/src/
     ```
     or just:
     ```bash
     git add .
     ```
   - GUI: check the boxes next to the files you changed.
3. Commit:
   - Command line:
     ```bash
     git commit -m "brief message about what you did"
     ```
   - GUI: type a commit message and press **Commit**.

Tips:

- Commit “one logical thing at a time” (e.g. `add player walk animation`, `fix enemy speed`).
- You can make many small commits; that is totally fine.

---

## 6. Push: “upload your stuff”

After committing locally, push your changes to GitHub so the rest of the team can see them.

### Command-line

```bash
git push
```

(or `git push origin main` / your branch name, depending on setup.)

### GUI

Look for a **Push** button.

### If push fails with “rejected” or “non-fast-forward”

That means someone else pushed first. Do:

1. Pull:
   ```bash
   git pull
   ```
   or click **Pull**.
2. Fix any conflicts (if there are any).
3. Commit the merge result (if Git asks you to).
4. Push again:
   ```bash
   git push
   ```

---

## 7. Merges: when timelines diverge

Merges happen when:

- You run `git pull` and both you and someone else changed the branch differently.
- The merge boss merges branches or moves stuff from `people/<name>/...` into `game/`.

### What Git tries to do

- If you edited different files or different lines, Git merges automatically.
- If you both edited the **same lines**, you get a **merge conflict**.

### What a conflict looks like

Inside a file, you might see:

```text
<<<<<<< HEAD
your version of the code
=======
their version of the code
>>>>>>> some-other-commit
```

This means Git wants you to choose which version (or a mix of both).

### For regular contributors

- If the conflict is in `people/<your-name>/...` and you understand it:
  - Edit the file to what you want.
  - Delete the `<<<<<<<`, `=======`, `>>>>>>>` lines.
  - Stage and commit the file again.
- If the conflict is in `game/` or looks confusing:
  - Stop.
  - Ask the merge boss or a more experienced teammate for help.
  - Do **not** randomly mash commands until it goes away.

The whole point of the sandbox approach is that **most** scary merges are handled by the merge boss in `game/`, not by everyone.

---

## 8. Minimal “don’t be scared” workflow

For people working only in their sandbox (`people/<your-name>/`):

1. **Start of session**
   - Open the repo.
   - Pull:
     - Command line: `git pull`
     - Or click **Pull** in your GUI.

2. **Do work**
   - Only edit files inside `people/<your-name>/assets/` and `people/<your-name>/src/`.

3. **Save work locally**
   - Stage:
     ```bash
     git add people/<your-name>/
     ```
     or `git add .`
   - Commit:
     ```bash
     git commit -m "short message about what you did"
     ```

4. **Share work**
   - Pull again:
     ```bash
     git pull
     ```
   - Fix any simple conflicts in your own folder if you understand them.
   - Push:
     ```bash
     git push
     ```

5. **If something feels cursed**
   - Don’t spam random git commands.
   - Tell the merge boss “my branch / repo is weird” and wait for help.

---

## 9. What the merge boss does (high level)

The merge boss:

- Reviews and merges work from `people/<name>/...` into `game/`.
- Handles conflicts inside `game/` so the rest of the team doesn’t have to.
- Makes sure `game/` on the main branch:
  - Builds.
  - Runs.
  - Stays reasonably clean.

If you’re not the merge boss, your main goal is just:

> Keep your sandbox in `people/<your-name>/` tidy and push clean, understandable commits.

That’s it. You don’t need to be a Git wizard to contribute.
