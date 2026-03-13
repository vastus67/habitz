import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { ArrowLeft, ArrowRight, CheckCircle2 } from "lucide-react";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { useAuth } from "@/context/auth-context";
import { getData, postData } from "@/lib/api";

export default function PlanDetailPage() {
  const { planId } = useParams();
  const navigate = useNavigate();
  const { user, setUser } = useAuth();
  const [plan, setPlan] = useState(null);

  useEffect(() => {
    let active = true;
    getData(`/plans/${planId}`).then((data) => {
      if (active) setPlan(data.plan);
    });
    return () => {
      active = false;
    };
  }, [planId]);

  if (!plan) {
    return (
      <div className="rounded-[32px] border border-white/10 bg-white/5 p-10 text-center text-white/65" data-testid="plan-detail-loading-state">
        Loading plan detail...
      </div>
    );
  }

  const isActive = user?.active_plan_id === plan.plan_id;

  const handleActivate = async () => {
    const data = await postData(`/plans/${plan.plan_id}/activate`);
    setUser(data.user);
    toast.success("Plan activated.");
  };

  return (
    <div className="space-y-6" data-testid="plan-detail-page">
      <button className="inline-flex items-center gap-2 text-sm font-medium text-white/70 hover:text-white" data-testid="plan-detail-back-button" onClick={() => navigate("/app/plans")} type="button">
        <ArrowLeft className="h-4 w-4" />
        Back to plans
      </button>

      <Card className="overflow-hidden rounded-[34px] border-white/10 bg-white/5 text-white" data-testid="plan-detail-hero-card">
        <div className="aspect-[16/6] overflow-hidden">
          <img alt={plan.name} className="h-full w-full object-cover" data-testid="plan-detail-image" src={plan.hero_image} />
        </div>
        <CardContent className="space-y-6 p-6 lg:p-8">
          <div className="flex flex-wrap items-start justify-between gap-4">
            <div>
              <p className="text-xs uppercase tracking-[0.28em] text-lime-200/80">Workout detail</p>
              <h1 className="mt-3 text-4xl font-black" data-testid="plan-detail-name">{plan.name}</h1>
              <p className="mt-4 max-w-3xl text-sm leading-7 text-white/65" data-testid="plan-detail-description">{plan.description}</p>
            </div>
            <Button className={`rounded-full ${isActive ? "bg-lime-300 text-slate-950 hover:bg-lime-200" : "bg-white/10 text-white hover:bg-white/15"}`} data-testid="plan-detail-activate-button" onClick={handleActivate}>
              {isActive ? (
                <>
                  <CheckCircle2 className="mr-2 h-4 w-4" />
                  Active now
                </>
              ) : (
                "Make active"
              )}
            </Button>
          </div>

          <div className="grid gap-4 md:grid-cols-4">
            {[
              ["Goal", plan.goal],
              ["Level", plan.level],
              ["Equipment", plan.equipment],
              ["Schedule", `${plan.days_per_week} days/week`],
            ].map(([label, value]) => (
              <div className="rounded-[24px] border border-white/10 bg-black/20 p-4" data-testid={`plan-detail-stat-${label.toLowerCase()}`} key={label}>
                <p className="text-xs uppercase tracking-[0.24em] text-white/45">{label}</p>
                <p className="mt-2 text-lg font-semibold">{value}</p>
              </div>
            ))}
          </div>

          <div className="grid gap-3 sm:grid-cols-3">
            {plan.highlights.map((item) => (
              <div className="rounded-[24px] border border-lime-300/15 bg-lime-300/8 px-4 py-4 text-sm text-lime-50" data-testid={`plan-detail-highlight-${item.replace(/\s+/g, '-').toLowerCase()}`} key={item}>
                {item}
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      <Card className="rounded-[34px] border-white/10 bg-white/5 text-white" data-testid="plan-detail-days-card">
        <CardContent className="space-y-4 p-6 lg:p-8">
          <div className="flex items-center justify-between gap-4">
            <div>
              <p className="text-xs uppercase tracking-[0.28em] text-white/45">Workout days</p>
              <h2 className="mt-2 text-3xl font-black">Session breakdown</h2>
            </div>
            <Button className="rounded-full bg-lime-300 text-slate-950 hover:bg-lime-200" data-testid="plan-detail-start-first-day-button" onClick={() => navigate(`/app/workout/${plan.plan_id}/${plan.days[0].day_id}`)}>
              Start first day
              <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </div>

          <div className="space-y-3">
            {plan.days.map((day) => (
              <div className="flex flex-wrap items-center justify-between gap-4 rounded-[28px] border border-white/10 bg-black/20 p-4" data-testid={`plan-detail-day-${day.day_id}`} key={day.day_id}>
                <div>
                  <p className="text-xs uppercase tracking-[0.24em] text-white/45">Day {day.day_index}</p>
                  <p className="mt-1 text-xl font-semibold" data-testid={`plan-detail-day-title-${day.day_id}`}>{day.title}</p>
                  <p className="mt-2 text-sm text-white/60">{day.focus} • {day.exercises.length} exercises</p>
                </div>
                <Button className="rounded-full bg-white/10 text-white hover:bg-white/15" data-testid={`plan-detail-open-day-button-${day.day_id}`} onClick={() => navigate(`/app/workout/${plan.plan_id}/${day.day_id}`)}>
                  Open day
                </Button>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
