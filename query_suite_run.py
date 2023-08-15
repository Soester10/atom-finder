import os
import pandas as pd


def combine_csv(atom_name: str):
    main_df = None
    for file in os.listdir(f"CodeQL/{atom_name}/cpp/queries"):
        os.system(f"codeql database analyze CodeQL/db/postIncr-gitNotLatest-database --format=csv --output=CodeQL/out/{atom_name}_git_{file.split('.')[0]}.csv CodeQL/classifiers/{atom_name}/cpp/queries/{file} --rerun")

        # if main_df.all() == None:
        if type(main_df)() is None:
            main_df = pd.read_csv(f"CodeQL/out/{atom_name}_git_{file.split('.')[0]}.csv", header=None)
            os.remove(f"CodeQL/out/{atom_name}_git_{file.split('.')[0]}.csv")
            continue
        
        df = pd.read_csv(f"CodeQL/out/{atom_name}_git_{file.split('.')[0]}.csv", header=None)
        main_df = pd.concat([main_df, df], ignore_index=True)
        os.remove(f"CodeQL/out/{atom_name}_git_{file.split('.')[0]}.csv")

    main_df.to_csv(f"CodeQL/out/{atom_name}_git.csv", header=None, index=False)


if __name__ == "__main__":
    # combine_csv("assignmentAsValue")
    # combine_csv("implicitPredicate")
    combine_csv("conditionalOperator")

    
