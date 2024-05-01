#ifndef AST_H
#define AST_H

#include <stdlib.h>

// Define the type of node, which could be extended with more types as needed
typedef enum {
    NODE_TYPE_FUNCTION,
    NODE_TYPE_COMMAND,
    NODE_TYPE_EXPRESSION
} NodeType;

// Define a generic AST node structure
typedef struct ASTNode {
    NodeType type;               // Type of the node
    void *data;                  // Pointer to the node's specific content
    struct ASTNode *firstChild;  // Pointer to the first child node
    struct ASTNode *nextSibling; // Pointer to the next sibling node
} ASTNode;

// Function prototypes
ASTNode *create_ast_node(NodeType type, void *data);
void add_child_node(ASTNode *parent, ASTNode *child);
void add_sibling_node(ASTNode *node, ASTNode *sibling);
void free_ast(ASTNode *node);

#endif // AST_H
