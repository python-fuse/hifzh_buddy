import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isPlaying;
  final bool isLoading;

  const PlayButton({
    super.key,
    required this.onTap,
    required this.isPlaying,
    required this.isLoading,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  double size = 60.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onTapDown: (details) => {
        setState(() {
          size -= 10;
        }),
      },
      onTapUp: (details) => {
        setState(() {
          size += 10;
        }),
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: widget.isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    value: null,

                    strokeWidth: 2,
                  ),
                ),
              )
            : widget.isPlaying
            ? Icon(Icons.pause, color: Colors.white, size: 30)
            : Icon(Icons.play_arrow, color: Colors.white, size: 30),
      ),
    );
  }
}
