parser grammar AslParser;

options {tokenVocab=AslLexer;}


target                        : bodyDefinition;

bodyDefinition                : actionDefinition
                              | bridgeDefinition
                              | functionDefinition
                              | scenarioDefinition
                              ;

//---------------------------------------------------------
// action bodies
//---------------------------------------------------------
actionDefinition              : DEFINE ACTION functionName NEWLINE blockInput blockOutput statement* ENDDEFINE;
bridgeDefinition              : DEFINE BRIDGE functionName NEWLINE blockInput blockOutput statement* ENDDEFINE;
functionDefinition            : DEFINE FUNCTION functionName NEWLINE blockInput blockOutput statement* ENDDEFINE;
scenarioDefinition            : DEFINE SCENARIO functionName NEWLINE blockInput blockOutput statement* ENDDEFINE;
blockInput                    : INPUT blockParameters NEWLINE;
blockOutput                   : OUTPUT blockParameters NEWLINE;
blockParameters               : parameterDefinition? ( NEWLINE parameterDefinition )*;
parameterDefinition           : parameterName COLON parameterType;
functionName                  : identifier DOUBLE_COLON identifier;
parameterName                 : identifier;
parameterType                 : identifier | INTEGER | REAL | BOOLEAN;

//---------------------------------------------------------
// Statement
//---------------------------------------------------------
statement                     : assignStatement NEWLINE
                              | createExpression NEWLINE
                              | deleteStatement NEWLINE
                              | linkStatement NEWLINE
                              | Description
                              ;
assignStatement               : identifier EQUALS expression;
deleteStatement               : DELETE expression
                              | DELETE objectName WHERE whereClause
                              ;
linkStatement                 : linkType
                                lhs=identifier relationshipName
                                (
                                  rhs=navigateExpression
                                  (USING assoc=navigateExpression)?
                                )?
                              ;
relationshipSpec              : relationshipReference ( DOT objOrRole=identifier (DOT objectReference)? )?;
relationshipName              : RelationshipName;
relationshipReference         : relationshipName;

//---------------------------------------------------------
// Find Condition  ... CDS can skip postfix, next is link.  Put link statements in test.asl.
//---------------------------------------------------------
findCondition                     : findLogicalOr;
findLogicalOr                     : lhs=findLogicalOr OR rhs=findLogicalXor
                                  | findLogicalXor
                                  ;
findLogicalXor                    : lhs=findLogicalXor XOR rhs=findLogicalAnd
                                  | findLogicalAnd
                                  ;
findLogicalAnd                    : lhs=findLogicalAnd AND rhs=findPrimary
                                  | findPrimary
                                  ;
findPrimary                       : findComparison
                                  | findUnary
                                  ;
findUnary                         : NOT findUnary
                                  | LEFT_PARENTHESIS findCondition RIGHT_PARENTHESIS
                                  ;
findComparison                    : lhs=findName ( EQUALS | NOT_EQUALS | LESS_THAN | GREATER_THAN | LESS_THAN_OR_EQUAL_TO | GREATER_THAN_OR_EQUAL_TO  ) rhs=additiveExp;
findName                          : att=identifier
                                    ( DOT comp=identifier
                                    | LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET
                                    )*
                                  ;

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
multExp                       : lhs=multExp ( STAR | SLASH | CARAT ) rhs=unaryExp // multiplication, division, exponentiation
                              | unaryExp
                              ;
unaryExp                      : unaryOperator exp=unaryExp
                              | linkExpression
                              ;
unaryOperator                 : MINUS | PLUS | NOT;
linkExpression                : navigateExpression
                              | ( linkType
                                  lhs=navigateExpression relationshipSpec
                                  (rhs=navigateExpression)?
                                )
                              ;
linkType                      : LINK | UNLINK;
navigateExpression            : lhs=navigateExpression
                                ( relationshipSpec whereClause?
//                              | WITH rhs=extendedExpression
//                                relationshipSpec
//                              | ORDERED_BY sortOrder
//                              | REVERSE_ORDERED_BY sortOrder
                                )
                              | extendedExpression
                              ;
extendedExpression            : primaryExpression
                              | createExpression
                              | findExpression
                              ;
findExpression                : findType objectReference ( WHERE whereClause )?;
whereClause                   : findCondition;
findType                      : FIND | FIND_ALL | FIND_ONE | FIND_ONLY;
createExpression              : CREATE UNIQUE? objectReference ( WITH createArgumentList )?;
createArgumentList            : (createArgument ( AND createArgument )*)?;
createArgument                : attributeName EQUALS expression
//                            | CURRENT_STATE EQUALS stateName
                              ;
primaryExpression             : literal
                              | parenthesisedExpression
                              | nameExpression
                              ;
objectReference               : objectName;
objectName                    : identifier;
attributeName                 : identifier;
stateName                     : identifier;
nameExpression                : identifier;
parenthesisedExpression       : LEFT_PARENTHESIS expression RIGHT_PARENTHESIS;
identifier                    : Identifier | SetIdentifier;
literal                       : IntegerLiteral | RealLiteral | StringLiteral | TRUE | FALSE | EnumerationLiteral;
