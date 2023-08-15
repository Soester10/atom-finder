/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp

 predicate instancy(AssignExpr e) {
    e.getLValue() instanceof AssignExpr or
    e.getLValue() instanceof NEExpr or
    // e.getLValue() instanceof PointerFieldAccess or

    e.getRValue() instanceof AssignExpr or
    e.getRValue() instanceof NEExpr
    // e.getRValue() instanceof PointerFieldAccess
 }


 predicate parenty(AssignExpr e) {
    e.getParent() instanceof NEExpr or
    e.getParent() instanceof AssignExpr or
    e.getParent() instanceof WhileStmt or
    e.getParent() instanceof IfStmt
 }


 from AssignExpr e
 where instancy(e) or parenty(e)
 select e, "This is an Assignment As Value atom"