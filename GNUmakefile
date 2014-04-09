#
# GNUmakefile
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

#
# Framework
#
VERSION = 0.1
PACKAGE_NAME = EM
FRAMEWORK_NAME = EM

#
# Resource files
#
EM_RESOURCE_FILES = \
Resources/Version \

#
# Header files
#
EM_HEADER_FILES = \
PXUndefinedValue.h \
PXObjectPushMethod.h \
PXInstructionCounter.h \
PXArrayJoinMethod.h \
PXExpressionNodeBuilder.h \
PXSquareRootFunction.h \
PXStringValue.h \
PXObjectKeysMethod.h \
pixate-expression-machine-mac-Prefix.pch \
PXExpressionLexemeType.h \
PXSinFunction.h \
PXExpressionInstructionType.h \
PXExpressionLexeme.h \
PXExpressionInstruction.h \
PXExpressionAssembler.h \
PXBlockValue.h \
PXExpressionNode.h \
PXObjectValueWrapper.h \
PXGenericNode.h \
PXArrayShiftMethod.h \
PXArrayValue.h \
PXExpressionUnit.h \
PXBooleanValue.h \
PXNullValue.h \
PXObjectConcatenateMethod.h \
PXArrayReverseMethod.h \
PXStringLengthMethod.h \
PXExpressionExports.h \
PXStringSubstringMethod.h \
Supporting \
PXSourceEmitter.h \
PXExpressionEnvironment.h \
PXLexeme.h \
PXMarkValue.h \
PXObjectConcatenateMethod.h \
PXObjectKeysMethod.h \
PXArrayReduceMethod.h \
PXSourceWriter.h \
PXObjectValue.h \
PXStringLengthMethod.h \
PXPowerFunction.h \
Supporting \
PXParserBase.h \
PXFunctionValueBase.h \
Supporting \
PXScopeBase.h \
pixate-expression-machine-Prefix.pch \
PXCosFunction.h \
pixate-expression-machine-Prefix.pch \
PXParser.h \
PXExpressionValueAssertions.h \
PXShowTopFunction.h \
PXExpressionByteCode.h \
PXScriptManager.h \
PXExpressionValueBase.h \
PXBlockNode.h \
PXDoubleProperty.h \
PXStringSubstringMethod.h \
PXByteCodeBuilder.h \
PXObjectReverseMethod.h \
PXArrayPushMethod.h \
PXArrayPopMethod.h \
PXPushValueInstruction.h \
PXObjectValuesMethod.h \
PXExpressionParser.h \
PXLogFunction.h \
PXArrayMapMethod.h \
PXExpressionScope.h \
PXObjectValuesMethod.h \
PXObjectUnshiftMethod.h \
PXExpressionNodeUtils.h \
PXScope.h \
PXObjectLengthMethod.h \
PXArrayLengthMethod.h \
PXBuiltInSource.h \
PXByteCodeOptimizer.h \
PXObjectUnshiftMethod.h \
PXExpressionNodeCompiler.h \
PXExpressionObject.h \
PXObjectForEachMethod.h \
PXArrayForEachMethod.h \
PXBuiltInScope.h \
PXByteCodeOptimizer.h \
PXParameter.h \
PXExpressionValue.h \
PXInstructionProcessor.h \
PXExpressionArray.h \
PXByteCodeFunction.h \
PXObjectPushMethod.h \
PXExpressionFunction.h \
PXInstructionDisassembler.h \
PXArrayUnshiftMethod.h \
PXDoubleValue.h \

#
# Class files
#
EM_OBJC_FILES = \
PXArrayShiftMethod.m \
PXExpressionEnvironment.m \
PXExpressionByteCode.m \
PXExpressionNodeCompiler.m \
PXInstructionDisassembler.m \
PXParameter.m \
PXArrayPushMethod.m \
PXArrayReverseMethod.m \
PXArrayJoinMethod.m \
PXByteCodeBuilder.m \
PXExpressionNodeBuilder.m \
PXSquareRootFunction.m \
PXFunctionValueBase.m \
PXObjectValuesMethod.m \
PXCosFunction.m \
PXShowTopFunction.m \
PXStringSubstringMethod.m \
PXObjectKeysMethod.m \
PXArrayValue.m \
PXExpressionValueBase.m \
PXLogFunction.m \
PXExpressionInstruction.m \
PXArrayLengthMethod.m \
PXParserBase.m \
PXExpressionUnit.m \
PXObjectForEachMethod.m \
PXUndefinedValue.m \
PXExpressionNodeUtils.m \
PXScope.m \
PXObjectLengthMethod.m \
PXExpressionAssembler.m \
PXBuiltInSource.m \
PXSinFunction.m \
PXScopeBase.m \
PXDoubleProperty.m \
PXBuiltInScope.m \
PXExpressionLexeme.m \
PXMarkValue.m \
PXArrayMapMethod.m \
PXByteCodeFunction.m \
PXStringValue.m \
PXExpressionParser.m \
PXObjectValueWrapper.m \
PXNullValue.m \
PXArrayForEachMethod.m \
PXObjectConcatenateMethod.m \
PXArrayPopMethod.m \
PXBlockValue.m \
PXObjectPushMethod.m \
PXBlockNode.m \
PXArrayUnshiftMethod.m \
PXObjectUnshiftMethod.m \
PXObjectReverseMethod.m \
PXByteCodeOptimizer.m \
PXInstructionProcessor.m \
PXDoubleValue.m \
PXObjectValue.m \
PXPushValueInstruction.m \
PXBooleanValue.m \
PXInstructionCounter.m \
PXScriptManager.m \
PXStringLengthMethod.m \
PXSourceWriter.m \
PXGenericNode.m \
PXArrayReduceMethod.m \
PXPowerFunction.m \

#
# Makefiles
#
-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/framework.make
-include GNUmakefile.postamble
