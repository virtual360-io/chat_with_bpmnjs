# Setup Guide

## Prerequisites

- `bash` (≥ 3.2)
- `xmllint` (libxml2)
- `xsltproc` (libxslt)

### Install Dependencies

**macOS:**
```bash
brew install libxml2 libxslt
```

**Ubuntu/Debian:**
```bash
sudo apt-get install libxml2-utils libxslt1-tools
```

**CentOS/RHEL:**
```bash
sudo yum install libxml2 libxslt
```

## Quick Start

```bash
# Clone repository
git clone git@github.com:virtual360-io/chat_with_bpmnjs.git
cd chat_with_bpmnjs

# Make script executable
chmod +x navigator.sh

# Test
./navigator.sh "/path/to/your/process.bpmn" summary
```

## Basic Usage

```bash
# Process overview
./navigator.sh "file.bpmn" summary

# List user tasks
./navigator.sh "file.bpmn" nodes userTask

# Search by keyword
./navigator.sh "file.bpmn" search "validate"

# Explore flow (3 levels forward)
./navigator.sh "file.bpmn" neighbors "Start" 3 out

# Find path between two nodes
./navigator.sh "file.bpmn" path "Start" "End"
```

## Integration with Claude Code

To use as a Claude Code skill, see [INTEGRATION.md](INTEGRATION.md) for:
- Symlink setup
- Git submodule setup
- Direct copy method
- Troubleshooting

### Quick Integration

```bash
# Option 1: Symlink
ln -s "$(pwd)" ~/.claude/skills/bpmn

# Option 2: Submodule (in your project)
git submodule add git@github.com:virtual360-io/chat_with_bpmnjs.git .claude/skills/bpmn
```

Then use in Claude Code:
```bash
/bpmn "/path/to/process.bpmn" "Analyze this flow"
```

## File Structure

```
chat_with_bpmnjs/
├── navigator.sh       # Main script
├── SKILL.md           # Claude Code skill definition
├── README.md          # Complete documentation
├── DEVELOPMENT.md     # Developer guide
├── INTEGRATION.md     # Claude Code integration
├── SETUP.md           # This file
├── LICENSE            # MIT License
└── .gitignore         # Git ignore rules
```

## Documentation

- **README.md** - Full usage guide with examples
- **SKILL.md** - Claude Code skill instructions
- **DEVELOPMENT.md** - Architecture and roadmap
- **INTEGRATION.md** - Claude Code integration guide

## Verify Installation

```bash
# Check dependencies
which xmllint xsltproc

# Test with BPMN file
./navigator.sh "your_file.bpmn" summary

# Look for "=== BPMN Summary ===" output
```

## Troubleshooting

### Error: "xmllint: not found"
Install libxml2 from the Prerequisites section above.

### Script returns error
```bash
# Debug mode
bash -x navigator.sh "file.bpmn" summary

# Validate BPMN file
xmllint --noout "file.bpmn"
```

### Claude Code skill not recognized
1. Ensure `SKILL.md` exists in the skill directory
2. Restart Claude Code
3. Check permissions: `chmod +x navigator.sh`

For more troubleshooting, see [INTEGRATION.md](INTEGRATION.md#troubleshooting)

## Contributing

See [DEVELOPMENT.md](DEVELOPMENT.md) for:
- How to add new commands
- Coding patterns
- Feature roadmap

## License

MIT License - See [LICENSE](LICENSE)

---

**Ready to use!** 🚀

Next: Integrate with Claude Code (see [INTEGRATION.md](INTEGRATION.md)) or test locally.
