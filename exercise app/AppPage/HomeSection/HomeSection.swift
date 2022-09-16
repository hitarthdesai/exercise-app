import SwiftUI

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

struct ExerciseView: View {
    var exercise: Exercise
    
    var body: some View {
        VStack {
            Text(exercise.name)
                .font(.title3)
        }
    }
}

struct HomeSection: View {
    var Workouts: [Workout]
    init() {
        let Exercises: [Exercise] = [
            Exercise(id: UUID(), name: "Flat Bench Press"),
            Exercise(id: UUID(), name: "Incline Bench Press"),
            Exercise(id: UUID(), name: "Decline Bench Press")
        ]
        
        Workouts = [
            Workout(id: UUID(), name: "Workout 1", exercises: Exercises),
            Workout(id: UUID(), name: "Workout 2", exercises: Exercises),
            Workout(id: UUID(), name: "Workout 3", exercises: Exercises)
        ]
    }
    
    var body: some View {
        VStack {
            NavigationView {
                List(Workouts) { workout in
                    NavigationLink(destination: WorkoutView(workout: workout)) {
                        WorkoutLinkView(workout: workout)
                    }
                }
                .navigationTitle("My Workouts")
            }
        }
    }
}

struct HomeSection_Previews: PreviewProvider {
    static var previews: some View {
        HomeSection()
    }
}
