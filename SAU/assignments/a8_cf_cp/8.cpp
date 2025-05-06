#include <iostream>
#include <fstream>
#include <vector>
#include <unordered_map>
#include <sstream>
using namespace std;

struct Quadruple {
    string op, arg1, arg2, result;
};

static bool isNumber(const string &s) {
    for (char c : s)
        if (!isdigit(c)) return false;
    return !s.empty();
}

static int evaluate(const string &op, int a, int b) {
    if (op == "+") return a + b;
    if (op == "-") return a - b;
    if (op == "*") return a * b;
    if (op == "/" && b != 0) return a / b;
    return 0;
}

int main() {
    ifstream in("input.txt");
    if (!in) {
        cerr << "Failed to open input.txt\n";
        return 1;
    }

    vector<Quadruple> quads;
    string line;
    // Read every non-blank line as: op,arg1,arg2,result
    while (getline(in, line)) {
        if (line.find(',') == string::npos) continue;
        Quadruple q;
        stringstream ss(line);
        getline(ss, q.op, ',');
        getline(ss, q.arg1, ',');
        getline(ss, q.arg2, ',');
        getline(ss, q.result, ',');
        // trim spaces
        for (auto *p : {&q.op,&q.arg1,&q.arg2,&q.result}) {
            while (!p->empty() && isspace(p->front())) p->erase(0,1);
            while (!p->empty() && isspace(p->back())) p->pop_back();
        }
        quads.push_back(q);
    }

    // constant map
    unordered_map<string,int> C;
    for (auto &q : quads) {
        // propagate
        if (C.count(q.arg1)) q.arg1 = to_string(C[q.arg1]);
        if (C.count(q.arg2)) q.arg2 = to_string(C[q.arg2]);

        // fold
        if (isNumber(q.arg1) && (q.op!="=") && (q.arg2.empty()||isNumber(q.arg2))) {
            int v = evaluate(q.op, stoi(q.arg1), q.arg2.empty()?0:stoi(q.arg2));
            q.op = "=";  q.arg1 = to_string(v);  q.arg2.clear();
            C[q.result] = v;
        }
        else if (q.op=="=" && isNumber(q.arg1)) {
            C[q.result] = stoi(q.arg1);
        }
        else {
            C.erase(q.result);
        }
    }

    // output
    for (auto &q : quads) {
        cout << q.op << ", " 
             << q.arg1 << ", " 
             << q.arg2 << ", " 
             << q.result << "\n";
    }
}
