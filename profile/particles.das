// options log = true, log_nodes =true, print_ref = true, print_var_access = true // , log_optimization_passes = true
// options logCpp = true
// options log_nodes=true
struct NObject
    position : float3
    velocity : float3

[jit]
def testSim2I(var objects:array<NObject>; count:int)
    for i in range(count)
        for obj in objects
            obj.position += obj.velocity

def init(var objects:array<NObject>)
    resize(objects, 50000)
    var i = 0
    for obj in objects
        obj.position=float3(i++,i+1,i+2)
        obj.velocity=float3(1.0,2.0,3.0)
    assert(i==length(objects))

[export]
def main
    var objects:array<NObject>
    init(objects)
    let total=20
    profile(total,"particles kinematics") <|
        testSim2I(objects,100)

