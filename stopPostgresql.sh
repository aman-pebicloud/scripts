service=postgresql

pgrep $service || service $service stop
