#ifndef LEXICAL_VALUE_H
#define LEXICAL_VALUE_H

#include <stdlib.h>

// Define a type for token categories
typedef enum {
    IDENTIFIER, LITERAL
} TokenType;

// Define the LexicalValue struct
typedef struct {
    int line;            // Line number where the token was found
    TokenType type;      // Type of the token (identifier or literal)
    char* value;         // Value of the token as a string
} LexicalValue;

// Function prototypes
LexicalValue* create_lexical_value(int line, TokenType type, const char* value);
void free_lexical_value(LexicalValue* lv);

#endif // LEXICAL_VALUE_H
