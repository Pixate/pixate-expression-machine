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
EM_HEADER_FILES_DIR = Headers

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
PXPropertyTestClass.h \
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
PXEasing.h \
PXParserBase.h \
PXFunctionValueBase.h \
PXSquareFunction.h \
PXScopeBase.h \
PXCosFunction.h \
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
Classes/PXArrayShiftMethod.m \
Classes/PXExpressionEnvironment.m \
Classes/PXExpressionByteCode.m \
Classes/PXExpressionNodeCompiler.m \
Classes/PXInstructionDisassembler.m \
Classes/PXParameter.m \
Classes/PXArrayPushMethod.m \
Classes/PXArrayReverseMethod.m \
Classes/PXArrayJoinMethod.m \
Classes/PXByteCodeBuilder.m \
Classes/PXExpressionNodeBuilder.m \
Classes/PXSquareRootFunction.m \
Classes/PXFunctionValueBase.m \
Classes/PXObjectValuesMethod.m \
Classes/PXCosFunction.m \
Classes/PXShowTopFunction.m \
Classes/PXStringSubstringMethod.m \
Classes/PXObjectKeysMethod.m \
Classes/PXArrayValue.m \
Classes/PXExpressionValueBase.m \
Classes/PXLogFunction.m \
Classes/PXExpressionInstruction.m \
Classes/PXArrayLengthMethod.m \
Classes/PXParserBase.m \
Classes/PXExpressionUnit.m \
Classes/PXObjectForEachMethod.m \
Classes/PXUndefinedValue.m \
Classes/PXExpressionNodeUtils.m \
Classes/PXScope.m \
Classes/PXObjectLengthMethod.m \
Classes/PXExpressionAssembler.m \
Classes/PXBuiltInSource.m \
Classes/PXSinFunction.m \
Classes/PXScopeBase.m \
Classes/PXDoubleProperty.m \
Classes/PXBuiltInScope.m \
Classes/PXExpressionLexeme.m \
Classes/PXMarkValue.m \
Classes/PXArrayMapMethod.m \
Classes/PXByteCodeFunction.m \
Classes/PXStringValue.m \
Classes/PXExpressionParser.m \
Classes/PXObjectValueWrapper.m \
Classes/PXNullValue.m \
Classes/PXArrayForEachMethod.m \
Classes/PXObjectConcatenateMethod.m \
Classes/PXArrayPopMethod.m \
Classes/PXBlockValue.m \
Classes/PXObjectPushMethod.m \
Classes/PXBlockNode.m \
Classes/PXArrayUnshiftMethod.m \
Classes/PXObjectUnshiftMethod.m \
Classes/PXObjectReverseMethod.m \
Classes/PXByteCodeOptimizer.m \
Classes/PXInstructionProcessor.m \
Classes/PXDoubleValue.m \
Classes/PXObjectValue.m \
Classes/PXPushValueInstruction.m \
Classes/PXBooleanValue.m \
Classes/PXScriptManager.m \
Classes/PXStringLengthMethod.m \
Classes/PXSourceWriter.m \
Classes/PXGenericNode.m \
Classes/PXArrayReduceMethod.m \
Classes/PXPowerFunction.m \
Classes/PXExpressionLexer.yy.m \

#
# Makefiles
#
-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/framework.make
-include GNUmakefile.postamble
