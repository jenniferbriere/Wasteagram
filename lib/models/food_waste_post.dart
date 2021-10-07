class FoodWastePost {
  DateTime date;
  String imageURL;
  int quantity;
  num latitude;
  num longitude;

  FoodWastePost(
      {this.date, this.imageURL, this.quantity, this.latitude, this.longitude});

  factory FoodWastePost.fromMap(Map<String, dynamic> map) {
    return FoodWastePost(
        date: map['date'],
        imageURL: map['imageURL'],
        quantity: map['quantity'] as int,
        latitude: map['latitude'],
        longitude: map['longitude']);
  }

  // getters - I didn't need these for my implementation, but created
  // them so I could create more unit tests
  DateTime get getDate => date;
  String get getURL => imageURL;
  int get getQuantity => quantity;
  num get getLatitude => latitude;
  num get getLongitude => longitude;
}
