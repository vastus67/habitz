import { useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowRight, CheckCircle2, Dumbbell, ShieldCheck } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { useAuth } from "@/context/auth-context";

const heroImage = "https://images.unsplash.com/photo-1758875570600-8daf8d2f05f3?crop=entropy&cs=srgb&fm=jpg&ixid=M3w3NTY2NjZ8MHwxfHNlYXJjaHwzfHxmaXRuZXNzJTIwdHJhaW5pbmclMjBneW18ZW58MHx8fHwxNzczNDAyMTEwfDA&ixlib=rb-4.1.0&q=85";

const highlights = [
  "Personalized training plans from onboarding choices",
  "Habit streak tracking with daily completion",
  "Dashboard, workout sessions, and analytics in one system",
];

export default function AuthPage() {
  const navigate = useNavigate();
  const { login, register } = useAuth();
  const [mode, setMode] = useState("register");
  const [form, setForm] = useState({ name: "", email: "", password: "" });
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const isRegister = mode === "register";

  const subtitle = useMemo(
    () =>
      isRegister
        ? "Create your account to save your personalized Habitz system."
        : "Welcome back. Your routines, workouts, and progress are waiting.",
    [isRegister],
  );

  const handleSubmit = async (event) => {
    event.preventDefault();
    setSubmitting(true);
    setError("");

    try {
      const user = isRegister
        ? await register(form)
        : await login({ email: form.email, password: form.password });
      navigate(user.onboarding_completed ? "/app/dashboard" : "/onboarding", { replace: true });
    } catch (submissionError) {
      setError(submissionError?.response?.data?.detail || "Unable to continue. Please try again.");
    } finally {
      setSubmitting(false);
    }
  };

  const handleGoogleAuth = () => {
    // REMINDER: DO NOT HARDCODE THE URL, OR ADD ANY FALLBACKS OR REDIRECT URLS, THIS BREAKS THE AUTH
    const redirectUrl = window.location.origin + "/app/dashboard";
    window.location.href = `https://auth.emergentagent.com/?redirect=${encodeURIComponent(redirectUrl)}`;
  };

  return (
    <div className="min-h-screen bg-[radial-gradient(circle_at_top,_rgba(163,230,53,0.12),_transparent_28%),linear-gradient(135deg,#07110c,#0a1c17_40%,#081513)] text-white">
      <div className="mx-auto grid min-h-screen max-w-7xl gap-8 px-4 py-8 sm:px-6 lg:grid-cols-[1.1fr_0.9fr] lg:px-10 lg:py-10">
        <section className="relative overflow-hidden rounded-[36px] border border-white/10 bg-slate-950/40 p-6 backdrop-blur sm:p-8" data-testid="auth-hero-section">
          <div className="absolute inset-0">
            <img
              alt="Fitness training"
              className="h-full w-full object-cover opacity-30"
              data-testid="auth-hero-image"
              src={heroImage}
            />
          </div>
          <div className="absolute inset-0 bg-gradient-to-br from-black/30 via-slate-950/70 to-slate-950/90" />

          <div className="relative z-10 flex h-full flex-col justify-between gap-10">
            <div>
              <div className="inline-flex items-center gap-2 rounded-full border border-lime-300/25 bg-lime-300/10 px-4 py-2 text-xs uppercase tracking-[0.32em] text-lime-200" data-testid="auth-hero-badge">
                <Dumbbell className="h-3.5 w-3.5" />
                Habitz MVP
              </div>
              <h1 className="mt-6 max-w-2xl text-4xl font-black tracking-tight sm:text-5xl lg:text-6xl" data-testid="auth-hero-title">
                Train with a plan that actually reflects your onboarding choices.
              </h1>
              <p className="mt-5 max-w-xl text-base text-white/75 sm:text-lg" data-testid="auth-hero-subtitle">
                No more generic recommendations. Habitz now personalizes your fitness system across sex selection, level, goals, habits, and equipment.
              </p>
            </div>

            <div className="grid gap-4 md:grid-cols-3">
              {highlights.map((item, index) => (
                <div
                  key={item}
                  className="rounded-[28px] border border-white/10 bg-white/10 p-4 shadow-[0_18px_80px_rgba(0,0,0,0.22)] backdrop-blur"
                  data-testid={`auth-highlight-card-${index + 1}`}
                >
                  <CheckCircle2 className="h-5 w-5 text-lime-300" />
                  <p className="mt-3 text-sm leading-6 text-white/78">{item}</p>
                </div>
              ))}
            </div>
          </div>
        </section>

        <section className="flex items-center justify-center">
          <Card className="w-full max-w-xl rounded-[36px] border-white/10 bg-white/8 text-white shadow-[0_30px_100px_rgba(0,0,0,0.28)] backdrop-blur-xl" data-testid="auth-form-card">
            <CardContent className="space-y-6 p-6 sm:p-8">
              <div className="flex items-center justify-between gap-3 rounded-full border border-white/10 bg-white/5 p-1" data-testid="auth-mode-switcher">
                <button
                  className={`flex-1 rounded-full px-4 py-3 text-sm font-semibold transition ${isRegister ? "bg-lime-300 text-slate-950" : "text-white/70"}`}
                  data-testid="auth-register-mode-button"
                  onClick={() => setMode("register")}
                  type="button"
                >
                  Create account
                </button>
                <button
                  className={`flex-1 rounded-full px-4 py-3 text-sm font-semibold transition ${!isRegister ? "bg-lime-300 text-slate-950" : "text-white/70"}`}
                  data-testid="auth-login-mode-button"
                  onClick={() => setMode("login")}
                  type="button"
                >
                  Sign in
                </button>
              </div>

              <div>
                <h2 className="text-3xl font-black" data-testid="auth-form-title">
                  {isRegister ? "Create your Habitz account" : "Sign in to Habitz"}
                </h2>
                <p className="mt-2 text-sm text-white/65" data-testid="auth-form-subtitle">
                  {subtitle}
                </p>
              </div>

              <Button
                className="h-12 w-full rounded-full border border-white/10 bg-white text-slate-950 hover:bg-lime-100"
                data-testid="auth-google-button"
                onClick={handleGoogleAuth}
                type="button"
                variant="ghost"
              >
                <ShieldCheck className="mr-2 h-4 w-4" />
                Continue with Google
              </Button>

              <div className="relative text-center text-xs uppercase tracking-[0.28em] text-white/35" data-testid="auth-divider">
                <span className="relative z-10 bg-[#0a1914] px-4">or continue with email</span>
                <div className="absolute left-0 right-0 top-1/2 h-px -translate-y-1/2 bg-white/10" />
              </div>

              <form className="space-y-4" onSubmit={handleSubmit}>
                {isRegister ? (
                  <div className="space-y-2">
                    <label className="text-sm font-medium text-white/70" htmlFor="name">
                      Name
                    </label>
                    <Input
                      className="h-12 rounded-2xl border-white/10 bg-white/5 text-white placeholder:text-white/35"
                      data-testid="auth-name-input"
                      id="name"
                      onChange={(event) => setForm((current) => ({ ...current, name: event.target.value }))}
                      placeholder="Jordan Carter"
                      required
                      value={form.name}
                    />
                  </div>
                ) : null}

                <div className="space-y-2">
                  <label className="text-sm font-medium text-white/70" htmlFor="email">
                    Email
                  </label>
                  <Input
                    className="h-12 rounded-2xl border-white/10 bg-white/5 text-white placeholder:text-white/35"
                    data-testid="auth-email-input"
                    id="email"
                    onChange={(event) => setForm((current) => ({ ...current, email: event.target.value }))}
                    placeholder="you@example.com"
                    required
                    type="email"
                    value={form.email}
                  />
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-medium text-white/70" htmlFor="password">
                    Password
                  </label>
                  <Input
                    className="h-12 rounded-2xl border-white/10 bg-white/5 text-white placeholder:text-white/35"
                    data-testid="auth-password-input"
                    id="password"
                    onChange={(event) => setForm((current) => ({ ...current, password: event.target.value }))}
                    placeholder="At least 8 characters"
                    required
                    type="password"
                    value={form.password}
                  />
                </div>

                {error ? (
                  <div className="rounded-2xl border border-rose-400/25 bg-rose-400/10 px-4 py-3 text-sm text-rose-100" data-testid="auth-error-message">
                    {error}
                  </div>
                ) : null}

                <Button className="h-12 w-full rounded-full bg-lime-300 text-slate-950 hover:bg-lime-200" data-testid="auth-submit-button" disabled={submitting} type="submit">
                  {submitting ? "Please wait..." : isRegister ? "Create account" : "Sign in"}
                  <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
              </form>
            </CardContent>
          </Card>
        </section>
      </div>
    </div>
  );
}
