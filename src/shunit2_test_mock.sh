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

test_get_sub_count() {
	clear_global_vars

	assertEquals 0 $(get_subvars_count array)

	set_global_var array 1 a
	assertEquals 1 $(get_subvars_count array)

	set_global_var array 2 a
	assertEquals 2 $(get_subvars_count array)

	set_global_var array1 array2 1 a
	set_global_var array1 array2 2 b
	assertEquals 2 $(get_subvars_count array1 array2)
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

test_mock_never_called() {
	local msg
	mock_function fun_test

	mock_verify fun_test NEVER_CALLED	
	assertEquals "$LINENO" 0 $?

	fun_test
	msg=$(mock_verify fun_test NEVER_CALLED 2>&1)
	assertFalse "$LINENO" $?
	assertEquals "$LINENO" "Expect <fun_test> shall never be called, but called <1> time(s)" "$msg"
}

test_mock_exactly_called() {
	local msg
	mock_function fun_test

	fun_test
	mock_verify fun_test EXACTLY_CALLED 1
	assertEquals "$LINENO" 0 $?

	fun_test
	msg=$(mock_verify fun_test EXACTLY_CALLED 1 2>&1)
	assertFalse "$LINENO" $?
	assertEquals "$LINENO" "Expect <fun_test> shall never be called <1> times, but called <2> time(s)" "$msg"
}

test_mock_call_with_arg() {
	local msg
	mock_function fun_test

	fun_test a
	fun_test 'arg1' 'arg 2'

	mock_verify fun_test IN_CALL 1 WITH_ARGS a
	assertEquals "$LINENO" 0 $?
	mock_verify fun_test IN_CALL 2 WITH_ARGS 'arg1' 'arg 2'
	assertEquals "$LINENO" 0 $?

	msg=$(mock_verify fun_test IN_CALL 1 WITH_ARGS a b 2>&1)
	assertFalse "$LINENO" $?
	assertEquals "$LINENO" "Few expected arguments, passed <1> arguments in the calling <1> of <fun_test>" "$msg"

	msg=$(mock_verify fun_test IN_CALL 3 WITH_ARGS a 2>&1)
	assertFalse "$LINENO" $?
	assertEquals "$LINENO" "<fun_test> only be called <2> times." "$msg"

	msg=$(mock_verify fun_test IN_CALL 1 WITH_ARGS A 2>&1)
	assertFalse "$LINENO" $?
	assertEquals "$LINENO" "Unexpected argument <1> in the calling <1> of <fun_test>, expect:<A> but was:<a>" "$msg"

	msg="$(mock_verify fun_test IN_CALL 2 WITH_ARGS a1 a2 2>&1)"
	assertFalse "$LINENO" $?
	assertEquals "$LINENO" "Unexpected argument <1> in the calling <2> of <fun_test>, expect:<a1> but was:<arg1>
Unexpected argument <2> in the calling <2> of <fun_test>, expect:<a2> but was:<arg 2>" "$msg"

	mock_verify fun_test IN_CALL 2 WITH_ARGS __ANY_VALUE__ 'arg 2'
	assertEquals "$LINENO" 0 $?

	msg="$(mock_verify fun_test IN_CALL 2 WITH_ARGS arg1 2>&1)"
	assertFalse "$LINENO" $?
	assertEquals "$LINENO" "More unexpected arguments, passed <2> arguments in the calling <2> of <fun_test>" "$msg"

	fun_test a b c
	mock_verify fun_test IN_CALL 3 WITH_ARGS a __ANY_LAST__
	assertEquals "$LINENO" 0 $?

}


. ${TH_SHUNIT}
