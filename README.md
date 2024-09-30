Automatisation de la production
==============================
Devoitine Célèna <br>
Richardin--Dutilleul Killian
<br>

#### Pour que les tests fonctionne sans erreur d'allocation mémoire nous devons retirer cette ligne dans le fichier phpunit.xml.
#### Cette ligne permet d'ajouter les librairies au projet, nous partons du principe que si elles sont en ligne, c'est qu'elles ont été testé.

```
<directory suffix=".php">./vendor</directory>
```
<br>

#### Cette ligne permet de définir le nom de notre action GitHub. <br>
```
name: CI
```
<br>

#### Cette ligne permet de declencher les actions github à chaque fois que le projet est mis à jour (push) sur Github. <br>
```
on: [push]
```
<br>

#### Cette section permet de définir les jobs du workflow. 
Dans notre cas nous avons un seul job qui s'appelle build-test.
Ces tests sont exécutés sur une machine sous l'OS Ubuntu<br>
```
jobs:
build-test:
runs-on: ubuntu-latest
```
<br>

#### Cette section permet de définir les étapes de notre job. <br>
```
steps:
```
<br>

#### L'action ``actions/checkout@v3`` est utilisée pour cloner le dépôt Git dans l'environnement Ubuntu afin que le code soit disponible pour les étapes suivantes.
```
- uses: actions/checkout@v3
```
<br>

#### Cette action exécute Composer pour gérer les dépendances PHP. L'action ``php-actions/composer@v6`` installe les paquets définis dans le fichier composer.json
```
- uses: php-actions/composer@v6
```
<br>

#### Cette action exécute PHPUnit pour exécuter les tests unitaires. L'action ``php-actions/phpunit@v3`` exécute les tests unitaires définis dans le fichier phpunit.xml
```
- uses: php-actions/phpunit@v3
    with:
        php_version: '8.2'
        php_extensions: "gd"
```

#### Voici la version complète de notre action GitHub qui permet de tester le projet PHP avec PHPUnit. <br>
```
name: CI
on: [push]
jobs:
build-test:
runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: php-actions/composer@v6
    - uses: php-actions/phpunit@v3
      with:
        php_version: '8.2'
        php_extensions: "gd"
```


