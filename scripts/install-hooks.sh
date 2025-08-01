#!/bin/bash
# Install git hooks for Ojyx project

echo "📦 Installing Ojyx git hooks..."

# Get the git root directory
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$GIT_ROOT" ]; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Create hooks directory if it doesn't exist
HOOKS_DIR="$GIT_ROOT/.git/hooks"
mkdir -p "$HOOKS_DIR"

# Install pre-commit hook
cat > "$HOOKS_DIR/pre-commit" << 'EOF'
#!/bin/bash
# Ojyx pre-commit hook

# Run validation script
SCRIPT_DIR="$(git rev-parse --show-toplevel)/scripts"
if [ -f "$SCRIPT_DIR/pre-commit-validation.sh" ]; then
    bash "$SCRIPT_DIR/pre-commit-validation.sh"
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

# Run flutter format check
echo "🎨 Checking code formatting..."
flutter format --set-exit-if-changed lib/ test/

exit $?
EOF

# Make hooks executable
chmod +x "$HOOKS_DIR/pre-commit"

echo "✅ Git hooks installed successfully!"
echo ""
echo "The following hooks are now active:"
echo "  - pre-commit: Validates patterns and checks formatting"
echo ""
echo "To bypass hooks (not recommended), use: git commit --no-verify"