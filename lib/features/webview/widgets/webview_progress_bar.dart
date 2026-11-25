import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/webview_cubit.dart';
import '../cubit/webview_state.dart';

/// Thin non-blocking top progress bar for seamless in-app navigation.
class WebviewProgressBar extends StatefulWidget {
  const WebviewProgressBar({super.key});

  @override
  State<WebviewProgressBar> createState() => _WebviewProgressBarState();
}

class _WebviewProgressBarState extends State<WebviewProgressBar> {
  bool _initialLoadFinished = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebViewCubit, WebViewState>(
      buildWhen: (p, c) =>
          p.isPageLoading != c.isPageLoading ||
          p.progress != c.progress ||
          p.hasCompletedInitialLoad != c.hasCompletedInitialLoad,
      builder: (_, s) {
        if (!_initialLoadFinished &&
            s.hasCompletedInitialLoad &&
            !s.isPageLoading) {
          _initialLoadFinished = true;
        }

        final show =
            _initialLoadFinished && s.isPageLoading && s.progress < 0.75;

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            ignoring: true,
            child: show
                ? LinearProgressIndicator(
                    value: s.progress,
                    minHeight: 2.8,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF8B725A)),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
