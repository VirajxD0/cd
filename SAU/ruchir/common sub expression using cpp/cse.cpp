#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <string>

using namespace std;

// Maximum number of statements
const int MAX_STATEMENTS = 100;

// Arrays to store variables and expressions
string vars[MAX_STATEMENTS];
string exprs[MAX_STATEMENTS];
int stmt_count = 0;

// Read statements from input file
bool readStatementsFromFile(const string& filename) {
    ifstream infile(filename);
    string line;

    if (!infile.is_open()) {
        cerr << "Error: Could not open file " << filename << endl;
        return false;
    }

    stmt_count = 0;
    while (getline(infile, line) && stmt_count < MAX_STATEMENTS) {
        // Remove trailing semicolon and whitespace
        if (line.back() == ';') {
            line.pop_back();
        }
        while (!line.empty() && (line.back() == ' ' || line.back() == '\t')) {
            line.pop_back();
        }

        // Parse line into variable and expression
        int eq_pos = line.find('=');
        if (eq_pos == string::npos) continue;

        string var = line.substr(0, eq_pos);
        string expr = line.substr(eq_pos + 1);

        // Trim whitespace
        while (!var.empty() && (var.back() == ' ' || var.back() == '\t')) {
            var.pop_back(); 
        }
        while (!expr.empty() && (expr[0] == ' ' || expr[0] == '\t')) {
            expr.erase(0, 1);
        }

        if (!var.empty() && !expr.empty()) {
            vars[stmt_count] = var;
            exprs[stmt_count] = expr;
            stmt_count++;
        }
    }

    infile.close();
    return stmt_count > 0;
}

// Replace all occurrences of old_str with new_str in str
string replaceAll(const string& str, const string& old_str, const string& new_str) {
    string result = str;
    size_t pos = 0;
    while ((pos = result.find(old_str, pos)) != string::npos) {
        result.replace(pos, old_str.length(), new_str);
        pos += new_str.length();
    }
    return result;
}

// Perform Common Subexpression Elimination
void performCSE() {
    unordered_map<string, string> exprToVar; // Maps expression to variable
    string output[MAX_STATEMENTS]; // Store final statements
    int output_count = 0;

    // Process statements and build mappings
    for (int i = 0; i < stmt_count; i++) {
        string var = vars[i];
        string expr = exprs[i];

        // Check if expression exists
        if (exprToVar.find(expr) != exprToVar.end()) {
            // Expression is redundant, use the previous variable
            string prev_var = exprToVar[expr];
            // Update all later expressions that use this variable
            for (int j = i + 1; j < stmt_count; j++) {
                exprs[j] = replaceAll(exprs[j], var, prev_var);
            }
        } else {
            // New expression, add to map and keep statement
            exprToVar[expr] = var;
            output[output_count] = var + " = " + expr + ";";
            output_count++;
        }
    }

    // Print optimized statements
    cout << "After elimination -" << endl << endl;
    for (int i = 0; i < output_count; i++) {
        cout << output[i] << endl;
    }
}

int main() {
    string filename = "input.txt";
    if (!readStatementsFromFile(filename)) {
        cout << "No statements to process or file is empty." << endl;
        return 1;
    }

    cout << "Before elimination -" << endl << endl;
    for (int i = 0; i < stmt_count; i++) {
        cout << vars[i] << " = " << exprs[i] << ";" << endl;
    }
    cout << endl;

    performCSE();

    return 0;
}