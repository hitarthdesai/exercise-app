import SwiftUI

struct Workout: Identifiable {
    var id: UUID
    var name: String
    var exercises: [Exercise]
}

struct WorkoutLinkView: View {
    var workout: Workout
    
    var body: some View {
        VStack {
            Text(workout.name)
                .font(.title3)
            Text("\(workout.exercises.count) Exercises")
                .font(.caption)
        }
    }
}

struct WorkoutView: View {
    var workout: Workout
    
    var body: some View {
        VStack {
            List(workout.exercises) { exercise in
                ExerciseView(exercise: exercise)
            }
            Spacer()
        }
        .navigationTitle(workout.name)
    }
}
