##############################################################################
# Title:        check_setup.R – does this machine have what the course needs?
# Purpose:      Report the R version, Quarto, the required packages, whether
#               the data files are present and readable, and whether the
#               estimator of the course reproduces the reference
#               specification (-19.97 percentage points). Prints an [OK] /
#               [FAIL] / [SKIP] line per check and a verdict, and a [NOTE]
#               where a package is at another version than the course was
#               tested with. It only checks,
#               and changes nothing on your system. Base R up to the last
#               check, because it has to run before any package is installed.
# Author:       Chris Moreh
# Last updated: 2026-11-17
# Sourced by:   the participant, before the session (source("R/check_setup.R"))
##############################################################################

# A FAIL is not the end of the world: the browser lab on the course site runs
# the same exercise inside a web browser. The message at the bottom says what
# to do.

# --- tiny reporting helpers -------------------------------------------------
.results <- list2env(list(pass = 0L, fail = 0L, skip = 0L))
.tally <- function(kind, label, msg) {
  assign(kind, get(kind, envir = .results) + 1L, envir = .results)
  writeLines(paste0(label, msg))
}
ok   <- function(msg) .tally("pass", "[OK]   ", msg)
fail <- function(msg) .tally("fail", "[FAIL] ", msg)
skip <- function(msg) .tally("skip", "[SKIP] ", msg)

# Run a system command quietly and return its trimmed stdout, or "" on failure.
sys_out <- function(cmd, args) {
  out <- tryCatch(
    suppressWarnings(system2(cmd, args, stdout = TRUE, stderr = TRUE)),
    error = function(e) character(0)
  )
  if (length(out) == 0) "" else trimws(paste(out, collapse = " "))
}

writeLines("\n=== AR4DS workspace, the Housing and racial bias case study – setup check ===\n")

# --- 1. R version -----------------------------------------------------------
if (getRversion() >= "4.4.0") {
  ok(paste0("R ", getRversion(), " (>= 4.4 required)"))
} else {
  fail(paste0("R ", getRversion(), " is below 4.4 – please update R"))
}

# --- 2. Quarto on PATH ------------------------------------------------------
qv <- sys_out("quarto", "--version")
if (nzchar(qv) && !grepl("not found|error", qv, ignore.case = TRUE)) {
  ok(paste0("Quarto on PATH (version ", qv, ")"))
} else {
  fail("Quarto not found on PATH – install from https://quarto.org and reopen the terminal")
}

# --- 3. packages ------------------------------------------------------------
# The estimator fits with parameters (and sandwich for the HC2 errors),
# marginaleffects and effectsize, and chooses its rows with dplyr, tibble and
# datawizard, iterating with purrr; the report reads with readr, draws with
# tinyplot (McDermott, Arel-Bundock and Zeileis; CRAN,
# doi:10.32614/CRAN.package.tinyplot) and asks dagitty about the causal graph.
# Quarto runs the R chunks of the report through rmarkdown, so a fresh R
# installation without it renders nothing.
needed <- c("dplyr", "purrr", "readr", "tibble", "datawizard", "parameters", "sandwich",
            "marginaleffects", "effectsize", "tinyplot", "dagitty", "rmarkdown")
# The course was tested with the versions that CRAN held on its package date.
# The address is the copy of CRAN of that day kept by the public package
# manager of Posit, and the install lines below take the packages from it.
course_repo <- "https://packagemanager.posit.co/cran/2026-11-17"
install_line <- '          install.packages(c("%s"), repos = "%s")'
missing <- needed[!vapply(needed, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing) == 0) {
  ok(paste0("all ", length(needed), " required packages installed"))
} else {
  fail(paste0("missing package(s): ", paste(missing, collapse = ", ")))
  writeLines(c("        install the missing ones with:",
               sprintf(install_line, paste(missing, collapse = '", "'), course_repo)))
}

# The installed versions against those of the package date. A difference is
# not a failure: the note is there for the day on which an exercise stops.
present <- setdiff(needed, missing)
tested <- tryCatch(
  stats::setNames(utils::available.packages(repos = course_repo, type = "source")[present, "Version"], present),
  error = function(e) NULL, warning = function(w) NULL
)
if (length(present) == 0 || is.null(tested)) {
  skip("the package versions were not compared with those of the course (no connection)")
} else {
  differ <- present[vapply(present, function(p) utils::packageVersion(p) != tested[[p]], logical(1))]
  if (length(differ) == 0) {
    ok(paste0("the ", length(present), " packages are at the versions of the course"))
  } else {
    writeLines(c(
      paste0("[NOTE] ", length(differ), " package(s) at another version than the course was tested with:"),
      paste0("        ", differ, " ", vapply(differ, function(p) as.character(utils::packageVersion(p)), character(1)),
             " (the course: ", tested[differ], ")"),
      "        if an exercise fails, install the versions of the course with:",
      sprintf(install_line, paste(differ, collapse = '", "'), course_repo)
    ))
  }
}

# --- 4. data files present and readable -------------------------------------
# The report renders offline because these ship inside the workspace.
# housing_emails.csv is the course file that Tasks 2, 4 and 5 use, and
# housing_original.csv the public file of the original authors, on which Task 3
# reproduces a result of the robustness study. R/spec_tools.R reads the curve of 64
# specifications and the reasons for the options that are not on it. Task 6 reads
# housing_replication.csv, the data of the SCORE replication, and
# replication_curve.csv, the curve of the claim on them. The last two hold the five
# analyses of the robustness study and the reference marks of the curve.
data_files <- c("data/housing_emails.csv", "data/housing_original.csv", "data/spec_curve.csv",
                "data/menu_options.csv", "data/housing_replication.csv", "data/replication_curve.csv",
                "data/analysts5.csv", "data/reference_marks.csv")
for (f in data_files) {
  if (!file.exists(f)) {
    fail(paste0("data file missing: ", f, " – run from the workspace root folder"))
    next
  }
  n_rows <- tryCatch(nrow(utils::read.csv(f)), error = function(e) NA_integer_)
  if (is.na(n_rows)) {
    fail(paste0("could not read ", f))
  } else {
    ok(paste0(f, " present and readable (", n_rows, " rows)"))
  }
}

# --- 5. the report file -----------------------------------------------------
# index.qmd is what you open and work in.
if (file.exists("index.qmd")) {
  ok("index.qmd present – open it to start")
} else {
  fail("index.qmd not found – run this from the workspace root folder")
}

# --- 6. the estimator reproduces the reference specification ----------------
# The raw difference of the paper: Hispanic against white names, among the
# replies, without covariates. The live fit must match the row of the curve
# that is marked as the reference.
if (length(missing) == 0 && all(file.exists(data_files[c(1, 3)])) && file.exists("R/spec_tools.R")) {
  tools <- new.env()
  check <- tryCatch({
    sys.source("R/spec_tools.R", envir = tools)
    curve <- utils::read.csv("data/spec_curve.csv")
    list(live = get("fit_spec", envir = tools)(get(".housing", envir = tools)())$b_pp,
         stored = curve$b_pp[curve$is_reference])
  }, error = function(e) list(live = NA_real_, stored = NA_real_, msg = conditionMessage(e)))
  if (isTRUE(abs(check$live - check$stored) < 1e-9)) {
    ok(sprintf("the reference specification reproduces: %.2f percentage points", check$live))
  } else {
    fail(paste0("the reference specification does not reproduce",
                if (!is.null(check$msg)) paste0(" (", check$msg, ")"),
                " – restore R/ and data/ from a fresh download of the workspace"))
  }
} else {
  skip("the reproduction check needs the packages, R/spec_tools.R and the data files above")
}

# --- verdict ----------------------------------------------------------------
writeLines(c("\n=== Verdict ===",
             sprintf("  %d OK   %d FAIL   %d SKIP", .results$pass, .results$fail, .results$skip)))

if (.results$fail == 0) {
  writeLines("\nYou are ready. Open index.qmd and run `quarto preview` in the terminal.\n")
} else {
  writeLines(c("\nSome checks failed. Two options:",
               " 1. Fix the FAILs above (each line says how), then re-run this script.",
               "    The help page on the course site lists the common failures and fixes.",
               " 2. Come anyway – the slides of the day and the browser lab run the same",
               "    exercise inside a web browser, and you can work through the rest on",
               "    a partner's laptop.",
               ""))
}
