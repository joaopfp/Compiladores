#include "lexical_value.h"
#include <string.h>
#include <stdio.h>

// Function to create a new lexical value
LexicalValue* create_lexical_value(int line, TokenType type, const char* value) {
    LexicalValue* lv = (LexicalValue*)malloc(sizeof(LexicalValue));
    if (lv == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    lv->line = line;
    lv->type = type;
    lv->value = strdup(value);  // Duplicate the string to ensure it is managed separately
    if (lv->value == NULL) {
        fprintf(stderr, "String duplication failed\n");
        exit(EXIT_FAILURE);
    }
    return lv;
}

// Function to free a lexical value
void free_lexical_value(LexicalValue* lv) {
    if (lv != NULL) {
        free(lv->value);  // Free the duplicated string
        free(lv);         // Free the struct itself
    }
}
