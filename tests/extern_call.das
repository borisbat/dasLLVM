require dastest/testing_boost

require jit

require strings

[jit]
def length_jit ( a : string )
    return length(a)

[test]
def test_ref ( t:T? )
    t |> run("extern call") <| @ ( t : T? )
        t |> success(is_jit_function(@@length_jit))
        t |> equal(length_jit("hello"), 5)

