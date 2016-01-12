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

test_default_mock() {
	mock_function mocked_function

	mocked_function

	assertEquals 0 $?
}

test_mock_with_code() {
	mock_function fun_ret_100 'return 100'

	fun_ret_100

	assertEquals 100 $?
}

test_mock_call_times() {
	mock_function fun_test

	fun_test
	assertEquals 1 $(get_global_var __mocked_fun fun_test called_times)

	fun_test
	assertEquals 2 $(get_global_var __mocked_fun fun_test called_times)
}

test_mock_call_with_args() {
	mock_function fun_test

	fun_test a
	assertEquals a $(get_global_var __mocked_fun fun_test called_args 1 1)

	fun_test 'a b'
	assertEquals 'a b' "$(get_global_var __mocked_fun fun_test called_args 2 1)"

	fun_test c d
	assertEquals c $(get_global_var __mocked_fun fun_test called_args 3 1)
	assertEquals d $(get_global_var __mocked_fun fun_test called_args 3 2)
}

. ${TH_SHUNIT}
