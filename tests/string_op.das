require dastest/testing_boost

require jit

[jit, sideeffects]
def strcat ( a,b:string )
    return a + b

[jit, sideeffects]
def strcati ( var a:string&; b:string )
    a += b

[test]
def test_ref ( t:T? )
    t |> run("string + and +=") <| @ ( t : T? )
        var a = "hello "
        var b = "world"
        let c = strcat(a,b)
        strcati(a,b)
        t |> equal("hello world",c)
        t |> equal("hello world",a)
        t |> equal("world",b)
