import 'individual_bar.dart';

class BarData{
  final int eastern;
  final int central;
  final int riftValley;
  final int nyanza;
  final int coast;
  final int nairobi;
  final int northEastern;
  final int western;

  BarData({required this.central, required this.coast, required this.eastern, required this.nairobi, required this.northEastern,
  required this.nyanza, required this.riftValley, required this.western});

  List<IndividualBar> barData = [];

  void initBarData(){
    barData = [
      IndividualBar(x: 1, y: nairobi),
      IndividualBar(x: 2, y: eastern),
      IndividualBar(x: 3, y: coast),
      IndividualBar(x: 4, y: northEastern),
      IndividualBar(x: 5, y: central),
      IndividualBar(x: 6, y: western),
      IndividualBar(x: 7, y: nyanza),
      IndividualBar(x: 8, y: riftValley)];
    print(barData[6].y);
  }
}