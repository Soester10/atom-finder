import pandas as pd

codeql_df = pd.read_csv("CodeQL/out/postfix_git_final.csv", header=None)

codeql_df[4] = 'git' + codeql_df[4].astype(str)

codeql_allExprs_files = codeql_df[4].astype(str)
codeql_allExprs_files = set(codeql_allExprs_files)

codeql_allExprs_map = {'file': list(codeql_allExprs_files)}
codeql_allExprs_df = pd.DataFrame(codeql_allExprs_map)

codeql_allExprs_df.to_csv('CodeQL/out/compiled_files_git.csv')