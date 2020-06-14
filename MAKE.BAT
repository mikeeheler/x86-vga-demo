@echo off
pushd "%~dp0"
mingw32-make -f Makefile %*
popd
