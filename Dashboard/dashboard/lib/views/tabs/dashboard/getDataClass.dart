import 'package:cloud_firestore/cloud_firestore.dart';

class DonationsData {
  late String showDate;
  late int donationsCount;
  late int foodDonationsCount;

  Future<void> getDonationsData(int backDays) async {
    showDate =
        '${DateTime.now().subtract(Duration(days: backDays)).month}-${DateTime.now().subtract(Duration(days: backDays)).day}';

    String filterDate =
        '${DateTime.now().subtract(Duration(days: backDays)).day}-${DateTime.now().subtract(Duration(days: backDays)).month}-${DateTime.now().subtract(Duration(days: backDays)).year}';

    await FirebaseFirestore.instance
        .collection('donation')
        .where('date', isEqualTo: filterDate)
        .get()
        .then((snapshot) {
      donationsCount = snapshot.size;
    });

    await FirebaseFirestore.instance
        .collection('food_donation')
        .where('date', isEqualTo: filterDate)
        .get()
        .then((snapshot) {
      foodDonationsCount = snapshot.size;
    });
  }
}

class DonationsForSevenDays {
  DonationsData d0 = DonationsData();
  DonationsData d1 = DonationsData();
  DonationsData d2 = DonationsData();
  DonationsData d3 = DonationsData();
  DonationsData d4 = DonationsData();
  DonationsData d5 = DonationsData();
  DonationsData d6 = DonationsData();

  Future<void> getDataForSevenDays() async {
    await d0.getDonationsData(0);
    await d1.getDonationsData(1);
    await d2.getDonationsData(2);
    await d3.getDonationsData(3);
    await d4.getDonationsData(4);
    await d5.getDonationsData(5);
    await d6.getDonationsData(6);
  }
}
