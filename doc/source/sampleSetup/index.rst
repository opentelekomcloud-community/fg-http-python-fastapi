.. _my-reference-sample:

Setup Sample
================

.. toctree::
   :maxdepth: 3


Architecture
------------

.. raw:: html

    <object data="../_static/architecture.drawio.svg" type="image/svg+xml"></object>


Prerequisites
-------------

Unix environment
^^^^^^^^^^^^^^^^^^

Make sure you have a Unix-like environment (Linux or `WSL on Windows <https://learn.microsoft.com/en-us/windows/wsl>`_).

Python 3.10 installed
^^^^^^^^^^^^^^^^^^^^^^

See `python.org <https://www.python.org/downloads/>`_ on how to install python.

Checkout Code
^^^^^^^^^^^^^^

.. code-block:: bash

    git clone https://github.com/opentelekomcloud-community/fg-http-python-fastapi.git
    cd fg-http-python-fastapi


Python virtual environment .venv
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create and activate a python virtual environment like:

.. code-block:: bash

    # Create python env
    python3 -m venv .venv

    # activate venv
    source .venv/bin/activate

    # install requirements
    pip install -r requirements.txt


Run FastApi app on local machine
--------------------------------

.. code-block:: bash

    # change folder
    cd src

    # start program
    python3 app.py


Open browser with http://localhost:8000/

Test endpoints using curl
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    # test endpoint root
    curl http://localhost:8000

    # response
    {"Hello":"World"}

    # test endpoint with path and query parameter
    curl http://localhost:8000/api/v1/items/100?q=100

    # response
    {"item_id":100,"q":"100"}

Test additional endpoints using browser
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Further endpoints:

* http://localhost:8000/openapi.json

* http://localhost:8000/docs

* http://localhost:8000/redoc


