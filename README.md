# osic-tools-wsl
Script to download osic-tools docker image and run it directly in wsl (without docker)

Why?
1. GUI support using WSLg works quite well.
2. VSCode integration with WSL is nice.
3. No need for docker desktop (run docker inside wsl if needed)

Prerequisites:
- go (for compiling undocker.exe)

To Do:
- Remove go requirement (with a compiled binary of undocker.exe)
