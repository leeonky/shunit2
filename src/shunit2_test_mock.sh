. ./shunit2_test_helpers
. ./shunit2_mock

test_set_single_var() {
	clear_global_vars

	set_global_var var value
	assertEquals value "$(get_global_var var)"

	set_global_var var 'value 1'
	assertEquals 'value 1' "$(get_global_var var)"

	set_global_var 'var 2' 'value 2'
	assertEquals 'value 2' "$(get_global_var 'var 2')"
}

test_get_nonexist_single_var() {
	clear_global_vars

	assertEquals '' "$(get_global_var var)"
}

test_rm_single_var() {
	clear_global_vars

	set_global_var var value
	rm_global_var var

	assertEquals '' "$(get_global_var var)"
}

test_set_array_vars() {
	clear_global_vars

	set_global_var var 1 a
	set_global_var var 2 b
	set_global_var var x 1 c
	set_global_var var x 2 d

	assertEquals a "$(get_global_var var 1)"
	assertEquals b "$(get_global_var var 2)"
	assertEquals c "$(get_global_var var x 1)"
	assertEquals d "$(get_global_var var x 2)"
}

. ${TH_SHUNIT}
