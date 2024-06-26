{ inputs, pkgs, ... }:
{

  home.packages = [ inputs.plasma-manager.packages.${pkgs.system}.rc2nix ];

  programs.plasma = {
    enable = true;

    #
    # Some high-level settings:
    #
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      #cursorTheme = "Bibata-Modern-Ice";
      #iconTheme = "Papirus-Dark";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Flow";
    };

    kwin = {
      virtualDesktops = {
        rows = 2;
        number = 4;
        names = [
          "Desktop 1"
          "Desktop 2"
          "Desktop 3"
          "Desktop 4"
        ];
      };
    };

    shortcuts = {
      "ferdium.desktop"."_launch" = "Meta+Shift+F";
      "firefox.desktop"."_launch" = "Meta+F";
      "kitty.desktop"."_launch" = "Meta+T";
      "org.kde.dolphin.desktop"."_launch" = "Meta+D";
      "plasmashell" = {
        "stop current activity" = ""; # So that I can assign Meta+S to spotify
      };
      "spotify.desktop"."_launch" = "Meta+S";
    };

    panels = [
      # Windows-like panel at the bottom
      {
        location = "top";
        height = 34;
        floating = false;
        widgets = [
          # We can configure the widgets by adding the name and config
          # attributes. For example to add the the kickoff widget and set the
          # icon to "nix-snowflake-white" use the below configuration. This will
          # add the "icon" key to the "General" group for the widget in
          # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General.icon = "nix-snowflake-white";
            };
          }
          # Adding configuration to the widgets can also for example be used to
          # pin apps to the task-manager, which this example illustrates by
          # pinning dolphin and konsole to the task-manager by default.
          {
            name = "org.kde.plasma.taskmanager";
            config = {
              General = {
                groupingStrategy = "0";
                launchers = [
                  # "applications:org.kde.dolphin.desktop"
                  # "applications:org.kde.konsole.desktop"
                ];
              };
            };
          }
          # If no configuration is needed, specifying only the name of the
          # widget will add them with the default configuration.
          "org.kde.plasma.marginsseparator"
          {
            name = "org.kde.plasma.pager";
            config = {
              General = {
                currentDesktopSelected = "ShowDesktop";
                showOnlyCurrentScreen = "true";
                showWindowIcons = "true";
              };
            };
          }
          # If you need configuration for your widget, instead of specifying the
          # the keys and values directly using the config attribute as shown
          # above, plasma-manager also provides some higher-level interfaces for
          # configuring the widgets. See modules/widgets for supported widgets
          # and options for these widgets. The widgets below shows two examples
          # of usage, one where we add a digital clock, setting 12h time and
          # first day of the week to sunday and another adding a systray with
          # some modifications in which entries to show.
          {
            systemTray = {
              icons = {
                spacing = "small";
                scaleToFit = false;
              };
              items = {
                #    # We explicitly show bluetooth and battery
                #    shown = [
                #      "org.kde.plasma.battery"
                #      "org.kde.plasma.bluetooth"
                #    ];
                hidden = [ "org.kde.plasma.brightness" ];
                configs = {
                  battery.showPercentage = true;
                };
              };
            };
          }
          {
            digitalClock = {
              calendar = {
                firstDayOfWeek = "monday";
                plugins = [ "holidaysevents" ];
              };
              time = {
                format = "24h";
                showSeconds = "onlyInTooltip";
              };
              date = {
                enable = true;
                format = "isoDate";
                position = "belowTime";
              };
            };
          }
        ];
        hiding = "none";
      }
    ];

    #
    # Some low-level settings:
    #
    configFile = {

      baloofilerc = {
        "Basic Settings" = {
          "Indexing-Enabled" = false;
        };
      };

      kscreenlockerrc = {
        "Greeter/LnF/General" = {
          showMediaControls = false;
        };
        "Greeter/Wallpaper/org.kde.image/General" = {
          Image = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Flow";
        };
      };

      kxkbrc = {
        Layout = {
          "DisplayNames" = ",";
          "LayoutList" = "us,pt";
          "Options" = "grp:shifts_toggle";
          "ResetOldOptions" = true;
          "Use" = true;
          "VariantList" = ",";
        };
      };
      kcminputrc = {
        "Keyboard"."NumLock" = 0;
      };

      kwinrc = {
        Desktops = {
          Number = {
            value = 4;
            # Forces kde to not change this value (even through the settings app).
            immutable = true;
          };
          Rows = {
            value = 2;
            immutable = true;
          };
        };
        NightColor = {
          Active = true;
          Mode = "Location";
          LatitudeAuto = 38.9;
          LongitudeFixed = -9.03;
          NightTemperature = 4400;
        };
        Xwayland = {
          Scale = 2.25;
        };
      };

      kglobalshortcutsrc = {
        kwin = {
          "Show Desktop" = null;
          "Window One Screen to the Left" = "Ctrl+Alt+Left";
          "Window One Screen to the Right" = "Ctrl+Alt+Right";
        };
      };

      powerdevilrc = {
        "AC/Display" = {
          DimDisplayIdleTimeoutSec = 900;
          TurnOffDisplayIdleTimeoutSec = 3600;
        };
        "AC/Keyboard" = {
          KeyboardBrightness = 100;
        };
        "AC/Performance" = {
          PowerProfile = "performance";
        };
        "AC/SuspendAndShutdown" = {
          AutoSuspendAction = 0;
          PowerButtonAction = 1;
        };
        "Battery/Performance" = {
          PowerProfile = "balanced";
        };
        "LowBattery/Keyboard" = {
          KeyboardBrightness = 15;
          UseProfileSpecificKeyboardBrightness = true;
        };
        "LowBattery/Performance" = {
          PowerProfile = "power-saver";
        };
      };

      kdeglobals = {
        KDE = {
          widgetStyle = "Breeze";
          LookAndFeelPackage = "org.kde.breezedark.desktop";
          SingleClick = false;
        };
        General = {
          TerminalApplication = "kitty";
          TerminalService = "kitty.desktop";
          XftAntialias = true;
          XftHintStyle = "hintfull";
          XftSubPixel = "rgb";
          # Fonts
          fixed = "EnvyCodeR Nerd Font Mono,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          font = "Sans Serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          menuFont = "Sans Serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          smallestReadableFont = "Sans Serif,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          toolBarFont = "Sans Serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        };
      };

      ksmserverrc.General.loginMode = "emptySession";

      dolphinrc = {
        General = {
          FilterBar = true;
          RememberOpenedTabs = false;
          ShowFullPath = true;
          ShowFullPathInTitlebar = true;
        };
        MainWindow = {
          MenuBar = "Disabled";
          ToolBarsMovable = "Disabled";
        };
        DetailsMode = {
          PreviewSize = 22;
        };
        "KFileDialog Settings" = {
          "Places Icons Auto-resize" = true;
        };
      };
    };
  };
}
