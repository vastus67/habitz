import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { useAuth } from "@/context/auth-context";
import { putData } from "@/lib/api";

const goalOptions = [
  { value: "build_muscle", label: "Build muscle" },
  { value: "lose_fat", label: "Lose fat" },
  { value: "improve_health", label: "Improve health" },
  { value: "improve_discipline", label: "Improve discipline" },
  { value: "build_daily_habits", label: "Daily habits" },
  { value: "increase_energy", label: "Increase energy" },
];

const selectClass = "h-12 w-full rounded-2xl border border-white/10 bg-white/5 px-4 text-sm text-white outline-none transition focus:border-lime-300/35";

export default function ProfilePage() {
  const navigate = useNavigate();
  const { logout, setUser, user } = useAuth();
  const [form, setForm] = useState({
    name: user?.name || "",
    sex_variant: user?.sex_variant || "unisex",
    fitness_level: user?.fitness_level || "beginner",
    equipment: user?.equipment || "home",
    wake_time: user?.wake_time || "07:00",
    goals: user?.goals || [],
  });

  useEffect(() => {
    setForm({
      name: user?.name || "",
      sex_variant: user?.sex_variant || "unisex",
      fitness_level: user?.fitness_level || "beginner",
      equipment: user?.equipment || "home",
      wake_time: user?.wake_time || "07:00",
      goals: user?.goals || [],
    });
  }, [user]);

  const toggleGoal = (value) => {
    setForm((current) => ({
      ...current,
      goals: current.goals.includes(value)
        ? current.goals.filter((goal) => goal !== value)
        : [...current.goals, value],
    }));
  };

  const handleSave = async () => {
    try {
      const data = await putData("/profile", form);
      setUser(data.user);
      toast.success("Profile updated.");
    } catch (error) {
      toast.error(error?.response?.data?.detail || "Unable to save profile.");
    }
  };

  const handleLogout = async () => {
    await logout();
    navigate("/auth", { replace: true });
  };

  return (
    <div className="space-y-6" data-testid="profile-page">
      <Card className="rounded-[34px] border-white/10 bg-white/5 text-white" data-testid="profile-header-card">
        <CardContent className="flex flex-wrap items-start justify-between gap-4 p-6">
          <div>
            <p className="text-xs uppercase tracking-[0.28em] text-white/45">Account & preferences</p>
            <h1 className="mt-2 text-4xl font-black" data-testid="profile-title">Your personalization profile</h1>
            <p className="mt-3 max-w-3xl text-sm leading-7 text-white/65" data-testid="profile-subtitle">
              Update your onboarding selections here and Habitz will keep future recommendations aligned with your profile.
            </p>
          </div>
          <div className="rounded-[28px] border border-white/10 bg-black/20 px-4 py-3 text-sm" data-testid="profile-account-summary">
            <p className="text-white/45">Signed in as</p>
            <p className="mt-1 font-semibold" data-testid="profile-account-email">{user?.email}</p>
            <div className="mt-3 flex flex-wrap gap-2">
              {user?.providers?.map((provider) => (
                <span className="rounded-full border border-lime-300/20 bg-lime-300/10 px-3 py-1 text-xs uppercase tracking-[0.2em] text-lime-200" data-testid={`profile-provider-${provider}`} key={provider}>
                  {provider}
                </span>
              ))}
            </div>
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-6 xl:grid-cols-[1.1fr_0.9fr]">
        <Card className="rounded-[32px] border-white/10 bg-white/5 text-white" data-testid="profile-form-card">
          <CardContent className="space-y-5 p-6">
            <div className="space-y-2">
              <label className="text-sm text-white/65" htmlFor="profile-name">Name</label>
              <Input className="h-12 rounded-2xl border-white/10 bg-white/5 text-white" data-testid="profile-name-input" id="profile-name" onChange={(event) => setForm((current) => ({ ...current, name: event.target.value }))} value={form.name} />
            </div>

            <div className="grid gap-4 md:grid-cols-2">
              <div className="space-y-2">
                <label className="text-sm text-white/65" htmlFor="profile-sex">Workout variant</label>
                <select className={selectClass} data-testid="profile-sex-select" id="profile-sex" onChange={(event) => setForm((current) => ({ ...current, sex_variant: event.target.value }))} value={form.sex_variant}>
                  <option value="male">Male</option>
                  <option value="female">Female</option>
                  <option value="unisex">Unisex</option>
                </select>
              </div>
              <div className="space-y-2">
                <label className="text-sm text-white/65" htmlFor="profile-level">Level</label>
                <select className={selectClass} data-testid="profile-level-select" id="profile-level" onChange={(event) => setForm((current) => ({ ...current, fitness_level: event.target.value }))} value={form.fitness_level}>
                  <option value="beginner">Beginner</option>
                  <option value="intermediate">Intermediate</option>
                  <option value="advanced">Advanced</option>
                </select>
              </div>
              <div className="space-y-2">
                <label className="text-sm text-white/65" htmlFor="profile-equipment">Equipment</label>
                <select className={selectClass} data-testid="profile-equipment-select" id="profile-equipment" onChange={(event) => setForm((current) => ({ ...current, equipment: event.target.value }))} value={form.equipment}>
                  <option value="none">No equipment</option>
                  <option value="home">Home equipment</option>
                  <option value="gym">Full gym</option>
                </select>
              </div>
              <div className="space-y-2">
                <label className="text-sm text-white/65" htmlFor="profile-wake-time">Wake time</label>
                <Input className="h-12 rounded-2xl border-white/10 bg-white/5 text-white" data-testid="profile-wake-time-input" id="profile-wake-time" onChange={(event) => setForm((current) => ({ ...current, wake_time: event.target.value }))} value={form.wake_time} />
              </div>
            </div>

            <div className="space-y-3">
              <p className="text-sm text-white/65" data-testid="profile-goals-label">Primary goals</p>
              <div className="grid gap-3 sm:grid-cols-2">
                {goalOptions.map((goal) => (
                  <button
                    className={`rounded-[24px] border px-4 py-4 text-left text-sm font-medium transition ${form.goals.includes(goal.value) ? "border-lime-300/35 bg-lime-300/10 text-white" : "border-white/10 bg-black/20 text-white/70 hover:border-white/20"}`}
                    data-testid={`profile-goal-${goal.value}-button`}
                    key={goal.value}
                    onClick={() => toggleGoal(goal.value)}
                    type="button"
                  >
                    {goal.label}
                  </button>
                ))}
              </div>
            </div>

            <div className="flex flex-wrap gap-3 pt-2">
              <Button className="rounded-full bg-lime-300 text-slate-950 hover:bg-lime-200" data-testid="profile-save-button" onClick={handleSave}>
                Save changes
              </Button>
              <Button className="rounded-full border border-white/10 bg-white/5 text-white hover:bg-white/10" data-testid="profile-view-plans-button" onClick={() => navigate("/app/plans")} variant="ghost">
                Review plans
              </Button>
            </div>
          </CardContent>
        </Card>

        <Card className="rounded-[32px] border-white/10 bg-white/5 text-white" data-testid="profile-side-card">
          <CardContent className="space-y-5 p-6">
            <div>
              <p className="text-xs uppercase tracking-[0.28em] text-white/45">Current system</p>
              <p className="mt-2 text-3xl font-black" data-testid="profile-active-plan-id">{user?.active_plan_id || "No active plan"}</p>
              <p className="mt-3 text-sm leading-7 text-white/65">
                If your preferences changed, revisit the plans page and activate a newly recommended track.
              </p>
            </div>
            <div className="rounded-[24px] border border-white/10 bg-black/20 p-4" data-testid="profile-personalization-values">
              <p className="text-sm text-white/55">Sex variant: <span className="font-semibold text-white">{form.sex_variant}</span></p>
              <p className="mt-2 text-sm text-white/55">Level: <span className="font-semibold text-white">{form.fitness_level}</span></p>
              <p className="mt-2 text-sm text-white/55">Equipment: <span className="font-semibold text-white">{form.equipment}</span></p>
            </div>
            <Button className="w-full rounded-full border border-rose-400/25 bg-rose-400/10 text-rose-100 hover:bg-rose-400/20" data-testid="profile-logout-button" onClick={handleLogout} variant="ghost">
              Sign out
            </Button>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
