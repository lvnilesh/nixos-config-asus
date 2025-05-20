{
  config,
  pkgs,
  ...
}: {
  programs.lazygit = {
    enable = true;
    settings = {
      confirmOnQuit = false;
      git = {
        allBranchesLogCmd = "git log --graph --all --color=always --abbrev-commit --decorate --date=relative  --pretty=medium";
        autoFetch = true;
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
        disableForcePushing = false;
        merging = {
          args = "";
          manualCommit = false;
        };
        overrideGpg = false;
        paging = {
          colorArg = "always";
          useConfig = false;
        };
        skipHookPrefix = "WIP";
      };
      gui = {
        expandFocusedSidePanel = false;
        mainPanelSplitMode = "flexible";
        mouseEvents = true;
        scrollHeight = 10;
        scrollPastBottom = true;
        showIcons = true;
        sidePanelWidth = 0.3333;
        skipStashWarning = true;
        skipDiscardChangeWarning = false;
        theme = {
          activeBorderColor = [
            "green"
            "bold"
            "green"
            "bold"
          ];
          cherryPickedCommitBgColor = [
            "blue"
          ];
          inactiveBorderColor = [
            "white"
            "white"
          ];
          lightTheme = false;
          selectedLineBgColor = [
            "default"
          ];
        };
      };
      keybinding = {
        universal = {
          gotoBottom = ">";
          gotoTop = "<";
          nextBlock = "<right>";
          nextItem = "<down>";
          nextPage = ".";
          prevBlock = "<left>";
          prevItem = "<up>";
          prevPage = ",";
          quit = "q";
          quit-alt1 = "<c-c>";
          quitWithoutChangingDirectory = "Q";
          return = "<esc>";
          scrollLeft = "H";
          scrollRight = "L";
          togglePanel = "<tab>";
        };
      };
      quitOnTopLevelReturn = true;
      refresher = {
        fetchInterval = 60;
        refreshInterval = 10;
      };
      reporting = "undetermined";
      update = {
        days = 14;
        method = "prompt";
      };
    };
  };
}
