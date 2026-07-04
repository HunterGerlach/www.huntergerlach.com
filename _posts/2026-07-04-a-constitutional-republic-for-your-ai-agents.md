---
title: "A Constitutional Republic for Your AI Agents"
tags:
- ai
- agents
- architecture
- strategy
---

*What 250 years of American constitutional design can teach you about trusting agentic systems.*

Today, the United States turns 250.

Most of the attention will be on the celebration. Mine keeps drifting to the design. The most useful way to honor a founding is not nostalgia. It is to borrow the design pattern.

I should be clear about what this is. I am not a historian or a political scientist, and this is not a political post. I am an engineer working on a specific problem: how to safely delegate real work to AI agents. The anniversary just happens to put a 250-year-old answer to a similar problem back in the news.

Read through an engineer's eyes, the founding was a systems architecture problem. The Constitution is a governance framework for a country of non-deterministic agents: millions of humans who are unpredictable, self-interested, occasionally brilliant, and frequently wrong. The founders did not try to fix human nature. They built a structure that assumed it. Madison put the operating principle plainly in Federalist No. 51: "Ambition must be made to counteract ambition." And a few lines later: "If men were angels, no government would be necessary."

That may be the most relevant sentence in 18th-century political thought for the age of AI agents. Because agents are not angels either. They hallucinate. They inherit poisoned context. They produce confident nonsense. And they are moving from answering questions to taking actions: sending emails, opening pull requests, negotiating with other agents, spending money.

So the question is not: *Can I trust this agent?*

The better question is: *Can I trust the system that governs this agent?*

That is a different question. It is also the question constitutional government was built to answer.

## Start with the sovereign

Before the branches, the American design settles a prior question: who holds power in the first place? Not the government. The people. Every power the government has is delegated, enumerated, and revocable. That is what sovereignty means.

In your agent republic, the sovereign is you. Agents hold no native authority. Everything they can do is delegated from you, everything delegated is bounded, and everything bounded can be revoked. Agenda-setting stays with the sovereign too: agents work in response to your mandate, not their own.

Hold onto that, because every design choice below is downstream of it.

## The mistake most people make with agents

There are two obvious ways to use agents, and both fail.

The first is blind trust: ask the agent, accept the answer, let it act, hope it was right. This is how you get a model making a bad assumption, approving its own plan, and taking real-world action before anyone notices.

The second is exhaustive review: check every claim, approve every step manually. Safer, but it defeats the point. If the human must review everything, the human remains the bottleneck. The agent never becomes a delegate. It stays a typing accelerator.

The third path is constitutional:

**Let agents work. Do not let one agent hold all powers.**

That is the whole trick. Everything else is implementation detail.

## Law first, action second, judgment last

The Constitution lists the branches in a deliberate order. Article I is the legislature. Article II is the executive. Article III is the courts. I will not pretend to know everything the framers meant by that sequence. But read as a design document, it sketches a theory of a high-trust society: law comes first, because most behavior in a functioning society is governed by rules people have already internalized, not by a judge pre-approving every act. Action comes second, with real latitude inside the law. Judgment comes last, after the fact, and its rulings feed back into the law.

Agents deserve the same order.

**Legislative: write the law before any agent acts.** Policies, acceptance criteria, budgets, boundaries. Versioned, testable, scoped, expiring. A prompt is advice; a policy is law. If your standards live only in a prompt, you have suggestions, not standards. The sovereign ratifies the law. Agents can help draft it, but they do not enact it.

You do not need a complete legal code on day one. The founders did not write one either. They started with a bill of rights: a short list of hard limits no future law could cross, and left the rest to be worked out. Your agent republic starts the same way. A handful of inviolable rules from the first hour: never spend money, never send anything external without a signature, never modify your own policies. Everything else starts narrow and grows. New laws get written the way they always have: when an edge case finds you.

**Formation: evals are how agents grow up.** Here is the piece most agent architectures skip. Think about how a human becomes trustworthy. Nobody hands a teenager the car keys after a courtroom hearing. They get years of formation: prompts revised constantly, right and wrong reinforced daily, small freedoms extended and sometimes pulled back. Evals are that process for agents. Continuous testing against the law, before consequential authority is ever granted. An agent does not earn latitude by seeming smart. It earns latitude by passing the curriculum, repeatedly, under conditions that look like the real job. Formation is what allows judgment to move to the end instead of blocking every act.

**Executive: act within enumerated powers.** The executive branch is the only one that mutates state, so its powers are enumerated, not general. Inside its jurisdiction, it moves fast and does not stop to ask permission. At the edges, it hits structure, not persuasion: deterministic gates that no clever argument can talk past. This is the pattern underneath the whole design: stochastic in thought, deterministic in authority. The founders could only make usurpation punishable. A gate makes it impossible. And some actions, like an irreversible wire transfer, sit outside any agent's enumerated powers entirely and require the sovereign's signature. That is not distrust. That is the constitution doing its job.

**Judicial: review after, and let rulings compound.** With law written and formation done, judgment can sit where the framers put it: at the end. Review after the fact only works if there is a record worth reviewing, so every meaningful action produces a receipt: the mandate, the policy version, the evidence, the tool calls, the outcome, the rollback path. Not the agent's summary of the test run. The actual test output. Without receipts, after-the-fact review is theater. With them, the judicial function audits, adjudicates failures, and turns verdicts into precedent. A violation shrinks jurisdiction. A clean record expands it. Every ruling flows back into the law and the evals, so the system gets more trustworthy with use. Trust is jurisdiction: the calendar agent that safely rescheduled a hundred meetings earned autonomy for scheduling, not the right to move money.

## The operating loop

In practice, all of this runs as one loop:

**Law → Formation → Action → Receipt → Review → Amend**

The sovereign holds the pen at both ends. You write the law, and you ratify the amendments. In between, agents act with real latitude, bounded by structure, accountable to review.

The doctrine is short:

Let stochastic systems advise.
Let bounded systems act.
Let humans amend.

## The real promise

The promise of agents is not that they will be perfect. They will not be. The promise is that we can build systems where trust is earned before authority is granted, and mistakes are caught, judged, and compounded into better law. That is what constitutional government tried to do for human power. It did not make people angels. It made power safer to grant.

None of it works, though, if you treat non-determinism as a defect to be engineered away. It is the feature. The reason to delegate to an agent at all is that it can produce answers you did not specify in advance. The same range of possibility that makes an agent useful is what makes it risky, and you cannot keep one while eliminating the other. The engineering problem is combining non-deterministic judgment with deterministic authority so the variance lands where you can afford it. And that requires leaders to accept something uncomfortable: some level of risk is the price of the reward. A republic that tolerates no failure gets no initiative. The founders accepted that trade for people. We will have to accept it for agents.

Two hundred fifty years is one experiment, still running, and I hold the analogy loosely. But it is also the longest-running production system we have for governing non-deterministic agents at scale, and it would be strange not to borrow from it.

As America turns 250, that may be the best idea to carry forward into the agent age:

Do not build oracle machines. Build trust machinery.

Fast where reversible.
Careful where consequential.
Impossible where forbidden.
Audited where trusted.
Human where sovereign.
