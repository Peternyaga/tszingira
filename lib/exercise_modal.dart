class ExerciseModal {
  final String exerciseName, location, start;
  final int targetSeedlings, plantedSeedlings, participants, exerciseId;
  int status;

  ExerciseModal({required this.status, required this.exerciseName, required this.location, required this.start,
      required this.targetSeedlings, required this.plantedSeedlings, required this.participants, required this.exerciseId});
}