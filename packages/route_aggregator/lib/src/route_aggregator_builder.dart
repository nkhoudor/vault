import 'package:build/build.dart';
import 'package:route_aggregator/src/route_aggregator_generator.dart';

const String defaultOutputPath = 'lib/app/presentation/routes/app_routes.dart';

Builder routeAggregatorBuilder(BuilderOptions options) {
  final config = RouteAggregatorBuilderConfig.fromOptions(options);
  return _RouteAggregatorBuilder(config);
}

class RouteAggregatorBuilderConfig {
  const RouteAggregatorBuilderConfig({
    required this.routeAnnotationUrl,
    required this.screenGlobPattern,
    required this.outputPath,
  });

  factory RouteAggregatorBuilderConfig.fromOptions(BuilderOptions options) {
    final config = options.config;

    String valueOrDefault(String key, String fallback) {
      final value = config[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      return fallback;
    }

    return RouteAggregatorBuilderConfig(
      routeAnnotationUrl: valueOrDefault('route_annotation_url', defaultRouteAnnotationUrl),
      screenGlobPattern: valueOrDefault('screen_glob', defaultScreenGlobPattern),
      outputPath: valueOrDefault('output_path', defaultOutputPath),
    );
  }

  final String routeAnnotationUrl;
  final String screenGlobPattern;
  final String outputPath;
}

class _RouteAggregatorBuilder implements Builder {
  _RouteAggregatorBuilder(this.config);

  final RouteAggregatorBuilderConfig config;

  @override
  Map<String, List<String>> get buildExtensions => {
    r'$lib$': [config.outputPath.replaceFirst('lib/', '')],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Only trigger on a synthetic input
    if (buildStep.inputId.path != r'lib/$lib$') {
      return;
    }

    final generator = RouteAggregator(
      routeAnnotationUrl: config.routeAnnotationUrl,
      screenGlobPattern: config.screenGlobPattern,
    );

    final output = await generator.generate(buildStep);
    if (output == null || output.isEmpty) {
      return;
    }

    final outputId = AssetId(buildStep.inputId.package, config.outputPath);
    await buildStep.writeAsString(outputId, output);
  }
}
