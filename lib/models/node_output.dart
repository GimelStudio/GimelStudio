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
      'dataType': dataType,
    };
  }

  Output.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idname = json['idname'],
        dataType = json['dataType'];

  @override
  String toString() {
    return 'id: $id, idname: $idname, dataType: $dataType';
  }

  factory Output.clone(Output source, String id) {
    return Output(
      id: id,
      idname: source.idname,
      dataType: source.dataType,
    );
  }
}
