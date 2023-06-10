# atom-finder
Tool to find the Atoms of Confusion in a project

## Commands

### CodeQL
Install CodeQL CLI from [here](https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/getting-started-with-the-codeql-cli)

- DB Create:

```
cd <project directory>
codeql database create <db location> --language=<language> --command="<optional build command for compiled languages"
```

- Install ql pack:
Create qlpack.yml in query directory \(refer [this](https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/about-codeql-packs)\)

```
cd <codeql query directory> && codeql pack install  
```

- DB Analyze:

```
codeql database analyze <db> --format=csv --output=<output location> <query.ql file>
```


### Semgrep
Install Semgrep from [here](https://github.com/returntocorp/semgrep)

- Pattern Matching:

```
semgrep --config <rule.yaml file> --output <output location> --json
```