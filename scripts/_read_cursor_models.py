import sqlite3
import json

path = r"C:\Users\xwy12\AppData\Roaming\Cursor\User\globalStorage\state.vscdb"
conn = sqlite3.connect(path)
cur = conn.cursor()
cur.execute(
    "SELECT value FROM ItemTable WHERE key = ?",
    (
        "src.vs.platform.reactivestorage.browser.reactiveStorageServiceImpl.persistentStorage.applicationUser",
    ),
)
row = cur.fetchone()
obj = json.loads(row[0].decode() if isinstance(row[0], bytes) else row[0])

print("openAIBaseUrl:", obj.get("openAIBaseUrl"))
print("anthropicBaseUrl:", obj.get("anthropicBaseUrl"))
print("useOpenAIKey:", obj.get("useOpenAIKey"))

models = obj.get("availableDefaultModels2") or []
print("\nmodels:")
for m in models[:12]:
    print(
        f"  - {m.get('inputboxShortModelName') or m.get('name')}"
        f" | server={m.get('serverModelName')}"
        f" | client={m.get('clientModelName', '')}"
    )

composer = obj.get("aiSettings", {}).get("modelConfig", {}).get("composer", {})
print("\ncomposer selected:", composer.get("modelName"), composer.get("selectedModels"))

conn.close()
