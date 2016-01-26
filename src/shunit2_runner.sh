base_path="$(pwd)"
unit_name="$(basename $2)"

test_rpt="${SYS_TEMP_PATH:-/tmp}/$unit_name.rpt"

case $1 in
t)
	echo "$base_path/$2"
	"$base_path/$2" | tee "$test_rpt"
;;
r)
	[ -f "$test_rpt" ] && cat "$test_rpt"
;;
esac
