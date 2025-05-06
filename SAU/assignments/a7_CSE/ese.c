#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// Structure to represent a quadruple (op, arg1, arg2, result)
typedef struct {
    char op[5];
    char arg1[10];
    char arg2[10];
    char result[10];
} Quadruple;

// Structure to represent an expression for CSE
typedef struct {
    char op[5];
    char arg1[10];
    char arg2[10];
    char temp[10];
    bool used;
} Expression;

// Check if two expressions are identical (taking commutativity into account)
bool isSameExpression(Expression *e1, Expression *e2) {
    if (strcmp(e1->op, e2->op) != 0) return false;
    if (strcmp(e1->op, "+") == 0 || strcmp(e1->op, "*") == 0) {
        return ((strcmp(e1->arg1, e2->arg1)==0 && strcmp(e1->arg2, e2->arg2)==0) ||
                (strcmp(e1->arg1, e2->arg2)==0 && strcmp(e1->arg2, e2->arg1)==0));
    } else {
        return (strcmp(e1->arg1, e2->arg1)==0 && strcmp(e1->arg2, e2->arg2)==0);
    }
}

// Parse quadruples from a file named "input.txt"
Quadruple* parseQuadruples(const char *filename, int *count) {
    FILE *f = fopen(filename, "r");
    if (!f) {
        perror("fopen");
        exit(1);
    }
    // count non-blank lines
    int lines = 0;
    char buf[128];
    while (fgets(buf, sizeof buf, f)) if (strchr(buf, ',')) lines++;
    rewind(f);

    Quadruple *quads = malloc(lines * sizeof *quads);
    *count = 0;
    while (fgets(buf, sizeof buf, f)) {
        if (!strchr(buf, ',')) continue;
        buf[strcspn(buf, "\n")] = 0;
        char *t = strtok(buf, ",");    strcpy(quads[*count].op, t);
        t = strtok(NULL, ",");         strcpy(quads[*count].arg1, t);
        t = strtok(NULL, ",");         strcpy(quads[*count].arg2, t ? t : "");
        t = strtok(NULL, ",");         strcpy(quads[*count].result, t);
        (*count)++;
    }
    fclose(f);
    return quads;
}

// Apply Common Subexpression Elimination
Quadruple* applyCSE(Quadruple *in, int n, int *outCount) {
    Expression *exprs = malloc(n * sizeof *exprs);
    int exprN = 0;
    Quadruple *out = malloc(n * sizeof *out);
    *outCount = 0;

    for (int i = 0; i < n; i++) {
        Quadruple q = in[i];
        bool isCSE = false;

        // skip plain assignments
        if (strcmp(q.op, "=")==0 && q.arg2[0]==0) {
            out[(*outCount)++] = q;
            continue;
        }

        Expression cur = { .used=false };
        strcpy(cur.op, q.op);
        strcpy(cur.arg1, q.arg1);
        strcpy(cur.arg2, q.arg2);
        strcpy(cur.temp, q.result);

        for (int j = 0; j < exprN; j++) {
            if (isSameExpression(&cur, &exprs[j])) {
                // replace this quad with an assignment from previous temp
                strcpy(q.op, "=");
                strcpy(q.arg1, exprs[j].temp);
                q.arg2[0] = '\0';
                isCSE = true;
                break;
            }
        }

        out[(*outCount)++] = q;
        if (!isCSE) exprs[exprN++] = cur;
    }

    free(exprs);
    return out;
}

// Print a list of quadruples
void printQuads(const char *title, Quadruple *q, int n) {
    printf("%s\n", title);
    for (int i = 0; i < n; i++) {
        if (q[i].arg2[0])
            printf("%d: (%s, %s, %s, %s)\n", i, q[i].op, q[i].arg1, q[i].arg2, q[i].result);
        else
            printf("%d: (%s, %s, , %s)\n", i, q[i].op, q[i].arg1, q[i].result);
    }
    printf("\n");
}

int main(void) {
    int n;
    Quadruple *orig = parseQuadruples("input.txt", &n);

    printQuads("Original Quadruples:", orig, n);

    int m;
    Quadruple *opt = applyCSE(orig, n, &m);

    printQuads("After CSE:", opt, m);

    free(orig);
    free(opt);
    return 0;
}
