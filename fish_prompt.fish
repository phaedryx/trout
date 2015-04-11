# name: tthorley
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function fish_prompt
  set -l last_status $status
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l magenta (set_color magenta)
  set -l normal (set_color normal)

  if test $last_status = 0
    set prompt " $green☆ "
  else
    set prompt " $red☆ "
  end

  set -l cwd $cyan(basename (prompt_pwd))

  set ruby_version (rbenv version-name)
  set ruby_info "$red($ruby_version)$normal"

  if [ (_git_branch_name) ]
    set -l git_branch $magenta(_git_branch_name)
    set git_info "$git_branch"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow*$normal"
      set -l ahead
      set git_info "$git_info$dirty"
    end

    set git_info "$green($git_info$green)$normal"
  end

  echo -n -s $ruby_info $git_info $prompt $normal ' '
end

function file_count
  ls -1 | wc -l | sed 's/\ //g'
end

function fish_right_prompt
  set -l blue (set_color blue)
  set -l normal (set_color normal)
  set -l time (date '+%I:%M')
  set -l time_info "($time)"
  echo '('(pwd)' ('(file_count)'))'$blue$time_info$normal
end
