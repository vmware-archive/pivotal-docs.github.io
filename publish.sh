#!/bin/bash

cwd=$(pwd)

if [ ! -f "README.md" ]; then
  echo "This script must be run from the top of the 'pivotal-docs.github.io' repo."
  exit 1
fi

if [ ! -d "../pcf-docs" ]; then
  echo "The docs source repo must exist at '../pcf-docs'. If necessary, run this command from the current directory: "
  echo "$ git clone git@github.com:pivotal-cf/pcf-docs.git ../pcf-docs"
  exit 1
fi

echo ""
echo ""
echo "Pulling the latest published docs..."
git pull

cd ../pcf-docs

echo ""
echo ""
echo "Pulling the latest source docs..."
git pull

echo ""
echo ""
echo "Building the docs..."
rm -rf build
bundle exec middleman build

cd $cwd

echo ""
echo ""
echo "Copying built docs to publishing repo..."
rsync -vaz ../pcf-docs/build/ . --delete --filter="P .git" --filter="P README.md" --filter="P publish.sh"

git add -A

git status

echo ""
echo ""
echo "Check the 'git status' output, and verify the the expected files were changed."
echo "When ready, do:"
echo "$ git commit -m \"latest changes\""
echo "$ git push"
