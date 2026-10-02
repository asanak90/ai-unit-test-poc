import json
import urllib.request
from pathlib import Path

MODEL = "llama3.2"
OLLAMA_URL = "http://localhost:11434/api/generate"

prompt_file = Path("ai/test-generation-prompt.md")
context_file = Path("ai/output/ai-context.md")
output_file = Path("ai/generated/PaymentServiceTests.Generated.cs")

prompt_template = prompt_file.read_text()
context = context_file.read_text()

prompt = prompt_template.replace(
    "{{SOURCE_CODE}}",
    context
).replace(
    "{{EXISTING_TESTS}}",
    context
).replace(
    "{{CODE_ANALYSIS}}",
    context
)

payload = {
    "model": MODEL,
    "prompt": prompt,
    "stream": False
}

request = urllib.request.Request(
    OLLAMA_URL,
    data=json.dumps(payload).encode("utf-8"),
    headers={"Content-Type": "application/json"}
)

with urllib.request.urlopen(request) as response:
    result = json.loads(response.read().decode("utf-8"))

generated = result["response"].strip()

# Remove Markdown code fences if the model adds them.
if generated.startswith("```csharp"):
    generated = generated[len("```csharp"):].strip()

if generated.startswith("```"):
    generated = generated[3:].strip()

if generated.endswith("```"):
    generated = generated[:-3].strip()

# Ensure nullable reference type annotations are enabled.
if not generated.startswith("#nullable enable"):
    generated = "#nullable enable\n\n" + generated

output_file.write_text(generated)

print(f"Generated tests written to: {output_file}")