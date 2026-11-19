# AR4DS workspace – Housing and racial bias

## About this workspace

A ready-to-run replication exercise for the course "Applied Replication for Data Skills". You reproduce one of the reanalyses from the robustness study of SCORE (Multi100; Aczel et al. 2026) and test the robustness of a published claim: that emails to public housing authorities signed with Hispanic names were less likely to be answered with a greeting by name than emails signed with white names (Einstein and Glick 2017). You are analyst no. 6.

The report you build is `index.qmd`. It renders out of the box: the data ship inside `data/`, so your very first `quarto preview` works with no edits and no network.

------------------------------------------------------------------------

## Setting up the workspace

This workspace is a plain folder, with no version control and no account to sign in to. You download it, unzip it, and work inside it.

1.  **Download the workspace.** On the GitHub page of the template, click the green **Code** button, then **Download ZIP** – or use the direct link `https://github.com/CodeMoreh/ar4ds-housing-workspace/archive/refs/heads/main.zip`. Save it somewhere you own (Desktop or Documents).

2.  **Unzip it.** Extract the ZIP to a real folder (on Windows, "Extract All" – do not work inside the compressed preview). You will get a folder called `ar4ds-housing-workspace-main` containing `index.qmd`, `data/`, `R/`, and this file.

3.  **Open the folder in your IDE.** In Positron or VS Code, **File → Open Folder…** and pick the unzipped folder; in RStudio, open `ar4ds-housing-workspace.Rproj`, which sits inside it.

4.  **Check the packages.** `R/check_setup.R` checks what is installed and lists what is missing. In the R console:

    ``` r
    source("R/check_setup.R")
    ```

    It prints an `[OK]`, `[FAIL]` or `[SKIP]` line per check (R version, Quarto, the twelve required packages, the data files, and a fit of the reference specification, which must come out at −19.97 percentage points), and a `[NOTE]` that names any package installed at another version than the course was tested with. If any packages are missing, it prints the one line that installs them. Run that line, then re-run the check.

5.  **Open the report and preview it.** Open `index.qmd`, then in a terminal inside your IDE:

    ``` sh
    quarto preview
    ```

    The report opens in a browser. Work through the tasks inside `index.qmd`. `working_script.R` holds the same steps as a plain script, for working in the console.

------------------------------------------------------------------------

## A note on version control

Putting your own work under version control and publishing the rendered report is the natural next step, and the module **Git and GitHub for reproducible research** on the course site goes through it: <https://codemoreh.github.io/ar4ds/git-github.html>. The `.github/` and `.devcontainer/` folders of this workspace set up that route once the folder is a repository again, and you can ignore them until then.

------------------------------------------------------------------------

## The tasks

The report `index.qmd` holds six tasks:

- **Task 1** – the setup check and the three Rs.
- **Task 2** – the data, the estimand and the causal graph.
- **Task 3** – the reproduction of one of the five analyses of the robustness study, from the public file of the original authors. `prep/reproduce_reanalyses.R` holds all five as a script.
- **Task 4** – the specification menu, with one specification sent to the class chart as exploratory.
- **Task 5** – one specification preregistered, then fitted, reported and placed among the 64 specifications of the curve.
- **Task 6** – the preregistered specification fitted again on the data of the SCORE replication, a new experiment of 2020, and placed on the curve of the claim on the new data.
- **Going further** – three optional exercises.

------------------------------------------------------------------------

## Links

- **Course site:** https://codemoreh.github.io/ar4ds-housing/
- **Class chart:** https://codemoreh.github.io/ar4ds-housing/class-results.html
- **Take-home git/GitHub path:** https://codemoreh.github.io/ar4ds/git-github.html
- **The data:** the replication package of the original study on Harvard Dataverse, https://doi.org/10.7910/DVN/1HOVTU (CC0).
- **The data of the SCORE replication:** the de-identified data of the new experiment on the OSF, https://osf.io/xseqg/, published without a stated licence.
- **The five analyses of the robustness study:** the component of the robustness study for the paper on the OSF, https://osf.io/38rsh/, with one sub-component per analyst: 8PTRZ https://osf.io/j8wvh/, UYV3F https://osf.io/3672s/ (a review document only), EWFMI https://osf.io/jhvca/, 25N5D https://osf.io/v8zah/ and P9W8Y https://osf.io/pzwbm/.

------------------------------------------------------------------------

## Notes for the repository maintainer

This workspace is published as the "Use this template" repository `CodeMoreh/ar4ds-housing-workspace`. Two folders serve the take-home and publishing route:

- `.devcontainer/devcontainer.json` – a Codespaces / dev-container image (R + Quarto + the package list) so the repository can be opened and rendered in the cloud with no local install.
- `.github/workflows/publish.yml` – renders the report and publishes it to GitHub Pages on every push, once **Settings → Pages → Source** is set to **"GitHub Actions"**. It installs R and re-runs the chunks, so the edits of a participant show up.

Neither is needed for the zip route used in class. Keep `data/` in step with the `data/` folder of the course repository. `housing_emails.csv` is what the report and the helpers read, and `housing_original.csv` is the public file of the original authors, on which the five reproductions of Task 3 run. `spec_curve.csv` is the curve of 64 specifications, against which `R/spec_tools.R` checks and places every live fit, and `menu_options.csv` gives the reason for every option that is not on the curve. `analysts5.csv` and `reference_marks.csv` record the five analyses of the robustness study and the reference marks of the curve. `housing_replication.csv` holds the data of the SCORE replication in the columns of the course file, and `replication_curve.csv` the curve of the claim on them, which Task 6 reads. The codebooks beside them describe every column. The estimator in `R/spec_tools.R` is a verbatim copy of `R/_tools.R` in the course repository, which builds the curve; the configuration block at the top of that file holds the ID and entry codes of the results Form.

------------------------------------------------------------------------

## References

Aczel, B., Szaszi, B., Clelland, H. T., et al. (2026). Investigating the analytical robustness of the social and behavioural sciences. *Nature*, 652(8108), 135–142.

Einstein, K. L., & Glick, D. M. (2017). Does race affect access to government services? An experiment exploring street-level bureaucrats and access to public housing. *American Journal of Political Science*, 61(1), 100–116.

------------------------------------------------------------------------

*Code is MIT-licensed; prose and figures are CC BY 4.0, and the data of the original study are CC0 – see `LICENSE`. The data of the SCORE replication come from the OSF, where they were published without a stated licence.*
