%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 节点类型定义
typedef enum {
    NODE_ID, NODE_TRUE, NODE_FALSE, 
    NODE_NOT, NODE_AND, NODE_OR, 
    NODE_IMPLIES, NODE_IFF
} NodeType;

// AST节点结构
typedef struct ASTNode {
    NodeType type;
    char* id;
    struct ASTNode* left;
    struct ASTNode* right;
} ASTNode;

// 函数声明
ASTNode* createNode(NodeType type, char* id, ASTNode* left, ASTNode* right);
void printAST(ASTNode* node, int depth);
void freeAST(ASTNode* node);

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s) {
    fprintf(stderr, "语法错误: %s\n", s);
}
%}

%union {
    char* str;
    ASTNode* node;
}

%token <str> ID
%token TRUE FALSE
%token NOT AND OR IMPLIES IFF
%token LPAREN RPAREN

%type <node> formula

%left IFF
%left IMPLIES
%left OR
%left AND
%right NOT

%%

input: formula { 
        printf("语法分析成功！\n");
        printAST($1, 0);
        freeAST($1);
        exit(0);
    }
    ;

formula: ID { 
            $$ = createNode(NODE_ID, $1, NULL, NULL); 
        }
    | TRUE { 
            $$ = createNode(NODE_TRUE, NULL, NULL, NULL); 
        }
    | FALSE { 
            $$ = createNode(NODE_FALSE, NULL, NULL, NULL); 
        }
    | NOT formula { 
            $$ = createNode(NODE_NOT, NULL, $2, NULL); 
        }
    | LPAREN formula AND formula RPAREN { 
            $$ = createNode(NODE_AND, NULL, $2, $4); 
        }
    | LPAREN formula OR formula RPAREN { 
            $$ = createNode(NODE_OR, NULL, $2, $4); 
        }
    | LPAREN formula IMPLIES formula RPAREN { 
            $$ = createNode(NODE_IMPLIES, NULL, $2, $4); 
        }
    | LPAREN formula IFF formula RPAREN { 
            $$ = createNode(NODE_IFF, NULL, $2, $4); 
        }
    ;

%%

ASTNode* createNode(NodeType type, char* id, ASTNode* left, ASTNode* right) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = type;
    node->id = id;
    node->left = left;
    node->right = right;
    return node;
}

void printAST(ASTNode* node, int depth) {
    if (node == NULL) return;
    
    for (int i = 0; i < depth; i++) {
        printf("  ");
    }
    
    switch (node->type) {
        case NODE_ID:
            printf("ID: %s\n", node->id);
            break;
        case NODE_TRUE:
            printf("TRUE\n");
            break;
        case NODE_FALSE:
            printf("FALSE\n");
            break;
        case NODE_NOT:
            printf("NOT\n");
            printAST(node->left, depth + 1);
            break;
        case NODE_AND:
            printf("AND\n");
            printAST(node->left, depth + 1);
            printAST(node->right, depth + 1);
            break;
        case NODE_OR:
            printf("OR\n");
            printAST(node->left, depth + 1);
            printAST(node->right, depth + 1);
            break;
        case NODE_IMPLIES:
            printf("IMPLIES\n");
            printAST(node->left, depth + 1);
            printAST(node->right, depth + 1);
            break;
        case NODE_IFF:
            printf("IFF\n");
            printAST(node->left, depth + 1);
            printAST(node->right, depth + 1);
            break;
    }
}

void freeAST(ASTNode* node) {
    if (node == NULL) return;
    if (node->id) free(node->id);
    freeAST(node->left);
    freeAST(node->right);
    free(node);
}

int main(int argc, char** argv) {
    if (argc > 1) {
        FILE* file = fopen(argv[1], "r");
        if (file) {
            yyin = file;
        } else {
            fprintf(stderr, "无法打开文件: %s\n", argv[1]);
            return 1;
        }
    }
    yyparse();
    return 0;
}