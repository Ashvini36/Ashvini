class SearchModel {
  List<SearchHistory>? searchHistory;
  List<Category>? category;

  SearchModel({this.searchHistory, this.category});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['search_history'] != null) {
      searchHistory = <SearchHistory>[];
      json['search_history'].forEach((v) {
        searchHistory!.add(SearchHistory.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (searchHistory != null) {
      data['search_history'] =
          searchHistory!.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchHistory {
  String? id;
  String? searchName;

  SearchHistory({this.id, this.searchName});

  SearchHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    searchName = json['search_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['search_name'] = searchName;
    return data;
  }
}

class Category {
  String? id;
  String? title;
  List<CategoriesItem>? categoriesItem;

  Category({this.id, this.title, this.categoriesItem});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['categories_item'] != null) {
      categoriesItem = <CategoriesItem>[];
      json['categories_item'].forEach((v) {
        categoriesItem!.add(CategoriesItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (categoriesItem != null) {
      data['categories_item'] =
          categoriesItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoriesItem {
  String? id;
  String? name;
  String? image;
  String? rating;
  String? minDiscount;
  String? maxDiscount;
  bool? checked;

  CategoriesItem({this.id, this.name, this.image,this.rating,this.minDiscount,this.maxDiscount,this.checked});

  CategoriesItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    rating = json['rating'];
    minDiscount = json['minDiscount'];
    maxDiscount = json['maxDiscount'];
    checked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['rating'] = rating;
    data['minDiscount'] = minDiscount;
    data['maxDiscount'] = maxDiscount;
    return data;
  }
}
