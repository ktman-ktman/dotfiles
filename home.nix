{ pkgs, username, llm-agents, ... }: let
  gitName = "dk";
  gitEmail = "dk@dk-u-s";

  # jjの補完スクリプトを生成
  jjCompletion = pkgs.runCommand "jj_completion.nu" {} ''
    ${pkgs.jujutsu}/bin/jj util completion nushell > $out
  '';
  # ...既存のlet束縛...
  agents = llm-agents.packages.${pkgs.system};
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # rust系モダンツール
    eza        # ls
    bat        # cat
    fd         # find
    ripgrep    # grep
    dust       # du
    sd         # sed
    # delta      # git diff viewer
    lazyjj     # jujutu
    gitui      # git TUI
    procs      # ps
    yazi       # ファイルマネージャー
    hyperfine  # ベンチマーク
    tokei      # コード行数
    just       # タスクランナー
    # AI agents
    agents.claude-code
    # agents.codex
    agents.gemini-cli
    agents.opencode
  ];

  # programs.*モジュールで管理するもの
  programs.zellij = {
  enable = true;
  settings = {
      default_shell = "nu";
      default_mode = "locked";
      default_cwd = "/home/dk";
      show_startup_tips = false;
      copy_command = if builtins.pathExists /proc/sys/fs/binfmt_misc/WSLInterop
      then "clip.exe"
      else "xclip -selection clipboard";  # あるいは "wl-copy"
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = gitName;
        email = gitEmail;
      };
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = gitName;
        email = gitEmail;
      };
    };
  };

  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config.edit_mode = "vi"
      def l [] { ls -l | sort-by modified --reverse }
      def ll [] { ls -la | sort-by modified --reverse }
      # jjの補完
      ${builtins.readFile jjCompletion}
      # 履歴
      $env.config = {
        history: {
          max_size: 1000000
          sync_on_enter: true
          file_format: "sqlite"
          isolation: false  # ← ここをfalse（共有）にする
        }
      }
    '';
    shellAliases = {
    };
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  # nushell用fazzy finder
  programs.television= {
    enable = true;
    enableNushellIntegration = true;
  };

  # zoxideにtelevisionを使わせるための環境変数
  home.sessionVariables = {
    # zoxideが内部で呼び出すコマンドをtvに差し替える
    _ZO_FZF_ITERM = "tv"; 
  };

  programs.bottom.enable = true;

programs.starship = {
  enable = true;
  enableNushellIntegration = true;
  settings = {
    format = "[](fg:#3B4252)$os$username$hostname[](bg:#4C566A fg:#3B4252)$directory[](bg:#81A1C1 fg:#4C566A)$git_branch$git_status[](bg:#88C0D0 fg:#81A1C1)$rust$nodejs$python[](bg:#434C5E fg:#88C0D0)$time[ ](fg:#434C5E)";

    os = {
      disabled = false;
      style = "bg:#3B4252 fg:#88C0D0";
    };

    username = {
      show_always = true;
      style_user = "bg:#3B4252 fg:#E5E9F0";
      style_root = "bg:#3B4252 fg:#BF616A";
      format = "[ $user ]($style)";
    };

    hostname = {
      ssh_only = false;
      style = "bg:#3B4252 fg:#88C0D0";
      format = "[@$hostname ]($style)";
    };

    directory = {
      style = "bg:#4C566A fg:#ECEFF4";
      format = "[ $path ]($style)";
      truncation_length = 3;
      truncation_symbol = "…/";
    };

    git_branch = {
      style = "bg:#81A1C1 fg:#2E3440";
      format = "[ $symbol$branch ]($style)";
      symbol = " ";
    };

    git_status = {
      style = "bg:#81A1C1 fg:#2E3440";
      format = "[$all_status$ahead_behind ]($style)";
    };

    time = {
      disabled = false;
      style = "bg:#434C5E fg:#88C0D0";
      format = "[ $time ]($style)";
      time_format = "%H:%M";
    };

    rust = {
      style = "bg:#88C0D0 fg:#2E3440";
      format = "[ $symbol$version ]($style)";
    };

    nodejs = {
      style = "bg:#88C0D0 fg:#2E3440";
      format = "[ $symbol$version ]($style)";
    };

    python = {
      style = "bg:#88C0D0 fg:#2E3440";
      format = "[ $symbol$version ]($style)";
    };
  };
};
  programs.home-manager.enable = true;
}