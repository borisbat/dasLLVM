require dastest/testing_boost

require jit

[jit]
def count_all ( value:int )
    var i = 0
    while i < value
        i ++
    return i

[jit]
def count_with_break ( value,max_value:int )
    var i = 0
    while i < value
        if i >= max_value
            break
        i ++
    return i

[jit]
def count_with_continue ( value,max_value:int )
    var i = 0
    var j = 0
    while i < value
        i ++
        if i >= max_value
            continue
        j ++
    return j

[jit]
def count_with_finally ( value:int )
    var i = 0
    var tf = 0
    while i < value
        i ++
    finally
        tf ++
    return tf

[test]
def test_while_loop ( t:T? )

    t |> success ( is_jit_function ( @@count_all ) )
    t |> success ( is_jit_function ( @@count_with_break ) )
    t |> success ( is_jit_function ( @@count_with_continue ) )
    t |> success ( is_jit_function ( @@count_with_finally ) )

    t |> equal ( count_all(10), 10 )
    t |> equal ( count_with_break(10,5), 5 )
    t |> equal ( count_with_continue(10,5), 4 )
    t |> equal ( count_with_finally(10), 1 )



