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