set -eu

dry_run=0

while getopts d OPT; do
  case $OPT in
    d)
      dry_run=1
      ;;
  esac
done
shift $((OPTIND - 1))

target_d=$1

function run_cmd() {
  if [ $dry_run -eq 1 ]; then
    echo "dry run: $@"
  else
    $@
  fi
}

while read path; do
  dir=$(
    exiv2 -K 'Exif.Photo.DateTimeOriginal' pr $path |
      awk '{print $4}' |
      awk -F ':' '{ printf "%s-%s", $1, $2 }'
  )
  if [ ! -e ${target_d}/${dir} ]; then run_cmd mkdir -v ${target_d}/${dir}; fi
  echo -n . 1>&2

  if [ ! -e ${target_d}/${dir}/$(basename $path) ]; then
    run_cmd cp -v $path ${target_d}/${dir}
  fi
done
