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

//---------------------------------------------------------
// Statement
//---------------------------------------------------------
statement                     : SMT Identifier NEWLINE
                              | assignStatement NEWLINE
                              | Description
                              ;
assignStatement               : Identifier EQUALS expression; // TODO:  change to constExpression


//---------------------------------------------------------
// Expression
//---------------------------------------------------------
constExpression               : expression;
expression                    : rangeExpression;
rangeExpression               : logicalOr (DOUBLE_DOT logicalOr)?;
logicalOr                     : lhs=logicalOr OR rhs=logicalXor
                              | logicalXor
                              ;
logicalXor                    : lhs=logicalXor XOR rhs=logicalAnd
                              | logicalAnd
                              ;
logicalAnd                    : lhs=logicalAnd AND rhs=equality
                              | equality
                              ;
equality                      : lhs=equality ( EQUALS | NOT_EQUALS ) rhs=relationalExp
                              | relationalExp
                              ;
relationalExp                 : lhs=relationalExp ( LESS_THAN | GREATER_THAN | LESS_THAN_OR_EQUAL_TO | GREATER_THAN_OR_EQUAL_TO ) rhs=additiveExp
                              | additiveExp
                              ;
additiveExp                   : lhs=additiveExp ( PLUS | MINUS ) rhs=multExp
                              | multExp
                              ;
multExp                       : lhs=multExp ( STAR | SLASH | MOD | CARAT ) rhs=unaryExp
                              | unaryExp
                              ;
unaryExp                      : unaryOperator exp=unaryExp
                              | primaryExpression
                              ;
unaryOperator                 : MINUS | PLUS | NOT
//                            | ABS
                              ;
primaryExpression             : literal
                              | parenthesisedExpression
                              | nameExpression
                              ;
nameExpression                : identifier;
parenthesisedExpression       : LEFT_PARENTHESIS expression RIGHT_PARENTHESIS;
identifier                    : Identifier;
literal                       : IntegerLiteral | RealLiteral | StringLiteral;
