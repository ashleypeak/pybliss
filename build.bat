set ENV_PYTHON2_DIR=.\venv\windows\python2
set ENV_PYTHON3_DIR=.\venv\windows\python3

call %ENV_PYTHON3_DIR%\Scripts\activate.bat
call pip install --upgrade build
call python -m build
call deactivate

call %ENV_PYTHON2_DIR%\Scripts\activate.bat
call pip install --upgrade build
call python -m build
call deactivate
