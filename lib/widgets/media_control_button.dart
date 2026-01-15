import 'package:flutter/material.dart';

class MediaControlButton extends StatefulWidget {
  final VoidCallback handleTap;
  final IconData icon;
  const MediaControlButton({
    super.key,
    required this.icon,
    required this.handleTap,
  });

  @override
  State<MediaControlButton> createState() => _MediaControlButtonState();
}

class _MediaControlButtonState extends State<MediaControlButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: widget.handleTap,

      constraints: BoxConstraints(),
      icon: Icon(widget.icon, size: 15),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        fixedSize: Size(30, 30),
        shape: const CircleBorder(),

        disabledBackgroundColor: Theme.of(
          context,
        ).primaryColor.withValues(alpha: 0.5),
      ),
    );
  }
}
