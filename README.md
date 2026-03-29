# LHAI Setup
Sai Coumar

This repository contains my configurations for locally hosted AI. The docker compose brings up ollama with OpenWebUI as a graphical interface. This repository also contains scripts to install AI tools with an optimized workflow for my AI-driven development.


## Services

Ollama runs on port 11434
OpenWebUI runs on port 8080
Chroma runs on port 9000

## Prompt Optimization and Recommended Autonomous Delivery Workflow

It's recommended to use tmux with the CLI version of opencode and claude code. This allows for persistent work even while the client has been disconnected from the session.

Open a tmux session
```
tmux
```

Step 1: Prompt optimization
Write your prompt down in either a prompt.txt file.
Then run opencode:
```
opencode
```

and then use the following prompt to optmize your prompt
```
You are an expert prompt engineer. Your task is to rewrite and optimize a given prompt to maximize clarity, performance, and reliability for an AI system.

## Goals
- Preserve the original intent and requirements
- Eliminate ambiguity and unnecessary verbosity
- Improve structure, specificity, and constraints
- Make the prompt robust to edge cases
- Ensure the output is actionable and consistent

## Instructions
1. Analyze the provided prompt.
2. Identify weaknesses (ambiguity, missing constraints, poor structure, etc.).
3. Rewrite the prompt with:
   - Clear role definition
   - Explicit task description
   - Well-defined inputs and outputs
   - Constraints and edge case handling
   - Step-by-step instructions if needed
4. Write an explanation of your work in SUMMARY.md. Be concise and reflect on what the next steps are, as well as what might potentially need more refinement.

## Input Prompt
The input prompt is in prompt.txt

## Output Format
Return ONLY the optimized prompt. Do not include commentary. Write the prompt to new_prompt.txt
```

## Implementation
Copy the resulting prompt in new_prompt.txt. Then run opencode and use that prompt to implement your work. Alternatively you could use
```
opencode generate
```

## Code review, bug fixes, and testing
Once the project has been implemented it will likely not work quite as well as it could using a frontier model. Use claude code to to test your implementation
```
WIP
```

## kubernetes monitoring
kubectl get pods
helm -n "$NAMESPACE" uninstall vllm
kubectl delete pod <orphaned pod name> -n default
kubectl -n <namespace> describe pod <pod-name>
kubectl -n default logs -f <pod-name>