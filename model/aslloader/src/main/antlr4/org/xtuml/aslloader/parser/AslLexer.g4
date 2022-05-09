lexer grammar AslLexer;

//==============================================================================
//==============================================================================
//
// Lexer 
//
//==============================================================================
//==============================================================================


// keywords and punctuation
ACTION                        : 'action';
ADA_INLINE                    : '#$ADA_INLINE'; // eat Ada incline code
ALREADY_DEFINED               : 'ALREADY_DEFINED';
AND                           : '&' | 'and';
APPEND                        : 'append';
ASSOCIATE                     : 'associate';
ASSOCIATION                   : '-A';
BOOLEAN                       : 'Boolean';
BREAK                         : 'break';
BREAKIF                       : 'breakif';
BRIDGE                        : 'bridge';
BY                            : 'by';
CARAT                         : '^';
CASE                          : 'case';
COLON                         : ':';
COMMA                         : ',';
COUNTOF                       : 'countof';
CREATE                        : 'create';
CREATE_TIMER                  : 'Create_Timer';
CURRENT_DATE                  : 'current-date';
CURRENT_TIME                  : 'current-time';
DEFAULT                       : 'default';
DEFINE                        : 'define';
DELETE                        : 'delete';
DELETE_TIMER                  : 'Delete_Timer';
DISUNION_OF                   : 'disunion-of';
DIV                           : '/';
DO                            : 'do';
DOT                           : '.';
DOUBLE_COLON                  : '::';
DQUOTE                        : '"';
ELSE                          : 'else';
ENDDEFINE                     : 'enddefine';
ENDFOR                        : 'endfor';
ENDIF                         : 'endif';
ENDLOOP                       : 'endloop';
ENDSWITCH                     : 'endswitch';
ENDUSE                        : '$ENDUSE';
EQUALS                        : '=' | 'equals';
ERROR                         : 'ERROR';
EVENT                         : 'event';
FALSE                         : 'FALSE';
FIND                          : 'find';
FIND_ALL                      : 'find-all';
FIND_ONE                      : 'find-one';
FIND_ONLY                     : 'find-only';
FOR                           : 'for';
FROM                          : 'from';
FUNCTION                      : 'function';
GENERATE                      : 'generate';
GET_TIME_REMAINING            : 'Get_Time_Remaining';
GREATER_THAN                  : '>' | 'greater-than';
GREATER_THAN_OR_EQUAL_TO      : '>=' | 'greater-than-or-equal-to';
IF                            : 'if';
IN                            : 'in';
INCLUDE_HEADER                : '$INCLUDE_HEADER'; // eat header lines
INLINE                        : '$INLINE'; // eat C inline code
INPUT                         : 'input';
INTEGER                       : 'Base_Integer_Type';
INTERSECTION_OF               : 'intersection-of';
IS                            : 'is';
LEFT_BRACE                    : '{';
LEFT_PARENTHESIS              : '(';
LEFT_SQUARE_BRACKET           : '[';
LESS_THAN                     : '<' | 'less-than';
LESS_THAN_OR_EQUAL_TO         : '<=' | 'less-than-or-equal-to';
LINK                          : 'link' | 'link-counterpart';      // could separate these
LOOP                          : 'loop';
MINUS                         : '-';
NEWLINE                       : '\n'+;
NOT                           : '!' | 'not';
NOT_EQUALS                    : '!=' | 'not-equals';
NOT_IN                        : 'not-in';
OF                            : 'of';
ON                            : 'on';
ONE_OF                        : 'one-of';
ONLY                          : 'only';
OR                            : '|' | 'or';
ORDERED                       : 'ordered';
OUTPUT                        : 'output';
PLUS                          : '+';
POINTER                       : '->';
REAL                          : 'Base_Float_Type';
RESET_TIMER                   : 'TIM2:Reset_Timer';
REVERSE                       : 'reverse';
RIGHT_BRACE                   : '}';
RIGHT_PARENTHESIS             : ')';
RIGHT_SQUARE_BRACKET          : ']';
SCENARIO                      : 'scenario';
SEMICOLON                     : ';';
SET_TIMER                     : 'TIM1:Set_Timer';
STAR                          : '*';
STRUCTURE                     : 'structure';
SWITCH                        : 'switch';
TEXT                          : 'Base_Text_Type';
THEN                          : 'then';
THIS                          : 'this';
TO                            : 'to';
TRUE                          : 'TRUE';
UNASSOCIATE                   : 'unassociate';
UNDEFINED                     : 'UNDEFINED';
UNION_OF                      : 'union-of';
UNIQUE                        : 'unique';
UNLINK                        : 'unlink' | 'unlink-counterpart';  // could separate these
USE                           : '$USE';
USING                         : 'using';
WHERE                         : 'where';
WITH                          : 'with';

SMT : 'statement';

Identifier                    : ( Letter | '_' ) ( Letter | Digit | '_' )*;
StringLiteral                 : '"' ( ~('\\'|'"') )* '"';
IntegerLiteral                : Digit+;
RealLiteral                   : Digit+
                                ( ('.' Digit+)
                                | UnbasedExponent
                                )
                              | '.' Digit+ UnbasedExponent?
                              ;
fragment UnbasedExponent      : ('e'|'E')('+'|'-')? Digit+ ;
fragment Digit                : '0'..'9';
fragment Letter               : 'A'..'Z' | 'a'..'z';
Continue_line                 : '\\' (' ' | '\t' | '\f' | '\r' )* NEWLINE -> skip;
Description                   : '#$DESCRIPTION' .*? '#$END_DESCRIPTION' NEWLINE -> skip; // TODO:  parse req IDs
TokenH                        : '#$TOKENH' .*? '#$END_TOKENH' NEWLINE -> skip; // TODO:  eat stuff?
TokenL                        : '#$TOKENL' .*? '#$END_TOKENL' NEWLINE -> skip; // TODO:  eat stuff?
Comment                       : '#' ~[\r\n]* NEWLINE -> skip;
Whitespace                    : (' ' | '\t' | '\f' )+ -> skip;
