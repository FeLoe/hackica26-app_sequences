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
  "X Google enrollment",
  "One UI-Startbildschirm",
  "One UI Home",
  "POCO Launcher",
  "ME Launcher",
  "Discreet App-Starter",
  " ME Launcher",
  "(other app)"
)

cat_pal <- c(
  "communication"  = "#4E79A7",
  "social media"   = "#F28E2B",
  "entertainment"  = "#B07AA1",
  "gaming"         = "#E15759",
  "utilities"      = "#59A14F",
  "shopping"       = "#76B7B2",
  "practical life" = "#EDC948"
)

# Map raw Play-Store category strings (German) to the 7-bucket English scheme used
# throughout. NA / empty / unknown categories → NA.
translate_category <- function(x) {
  mapping <- c(
    # Communication
    "Kommunikation"               = "communication",
    "Dating"                      = "communication",

    # Social media
    "Soziale Netzwerke"           = "social media",

    # Entertainment
    "Videoplayer & Editors"       = "entertainment",
    "Musik & Audio"               = "entertainment",
    "Musik"                       = "entertainment",
    "Unterhaltung"                = "entertainment",
    "Nachrichten & Zeitschriften" = "entertainment",
    "Bücher & Nachschlagewerke"   = "entertainment",
    "Fotografie"                  = "entertainment",

    # Gaming
    "Geduldsspiele"               = "gaming",
    "Simulation"                  = "gaming",
    "Karten"                      = "gaming",
    "Strategie"                   = "gaming",
    "Casino"                      = "gaming",
    "Brettspiele"                 = "gaming",
    "Action"                      = "gaming",
    "Abenteuer"                   = "gaming",
    "Worträtsel"                  = "gaming",
    "Racing"                      = "gaming",
    "Rollenspiele"                = "gaming",
    "Quiz"                        = "gaming",
    "Casual"                      = "gaming",

    # Utilities
    "Personalisierung"            = "utilities",
    "Tools"                       = "utilities",
    "Effizienz"                   = "utilities",
    "Business"                    = "utilities",
    "Software & Demos"            = "utilities",
    "Wetter"                      = "utilities",
    "Kunst & Design"              = "utilities",

    # Shopping
    "Shopping"                    = "shopping",
    "Essen & Trinken"             = "shopping",
    "Finanzen"                    = "shopping",

    # Practical life
    "Reisen & Lokales"            = "practical life",
    "Karten & Navigation"         = "practical life",
    "Autos & Fahrzeuge"           = "practical life",
    "Haus & Garten"               = "practical life",
    "Events"                      = "practical life",
    "Eltern"                      = "practical life",
    "Gesundheit & Fitness"        = "practical life",
    "Sport"                       = "practical life",
    "Medizin"                     = "practical life",
    "Lernen"                      = "practical life",
    "Lifestyle"                   = "practical life",
    "Beauty"                      = "practical life"
  )
  result <- mapping[x]
  unname(result)
}

# App-level overrides applied after translate_category().
# Covers two cases:
#   (a) apps whose Play Store category is wrong/missing (raw NA → correct bucket)
#   (b) apps whose Play Store category is technically correct but behaviourally
#       belongs elsewhere (e.g. Google Search filed under "Tools").
apply_category_overrides <- function(df) {
  dplyr::mutate(df, app_category = dplyr::case_when(
    # (a) Explicit reclassifications regardless of raw category
    app_name == "Google"            ~ "communication",

    # Communication: phone, messaging, contacts apps without a Play Store category
    app_name %in% c(
      "Telefon", "Phone", "Anruf", "Call", "Kontakte", "Contacts",
      "Nachrichten", "Messages", "Messenger", "ICQ",
      "E-Mail", "Fennec"
    ) ~ "communication",

    # Entertainment: camera, gallery, media apps without a Play Store category
    app_name %in% c(
      "Kamera", "Camera", "Galerie", "Gallery",
      "Fotos", "Photos", "Foto-Editor",
      "Samsung Free", "Video Player"
    ) ~ "entertainment",

    # Gaming
    app_name %in% c("Gaming Hub") ~ "gaming",

    # Utilities: store, system tools, clock, weather, security without a category
    app_name %in% c(
      "Google Play Store", "Play Store", "Galaxy Store",
      "Finder", "Uhr", "Clock", "Wetter", "Weather",
      "Sicherheit", "Security", "Security Master", "Norton App Lock",
      "Battery Doctor", "Screen Off and Lock",
      "Notizen", "Dateien", "Media-Auswahl", "Bildschirmfoto",
      "Smart-Aufnahme", "Kontoverwaltung"
    ) ~ "utilities",

    # (b) Default: keep existing value (including NA for truly unknown apps)
    TRUE ~ app_category
  ))
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
