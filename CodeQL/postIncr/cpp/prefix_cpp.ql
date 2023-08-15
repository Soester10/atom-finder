/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

import cpp

from Expr e
where e.getAChild() instanceof PrefixIncrExpr or e.getAChild() instanceof PrefixDecrExpr
select e, "This is a Prefix atom"