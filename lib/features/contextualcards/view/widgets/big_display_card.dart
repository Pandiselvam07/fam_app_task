import 'package:famapp/core/helpers/color_utils.dart';
import 'package:famapp/core/helpers/formatted_text_builder.dart';
import 'package:famapp/core/helpers/image_builder.dart';
import 'package:famapp/core/helpers/url_handler.dart';
import 'package:flutter/material.dart';
import '../../../../core/helpers/cta_button.dart';
import '../../../../core/helpers/gradient_builder.dart';
import '../../model/contextual_card_model.dart';

class BigDisplayCard extends StatefulWidget {
  final ContextualCard card;
  final Function(String, bool) onDismiss;

  const BigDisplayCard({Key? key, required this.card, required this.onDismiss})
    : super(key: key);

  @override
  _BigDisplayCardState createState() => _BigDisplayCardState();
}

class _BigDisplayCardState extends State<BigDisplayCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _isSliding = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.45, 0)).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _slideController.dispose();
    super.dispose();
  }

  void _handleLongPress() {
    if (_isDisposed) return;

    if (mounted) {
      setState(() {
        _isSliding = true;
      });
      _slideController.forward();
    }
  }

  void _handleTap() {
    if (_isDisposed) return;

    if (_isSliding) {
      if (mounted) {
        setState(() {
          _isSliding = false;
        });
      }
      _slideController.reverse();
    } else {
      UrlHandler.handleTap(widget.card.url);
    }
  }

  void _handleDismiss(bool permanently) {
    if (_isDisposed) return;

    widget.onDismiss(widget.card.name, permanently);
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _handleLongPress,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Stack(
          children: [
            if (_isSliding)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.only(right: _isSliding ? 25 : 0),
                  width: 150,

                  child: Column(
                    children: [
                      SizedBox(height: 75),

                      Expanded(
                        child: GestureDetector(
                          onTap: () => _handleDismiss(false),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xFFF5F5F5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFB800),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'remind later',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      Expanded(
                        child: GestureDetector(
                          onTap: () => _handleDismiss(true),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xFFF5F5F5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF9500),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'dismiss now',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 75),
                    ],
                  ),
                ),
              ), // Main card
            SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: double.infinity,
                height: 378,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: widget.card.bgGradient != null
                      ? GradientBuilder.buildGradient(widget.card.bgGradient!)
                      : null,
                  color: widget.card.bgGradient == null
                      ? ColorUtils.parseColor(widget.card.bgColor) ??
                            Colors.blue
                      : null,
                ),
                child: Stack(
                  children: [
                    if (widget.card.bgImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ImageBuilder.buildImage(
                          widget.card.bgImage!,
                          double.infinity,
                          double.infinity,
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 125,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.card.formattedTitle != null)
                            FormattedTextBuilder.buildFormattedText(
                              widget.card.formattedTitle!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          else if (widget.card.title != null)
                            Text(
                              widget.card.title!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          const SizedBox(height: 4),
                          if (widget.card.formattedDescription != null)
                            FormattedTextBuilder.buildFormattedText(
                              widget.card.formattedDescription!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            )
                          else if (widget.card.description != null)
                            Text(
                              widget.card.description!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          if (widget.card.cta.isNotEmpty)
                            Row(
                              children: widget.card.cta
                                  .map(
                                    (cta) => Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                      ),
                                      child: SizedBox(
                                        width: 125,
                                        height: 30,
                                        child: CTAButton.buildCTAButton(cta),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
