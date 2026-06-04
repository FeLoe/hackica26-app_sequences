gap_threshold <- 10 * 60  # seconds; 10-minute rule from Fan et al.

# Apps excluded from all analyses.
# "Pixel Launcher" and "Xperia Home" are Android home-screen launchers that
# appear between genuine app uses whenever the user presses the home button.
# They carry no behavioural information and inflate transition counts between
# unrelated apps. Filter applied to df_merged immediately after merge_consecutive().
noise_apps <- c(
  # Home-screen launchers (Android, Samsung, Sony, Huawei, Honor, POCO, Motorola)
  "Pixel Launcher", "Xperia Home", "One UI-Startbildschirm", "One UI Home",
  "Systemlauncher", "System-Launcher", "ME Launcher", "POCO Launcher",
  "Moto App Launcher", "HONOR Home", "Huawei Home",
  # Android system internals — no behavioural content
  "Android-System", "Android System", "System-UI", "IntentResolver",
  "Package installer", "Oberfläche",
  # Permission / settings overlays
  "Berechtigungssteuerung", "Permission controller",
  "Einstellungen", "Settings",
  "Formulare von Samsung Pass ausfüllen lassen",
  # Utility launchers that interpose between apps
  "Screen Off and Lock", "Discreet App-Starter",
  # Generic home-screen labels (LG Launcher shows as "Home")
  "Home"
)

cat_pal <- c(
  "social network" = "#F28E2B",
  "communication"  = "#4E79A7",
  "tools"          = "#59A14F",
  "entertainment"  = "#B07AA1",
  "other"          = "#BAB0AC"
)

# Map raw Play-Store category strings (German) to the 5-bucket English scheme used
# throughout. NA / empty / unknown categories → "other".
translate_category <- function(x) {
  mapping <- c(
    "Soziale Netzwerke"           = "social network",
    "Kommunikation"               = "communication",
    "Tools"                       = "tools",
    "Effizienz"                   = "tools",
    "Unterhaltung"                = "entertainment",
    "Musik & Audio"               = "entertainment",
    "Action"                      = "entertainment",
    "Rollenspiele"                = "entertainment",
    "Videoplayer & Editors"       = "entertainment",
    "Finanzen"                    = "other",
    "Shopping"                    = "other",
    "Fotografie"                  = "other",
    "Gesundheit & Fitness"        = "other",
    "Karten & Navigation"         = "other",
    "Lifestyle"                   = "other",
    "Medizin"                     = "other",
    "Nachrichten & Zeitschriften" = "other",
    "Reisen & Lokales"            = "other",
    "Sport"                       = "other",
    "Business"                    = "other",
    "Autos & Fahrzeuge"           = "other",
    "Essen & Trinken"             = "other",
    "Wetter"                      = "other"
  )
  result        <- mapping[x]
  result[is.na(result)] <- "other"
  unname(result)
}

merge_consecutive <- function(d, gap_sec) {
  d |>
    arrange(start_time) |>
    mutate(
      # Use start_time + Duration as the effective foreground end, not end_time.
      # end_time can reflect background running (up to hours), making gaps look
      # artificially large; Duration is the actual active foreground time.
      .eff_end = start_time + Duration,
      .gap     = as.numeric(start_time - lag(.eff_end, default = first(start_time)),
                            units = "secs"),
      .grp     = cumsum(app_name != lag(app_name, default = "") | .gap > gap_sec)
    ) |>
    group_by(.grp) |>
    summarise(
      across(-c(.eff_end, .gap, end_time, Duration), first),
      end_time = last(end_time),
      Duration = sum(Duration, na.rm = TRUE),
      .groups  = "drop"
    ) |>
    dplyr::select(-.grp)
}

dir.create("results/tables", recursive = TRUE, showWarnings = FALSE)
