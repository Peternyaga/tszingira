import 'package:tsc_miti/dashboard/leaderboard_item_modal.dart';
import 'package:intl/intl.dart';


const String baseUrl = "https://services.tsc.go.ke/tsc-mazingira";
//const String baseUrl = "http://127.0.0.1:8000";
const String apisUrl = "$baseUrl/api";
const String accountActivationURL = "$apisUrl/activate";
const String confirmOTPURL = "$apisUrl/confirm_otp";
const String setPasswordURL = "$apisUrl/set_password";
const String loginURL = "$apisUrl/login";
const String fetchExercisesURL = "$apisUrl/search_exercise";
const String fetchMyExercisesURL = "$apisUrl/initiator_exercises";
const String participateURL = "$apisUrl/participate_in_exercise";
const String imageUpload = "$apisUrl/upload_image";
const String plantTree = "$apisUrl/plant_tree";
const String registerExercise = "$apisUrl/register_exercise";
const String startExercise = "$apisUrl/start_exercise";
const String myActivityURL = "$apisUrl/participated_exercises";
const String dashboardUpdateURL = "$apisUrl/updateDashboard";
const String secretariatUpdateURL = "$apisUrl/sec_performance";
const String teachersUpdateURL = "$apisUrl/teachers_per_county";

String APIKey = const String.fromEnvironment('TSC_API_KEY');
 String tscNo = "";
 String firstName = "";
 int totalTrees = 0;
 int myTrees = 0;
 List<LeaderboardItemModal> leaderboardList = [];
 List<int> regionalSummaryList = [];
 String today = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());



