
require dastest/testing_boost

require jit

bitfield bits123
    one
    two
    three

[jit]
def is_one ( b : bits123 )
    return b.one

[jit]
def set_one ( var b : bits123 )
    b |= bits123 one
    return b

[test]
def test_bitfield ( t: T? )
    t |> run("one") <| @ ( t : T? )
        verify(is_jit_function(@@is_one))
        t |> equal ( true, is_one ( bits123 one ) )
        t |> equal ( false, is_one ( bits123 two ) )
        t |> equal ( false, is_one ( bits123 three ) )
    t |> run("set_one") <| @ ( t : T? )
        verify(is_jit_function(@@set_one))
        t |> equal ( bits123 one, set_one ( bits123 one ) )
        t |> equal ( bits123 one | bits123 two, set_one ( bits123 two ) )
        t |> equal ( bits123 one | bits123 three, set_one ( bits123 three ) )

