import "package:mason/mason.dart";
import "package:template_utils/template_utils.dart";

Future<void> run(HookContext context) async {
  final rootDir = projectRootDir(context.vars["root_folder_path"]);
  var widgetName = (context.vars["widget_name"] as String? ?? "").trim().pascalCase;
  final featureName = (context.vars["feature_name"] as String? ?? "").trim().snakeCase;
  var subdirectory = (context.vars["subdirectory"] as String? ?? "").trim();

  if (widgetName.isEmpty) {
    throw "Cannot use empty name for widget_name";
  }
  if (featureName.isEmpty) {
    throw "Cannot use empty name for feature_name";
  }

  final stem = widgetName.replaceAll(RegExp(r"Widget$"), "");
  final featurePath =
      "features/${featureName}/${subdirectory}" //
          .replaceAll(RegExp("/+"), "/")
          .replaceAll(RegExp("/\$"), "");
  final featureL10nPath = "features/${featureName}/l10n";
  final featureTestPath =
      "features/${featureName}" //
          .replaceAll(RegExp("/+"), "/")
          .replaceAll(RegExp("/\$"), "");

  widgetName = "${stem}Widget";

  final presenterName = "${stem}Presenter";
  final widgetParamsName = "${stem}WidgetParams";
  final stateName = "${stem}State";
  final navigatorName = "${stem}Navigator";
  final repositoryName = "${stem}Repository";

  final widgetFileName = "${stem.snakeCase}_widget.dart";
  final widgetTestFileName = "${stem.snakeCase}_widget_test.dart";
  final presenterFileName = "${stem.snakeCase}_presenter.dart";
  final presenterTestFileName = "${stem.snakeCase}_presenter_test.dart";
  final stateFileName = "${stem.snakeCase}_state.dart";
  final stateFreezedFileName = "${stem.snakeCase}_state.freezed.dart";
  final widgetParamsFileName = "${stem.snakeCase}_widget_params.dart";
  final widgetParamsFreezedFileName = "${stem.snakeCase}_widget_params.freezed.dart";
  final navigatorFileName = "${stem.snakeCase}_navigator.dart";
  final repositoryFileName = "${stem.snakeCase}_repository.dart";
  final relativeRoot = relativeRootDir(rootDir);
  final relativeLibFeaturePath = "$relativeRoot/lib/${featurePath}";
  final relativeL10nFeaturePath = "$relativeRoot/lib/${featureL10nPath}";
  final relativeTestFeaturePath = "$relativeRoot/test/${featureTestPath}";
  final relativeGeneratedFeaturePath = "../../../generated/${featurePath}";
  final appPackage = await getAppPackage(rootDir);

  await ensureFeaturesFiles(appPackage: appPackage, featureName: featureName, rootDir: rootDir);

  final presenterImports = [
    "$appPackage/$featurePath/$navigatorFileName",
    "$appPackage/$featurePath/$stateFileName",
    "$appPackage/$featurePath/domain/repository/$repositoryFileName",
    "flutter_bloc/flutter_bloc.dart",
  ]..sort();

  context.vars = {
    ...context.vars,
    ...context.vars,
    "app_package": await getAppPackage(rootDir),
    "import_path": "${featurePath}",
    "presenter_imports": presenterImports.map(templateImport).join("\n"),
    "stem": stem,
    //class names
    "widget_name": widgetName,
    "presenter_name": presenterName,
    "state_name": stateName,
    "widget_params_name": widgetParamsName,
    "navigator_name": navigatorName,
    "repository_name": repositoryName,
    //file names
    "widget_file_name": widgetFileName,
    "presenter_file_name": presenterFileName,
    "widget_params_file_name": widgetParamsFileName,
    "state_file_name": stateFileName,
    "state_freezed_file_name": stateFreezedFileName,
    "widget_params_freezed_file_name": widgetParamsFreezedFileName,
    "navigator_file_name": navigatorFileName,
    "repository_file_name": repositoryFileName,
    // absolute paths
    "widget_absolute_path": "$relativeLibFeaturePath/$widgetFileName",
    "presenter_absolute_path": "$relativeLibFeaturePath/$presenterFileName",
    "state_absolute_path": "$relativeLibFeaturePath/$stateFileName",
    "navigator_absolute_path": "$relativeLibFeaturePath/$navigatorFileName",
    "repository_absolute_path": "$relativeLibFeaturePath/domain/repository/$repositoryFileName",
    "widget_params_absolute_path": "$relativeLibFeaturePath/$widgetParamsFileName",
    "widget_test_absolute_path": "$relativeTestFeaturePath/widgets/$widgetTestFileName",
    "presenter_test_absolute_path": "$relativeTestFeaturePath/presenters/$presenterTestFileName",
    "relative_generated_feature_path": "$relativeGeneratedFeaturePath",
    "feature": featureName,
    "root_dir": rootDir,
    "en_arb_absolute_path": "$relativeL10nFeaturePath/en.arb",
  };
  context.logger.info(
    "Generating widget, variables: ${context.vars.entries.map((it) => "${it.key} -> ${it.value}").join("\n")}",
  );
}
