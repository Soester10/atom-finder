import os

#CODEQL
def codeql():
    project_directory: str = "."
    db_location: str = os.path.join(project_directory, "CodeQL/db/postIncr-cpp-database2")
    language: str = "cpp"
    main_file: str = os.path.join(project_directory, "examples/test1.cpp")
    output_location: str = os.path.join(project_directory, "CodeQL/out/postIncr_cpp2.csv")
    query_file_location: str = "CodeQL/postIncr/cpp/postIncr_cpp.ql"

    build_commands: dict = {'cpp': 'g++', 'java': 'javac'}
    main_file_name: str = os.path.split(main_file)[1]
    extension: str = main_file_name.split(".")[-1]
    command: str = ""
    if extension in build_commands:
        command = build_commands[extension] + " " + main_file
        command = f' --command="{command}"'


    ##change into project directory
    os.system(f"cd {project_directory}")

    ## create db
    os.system(f"codeql database create {db_location} --language={language}" + command)

    ## install ql packs
    ###TODO

    ## db analyze
    os.system(f"codeql database analyze {db_location} --format=csv --output={output_location} {query_file_location}")



#SEMGREP
def semgrep():
    project_directory: str = "examples"
    rule_file_location: str = "Semgrep/postIncr/postIncr_cpp.yaml"
    output_location: str = "Semgrep/out/postIncr_cpp2.json"

    ##change into project directory
    os.system(f"cd {project_directory}")

    ## pattern matching
    os.system(f"semgrep --config {rule_file_location} --output {output_location} --json")



if __name__ == "__main__":
    codeql()
    semgrep()
