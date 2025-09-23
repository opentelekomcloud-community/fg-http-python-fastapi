Setup and Deploy
================

.. toctree::
   :maxdepth: 3

Prerequisites
-------------

Unix environment
^^^^^^^^^^^^^^^^^^

Make sure you have a Unix-like environment (Linux or `WSL on Windows <https://learn.microsoft.com/en-us/windows/wsl>`_).

Python 3.10 installed
^^^^^^^^^^^^^^^^^^^^^^

See `python.org <https://www.python.org/downloads/>`_ on how to install python.

Python virtual environment venv
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create and activate a python virtual environment like:

.. code-block:: bash

    # Create python env
    python3 -m venv .venv

    # activate venv
    source .venv/bin/activate

    # install requirements
    pip install -r requirements.txt


Test local
----------

.. code-block:: bash

    # change folder
    cd src

    # start program
    python3 app.py


Open browser with http://localhost:8000/

Further endpoints:

* http://localhost:8000/openapi.json

* http://localhost:8000/docs

* http://localhost:8000/redoc

* http://localhost:8000/api/v1/items/100?q=100

