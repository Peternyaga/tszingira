import 'leaderboard_item_modal.dart';

class DashboardData {
  final String name;
  final int totalTrees;
  final int myTrees;
  final List<int> regionalSummary;
  final List<LeaderboardItemModal> leaderboardList;

  DashboardData({required this.name, required this.totalTrees, required this.myTrees, required this.regionalSummary, required this.leaderboardList});

}