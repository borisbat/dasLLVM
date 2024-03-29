require dastest/testing_boost

require jit

[sideeffects,jit]
def test_const_r64
    return range64(1,2)

[sideeffects,jit]
def test_const_ur64
    return urange64(3,4)

[sideeffects,jit]
def test_make_r64_from_int(a:int)
    return range64(a)

[sideeffects,jit]
def test_make_r64_from_2xr64(a,b:int64)
    return range64(a,b)

[sideeffects,jit]
def test_make_r64_from_2xfloat(a,b:float)
    return range64(a,b)

[jit,sideeffects]
def test_r64_yx ( r:range64 ) : range64
    return r.yx

[jit,sideeffects]
def test_for_range64
    var t = 0ul
    for x in 0ul .. 10ul
        t ++
    return t

[test]
def test_range64_urange64_intrinsics ( t:T? )
    t |> run("constants") <| @ ( t : T? )
        t |> success ( is_jit_function(@@test_const_r64))
        t |> equal ( range64(1,2), test_const_r64() )
        t |> success ( is_jit_function(@@test_const_ur64))
        t |> equal ( urange64(3,4), test_const_ur64() )
    t |> run("constructors") <| @ ( t : T? )
        t |> success ( is_jit_function(@@test_make_r64_from_int))
        t |> equal ( range64(0,123), test_make_r64_from_int(123) )
        t |> success ( is_jit_function(@@test_make_r64_from_2xr64))
        let c1 = 1l<<32l
        let c2 = 1l<<33l
        t |> equal ( range64(c1,c2), test_make_r64_from_2xr64(c1,c2) )
        t |> success ( is_jit_function(@@test_make_r64_from_2xfloat))
        t |> equal ( range64(1.,2.), test_make_r64_from_2xfloat(1.,2.) )
    t |> run("swizzle") <| @ ( t : T? )
        t |> success ( is_jit_function(@@test_r64_yx))
        t |> equal ( range64(2,1), test_r64_yx(range64(1,2)) )
    t |> run("for") <| @ ( t : T? )
        t |> success ( is_jit_function(@@test_for_range64))
        t |> equal ( 10ul, test_for_range64() )

