---

This work is licensed under the Creative Commons CC0 License

---

# MCMC Java
### xtUML Project Design Note

1. Abstract
-----------
See [[2.2]](#2.2) section 1

2. Document References
----------------------
<a id="2.1"></a>2.1 [#8540 Parent issue](https://support.onefact.net/issues/8540)  
<a id="2.2"></a>2.2 [#8540 analysis note](8540_java_ant.md)  
<a id="2.3"></a>2.3 [#8547 Use create for WFL instead of SQL](https://support.onefact.net/issues/8547)  

3. Background
-------------
See [[2.2]](#2.2) section 3

4. Requirements
---------------
See [[2.2]](#2.2) section 4

5. Analysis
-----------
See [[2.2]](#2.2) section 5

6. Design
---------

6.1 `mcmc` extension

`mcmc` must be extended to produce Java generated action bodies

6.1.1 Java mode

In order for `mcmc` to be useful for MC-Java while still remaining compatible
with MC3020, it must be extended to support "Java mode" separately from "C"
mode. This extension will be made through a marking function `EnableJavaMode`.
This marking function will take a string argument representing the root package
of the model to compile to Java.

MC-Java does not support components, so the OOA of OOA is still modeled wholly
in subsystem packages. MC3020 (and consequently `mcmc`) require a component to
be the "compilation unit". This presents a problem for using `mcmc` with the OOA
of OOA because `mcmc` will ignore anything outside a component. To solve this
problem, `mcmc` will be extended to create a component and relate the root
package to the component if running in Java mode.

6.1.2 Modification

`mcmc` must be modified to generate code for statements and values in Java
syntax when in Java mode. The MC3020 archetypes dealing with the value and
statement subsystems will be modified to include a condition checking for Java
mode in each translation function. These archetypes with then be used to derive
and compile a new version of `mcmc`.

It should be noted that we expect a few unexpected challenges during this work
of generating Java syntax with `mcmc`. Significant findings will be included in
the implementation note. Analysis will also be done during implementation with
respect to the best way to move both MC3020 and MC-Java forward in the future.

6.2 MC-Java `mcmc` integration

`mcmc` must be integrated into the BridgePoint build to generate Java

6.2.1 Build process

BridgePoint currently uses Ant build scripts to compile the tool. The `pyrsl`
generator is called against model data and the MC-Java main archetype `java.arc`
to run MC-Java in the MC-Java build script.

MC3020 uses the `xtumlmc_build` Perl script to run the compiler. This script
runs `mcmc` and then calls the `pyrsl` generator against the MC3020 archetypes.

In order to enable MC-Java to call `mcmc`, the `xtumlmc_build` script shall be
modified to allow `mcmc` to be called by itself. An Ant "exec" task will be
added to the MC-Java build script to call `mcmc` before the generator is run.

6.2.2 MC-Java modifications

As noted in the analysis note [[2.2]](#2.2) section 5.2, MC-Java translates
action blocks in five different places. Each of these places shall have a test
for existing `TE_ABA` instances. If they exist, the generated code from the
`TE_ABA` instances will be used instead of the full translation by MC-Java.

6.2.3 Special situations

There are three special situations where action blocks are translated
differently than generic Java.

6.2.3.1 OAL validation functions

In `org.xtuml.bp.als` some functions are translated into OAL validation
functions instead of domain functions. These are specified in the OOA of OOA by
the tag "ParserValidateFunction: TRUE" and "ParserUtilityFunction: TRUE" in the
description field of the function. `mcmc` will not have to do any special
processing to these functions, because MC-Java will just ignore them.

6.2.3.2 CME workflow PEI data

In `org.xtuml.bp.core`, action blocks are used to generate PEI data as SQL
statements. An issue is open to analyze whether this can be simplified.
[[2.3]](#2.3)

6.2.3.3 CME action classes

In `org.xtuml.bp.core`, action blocks are used to generate special CME action
classes. Like the OAL validation functions, these are generated into special
places instead of a domain class, however unlike the OAL validation functions,
the translation is slightly different than generic Java. These are specified by
the tag "ContextMenuFunction: TRUE" in the description field of the function.
These functions could be left as is and work, but it may be worth modifying
`mcmc` to translate them. They will be left as is for the first phase, but
integrating them in `mcmc` will be investigated and documented in the
implementation note.

6.2.4 Other complications

In some cases (most notably `org.xtuml.bp.core`), model data is split up into
pieces and processed by MC-Java in chunks. This will cause complexities in the
build integration. They will be identified and documented in the implementation
note as they are handled.

In the case of CME menus, it may be desirable to keep to versions of the model
data -- one processed by `mcmc` and one straight from the pre-builder. This
would be necessary if the CME function generation was left as is because `mcmc`
removes all the `ACT_` and `V_` instances. Details of this will also be
documented in the implementation note.

7. Design Comments
------------------

8. Unit Test
------------
See [[2.2]](#2.2) section 7

End
---

