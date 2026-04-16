import Fastify from "fastify";
import { FoodSearchService } from "../domains/nutrition/foodSearchService.js";
import { MealAnalysisService } from "../domains/nutrition/mealAnalysisService.js";
import { ProjectionService } from "../domains/goals/projectionService.js";
import { WorkoutService } from "../domains/training/workoutService.js";
import { CoachingService } from "../domains/coaching/coachingService.js";
import type { AnalyzeMealRequest } from "../contracts/mealContracts.js";

const app = Fastify({ logger: true });

const foodSearchService = new FoodSearchService();
const mealAnalysisService = new MealAnalysisService();
const projectionService = new ProjectionService();
const workoutService = new WorkoutService();
const coachingService = new CoachingService();

app.get("/health", async () => ({ status: "ok" }));

app.get("/v1/foods/search", async (request) => {
  const query = String((request.query as { q?: string }).q ?? "");
  return { items: foodSearchService.search(query) };
});

app.post("/v1/meals/analyze", async (request) => {
  const body = request.body as AnalyzeMealRequest;
  return mealAnalysisService.analyze(body);
});

app.post("/v1/meals", async (request) => {
  const body = request.body as AnalyzeMealRequest;
  return mealAnalysisService.analyze(body);
});

app.get("/v1/goals/projections", async () => ({
  scenarios: projectionService.buildScenarios()
}));

app.get("/v1/workouts/plans", async () => ({
  plans: workoutService.defaultPlans()
}));

app.get("/v1/coaching/daily", async (request) => {
  const tone = ((request.query as { tone?: "supportive" | "balanced" | "direct" }).tone ?? "balanced");
  return coachingService.buildDailyInsight(tone);
});

const start = async () => {
  try {
    await app.listen({ port: 4000, host: "0.0.0.0" });
  } catch (error) {
    app.log.error(error);
    process.exit(1);
  }
};

start();
