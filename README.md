# osic-tools-wsl
Script to download osic-tools docker image and run it directly in wsl (without docker)

### Why?
1. GUI support using WSLg works quite well.
2. VSCode integration with WSL is nice.
3. No need for docker desktop (run docker inside wsl if needed)

### Prerequisites:
- go (for compiling undocker.exe)

### Usage
clone, cd to directory, run:
- install.ps1 to download and install image
- run.ps1 to run image with designs drive mounted
- update.ps1 to update existing image

### To Do:
- Remove go requirement (with a compiled binary of undocker.exe)
