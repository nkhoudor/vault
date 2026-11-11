# Entry point for the everyday commands. Run `make` to list them.
# CI runs the same targets, so a green `make check` locally means a green pull request.

# Use the Flutter version pinned in .fvmrc when fvm is installed (local machines),
# and the Flutter on PATH otherwise (CI installs the pinned version directly).
FVM := $(shell command -v fvm >/dev/null 2>&1 && echo fvm)
FLUTTER := $(FVM) flutter
DART := $(FVM) dart
SCRIPT_FLAGS := $(if $(FVM),--useFvm)

.DEFAULT_GOAL := help
.PHONY: help setup deps gen l10n icons format format-check analyze test goldens check certificates beta

help: ## List the available commands
	@awk 'BEGIN {FS = ":.*## "} /^[a-z0-9-]+:.*## / {printf "  make %-14s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Full setup after cloning: clean, dependencies, code generation, pods, icons, splash, format
	./scripts/get_all.sh $(SCRIPT_FLAGS)

deps: ## Download dependencies
	$(FLUTTER) pub get

gen: ## Generate freezed, json and route code into lib/generated/
	$(DART) run build_runner build --delete-conflicting-outputs
	@# The route file is committed and build_runner writes it unformatted.
	@./scripts/code_format.sh $(SCRIPT_FLAGS) > /dev/null

l10n: ## Regenerate localization classes from the .arb files
	./scripts/generate_localizations.sh

icons: ## Regenerate the AppImages class from assets/icons and assets/images
	./scripts/generate_icons.sh $(SCRIPT_FLAGS)

format: ## Format the app code
	./scripts/code_format.sh $(SCRIPT_FLAGS)

format-check: ## Fail if the app code is not formatted (changes nothing)
	./scripts/check_format.sh $(SCRIPT_FLAGS)

analyze: ## Run the static analyzer
	$(FLUTTER) analyze

test: ## Run unit and widget tests (golden tests excluded, as in CI)
	$(FLUTTER) test --exclude-tags golden

goldens: ## Regenerate the golden images
	./scripts/update_goldens.sh

check: format-check gen analyze test ## Everything CI checks on a pull request

certificates: ## Install the development certificate and profile on this Mac (needs MATCH_PASSWORD)
	cd ios && bundle exec fastlane certificates

beta: ## Build and upload to TestFlight (needs the signing secrets, see README)
	cd ios && bundle exec fastlane beta
