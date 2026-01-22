# CLAUDE.md - AI Assistant Guide for Familie Repository

## Repository Overview

This is a **dual-purpose repository** containing:

1. **MakeCode Extension** - Educational programming extension for Calliope Mini microcontroller
2. **Circular Calendar Web App** - Interactive web application for visualizing annual events in a circular timeline

**Primary Language:** German (all documentation, UI text, and comments)
**Author:** thomashalfmann
**Platform:** GitHub Pages enabled at https://thomashalfmann.github.io/familie/

## Quick Facts

- **Total Size:** ~278 KB
- **Main Branch:** `main` (or `master`)
- **Target Hardware:** Calliope Mini (educational microcontroller)
- **MakeCode Version:** 4.0.29
- **Preferred Editor:** blocksprj (MakeCode block editor)

---

## Project Structure

```
/home/user/familie/
├── .github/
│   └── workflows/
│       ├── cfg-check.yml       # Validates pxt.json, auto-creates PRs for fixes
│       └── makecode.yml        # CI/CD: builds on every push
├── .vscode/
│   ├── settings.json           # Editor config: auto-format, file associations
│   └── tasks.json              # MakeCode build tasks
├── circular-calendar.html      # Complete web app (447 lines, 14.7 KB)
├── main.ts                     # MakeCode TypeScript source (493 bytes)
├── main.blocks                 # Visual block representation (3.8 KB)
├── test.ts                     # Test placeholder (122 bytes)
├── pxt.json                    # MakeCode project manifest
├── tsconfig.json               # TypeScript config (ES5 target)
├── _config.yml                 # Jekyll site config for GitHub Pages
├── Gemfile                     # Ruby dependencies (github-pages)
├── Makefile                    # Build automation targets
├── README.md                   # German documentation
└── .gitignore                  # Excludes build artifacts, node_modules
```

---

## Technologies & Frameworks

### MakeCode Component
- **TypeScript** (ES5 target, strict null checks enabled)
- **MakeCode/PXT** - Microsoft's visual programming platform
- **Node.js** - Build toolchain (v14.x in CI/CD)
- **Calliope Mini API** - Hardware-specific APIs for LED matrix, music, sensors

### Web Application
- **HTML5** - Semantic markup
- **CSS3** - Modern styling (flexbox, grid, gradients)
- **Vanilla JavaScript** - Canvas 2D API for graphics rendering
- **Responsive Design** - Mobile-friendly layout

### Infrastructure
- **GitHub Pages** - Static site hosting
- **Jekyll** - Static site generator (via github-pages gem)
- **GitHub Actions** - CI/CD automation

---

## Development Workflows

### 1. MakeCode Development

#### Local Development
```bash
# Install dependencies
pxt install

# Build project
pxt build

# Deploy to device
pxt deploy

# Run tests
pxt test
```

Or using Makefile:
```bash
make build   # Equivalent to pxt build
make deploy  # Equivalent to pxt deploy
make test    # Equivalent to pxt test
```

#### VS Code Integration
- **Task shortcuts** available in VS Code (`.vscode/tasks.json`)
- **Auto-format on type** enabled
- **File associations**: `*.blocks` files treated as HTML

#### Cloud Build (CI/CD)
- **Trigger:** Every push to any branch
- **Workflow:** `.github/workflows/makecode.yml`
- **Steps:**
  1. Setup Node.js 14.x
  2. Install pxt globally
  3. Target Calliope Mini
  4. Run `pxt install && pxt build --cloud`

### 2. Web Application Development

#### Direct Editing
- The `circular-calendar.html` file is **self-contained**
- No build process required
- Edit HTML/CSS/JS directly in the file
- Test by opening in browser

#### GitHub Pages Deployment
- **Automatic** on push to main/master
- Accessible at: https://thomashalfmann.github.io/familie/
- Both `README.md` and `circular-calendar.html` are served

### 3. Configuration Validation

- **Workflow:** `.github/workflows/cfg-check.yml`
- **Trigger:** Push to master/main
- **Purpose:** Validates `pxt.json` integrity
- **Auto-fix:** Creates PR if missing files detected

---

## Key Conventions

### Language & Localization
- **ALL user-facing text MUST be in German**
- Variable names can be English (standard practice)
- Comments should be German for consistency
- Documentation (README, etc.) is German

### Code Style

#### TypeScript (main.ts)
```typescript
// German comments for clarity
basic.forever(function () {
    // Use MakeCode's block-friendly structure
    basic.showIcon(IconNames.Heart)
    music.playMelody("G B A G C5 B A B ", 120)
    basic.showString("Helena")
})
```

**Conventions:**
- Use MakeCode's `basic`, `music`, `led` namespaces
- Melody strings: space-separated notes (e.g., "G B A G C5 B A B ")
- Tempo in BPM (e.g., 120)
- Icon names from `IconNames` enum

#### HTML/JavaScript (circular-calendar.html)
```javascript
// Self-contained structure
// All CSS in <style> block
// All JS in <script> block
// German UI labels and text
```

**Conventions:**
- Canvas-based rendering
- Event objects structure:
  ```javascript
  {
      name: "Event Name",
      startDate: Date object,
      endDate: Date object,
      color: "#hexcolor"
  }
  ```
- Responsive design with max-width: 900px
- Modern ES6+ JavaScript is acceptable

### File Modifications

#### When editing MakeCode files:
1. **Always preserve `pxt.json` structure** - CI/CD depends on it
2. **Don't remove files listed in `pxt.json`** - validation will fail
3. **Test with `pxt build --cloud`** before committing
4. **Update `main.blocks` if you add new blocks** (though typically auto-generated)

#### When editing the web app:
1. **Keep it self-contained** - no external dependencies
2. **Maintain German language** for all UI text
3. **Test responsive behavior** on mobile viewports
4. **Preserve the circular visualization logic** - core feature

### Version Control

#### Git Ignore Patterns
The `.gitignore` excludes:
- `built/` - MakeCode build output
- `node_modules/` - npm dependencies
- `yotta_modules/`, `yotta_targets/` - MakeCode build artifacts
- `pxt_modules/` - PXT dependencies
- `*.db` - Database files
- `*.tgz` - Archives

**Never commit these directories!**

---

## File-Specific Guidance

### pxt.json
**Critical configuration file** - defines the MakeCode project.

```json
{
    "name": "Familie",           // Project name
    "description": "",           // Optional description
    "dependencies": {
        "core": "*"              // Core Calliope Mini API
    },
    "files": [                   // Source files
        "main.blocks",
        "main.ts",
        "README.md"
    ],
    "testFiles": ["test.ts"],    // Test files
    "targetVersions": {
        "target": "4.0.29",      // MakeCode version
        "targetId": "calliopemini"
    },
    "supportedTargets": ["calliopemini"],
    "preferredEditor": "blocksprj"
}
```

**Rules:**
- Don't remove files from `files` array
- Keep `targetId` as `calliopemini`
- Use `"core": "*"` for latest core API
- `preferredEditor: "blocksprj"` enables block editor by default

### main.ts
**MakeCode TypeScript source** - contains the program logic.

**Current Functionality:**
- Displays family member names in sequence: Helena, Linus, Nicole, Thomas
- Plays unique melody for each person
- Shows icons (Heart, SmallHeart, Giraffe, Duck)
- Runs in infinite loop (`basic.forever`)

**When modifying:**
- Use MakeCode API namespaces: `basic`, `music`, `led`, `input`, etc.
- Keep code simple and educational
- Melodies: space-separated note strings
- Use meaningful German strings for `showString()`

### circular-calendar.html
**Self-contained web application** - 447 lines, ~15 KB.

**Architecture:**
```
<!DOCTYPE html>
<html lang="de">
  <head>
    <style>/* All CSS here */</style>
  </head>
  <body>
    <!-- UI Structure -->
    <script>/* All JavaScript here */</script>
  </body>
</html>
```

**Key Features:**
- **Circular visualization** of 12 months
- **Event management** with add/delete
- **Date range selection** (start/end dates)
- **Color coding** for events
- **Collision handling** - stacked arcs for overlapping events
- **Leap year support**
- **Responsive design**

**When modifying:**
- Preserve canvas rendering logic
- Maintain German labels (e.g., "Januar", "Februar", etc.)
- Test event collision detection
- Ensure responsive behavior (viewport < 600px)

### README.md
**German documentation** for end users.

**Sections:**
1. Opening the GitHub Pages site
2. Using as MakeCode extension
3. Editing in MakeCode
4. Block preview image
5. Metadata for MakeCode rendering

**When modifying:**
- Keep instructions in German
- Update URLs if repository is forked
- Preserve MakeCode embed script

### tsconfig.json
**TypeScript compiler configuration** for MakeCode.

```json
{
    "compilerOptions": {
        "target": "ES5",              // Required for MakeCode
        "noImplicitAny": true,
        "outDir": "built",
        "rootDir": ".",
        "strictNullChecks": true      // Type safety
    }
}
```

**Don't modify** unless specifically needed - MakeCode expects these settings.

---

## Build & Deployment

### Local Build Process

```bash
# 1. Install MakeCode CLI globally (if not installed)
npm install -g pxt

# 2. Install project dependencies
pxt install

# 3. Build the project
pxt build

# 4. Deploy to connected Calliope Mini
pxt deploy
```

### CI/CD Pipeline

#### On Every Push (any branch):
1. GitHub Actions runs `.github/workflows/makecode.yml`
2. Sets up Node.js 14.x
3. Installs PXT
4. Targets Calliope Mini
5. Runs `pxt install && pxt build --cloud`
6. **Status badge** updates in README.md

#### On Push to main/master:
1. GitHub Actions runs `.github/workflows/cfg-check.yml`
2. Validates `pxt.json` structure
3. Auto-creates PR if configuration needs fixes
4. GitHub Pages automatically deploys updates

### Manual Deployment

**To Calliope Mini:**
```bash
make deploy
# or
pxt deploy
```

**To GitHub Pages:**
- Push to main/master branch
- GitHub automatically rebuilds and deploys
- Changes visible at https://thomashalfmann.github.io/familie/

---

## Testing

### Current Test Coverage
- **main.ts:** No automated tests (empty `test.ts`)
- **circular-calendar.html:** Manual testing required

### Test File Structure
```typescript
// test.ts (placeholder)
// Test hier hinzufügen. Diese Datei wird nicht auf dem Gerät kompiliert.
```

### Testing Strategy

**For MakeCode changes:**
1. Use MakeCode simulator in browser
2. Test on actual Calliope Mini hardware
3. Verify LED matrix displays correctly
4. Check melody playback
5. Validate timing and sequencing

**For web app changes:**
1. Open `circular-calendar.html` in browser
2. Test event creation with various date ranges
3. Verify circular rendering (12 months visible)
4. Test event deletion
5. Check responsive behavior (resize window)
6. Test edge cases: leap years, year boundaries
7. Verify collision handling (overlapping events)

### Writing Tests (Future)

If adding tests to `test.ts`:
```typescript
// Tests are not compiled for the device
// Use MakeCode test framework

// Example:
input.onButtonPressed(Button.A, function () {
    basic.showNumber(1)
})

// Test that Button A shows number 1
```

---

## Git Workflows

### Branch Strategy

**Current setup:**
- **Main branch:** `main` or `master`
- **Feature branches:** Create from main with descriptive names
- **Example:** `claude/feature-name-sessionid`

### Commit Conventions

**Follow semantic commit messages:**
```
feat: Add leap year support to circular calendar
fix: Correct melody timing for Linus
docs: Update README with web app instructions
chore: Update pxt.json dependencies
ci: Add Node.js version to makecode workflow
```

**German commits are also acceptable** (matching repository language):
```
Zirkulare Kalender Web-App hinzugefügt
Erste Dateien für MakeCode-Projekt
```

### Push Process

```bash
# 1. Stage changes
git add .

# 2. Commit with clear message
git commit -m "feat: Add new melody for family member"

# 3. Push to feature branch
git push -u origin claude/feature-name-sessionid
```

**Important:**
- Always push to feature branches starting with `claude/`
- Never force push to main/master
- CI/CD runs on every push
- Wait for build status before merging

---

## Common Tasks for AI Assistants

### Task 1: Add New Family Member to MakeCode

```typescript
// In main.ts, add to the basic.forever loop:
basic.showIcon(IconNames.Butterfly)
music.playMelody("E G F E D C E G ", 120)
basic.showString("NewName")
```

**Steps:**
1. Read `main.ts`
2. Add new icon + melody + name block
3. Test with `pxt build`
4. Commit changes

### Task 2: Add Event Type to Circular Calendar

**Locate in `circular-calendar.html`:**
1. Find the event creation form (around line 200-250)
2. Add new input field or select option
3. Update event object structure in JavaScript
4. Modify rendering logic to use new property
5. Test in browser

### Task 3: Update MakeCode Dependencies

**Edit `pxt.json`:**
```json
{
    "dependencies": {
        "core": "*",
        "radio": "*"  // Add new dependency
    }
}
```

Then run:
```bash
pxt install
pxt build
```

### Task 4: Modify Circular Calendar Styling

**Edit `circular-calendar.html` `<style>` section:**
```css
/* Find the relevant selector */
.container {
    background: white;
    border-radius: 20px;
    /* Modify properties */
}
```

**Test immediately** - changes are instant (no build process).

### Task 5: Add New MakeCode Block

1. Edit `main.ts` with new function
2. MakeCode will auto-generate block representation
3. `main.blocks` updates automatically
4. Test in MakeCode editor online

### Task 6: Debug CI/CD Failure

**Check GitHub Actions:**
1. Go to repository → Actions tab
2. Find failed workflow
3. Read error logs
4. Common issues:
   - Missing file in `pxt.json`
   - TypeScript compilation error
   - Invalid `pxt.json` syntax
   - Node.js version mismatch

**Fix and push:**
```bash
# Fix the issue locally
pxt build  # Ensure it builds
git commit -am "fix: Resolve CI/CD build error"
git push
```

---

## Important Notes for AI Assistants

### Do's ✅

1. **Always use German** for user-facing text
2. **Test MakeCode changes** with `pxt build` before committing
3. **Keep web app self-contained** - no external dependencies
4. **Preserve file structure** in `pxt.json`
5. **Follow existing code patterns** - consistency matters
6. **Commit frequently** with clear messages
7. **Check CI/CD status** after pushing
8. **Maintain responsive design** in web app
9. **Use MakeCode API correctly** - reference documentation
10. **Document significant changes** in commit messages

### Don'ts ❌

1. **Never remove files** listed in `pxt.json` without updating it
2. **Don't add external dependencies** to web app (keep it standalone)
3. **Don't break MakeCode block compatibility** - users expect blocks
4. **Don't ignore CI/CD failures** - fix them immediately
5. **Don't use English** in user-facing text (German only)
6. **Don't modify `.gitignore`** to commit build artifacts
7. **Don't change `targetId`** in `pxt.json` (must stay `calliopemini`)
8. **Don't force-push** to main/master
9. **Don't add npm/build processes** to web app (keep it simple)
10. **Don't assume - test everything** before committing

### Edge Cases to Consider

1. **Leap years** - Web app must handle February 29
2. **Year boundaries** - Events spanning Dec 31 → Jan 1
3. **Event collisions** - Multiple overlapping events on calendar
4. **Mobile viewport** - Test responsive behavior < 600px
5. **Long event names** - Ensure UI doesn't break
6. **Melody strings** - Invalid notes will crash MakeCode
7. **Icon names** - Must match `IconNames` enum exactly
8. **Date validation** - End date must be after start date

---

## Resources & References

### MakeCode Documentation
- **MakeCode for Calliope:** https://makecode.calliope.cc/
- **MakeCode Blocks:** https://makecode.calliope.cc/blocks
- **TypeScript API:** https://makecode.calliope.cc/reference
- **PXT Documentation:** https://makecode.com/docs

### Calliope Mini Hardware
- **Official Site:** https://calliope.cc/
- **Hardware Specs:** LED matrix (5x5), speaker, buttons, sensors
- **Target Audience:** Educational (ages 8-12)

### GitHub Pages
- **Site URL:** https://thomashalfmann.github.io/familie/
- **Jekyll Docs:** https://jekyllrb.com/docs/
- **GitHub Pages Guide:** https://pages.github.com/

### Development Tools
- **VS Code:** Recommended editor (config in `.vscode/`)
- **Node.js 14.x:** Required for CI/CD
- **Git:** Version control

---

## Troubleshooting

### Issue: `pxt build` fails

**Solution:**
```bash
# Clean build artifacts
rm -rf built/ node_modules/ pxt_modules/

# Reinstall dependencies
pxt install

# Rebuild
pxt build
```

### Issue: Web app not rendering calendar

**Check:**
1. Canvas element exists in DOM
2. JavaScript console for errors
3. Browser compatibility (modern browsers only)
4. Date calculations (leap year logic)

### Issue: CI/CD failing on push

**Common causes:**
1. Invalid `pxt.json` syntax → validate JSON
2. Missing file in `pxt.json` → add it
3. TypeScript errors → run `pxt build` locally
4. Node.js version mismatch → use v14.x

### Issue: MakeCode blocks not updating

**Solution:**
- Blocks auto-generate from TypeScript
- Use MakeCode online editor to sync
- Don't manually edit `main.blocks` (XML format)

---

## Summary

This repository is a **family-themed educational project** combining:
- **Microcontroller programming** (Calliope Mini)
- **Web visualization** (Circular calendar)
- **German language** throughout
- **Automated CI/CD** with GitHub Actions

**Core philosophy:**
- Keep it simple and educational
- Self-contained when possible
- German-first for user experience
- Automated testing and validation
- Accessible to young learners

When working on this repository, prioritize **clarity**, **simplicity**, and **educational value**. The target audience includes German-speaking students and educators using Calliope Mini hardware.

---

**Last Updated:** 2026-01-22
**Repository:** https://github.com/thomashalfmann/familie
**Maintained by:** thomashalfmann
