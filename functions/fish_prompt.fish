# You can override some default options with config.fish:
#
#  set -g theme_short_path yes
#  set -g theme_stash_indicator yes

function fish_prompt
  set -f last_command_status $status
  set -f cwd

  if test "$theme_short_path" = 'yes'
    set cwd (basename (prompt_pwd))
  else
    set cwd (prompt_pwd)
  end

  set -f ahead    "↑"
  set -f behind   "↓"
  set -f diverged "⥄"
  set -f dirty    "⨯"
  set -f stash    "≡"
  set -f none     "◦"

  set -f normal_color     (set_color normal)
  set -f success_color    (set_color white)
  set -f error_color      (set_color $fish_color_error 2> /dev/null; or set_color red --bold)
  set -f directory_color  (set_color $fish_color_quote 2> /dev/null; or set_color brown)
  set -f repository_color (set_color $fish_color_cwd 2> /dev/null; or set_color green)


  if test $last_command_status -eq 0
    set -f status_color $success_color
  else
    set -f status_color $error_color
  end
  #echo -n -s $status_color "╭" $normal_color
  echo -n -s $status_color "┌" $normal_color

  if git_is_repo
    if test "$theme_short_path" = 'yes'
      set -f root_folder (command git rev-parse --show-toplevel 2> /dev/null)
      set -f parent_root_folder (dirname $root_folder)
      set -f cwd (echo $PWD | sed -e "s|$parent_root_folder/||")
    end

    echo -n -s "[ " $directory_color $cwd $normal_color " ]"
    echo -n -s $repository_color "  " (git_branch_name) $normal_color " "


    set -l list
    if test "$theme_stash_indicator" = yes; and git_is_stashed
      set list $list $stash
    end
    if git_is_touched
      set list $list $dirty
    end
    echo -n $list

    if test -z "$list"
      echo -n -s (git_ahead $ahead $behind $diverged $none)
    end
  else
    echo -n -s " " $directory_color $cwd $normal_color
  end

  #echo -n -s -e "\n$status_color╰❯$normal_color "
  echo -n -s -e "\n$status_color└❯$normal_color "
end
