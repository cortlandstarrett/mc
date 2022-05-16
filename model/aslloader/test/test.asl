define function fooDomain::barFunction
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

enddefine
