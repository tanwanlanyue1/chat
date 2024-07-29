extension SafeListExtension<T> on List<T> {
  T? safeElementAt(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    } else {
      return null;
    }
  }
}
