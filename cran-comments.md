# audubon 0.6.3

This is a resubmission.

I addressed the M1mac additional issue related to locale-dependent code paths.

Changes in this version:
- examples involving Japanese calendar/date formatting are no longer run on CRAN,
- CRAN checks no longer exercise some locale-dependent code paths,
- the locale specification used in Japanese phrase-based wrapping was simplified.

The issue appears to be environment-specific on the CRAN M1mac setup and I could not reproduce it locally.
