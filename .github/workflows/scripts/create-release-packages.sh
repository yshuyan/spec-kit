#!/bin/bash

# Create release packages for all AI agents and script types
# Usage: ./create-release-packages.sh <version>
# Example: ./create-release-packages.sh v1.0.1

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

VERSION="${1:-v1.0.1}"

echo -e "${CYAN}======================================${NC}"
echo -e "${CYAN}  Creating Spec-Kit Release Packages${NC}"
echo -e "${CYAN}  Version: $VERSION${NC}"
echo -e "${CYAN}======================================${NC}"
echo ""

# Check if we're in the correct directory
if [ ! -f "pyproject.toml" ] || [ ! -d "templates" ]; then
    echo -e "${RED}Error: Must run from spec-kit root directory${NC}"
  exit 1
fi

# Ensure all source bash scripts have execute permissions before packaging
echo -e "${CYAN}Ensuring source scripts have execute permissions...${NC}"
if [ -d "scripts/bash" ]; then
    chmod +x scripts/bash/*.sh 2>/dev/null || true
    echo -e "${GREEN}✓ Source bash scripts permissions updated${NC}"
fi
echo ""

# Define all supported agents
ALL_AGENTS=(claude gemini copilot cursor qwen opencode codex windsurf kilocode auggie roo)

# Script types
SCRIPT_TYPES=(sh ps)

# Create output directory
OUTPUT_DIR=".genreleases"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

echo -e "${CYAN}Output directory: $OUTPUT_DIR${NC}"
echo ""

# Function to get script name for a command
get_script_name() {
    local cmd_name="$1"
    case "$cmd_name" in
        specify) echo "create-new-feature" ;;
        plan) echo "setup-plan" ;;
        specify-unit) echo "create-unit-test" ;;
        plan-unit) echo "setup-unit-plan" ;;
        *) echo "NA" ;;
    esac
}

# Function to generate command files for an agent
generate_commands() {
    local agent="$1"
    local format="$2"
    local arg_placeholder="$3"
    local output_dir="$4"
    local script_type="$5"
    
    local script_ext
    local script_dir
    if [ "$script_type" = "sh" ]; then
        script_ext="sh"
        script_dir="bash"
    else
        script_ext="ps1"
        script_dir="powershell"
    fi
    
    # Copy command files from templates
    for cmd_file in templates/commands/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)
        local script_name=$(get_script_name "$cmd_name")
        local dest_file="$output_dir/$cmd_name.$format"
        
        # Read the template
        local content=$(cat "$cmd_file")
        
        # Replace placeholders based on format
        if [ "$format" = "md" ]; then
            # Markdown format (Claude, Cursor, opencode, Windsurf, Codex, Kilocode, Auggie, Roo)
            if [ "$script_name" != "NA" ]; then
                # Has a script
                content="${content//\{SCRIPT\}/scripts/$script_dir/$script_name.$script_ext}"
            fi
            content="${content//\{ARGS\}/$arg_placeholder}"
            content="${content//__AGENT__/$agent}"
            echo "$content" > "$dest_file"
        elif [ "$format" = "toml" ]; then
            # TOML format (Gemini, Qwen)
            local toml_content="description = \"$(head -n 1 "$cmd_file" | sed 's/^---$//' | sed 's/description: //' | tr -d '\"')\"\n\nprompt = \"\"\"\n$content\n\"\"\""
            if [ "$script_name" != "NA" ]; then
                toml_content="${toml_content//\{SCRIPT\}/scripts/$script_dir/$script_name.$script_ext}"
            fi
            toml_content="${toml_content//\{ARGS\}/{{args\}}}"
            toml_content="${toml_content//\$ARGUMENTS/{{args\}}}"
            toml_content="${toml_content//__AGENT__/$agent}"
            echo -e "$toml_content" > "$dest_file"
        fi
    done
}

# Function to copy template files
copy_templates() {
    local base_dir="$1"
    
    # Create templates directory structure
    mkdir -p "$base_dir/.specify/templates"
    
    # Copy all template files
    cp templates/*.md "$base_dir/.specify/templates/" 2>/dev/null || true
    
    # Ensure key templates exist
    local key_templates=(
        "spec-template.md"
        "plan-template.md"
        "tasks-template.md"
        "unit-test-template.md"
        "unit-test-plan-template.md"
        "unit-tasks-template.md"
        "agent-file-template.md"
    )
    
    for template in "${key_templates[@]}"; do
        if [ ! -f "$base_dir/.specify/templates/$template" ]; then
            echo -e "${YELLOW}Warning: Missing template $template${NC}"
        fi
  done
}

# Function to copy scripts
copy_scripts() {
    local base_dir="$1"
    local script_type="$2"
    
    # Create scripts directory
    mkdir -p "$base_dir/scripts/$script_type"
    
    # Copy all scripts
    if [ "$script_type" = "bash" ]; then
        # First ensure source scripts are executable (in case they weren't in git)
        chmod +x scripts/bash/*.sh 2>/dev/null || true
        
        cp scripts/bash/*.sh "$base_dir/scripts/$script_type/"
        
        # Make destination scripts executable
        chmod +x "$base_dir/scripts/$script_type"/*.sh
    else
        cp scripts/powershell/*.ps1 "$base_dir/scripts/$script_type/"
    fi
}

# Function to create agent-specific context file
create_agent_context() {
    local base_dir="$1"
    local agent="$2"
    local agent_dir="$3"
    
    # Read the agent file template
    if [ -f "templates/agent-file-template.md" ]; then
        local content=$(cat templates/agent-file-template.md)
        content="${content//__AGENT__/$agent}"
        
        # Create agent-specific directory and file
        mkdir -p "$base_dir/$agent_dir"
        echo "$content" > "$base_dir/$agent_dir/specify-rules.md"
    fi
}

# Function to create .specify directory structure
create_specify_structure() {
    local base_dir="$1"
    
    mkdir -p "$base_dir/.specify/specs"
    mkdir -p "$base_dir/.specify/plans"
    mkdir -p "$base_dir/.specify/tasks"
    mkdir -p "$base_dir/.specify/templates"
    mkdir -p "$base_dir/tests"
    
    # Create README files
    cat > "$base_dir/.specify/README.md" << 'EOF'
# .specify Directory

This directory contains the Spec-Driven Development workflow files.

## Structure

- `specs/` - Feature specifications created by `/specify`
- `plans/` - Implementation plans created by `/plan`
- `tasks/` - Task lists created by `/tasks`
- `templates/` - Template files for generating specs, plans, and tests

## Workflow

1. **Specify**: Define what you want to build
2. **Plan**: Create an implementation plan
3. **Tasks**: Break down into actionable tasks
4. **Implement**: Build according to the plan

For unit testing:
1. **Specify-Unit**: Define test requirements
2. **Plan-Unit**: Create test implementation plan
3. **Tasks-Unit**: Break down into test tasks
4. **Implement-Unit**: Write the tests
EOF

    cat > "$base_dir/tests/README.md" << 'EOF'
# Tests Directory

This directory contains unit test specifications and implementations.

Each test is organized in a numbered directory (e.g., `001-unit-auth-service/`) containing:
- `test-spec.md` - Test specification
- `test-plan.md` - Test implementation plan  
- `test-tasks.md` - Test task list
- Test implementation files

## Workflow

Use the `/specify-unit`, `/plan-unit`, `/tasks-unit`, and `/implement-unit` commands to create and implement tests.
EOF
}

# Create packages for each agent and script type
echo -e "${CYAN}Creating packages for all agents...${NC}"
echo ""

for agent in "${ALL_AGENTS[@]}"; do
    for script_type in "${SCRIPT_TYPES[@]}"; do
        echo -e "${YELLOW}Creating package: $agent-$script_type${NC}"
        
        # Create temporary directory for this package
        TEMP_DIR=$(mktemp -d)
        BASE_DIR="$TEMP_DIR/spec-kit-$agent-$script_type"
        mkdir -p "$BASE_DIR"
        
        # Determine directory structure based on agent
  case $agent in
    claude)
                mkdir -p "$BASE_DIR/.claude/commands"
                generate_commands "$agent" "md" "\$ARGUMENTS" "$BASE_DIR/.claude/commands" "$script_type"
                create_agent_context "$BASE_DIR" "Claude Code" ".claude/rules"
                ;;
    gemini)
                mkdir -p "$BASE_DIR/.gemini/commands"
                generate_commands "$agent" "toml" "{{args}}" "$BASE_DIR/.gemini/commands" "$script_type"
                create_agent_context "$BASE_DIR" "Gemini CLI" ".gemini/rules"
                ;;
    copilot)
                mkdir -p "$BASE_DIR/.github/prompts"
                generate_commands "$agent" "md" "\$ARGUMENTS" "$BASE_DIR/.github/prompts" "$script_type"
                mkdir -p "$BASE_DIR/.github/copilot"
                create_agent_context "$BASE_DIR" "GitHub Copilot" ".github/copilot"
                ;;
    cursor)
                mkdir -p "$BASE_DIR/.cursor/commands"
                generate_commands "$agent" "md" "\$ARGUMENTS" "$BASE_DIR/.cursor/commands" "$script_type"
                create_agent_context "$BASE_DIR" "Cursor" ".cursor/rules"
                ;;
    qwen)
                mkdir -p "$BASE_DIR/.qwen/commands"
                generate_commands "$agent" "toml" "{{args}}" "$BASE_DIR/.qwen/commands" "$script_type"
                create_agent_context "$BASE_DIR" "Qwen Code" ".qwen/rules"
                ;;
    opencode)
                mkdir -p "$BASE_DIR/.opencode/command"
                generate_commands "$agent" "md" "\$ARGUMENTS" "$BASE_DIR/.opencode/command" "$script_type"
                create_agent_context "$BASE_DIR" "opencode" ".opencode/rules"
                ;;
            codex)
                mkdir -p "$BASE_DIR/.codex/commands"
                generate_commands "$agent" "md" "\$ARGUMENTS" "$BASE_DIR/.codex/commands" "$script_type"
                create_agent_context "$BASE_DIR" "Codex CLI" ".codex/rules"
                ;;
    windsurf)
                mkdir -p "$BASE_DIR/.windsurf/workflows"
                generate_commands "$agent" "md" "\$ARGUMENTS" "$BASE_DIR/.windsurf/workflows" "$script_type"
                create_agent_context "$BASE_DIR" "Windsurf" ".windsurf/rules"
                ;;
    kilocode)
                mkdir -p "$BASE_DIR/.kilocode/commands"
                generate_commands "$agent" "md" "\$ARGUMENTS" "$BASE_DIR/.kilocode/commands" "$script_type"
                create_agent_context "$BASE_DIR" "Kilo Code" ".kilocode/rules"
                ;;
    auggie)
                mkdir -p "$BASE_DIR/.auggie/commands"
                generate_commands "$agent" "md" "\$ARGUMENTS" "$BASE_DIR/.auggie/commands" "$script_type"
                create_agent_context "$BASE_DIR" "Auggie CLI" ".auggie/rules"
                ;;
            roo)
                mkdir -p "$BASE_DIR/.roo/commands"
                generate_commands "$agent" "md" "\$ARGUMENTS" "$BASE_DIR/.roo/commands" "$script_type"
                create_agent_context "$BASE_DIR" "Roo Code" ".roo/rules"
                ;;
        esac
        
        # Copy templates (all agents need these)
        copy_templates "$BASE_DIR"
        
        # Copy scripts based on script type
        if [ "$script_type" = "sh" ]; then
            copy_scripts "$BASE_DIR" "bash"
        else
            copy_scripts "$BASE_DIR" "powershell"
        fi
        
        # Create .specify directory structure
        create_specify_structure "$BASE_DIR"
        
        # Copy documentation
        cp README.md "$BASE_DIR/" 2>/dev/null || true
        cp UNIT-TESTING.md "$BASE_DIR/" 2>/dev/null || true
        cp spec-driven.md "$BASE_DIR/" 2>/dev/null || true
        cp GO-TESTING-GUIDE.md "$BASE_DIR/" 2>/dev/null || true
        
        # Create memory directory
        mkdir -p "$BASE_DIR/memory"
        cp memory/constitution.md "$BASE_DIR/memory/" 2>/dev/null || true
        
        # Create package
        PACKAGE_NAME="spec-kit-template-${agent}-${script_type}-${VERSION}.zip"
        cd "$TEMP_DIR"
        zip -r "$PACKAGE_NAME" "spec-kit-$agent-$script_type" > /dev/null
        mv "$PACKAGE_NAME" "$OLDPWD/$OUTPUT_DIR/"
        cd "$OLDPWD"
        
        # Cleanup
        rm -rf "$TEMP_DIR"
        
        echo -e "${GREEN}✓ Created: $PACKAGE_NAME${NC}"
  done
done

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  ✓ All packages created!${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${CYAN}Packages location: $OUTPUT_DIR/${NC}"
echo ""

# List all created packages
echo -e "${CYAN}Created packages:${NC}"
ls -lh "$OUTPUT_DIR"/*.zip | awk '{printf "  %s (%s)\n", $9, $5}'

echo ""
echo -e "${CYAN}Total packages: $(ls -1 "$OUTPUT_DIR"/*.zip | wc -l)${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Test a package locally:"
echo "     unzip $OUTPUT_DIR/spec-kit-template-claude-sh-$VERSION.zip"
echo ""
echo "  2. Create GitHub release:"
echo "     ./create-release.sh your-github-username"
echo ""
