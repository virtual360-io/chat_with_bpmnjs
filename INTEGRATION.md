# Integration with Claude Code

This tool can be integrated with Claude Code as a skill to provide interactive BPMN process analysis.

## Prerequisites

- Claude Code installed and configured
- `chat_with_bpmnjs` repository cloned locally
- Dependencies installed (see SETUP.md)

## Installation Methods

### Method 1: Symlink (Development)

For local development or quick testing:

```bash
# Clone or navigate to your chat_with_bpmnjs directory
cd /path/to/chat_with_bpmnjs
chmod +x navigator.sh

# Create symlink in Claude Code skills directory
# Adjust path based on your Claude Code setup
ln -s "$(pwd)" ~/.claude/skills/bpmn

# Or manually:
ln -s /path/to/chat_with_bpmnjs ~/.claude/skills/bpmn
```

### Method 2: Git Submodule (Recommended)

For projects using git, add as a submodule:

```bash
cd /path/to/your/project

# Add submodule to .claude/skills
git submodule add git@github.com:virtual360-io/chat_with_bpmnjs.git .claude/skills/bpmn

# Commit
git add .gitmodules .claude/skills/bpmn
git commit -m "chore: add chat_with_bpmnjs as skill submodule"
```

### Method 3: Direct Copy

For isolated environments:

```bash
cd /path/to/your/project
cp -r /path/to/chat_with_bpmnjs .claude/skills/bpmn
```

## Verifying Installation

After installation, verify the skill is recognized:

```bash
# Check if SKILL.md exists
ls -la ~/.claude/skills/bpmn/SKILL.md

# Or for project-specific:
ls -la .claude/skills/bpmn/SKILL.md

# Make script executable
chmod +x ~/.claude/skills/bpmn/navigator.sh
```

## Using the Skill

Once installed, use the `/bpmn` skill in Claude Code:

```bash
/bpmn "/path/to/your/process.bpmn" "Analyze the flow"
```

### Examples

```bash
# Get overview
/bpmn "process.bpmn" summary

# Identify bottlenecks
/bpmn "process.bpmn" "What are the bottlenecks?"

# Find error handling paths
/bpmn "process.bpmn" "How are errors handled?"

# Suggest improvements
/bpmn "process.bpmn" "Suggest improvements"
```

## Directory Structure

Expected structure in your Claude Code setup:

```
.claude/
└── skills/
    └── bpmn/                  # or named differently
        ├── navigator.sh       # Main script
        ├── SKILL.md           # Skill metadata
        ├── README.md          # Documentation
        ├── DEVELOPMENT.md     # Dev guide
        ├── LICENSE            # MIT License
        └── .gitignore         # Git ignore rules
```

## Updating

### For Symlinked Version
No action needed - always uses latest from source directory.

### For Submodule Version

```bash
# Update to latest version
git submodule update --remote .claude/skills/bpmn

# Or manually pull
cd .claude/skills/bpmn
git pull origin main
cd ../..

# Commit update
git add .claude/skills/bpmn
git commit -m "chore: update bpmn skill submodule"
```

### For Copied Version

```bash
# Remove old copy
rm -rf .claude/skills/bpmn

# Copy new version
cp -r /path/to/chat_with_bpmnjs .claude/skills/bpmn
```

## Troubleshooting

### Skill Not Recognized

1. **Check file exists:**
```bash
ls -la ~/.claude/skills/bpmn/SKILL.md
```

2. **Verify permissions:**
```bash
chmod +x ~/.claude/skills/bpmn/navigator.sh
```

3. **Restart Claude Code** - Skills are cached on startup

4. **Clear skill cache (if supported):**
```bash
# Location varies by OS/installation
rm -rf ~/.cache/claude-code/skills
```

### Script Execution Fails

1. **Verify dependencies:**
```bash
which xmllint xsltproc bash
```

2. **Test directly:**
```bash
~/.claude/skills/bpmn/navigator.sh "your_file.bpmn" summary
```

3. **Debug mode:**
```bash
bash -x ~/.claude/skills/bpmn/navigator.sh "your_file.bpmn" summary
```

### Permission Denied

```bash
# Fix permissions
chmod +x ~/.claude/skills/bpmn/navigator.sh
chmod +x ~/.claude/skills/bpmn/navigator.sh
```

## Integration Patterns

### Pattern 1: Local Analysis

Use for quick analysis of local BPMN files:

```bash
/bpmn "~/Downloads/my_process.bpmn" "Identify critical paths"
```

### Pattern 2: Project Documentation

Store BPMNs in project and analyze during development:

```bash
/bpmn ".docs/processes/workflow.bpmn" "Generate improvement suggestions"
```

### Pattern 3: Batch Analysis

Script multiple analyses:

```bash
for file in .docs/processes/*.bpmn; do
  echo "=== Analyzing $file ==="
  /bpmn "$file" summary
done
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: BPMN Analysis
on: [push, pull_request]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true

      - name: Validate BPMN files
        run: |
          apt-get update
          apt-get install -y libxml2-utils libxslt1-tools

          for file in .docs/processes/*.bpmn; do
            .claude/skills/bpmn/navigator.sh "$file" summary
          done
```

## Advanced Configuration

### Custom Skill Alias

Some Claude Code setups allow custom aliases. You might configure:

```bash
# In your Claude Code config
alias process-analysis="/bpmn"
```

### Environment Variables

Set up environment-specific settings:

```bash
export BPMN_SKILL_PATH="/path/to/chat_with_bpmnjs"
export BPMN_TIMEOUT=30
```

## Support

- See [README.md](README.md) for usage examples
- See [SETUP.md](SETUP.md) for installation help
- See [DEVELOPMENT.md](DEVELOPMENT.md) for contribution guidelines
- Open an issue on GitHub for bugs or feature requests

## License

MIT License - See [LICENSE](LICENSE)
