/**
 * @name Empty scope
 * @kind problem
 * @problem.severity warning
 * @id python/example/empty-scope
 */

 import cpp


predicate instancy(Operation e) {
  (checkInSensitiveCombinations(e) or checkSensitiveCombinations(e)) //and
  // checkSensitiveCombinations(e) //and
  // instancyOperand(e)
 }


 predicate checkInSensitiveCombinations(Operation e) {
    (binaryCheck2(e)) or
    // (binaryCheck(e) and binaryCheck(e.getAnOperand()) and not(checkAddSub(e)) and not(checkSameOperand(e)))
    // [:bitwise_not :arith_unary] 
    (checkBitUnary(e, e.getAnOperand(), false) or checkBitUnary(e.getAnOperand(), e, true)) or
    // ((e instanceof UnaryBitwiseOperation and checkArithUnary(e.getAnOperand())) or (checkArithUnary(e) and e.getAnOperand() instanceof UnaryBitwiseOperation)) or
    // [:bitwise_not :not] 
    (checkBitUnaryLogic(e, e.getAnOperand(), false) or checkBitUnaryLogic(e.getAnOperand(), e, true)) or
    // ((e instanceof UnaryBitwiseOperation and e.getAnOperand() instanceof UnaryLogicalOperation) or (e instanceof UnaryLogicalOperation and e.getAnOperand() instanceof UnaryBitwiseOperation)) or
    // [:bitwise_not :pointer]
    (checkBitUnaryPointer(e, e.getAnOperand(), true) or checkBitUnaryPointer(e, e.getAnOperand(), true)) or
    // ((e instanceof UnaryBitwiseOperation and checkPointer(e.getAnOperand())) or (checkPointer(e) and e.getAnOperand() instanceof UnaryBitwiseOperation)) or
    // [:bitwise_bin :compare] [:bitwise_bin :pointer]
    (checkBitBinaryPointer(e) or checkBitBinaryCompare(e) or checkPointerBitBinary(e)) //or
    // ((e instanceof BinaryBitwiseOperation and checkPointerCompare(e.getAnOperand())) or (checkPointerCompare(e) and e.getAnOperand() instanceof BinaryBitwiseOperation))

    // [:compare :and] [:compare :or] [:compare :compare]
    // checkCompares(e, e.getAnOperand()) or checkCompares(e.getAnOperand(), e)
 }

 predicate checkSensitiveCombinations(Operation e) {
  // [:pointer :de_incr]
  (checkPointerIncr(e, e.getAnOperand())) or
  // (checkPointer(e) and e.getAnOperand() instanceof CrementOperation) or
  //  [:arith_unary :add] [:arith_unary :multiply] [:arith_unary :and] [:arith_unary :or] [:arith_unary :cond] [:arith_unary :non-asso] [:arith_unary :bitwise_bin]
  (checkArithBin1(e) or checkArithBin2(e)) or
  // (checkArithUnaryInsesCompanion(e) and checkArithUnary(e.getAnOperand())) or
  // [:not :add] [:not :multiply] [:not :and] [:not :or] [:not :compare] [:not :cond] [:not :non-asso] [:not :bitwise_bin]
  checkNotBin1(e) or checkNotBin2(e) or checkNotBin3(e) or
  // (e.getAnOperand() instanceof UnaryLogicalOperation and checkLogicUnaryInsesCompanion(e)) or
  // [:pointer :add]
  checkPointerAdd(e) or
  // (checkPointer(e.getAnOperand()) and e instanceof AddExpr) or
  // [:and :cond] [:or :cond] [:not :cond] [:compare :cond] [:bitwise_not :cond] [:bitwise_bin :cond]
  checkBinCond(e) or
  // (checkCondInsesCompanion(e.getAnOperand()) and e instanceof ConditionalExpr) or
  // [:bitwise_not :add] [:bitwise_not :multiply] [:bitwise_not :or] [:bitwise_not :cond] [:bitwise_not :compare] [:bitwise_not :non-asso] [:bitwise_not :de_incr] [:bitwise_not :bitwise_bin]
  checkBitNotBin(e) or checkBitNotBin2(e) or checkBitNotBin3(e) or
  // (e.getAnOperand() instanceof UnaryBitwiseOperation and checkBitNotInsesCompanion(e)) or
  // pointer/addr -> PointerFieldAccess, pointer/addr -> valuefield->arrayexpr->pointerfield,
  // pointer/addr -> valuefield->pointerfield, pointer/addr -> arrayexpr->pointerfield,
  // pointer/addr -> valuefield
  checkPointerFieldRef(e, e.getAnOperand()) or checkPointerFieldRef2(e, e.getAnOperand()) 
  or checkPointerFieldRef3(e, e.getAnOperand()) or checkPointerFieldRef4(e, e.getAnOperand())
  or checkPointerFieldRef5(e, e.getAnOperand())
  // (checkPointer(e) and e.getAnOperand() instanceof PointerFieldAccess)
 }











 predicate checkCompares(ComparisonOperation e, Operation a) {
  (a instanceof BinaryLogicalOperation or 
  a instanceof ComparisonOperation)
  and
  instancyOperand2(a)
 }





 predicate checkPointerFieldRef5(Operation e, ValueFieldAccess a) {
  checkPointer(e) and
  not((a.getFullyConverted() instanceof ParenthesisExpr) or
  (a.getFullyConverted() instanceof CStyleCast and cstyleExpr(a.getFullyConverted())))
 //  and not(a.isAffectedByMacro())
//  and not(a.isInMacroExpansion())
    and not(inMacroExpansion(a))

  // and (e.getEnclosingFunction().getParameterString().matches(e.toString()) or not(inMacroExpansion(a)))
  // and not(inSystemMacroExpansion(a))
 }





 predicate checkPointerFieldRef4(Operation e, ArrayExpr a) {
  checkPointer(e) and a.getArrayBase() instanceof PointerFieldAccess and
  not((a.getFullyConverted() instanceof ParenthesisExpr) or
  (a.getFullyConverted() instanceof CStyleCast and cstyleExpr(a.getFullyConverted())))
 //  and not(a.isAffectedByMacro())
//  and not(a.isInMacroExpansion())
    and not(inMacroExpansion(a))

    // and (e.getEnclosingFunction().getParameterString().matches(e.toString()) or not(inMacroExpansion(a)))
// and not(inSystemMacroExpansion(a))
 }



 predicate checkPointerFieldRef2(Operation e, ValueFieldAccess a) {
  checkPointer(e) and checkPointerFieldRef4(e, a.getQualifier())
 }




 predicate checkPointerFieldRef3(Operation e, ValueFieldAccess a) {
  checkPointer(e) and a.getQualifier() instanceof PointerFieldAccess and
  not((a.getFullyConverted() instanceof ParenthesisExpr) or
  (a.getFullyConverted() instanceof CStyleCast and cstyleExpr(a.getFullyConverted())))
 //  and not(a.isAffectedByMacro())
//  and not(a.isInMacroExpansion())
    and not(inMacroExpansion(a))

    // and (e.getEnclosingFunction().getParameterString().matches(e.toString()) or not(inMacroExpansion(a)))
// and not(inSystemMacroExpansion(a))
 }



 predicate checkPointerFieldRef(Operation e, PointerFieldAccess a) {
  checkPointer(e) and
  not((a.getFullyConverted() instanceof ParenthesisExpr) or
  (a.getFullyConverted() instanceof CStyleCast and cstyleExpr(a.getFullyConverted())))
 //  and not(a.isAffectedByMacro())
//  and not(a.isInMacroExpansion())
    and not(inMacroExpansion(a))

    // and (e.getEnclosingFunction().getParameterString().matches(e.toString()) or not(inMacroExpansion(a)))
// and not(inSystemMacroExpansion(a))
 }





 predicate checkBitNotBin(BinaryOperation e) {
  checkBitNotInsesCompanion(e) and e.getLeftOperand() instanceof UnaryBitwiseOperation and instancyOperand2(e.getLeftOperand()) 
 }


 predicate checkBitNotBin2(ConditionalExpr e) {
  e.getCondition() instanceof UnaryBitwiseOperation and instancyOperand2(e.getCondition())  
 }


 predicate checkBitNotBin3(CrementOperation e) {
  e.getAnOperand() instanceof UnaryBitwiseOperation and instancyOperand2(e.getAnOperand())   
 }







 predicate checkBinCond(ConditionalExpr e) {
  checkCondInsesCompanion(e.getCondition()) and instancyOperand2(e.getCondition())
  
 }



 predicate checkPointerAdd(AddExpr e) {
  checkPointer(e.getLeftOperand()) and instancyOperand2(e.getLeftOperand())  
 }




 predicate checkNotBin1(BinaryOperation e) {
  binaryCheck(e) and e.getLeftOperand() instanceof UnaryLogicalOperation and instancyOperand2(e.getLeftOperand())
  // checkLogicUnaryInsesCompanion(e) and instancyOperand2(a)
 }


 predicate checkNotBin2(ConditionalExpr e) {
  e.getCondition() instanceof UnaryLogicalOperation and instancyOperand2(e.getCondition())
 }


 predicate checkNotBin3(ComparisonOperation e) {
  e.getLeftOperand() instanceof UnaryLogicalOperation and instancyOperand2(e.getLeftOperand())  
 }





 predicate checkArithBin1(BinaryOperation e) {
  binaryCheck(e) and checkArithUnary(e.getLeftOperand()) and instancyOperand2(e.getLeftOperand())
  // checkArithUnaryInsesCompanion(e) and checkArithUnary(a) and instancyOperand2(a)
 }


 predicate checkArithBin2(ConditionalExpr e) {
  checkArithUnary(e.getCondition()) and instancyOperand2(e.getCondition())
  // checkArithUnaryInsesCompanion(e) and checkArithUnary(a) and instancyOperand2(a)
 }





 predicate checkPointerIncr(Operation e, CrementOperation a) {
  checkPointer(e) and instancyOperand2(a)
 }




predicate checkBitUnaryLogic(Operation e, Operation a, boolean s) {
  (s=false and e instanceof UnaryBitwiseOperation and checkUnaryLogic(a, true))
  or (s=true and e instanceof UnaryBitwiseOperation and instancyOperand2(e) and checkUnaryLogic(a, false))
  
}



predicate checkBitUnaryPointer(Operation e, Operation a, boolean s) {
  (s=false and e instanceof UnaryBitwiseOperation and checkPointer_c(a))
  or (s=true and e instanceof UnaryBitwiseOperation and instancyOperand2(e) and checkPointer(a))
  
}





predicate checkBitBinaryPointer(BinaryBitwiseOperation e) {
  (e.getLeftOperand() instanceof ComparisonOperation and instancyOperand2(e.getLeftOperand()))
  or (e.getRightOperand() instanceof ComparisonOperation and instancyOperand2(e.getRightOperand()))

  or

  (checkPointer(e.getLeftOperand()) and instancyOperand2(e.getLeftOperand()))
  or (checkPointer(e.getRightOperand())and instancyOperand2(e.getRightOperand()))  
}



predicate checkBitBinaryCompare(ComparisonOperation e) {
  (e.getLeftOperand() instanceof BinaryBitwiseOperation and instancyOperand2(e.getLeftOperand()))
  or (e.getRightOperand() instanceof BinaryBitwiseOperation and instancyOperand2(e.getRightOperand()))  
}



predicate checkPointerBitBinary(Operation e) {
  checkPointer(e) and  checkBitBinary(e.getAnOperand())
}



predicate checkBitBinary(BinaryBitwiseOperation e) {
  instancyOperand2(e)
}



 predicate checkBitUnary(Operation e, Operation a, boolean s) {
  (s=false and e instanceof UnaryBitwiseOperation and checkArithUnary_c(a))
  or (s=true and e instanceof UnaryBitwiseOperation and instancyOperand2(e) and checkArithUnary(a))
 }



 predicate checkUnaryLogic(UnaryOperation e, boolean s) {
  (s=true and e instanceof UnaryLogicalOperation and instancyOperand2(e)) or
  (s=false and e instanceof UnaryLogicalOperation)
 }



 predicate checkBitNotInsesCompanion(BinaryOperation e) {
  binaryCheck(e) or
  // e instanceof ConditionalExpr or
  e instanceof ComparisonOperation
  // e instanceof CrementOperation
 }


 predicate checkCondInsesCompanion(Operation e) {
  e instanceof BinaryLogicalOperation or
  e instanceof UnaryLogicalOperation or
  e instanceof ComparisonOperation or
  e instanceof BinaryBitwiseOperation or
  e instanceof UnaryBitwiseOperation
 }


 predicate checkLogicUnaryInsesCompanion(Operation e) {
  binaryCheck(e) or
  e instanceof ConditionalExpr or
  e instanceof ComparisonOperation
 }



 predicate checkArithUnaryInsesCompanion(Operation e) {
  binaryCheck(e) //or
  // e instanceof ConditionalExpr
 }


 predicate checkPointerCompare(Operation e) {
  checkPointer(e) or e instanceof ComparisonOperation
 }


 predicate checkPointer(UnaryOperation e) {
  e instanceof AddressOfExpr or
  e instanceof PointerDereferenceExpr  
 }




 predicate checkPointer_c(UnaryOperation e) {
  (e instanceof AddressOfExpr or
  e instanceof PointerDereferenceExpr)
  and instancyOperand2(e)
 }




 predicate checkArithUnary_c(UnaryArithmeticOperation e) {
  (e instanceof UnaryMinusExpr or e instanceof UnaryPlusExpr)
  and instancyOperand2(e)
}

predicate checkArithUnary(UnaryArithmeticOperation e) {
  (e instanceof UnaryMinusExpr or e instanceof UnaryPlusExpr)
}

predicate binaryCheck(BinaryOperation e) {
  (e instanceof BinaryArithmeticOperation or
  e instanceof BinaryBitwiseOperation or
  e instanceof BinaryLogicalOperation)
  // and 
  // ((binaryCheckOperand(e.getLeftOperand()) and checkAddSub2(e, e.getLeftOperand()) and checkSameOperand2(e, e.getLeftOperand())) or
  // (binaryCheckOperand(e.getRightOperand()) and checkAddSub2(e, e.getRightOperand()) and checkSameOperand2(e, e.getRightOperand())))
}




predicate binaryCheck2(BinaryOperation e) {
  (e instanceof BinaryArithmeticOperation or
  e instanceof BinaryBitwiseOperation or
  e instanceof BinaryLogicalOperation)
  and 
  ((binaryCheckOperand(e.getLeftOperand()) and checkAddSub2(e, e.getLeftOperand()) and checkSameOperand2(e, e.getLeftOperand())) or
  (binaryCheckOperand(e.getRightOperand()) and checkAddSub2(e, e.getRightOperand()) and checkSameOperand2(e, e.getRightOperand())))
}




predicate checkSameOperand2(BinaryOperation e, BinaryOperation a) {
  (e instanceof DivExpr and a instanceof DivExpr) or
  // (e instanceof DivExpr and a instanceof RemExpr) or
  (e instanceof RemExpr and a instanceof RemExpr) or
  // (e instanceof RemExpr and a instanceof DivExpr) or
  not(a.toString() = e.toString())
}



predicate checkAddSub2(BinaryOperation e, BinaryOperation a) {
  not((e instanceof AddExpr and a instanceof SubExpr or (e instanceof SubExpr and a instanceof AddExpr)))  
}



predicate binaryCheckOperand(BinaryOperation e) {
 (e instanceof BinaryArithmeticOperation or
  e instanceof BinaryBitwiseOperation or
  e instanceof BinaryLogicalOperation) and
  instancyOperand2(e)
}




predicate instancyOperand2(Operation e) {
  not((e.getFullyConverted() instanceof ParenthesisExpr) or
  (e.getFullyConverted() instanceof CStyleCast and cstyleExpr(e.getFullyConverted())))
 //  and not(e.isAffectedByMacro())
//  and not(e.isInMacroExpansion())
// and not(inSystemMacroExpansion(e))
//  and not(inMacroExpansion(e))

    and not(inMacroExpansion(e))



    //test
    // and (e.getEnclosingFunction().getParameterString().matches(e.toString()) or not(inMacroExpansion(e)))
}



 predicate instancyOperand(Operation e) {
   not((e.getAnOperand().getFullyConverted() instanceof ParenthesisExpr) or
   (e.getAnOperand().getFullyConverted() instanceof CStyleCast and cstyleExpr(e.getAnOperand().getFullyConverted())))
  //  and not(e.isAffectedByMacro())
  and not(e.isInMacroExpansion())
 }


 predicate cstyleExpr(CStyleCast e) {
   e.getExpr() instanceof ParenthesisExpr
 }


 predicate checkSameOperand(Operation e) {
   e.getAnOperand().toString() = e.toString()
 }



 predicate checkAddSub(BinaryArithmeticOperation e) {
   (e instanceof SubExpr or e instanceof AddExpr or e instanceof PointerArithmeticOperation) and
   (e.getLeftOperand() instanceof SubExpr or e.getLeftOperand() instanceof AddExpr or e.getLeftOperand() instanceof PointerArithmeticOperation or
   e.getRightOperand() instanceof SubExpr or e.getRightOperand() instanceof AddExpr or e.getRightOperand() instanceof PointerArithmeticOperation)
 }



 predicate checkPointerAddSub(BinaryArithmeticOperation e) {
   (e instanceof PointerSubExpr or e instanceof PointerAddExpr or e instanceof PointerDiffExpr)
 }

 
 
 predicate testy_unary(UnaryOperation e) {
    e instanceof CrementOperation or instancy(e.getOperand())
 }
 
 
 predicate testy(BinaryOperation e) {
   instancy(e.getLeftOperand()) or instancy(e.getRightOperand())
 }
 
 
 from Operation e
 where instancy(e)
 select e, "This is an Operator Precedence atom"