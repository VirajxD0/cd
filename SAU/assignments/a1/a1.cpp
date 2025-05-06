#include <iostream>
#include <regex>
#include <vector>
#include <unordered_map>
#include <fstream>

using namespace std;

// Token types
enum TokenType
{
        KEYWORD,
        IDENTIFIER,
        OPERATOR,
        NUMBER,
        STRING,
        SYMBOL,
        COMMENT,
        ERROR
};

struct Token
{
        TokenType type;
        string value;
};

// List of SQL keywords
vector<string> keywords = {"SELECT", "FROM", "WHERE", "INSERT", "UPDATE", "DELETE", "CREATE", "DROP", "TABLE", "INTO", "VALUES", "SET"};

// Regular expressions for tokens
regex identifier_regex("^[a-zA-Z_][a-zA-Z0-9_]*");
regex number_regex("^[0-9]+(\\.[0-9]+)?");
regex string_regex("^'[^']*'");
regex operator_regex("^(>=|<=|<>|=|>|<|AND|OR|NOT)");
regex symbol_regex("^[(),;.*]");
regex comment_regex("^--.*");

// Function to check if a string is a keyword
bool isKeyword(const string &word)
{
        for (const string &kw : keywords)
        {
                if (word == kw)
                        return true;
        }
        return false;
}

// Function to get token type as a string
string getTokenTypeName(TokenType type)
{
        switch (type)
        {
        case KEYWORD:
                return "KEYWORD";
        case IDENTIFIER:
                return "IDENTIFIER";
        case OPERATOR:
                return "OPERATOR";
        case NUMBER:
                return "NUMBER";
        case STRING:
                return "STRING";
        case SYMBOL:
                return "SYMBOL";
        case COMMENT:
                return "COMMENT";
        case ERROR:
                return "ERROR";
        default:
                return "UNKNOWN";
        }
}

// Lexical Analyzer function
vector<Token> lexicalAnalysis(const string &code)
{
        vector<Token> tokens;
        unordered_map<TokenType, int> token_count;
        size_t i = 0;

        while (i < code.length())
        {
                if (isspace(code[i]))
                {
                        i++;
                        continue;
                }

                string remaining_code = code.substr(i);
                smatch match;

                if (regex_search(remaining_code, match, comment_regex))
                {
                        tokens.push_back({COMMENT, match.str()});
                        i += match.length();
                        continue;
                }
                if (regex_search(remaining_code, match, string_regex))
                {
                        tokens.push_back({STRING, match.str()});
                }
                else if (regex_search(remaining_code, match, number_regex))
                {
                        tokens.push_back({NUMBER, match.str()});
                }
                else if (regex_search(remaining_code, match, operator_regex))
                {
                        tokens.push_back({OPERATOR, match.str()});
                }
                else if (regex_search(remaining_code, match, symbol_regex))
                {
                        tokens.push_back({SYMBOL, match.str()});
                }
                else if (regex_search(remaining_code, match, identifier_regex))
                {
                        string token_value = match.str();
                        if (isKeyword(token_value))
                        {
                                tokens.push_back({KEYWORD, token_value});
                        }
                        else
                        {
                                tokens.push_back({IDENTIFIER, token_value});
                        }
                }
                else
                {
                        tokens.push_back({ERROR, string(1, code[i])});
                }

                token_count[tokens.back().type]++;
                i += match.length();
        }

        cout << "\nToken counts:\n";
        for (auto &pair : token_count)
        {
                cout << getTokenTypeName(pair.first) << " : " << pair.second << "\n";
        }

        return tokens;
}

// Driver Code
int main()
{
        ifstream inputFile("in.sql"); // Open the input file
        if (!inputFile)
        {
                cerr << "Error opening file!" << endl;
                return 1;
        }

        string sql_code((istreambuf_iterator<char>(inputFile)), istreambuf_iterator<char>()); // Read file content
        inputFile.close();

        vector<Token> tokens = lexicalAnalysis(sql_code);

        ofstream outputFile("output.txt");
        if (!outputFile)
        {
                cerr << "Error opening output file!" << endl;
                return 1;
        }

        outputFile << "\nTokens:\n";
        for (const auto &token : tokens)
        {
                outputFile << "Type: " << getTokenTypeName(token.type) << "\tValue: " << token.value << "\n";
        }
        outputFile.close();

        return 0;
}
