/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

import cpp

// from PostfixCrementOperation e
// where not(e instanceof ExprInVoidContext) or e.getParent() instanceof WhileStmt
// select e, "This is a Preprocessor In Statement atom"
// predicate isMacroinFunction(Macro e) { e.getParentScope() instanceof TopLevelFunction }
// from Macro e
// where isMacroinFunction(e)
// select e, "This is a Preprocessor In Statement atom"
// //new
predicate isMacroinFunction(TopLevelFunction f) {
  //   f.getEntryPoint().getAChild().isAffectedByMacro()
  //   exists(Macro macro | f.getEntryPoint().getAChild() = macro)
  exists(Macro macro |
    f.getLocation().getFile() = macro.getLocation().getFile() and
    (
      f.getEntryPoint().getLocation().getStartLine() < macro.getLocation().getStartLine() and
      f.getEntryPoint().getLocation().getEndLine() > macro.getLocation().getEndLine()
    )
  )
}

from TopLevelFunction f
where isMacroinFunction(f)
select f, "This is a Preprocessor In Statement atom"
// //macro test
// from Macro e
// select e, e.getLocation().getStartLine(), "This is Macro"
