# Risk Register
Sprint 3 | Squad — Section 02, Team 9
Date: 2026-03-08

## Risk 1: Duplicate tracks inflate artist frequency counts
- **Description:** The dataset contains the same song appearing multiple times across different release years and formats.
- **Likelihood:** High — confirmed in beatles_tracks.txt and taylor_tracks.txt
- **Impact:** High — top-artist ranking used directly in acquisition recommendation
- **Mitigation:** De-duplicate by track name + year before counting; note diff from original counts in output comments.

## Risk 2: Explicit content flag is inconsistently applied across ingestion batches
- **Description:** The explicit field may have been tagged by different data providers with different standards.
- **Likelihood:** Medium — common in large multi-source datasets
- **Impact:** High — affects compliance recommendation and family-friendly playlist policy
- **Mitigation:** Run a quality check comparing explicit flag distribution across release year cohorts.

## Risk 3: Year data only goes to 2020 — recent trends are missing
- **Description:** The dataset does not include tracks released after 2020.
- **Likelihood:** Certain — confirmed by freq_year.txt
- **Impact:** Medium — limits how far forward the stakeholder can extrapolate recommendations
- **Mitigation:** Clearly state the 2020 cutoff as a limitation in the Decision Brief.
