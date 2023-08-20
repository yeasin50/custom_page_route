
part of custom_page_route;

extension BoxConstraintsExtension on BoxConstraints {
  /// get touch point to start ripple
  FractionalOffset fractionalOffset(Offset tapPosition) {
    return FractionalOffset(
      tapPosition.dx / maxWidth,
      tapPosition.dy / maxHeight,
    );
  }
}
