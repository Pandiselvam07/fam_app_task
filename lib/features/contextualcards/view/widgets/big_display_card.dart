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

  const BigDisplayCard({required this.card, required this.onDismiss});

  @override
  _BigDisplayCardState createState() => _BigDisplayCardState();
}

class _BigDisplayCardState extends State<BigDisplayCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0.3, 0))
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _handleLongPress() {
    setState(() {
      _isSliding = true;
    });
    _slideController.forward();
  }

  void _handleTap() {
    if (_isSliding) {
      setState(() {
        _isSliding = false;
      });
      _slideController.reverse();
    } else {
      UrlHandler.handleTap(widget.card.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _handleLongPress,
      child: Container(
        margin: EdgeInsets.all(16),
        child: Stack(
          children: [
            if (_isSliding)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 150,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget.onDismiss(widget.card.name, false);
                          },
                          child: Container(
                            color: Colors.orange,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.schedule, color: Colors.white),
                                Text(
                                  'Remind Later',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget.onDismiss(widget.card.name, true);
                          },
                          child: Container(
                            color: Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.close, color: Colors.white),
                                Text(
                                  'Dismiss Now',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Main card
            SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: double.infinity,
                height: 350,
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
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.card.formattedTitle != null)
                            FormattedTextBuilder.buildFormattedText(
                              widget.card.formattedTitle!,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          else if (widget.card.title != null)
                            Text(
                              widget.card.title!,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          SizedBox(height: 12),
                          if (widget.card.formattedDescription != null)
                            FormattedTextBuilder.buildFormattedText(
                              widget.card.formattedDescription!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            )
                          else if (widget.card.description != null)
                            Text(
                              widget.card.description!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          Spacer(),
                          if (widget.card.cta.isNotEmpty)
                            Row(
                              children: widget.card.cta
                                  .map(
                                    (cta) => Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: CTAButton.buildCTAButton(cta),
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
