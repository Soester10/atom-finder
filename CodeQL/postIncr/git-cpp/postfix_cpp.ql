/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

import cpp

from Expr e
where e.getAChild() instanceof PostfixIncrExpr or e.getAChild() instanceof PostfixDecrExpr
select e, "This is a Postfix atom"