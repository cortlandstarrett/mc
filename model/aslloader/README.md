## build

Build `ooaasl` first:

```
cd ../ooaasl
mvn install
```

Build `aslloader`:

```
mvn install
```

## run

Run a test:

```
java -jar target/aslloader-1.0.0-SNAPSHOT-jar-with-dependencies.jar -i test/test.asl
```
