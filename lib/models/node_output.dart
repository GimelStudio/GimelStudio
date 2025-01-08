class Output {
  Output({
    required this.id,
    required this.idname,
    required this.dataType,
  });

  /// A unique id.
  String id;

  /// The string by which this output will be referenced.
  /// This should be unique per node type.
  final String idname;

  /// The data type of this output.
  final Type dataType;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idname': idname,
      'dataType': dataType.toString(),
    };
  }

  Output.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        idname = json['idname'] as String,
        dataType = json['dataType']; // TODO

  @override
  String toString() {
    return 'Output{id: $id, idname: $idname, dataType: $dataType}';
  }

  factory Output.clone(Output source, String id) {
    return Output(
      id: id,
      idname: source.idname,
      dataType: source.dataType,
    );
  }
}
