{
  programs.git = {
    enable = true;
    userName = "Nilesh";
    userEmail = "nilesh@cloudgeni.us";
    aliases = {
      recent = "!git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %(refname:short)' | head -n 10";
      co = "checkout";
      cob = "checkout -b";
      coo = "!git fetch && git checkout";
      br = "branch";
      brd = "branch -d";
      brD = "branch -D";
      merged = "branch --merged";
      st = "status";
      aa = "add -A .";
      cm = "commit -m";
      aacm = "!git add -A . && git commit -m";
      cp = "cherry-pick";
      amend = "commit --amend -m";
      dev = "!git checkout dev && git pull origin dev";
      staging = "!git checkout staging && git pull origin staging";
      main = "!git checkout main && git pull origin";
      master = "!git checkout master && git pull origin";
      po = "push origin";
      pu = "!git push origin `git branch --show-current`";
      pod = "push origin dev";
      pos = "push origin staging";
      pom = "push origin master";
      poh = "push origin HEAD";
      pogm = "!git push origin gh-pages && git checkout master && git pull origin master && git rebase gh-pages && git push origin master && git checkout gh-pages";
      pomg = "!git push origin master && git checkout gh-pages && git pull origin gh-pages && git rebase master && git push origin gh-pages && git checkout master";
      plo = "pull origin";
      plod = "pull origin dev";
      plos = "pull origin staging";
      plom = "pull origin master";
      ploh = "pull origin HEAD";
      unstage = "reset --soft HEAD^";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat";
      f = "!git ls-files | grep -i";
      gr = "grep -Ii";
      la = "!git config -l | grep alias | cut -c 7-";
    };
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
    };
  };
}
