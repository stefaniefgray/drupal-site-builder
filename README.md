# drupal-site-builder

Repository for Drupal Site Builder certification exam work.

The Drupal codebase lives in [`my-project/`](my-project/). It is a Composer
project based on `drupal/recommended-project` (Drupal 11.4, PHP 8.3).

## Local setup (DDEV)

Run everything from `my-project/`:

```
cd my-project
ddev config --project-type=drupal11 --docroot=web --php-version=8.3
ddev start
ddev composer install
ddev drush site:install standard --account-name=admin --site-name="Site Builder Practice" -y
ddev launch
```

`ddev drush site:install` prints the generated admin password. Prefer it over
the browser installer: closing the browser mid-install leaves a half-populated
database and a partial `settings.php`.

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
