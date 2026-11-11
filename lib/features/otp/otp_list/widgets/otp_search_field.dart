import 'package:app_core/features/otp/l10n/otp_localizations.dart';
import 'package:flutter/material.dart';

/// Search bar that renders [query] and reports edits through [onChanged].
///
/// The query is owned by the presenter state; this widget only keeps the
/// [TextEditingController] the text input needs and syncs it to [query].
class OtpSearchField extends StatefulWidget {
  const OtpSearchField({required this.query, required this.onChanged, super.key});

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<OtpSearchField> createState() => _OtpSearchFieldState();
}

class _OtpSearchFieldState extends State<OtpSearchField> {
  late final TextEditingController _controller = TextEditingController(text: widget.query);

  @override
  void didUpdateWidget(OtpSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SearchBar(
        controller: _controller,
        onChanged: widget.onChanged,
        hintText: context.l10n.searchHint,
        textInputAction: TextInputAction.search,
        elevation: const WidgetStatePropertyAll(0),
        leading: const Icon(Icons.search),
        trailing: [
          if (widget.query.isNotEmpty)
            IconButton(
              onPressed: () => widget.onChanged(''),
              icon: const Icon(Icons.clear),
              tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
            ),
        ],
      ),
    );
  }
}
