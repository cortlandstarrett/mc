define function fooDomain3::barFunction
input \
        The_Input_Value:Test_Enum_Type
output \
        The_Return_Value:Base_Integer_Type

#$DESCRIPTION
some desription text here
#$END_DESCRIPTION

# comment
a = 1
b = 1.1
c = "hello"
d = 1 + 1
e = 1.1 * 3.0
# another comment
f = a + 1
g = create myObject
h = create unique another
i = create fooObject with attr1 = 1
j = create barObject with a1 = 1 & a2 = "ww"
delete abc
delete dogClass where name = "phydeaux"
k = 'enum_value'
{l} = set_of_instances
{m} = find-all dog
n = find-one cat
o = find-all dog where name = "phydeaux"
link first_instance R1 second_instance
unlink first_instance R12345 second_instance
link anObject R99 anotherObject using assrObject
unassociate anObject R11 anotherObject from assrObject2
p = anObject -> R1.anotherObject
{q} = anObject -> R2.anotherObject -> R22
r = anObject -> R3.anotherObject -> R33.follows
{s} = anObject -> R4.anotherObject -> R44.follows.another
{t} = {s} -> R4.anotherObject -> R44.follows.another
t = class_with_name_attr where name = "fred" -> R1.anotherObject
generate ROB1:Reset() to requiredRobot
generate BTD5:DeleteInstance(Test, Test_Number) to newBTD
[] = DOM1::svc[ a, "1" ]
[u] = DOM2::svc[ 3 ]
[v] = OBJ7:op1[ 3.2 ]
[w, x, y] = CLS1:op2[ a ]

enddefine
