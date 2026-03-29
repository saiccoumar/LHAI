#!/bin/bash

# Step 0: Install OpenCode
echo "Installing OpenCode..."
curl -fsSL https://opencode.ai/install | bash

# Step 1: Set permanent environment variables (overwrite if exists)
SHELL_CONFIG="$HOME/.bashrc"

declare -A ENV_VARS
ENV_VARS=(
  ["OPENCODE_OLLAMA_HOST"]="http://127.0.0.1:11434"
  ["OPENCODE_OLLAMA_API_KEY"]=""
)

for VAR in "${!ENV_VARS[@]}"; do
    if grep -q "^export $VAR=" "$SHELL_CONFIG"; then
        sed -i "s|^export $VAR=.*|export $VAR=\"${ENV_VARS[$VAR]}\"|" "$SHELL_CONFIG"
    else
        echo "export $VAR=\"${ENV_VARS[$VAR]}\"" >> "$SHELL_CONFIG"
    fi
done

# Apply changes immediately
source "$SHELL_CONFIG"
echo "Environment variables set permanently."

# Step 2: Configure global OpenCode JSON
CONFIG_FILE="$HOME/.config/opencode/opencode.json"
mkdir -p "$(dirname "$CONFIG_FILE")"
cat > "$CONFIG_FILE" <<'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama-local": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama",
      "options": {
        "baseURL": "http://127.0.0.1:11434/v1"
      },
      "models": {
        "qwen3-coder-next:q8_0": {
          "name": "qwen3-coder-next:q8_0"
        }
      }
    }
  }
}
EOF


# Step 4: Connect to the provider automatically
echo "Connecting OpenCode to the local Ollama provider..."
opencode connect --provider ollama-local --model qwen3-coder-next:q8_0

echo "OpenCode is now connected to your local Ollama instance."
echo "You can test it with:"
echo "    opencode generate \"print('Hello from Ollama')\""
