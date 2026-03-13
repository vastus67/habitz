import { useEffect, useRef } from "react";
import { BrowserRouter, Navigate, Route, Routes, useLocation, useNavigate } from "react-router-dom";
import { toast } from "sonner";

import { AppShell } from "@/components/app-shell";
import { AuthProvider, useAuth } from "@/context/auth-context";
import AnalyticsPage from "@/pages/AnalyticsPage";
import AuthPage from "@/pages/AuthPage";
import DashboardPage from "@/pages/DashboardPage";
import HabitsPage from "@/pages/HabitsPage";
import OnboardingPage from "@/pages/OnboardingPage";
import PlanDetailPage from "@/pages/PlanDetailPage";
import PlansPage from "@/pages/PlansPage";
import ProfilePage from "@/pages/ProfilePage";
import WorkoutDayPage from "@/pages/WorkoutDayPage";

function FullscreenLoader({ label, testId }) {
  return (
    <div className="flex min-h-screen items-center justify-center bg-[radial-gradient(circle_at_top,_rgba(163,230,53,0.16),_transparent_30%),#07110c] px-4 text-center text-white/70" data-testid={testId}>
      <div>
        <div className="mx-auto h-12 w-12 animate-spin rounded-full border-2 border-white/15 border-t-lime-300" />
        <p className="mt-4 text-sm uppercase tracking-[0.3em]">{label}</p>
      </div>
    </div>
  );
}

function AuthCallbackPage() {
  const navigate = useNavigate();
  const hasProcessed = useRef(false);
  const { handleGoogleSession, setLoading } = useAuth();

  useEffect(() => {
    if (hasProcessed.current) return;
    hasProcessed.current = true;

    const hash = window.location.hash.replace(/^#/, "");
    const params = new URLSearchParams(hash);
    const sessionId = params.get("session_id");

    if (!sessionId) {
      setLoading(false);
      navigate("/auth", { replace: true });
      return;
    }

    (async () => {
      try {
        const user = await handleGoogleSession(sessionId);
        window.history.replaceState({}, document.title, window.location.pathname);
        navigate(user.onboarding_completed ? "/app/dashboard" : "/onboarding", { replace: true });
      } catch (error) {
        toast.error(error?.response?.data?.detail || "Google sign-in failed.");
        navigate("/auth", { replace: true });
      } finally {
        setLoading(false);
      }
    })();
  }, [handleGoogleSession, navigate, setLoading]);

  return <FullscreenLoader label="Connecting your Google account" testId="auth-callback-loader" />;
}

function AuthRoute() {
  const { user, loading } = useAuth();

  if (loading) {
    return <FullscreenLoader label="Loading Habitz" testId="auth-route-loader" />;
  }

  if (user) {
    return <Navigate replace to={user.onboarding_completed ? "/app/dashboard" : "/onboarding"} />;
  }

  return <AuthPage />;
}

function OnboardingRoute() {
  const { user, loading } = useAuth();

  if (loading) {
    return <FullscreenLoader label="Loading onboarding" testId="onboarding-route-loader" />;
  }

  if (!user) {
    return <Navigate replace to="/auth" />;
  }

  if (user.onboarding_completed) {
    return <Navigate replace to="/app/dashboard" />;
  }

  return <OnboardingPage />;
}

function ProtectedShell() {
  const { user, loading } = useAuth();

  if (loading) {
    return <FullscreenLoader label="Loading your dashboard" testId="protected-shell-loader" />;
  }

  if (!user) {
    return <Navigate replace to="/auth" />;
  }

  if (!user.onboarding_completed) {
    return <Navigate replace to="/onboarding" />;
  }

  return <AppShell />;
}

function RootRedirect() {
  const { user, loading } = useAuth();

  if (loading) {
    return <FullscreenLoader label="Opening Habitz" testId="root-loader" />;
  }

  if (!user) {
    return <Navigate replace to="/auth" />;
  }

  return <Navigate replace to={user.onboarding_completed ? "/app/dashboard" : "/onboarding"} />;
}

function AppRoutes() {
  const location = useLocation();

  if (window.location.hash?.includes("session_id=")) {
    return <AuthCallbackPage />;
  }

  return (
    <Routes>
      <Route element={<RootRedirect />} path="/" />
      <Route element={<AuthRoute />} path="/auth" />
      <Route element={<OnboardingRoute />} path="/onboarding" />
      <Route element={<ProtectedShell />} path="/app">
        <Route element={<Navigate replace to="dashboard" />} index />
        <Route element={<DashboardPage />} path="dashboard" />
        <Route element={<PlansPage />} path="plans" />
        <Route element={<PlanDetailPage />} path="plans/:planId" />
        <Route element={<WorkoutDayPage />} path="workout/:planId/:dayId" />
        <Route element={<HabitsPage />} path="habits" />
        <Route element={<AnalyticsPage />} path="analytics" />
        <Route element={<ProfilePage />} path="profile" />
      </Route>
      <Route element={<Navigate replace to={location.pathname.startsWith("/app") ? "/app/dashboard" : "/"} />} path="*" />
    </Routes>
  );
}

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <AppRoutes />
      </BrowserRouter>
    </AuthProvider>
  );
}
