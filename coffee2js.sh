for f in $(find ./app/assets/javascripts/ -type f -name "*.coffee")
do
 echo "Processing $f"
 coffee2js $f
done
