/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp

 predicate instancy(Assignment e) {
    e.getLValue() instanceof Assignment or
    e.getLValue() instanceof NEExpr or
    // (e.getLValue() instanceof ArrayExpr and (arrayChecky(e.getLValue()))) or

    e.getRValue() instanceof Assignment or
    e.getRValue() instanceof NEExpr 
    // (e.getRValue() instanceof ArrayExpr and (arrayChecky(e.getRValue())))
 }

 predicate arrayChecky(ArrayExpr e){
    e.getArrayBase() instanceof PointerFieldAccess
 }


 predicate parenty(Assignment e) {
    e.getParent() instanceof NEExpr or
    // e.getParent() instanceof AssignExpr or
    e.getParent() instanceof WhileStmt or
    e.getParent() instanceof IfStmt
 }


 from Assignment e
 where not(e instanceof BlockAssignExpr) and (instancy(e) or parenty(e))
 select e, "This is an Assignment As Value atom"