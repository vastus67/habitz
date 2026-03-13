import { useEffect, useState } from "react";
import { Area, AreaChart, Bar, BarChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";

import { Card, CardContent } from "@/components/ui/card";
import { getData } from "@/lib/api";

export default function AnalyticsPage() {
  const [analytics, setAnalytics] = useState(null);

  useEffect(() => {
    let active = true;
    getData("/analytics").then((data) => {
      if (active) setAnalytics(data);
    });
    return () => {
      active = false;
    };
  }, []);

  if (!analytics) {
    return (
      <div className="rounded-[32px] border border-white/10 bg-white/5 p-10 text-center text-white/65" data-testid="analytics-loading-state">
        Loading analytics...
      </div>
    );
  }

  return (
    <div className="space-y-6" data-testid="analytics-page">
      <Card className="rounded-[34px] border-white/10 bg-white/5 text-white" data-testid="analytics-header-card">
        <CardContent className="p-6">
          <p className="text-xs uppercase tracking-[0.28em] text-white/45">Progress intelligence</p>
          <h1 className="mt-2 text-4xl font-black" data-testid="analytics-title">Performance analytics</h1>
          <p className="mt-3 text-sm leading-7 text-white/65" data-testid="analytics-subtitle">
            Review how your habits and workout completion are trending across the week.
          </p>
        </CardContent>
      </Card>

      <div className="grid gap-6 xl:grid-cols-[1.1fr_0.9fr]">
        <Card className="rounded-[32px] border-white/10 bg-white/5 text-white" data-testid="analytics-trend-card">
          <CardContent className="p-6">
            <p className="text-xs uppercase tracking-[0.28em] text-white/45">7-day completion</p>
            <div className="mt-6 h-[320px]" data-testid="analytics-trend-chart">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={analytics.trend}>
                  <defs>
                    <linearGradient id="habitzArea" x1="0" x2="0" y1="0" y2="1">
                      <stop offset="0%" stopColor="#a3e635" stopOpacity={0.6} />
                      <stop offset="100%" stopColor="#a3e635" stopOpacity={0.04} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid stroke="rgba(255,255,255,0.06)" vertical={false} />
                  <XAxis dataKey="label" stroke="rgba(255,255,255,0.45)" />
                  <YAxis stroke="rgba(255,255,255,0.45)" />
                  <Tooltip contentStyle={{ backgroundColor: "#07110c", border: "1px solid rgba(255,255,255,0.12)", borderRadius: 18 }} />
                  <Area dataKey="completion" fill="url(#habitzArea)" stroke="#bef264" strokeWidth={3} type="monotone" />
                </AreaChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        <Card className="rounded-[32px] border-white/10 bg-white/5 text-white" data-testid="analytics-breakdown-card">
          <CardContent className="space-y-4 p-6">
            <div>
              <p className="text-xs uppercase tracking-[0.28em] text-white/45">Summary</p>
              <h2 className="mt-2 text-3xl font-black">What the week says</h2>
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="rounded-[24px] border border-white/10 bg-black/20 p-4" data-testid="analytics-summary-habits">
                <p className="text-xs uppercase tracking-[0.24em] text-white/45">Habit completion</p>
                <p className="mt-2 text-3xl font-black text-lime-200">{analytics.habit_completion_rate}%</p>
              </div>
              <div className="rounded-[24px] border border-white/10 bg-black/20 p-4" data-testid="analytics-summary-workouts">
                <p className="text-xs uppercase tracking-[0.24em] text-white/45">Total workouts</p>
                <p className="mt-2 text-3xl font-black text-sky-200">{analytics.total_workouts}</p>
              </div>
            </div>
            <div className="h-[200px]" data-testid="analytics-bar-chart">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={analytics.trend}>
                  <CartesianGrid stroke="rgba(255,255,255,0.06)" vertical={false} />
                  <XAxis dataKey="label" stroke="rgba(255,255,255,0.45)" />
                  <YAxis stroke="rgba(255,255,255,0.45)" />
                  <Tooltip contentStyle={{ backgroundColor: "#07110c", border: "1px solid rgba(255,255,255,0.12)", borderRadius: 18 }} />
                  <Bar dataKey="habits" fill="#38bdf8" radius={[8, 8, 0, 0]} />
                  <Bar dataKey="workouts" fill="#a3e635" radius={[8, 8, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>
      </div>

      <Card className="rounded-[32px] border-white/10 bg-white/5 text-white" data-testid="analytics-recent-workouts-card">
        <CardContent className="space-y-4 p-6">
          <div>
            <p className="text-xs uppercase tracking-[0.28em] text-white/45">Recent sessions</p>
            <h2 className="mt-2 text-3xl font-black">Workout log</h2>
          </div>
          <div className="overflow-x-auto">
            <table className="min-w-full text-left text-sm" data-testid="analytics-recent-workouts-table">
              <thead>
                <tr className="text-white/45">
                  <th className="pb-3 pr-4">Plan</th>
                  <th className="pb-3 pr-4">Day</th>
                  <th className="pb-3 pr-4">Duration</th>
                  <th className="pb-3">Effort</th>
                </tr>
              </thead>
              <tbody>
                {analytics.recent_workouts.map((workout) => (
                  <tr className="border-t border-white/10" data-testid={`analytics-workout-row-${workout.session_log_id}`} key={workout.session_log_id}>
                    <td className="py-3 pr-4" data-testid={`analytics-workout-plan-${workout.session_log_id}`}>{workout.plan_name}</td>
                    <td className="py-3 pr-4" data-testid={`analytics-workout-day-${workout.session_log_id}`}>{workout.day_title}</td>
                    <td className="py-3 pr-4" data-testid={`analytics-workout-duration-${workout.session_log_id}`}>{workout.duration_minutes} min</td>
                    <td className="py-3" data-testid={`analytics-workout-effort-${workout.session_log_id}`}>{workout.effort}/10</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}