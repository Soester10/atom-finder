/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp





 predicate instancy(Conversion e) {
    e.isImplicit()
   //  and not(e instanceof CStyleCast)
    // and not(inMacroExpansion(e))
    and not(e.isAffectedByMacro())
    and (e.getActualType() instanceof ArithmeticType)
 }


 from Conversion e
 where instancy(e)
 select e, "This is a Type Conversion atom"