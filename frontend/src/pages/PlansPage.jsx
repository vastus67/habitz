import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowRight, CheckCircle2, Target } from "lucide-react";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { useAuth } from "@/context/auth-context";
import { getData, postData } from "@/lib/api";

export default function PlansPage() {
  const navigate = useNavigate();
  const { setUser, user } = useAuth();
  const [plans, setPlans] = useState([]);

  useEffect(() => {
    let active = true;
    getData("/plans").then((data) => {
      if (active) setPlans(data.plans);
    });
    return () => {
      active = false;
    };
  }, []);

  const activatePlan = async (planId) => {
    const data = await postData(`/plans/${planId}/activate`);
    setUser(data.user);
    toast.success("Active plan updated.");
  };

  return (
    <div className="space-y-6" data-testid="plans-page">
      <Card className="rounded-[34px] border-white/10 bg-white/5 text-white" data-testid="plans-header-card">
        <CardContent className="flex flex-wrap items-end justify-between gap-4 p-6">
          <div>
            <p className="text-xs uppercase tracking-[0.28em] text-white/45">Plan library</p>
            <h1 className="mt-2 text-4xl font-black" data-testid="plans-title">Personalized workout plans</h1>
            <p className="mt-3 max-w-3xl text-sm leading-7 text-white/65" data-testid="plans-subtitle">
              Your plan list respects your onboarding choices. Opposite-sex variants are filtered out so the recommendations stay relevant.
            </p>
          </div>
          <div className="rounded-full border border-lime-300/20 bg-lime-300/10 px-4 py-2 text-sm text-lime-200" data-testid="plans-active-profile-chip">
            {user?.sex_variant || "pending"} • {user?.fitness_level || "pending"} • {user?.equipment || "pending"}
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-5 xl:grid-cols-2" data-testid="plans-grid">
        {plans.map((plan) => {
          const isActive = user?.active_plan_id === plan.plan_id;
          return (
            <Card className="overflow-hidden rounded-[32px] border-white/10 bg-white/5 text-white transition hover:-translate-y-1 hover:bg-white/10" data-testid={`plan-card-${plan.plan_id}`} key={plan.plan_id}>
              <div className="aspect-[16/8] overflow-hidden">
                <img alt={plan.name} className="h-full w-full object-cover" data-testid={`plan-card-image-${plan.plan_id}`} src={plan.hero_image} />
              </div>
              <CardContent className="space-y-5 p-6">
                <div className="flex flex-wrap items-start justify-between gap-3">
                  <div>
                    <p className="text-2xl font-black" data-testid={`plan-card-name-${plan.plan_id}`}>{plan.name}</p>
                    <p className="mt-2 text-sm leading-7 text-white/65">{plan.description}</p>
                  </div>
                  {typeof plan.match_score === "number" ? (
                    <span className="rounded-full border border-lime-300/25 bg-lime-300/10 px-3 py-1 text-xs uppercase tracking-[0.24em] text-lime-200" data-testid={`plan-card-match-${plan.plan_id}`}>
                      Match {plan.match_score}
                    </span>
                  ) : null}
                </div>

                <div className="flex flex-wrap gap-2 text-xs text-white/60">
                  {[plan.sex_variant, plan.level, plan.equipment, `${plan.days_per_week} days/week`].map((chip) => (
                    <span className="rounded-full border border-white/10 px-3 py-1" data-testid={`plan-card-chip-${plan.plan_id}-${chip.replace(/\s+/g, '-').toLowerCase()}`} key={chip}>
                      {chip}
                    </span>
                  ))}
                </div>

                <div className="grid gap-3 sm:grid-cols-3">
                  {plan.highlights.map((item) => (
                    <div className="rounded-2xl border border-white/10 bg-black/20 px-3 py-3 text-sm text-white/75" data-testid={`plan-card-highlight-${plan.plan_id}-${item.replace(/\s+/g, '-').toLowerCase()}`} key={item}>
                      {item}
                    </div>
                  ))}
                </div>

                <div className="flex flex-wrap items-center justify-between gap-3">
                  <button className="inline-flex items-center gap-2 text-sm font-medium text-sky-200" data-testid={`plan-card-detail-button-${plan.plan_id}`} onClick={() => navigate(`/app/plans/${plan.plan_id}`)} type="button">
                    View full plan
                    <ArrowRight className="h-4 w-4" />
                  </button>

                  <Button className={`rounded-full ${isActive ? "bg-lime-300 text-slate-950 hover:bg-lime-200" : "bg-white/10 text-white hover:bg-white/15"}`} data-testid={`plan-card-activate-button-${plan.plan_id}`} onClick={() => activatePlan(plan.plan_id)}>
                    {isActive ? (
                      <>
                        <CheckCircle2 className="mr-2 h-4 w-4" />
                        Active plan
                      </>
                    ) : (
                      <>
                        <Target className="mr-2 h-4 w-4" />
                        Make active
                      </>
                    )}
                  </Button>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
