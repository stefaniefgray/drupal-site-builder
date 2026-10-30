# drupal-site-builder

Repository for Drupal Site Builder certification exam work.

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
