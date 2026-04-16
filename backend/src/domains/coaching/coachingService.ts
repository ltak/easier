export type CoachTone = "supportive" | "balanced" | "direct";

export interface DailyInsight {
  title: string;
  message: string;
  tone: CoachTone;
}

export class CoachingService {
  buildDailyInsight(tone: CoachTone): DailyInsight {
    const baseMessage =
      "Lunch is carrying easy calories from sauce. Tightening that first is the simplest way to save calories without making the meal feel much smaller.";

    return {
      title: "Save calories without extra hunger",
      message: baseMessage,
      tone
    };
  }
}
