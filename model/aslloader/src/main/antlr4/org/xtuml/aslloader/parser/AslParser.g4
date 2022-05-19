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
actionDefinition              : DEFINE ACTION actionName NEWLINE blockInput blockOutput statementList ENDDEFINE;
bridgeDefinition              : DEFINE BRIDGE bridgeName NEWLINE blockInput blockOutput statementList ENDDEFINE;
functionDefinition            : DEFINE FUNCTION functionName NEWLINE blockInput blockOutput statementList ENDDEFINE;
scenarioDefinition            : DEFINE SCENARIO scenarioName NEWLINE blockInput blockOutput statementList ENDDEFINE;
blockInput                    : INPUT blockParameters NEWLINE;
blockOutput                   : OUTPUT blockParameters NEWLINE;
blockParameters               : parameterDefinition? ( COMMA NEWLINE? parameterDefinition )*;
parameterDefinition           : parameterName COLON parameterType;
actionName                    : identifier;
bridgeName                    : identifier COLON identifier COLON identifier;  // TODO refine this
functionName                  : identifier ( COLON | DOUBLE_COLON ) identifier;
scenarioName                  : identifier;
parameterName                 : identifier;
parameterType                 : identifier | TEXT | INTEGER | REAL | BOOLEAN;

//---------------------------------------------------------
// Statement
//---------------------------------------------------------
statementList                 : statement* ;
statement                     : NEWLINE
                              | ifStatement NEWLINE
                              | loopStatement NEWLINE
                              | forStatement NEWLINE
                              | structureInstantiation NEWLINE
                              | structureAssembly NEWLINE
                              | assignStatement NEWLINE
                              | enumValueAssignStatement NEWLINE
                              | deleteStatement NEWLINE
                              | linkStatement NEWLINE
                              | generateStatement NEWLINE
                              | callStatement NEWLINE
                              | breakStatement NEWLINE
                              | breakifStatement NEWLINE
                              | Description
                              | AdaInline
                              | Inline
                              ;
assignStatement               : postfixExpression EQUALS expression;
enumValueAssignStatement      : identifier OF identifier EQUALS EnumerationLiteral; // TODO:  refine
deleteStatement               : DELETE expression
                              | DELETE objectName WHERE whereClause
                              ;
linkStatement                 : linkType
                                lhs=navigateExpression relationshipSpec
                                (
                                  rhs=navigateExpression
                                  ( ( USING | FROM ) assoc=navigateExpression)?
                                )?
                              ;
relationshipSpec              : relationshipReference ( DOT ( identifier | StringLiteral ) (DOT objectReference)? )?;
relationshipName              : RelationshipName;
relationshipReference         : relationshipName;
generateStatement             : GENERATE operationName COLON eventName
                                LEFT_PARENTHESIS argumentList RIGHT_PARENTHESIS ( TO expression )?
                              ;
ifStatement                   : IF condition THEN NEWLINE
                                  statementList
                                elseBlock?
                                ENDIF
                              ;
elseBlock                     : ELSE NEWLINE statementList
                              ;
loopStatement                 : LOOP NEWLINE
                                 statementList
                                ENDLOOP
                              ;
condition                     : logicalOr
                              ;
forStatement                  : FOR ( identifier | sequence ) IN SetIdentifier DO NEWLINE
                                  statementList
                                ENDFOR
                              ;
callStatement                 : sequence EQUALS root=nameExpression LEFT_SQUARE_BRACKET argumentList RIGHT_SQUARE_BRACKET;
breakStatement                : BREAK;
breakifStatement              : BREAKIF logicalOr;
structureInstantiation        : SetIdentifier IS typeName;
structureAssembly             : APPEND sequence TO SetIdentifier;

//---------------------------------------------------------
// Find Condition
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
unaryOperator                 : MINUS | PLUS | NOT | COUNTOF;
linkExpression                : navigateExpression
//                            | ( linkType
//                                lhs=navigateExpression relationshipSpec
//                                (rhs=navigateExpression)?
//                              )
                              ;
linkType                      : LINK | UNLINK | UNASSOCIATE;
navigateExpression            : lhs=navigateExpression
                                ( POINTER relationshipSpec whereClause?
                                )
                              | objectName whereClause
                              | postfixExpression
                              ;
postfixExpression             : root=postfixExpression
                                ( LEFT_PARENTHESIS argumentList RIGHT_PARENTHESIS
                                | DOT identifier
                                )
                              | extendedExpression
                              ;
extendedExpression            : createExpression
                              | findExpression
                              | primaryExpression
                              ;
findExpression                : findType objectReference ( whereClause )?;
whereClause                   : WHERE findCondition;
findType                      : FIND | FIND_ALL | FIND_ONE | FIND_ONLY;
createExpression              : CREATE UNIQUE? objectReference ( WITH createArgumentList )?;
createArgumentList            : (createArgument ( AND createArgument )*)?;
createArgument                : attributeName EQUALS expression
//                            | CURRENT_STATE EQUALS stateName
                              ;
primaryExpression             : literal
                              | parenthesisedExpression
                              | nameExpression
                              | sequence
                              ;
sequence                      : LEFT_SQUARE_BRACKET argumentList RIGHT_SQUARE_BRACKET;
nameExpression                : ( operationName DOUBLE_COLON )? identifier
                              | ( operationName COLON )? identifier
                              | identifier
                              ;
parenthesisedExpression       : LEFT_PARENTHESIS expression RIGHT_PARENTHESIS;
argumentList                  : (expression ( COMMA expression )*)? ;
operationName                 : identifier;
objectReference               : objectName;
objectName                    : identifier;
attributeName                 : identifier;
stateName                     : identifier;
eventName                     : identifier;
typeName                      : identifier;
identifier                    : Identifier | SetIdentifier;
literal                       : IntegerLiteral | RealLiteral | StringLiteral | THIS | TRUE | FALSE | EnumerationLiteral | UNDEFINED;

