import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/app_fader_effect.dart';
import '../widgets/bnb.dart';

class FinalView extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const FinalView({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<FinalView> createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  late final ScrollController _scrollController;
  double _scrollOffset = 0.0;
  bool _atBottom = false;
  final bool _isShimmerActive = true;
  Offset? _appBarTapPosition;
  bool _isAppBarHovered = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange) {
            _atBottom = true;
          } else {
            _atBottom = false;
          }
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// MAIN UI
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double opacity =
        (_scrollOffset / 250).clamp(0.0, 1.0); // fade speed 0–250 px

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,

      /// 🌙 Transparent → Solid AppBar with Gradient
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isAppBarHovered = true),
          onExit: (_) => setState(() {
            _isAppBarHovered = false;
            _appBarTapPosition = null;
          }),
          onHover: (event) {
            if (_isAppBarHovered) {
              setState(() => _appBarTapPosition = event.localPosition);
            }
          },
          child: GestureDetector(
            onTapDown: (details) {
              setState(() => _appBarTapPosition = details.localPosition);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: _appBarTapPosition != null && opacity > 0.3
                    ? RadialGradient(
                        center: Alignment(
                          (_appBarTapPosition!.dx / 200) - 1,
                          (_appBarTapPosition!.dy / 30) - 1,
                        ),
                        radius: 2.0,
                        colors: [
                          theme.primaryColor.withOpacity(opacity * 0.8),
                          theme.primaryColor.withOpacity(opacity * 0.5),
                          (theme.appBarTheme.backgroundColor ??
                                  theme.colorScheme.primary)
                              .withOpacity(opacity),
                        ],
                      )
                    : null,
                color: _appBarTapPosition == null
                    ? (theme.appBarTheme.backgroundColor ??
                            theme.colorScheme.primary)
                        .withOpacity(opacity)
                    : null,
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Opacity(
                        opacity: opacity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Don't forget to SUBSCRIBE!",
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "@PROGRAMMINGWITHFLEXZ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildThemeToggleButton(theme, opacity),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      /// 🧱 Body
      body: Stack(
        children: [
          Positioned.fill(child: _listView()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppFaderEffect(atBottom: _atBottom),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBBN(
              atBottom: _atBottom,
              onChangePage: (index) {
                // Handle page change
                print('Navigate to page: $index');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggleButton(ThemeData theme, double opacity) {
    return MouseRegion(
      child: GestureDetector(
        onTap: widget.toggleTheme,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _isAppBarHovered
                ? RadialGradient(
                    colors: [
                      theme.primaryColor.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  )
                : null,
          ),
          child: Icon(
            widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: opacity > 0.5 ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  /// 🪄 Scrollable List
  Widget _listView() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        setState(() {
          _scrollOffset = scrollInfo.metrics.pixels;
        });
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(
            top: 100, bottom: 100), // space for AppBar and bottom nav
        itemCount: 9,
        itemBuilder: (context, index) => _buildSingleItem(context, index),
      ),
    );
  }

  /// 💫 Shimmer Cards with Gradient Interaction
  Widget _buildSingleItem(BuildContext context, int index) {
    final baseColor = Theme.of(context).colorScheme.secondary;
    final highlightColor = Theme.of(context).dialogBackgroundColor;

    return _InteractiveShimmerCard(
      baseColor: baseColor,
      highlightColor: highlightColor,
      isShimmerActive: _isShimmerActive,
      index: index,
    );
  }
}

class _InteractiveShimmerCard extends StatefulWidget {
  final Color baseColor;
  final Color highlightColor;
  final bool isShimmerActive;
  final int index;

  const _InteractiveShimmerCard({
    required this.baseColor,
    required this.highlightColor,
    required this.isShimmerActive,
    required this.index,
  });

  @override
  State<_InteractiveShimmerCard> createState() =>
      _InteractiveShimmerCardState();
}

class _InteractiveShimmerCardState extends State<_InteractiveShimmerCard> {
  Offset? _tapPosition;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _tapPosition = null;
      }),
      onHover: (event) {
        if (_isHovered) {
          setState(() => _tapPosition = event.localPosition);
        }
      },
      child: GestureDetector(
        onTapDown: (details) {
          setState(() => _tapPosition = details.localPosition);
        },
        onTapUp: (_) {
          // Handle tap
          print('Card ${widget.index} tapped');
        },
        onTapCancel: () => setState(() => _tapPosition = null),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 110,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: _tapPosition != null || _isHovered
                    ? RadialGradient(
                        center: _tapPosition != null
                            ? Alignment(
                                (_tapPosition!.dx / 200) - 1,
                                (_tapPosition!.dy / 55) - 1,
                              )
                            : Alignment.center,
                        radius: 1.5,
                        colors: [
                          theme.primaryColor.withOpacity(0.15),
                          theme.primaryColor.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _shimmerBox(
                        Colors.grey.shade900,
                        90,
                        widget.baseColor,
                        widget.highlightColor,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _shimmerTextBlocks(
                          widget.baseColor,
                          widget.highlightColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(delay: Duration(milliseconds: 60 * widget.index))
                .slideX(begin: 0.1),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _shimmerTextBlocks(Color baseColor, Color highlightColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _shimmerBox(Colors.black, 20, baseColor, highlightColor, width: 200),
        const SizedBox(height: 6),
        _shimmerBox(Colors.black, 12, baseColor, highlightColor, width: 150),
        const SizedBox(height: 6),
        _shimmerBox(Colors.black, 12, baseColor, highlightColor, width: 90),
      ],
    );
  }

  Widget _shimmerBox(
    Color color,
    double height,
    Color base,
    Color highlight, {
    double width = double.infinity,
  }) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      enabled: widget.isShimmerActive,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}