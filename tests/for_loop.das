require dastest/testing_boost
require llvm/llvm_jit
require jit

[jit]
def range_for ( value:int )
    var i = 0
    for _ in range(0,value)
        i ++
    return i

[jit]
def range_for_range ( value:range )
    var i = 0
    for _ in value
        i ++
    return i

[jit]
def range_for_range_extra ( value:range )
    var i = 0
    for a,b in value,range(13,100500)
        i ++
    return i

[jit]
def range_for_with_break ( value,max_value:int )
    var i = 0
    for _ in range(0,value)
        if i >= max_value
            break
        i ++
    return i

[jit]
def range_for_with_continue ( value,max_value:int )
    var i = 0
    var j = 0
    for _ in range(0,value)
        i ++
        if i >= max_value
            continue
        j ++
    return j

[jit]
def range_for_with_finally ( value:int )
    var i = 0
    var tf = 0
    for _ in range(0,value)
        i ++
    finally
        tf ++
    return tf

[jit]
def dim_for ( var a:int[10] )
    var count = 0
    for j in a
        j = 13
        count ++
    return count

[jit]
def dim_and_range_for ( var a:int[10] )
    var count = 0
    for i,j in range(5),a
        j = i
        count ++
    return count

[jit]
def array_for ( var a:array<int> )
    var count = 0
    for j in a
        j = 13
        count ++
    return count

[jit]
def array_and_range_for ( var a:array<int> )
    var count = 0
    for i,j in range(5),a
        j = i
        count ++
    return count

def gen_range ( value:int )
    return <- generator<int>() <|
        for i in range(value)
            yield i
        return false

[jit]
def iterator_for ( value:int )
    var i = 0
    for _ in gen_range(value)
        i ++
    return i

[jit]
def hybrid_for ( value:int )
    var i = 0
    for a,b in gen_range(value),range(7)
        i ++
    return i

[jit]
def array_comp ( value:int )
    return <- [{for x in range(0,value); x}]

[test]
def test_comprehension ( t:T? )
    t |> run("comprehension") <| @ ( t : T? )
        t |> success ( is_jit_function ( @@array_comp ) )
        var a <- array_comp(10)
        for x,y in a,range(10)
            t |> equal ( x, y )

[test]
def test_for_loop ( t:T? )
    t |> run("range for") <| @ ( t : T? )
        t |> success ( is_jit_function ( @@range_for ) )
        t |> success ( is_jit_function ( @@range_for_range ) )
        t |> success ( is_jit_function ( @@range_for_range_extra ) )
        t |> success ( is_jit_function ( @@range_for_with_break ) )
        t |> success ( is_jit_function ( @@range_for_with_continue ) )
        t |> success ( is_jit_function ( @@range_for_with_finally ) )
        t |> equal ( range_for(10), 10 )
        t |> equal ( range_for_range(range(100,110)), 10 )
        t |> equal ( range_for_range_extra(range(100,110)), 10 )
        t |> equal ( range_for_with_break(10,5), 5 )
        t |> equal ( range_for_with_continue(10,5), 4 )
        t |> equal ( range_for_with_finally(10), 1 )
    t |> run("dim for") <| @ ( t : T? )
        t |> success ( is_jit_function ( @@dim_for ) )
        t |> success ( is_jit_function ( @@dim_and_range_for ) )
        var a : int[10]
        t |> equal ( dim_for(a), 10 )
        for i in a
            t |> equal ( i, 13 )
        t |> equal ( dim_and_range_for(a), 5 )
        for i,j in a,range(10)
            t |> equal ( i, j<5 ? j : 13 )
    t |> run("array for") <| @ ( t : T? )
        t |> success ( is_jit_function ( @@array_for ) )
        t |> success ( is_jit_function ( @@array_and_range_for ) )
        var a : array<int>
        a |> resize(10)
        t |> equal ( array_for(a), 10 )
        for i in a
            t |> equal ( i, 13 )
        t |> equal ( array_and_range_for(a), 5 )
        for i,j in a,range(10)
            t |> equal ( i, j<5 ? j : 13 )
    t |> run("iterator for") <| @ ( t : T? )
        t |> success ( is_jit_function ( @@iterator_for ) )
        t |> equal ( iterator_for(10), 10 )
    t |> run("hybrid for") <| @ ( t : T? )
        t |> success ( is_jit_function ( @@hybrid_for ) )
        t |> equal ( 7, hybrid_for(10) )
        t |> equal ( 5, hybrid_for(5) )
