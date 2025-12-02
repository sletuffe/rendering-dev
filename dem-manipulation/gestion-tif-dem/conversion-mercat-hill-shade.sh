#!/bin/bash
for x in *.tif ; do 
gdalwarp -of GTiff -co "TILED=YES" -srcnodata 32767 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -rcs -order 3 -tr 30 30 -multi $x $x.new 
/home/big-data/ASTER/color-shade $x.new /home/big-data/ASTER/scale.txt $x -z 0.8 -a 0.15
rm $x.new 
done