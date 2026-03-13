import { NavLink, Outlet, useLocation, useNavigate } from "react-router-dom";
import { BarChart3, Dumbbell, Home, LogOut, Sparkles, UserRound } from "lucide-react";

import { Button } from "@/components/ui/button";
import { useAuth } from "@/context/auth-context";

const navigation = [
  { to: "/app/dashboard", label: "Dashboard", icon: Home, testId: "shell-nav-dashboard-link" },
  { to: "/app/plans", label: "Plans", icon: Dumbbell, testId: "shell-nav-plans-link" },
  { to: "/app/habits", label: "Habits", icon: Sparkles, testId: "shell-nav-habits-link" },
  { to: "/app/analytics", label: "Analytics", icon: BarChart3, testId: "shell-nav-analytics-link" },
  { to: "/app/profile", label: "Profile", icon: UserRound, testId: "shell-nav-profile-link" },
];

export function AppShell() {
  const { logout, user } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const handleLogout = async () => {
    await logout();
    navigate("/auth", { replace: true });
  };

  return (
    <div className="min-h-screen bg-[radial-gradient(circle_at_top_left,_rgba(163,230,53,0.18),_transparent_28%),radial-gradient(circle_at_top_right,_rgba(56,189,248,0.18),_transparent_26%),#07110c] text-white">
      <div className="mx-auto flex min-h-screen w-full max-w-[1600px] flex-col lg:flex-row">
        <aside className="border-b border-white/10 bg-white/5 backdrop-blur lg:min-h-screen lg:w-[280px] lg:border-b-0 lg:border-r">
          <div className="flex items-center justify-between gap-4 px-6 py-6 lg:block">
            <div>
              <p className="text-xs uppercase tracking-[0.35em] text-lime-300/70" data-testid="shell-brand-kicker">
                Habitz System
              </p>
              <h1 className="mt-2 text-3xl font-black tracking-tight" data-testid="shell-brand-title">
                Built for motion.
              </h1>
              <p className="mt-2 max-w-xs text-sm text-white/65" data-testid="shell-brand-subtitle">
                Personal habits, training structure, and analytics tuned to your onboarding profile.
              </p>
            </div>
            <Button
              className="hidden rounded-full bg-white/10 px-5 text-white hover:bg-white/20 lg:inline-flex"
              data-testid="shell-logout-button-desktop"
              onClick={handleLogout}
              variant="ghost"
            >
              <LogOut className="mr-2 h-4 w-4" />
              Sign out
            </Button>
          </div>

          <div className="px-4 pb-4 lg:px-6">
            <div
              className="mb-5 rounded-[28px] border border-white/10 bg-black/20 p-4"
              data-testid="shell-user-summary"
            >
              <p className="text-xs uppercase tracking-[0.28em] text-white/50">Current athlete</p>
              <div className="mt-3 flex items-center gap-3">
                <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-lime-300 text-lg font-bold text-slate-950" data-testid="shell-user-avatar">
                  {(user?.name || "A").slice(0, 1).toUpperCase()}
                </div>
                <div>
                  <p className="font-semibold" data-testid="shell-user-name">{user?.name}</p>
                  <p className="text-sm text-white/60" data-testid="shell-user-email">{user?.email}</p>
                </div>
              </div>
            </div>

            <nav className="flex gap-2 overflow-x-auto pb-2 lg:flex-col" data-testid="shell-navigation">
              {navigation.map((item) => {
                const Icon = item.icon;
                return (
                  <NavLink
                    key={item.to}
                    className={({ isActive }) =>
                      [
                        "group inline-flex min-w-fit items-center gap-3 rounded-full border px-4 py-3 text-sm font-medium transition duration-200 lg:rounded-2xl",
                        isActive
                          ? "border-lime-300/30 bg-lime-300/15 text-lime-200"
                          : "border-white/10 bg-white/5 text-white/70 hover:border-white/20 hover:bg-white/10 hover:text-white",
                      ].join(" ")
                    }
                    data-testid={item.testId}
                    to={item.to}
                  >
                    <Icon className="h-4 w-4" />
                    <span>{item.label}</span>
                  </NavLink>
                );
              })}
            </nav>
          </div>

          <div className="px-4 pb-6 lg:hidden">
            <Button
              className="w-full rounded-full bg-white/10 text-white hover:bg-white/20"
              data-testid="shell-logout-button-mobile"
              onClick={handleLogout}
              variant="ghost"
            >
              <LogOut className="mr-2 h-4 w-4" />
              Sign out
            </Button>
          </div>
        </aside>

        <main className="min-w-0 flex-1 px-4 py-5 sm:px-6 lg:px-10 lg:py-8">
          <div className="mb-6 flex flex-wrap items-end justify-between gap-4 rounded-[32px] border border-white/10 bg-white/5 px-6 py-5 backdrop-blur">
            <div>
              <p className="text-xs uppercase tracking-[0.28em] text-white/45">Current route</p>
              <h2 className="mt-2 text-3xl font-black capitalize" data-testid="shell-current-route">
                {location.pathname.split("/").filter(Boolean).slice(-1)[0] || "dashboard"}
              </h2>
            </div>
            <div className="text-right">
              <p className="text-sm text-white/55">Profile-driven personalization is active.</p>
              <p className="mt-2 text-sm text-lime-200" data-testid="shell-personalization-summary">
                {user?.sex_variant || "pending"} • {user?.fitness_level || "pending"} • {user?.equipment || "pending"}
              </p>
            </div>
          </div>

          <Outlet />
        </main>
      </div>
    </div>
  );
}
