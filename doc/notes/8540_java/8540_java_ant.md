---

This work is licensed under the Creative Commons CC0 License

---

# MCMC Java
### xtUML Project Analysis Note

1. Abstract
-----------
The goal of this project is to extend `mcmc` to run in "Java mode" and generate
action bodies in Java. Then `mcmc` can be integrated into the MC-Java build.
This will decrease build time for BridgePoint development and pave the way for a
more mature and useful MC-Java.

2. Document References
----------------------
<a id="2.1"></a>2.1 [#8540 Parent issue](https://support.onefact.net/issues/8540)  

3. Background
-------------
Important vocabulary:
* __xtUML__ - The modelling language based on the Shlaer-Mellor methodology  
* __OAL (Object Action Language)__ - The textual language used to model actions
  in xtUML  
* __RSL__ - The template language used to build model compilers  
* __model compiler__ - An application used to transform xtUML to a target
  language/architecture  
* __MC3020__ - The C model compiler  
* __mcmc__ - The compiled part of MC3020 used to translate the OAL  
* __MC-Java__ - The Java model compiler used to build BridgePoint  

The C model compiler (MC3020) works in two parts. First, the model data is
passed to a compiled C executable `mcmc`. In this stage, all of the action
language is generated and then rolled up into model instances, each representing
a single action body. This new model data is then passed to the interpreted RSL
part of the compiler which generates all of the structural portions of the model
and inserts the generated action bodies. By the end of this work, MC-Java will
also work similarly in two phases, leveraging the extended `mcmc`.

4. Requirements
---------------
4.1 `mcmc` shall be extended to produce generated Java for action bodies  
4.2 MC-Java shall be modified to integrate `mcmc` into the build  
4.2.1 MC-Java shall generate code the "old way" in the absence of the `mcmc`
executable  
4.3 The design shall facilitate maintenance and extension of this work  

5. Analysis
-----------
5.1 

6. Work Required
----------------
6.1 Modify MC-Java build process to call `mcmc` before main compiler  
6.2 Modify MC-Java to recognize `TE_ABA` classes and use them if present  
6.3 Create mechanism to differentiate between "Java" and "C" mode in `mcmc`  
6.4 Modify MC3020 archetypes to translate values for Java  
6.5 Modify MC3020 archetypes to translate statements for Java  

7. Acceptance Test
------------------
7.1 Build BridgePoint without `mcmc`. Verify that the build completes normally  
7.2 Build BridgePoint with the Java extended `mcmc`. Verify that the generated
code is correct and that the build time decreased.

End
---

