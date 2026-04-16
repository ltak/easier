export interface WorkoutPlanSummary {
  id: string;
  name: string;
  split: string;
}

export class WorkoutService {
  defaultPlans(): WorkoutPlanSummary[] {
    return [
      { id: "full_body_3x", name: "Full Body 3x", split: "full-body" },
      { id: "upper_lower_4x", name: "Upper / Lower 4x", split: "upper-lower" }
    ];
  }
}
