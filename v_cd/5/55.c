#include <stdio.h>
#include <string.h>

#define MAX 100

typedef struct {
    char op[5], arg1[10], arg2[10], result[10];
} Quadruple;

int is_commutative(const char *op) {
    return (strcmp(op, "+") == 0 || strcmp(op, "*") == 0);
}

int are_expressions_equal(Quadruple q1, Quadruple q2) {
    if (strcmp(q1.op, q2.op) != 0)
        return 0;
    
    // For commutative ops: a + b == b + a
    if (is_commutative(q1.op)) {
        return ((strcmp(q1.arg1, q2.arg1) == 0 && strcmp(q1.arg2, q2.arg2) == 0) ||
                (strcmp(q1.arg1, q2.arg2) == 0 && strcmp(q1.arg2, q2.arg1) == 0));
    } else {
        return (strcmp(q1.arg1, q2.arg1) == 0 && strcmp(q1.arg2, q2.arg2) == 0);
    }
}

int main() {
    int n;
    printf("Enter number of quadruples: ");
    scanf("%d", &n);

    Quadruple quads[MAX], optimized[MAX];
    int used[MAX] = {0};

    printf("Enter quadruples in format: op arg1 arg2 result\n");
    for (int i = 0; i < n; i++) {
        scanf("%s %s %s %s", quads[i].op, quads[i].arg1, quads[i].arg2, quads[i].result);
    }

    int k = 0; // index for optimized
    for (int i = 0; i < n; i++) {
        int found = 0;

        for (int j = 0; j < k; j++) {
            if (are_expressions_equal(quads[i], optimized[j])) {
                // Replace with assignment
                strcpy(optimized[k].op, "=");
                strcpy(optimized[k].arg1, optimized[j].result);
                strcpy(optimized[k].arg2, "-");
                strcpy(optimized[k].result, quads[i].result);
                k++;
                found = 1;
                break;
            }
        }

        if (!found) {
            optimized[k++] = quads[i];
        }
    }

    printf("\nOptimized Quadruples:\n");
    for (int i = 0; i < k; i++) {
        printf("(%s, %s, %s, %s)\n", optimized[i].op, optimized[i].arg1, optimized[i].arg2, optimized[i].result);
    }

    return 0;
}
