#!/bin/sh

install_latex(){
    sudo apt-get update
    # Full installation because we don't know what do you want.
    # Change it if you know what specific libraries you need 
    # to build your project.
    sudo apt-get instal -y texlive-full
}

generate_pdf(){
  mkdir _build
  xelatex -shell-escape -output-directory _build report.tex
  cp _build/report.pdf .
}

setup_git() {
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
    git checkout ${TRAVIS_BRANCH}
}

make_commit() {
    git add .
    git commit --message "Travis build #$TRAVIS_BUILD_NUMBER [skip ci]"
}

upload_files() {
    git remote add origin-pages "https://${DKEY}@github.com/s3rius/feedEm.git" > /dev/null 2>&1
    git push --quiet --set-upstream origin-pages "${TRAVIS_BRANCH}"
}

setup_git
install_latex
generate_pdf
make_commit
upload_files
