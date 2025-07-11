# docs-enduser
Enduser documentation for the NREC Community Cloud

# development (Linux)

``` bash
git clone <repo>
cd docs-enduser
virtualenv . -p /path/to/python3
source bin/activate
pip install -r requirements.txt
cd docs
make html
xdg-open _build/html/index.html &
```

# development (Windows Terminal)

winget install python Git.Git ezwinports.make

re-login

``` powershell
git clone <repo>
cd .\docs-enduser\
python -m venv .
.\Scripts\activate
pip install -r .\requirements.txt
cd .\docs\
make html
ii .\_build\html\index.html
```
