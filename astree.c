#include "ast.h"
#include <stdio.h>

// Function to create a new AST node
ASTNode *create_ast_node(NodeType type, void *data) {
    ASTNode *node = (ASTNode *)malloc(sizeof(ASTNode));
    if (node == NULL) {
        fprintf(stderr, "Failed to allocate memory for AST node\n");
        exit(EXIT_FAILURE);
    }
    node->type = type;
    node->data = data;
    node->firstChild = NULL;
    node->nextSibling = NULL;
    return node;
}

// Function to add a child to an AST node
void add_child_node(ASTNode *parent, ASTNode *child) {
    if (parent == NULL || child == NULL) {
        fprintf(stderr, "Invalid node pointer(s)\n");
        return;
    }
    if (parent->firstChild == NULL) {
        parent->firstChild = child;
    } else {
        ASTNode *temp = parent->firstChild;
        while (temp->nextSibling != NULL) {
            temp = temp->nextSibling;
        }
        temp->nextSibling = child;
    }
}

// Function to add a sibling to an AST node
void add_sibling_node(ASTNode *node, ASTNode *sibling) {
    if (node == NULL || sibling == NULL) {
        fprintf(stderr, "Invalid node pointer(s)\n");
        return;
    }
    while (node->nextSibling != NULL) {
        node = node->nextSibling;
    }
    node->nextSibling = sibling;
}

// Recursive function to free an AST
void free_ast(ASTNode *node) {
    if (node != NULL) {
        free_ast(node->firstChild);
        free_ast(node->nextSibling);
        free(node->data); // Assuming 'data' is dynamically allocated
        free(node);
    }
}
