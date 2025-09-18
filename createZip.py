#!.venv/bin/python3

import os
import subprocess

from zipfile import ZIP_DEFLATED, ZipFile

####################################################################
# Zip Code and dependencies
####################################################################
def createZippedFunctionCode(packDependencies: bool):
    # create temp venv, installdependencies
    if packDependencies:
        subprocess.run(["./packDependencies.sh", ""], shell=True)

    # zip_buffer = io.BytesIO()

    with ZipFile("./code.zip", "w", ZIP_DEFLATED) as zip:
        # add files from folder src
        src = "./src"

        for dirname, subdirs, files in os.walk(src):
            for filename in files:
                absname = os.path.abspath(os.path.join(dirname, filename))
                arcname = absname[absname.rindex("/src/") + len("/src/") :]
                #print("zipping %s as %s" % (os.path.join(dirname, filename), arcname))
                if (
                  "__pycache__" not in absname
                  and "__pycache__" not in arcname
                ):
                  #print("zipping %s as %s" % (os.path.join(dirname, filename), arcname))
                  zip.write(absname, arcname)

        # add files from dependencies
        src = "./target/dependenciesVenv/lib/python3.10/site-packages"

        for dirname, subdirs, files in os.walk(src):
            for filename in files:
                absname = os.path.abspath(os.path.join(dirname, filename))
                arcname = absname[
                    absname.rindex("/site-packages/") + len("/site-packages/") :
                ]
                if (
                    not arcname.startswith("pip")
                    and not arcname.startswith("_distutils")
                    and not arcname.startswith("setuptools")
                    and "__pycache__" not in absname
                    and "__pycache__" not in arcname
                ):
                    #print("zipping %s as %s" % (os.path.join(dirname, filename), arcname))
                    zip.write(absname, arcname)
                    
    print("created: code.zip")


if __name__ == "__main__":
  createZippedFunctionCode(True)
