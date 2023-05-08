class Wedding {
  String? weddingId;
  String? id;

  String? weddingDesc;

  Wedding({
    this.weddingId,
    this.id,
    this.weddingDesc,
  });

  Wedding.fromJson(Map<String, dynamic> json) {
    weddingId = json['wedding_id'];
    id = json['id'];
    // weddingName = json['wedding_name'];
    weddingDesc = json['wedding_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wedding_id'] = weddingId;
    data['id'] = id;
    data['wedding_desc'] = weddingDesc;

    return data;
  }
}
