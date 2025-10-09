Whispering Wilds — Play locally in VS Code

Goal

Run the shipped `index.html` in a browser from within VS Code with minimal changes.

Quick steps (recommended)

1. Start a local static server from the project root. In PowerShell run one of these:

```powershell
py -3 -m http.server 8000
# or if you have `python` in PATH:
python -m http.server 8000
```

2. Open a browser and go to:

http://localhost:8000/index.html

3. Use the on-screen input box and buttons to play. Useful commands to try:

- look
- take rust_key
- e (or "east")
- unlock (or use rust_key when at the gate)
- inv / stats / help

Keyboard tips

- Press Enter to send the text in the input box.
- Use Up/Down arrows to walk command history.
- Click "Dev Mode" then "Run Tests" to exercise the test harness.

Run from VS Code (one-click)

- Open this folder in VS Code.
- Press Ctrl+Shift+B or open the Command Palette and run "Tasks: Run Task", choose "Serve Whispering Wilds".
- The task runs `py -3 -m http.server 8000`; then open http://localhost:8000/index.html.

Alternative: Use the Live Server extension

If you have the Live Server extension installed, right-click `index.html` and choose "Open with Live Server".

Troubleshooting

- If `py`/`python` isn't available, install Python 3 from https://python.org or use Node's http-server (`npx http-server -p 8000`).
- If the page looks blank, open browser Dev Tools console to see errors. PyScript requires a network-served page (not file://) to fetch WASM resources.

Minimal edits required

No code changes are required to run the game locally — it's a static PyScript-powered page. The README and the VS Code task added here are non-invasive helpers.

Enjoy the game! If you want, I can also add a small "Run" button to the HTML or a PowerShell script to start the server for you.
