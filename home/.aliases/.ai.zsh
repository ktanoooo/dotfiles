aiinstall() {
  if asdf current | grep -q "nodejs"; then
    npm install -g @openai/codex
    npm install -g @anthropic-ai/claude-code
    npm install -g @google/generative-ai
  else
    echo "nodejs is not installed"
  fi
}
