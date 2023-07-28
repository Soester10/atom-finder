import pandas as pd

##Clojure
clj_df = pd.read_csv("Clojure/all_atoms.csv")

## postIncrement
# clj_postfix_git = clj_df.loc[clj_df['atom'] == ':post-increment', ['file', 'line']]

## implicitPredicate
clj_postfix_git = clj_df.loc[clj_df['atom'] == ':implicit-predicate', ['file', 'line']]

clj_postfix_git = clj_postfix_git.loc[clj_postfix_git['file'].str.startswith('git/', na=False)]

# clj_postfix_git_map = clj_postfix_git.set_index('file').to_dict()['line']
clj_postfix_git_map = clj_postfix_git['file'].astype(str) + " : " + clj_postfix_git['line'].astype('str')
clj_postfix_git_map = set(clj_postfix_git_map)

# clj_postfix_git_map = {'git/compat/mingw.c : 903', 'git/compat/inet_pton.c : 125', 'git/compat/mingw.c : 1283', 'git/contrib/credential/gnome-keyring/git-credential-gnome-keyring.c : 394', 'git/contrib/credential/gnome-keyring/git-credential-gnome-keyring.c : 381', 'git/compat/mingw.c : 1282', 'git/compat/inet_pton.c : 62', 'git/strbuf.c : 526', 'git/compat/mingw.c : 2036', 'git/compat/inet_pton.c : 148', 'git/compat/inet_ntop.c : 148', 'git/compat/mingw.c : 2051', 'git/contrib/credential/osxkeychain/git-credential-osxkeychain.c : 150', 'git/contrib/credential/gnome-keyring/git-credential-gnome-keyring.c : 430', 'git/compat/mingw.c : 887', 'git/compat/mingw.c : 2048', 'git/compat/inet_pton.c : 149', 'git/compat/mingw.c : 2009', 'git/compat/basename.c : 51', 'git/contrib/credential/wincred/git-credential-wincred.c : 261', 'git/compat/mingw.c : 2021', 'git/compat/inet_ntop.c : 128', 'git/contrib/credential/libsecret/git-credential-libsecret.c : 280', 'git/contrib/credential/libsecret/git-credential-libsecret.c : 293', 'git/contrib/examples/builtin-fetch--tool.c : 371', 'git/compat/mingw.c : 906', 'git/compat/mingw.c : 2060', 'git/compat/win32/dirent.c : 35', 'git/compat/mingw.c : 899', 'git/compat/mingw.c : 905', 'git/compat/mingw.c : 2026', 'git/compat/mingw.c : 2047', 'git/compat/mingw.c : 895', 'git/compat/inet_ntop.c : 133', 'git/contrib/credential/osxkeychain/git-credential-osxkeychain.c : 127', 'git/compat/mingw.c : 890', 'git/compat/inet_pton.c : 166', 'git/compat/memmem.c : 25', 'git/contrib/credential/libsecret/git-credential-libsecret.c : 329', 'git/compat/mingw.c : 2035', 'git/compat/inet_pton.c : 165', 'git/contrib/examples/builtin-fetch--tool.c : 262', 'git/compat/mingw.c : 2054', 'git/compat/mingw.c : 898', 'git/contrib/credential/gnome-keyring/git-credential-gnome-keyring.c : 371', 'git/ppc/sha1.c : 59', 'git/compat/inet_ntop.c : 147', 'git/contrib/examples/builtin-fetch--tool.c : 364', 'git/contrib/credential/libsecret/git-credential-libsecret.c : 270', 'git/compat/mingw.c : 2058', 'git/contrib/examples/builtin-fetch--tool.c : 335', 'git/compat/mingw.c : 900', 'git/compat/mingw.c : 2050', 'git/compat/win32/dirent.c : 36', 'git/compat/mingw.c : 2027', 'git/compat/mingw.c : 2046', 'git/compat/mingw.c : 2034'}


##CodeQL
# codeql_df = pd.read_csv("CodeQL/out/postfix_atoms_gitNotLatest.csv", header=None)
# codeql_df = pd.read_csv("CodeQL/out/postfix_git_final.csv", header=None)
# codeql_df = pd.read_csv("CodeQL/out/postfix_cpp_try4.csv", header=None)
codeql_df = pd.read_csv("CodeQL/out/implicitPredicate_git3.csv", header=None)
## col4 => file; col5 => line
codeql_df[4] = 'git' + codeql_df[4].astype(str)

# codeql_postfix_git_map = codeql_df.set_index(4).to_dict()[5]
codeql_postfix_git_map = codeql_df[4].astype(str) + " : " + codeql_df[5].astype(str)
codeql_postfix_git_map = set(codeql_postfix_git_map)


codeql_compiled_files_df = pd.read_csv("CodeQL/out/compiled_files_git.csv")
codeql_compiled_files = set(codeql_compiled_files_df["file"])


##check for lines in map1 that is not present in map2
def check_diff(map1, map2):
    diff = set()
    for i in map1:
        if i in map2 or i.split(" : ")[0] not in codeql_compiled_files:
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


