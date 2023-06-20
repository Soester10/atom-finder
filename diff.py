import pandas as pd

##Clojure
clj_df = pd.read_csv("Clojure/all_atoms.csv")

clj_postfix_git = clj_df.loc[clj_df['atom'] == ':post-increment', ['file', 'line']]
clj_postfix_git = clj_postfix_git.loc[clj_postfix_git['file'].str.startswith('git/', na=False)]

# clj_postfix_git_map = clj_postfix_git.set_index('file').to_dict()['line']
clj_postfix_git_map = clj_postfix_git['file'].astype(str) + " : " + clj_postfix_git['line'].astype('str')
clj_postfix_git_map = set(clj_postfix_git_map)


##CodeQL
codeql_df = pd.read_csv("CodeQL/out/postfix_atoms_gitNotLatest.csv", header=None)
## col4 => file; col5 => line
codeql_df[4] = 'git' + codeql_df[4].astype(str)

# codeql_postfix_git_map = codeql_df.set_index(4).to_dict()[5]
codeql_postfix_git_map = codeql_df[4].astype(str) + " : " + codeql_df[5].astype(str)
codeql_postfix_git_map = set(codeql_postfix_git_map)


##check for lines in map1 that is not present in map2
def check_diff(map1, map2):
    diff = set()
    for i in map1:
        if i in map2:
            continue
        diff.add(i)
    
    return diff

if __name__ == "__main__":
    print("Total Findings in Clojure:", len(clj_postfix_git_map))
    print("Total Findings in CodeQL:", len(codeql_postfix_git_map))

    ##check for lines in clojure that is not present in codeql
    diff_clj_codeql = check_diff(clj_postfix_git_map, codeql_postfix_git_map)
    print("Lines in Clojure that is not present in CodeQL:", len(diff_clj_codeql))

    ##check for lines in codeql that is not present in clojure
    diff_codeql_clj = check_diff(codeql_postfix_git_map, clj_postfix_git_map)
    print("Lines in CodeQL that is not present in Clojure:", len(diff_codeql_clj))

    print(diff_clj_codeql)
    print()
    print(diff_codeql_clj)

    # print(clj_postfix_git_map)
    # print()
    # print(codeql_postfix_git_map)


