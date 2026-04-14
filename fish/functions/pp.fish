function pp
    set profiles low-power quiet balanced balanced-performance performance
    set current (cat /sys/firmware/acpi/platform_profile)
    set idx (contains -i -- $current $profiles)
    set next $profiles[(math "$idx % "(count $profiles)" + 1")]
    echo $next | sudo tee /sys/firmware/acpi/platform_profile
    notify-send "Power Profile" "Switched to: $next" -t 2000
end
