import { useEffect, useState } from "react";
import { CheckCircle2, Circle } from "lucide-react";

import { Card, CardContent } from "@/components/ui/card";
import { getData, patchData } from "@/lib/api";

export default function HabitsPage() {
  const [habits, setHabits] = useState([]);

  useEffect(() => {
    let active = true;
    getData("/habits").then((data) => {
      if (active) setHabits(data.habits);
    });
    return () => {
      active = false;
    };
  }, []);

  const toggleHabit = async (habitId, completed) => {
    const data = await patchData(`/habits/${habitId}/today`, { completed: !completed });
    setHabits((current) => current.map((habit) => (habit.habit_id === habitId ? data.habit : habit)));
  };

  return (
    <div className="space-y-6" data-testid="habits-page">
      <Card className="rounded-[34px] border-white/10 bg-white/5 text-white" data-testid="habits-header-card">
        <CardContent className="p-6">
          <p className="text-xs uppercase tracking-[0.28em] text-white/45">Habit system</p>
          <h1 className="mt-2 text-4xl font-black" data-testid="habits-title">Daily habit board</h1>
          <p className="mt-3 max-w-2xl text-sm leading-7 text-white/65" data-testid="habits-subtitle">
            Habits were generated from your onboarding flow. Mark them done to keep your streak and dashboard score moving.
          </p>
        </CardContent>
      </Card>

      <div className="grid gap-4 xl:grid-cols-2" data-testid="habits-grid">
        {habits.map((habit) => (
          <button
            className={`w-full rounded-[30px] border p-5 text-left transition ${habit.today_completed ? "border-lime-300/35 bg-lime-300/10" : "border-white/10 bg-white/5 hover:border-white/20 hover:bg-white/10"}`}
            data-testid={`habit-card-${habit.habit_id}`}
            key={habit.habit_id}
            onClick={() => toggleHabit(habit.habit_id, habit.today_completed)}
            type="button"
          >
            <div className="flex items-start justify-between gap-4">
              <div>
                <p className="text-xl font-black text-white" data-testid={`habit-card-title-${habit.habit_id}`}>{habit.title}</p>
                <p className="mt-2 text-sm leading-7 text-white/65">{habit.description}</p>
              </div>
              <div data-testid={`habit-card-status-icon-${habit.habit_id}`}>
                {habit.today_completed ? <CheckCircle2 className="h-6 w-6 text-lime-200" /> : <Circle className="h-6 w-6 text-white/45" />}
              </div>
            </div>

            <div className="mt-5 grid gap-3 sm:grid-cols-3">
              <div className="rounded-2xl border border-white/10 bg-black/20 px-4 py-3" data-testid={`habit-card-target-${habit.habit_id}`}>
                <p className="text-xs uppercase tracking-[0.24em] text-white/45">Target</p>
                <p className="mt-2 font-semibold text-white">{habit.target} {habit.unit}</p>
              </div>
              <div className="rounded-2xl border border-white/10 bg-black/20 px-4 py-3" data-testid={`habit-card-streak-${habit.habit_id}`}>
                <p className="text-xs uppercase tracking-[0.24em] text-white/45">Streak</p>
                <p className="mt-2 font-semibold text-white">{habit.streak} days</p>
              </div>
              <div className="rounded-2xl border border-white/10 bg-black/20 px-4 py-3" data-testid={`habit-card-rate-${habit.habit_id}`}>
                <p className="text-xs uppercase tracking-[0.24em] text-white/45">Completion</p>
                <p className="mt-2 font-semibold text-white">{habit.completion_rate}%</p>
              </div>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}
