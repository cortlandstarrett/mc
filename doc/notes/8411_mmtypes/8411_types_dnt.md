---

This work is licensed under the Creative Commons CC0 License

---

# Type and Typeref:  Beyond a Single UDT
### xtUML Project Design Note

1. Abstract
-----------
Move beyond a blind mapping of all MASL types and typerefs deriving
from a single User Defined Type.

2. Document References
----------------------
[1] [8411 - MM for Type and Typeref](https://support.onefact.net/issues/8411)  

3. Background
-------------
For Raven Basic, `masl2xtuml` mapped all MASL types and typerefs to uniquely
named User Defined Types (UDTs).  This enabled Import/Export round-tripping
with zero diffs.  However, it did not support type hierarchy.  This work adds
type hierarchy and makes types more useful.  However, more still needs to
be done to overhaul the xtUML type system in the future.

4. Requirements
---------------
4.1 Support Import/Export with zero diffs.  
4.1.1 The new type system must store and emit all of the pieces needed to
do full round-trip import and export.  
4.2 Support editing.  
4.2.1 Imported types must be editable.  
4.2.2 New types must be creatable and editable.  
4.2.3 Editing of a sequence, array, set, bag or definition shall be provided.  
4.3 Forward Migration  
4.3.1 Changes are anticipated in the meta-model for _type_ and _typeref_.
This work shall not preclude a reasonable migration from the current model
of xtUML to the enhanced model.  

5. Analysis
-----------
This section is only required if there is no preceding analysis note. If present
it sets out a brief analysis of the problem to be resolved by this design note.

5.1 Item 1  
5.2 Item 2  
5.3 Item 3  

6. Design
---------
6.1 Add PEIs for more MASL types.  
6.1.1 Add PEIs to the existing set of pre-existing instances of S_DT.  The
current set of preexisting instances represent native global types.  Add a
set of native global types for MASL that are derived from the xtUML native
types.  
6.1.2 The following table lists the types that need to in place.  
| UDT name | MASL type  | xtUML parent type | UUID                                 | parent UUID |  
|----------|------------|-------------------|--------------------------------------|-------------|  
| MASLtype | unassigned | string            | ba5eda7a-def5-0000-0000-000000000011 |             |  
| MASLtype | unassigned | string            | ba5eda7a-def5-0000-0000-000000000011 |             |  

7. Design Comments
------------------
If research carried out during this phase shows that a requirement stated in the
analysis note is infeasible or needs some modification, enumerate those changes
here. If there was no preceding analysis note, then this section documents any
deviations from the design as presented at the design review.

8. Unit Test
------------
Outline all the unit tests that need to pass and describe the method that you
will use to design and perform the tests.

End
---

