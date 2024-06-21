class InternetReconnectingState {
  bool isInternetAvailable;
  int secondsRemaining;
  InternetReconnectingState({
    required this.isInternetAvailable,
    required this.secondsRemaining,
  });

  InternetReconnectingState.initial()
      : isInternetAvailable = true,
        secondsRemaining = 15;

  @override
  bool operator ==(covariant InternetReconnectingState other) {
    if (identical(this, other)) return true;

    return other.isInternetAvailable == isInternetAvailable &&
        other.secondsRemaining == secondsRemaining;
  }

  @override
  int get hashCode => isInternetAvailable.hashCode ^ secondsRemaining.hashCode;

  InternetReconnectingState copyWith({
    bool? isInternetAvailable,
    int? secondsRemaining,
  }) {
    return InternetReconnectingState(
      isInternetAvailable: isInternetAvailable ?? this.isInternetAvailable,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
    );
  }
}
