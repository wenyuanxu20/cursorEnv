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
obj = json.loads(cur.fetchone()[0].decode())

out = {
    "openAIBaseUrl": obj.get("openAIBaseUrl"),
    "anthropicBaseUrl": obj.get("anthropicBaseUrl"),
    "useOpenAIKey": obj.get("useOpenAIKey"),
    "useClaudeKey": obj.get("useClaudeKey"),
    "useAnthropicKey": obj.get("useAnthropicKey"),
    "models": [],
}
for m in obj.get("availableDefaultModels2", []) or []:
    out["models"].append({
        "name": m.get("name") or m.get("inputboxShortModelName"),
        "serverModelName": m.get("serverModelName"),
        "clientDisplayName": m.get("clientDisplayName"),
    })

print(json.dumps(out, indent=2, ensure_ascii=False))
conn.close()
