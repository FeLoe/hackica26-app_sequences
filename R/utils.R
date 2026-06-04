gap_threshold <- 10 * 60  # seconds; 10-minute rule from Fan et al.

# Apps excluded from all analyses.
# "Pixel Launcher" and "Xperia Home" are Android home-screen launchers that
# appear between genuine app uses whenever the user presses the home button.
# They carry no behavioural information and inflate transition counts between
# unrelated apps. Filter applied to df_merged immediately after merge_consecutive().
noise_apps <- c(
  # Home-screen launchers / system launchers
  "Pixel Launcher",
  "Xperia Home",
  "Quickstep",
  "Systemlauncher",
  "System-Launcher",
  "Huawei Home",
  "HONOR Home",
  "Moto App Launcher",
  "Startprogramm",
  "Home",
  "App Starter",

  # Android system internals / system UI
  "Android-System",
  "Android System",
  "Android Services Library",
  "System-UI",
  "System UI",
  "Systemdienst-Plugin",
  "System mit Plug-in",
  "Systembenutzeroberfläche-Plugin",
  "Einstellungen des System-UI",
  "Oberfläche",
  "IntentResolver",

  # Settings / personalization / system configuration
  "Einstellungen",
  "Settings",
  "Ein​stellungen",
  "SettingsHelper",
  "Einstellungsvorschläge",
  "Settings Suggestions",
  "Einstellungsupdates",
  "Drahtloseinstellungen",
  "Eingabe-Einstellungen",
  "Bildschirmsperre Einstellungen",
  "Hintergrundbild und Stil",
  "Wallpaper and style",
  "Hintergründe",
  "Hintergrund & Thema",
  "Hintergrundbilddienste",
  "Live Wallpaper Picker",
  "Live-Hintergrund-Auswahl",
  "Immer eingeschaltetes Display und Sperrbildschirm-Editor",
  "Always-on display",
  "AlwaysOnDisplay",

  # Permissions / credentials / security frameworks
  "Berechtigungssteuerung",
  "Permission controller",
  "Berechtigungsnutzung",
  "Anmeldedaten-Manager",
  "Credential manager",
  "Authentication Framework",
  "Key Chain",
  "Schlüsselbund",
  "Schlüsselkette",
  "com.samsung.android.biometrics.app.setting",
  "Biometrische Daten",
  "Sicherheits-Kernkomponente",
  "SecurityLogAgent",
  "KmxService",
  "VpnDialogs",

  # Package installation / system updates
  "Paketinstallation",
  "Package installer",
  "Paket-Installer",
  "Updater",
  "Software-Update",
  "Software update",
  "Softwareaktualisierung",
  "Updater für System-Apps",
  "App Updates",
  "Update-Center",
  "com.miui.rom",
  "HnStartupGuide",
  "HnUpgradeGuide",

  # Network / connectivity / device-linking services
  "Anmeldung über Captive Portal",
  "Anmeldung Ã¼ber Captive Portal",
  "CaptivePortalLogin",
  "Captive portal login",
  "Wi-Fi",
  "WLAN-Tipps",
  "Bluetooth",
  "Bluetooth-Erweiterung",
  "NFC",
  "NFC-Dienst",
  "NFC-Service",
  "Nfc Service",
  "NFC-Einstellungen",
  "USB-Verbindung",
  "MTP-Anwendung",
  "MTP application",
  "Medien",
  "Medienausgabe",
  "Medien-Viewer",
  "Medien und Geräte",
  "Cast",
  "Mi Share",
  "Huawei Share",
  "Share",
  "Suche nach Geräten in der Nähe",
  "Begleitgerät-Manager",
  "Interkonnektivität-Dienste",
  "Link zu Windows-Dienst",
  "Anrufe/SMS auf anderen Geräten",
  "Dateiaustausch",

  # Printing services
  "Druck-Spooler",
  "Print Spooler",
  "Druckverwaltung",
  "Druckverarbeitungsdienst",
  "Standarddruckdienst",
  "System-Druckservice",

  # Call-management settings/services kept from prior list
  "Anrufverwaltung",
  "Call Management",
  "Anrufe verwalten",
  "Anrufeinstellungen",
  "Call settings",
  "Anrufdienste",
  "Anrufbildschirm",
  "Kontakte und Wahlvorrichtung",
  "SIM-Toolkit",
  "SIM-Verwaltung",
  "eSIMs",
  "WLAN-Anrufe",

  # Emergency / cell broadcast services
  "Notfallbenachrichtigungen an Mobilgeräte",
  "Notfallbenachrichtigungen für Mobilgeräte",
  "Wireless emergency alerts",
  "Cell Broadcast",
  "Notfall-SOS",

  # Samsung system services
  "Samsung Einrichtungsassistent",
  "Samsung Account",
  "Samsung Pass",
  "Formulare von Samsung Pass ausfüllen lassen",
  "Formulare von Samsung Pass ausfÃ¼llen lassen",
  "Samsung-Tastatur",
  "Samsung Tastatur",
  "Samsung Keyboard",
  "Samsung-Spracheingabe",
  "Samsung text-to-speech engine",
  "Samsung Text-zu-Sprache-Engine",
  "Samsung Cloud",
  "Samsung Cloud Assistant",
  "Samsung ApexService",
  "Samsung O",
  "Samsung Visit In",
  "Samsung Blockchain Keystore",
  "Smart Switch Agent",
  "Find My Mobile",
  "Secure Folder",
  "Private Space",
  "Modes and Routines",
  "Modi und Routinen",
  "Bixby Routines",
  "Bixby Voice",
  "Bixby Vision",
  "S Pen-Befehle",
  "SecSoundPicker",
  "Sound picker",
  "Sound-Auswahl",
  "Tonqualität und Effekte",
  "Separater App-Ton",
  "Adapt Sound",

  # Xiaomi / MIUI system services
  "Xiaomi Cloud",
  "Xiaomi-Konto",
  "GetApps",
  "Akku und Leistung",
  "Bereinigung",
  "Optimizer",
  "Systemmanager",

  # Huawei / Honor system services
  "Huawei Health",
  "HMS Core",
  "Huawei-Start",
  "Huawei Share",
  "HiVoice",
  "HiSearch",
  "Magic Mobile Service",

  # LG / other OEM services
  "LG Mobile Switch",
  "Context Awareness",
  "SmartWorld",
  "com.sonymobile.pocketmode2",
  "com.mediatek.batterywarning",
  "X Google enrollment"
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
