
for F in SRTM/*.hgt.zip
do
#F='SRTM/N46E007.hgt.zip'
if [ -f SLOPES/${F:5:7}.tif ]
then
echo 'skipping already existing file'
else
echo yes | unzip $F
./gdal_fillnodata.py ${F:5:11} fill
rm ${F:5:11}

gdalwarp -of GTiff -co "TILED=YES" -srcnodata 32767 \
-t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" \
-rcs -order 3 -tr 50 50 -multi -overwrite fill warped

 listgeo warped  > geo.txt
 ./hillshade warped composite1.tif -z 2
 gdaldem hillshade -z 2 -compute_edges warped composite2.tif 
 
 convert -level 28%x70% composite2.tif composite.tif
 mogrify -bordercolor none -border 2x2 composite.tif
 
 # create a black image to compose with the hillshade
 SIZE=`identify -format "%wx%h" composite.tif`
 convert -size $SIZE xc:black black.png
 mogrify -negate composite.tif
 # convert the file to tranparent
 convert -depth 6 black.png composite.tif -alpha Off -compose Copy_Opacity -composite alpha.png
 convert -shave 2x2 alpha.png alpha.tif
 
 # set back geotiff infos
 geotifcp -g geo.txt alpha.tif SLOPES/${F:5:7}.tif
 
 fi
 done
 
 gdalbuildvrt SRTM.vrt SLOPES/*.tif
 
 ./gdal2tiles_mod.py -z 0-10 --webviewer=openlayers --profile=mercator --no-kml \
 --resampling='antialias' SRTM.vrt tiles/
 ./gdal2tiles_mod.py -z 0-11 --webviewer=openlayers --profile=mercator --no-kml \
 --resampling='antialias' SRTM.vrt tiles/
 