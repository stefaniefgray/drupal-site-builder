# drupal-site-builder

Repository for Drupal Site Builder certification exam work.

## AI assistance disclosure

> **I am completing the Acquia Certified Drupal Site Builder coursework and
> exam preparation manually. Claude (an AI assistant made by Anthropic) was used
> only to troubleshoot my development environment, not to do the coursework.**

This repository shows "Claude" as the author of three commits. Here is exactly
what that covers:

| Commit | What Claude did |
|---|---|
| `99a91d6` | Fixed `composer.json` after diagnosing an out-of-sync `composer.lock`: replaced Drush 10 with Drush 13 (Drush 10 does not support Drupal 11), removed `drupal/mysql56` and an unused package repository. Added a `.gitignore`. |
| `6b7b22f` | Wrote the DDEV setup and interrupted-install recovery instructions in this README. |
| `4cfd22c` | Researched the October 2026 PHP security patches and documented them in this README. |

Outside of commits, Claude also advised on getting the project to run in
GitHub Codespaces (restarting DDEV after a failed install, port forwarding,
reverse-proxy settings, file permissions). I ran those steps myself.

**What Claude did not do in this repository:** write course exercises, build or
configure site content, or produce any of the coursework itself. The learning
and the Drupal site building are my own work.

The Claude commit trailers are left in place on purpose, so the history stays
accurate.

The Drupal codebase lives in [`my-project/`](my-project/). It is a Composer
project based on `drupal/recommended-project` (Drupal 11.4, PHP 8.4).

## Local setup (DDEV)

Run everything from `my-project/`:

```
cd my-project
ddev config --project-type=drupal11 --docroot=web --php-version=8.4
ddev start
ddev composer install
ddev drush site:install standard --account-name=admin --site-name="Site Builder Practice" -y
ddev launch
```

`ddev drush site:install` prints the generated admin password. Prefer it over
the browser installer: closing the browser mid-install leaves a half-populated
database and a partial `settings.php`.

## PHP version and security (PHP2Shell, Oct 2026)

On 21 Oct 2026 PHP patched two unauthenticated remote-code-execution bugs
(CVE-2026-109618, CVE-2026-109619; a third, CVE-2026-115560, was added on
23 Oct). Fixed releases: **8.5.12, 8.4.27, 8.3.36, 8.2.35**. Anything older,
and all of 8.1 and below, is vulnerable.

- Drupal 11.4 requires PHP 8.3 or newer. This project targets 8.4.
- Check the patch level you are actually running: `ddev php -v`. If it is
  below the versions above, run `ddev poweroff`, upgrade DDEV, then
  `ddev start` so the web image is rebuilt.
- Any publicly reachable site needs the patched PHP too. Check your host.
- Until fully patched, PHP's guidance is to set
  `session.upload_progress.enabled=0` and restart all workers.

Source: [CERT-EU advisory 2026-018](https://cert.europa.eu/publications/security-advisories/2026-018).
Support dates: [php.net/supported-versions](https://www.php.net/supported-versions.php).

## Recovering from an interrupted install

```
ddev stop --remove-data     # deletes this project's database
chmod u+w web/sites/default web/sites/default/settings.php
rm web/sites/default/settings.php
ddev start
```

Then run the `drush site:install` step above again.

## Notes

- `composer.lock` is the source of truth for versions. After editing
  `composer.json`, run `ddev composer update` so the lock stays in sync;
  `composer validate` will complain if it is not.
- `vendor/`, `web/core/`, contrib code, `settings.php` and `web/sites/*/files/`
  are git-ignored and rebuilt by Composer or the installer.
- Many Drupal tutorials and videos predate Drupal 10/11. Check version
  constraints (Drush 13 for Drupal 11, no `drupal/mysql56`) before copying
  `composer require` lines from them.
