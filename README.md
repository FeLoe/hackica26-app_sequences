# Sequence Mining in App Data — ICA 2026 Hackathon

Hackathon project for [ICA 2026](https://www.icahdq.org/page/ICA2026) in Stellenbosch.
We analyze sequences of user activities across social media apps (Facebook, YouTube, TikTok, Instagram) using digital trace data.

This project replicates and extends the six analytical approaches from:

> Fan, Y., Ohme, J., & Wedel, L. (2026). Exploring temporal dynamics in digital trace data: mining user-sequences for communication research. *Communication Methods and Measures*, 1–28. https://doi.org/10.1080/19312458.2026.2664873

The original code (Python) is at [YangliuF95/DTD_sequence_mining](https://github.com/YangliuF95/DTD_sequence_mining). We reimplement the analyses in **R**, using R-native packages where applicable.

---

## Research questions

The core idea: represent each user's activity log as an ordered sequence of events, then ask:

- What are typical activity patterns across and within platforms?
- How do activities at time *t* depend on activities at *t−1*, *t−2*, …?
- Are there latent user types or behavioral states?
- Which transitions between activity types are most common?

---

## Analytical approaches to replicate

### 1. Sequence Analysis (`R/01_sequence_analysis.R`)
**R package:** `TraMineR`

Represent each user's activity history as a state sequence, compute pairwise dissimilarities (e.g., OM distance), cluster users into trajectory types, and visualize sequence index plots and mean time in each state. The reference repo already includes a `TraMineR.R` starting point.

### 2. Event History Analysis (`R/02_event_history.R`)
**R packages:** `survival`, `survminer`

Model the timing of transitions between activity types as survival data. Estimate hazard rates for switching platforms or stopping an activity stream. Allows testing whether prior activities predict the time-to-next-event.

### 3. Hidden Markov Models (`R/03_hidden_markov.R`)
**R packages:** `depmixS4`, `seqHMM`

Fit HMMs to infer latent behavioral states from the observable sequence of app activities. Estimate the number of hidden states, emission probabilities per state, and transition matrix between states. Reveals underlying engagement patterns not visible in raw sequences.

### 4. Network Analysis (`R/04_network_analysis.R`)
**R packages:** `igraph`, `ggraph`

Build transition networks where nodes are activity types and weighted directed edges represent observed activity-to-activity transitions. Compute centrality measures to identify which activities act as hubs or gateways. Visualize cross-platform transition patterns.

### 5. Process Mining (`R/05_process_mining.R`)
**R packages:** `bupaR`, `processmapR`

Treat the activity log as an event log in the process mining sense. Mine frequent process variants (ordered subsequences), render process maps, and compute conformance with hypothesized behavioral models (e.g., "browse → react → search").

### 6. Language-Based Models (`R/06_language_models.R`)
**R packages:** `text2vec`, `word2vec`, or `tidytext` + embeddings

Treat each user's activity sequence as a "sentence" where activities are "words". Train sequence embeddings (e.g., activity2vec analogous to word2vec) to capture semantic similarity between activities and users based on co-occurrence patterns in sequences.

---

## Repository structure

```
hackica26-app_sequences/
├── README.md
├── data/
│   ├── raw/            # original data files — gitignored, not committed
│   └── processed/      # reshaped/cleaned data ready for analysis
├── R/
│   ├── 00_data_prep.R            # load, clean, reshape to sequence format
│   ├── 01_sequence_analysis.R    # TraMineR: state sequences, OM distance, clustering
│   ├── 02_event_history.R        # survival models for transition timing
│   ├── 03_hidden_markov.R        # HMMs for latent behavioral states
│   ├── 04_network_analysis.R     # transition networks, centrality
│   ├── 05_process_mining.R       # bupaR event logs, process maps
│   └── 06_language_models.R      # sequence embeddings / activity2vec
├── src/
│   ├── data/           # shared data loading and wrangling helpers
│   ├── analysis/       # shared analysis utilities
│   └── visualization/  # shared plotting helpers
├── notebooks/          # exploratory R Markdown / Quarto documents
├── results/
│   ├── figures/        # all output plots
│   └── tables/         # all output tables / model summaries
└── .gitignore
```

---

## Data

We cannot share the original dataset. The activity alphabet used in the reference study:

| Platform  | Activity types |
|-----------|---------------|
| Facebook  | searches, reactions, last seen content, posts, likes & follows |
| YouTube   | watch history, search history |
| TikTok    | watched videos, favorite videos/effects/hashtags/sounds, search history, shared videos |
| Instagram | likes, shared links, saved posts, comment history, search history |

Each record in the raw data represents a single user activity event with at minimum: `user_id`, a time variable (turn/timestamp), and `activity_type`.

---

## Getting started

```r
# Install core dependencies
install.packages(c(
  "TraMineR",       # sequence analysis
  "survival",       # event history
  "survminer",      # survival visualization
  "depmixS4",       # hidden Markov models
  "seqHMM",         # HMMs for sequence data
  "igraph",         # network analysis
  "ggraph",         # network visualization
  "bupaR",          # process mining
  "processmapR",    # process maps
  "tidyverse"       # data wrangling throughout
))
```

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
