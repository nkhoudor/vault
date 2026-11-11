import 'package:mason/mason.dart';
import 'package:template_utils/template_utils.dart';

Future<void> run(HookContext context) async {
  final appPackage = context.vars["app_package"] as String;
  final importPath = context.vars["import_path"] as String;
  final presenterName = context.vars["presenter_name"] as String;
  final stateName = context.vars["state_name"] as String;
  final stateFileName = context.vars["state_file_name"] as String;
  final presenterFileName = context.vars["presenter_file_name"] as String;
  final rootDir = context.vars["root_dir"] as String;
  final feature = context.vars["feature"] as String;

  await _replaceInFeatureComponent(
    context: context,
    appPackage: appPackage,
    importPath: importPath,
    stateName: stateName,
    stateFileName: stateFileName,
    presenterName: presenterName,
    presenterFileName: presenterFileName,
    rootDir: rootDir,
    feature: feature,
  );
}

Future<void> _replaceInFeatureComponent({
  required HookContext context,
  required String appPackage,
  required String importPath,
  required String stateName,
  required String stateFileName,
  required String presenterName,
  required String presenterFileName,
  required String rootDir,
  required String feature,
}) async {
  final filePath = featureComponentFilePath(feature: feature, rootDir: rootDir);
  await replaceAllInFileLineByLine(
    filePath: filePath,
    replacements: [
      StringReplacement.prepend(
        before: "//DO-NOT-REMOVE FEATURE_COMPONENT_IMPORTS",
        text:
            """
${templateImport("$appPackage/$importPath/$presenterFileName")}
${templateImport("$appPackage/$importPath/$stateFileName")}""",
      ),
      StringReplacement.prepend(
        before: "//DO-NOT-REMOVE MVP_GET_IT_CONFIG",
        text:
            """
${templateRegisterFactoryParam(implementationName: stateName, interfaceName: stateName, params: ["params"], param1TypeName: "${stateName}Params?", param1varName: "params", constructorName: "fromInitialParams", useConst: false)}
${templateRegisterFactoryParam(implementationName: presenterName, params: ["appComponent.get(param1: params)", "appComponent.get()", "appComponent.get()"], param1TypeName: "${stateName}Params?", param1varName: "params", useConst: false)}""",
      ),
    ],
  );
  await sortPackageImports(filePath);
}
