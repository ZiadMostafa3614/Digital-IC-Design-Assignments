# Overheating / startup cleanup policy (local notes)

**McAfee WebAdvisor — DO NOT REMOVE OR DISABLE**
- User requested: keep McAfee free products installed and running.
- Exclude McAfee WebAdvisor, `browserhost.exe`, and all McAfee services/tasks from bloat-removal and overheating fixes.

## Allowed intermediate fixes (McAfee excluded)
- RealPlayer downloaders: services/tasks disabled
- Grammarly: autostart removed/disabled
- GPU power saving (GpuPreference=2): Cursor, Chrome, Claude, Edge
- Processor max state: 85% (balanced plan)
- OneDrive: pause sync when applying fixes
- Lenovo Vantage: install/keep for thermal control
- Windows Defender: exclusion for dev workspace under `My Assignments`
- Other startup cleanup — never McAfee

Last verified: 2026-08-13
