reboot() {
  YESNO_MSG="Please type $(bold "y/Y") to proceed or $(bold "n/N") to abort... $(bold "[y/n]") "
  log_warning "Trying to reboot..."
  while true; do
    echo -n "$YESNO_MSG"
    read -r -k 1 yn
    case $yn in
    [Yy]*)
      log_warning "Rebooting..."
       sudo shutdown -r now
      ;;
    [Nn]*)
      log_warning "Aborting..."
      break
      ;;
    *) log_error "Option not recognised... " ;;
    esac
  done
}
