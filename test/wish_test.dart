import 'dart:io';

import 'package:exrail/data_source/remote_data_source/wish_data_source.dart';
import 'package:exrail/model/wish.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Get Wish of User', () async {
    List<Wish> wish = await WishRemoteDataSource().getWish();
    expect(wish[0].productName, "Gaming Setup");
  });

  test('Create Wish', () async {
    File? img = File('assets/images/vectors/hash.png');
    Wish wish = Wish(
      productName: "Gaming Setup",
      price: 100000,
    );
    bool status = await WishRemoteDataSource().addWish(img, wish);
    expect(status, true);
  });
}
