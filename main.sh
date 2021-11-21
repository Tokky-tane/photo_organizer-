set -eu
target_d=$1

while read path; do
  dir=$(
    exiv2 -K 'Exif.Photo.DateTimeOriginal' pr $path |
      awk '{print $4}' |
      awk -F ':' '{ printf "%s-%s", $1, $2 }'
  )
  if [ ! -e ${target_d}/${dir} ]; then mkdir -v ${target_d}/${dir}; fi
  echo -n . 1>&2
  cp -vn ${path} ${target_d}/${dir}/
done
