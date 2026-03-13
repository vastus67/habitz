import { useEffect, useMemo, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { ArrowLeft, CheckCircle2, Circle, Timer } from "lucide-react";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { getData, patchData, postData } from "@/lib/api";

export default function WorkoutDayPage() {
  const { planId, dayId } = useParams();
  const navigate = useNavigate();
  const [activeWorkout, setActiveWorkout] = useState(null);
  const [effort, setEffort] = useState(7);
  const [durationMinutes, setDurationMinutes] = useState("");
  const [note, setNote] = useState("");
  const [secondsElapsed, setSecondsElapsed] = useState(0);

  useEffect(() => {
    let active = true;
    (async () => {
      const existing = await getData("/workouts/active");
      if (existing.active_workout?.plan?.plan_id === planId && existing.active_workout?.day?.day_id === dayId) {
        if (active) setActiveWorkout(existing.active_workout);
        return;
      }
      const started = await postData("/workouts/start", { plan_id: planId, day_id: dayId });
      if (active) setActiveWorkout(started.active_workout);
    })();
    return () => {
      active = false;
    };
  }, [dayId, planId]);

  useEffect(() => {
    if (!activeWorkout?.started_at) return undefined;
    const updateElapsed = () => {
      const startedAt = new Date(activeWorkout.started_at).getTime();
      setSecondsElapsed(Math.max(0, Math.floor((Date.now() - startedAt) / 1000)));
    };
    updateElapsed();
    const intervalId = window.setInterval(updateElapsed, 1000);
    return () => window.clearInterval(intervalId);
  }, [activeWorkout?.started_at]);

  const completedIds = activeWorkout?.completed_exercise_ids || [];

  const formattedElapsed = useMemo(() => {
    const minutes = Math.floor(secondsElapsed / 60).toString().padStart(2, "0");
    const seconds = (secondsElapsed % 60).toString().padStart(2, "0");
    return `${minutes}:${seconds}`;
  }, [secondsElapsed]);

  const toggleExercise = async (exerciseId) => {
    const nextIds = completedIds.includes(exerciseId)
      ? completedIds.filter((item) => item !== exerciseId)
      : [...completedIds, exerciseId];
    const data = await patchData("/workouts/active", { completed_exercise_ids: nextIds });
    setActiveWorkout(data.active_workout);
  };

  const completeWorkout = async () => {
    try {
      const payload = {
        effort,
        note,
        duration_minutes: durationMinutes ? Number(durationMinutes) : undefined,
      };
      const data = await postData("/workouts/complete", payload);
      toast.success(`${data.summary.plan_name} complete.`);
      navigate("/app/dashboard", { replace: true });
    } catch (error) {
      toast.error(error?.response?.data?.detail || "Unable to complete workout.");
    }
  };

  if (!activeWorkout) {
    return (
      <div className="rounded-[32px] border border-white/10 bg-white/5 p-10 text-center text-white/65" data-testid="workout-loading-state">
        Preparing your workout session...
      </div>
    );
  }

  const totalExercises = activeWorkout.day.exercises.length;
  const progressPercent = Math.round((completedIds.length / Math.max(totalExercises, 1)) * 100);

  return (
    <div className="space-y-6" data-testid="workout-page">
      <button className="inline-flex items-center gap-2 text-sm font-medium text-white/70 hover:text-white" data-testid="workout-back-button" onClick={() => navigate(`/app/plans/${planId}`)} type="button">
        <ArrowLeft className="h-4 w-4" />
        Back to plan detail
      </button>

      <Card className="rounded-[34px] border-white/10 bg-white/5 text-white" data-testid="workout-header-card">
        <CardContent className="grid gap-5 p-6 lg:grid-cols-[1.1fr_0.9fr] lg:p-8">
          <div>
            <p className="text-xs uppercase tracking-[0.28em] text-white/45">Active workout</p>
            <h1 className="mt-2 text-4xl font-black" data-testid="workout-day-title">{activeWorkout.day.title}</h1>
            <p className="mt-3 max-w-2xl text-sm leading-7 text-white/65" data-testid="workout-day-focus">{activeWorkout.day.focus}</p>
          </div>
          <div className="grid gap-4 sm:grid-cols-2">
            <div className="rounded-[24px] border border-white/10 bg-black/20 p-4" data-testid="workout-progress-card">
              <p className="text-xs uppercase tracking-[0.24em] text-white/45">Progress</p>
              <p className="mt-2 text-3xl font-black text-lime-200" data-testid="workout-progress-value">{progressPercent}%</p>
              <p className="mt-2 text-sm text-white/60">{completedIds.length} of {totalExercises} exercises checked off</p>
            </div>
            <div className="rounded-[24px] border border-white/10 bg-black/20 p-4" data-testid="workout-timer-card">
              <p className="text-xs uppercase tracking-[0.24em] text-white/45">Timer</p>
              <div className="mt-2 flex items-center gap-2 text-3xl font-black text-sky-200" data-testid="workout-timer-value">
                <Timer className="h-5 w-5" />
                {formattedElapsed}
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      <Card className="rounded-[34px] border-white/10 bg-white/5 text-white" data-testid="workout-exercise-list-card">
        <CardContent className="space-y-4 p-6 lg:p-8">
          {activeWorkout.day.exercises.map((exercise) => {
            const done = completedIds.includes(exercise.exercise_id);
            return (
              <button
                className={`w-full rounded-[28px] border p-5 text-left transition ${done ? "border-lime-300/35 bg-lime-300/10" : "border-white/10 bg-black/20 hover:border-white/20 hover:bg-white/10"}`}
                data-testid={`workout-exercise-${exercise.exercise_id}`}
                key={exercise.exercise_id}
                onClick={() => toggleExercise(exercise.exercise_id)}
                type="button"
              >
                <div className="flex items-start justify-between gap-4">
                  <div>
                    <p className="text-xl font-black" data-testid={`workout-exercise-name-${exercise.exercise_id}`}>{exercise.name}</p>
                    <p className="mt-2 text-sm text-white/60">{exercise.sets} sets • {exercise.reps} reps • {exercise.rest_seconds}s rest</p>
                    <p className="mt-3 text-sm leading-7 text-white/70">{exercise.instructions}</p>
                  </div>
                  <div data-testid={`workout-exercise-status-${exercise.exercise_id}`}>
                    {done ? <CheckCircle2 className="h-6 w-6 text-lime-200" /> : <Circle className="h-6 w-6 text-white/45" />}
                  </div>
                </div>
              </button>
            );
          })}
        </CardContent>
      </Card>

      <Card className="rounded-[34px] border-white/10 bg-white/5 text-white" data-testid="workout-complete-card">
        <CardContent className="space-y-5 p-6 lg:p-8">
          <div>
            <p className="text-xs uppercase tracking-[0.28em] text-white/45">Finish session</p>
            <h2 className="mt-2 text-3xl font-black">Log your workout summary</h2>
          </div>
          <div className="grid gap-4 md:grid-cols-3">
            <div className="space-y-2">
              <label className="text-sm text-white/65" htmlFor="workout-effort">Effort (1-10)</label>
              <Input className="h-12 rounded-2xl border-white/10 bg-white/5 text-white" data-testid="workout-effort-input" id="workout-effort" max="10" min="1" onChange={(event) => setEffort(Number(event.target.value))} type="number" value={effort} />
            </div>
            <div className="space-y-2">
              <label className="text-sm text-white/65" htmlFor="workout-duration">Duration in minutes</label>
              <Input className="h-12 rounded-2xl border-white/10 bg-white/5 text-white" data-testid="workout-duration-input" id="workout-duration" onChange={(event) => setDurationMinutes(event.target.value)} placeholder="Optional override" type="number" value={durationMinutes} />
            </div>
            <div className="space-y-2">
              <label className="text-sm text-white/65" htmlFor="workout-note">Note</label>
              <Input className="h-12 rounded-2xl border-white/10 bg-white/5 text-white" data-testid="workout-note-input" id="workout-note" onChange={(event) => setNote(event.target.value)} placeholder="How did it feel?" value={note} />
            </div>
          </div>
          <Button className="rounded-full bg-lime-300 text-slate-950 hover:bg-lime-200" data-testid="workout-complete-button" onClick={completeWorkout}>
            Complete workout
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
