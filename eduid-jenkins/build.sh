set -x
set -e

test "x$package" = "x" && package="$1"
test "x$srcdir" = "x" && srcdir="$2"
test "x$testworkdir" = "x" && testworkdir="$3"
test "x$testworkdir" = "x" && testworkdir="$WORKSPACE"

if [ "x$package" = "x" ]; then
  echo "Missing package argument"
  exit 1
fi

if [ "x$srcdir" = "x" ]; then
  echo "Missing srcdir argument"
  exit 1
fi


cd $WORKSPACE

git status
ls -l

export VIRTUAL_ENV="/opt/eduid/"
export PIP_DOWNLOAD_CACHE=/var/cache/jenkins/pip
export PIP_INDEX_URL=https://pypi.nordu.net/simple/

. $VIRTUAL_ENV/bin/activate

test -f requirements.txt && pip install -r requirements.txt
test -f test_requirements.txt && pip install --upgrade -r test_requirements.txt
test -f requirements/testing.txt && pip install -r requirements/testing.txt
# only pysaml2 is known to use tests/test_requirements.txt
test -f tests/test_requirements.txt && pip install -r tests/test_requirements.txt

# By white listing pypi.nordu.net and pypi.python.org we forbidd easy_install
# to fetch package from very slow servers like the one from python-dateutil
# Easy_install tries to do that in order to look if there are newer versions
python ./setup.py develop --index-url https://pypi.nordu.net/simple --allow-hosts *.nordu.net,*.python.org,*.github.com,*.launchpad.net,*.cherrypy.org,*.sf.net,*.sourceforge.net
# compile language files if project has a 'locale' directory
test -d */locale && python setup.py compile_catalog
test -d */locale && find */locale -type f -ls
python ./setup.py sdist install
test -f setup.cfg && grep -q testing setup.cfg && python ./setup.py testing

# show installed package versions
pip freeze

rm -f nosetests.xml
rm -f */nosetests.xml

# after upgrade (?) on 2016-01-25, nose seems to think --with-coverage is implied by --with-xunit and complains. -- ft@
#nosetests --with-xunit --with-coverage --cover-package=${package} --cover-erase --cover-xml
# Change to another directory if testworkdir is set to something other than $WORKSPACE so that nosetest test tests installed code
cd $testworkdir
nosetests --with-xunit --xunit-file=$WORKSPACE/nosetests.xml --with-xcoverage --cover-xml --cover-xml-file=$WORKSPACE/coverage.xml --cover-package=${package} --cover-erase ${package}
cd $WORKSPACE

pylint -f parseable ${package} | tee pylint.out
ls -l pylint.out || true
# eduid-dashboard has strange directory layout... oh my, what a hack.
grep -q "No module named ${package}" pylint.out && pylint -f parseable ${srcdir} | tee pylint.out
sed -i 's%/opt/work/%%' pylint.out

sloccount --duplicates --wide --details ${srcdir} > sloccount.sc

# show files likely to be copied to pypi.nordu.net
echo "Resulting artifacts :"
ls -l dist/*.tar.gz dist/*.egg || ls -l

# for debugging missing coverage data
find . -name coverage.xml -ls
find . -name nosetests.xml -ls

