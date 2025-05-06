#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// Structure to represent a quadruple (op, arg1, arg2, result)
typedef struct {
    char op[5];        // Operator: +, -, *, /, etc.
    char arg1[10];     // First argument
    char arg2[10];     // Second argument (can be empty for unary operations)
    char result[10];   // Result
} Quadruple;

// Structure to represent an expression
typedef struct {
    char op[5];
    char arg1[10];
    char arg2[10];
    char temp[10];     // Temporary variable used to store this expression
    bool used;         // Flag to mark if this expression has been used
} Expression;

// Function to check if two expressions are the same
bool isSameExpression(Expression *expr1, Expression *expr2) {
    // Check if operator and operands match
    if (strcmp(expr1->op, expr2->op) != 0) return false;
    
    // For commutative operations like addition and multiplication, 
    // check both orders of operands
    if (strcmp(expr1->op, "+") == 0 || strcmp(expr1->op, "*") == 0) {
        return ((strcmp(expr1->arg1, expr2->arg1) == 0 && 
                 strcmp(expr1->arg2, expr2->arg2) == 0) ||
                (strcmp(expr1->arg1, expr2->arg2) == 0 && 
                 strcmp(expr1->arg2, expr2->arg1) == 0));
    } else {
        // For non-commutative operations, operand order matters
        return (strcmp(expr1->arg1, expr2->arg1) == 0 && 
                strcmp(expr1->arg2, expr2->arg2) == 0);
    }
}

// Function to apply Common Subexpression Elimination
Quadruple* applyCSE(Quadruple *quads, int quadCount, int *newQuadCount) {
    Expression *expressions = (Expression*)malloc(quadCount * sizeof(Expression));
    int exprCount = 0;
    
    // Allocate space for optimized quadruples
    Quadruple *optimizedQuads = (Quadruple*)malloc(quadCount * sizeof(Quadruple));
    *newQuadCount = 0;
    
    // Process each quadruple
    for (int i = 0; i < quadCount; i++) {
        Quadruple *quad = &quads[i];
        bool foundCommonExpr = false;
        
        // Skip assignments (like a = b) as they're not expressions to optimize
        if (strlen(quad->arg2) == 0 && strcmp(quad->op, "=") == 0) {
            // Just copy assignment to optimized list
            optimizedQuads[*newQuadCount] = *quad;
            (*newQuadCount)++;
            continue;
        }
        
        // Create an expression from this quadruple
        Expression currentExpr;
        strcpy(currentExpr.op, quad->op);
        strcpy(currentExpr.arg1, quad->arg1);
        strcpy(currentExpr.arg2, quad->arg2);
        strcpy(currentExpr.temp, quad->result);
        currentExpr.used = false;
        
        // Check if this expression already exists
        for (int j = 0; j < exprCount; j++) {
            if (isSameExpression(&currentExpr, &expressions[j])) {
                // Common subexpression found
                // Instead of recalculating, use the previous result
                strcpy(quad->op, "=");
                strcpy(quad->arg1, expressions[j].temp);
                strcpy(quad->arg2, "");  // No second argument for assignments
                foundCommonExpr = true;
                break;
            }
        }
        
        // Add to optimized quadruples
        optimizedQuads[*newQuadCount] = *quad;
        (*newQuadCount)++;
        
        // If not a common subexpression, add to expressions list
        if (!foundCommonExpr) {
            expressions[exprCount++] = currentExpr;
        }
    }
    
    free(expressions);
    return optimizedQuads;
}

// Function to print quadruples
void printQuadruples(Quadruple *quads, int count, const char *title) {
    printf("%s:\n", title);
    for (int i = 0; i < count; i++) {
        if (strlen(quads[i].arg2) > 0) {
            printf("%d: (%s, %s, %s, %s)\n", i, 
                   quads[i].op, quads[i].arg1, quads[i].arg2, quads[i].result);
        } else {
            printf("%d: (%s, %s, , %s)\n", i, 
                   quads[i].op, quads[i].arg1, quads[i].result);
        }
    }
    printf("\n");
}

// Function to parse input quadruples from a file
Quadruple* parseQuadruples(const char *filename, int *count) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("Could not open file %s\n", filename);
        exit(1);
    }
    
    // Count lines in the file
    int lineCount = 0;
    char ch;
    while(!feof(file)) {
        ch = fgetc(file);
        if(ch == '\n') {
            lineCount++;
        }
    }
    
    // Reset file pointer
    rewind(file);
    
    // Allocate memory for quadruples
    Quadruple *quads = (Quadruple*)malloc(lineCount * sizeof(Quadruple));
    *count = 0;
    
    // Parse quadruples
    char line[100];
    while (fgets(line, sizeof(line), file)) {
        // Skip empty lines
        if (strlen(line) <= 1) continue;
        
        // Remove newline
        line[strcspn(line, "\n")] = 0;
        
        // Parse the quadruple
        char *token = strtok(line, ",");
        strcpy(quads[*count].op, token);
        
        token = strtok(NULL, ",");
        strcpy(quads[*count].arg1, token);
        
        token = strtok(NULL, ",");
        if (token) {
            strcpy(quads[*count].arg2, token);
        } else {
            strcpy(quads[*count].arg2, "");
        }
        
        token = strtok(NULL, ",");
        strcpy(quads[*count].result, token);
        
        (*count)++;
    }
    
    fclose(file);
    return quads;
}

// Example function to create sample quadruples for testing
Quadruple* createSampleQuadruples(int *count) {
    *count = 10;
    Quadruple *quads = (Quadruple*)malloc(*count * sizeof(Quadruple));
    
    // a = b + c
    strcpy(quads[0].op, "+");
    strcpy(quads[0].arg1, "b");
    strcpy(quads[0].arg2, "c");
    strcpy(quads[0].result, "t1");
    
    // d = b + c
    strcpy(quads[1].op, "+");
    strcpy(quads[1].arg1, "b");
    strcpy(quads[1].arg2, "c");
    strcpy(quads[1].result, "t2");
    
    // e = d - a
    strcpy(quads[2].op, "-");
    strcpy(quads[2].arg1, "t2");
    strcpy(quads[2].arg2, "t1");
    strcpy(quads[2].result, "t3");
    
    // f = b + c
    strcpy(quads[3].op, "+");
    strcpy(quads[3].arg1, "b");
    strcpy(quads[3].arg2, "c");
    strcpy(quads[3].result, "t4");
    
    // g = c + b (commutative operation)
    strcpy(quads[4].op, "+");
    strcpy(quads[4].arg1, "c");
    strcpy(quads[4].arg2, "b");
    strcpy(quads[4].result, "t5");
    
    // h = f * g
    strcpy(quads[5].op, "*");
    strcpy(quads[5].arg1, "t4");
    strcpy(quads[5].arg2, "t5");
    strcpy(quads[5].result, "t6");
    
    // i = b - c (not commutative)
    strcpy(quads[6].op, "-");
    strcpy(quads[6].arg1, "b");
    strcpy(quads[6].arg2, "c");
    strcpy(quads[6].result, "t7");
    
    // j = c - b (different order, not equal to i)
    strcpy(quads[7].op, "-");
    strcpy(quads[7].arg1, "c");
    strcpy(quads[7].arg2, "b");
    strcpy(quads[7].result, "t8");
    
    // k = h + 5
    strcpy(quads[8].op, "+");
    strcpy(quads[8].arg1, "t6");
    strcpy(quads[8].arg2, "5");
    strcpy(quads[8].result, "t9");
    
    // l = b + c (again)
    strcpy(quads[9].op, "+");
    strcpy(quads[9].arg1, "b");
    strcpy(quads[9].arg2, "c");
    strcpy(quads[9].result, "t10");
    
    return quads;
}

int main(int argc, char *argv[]) {
    int quadCount;
    Quadruple *quads;
    
    // Check if an input file is provided
    if (argc > 1) {
        quads = parseQuadruples(argv[1], &quadCount);
    } else {
        printf("No input file provided. Using sample quadruples.\n");
        quads = createSampleQuadruples(&quadCount);
    }
    
    // Print original quadruples
    printQuadruples(quads, quadCount, "Original Quadruples");
    
    // Apply CSE optimization
    int optimizedCount;
    Quadruple *optimizedQuads = applyCSE(quads, quadCount, &optimizedCount);
    
    // Print optimized quadruples
    printQuadruples(optimizedQuads, optimizedCount, "Optimized Quadruples (After CSE)");
    
    // Free memory
    free(quads);
    free(optimizedQuads);
    
    return 0;
}