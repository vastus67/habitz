import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowLeft, ArrowRight, Clock3, Dumbbell, Flame, HeartPulse, Sparkles } from "lucide-react";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { useAuth } from "@/context/auth-context";
import { postData } from "@/lib/api";

const goalOptions = [
  { value: "build_muscle", label: "Build muscle", icon: Dumbbell },
  { value: "lose_fat", label: "Lose fat", icon: Flame },
  { value: "improve_health", label: "Improve health", icon: HeartPulse },
  { value: "improve_discipline", label: "Improve discipline", icon: Sparkles },
  { value: "build_daily_habits", label: "Build daily habits", icon: Clock3 },
  { value: "increase_energy", label: "Increase energy", icon: Sparkles },
];

const sexOptions = [
  { value: "male", label: "Male workouts" },
  { value: "female", label: "Female workouts" },
  { value: "unisex", label: "Unisex programs" },
];

const levelOptions = [
  { value: "beginner", label: "Beginner", description: "New to structured training" },
  { value: "intermediate", label: "Intermediate", description: "You train consistently" },
  { value: "advanced", label: "Advanced", description: "Performance and progression first" },
];

const equipmentOptions = [
  { value: "none", label: "No equipment" },
  { value: "home", label: "Home equipment" },
  { value: "gym", label: "Full gym access" },
];

const wakeTimes = ["05:30", "06:00", "06:30", "07:00", "07:30", "08:00", "08:30", "09:00"];

function SelectionCard({ selected, title, description, onClick, testId, badge }) {
  return (
    <button
      className={`w-full rounded-[28px] border p-5 text-left transition duration-200 ${selected ? "border-lime-300/40 bg-lime-300/12 text-white" : "border-white/10 bg-white/5 text-white/75 hover:border-white/20 hover:bg-white/10"}`}
      data-testid={testId}
      onClick={onClick}
      type="button"
    >
      {badge ? <p className="mb-2 text-xs uppercase tracking-[0.25em] text-lime-200/85">{badge}</p> : null}
      <div className="text-lg font-semibold">{title}</div>
      {description ? <p className="mt-2 text-sm leading-6 text-white/60">{description}</p> : null}
    </button>
  );
}

export default function OnboardingPage() {
  const { user, setUser } = useAuth();
  const navigate = useNavigate();
  const [step, setStep] = useState(0);
  const [loadingRecommendations, setLoadingRecommendations] = useState(false);
  const [saving, setSaving] = useState(false);
  const [recommendations, setRecommendations] = useState({ habits: [], plans: [] });
  const [form, setForm] = useState({
    name: user?.name || "",
    goals: [],
    sex_variant: "",
    fitness_level: "",
    equipment: "",
    wake_time: "07:00",
    habit_keys: [],
    selected_plan_id: null,
  });

  const canFetchRecommendations = useMemo(
    () => form.goals.length > 0 && form.sex_variant && form.fitness_level && form.equipment,
    [form.equipment, form.fitness_level, form.goals.length, form.sex_variant],
  );

  useEffect(() => {
    let active = true;
    if (!canFetchRecommendations) {
      return undefined;
    }

    setLoadingRecommendations(true);
    postData("/onboarding/recommendations", {
      goals: form.goals,
      sex_variant: form.sex_variant,
      fitness_level: form.fitness_level,
      equipment: form.equipment,
      wake_time: form.wake_time,
    })
      .then((data) => {
        if (!active) return;
        setRecommendations(data);
        setForm((current) => ({
          ...current,
          habit_keys: current.habit_keys.length ? current.habit_keys : data.habits.map((habit) => habit.key),
          selected_plan_id: current.selected_plan_id || data.plans[0]?.plan_id || null,
        }));
      })
      .finally(() => {
        if (active) setLoadingRecommendations(false);
      });

    return () => {
      active = false;
    };
  }, [canFetchRecommendations, form.equipment, form.fitness_level, form.goals, form.sex_variant, form.wake_time]);

  const toggleGoal = (value) => {
    setForm((current) => ({
      ...current,
      goals: current.goals.includes(value)
        ? current.goals.filter((goal) => goal !== value)
        : [...current.goals, value],
    }));
  };

  const toggleHabit = (value) => {
    setForm((current) => ({
      ...current,
      habit_keys: current.habit_keys.includes(value)
        ? current.habit_keys.filter((habit) => habit !== value)
        : [...current.habit_keys, value],
    }));
  };

  const handleSubmit = async () => {
    setSaving(true);
    try {
      const data = await postData("/onboarding/complete", form);
      setUser(data.user);
      toast.success("Your Habitz system is ready.");
      navigate("/app/dashboard", { replace: true });
    } catch (error) {
      toast.error(error?.response?.data?.detail || "Unable to finish onboarding.");
    } finally {
      setSaving(false);
    }
  };

  const stepValidations = [
    form.name.trim().length > 1 && form.goals.length > 0,
    Boolean(form.sex_variant),
    Boolean(form.fitness_level),
    Boolean(form.equipment) && Boolean(form.wake_time),
    form.habit_keys.length > 0,
    true,
  ];

  const content = [
    <div className="grid gap-4 md:grid-cols-2" key="goals">
      <div className="md:col-span-2 space-y-2">
        <label className="text-sm font-medium text-white/75" htmlFor="onboarding-name">What should we call you?</label>
        <Input
          className="h-12 rounded-2xl border-white/10 bg-white/5 text-white placeholder:text-white/35"
          data-testid="onboarding-name-input"
          id="onboarding-name"
          onChange={(event) => setForm((current) => ({ ...current, name: event.target.value }))}
          placeholder="Athlete name"
          value={form.name}
        />
      </div>
      {goalOptions.map((option) => {
        const Icon = option.icon;
        return (
          <SelectionCard
            badge={<Icon className="h-4 w-4" />}
            description="Used to choose your recommended habits and plan focus."
            key={option.value}
            onClick={() => toggleGoal(option.value)}
            selected={form.goals.includes(option.value)}
            testId={`onboarding-goal-${option.value}-button`}
            title={option.label}
          />
        );
      })}
    </div>,
    <div className="grid gap-4 md:grid-cols-3" key="sex">
      {sexOptions.map((option) => (
        <SelectionCard
          description="Plan recommendations will stay inside this variant plus unisex fallbacks."
          key={option.value}
          onClick={() => setForm((current) => ({ ...current, sex_variant: option.value, selected_plan_id: null }))}
          selected={form.sex_variant === option.value}
          testId={`onboarding-sex-${option.value}-button`}
          title={option.label}
        />
      ))}
    </div>,
    <div className="grid gap-4 md:grid-cols-3" key="level">
      {levelOptions.map((option) => (
        <SelectionCard
          description={option.description}
          key={option.value}
          onClick={() => setForm((current) => ({ ...current, fitness_level: option.value, selected_plan_id: null }))}
          selected={form.fitness_level === option.value}
          testId={`onboarding-level-${option.value}-button`}
          title={option.label}
        />
      ))}
    </div>,
    <div className="grid gap-6 lg:grid-cols-[1.2fr_0.8fr]" key="equipment">
      <div className="space-y-4">
        {equipmentOptions.map((option) => (
          <SelectionCard
            key={option.value}
            onClick={() => setForm((current) => ({ ...current, equipment: option.value, selected_plan_id: null }))}
            selected={form.equipment === option.value}
            testId={`onboarding-equipment-${option.value}-button`}
            title={option.label}
          />
        ))}
      </div>
      <div className="rounded-[30px] border border-white/10 bg-white/5 p-5">
        <p className="text-sm uppercase tracking-[0.28em] text-white/50">Wake time</p>
        <div className="mt-4 grid grid-cols-2 gap-3" data-testid="onboarding-wake-time-grid">
          {wakeTimes.map((time) => (
            <button
              className={`rounded-2xl border px-4 py-3 text-sm font-semibold transition ${form.wake_time === time ? "border-lime-300/40 bg-lime-300/12 text-white" : "border-white/10 bg-black/20 text-white/70 hover:border-white/20"}`}
              data-testid={`onboarding-wake-time-${time.replace(':', '-')}-button`}
              key={time}
              onClick={() => setForm((current) => ({ ...current, wake_time: time }))}
              type="button"
            >
              {time}
            </button>
          ))}
        </div>
      </div>
    </div>,
    <div className="space-y-4" key="habits">
      {loadingRecommendations ? (
        <div className="rounded-[28px] border border-white/10 bg-white/5 px-5 py-8 text-center text-white/65" data-testid="onboarding-habits-loading">
          Preparing your recommended habit stack...
        </div>
      ) : (
        recommendations.habits.map((habit) => (
          <SelectionCard
            description={habit.description}
            key={habit.key}
            onClick={() => toggleHabit(habit.key)}
            selected={form.habit_keys.includes(habit.key)}
            testId={`onboarding-habit-${habit.key}-button`}
            title={habit.title}
          />
        ))
      )}
    </div>,
    <div className="space-y-4" key="plans">
      {loadingRecommendations ? (
        <div className="rounded-[28px] border border-white/10 bg-white/5 px-5 py-8 text-center text-white/65" data-testid="onboarding-plans-loading">
          Matching plans to your profile...
        </div>
      ) : (
        recommendations.plans.map((plan) => (
          <button
            className={`w-full overflow-hidden rounded-[30px] border text-left transition ${form.selected_plan_id === plan.plan_id ? "border-lime-300/40 bg-lime-300/10" : "border-white/10 bg-white/5 hover:border-white/20 hover:bg-white/10"}`}
            data-testid={`onboarding-plan-${plan.plan_id}-button`}
            key={plan.plan_id}
            onClick={() => setForm((current) => ({ ...current, selected_plan_id: plan.plan_id }))}
            type="button"
          >
            <div className="aspect-[16/7] w-full overflow-hidden">
              <img alt={plan.name} className="h-full w-full object-cover opacity-75" data-testid={`onboarding-plan-${plan.plan_id}-image`} src={plan.hero_image} />
            </div>
            <div className="space-y-3 p-5">
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div>
                  <p className="text-xl font-bold" data-testid={`onboarding-plan-${plan.plan_id}-name`}>{plan.name}</p>
                  <p className="mt-1 text-sm text-white/65">{plan.description}</p>
                </div>
                <span className="rounded-full border border-lime-300/25 bg-lime-300/10 px-3 py-1 text-xs uppercase tracking-[0.24em] text-lime-200" data-testid={`onboarding-plan-${plan.plan_id}-match`}>
                  Match {plan.match_score}
                </span>
              </div>
              <div className="flex flex-wrap gap-2 text-xs text-white/60">
                <span data-testid={`onboarding-plan-${plan.plan_id}-sex`}>{plan.sex_variant}</span>
                <span data-testid={`onboarding-plan-${plan.plan_id}-level`}>{plan.level}</span>
                <span data-testid={`onboarding-plan-${plan.plan_id}-equipment`}>{plan.equipment}</span>
              </div>
            </div>
          </button>
        ))
      )}

      <button
        className="text-sm font-medium text-lime-200"
        data-testid="onboarding-plan-skip-button"
        onClick={() => setForm((current) => ({ ...current, selected_plan_id: null }))}
        type="button"
      >
        Skip manual selection and use the best fit automatically
      </button>
    </div>,
  ];

  return (
    <div className="min-h-screen bg-[radial-gradient(circle_at_top_right,_rgba(163,230,53,0.14),_transparent_25%),linear-gradient(145deg,#07110c,#0a1b16_45%,#08120f)] px-4 py-6 text-white sm:px-6 lg:px-10 lg:py-8">
      <div className="mx-auto max-w-5xl">
        <Card className="overflow-hidden rounded-[36px] border-white/10 bg-white/5 shadow-[0_28px_100px_rgba(0,0,0,0.26)] backdrop-blur-xl" data-testid="onboarding-card">
          <CardContent className="grid gap-8 p-6 sm:p-8 lg:grid-cols-[0.8fr_1.2fr] lg:p-10">
            <div className="rounded-[32px] border border-white/10 bg-slate-950/45 p-6">
              <p className="text-xs uppercase tracking-[0.32em] text-lime-200/80" data-testid="onboarding-kicker">Habitz onboarding</p>
              <h1 className="mt-4 text-4xl font-black tracking-tight" data-testid="onboarding-title">Build your personalized system.</h1>
              <p className="mt-4 text-sm leading-7 text-white/65" data-testid="onboarding-subtitle">
                Your choices here control the workout recommendations, active plan, habits, and dashboard behavior.
              </p>

              <div className="mt-8 space-y-3" data-testid="onboarding-step-list">
                {[
                  "Goals",
                  "Workout style",
                  "Level",
                  "Equipment & wake time",
                  "Habit stack",
                  "Plan selection",
                ].map((label, index) => (
                  <div className="flex items-center gap-3" data-testid={`onboarding-step-item-${index + 1}`} key={label}>
                    <div className={`flex h-9 w-9 items-center justify-center rounded-full text-sm font-bold ${index <= step ? "bg-lime-300 text-slate-950" : "bg-white/10 text-white/60"}`}>
                      {index + 1}
                    </div>
                    <p className={`text-sm ${index === step ? "text-white" : "text-white/55"}`}>{label}</p>
                  </div>
                ))}
              </div>

              <div className="mt-8 h-2 overflow-hidden rounded-full bg-white/10" data-testid="onboarding-progress-bar">
                <div className="h-full rounded-full bg-lime-300 transition-all duration-300" style={{ width: `${((step + 1) / content.length) * 100}%` }} />
              </div>
            </div>

            <div className="space-y-6">
              <div>
                <p className="text-xs uppercase tracking-[0.32em] text-white/45" data-testid="onboarding-step-kicker">
                  Step {step + 1} of {content.length}
                </p>
                <h2 className="mt-3 text-3xl font-black" data-testid="onboarding-step-title">
                  {[
                    "What are you optimizing for?",
                    "Choose your workout variant",
                    "How experienced are you?",
                    "What equipment do you have?",
                    "Pick your starter habits",
                    "Choose your recommended plan",
                  ][step]}
                </h2>
              </div>

              {content[step]}

              <div className="flex flex-wrap items-center justify-between gap-3 pt-2">
                <Button
                  className="rounded-full border border-white/10 bg-white/5 text-white hover:bg-white/10"
                  data-testid="onboarding-back-button"
                  disabled={step === 0 || saving}
                  onClick={() => setStep((current) => Math.max(current - 1, 0))}
                  type="button"
                  variant="ghost"
                >
                  <ArrowLeft className="mr-2 h-4 w-4" />
                  Back
                </Button>

                {step < content.length - 1 ? (
                  <Button
                    className="rounded-full bg-lime-300 text-slate-950 hover:bg-lime-200"
                    data-testid="onboarding-next-button"
                    disabled={!stepValidations[step] || saving}
                    onClick={() => setStep((current) => Math.min(current + 1, content.length - 1))}
                    type="button"
                  >
                    Continue
                    <ArrowRight className="ml-2 h-4 w-4" />
                  </Button>
                ) : (
                  <Button
                    className="rounded-full bg-lime-300 text-slate-950 hover:bg-lime-200"
                    data-testid="onboarding-finish-button"
                    disabled={saving || loadingRecommendations}
                    onClick={handleSubmit}
                    type="button"
                  >
                    {saving ? "Building your system..." : "Finish onboarding"}
                    <ArrowRight className="ml-2 h-4 w-4" />
                  </Button>
                )}
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}