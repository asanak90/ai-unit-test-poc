import json
import urllib.request
from pathlib import Path

MODEL = "llama3.2"
OLLAMA_URL = "http://localhost:11434/api/generate"

prompt_file = Path("ai/test-fix-prompt.md")
source_file = Path("PaymentService/PaymentService.cs")
generated_file = Path("ai/generated/PaymentServiceTests.Generated.cs")
validation_file = Path("ai/output/validation-output.txt")

prompt_template = prompt_file.read_text()
source_code = source_file.read_text()
generated_tests = generated_file.read_text()
validation_output = validation_file.read_text()

prompt = prompt_template.replace(
    "{{SOURCE_CODE}}",
    source_code
).replace(
    "{{GENERATED_TESTS}}",
    generated_tests
).replace(
    "{{VALIDATION_OUTPUT}}",
    validation_output
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

fixed_tests = result["response"].strip()

# Remove Markdown code fences if the model adds them.
if fixed_tests.startswith("```csharp"):
    fixed_tests = fixed_tests[len("```csharp"):].strip()

if fixed_tests.startswith("```"):
    fixed_tests = fixed_tests[3:].strip()

if fixed_tests.endswith("```"):
    fixed_tests = fixed_tests[:-3].strip()

# Ensure nullable reference type annotations are enabled.
if not fixed_tests.startswith("#nullable enable"):
    fixed_tests = "#nullable enable\n\n" + fixed_tests

generated_file.write_text(fixed_tests)

print(f"Fixed tests written to: {generated_file}")