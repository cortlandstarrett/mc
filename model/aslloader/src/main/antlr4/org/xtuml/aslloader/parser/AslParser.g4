parser grammar AslParser;

options {tokenVocab=AslLexer;}


target                        : statement+;

statement                     : SMT Identifier SEMI;
