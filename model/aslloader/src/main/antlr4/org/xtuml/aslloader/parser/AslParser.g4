parser grammar AslParser;

options {tokenVocab=AslLexer;}


target                        : bodyDefinition;

bodyDefinition                : actionDefinition
                              | bridgeDefinition
                              | functionDefinition
                              | scenarioDefinition
                              ;

//---------------------------------------------------------
// action body definitions
//---------------------------------------------------------
actionDefinition              : DEFINE ACTION functionName NEWLINE blockInput blockOutput statement* ENDDEFINE
                              ;
bridgeDefinition              : DEFINE BRIDGE functionName NEWLINE blockInput blockOutput statement* ENDDEFINE
                              ;
functionDefinition            : DEFINE FUNCTION functionName NEWLINE blockInput blockOutput statement* ENDDEFINE
                              ;
scenarioDefinition            : DEFINE SCENARIO functionName NEWLINE blockInput blockOutput statement* ENDDEFINE
                              ;
blockInput                    : INPUT blockParameters NEWLINE;
blockOutput                   : OUTPUT blockParameters NEWLINE;
blockParameters               : parameterDefinition? ( NEWLINE parameterDefinition )*
                              ;
parameterDefinition           : parameterName COLON parameterType;
functionName                  : Identifier DOUBLE_COLON Identifier;
parameterName                 : Identifier;
parameterType                 : Identifier | INTEGER | REAL | BOOLEAN;
statement                     : SMT Identifier NEWLINE
                              | Description
                              ;
