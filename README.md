# Verbal-Interaction Project Overview

This repository compiles important code for EEG analysis related to the study "Dyadic Neural Synchronization: Differences Between Offline and Computer-Assisted Online Verbal Interaction": Sections 1-3 cover the calculation of inter-subject correlation (ISC) for dyadic participants, Sections 1-6 include the statistical analysis of functional network metrics for significant edges, and Sections 2-6 contain the analysis of residual effects; the code is primarily used to verify and replicate the analysis workflow presented in the paper, with Major 1-3 and Major 1-6 implemented in MATLAB and Sections 2-6 implemented in R.

## Repository Structure

```text
Verbal-Interaction/
├─ 2-6/
│  └─ 04 baseline_and_time_ZPQ.R           # R script for baseline and time-window statistics
├─ Major 1-3/
│  ├─ cal_isc.m                            # Main batch script for multi-band ISC computation
│  ├─ cal_source_isc.m                     # ISC computation based on source-reconstructed signals
│  ├─ isceeg.m                             # Core ISC implementation from Cohen et al. (2016)
│  └─ ...
├─ Major 1-6/
│  ├─ netmetrics.m                         # Uses Brain Connectivity Toolbox to derive graph metrics
│  ├─ scout_isfc_*.m                       # Helper scripts for mapping significant edges and exporting metrics
│  └─ ...
└─ README.md
```

> **Note:** Raw data files (`.set`, `.mat`, `.xlsx`, etc.) are not included. Paths such as `D:\` reflect the author's local Windows environment; update them to match your own storage layout.

## Environment and Dependencies

- MATLAB R2018a or later.
- [EEGLAB](https://sccn.ucsd.edu/eeglab/index.php) (for functions such as `pop_loadset`, `pop_eegfilt`, `topoplot`, etc.).
- [Brain Connectivity Toolbox (BCT)](https://www.brain-connectivity-toolbox.net/) (for functions such as `clustering_coef_wu`, `efficiency_wei`, `participation_coef`, etc.).
- Optional: R (>= 4.0) to run `2-6/04 baseline_and_time_ZPQ.R`.

Make sure these toolboxes are installed and added to the MATLAB path. BCT functions must be discoverable alongside the scripts in the `Major 1-6` directory.

## Data Preparation

1. **EEG data:** `Major 1-3/cal_isc.m` assumes that `.set` files for each participant dyad live in paired folders under the directory defined by `savefolder` (for example, `F2F_WF/sub1A.set`, `F2F_WF/sub1B.set`). Replace the sample paths in the script with your actual data locations.
2. **Channel locations:** Set `locfile` to a `.loc` file with 32/64 channel coordinates; it is required for topographic plots and ISC computation.
3. **Network matrices:** `Major 1-6/netmetrics.m` reads a 62×62 functional connectivity matrix per participant (stored under field names such as `PLV`). Files should follow the naming pattern `sub#.mat`.

## Usage Guide

### 1. Batch ISC computation (`Major 1-3`)

1. Open `cal_isc.m` and update `savefolder`, the data root, and the output directories to match your experiment.
2. Ensure that EEGLAB is loaded so that functions like `pop_loadset` are available.
3. Run the script to filter data in the delta, theta, alpha, and beta bands, pair participants, call `isceeg`, and aggregate results into the `ISC_*_all` variables.
4. Length mismatches across dyads are logged in the `erro` list; review and fix any problematic datasets.

To compute ISC in source space, refer to `cal_source_isc.m`. The procedure mirrors the scalp-based workflow but takes source-space time series as input.

### 2. Network metrics on significant edges (`Major 1-6`)

1. Save thresholded connectivity matrices as `sub#.mat` files and update the `in_dir*` paths at the top of `netmetrics.m`.
2. Confirm that BCT functions are on the MATLAB search path.
3. Running the script produces:
   - `net_all`: participant-level global/node metrics, masks, and community assignments.
   - `net_region`: node metrics averaged across seven brain regions.
4. Auxiliary scripts such as `scout_isfc_ncpt2.m` and `scout_isfc_permutest.m` support edge selection, permutation testing, and visualization; adjust their parameters as needed.

### 3. R workflow (`2-6/04 baseline_and_time_ZPQ.R`)

This script is used to organize the statistics of baselines and time windows. Input data (such as Re_ISC_end_filled_end.xlsx) is used to monitor the presence of residual effects. Please modify the read-write paths according to the comments. Running method:

```r
Rscript 2-6/"04 baseline_and_time_ZPQ.R"
```

## Suggested Workflow

1. Preprocess EEG data and export `.set` files.
2. Run `cal_isc.m` / `cal_source_isc.m` to compute ISC metrics.
3. Feed significant edge matrices into `netmetrics.m` to derive graph properties.
4. Use the R script to consolidate statistics or create visualizations.
