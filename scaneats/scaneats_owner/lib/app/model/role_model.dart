class RoleModel {
  String? id;
  int? position;
  String? title;
  bool? isEdit;
  bool? isActive;
  List<RolePermission>? permission;

  RoleModel({this.id, this.position, this.title, this.isActive, this.isEdit, this.permission});

  RoleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
    title = json['title'];
    isEdit = json['isEdit'];
    isActive = json['isActive'];
    permission = json['permission'] != null ? List<RolePermission>.from(json['permission'].map((permissionJson) => RolePermission.fromJson(permissionJson))) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['position'] = position;
    data['title'] = title;
    data['isEdit'] = isEdit;
    data['isActive'] = isActive;
    data['permission'] = permission?.map((permission) => permission.toJson()).toList();
    return data;
  }
}

class RolePermission {
  String? title;
  bool? isEdit;
  bool? isUpdate;
  bool? isDelete;
  bool? isView;

  RolePermission({this.title, this.isEdit, this.isUpdate, this.isDelete, this.isView});

  RolePermission.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    isEdit = json['isEdit'];
    isUpdate = json['isUpdate'];
    isDelete = json['isDelete'];
    isView = json['isView'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['isEdit'] = isEdit;
    data['isUpdate'] = isUpdate;
    data['isDelete'] = isDelete;
    data['isView'] = isView;

    return data;
  }
}
