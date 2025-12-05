#!/bin/bash

for x in *.png ; do 
convert -pointsize 22 -draw "text 10,1950 'copyright openstreetmap & contributors sous licence libre CC-BY-SA'" $x $x
done