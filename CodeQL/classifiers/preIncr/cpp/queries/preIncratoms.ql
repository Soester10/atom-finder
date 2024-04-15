/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

import cpp

from PrefixCrementOperation e
where
  not inMacroExpansion(e) and
  ((not e instanceof ExprInVoidContext) or 
    // e.getControlFlowScope() instanceof WhileStmt)
    e.getParent() instanceof WhileStmt)
select e, "This is a Prefix atom"
