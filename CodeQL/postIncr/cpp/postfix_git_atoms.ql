/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

import cpp

from PostfixCrementOperation e
where not(e instanceof ExprInVoidContext) or e.getParent() instanceof WhileStmt
select e, "This is a Postfix atom"