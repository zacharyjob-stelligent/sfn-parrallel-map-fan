rm -r src
mkdir src
cp -r ../../../state_machine/entry/* ./src
cp -r ../../../state_machine/shared/* ./src
mv src/main.py src/app.py
rm src/unit_tests.py
