#!/bin/bash
# watch_inbox.sh — Monitor inbox/ for obi.jpg + jacket.jpg and process them
#
# Polls every 5 seconds. When both files are present and stable (not still
# being written), delegates to process_inbox.py.
#
# Logs to watch_inbox.log in the project root.

SCRIPT_DIR="/Volumes/Extreme SSD/obi-collection"
INBOX="$SCRIPT_DIR/inbox"
LOG="$SCRIPT_DIR/watch_inbox.log"
LOCK="$SCRIPT_DIR/.inbox_processing.lock"
ENV_FILE="$SCRIPT_DIR/.env"

# ── Logging ──────────────────────────────────────────────────────────────────

log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "$msg" | tee -a "$LOG"
}

# ── Environment setup ────────────────────────────────────────────────────────

load_env() {
    # Load from project-local .env file (highest priority)
    if [[ -f "$ENV_FILE" ]]; then
        set -a
        # shellcheck source=/dev/null
        source "$ENV_FILE"
        set +a
    fi

    # Also try common shell init files so env vars set there are available
    for rc in "$HOME/.zprofile" "$HOME/.bash_profile" "$HOME/.profile"; do
        if [[ -f "$rc" ]]; then
            # shellcheck source=/dev/null
            source "$rc" 2>/dev/null || true
            break
        fi
    done

    # Prepend common Homebrew and pyenv paths that launchd may not have
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
}

# ── File stability check ─────────────────────────────────────────────────────
# Wait until a file's size doesn't change for 2 seconds (copy/move complete)

file_is_stable() {
    local file="$1"
    local size1 size2
    size1=$(stat -f%z "$file" 2>/dev/null) || return 1
    sleep 2
    size2=$(stat -f%z "$file" 2>/dev/null) || return 1
    [[ "$size1" == "$size2" ]]
}

# ── Main loop ────────────────────────────────────────────────────────────────

load_env

log "=== OBI inbox watcher started (PID: $$) ==="
log "    Watching: $INBOX"
log "    Script:   $SCRIPT_DIR/process_inbox.py"

while true; do
    if [[ -f "$INBOX/obi.jpg" && -f "$INBOX/jacket.jpg" ]]; then

        # Skip if another instance is already running
        if [[ -f "$LOCK" ]]; then
            sleep 5
            continue
        fi

        # Wait for both files to finish being written
        if file_is_stable "$INBOX/obi.jpg" && file_is_stable "$INBOX/jacket.jpg"; then
            touch "$LOCK"
            log "Found obi.jpg + jacket.jpg — starting process_inbox.py..."

            python3 "$SCRIPT_DIR/process_inbox.py" >> "$LOG" 2>&1
            EXIT_CODE=$?

            rm -f "$LOCK"

            if [[ $EXIT_CODE -eq 0 ]]; then
                log "Done ✓"
            else
                log "process_inbox.py exited with code $EXIT_CODE — see log above"
            fi
        fi
    fi

    sleep 5
done
