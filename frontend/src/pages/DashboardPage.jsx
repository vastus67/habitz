import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowRight, Flame, Sparkles, Target } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { useAuth } from "@/context/auth-context";
import { getData } from "@/lib/api";

function StatCard({ label, value, accent, testId }) {
  return (
    <Card className="rounded-[28px] border-white/10 bg-white/5 text-white" data-testid={testId}>
      <CardContent className="p-5">
        <p className="text-xs uppercase tracking-[0.28em] text-white/45">{label}</p>
        <p className={`mt-3 text-3xl font-black ${accent}`} data-testid={`${testId}-value`}>
          {value}
        </p>
      </CardContent>
    </Card>
  );
}

export default function DashboardPage() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [dashboard, setDashboard] = useState(null);
  const [activeWorkout, setActiveWorkout] = useState(null);

  useEffect(() => {
    let active = true;
    Promise.all([getData("/dashboard"), getData("/workouts/active")]).then(([dashboardData, workoutData]) => {
      if (!active) return;
      setDashboard(dashboardData);
      setActiveWorkout(workoutData.active_workout);
    });
    return () => {
      active = false;
    };
  }, []);

  if (!dashboard) {
    return (
      <div className="rounded-[32px] border border-white/10 bg-white/5 p-10 text-center text-white/65" data-testid="dashboard-loading-state">
        Loading your Habitz dashboard...
      </div>
    );
  }

  const handleWorkoutClick = () => {
    if (activeWorkout) {
      navigate(`/app/workout/${activeWorkout.plan.plan_id}/${activeWorkout.day.day_id}`);
      return;
    }
    if (dashboard.active_plan && dashboard.next_workout_day) {
      navigate(`/app/workout/${dashboard.active_plan.plan_id}/${dashboard.next_workout_day.day_id}`);
      return;
    }
    navigate("/app/plans");
  };

  return (
    <div className="space-y-6" data-testid="dashboard-page">
      <section className="grid gap-6 xl:grid-cols-[1.25fr_0.75fr]">
        <Card className="overflow-hidden rounded-[34px] border-white/10 bg-[linear-gradient(135deg,rgba(163,230,53,0.18),rgba(8,18,15,0.9)_45%,rgba(59,130,246,0.12))] text-white" data-testid="dashboard-hero-card">
          <CardContent className="grid gap-6 p-6 lg:grid-cols-[1.1fr_0.9fr] lg:p-8">
            <div>
              <p className="text-xs uppercase tracking-[0.35em] text-lime-200/80">Today&apos;s focus</p>
              <h1 className="mt-4 text-4xl font-black tracking-tight sm:text-5xl" data-testid="dashboard-greeting-title">
                {user?.name}, your system is live.
              </h1>
              <p className="mt-4 max-w-xl text-sm leading-7 text-white/70" data-testid="dashboard-adaptive-message">
                {dashboard.adaptive_message}
              </p>
              <div className="mt-6 flex flex-wrap gap-3">
                <Button className="rounded-full bg-lime-300 text-slate-950 hover:bg-lime-200" data-testid="dashboard-primary-workout-button" onClick={handleWorkoutClick}>
                  {activeWorkout ? "Resume active workout" : dashboard.active_plan ? "Start next workout" : "Choose a plan"}
                  <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
                <Button className="rounded-full border border-white/10 bg-white/5 text-white hover:bg-white/10" data-testid="dashboard-view-plans-button" onClick={() => navigate("/app/plans")} variant="ghost">
                  View plans
                </Button>
              </div>
            </div>

            <div className="rounded-[30px] border border-white/10 bg-black/20 p-5">
              <p className="text-xs uppercase tracking-[0.28em] text-white/45">Active plan snapshot</p>
              {dashboard.active_plan ? (
                <div className="mt-4 space-y-3">
                  <p className="text-2xl font-bold" data-testid="dashboard-active-plan-name">{dashboard.active_plan.name}</p>
                  <p className="text-sm text-white/65" data-testid="dashboard-active-plan-description">{dashboard.active_plan.description}</p>
                  <div className="grid grid-cols-2 gap-3 text-sm">
                    <div className="rounded-2xl border border-white/10 bg-white/5 p-3" data-testid="dashboard-weekly-progress-card">
                      <p className="text-white/45">Weekly progress</p>
                      <p className="mt-2 text-xl font-bold text-lime-200">{Math.round(dashboard.weekly_progress * 100)}%</p>
                    </div>
                    <div className="rounded-2xl border border-white/10 bg-white/5 p-3" data-testid="dashboard-next-workout-card">
                      <p className="text-white/45">Next workout</p>
                      <p className="mt-2 text-xl font-bold text-sky-200">{dashboard.next_workout_day?.title || "Ready"}</p>
                    </div>
                  </div>
                </div>
              ) : (
                <div className="mt-4 rounded-[24px] border border-dashed border-white/15 bg-white/5 p-5 text-sm text-white/60" data-testid="dashboard-no-plan-state">
                  No active plan yet. Choose a personalized plan from the plans page to unlock workout progress.
                </div>
              )}
            </div>
          </CardContent>
        </Card>

        <div className="grid gap-4">
          <StatCard accent="text-lime-200" label="Completion" testId="dashboard-completion-card" value={`${Math.round(dashboard.completion * 100)}%`} />
          <StatCard accent="text-sky-200" label="Daily score" testId="dashboard-score-card" value={dashboard.score} />
          <StatCard accent="text-orange-200" label="Streak" testId="dashboard-streak-card" value={`${dashboard.streak} days`} />
        </div>
      </section>

      <section className="grid gap-6 lg:grid-cols-[0.9fr_1.1fr]">
        <Card className="rounded-[32px] border-white/10 bg-white/5 text-white" data-testid="dashboard-momentum-card">
          <CardContent className="p-6">
            <div className="flex items-center gap-3">
              <div className="rounded-full bg-lime-300/15 p-3 text-lime-200">
                <Flame className="h-5 w-5" />
              </div>
              <div>
                <p className="text-xs uppercase tracking-[0.28em] text-white/45">Momentum</p>
                <p className="mt-1 text-3xl font-black" data-testid="dashboard-momentum-value">{dashboard.momentum}</p>
              </div>
            </div>
            <p className="mt-4 text-sm leading-7 text-white/65">
              Momentum measures how consistently you are stacking habits and workouts over the last week.
            </p>
          </CardContent>
        </Card>

        <Card className="rounded-[32px] border-white/10 bg-white/5 text-white" data-testid="dashboard-habits-preview-card">
          <CardContent className="p-6">
            <div className="flex items-center justify-between gap-3">
              <div>
                <p className="text-xs uppercase tracking-[0.28em] text-white/45">Habit preview</p>
                <h2 className="mt-2 text-2xl font-black">Today&apos;s habit board</h2>
              </div>
              <Button className="rounded-full border border-white/10 bg-white/5 text-white hover:bg-white/10" data-testid="dashboard-open-habits-button" onClick={() => navigate("/app/habits")} variant="ghost">
                Open habits
              </Button>
            </div>
            <div className="mt-5 grid gap-3 sm:grid-cols-2">
              {dashboard.habits_preview.map((habit) => (
                <div className="rounded-[24px] border border-white/10 bg-black/20 p-4" data-testid={`dashboard-habit-preview-${habit.habit_id}`} key={habit.habit_id}>
                  <div className="flex items-center justify-between gap-3">
                    <p className="font-semibold" data-testid={`dashboard-habit-preview-title-${habit.habit_id}`}>{habit.title}</p>
                    <span className={`rounded-full px-3 py-1 text-xs ${habit.today_completed ? "bg-lime-300 text-slate-950" : "bg-white/10 text-white/65"}`} data-testid={`dashboard-habit-preview-status-${habit.habit_id}`}>
                      {habit.today_completed ? "Done" : "Open"}
                    </span>
                  </div>
                  <p className="mt-3 text-sm text-white/60">Streak {habit.streak} • {habit.completion_rate}% completion</p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </section>

      <Card className="rounded-[32px] border-white/10 bg-white/5 text-white" data-testid="dashboard-focus-strip">
        <CardContent className="flex flex-wrap items-center justify-between gap-4 p-6">
          <div className="flex items-center gap-3">
            <div className="rounded-full bg-sky-400/15 p-3 text-sky-200">
              <Target className="h-5 w-5" />
            </div>
            <div>
              <p className="text-sm font-semibold">{dashboard.today_habits_completed} / {dashboard.today_habits_total} habits complete today</p>
              <p className="text-sm text-white/60">Keep one more promise to yourself before the day ends.</p>
            </div>
          </div>
          <div className="flex items-center gap-2 text-sm text-lime-200" data-testid="dashboard-personalization-chip">
            <Sparkles className="h-4 w-4" />
            Personalized for {user?.sex_variant || "your profile"}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
