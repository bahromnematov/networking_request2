class CryptoModel {
  String? id;
  String? symbol;
  String? name;
  String? image;
  double? currentPrice;

  CryptoModel({
    this.symbol,
    this.name,
    this.image,
    this.currentPrice,
    required this.id,
  });

  CryptoModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    name = json['name'];
    image = json['image'];
    id = json['id'];
    currentPrice = json['current_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['symbol'] = this.symbol;
    data['name'] = this.name;
    data['image'] = this.image;
    data['current_price'] = this.currentPrice;
    return data;
  }
}
