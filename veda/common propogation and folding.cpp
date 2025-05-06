
#include <iostream>
#include <vector>
#include <unordered_map>
#include <sstream>
using namespace std;

struct Quadruple {
string op, arg1, arg2, result;
};
bool isNumber(const string &s) {
for (char c : s)
if (!isdigit(c)) return false;
return true;
}
int evaluate(string op, int a, int b) {
if (op == "+") return a + b;
if (op == "-") return a - b;
if (op == "*") return a * b;
if (op == "/") return b != 0 ? a / b : 0;
return 0;
}
int main() {
int n;
cout << "Enter number of quadruples: ";
cin >> n;
cin.ignore();
vector<Quadruple> quads(n);
unordered_map<string, int> constants; // Stores known constant values
cout << "Enter quadruples (op, arg1, arg2, result):\n";
for (int i = 0; i < n; ++i) {
string line;
getline(cin, line);
stringstream ss(line);
getline(ss, quads[i].op, ',');
getline(ss, quads[i].arg1, ',');
getline(ss, quads[i].arg2, ',');
getline(ss, quads[i].result, ',');
// Trim spaces
for (string *p : {&quads[i].op, &quads[i].arg1, &quads[i].arg2, &quads[i].result}) {
while (!p->empty() && p->front() == ' ') p->erase(0, 1);
while (!p->empty() && p->back() == ' ') p->pop_back();
}
}
cout << "\n--- Optimizing ---\n";
for (auto &q : quads) {
// Constant propagation
if (constants.count(q.arg1)) q.arg1 = to_string(constants[q.arg1]);
if (constants.count(q.arg2)) q.arg2 = to_string(constants[q.arg2]);
// Constant folding
if (isNumber(q.arg1) && (q.op != "=") && (q.arg2.empty() || isNumber(q.arg2))) {
int val = evaluate(q.op, stoi(q.arg1), q.arg2.empty() ? 0 : stoi(q.arg2));
q.op = "=";
q.arg1 = to_string(val);
q.arg2 = "";
constants[q.result] = val; // Store result as constant
} else if (q.op == "=" && isNumber(q.arg1)) {
constants[q.result] = stoi(q.arg1);
} else {
constants.erase(q.result); // No longer a constant
}
}
cout << "\n--- Optimized Quadruples ---\n";
for (const auto &q : quads) {
cout << q.op << ", " << q.arg1 << ", " << q.arg2 << ", " << q.result << '\n';
}
return 0;
}


//INPUT
//=, 2, , a
//=, 3, , b
//+, a, b, t1
//=, t1, , x
//*, x, 4, y