Automatisation de la production
==============================

#### Par Devoitine Célèna et Richardin--Dutilleul Killian

## Sections du fichier de configuration

1. Nom du Workflow <br>
   La ligne ``name: CI`` définit le nom du workflow qui sera affiché dans l'interface de GitHub Actions.
   ```yaml
   name: CI
   ```

2. Déclenchement du Workflow <br>
   La ligne ``on: [push]`` permet de déclencher le workflow à chaque fois qu'une modification est poussée sur le
   dépôt.
   ```yaml
   on: [push]
   ```

3. Jobs <br>
   La section ``jobs`` définit les tâches qui seront exécutées. Dans ce cas, il y a un seul job nommé ``build-test``,
   qui s'exécute sur un environnement Ubuntu.
   ```yaml
   jobs:
    build-test:
      runs-on: ubuntu-latest
   ```

4. Étapes du Job <br>

    - Les étapes du job sont décrites sous la section steps. <br>

      a. Checkout code <br>
        - L'étape ``Checkout code`` utilise ``actions/checkout@v3`` pour cloner le dépôt dans l'environnement de
          travail. <br>
         ```yaml
         - name: Checkout code 
           uses: actions/checkout@v3
         ```

      b. Install dependencies <br>
        - L'étape ``Install dependencies`` utilise ``php-actions/composer@v6`` pour installer les dépendances PHP
          définies dans le fichier ``composer.json``. <br>
         ```yaml
         - name: Install dependencies
           uses: php-actions/composer@v6
         ```

      c. Run PHPUnit tests <br>
        - L'étape ``Run PHPUnit tests`` utilise ``php-actions/phpunit@v3`` pour exécuter les tests unitaires. Elle
          précise la version de PHPUnit à utiliser, ainsi que la version de PHP et les extensions nécessaires. <br>
         ```yaml
         - name: Run PHPUnit tests
           uses: php-actions/phpunit@v3
           with:
             version: 9.6.1
             php_version: '8.2'
             php_extensions: gd mbstring pcov tokenizer
         ```

      d. Generate coverage summary <br>
        - L'étape ``Generate coverage summary`` utilise ``irongut/CodeCoverageSummary@v1.3.0`` pour générer un résumé de
          la couverture de code à partir du fichier ``log/coverage-cobertura.xml``. <br>
          ```yaml
          - name: Generate coverage summary
            uses: irongut/CodeCoverageSummary@v1.3.0
            id: coverage_summary
            with:
              filename: log/coverage-cobertura.xml
          ```

      e. Run PHPCS <br>
        - L'étape ``Run PHPCS`` exécute le PHP CodeSniffer pour vérifier le code source avec le rapport résumé. La
          commande continue même en cas d'erreurs. <br>
          ```yaml
          - name: Run PHPCS
            run: vendor/bin/phpcs --extensions=php ./lib/ --report=summary
            continue-on-error: true
          ```

      f. Run PHPMD <br>
        - L'étape ``Run PHPMD`` exécute le PHP Mess Detector pour détecter les problèmes de qualité du code. Cette
          commande continue également en cas d'erreurs. <br>
          ```yaml
          - name: Run PHPMD
            run: vendor/bin/phpmd ./lib ansi codesize,unusedcode,naming
            continue-on-error: true
          ```

      g. Run PHPStan <br>
        - L'étape ``Run PHPStan`` analyse le code pour détecter les erreurs et améliorer la qualité du code en utilisant
          PHPStan avec le niveau d'analyse maximal. <br>
          ```yaml
          - name: Run PHPStan
            run: vendor/bin/phpstan analyse ./lib/ --level=max
            continue-on-error: true
          ```

## Remarque :

Pour que les tests fonctionnent sans erreurs d'allocation mémoire, il est nécessaire de retirer la ligne suivante dans
le fichier phpunit.xml, qui ajoute les bibliothèques au projet :

```xml
<directory suffix=".php">./vendor</directory>
```

## Le fichier de configuration

Voici la version complète de notre action GitHub qui permet de tester le projet PHP avec PHPUnit. <br>

```yaml
name: CI

on: [ push ]

jobs:
  build-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Install dependencies
        uses: php-actions/composer@v6

      - name: Run PHPUnit tests
        uses: php-actions/phpunit@v3
        with:
          version: 9.6.1
          php_version: '8.2'
          php_extensions: gd mbstring pcov tokenizer
        if: success()

      - name: Generate coverage summary
        uses: irongut/CodeCoverageSummary@v1.3.0
        id: coverage_summary
        with:
          filename: log/coverage-cobertura.xml

      - name: Run PHPCS
        run: vendor/bin/phpcs --extensions=php ./lib/ --report=summary
        continue-on-error: true

      - name: Run PHPMD
        run: vendor/bin/phpmd ./lib ansi codesize,unusedcode,naming
        continue-on-error: true

      - name: Run PHPStan
        run: vendor/bin/phpstan analyse ./lib/ --level=max
        continue-on-error: true
```


