class TableModel {
  final String id;
  final String name;
  String? alias;
  List<String> tabIds;
  double tableTotal = 0;
  
  // todo table shape and position properties

  TableModel({
    required this.id,
    required this.name,
    required this.tabIds,
    this.alias,
  });

  factory TableModel.fromJson(Map<String,dynamic> json) {
    return TableModel(
      id: json['id'],
      name: json['name'],
      alias: json['alias'] == '' ? null : json['alias'],
      tabIds: json['tabIds'] == '' ? null : json['billId'],
    );
  }
}