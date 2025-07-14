class DiningTableModel {
  String? id;
  String? name;
  String? size;
  bool? isActive;
  String? branchId;
  String? tableAvtarImage;

  DiningTableModel({this.id, this.name,this.isActive,this.size,this.branchId,this.tableAvtarImage});

  DiningTableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    size = json['size'];
    branchId = json['branchId'];
    tableAvtarImage = json['tableAvtarImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    data['size'] = size;
    data['branchId'] = branchId;
    data['tableAvtarImage'] = tableAvtarImage;
    return data;
  }
}
