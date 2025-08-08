function fish_right_prompt
  set_color cyan --italic
  echo -n -s -e "\e[1A"(whoami)"@"(hostname -s)"\e[1B"
  set_color normal
end
