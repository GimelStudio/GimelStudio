class Output {
  Output({
    required this.name,
    required this.dataType,
  });

  /// The string by which this output will be referenced.
  /// This should be unique per node type.
  final String name;

  /// The data type of this output.
  final Type dataType;
}
