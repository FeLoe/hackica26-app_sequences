# Sequence Mining in App Data — ICA 2026 Hackathon

Hackathon project for [ICA 2026](https://www.icahdq.org/page/ICA2026) in Stellenbosch.
We analyze sequences of smartphone app use, treating each participant's app history
as an ordered sequence of events and applying six computational methods to uncover
temporal patterns.

This project replicates and extends the six analytical approaches from:

> Fan, Y., Ohme, J., & Wedel, L. (2026). Exploring temporal dynamics in digital trace data: mining user-sequences for communication research. *Communication Methods and Measures*, 1–28. https://doi.org/10.1080/19312458.2026.2664873

The original code (Python) is at [YangliuF95/DTD_sequence_mining](https://github.com/YangliuF95/DTD_sequence_mining). We reimplement the analyses in **R**, using R-native packages where applicable.

---

## Research questions

The core idea: represent each participant's app usage log as an ordered sequence of
events, then ask:

- What are typical app-use patterns across the day and week?
- How does app use at time *t* depend on what came before?
- Are there latent user types or behavioral states?
- Which app-to-app transitions are most common, and do apps cluster into communities?

---

## Analytical approaches

All analyses live in `R/` as self-contained Quarto documents (`.qmd`).
Each file loads the real data from `_files/` and caches expensive intermediate
results to `R/results/tables/`.

### 1. Sequence Analysis (`R/01_sequence_analysis.qmd`)
**R packages:** `TraMineR`, `TraMineRextras`, `colorspace`, `cluster`

Represent each participant's app history as a discrete state sequence, compute
pairwise optimal-matching (OM) distances, cluster participants into trajectory
types, and visualise with sequence index plots and state distribution plots.
Also includes n-gram motif analysis with Bonferroni significance testing.

### 2. Event History Analysis (`R/02_event_history.qmd`)
**R packages:** `survival`, `survminer`, `broom`

Model the timing of app switches as survival data. Kaplan-Meier curves show
how long participants stay on an app before switching, stratified by app and
category. Cox proportional hazards models test predictors of switching hazard
including time of day, weekday, and position within a phone session.

### 3. Hidden Markov Models (`R/03_hidden_markov.qmd`)
**R package:** `depmixS4`

Fit categorical HMMs to infer latent behavioral states from the observable
sequence of app uses. Model selection via AIC/BIC over k = 2–6 states. Outputs
include the transition matrix, emission probabilities per state, and Viterbi-decoded
state sequences visualised by hour of day.

### 4. Network Analysis (`R/04_network_analysis.qmd`)
**R packages:** `igraph`, `tidygraph`, `ggraph`

Build a directed weighted transition network from consecutive app pairs.
Compute centrality measures (degree, betweenness, eigenvector) and detect
communities. Includes both app-level and category-level networks, plus a
within-session network using `phone_session_id`.

### 5. Process Mining (`R/05_process_mining.qmd`)
**R packages:** `bupaR`, `processmapR`, `heuristicsmineR`

Treat each person-day as a process case and each app use as an event.
Plots event distributions by hour and weekday, a category transition duration
heatmap, and a category-level directly-follows process map with start/end
activity analysis.

### 6. Language-Based Models (`R/06_language_models.qmd`)
**R packages:** `word2vec`, `doc2vec`, `Rtsne`, `umap`

Treat app sequences as text. Activity2Vec (Word2Vec) learns embeddings for
each app token. Person2Vec (Doc2Vec) trains on per-day documents and averages
to produce one embedding per participant, enabling person-level clustering and
trajectory visualisation through the embedding space.

---

## Repository structure

```
hackica26-app_sequences/
├── README.md
├── R/
│   ├── utils.R                  # shared constants, palette, and merge_consecutive()
│   ├── 01_sequence_analysis.qmd
│   ├── 02_event_history.qmd
│   ├── 03_hidden_markov.qmd
│   ├── 04_network_analysis.qmd
│   ├── 05_process_mining.qmd
│   └── 06_language_models.qmd
└── .gitignore
```

---

## Data

**Source:** `d_apps_anonymized.csv` — app usage logs collected
via the Murmuras passive tracking app. Cannot be shared publicly.

Relevant columns:

| Column             | Description |
|--------------------|-------------|
| `participant_code` | Participant identifier; links to survey data |
| `app_name`         | Displayed app name (e.g., "Instagram", "Kalender") |
| `package_name`     | Unique Android package name (e.g., `com.instagram.android`) |
| `start_time`       | App session start (use this, not the epoch columns) |
| `end_time`         | App session end |
| `Duration`         | Duration in seconds (pre-computed) |
| `phone_session_id` | Increments on each phone unlock (non-monotonic, resets irregularly — use for grouping only) |
| `app_session_id`   | App-flow ID; has gaps for privacy-blacklisted apps (e.g., WhatsApp) |

App categories (`app_category`) are not in the raw file — they are provided
separately by the project as a `package_name → app_category` lookup.

> **Note:** `seen_timestamp` and `end_timestamp` in the raw file are epoch/UNIX
> values with a ~2 h CEST offset. Always use `start_time` / `end_time` instead.

---

## Getting started

```r
install.packages(c(
  # Core
  "tidyverse",
  # Method 1 — sequence analysis
  "TraMineR", "TraMineRextras", "colorspace", "cluster",
  # Method 2 — event history
  "survival", "survminer", "broom", "car",
  # Method 3 — hidden Markov models
  "depmixS4",
  # Method 4 — network analysis
  "igraph", "tidygraph", "ggraph", "ggrepel",
  # Method 5 — process mining
  "bupaR", "processmapR",
  # Method 6 — language models
  "word2vec", "doc2vec", "Rtsne", "umap",
  # Shared utilities
  "patchwork", "scales", "RColorBrewer", "here"
))
```

To run an analysis, open the relevant `.qmd` file in RStudio and click
**Render**, or run `quarto render R/01_sequence_analysis.qmd` from the terminal.
Place the data file at `_files/d_apps_anonymized.csv` before rendering.

---

## Reference

```bibtex
@article{Fan2026,
  author  = {Yangliu Fan and Jakob Ohme and Lion Wedel},
  doi     = {10.1080/19312458.2026.2664873},
  journal = {Communication Methods and Measures},
  pages   = {1--28},
  title   = {Exploring temporal dynamics in digital trace data: mining user-sequences for communication research},
  year    = {2026}
}
```
