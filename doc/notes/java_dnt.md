---

This work is licensed under the Creative Commons CC0 License

---

# MC-3020 Java Value and Body
### xtUML Project Design Note


1. Abstract
-----------
MC-Java is slower than the model-based MC-3020 when translating activities.
Use the model-based approach from MC-3020 to translate expressions and
statements, and continue using MC-Java for the structural Java.

2. Document References
----------------------
[1] [BridgePoint DEI #1](https://support.onefact.net/issues/1)  
[2] [BridgePoint DEI #2](https://support.onefact.net/issues/2)  

3. Background
-------------

4. Requirements
---------------
4.1  Item 1  

5. Analysis
-----------
5.1 enum
```
.assign te_enum.GeneratedName = ( ( te_dt.Owning_Dom_Name + "_" ) + ( te_dt.Name + "_" ) ) + ( "$r{te_enum.Name}" + "_e" )
$Cr{s_dt.Name}_c.$_{s_enum.Name}
```
5.2 Item 2  
5.3 Item 3  

6. Design
---------
In this section, describe in detail each step of the Work Required section of
the analysis, how the task will be accomplished, what technologies will
be used, algorithms, etc.

6.1 Some design point, with a code example
```java
    public void clearDatabase(IProgressMonitor pm) 
    {
    }
```

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

