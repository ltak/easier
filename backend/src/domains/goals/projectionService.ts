export interface ProjectionScenario {
  title: string;
  expectedWeeks: number;
  summary: string;
}

export class ProjectionService {
  buildScenarios(): ProjectionScenario[] {
    return [
      {
        title: "Current pace",
        expectedWeeks: 12,
        summary: "Based on your current trend, you are roughly twelve weeks from the target."
      },
      {
        title: "Small adjustment",
        expectedWeeks: 10,
        summary: "A modest calorie reduction or activity increase could pull the timeline closer to ten weeks."
      }
    ];
  }
}
