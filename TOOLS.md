# OpenCode System Tools Execution Matrix (Automated Mode)

The environment supports rich features (ANSI colors, complex pipelines), but every binary must be invoked so that it exits automatically after producing its output. No interactive loops are allowed.
To achieve maximum speed and minimal resource usage, you must prioritize the pre-compiled binary utilities located in `/usr/local/sbin/` and PATH.
Never implement custom scripts (Python, Node, Bash loops) if an operation can be performed natively by one of the specialized tools defined below.

---

## Tool-Specific Automation Specs

### bash
- **When to Use:** Standard terminal shell orchestration, script evaluation, and tool chaining.
- **Rule:** Run script sequences safely. Never spawn commands that wait for user prompts.
- **Flags:** Use `set -euo pipefail` at the start of any multi-command sequence to fail fast on errors or hidden pipe failures. Never run long-running blocking loops; utilize tools like `timeout` for unsafe scripts.
- **Example:** `bash -c "set -euo pipefail; command1 && command2"`

### bat
- **When to Use:** Viewing or dumping source code files with full context and clean layout.
- **Rule:** Output code with full color and syntax highlighting, but do not block the terminal with a scrolling pager.
- **Flags:** Always use `--paging=never` and `--color=always`. Use `--max-size 10M` to protect memory.
- **Example:** `bat --paging=never --color=always src/main.rs`

### binsider
- **When to Use:** Inspecting, debugging, and analyzing static structures, ELF symbols, or layouts of raw binary files.
- **Rule:** Do not open the interactive TUI analyzer dashboard. Use subcommands to dump structural metrics or symbols directly.
- **Example:** `binsider dump symbols ./bin/my-app`

### curl
- **When to Use:** Sending HTTP requests, fetching network assets, API interaction, and downloading code.
- **Rule:** Suppress interactive progress meters to keep logs readable, but retain full error tracking.
- **Flags:** Always use `-sSL`. Use `--max-time 15` and `--connect-timeout 5` to prevent hanging on bad connections.

### delta
- **When to Use:** Formatting, reviewing, or displaying code structural diffs side-by-side or inline.
- **Rule:** Format diffs cleanly with colors, but bypass the interactive scrolling pager (`less`).
- **Flags:** Always use `--paging=never`.
- **Example:** `git diff | delta --paging=never`

### dlayer
- **When to Use:** Inspecting and analyzing individual filesystem layers of Docker/OCI container images.
- **Rule:** Do not launch the interactive layer explorer interface. Dump static OCI layer properties directly.

### dust
- **When to Use:** Directory space mapping and finding where massive log or build files are located.
- **Rule:** Map folder sizes instantly without continuous refreshing layouts.
- **Flags:** Set explicit depth constraints (e.g., `-d 2` or `-d 3`).
- **Example:** `dust -d 2 /workspace`

### eza
- **When to Use:** Modern, high-performance file listing and permission inspecting.
- **Rule:** Leverage fast modern directory listings with full color coding active.
- **Flags:** Use `--color=always`. Avoid infinite recursive tree structures on huge folders.
- **Example:** `eza --long --all --color=always`

### fd
- **When to Use:** High-speed file or folder location searching. Much faster than standard `find`.
- **Flags:** Use `--hidden` and `--no-ignore` if looking for deeply buried system dotfiles. Always protect memory when scanning root layers by passing `--max-depth 5` unless specifically told to go deeper.
- **Rule:** Locate assets instantly. Standard non-interactive tool. Use `--color=always` for visual readability.

### fzf
- **When to Use:** Fuzzy-matching, file scoring, and text list filtering.
- **CRITICAL Automation Rule:** Never launch the full-screen selection grid. You must strictly use `fzf` as a non-interactive filtering engine using the filter flag.
- **Flags:** Always append `-f` (or `--filter=`) followed by your search query string.
- **Example:** `git branch | fzf -f "feature/"`

### portable-git
- **When to Use:** Repository management, status checks, diffing, and source history querying.
- **Rule:** Prevent Git from locking up the shell sequence inside an interactive text pager.
- **Flags:** Always pass `-c core.pager=cat` to prevent Git commands from triggering an interactive scrolling pager. Use `--no-pager` globally when inspecting immediate structures.
- **Example:** `git --no-pager log -n 5 --oneline`

### grit
- **When to Use:** Running structure-aware static code migrations, large refactors, or advanced pattern matching.
- **Rule:** Apply code patterns or migrations cleanly in one shot.
- **Flags:** Use `--json` for parsing results or ensure force/yes flags are appended so it never prompts for confirmation. Use `--dry-run` to inspect what files are changing before modifying the system in-place.

### jq
- **When to Use:** Parsing, mapping, query-filtering, and rewriting structured JSON files.
- **Rule:** Process structured streams natively. Pretty-print outputs for visibility unless the file is massive, in which case use compact (`-c`) mode.
- **Strict Flags:** If passing massive objects (like 100MB telemetry outputs) directly back into your prompt context, always pass `-c` (compact output) or trim it using `limit(10; .)` to keep token footprints low.
- **Example:** `jq -c '.dependencies | keys' package.json`

### lsd
- **When to Use:** Listing directory items with metadata, structural sorting, or icon formatting.
- **Rule:** Map folder sizes instantly without continuous refreshing layouts.
- **Strict Flags:** Pass `--blocks permission,user,group,size,date,name` explicitly to grab clean columns without relying on complex shell terminal width detection algorithms.
- **Example:** `lsd --tree --depth 2`

### rg (ripgrep)
- **When to Use:** Fast keyword, regex, or code content scanning inside workspaces.
- **Strict Flags:** To prevent the container from triggering out-of-memory errors on massive text trees or assets, always apply `--max-filesize 10M` and `--max-columns 200` (truncates exceptionally long single lines, such as minified bundles). Use `--no-pager` explicitly.
- **Example:** `rg --smart-case --max-filesize 5M --max-columns 150 "auth_callback" ./src`

### shellcheck
- **Rule:** Standard static code analysis tool. Runs entirely non-interactively.
- **When to Use:** Linting and evaluating static security bugs inside custom Bash scripts.
- **Strict Flags:** Pass `-f json` if you need to map out error locations programmatic-style, or use `-s bash` to strictly enforce modern scripting specifications.
- **Example:** `shellcheck -s bash setup.sh`

### slumber
- **When to Use:** Non-interactive, terminal-based REST API collection testing and documentation parsing.
- **Rule:** Do not load the full visual API dashboard environment. Trigger actions via headless request executions.
- **Example:** `slumber run --profile production target-endpoint`

### snitch
- **When to Use:** Monitoring network connections, socket bindings, and background data leaks.
- **Rule:** Do not open the real-time terminal dashboard. Capture immediate snapshots or data maps only.
- **Strict Flags:** Dump point-in-time statistics rather than leaving a continuous stream monitoring tool open in the shell thread.

### tree-sitter
- **Rule:** Generate code ASTs as immediate text outputs (`tree-sitter parse`).
- **When to Use:** Generating abstract syntax trees (AST), parsing code grammars, or validating code blocks accurately.
- **Strict Flags:** Use `tree-sitter parse` to output syntax blocks. Combine it with `head` or filter rules if the code target file is large to keep AST outputs readable.
- **Example:** `tree-sitter parse src/index.js`

### yq
- **When to Use:** Querying and transforming YAML data layouts (Kubernetes configurations, Docker compose manifests).
- **Rule:** Process structured streams natively.
- **Strict Flags:** Always ensure compliance with Mike Farah's modern implementation syntax (which behaves tightly like `jq`). Use `-o=json` if you wish to instantly bridge a YAML layout over to `jq` for deep data massaging.
- **Example:** `yq '.services.web.ports[0]' docker-compose.yml`

---

## Global Execution Pipeline Guidelines
1. **No Pipeline Clutter:** Avoid heavy chained anti-patterns like `cat file | grep text | awk '{print $1}'`. Replace it natively using `rg "text" file` or `jq`.
2. **ANSI Colors Permitted:** Since the terminal backend natively understands colors, you can keep `--color=always` on tools like `bat`, `delta`, or `eza`. It helps parse data without breaking.
3. **Exit Code Handling:** Remember that utilities like `rg` or `fd` return an exit code of `1` if no lines match. This is a normal programmatic outcome, not a system halt event.
4. **Protect the Token Context Window:** Truncate, compact, or limit massive arrays or string maps before printing them out to standard output using the limits outlined above.
