#!/bin/bash
cd /userdir/choreonoid_ws/choreonoid
git reset --hard HEAD
git clean -fdx
cd /userdir/choreonoid_ws/
rm -rf devel/

