enum ChannelType {
  method,
  event,
}

extension ChannelKeyTypeEx on ChannelType {
  String get name {
    switch (this) {
      case ChannelType.method:
        return 'ios_callkit';
      case ChannelType.event:
        return 'ios_callkit/event';
    }
  }
}
