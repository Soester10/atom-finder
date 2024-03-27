import pandas as pd
import sys
import random

##Clojure parse all atoms
clj_df = pd.read_csv("Clojure/all_atoms.csv")


##TODO: del later
# clj_df = pd.read_csv("Clojure/out_git4.csv")

##Naming convention map
atoms_naming_map = {"postIncr": "post-increment", 
                    "preIncr": "pre-increment",
                    "implicitPredicate": "implicit-predicate",
                    "assignmentAsValue": "assignment-as-value",
                    "conditionalOperator": "conditional",
                    "reversedSubscripts": "reversed-subscript", ##TODO
                    "logicAsControlFlow": "logic-as-control-flow",
                    "operatorPrecedence": "operator-precedence", ##TODO
                    "macroOperatorPrecedence": "macro-operator-precedence", ##TODO
                    "preprocessorInStatement": "preprocessor-in-statement", ##TODO
                    "commaOperator": "comma-operator",
                    "typeConversion" : "type-conversion", ##TODO
                    "repurposedVariable": "repurposed-variable", ##TODO
                    "literalEncoding": "literal-encoding", #TODO
                    }

# #tests to get all atoms name in clj codebase
# print(clj_df["atom"].unique())
# sys.exit(0)

def process_clojure_results(atom_name: str):
    clj_atoms = clj_df.loc[clj_df['atom'] == f":{atoms_naming_map[atom_name]}", ['file', 'line']]

    clj_atoms = clj_atoms.loc[clj_atoms['file'].str.startswith(f'{project}/', na=False)]
   
   
    ##TODO: del later
    # clj_atoms = clj_df.loc[clj_df['atom'] == f"{atoms_naming_map[atom_name]}", ['file', 'line']]
    # clj_atoms['file'] = clj_atoms['file'].str.split("git_notLatest.nosync/").str[-1]



    # clj_atoms = clj_atoms.set_index('file').to_dict()['line']
    clj_atoms_map = clj_atoms['file'].astype(str) + " : " + clj_atoms['line'].astype(str)
    clj_atoms_map = set(clj_atoms_map)

    # clj_postfix_git_map = {'git/compat/mingw.c : 903', 'git/compat/inet_pton.c : 125', ... }

    return clj_atoms_map


# #to analyze the AST with few examples
# project="git"
# clj_atoms_map = process_clojure_results(atom_name = "preprocessorInStatement")
# print(len(list(clj_atoms_map)))
# print(random.sample(list(clj_atoms_map), 10))
# sys.exit(0)


def process_codeql_results(atom_name: str):
    codeql_df = pd.read_csv(f"CodeQL/out/{atom_name}_{project}.csv", header=None)

    ## col4 => file; col5 => line
    codeql_df[4] = project + codeql_df[4].astype(str)

    # codeql_postfix_git_map = codeql_df.set_index(4).to_dict()[5]
    codeql_atoms_map = codeql_df[4].astype(str) + " : " + codeql_df[5].astype(str)
    codeql_atoms_map = set(codeql_atoms_map)

    return codeql_atoms_map


def get_codeql_all_compiled_files():
    codeql_compiled_files_df = pd.read_csv("CodeQL/out/compiled_files_git.csv")
    codeql_compiled_files = set(codeql_compiled_files_df["file"])

    return codeql_compiled_files



def process_results(atom_name: str):
    ##Clojure
    clj_atoms_map = process_clojure_results(atom_name)

    ##CodeQL
    codeql_atoms_map = process_codeql_results(atom_name)

    ##tests
    # print(codeql_postfix_git_map)
    # sys.exit(0)

    ##CodeQL all compiled files
    codeql_compiled_files = get_codeql_all_compiled_files()

    return clj_atoms_map, codeql_atoms_map, codeql_compiled_files


##check for lines in map1 that is not present in map2
def check_diff(map1: set, map2: set, codeql_compiled_files: set):
    diff = set()
    for i in map1:
        if i in map2 or i.split(" : ")[0] not in codeql_compiled_files:
            continue
        diff.add(i)
    
    return diff

if __name__ == "__main__":

    project = "git"

    atom_name = "preIncr"

    clj_atoms_map, codeql_atoms_map, codeql_compiled_files = process_results(atom_name)
    
    print("Total Findings in Clojure:", len(clj_atoms_map))
    print("Total Findings in CodeQL:", len(codeql_atoms_map))

    ##check for lines in clojure that is not present in codeql
    diff_clj_codeql = check_diff(clj_atoms_map, codeql_atoms_map, codeql_compiled_files)
    print("Lines in Clojure that is not present in CodeQL:", len(diff_clj_codeql))

    ##check for lines in codeql that is not present in clojure
    diff_codeql_clj = check_diff(codeql_atoms_map, clj_atoms_map, codeql_compiled_files)
    print("Lines in CodeQL that is not present in Clojure:", len(diff_codeql_clj))
    
    # print("\n Lines in Clojure that is not present in CodeQL")
    print(sorted(diff_clj_codeql))
    # print("\n Lines in CodeQL that is not present in Clojure")
    # print(sorted(diff_codeql_clj))
    # print()
    # print(sorted(diff_codeql_clj))

    # print(clj_atoms_map)
    # print()
    # print(codeql_atoms_map)


