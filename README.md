![CD Aude logo](https://camo.githubusercontent.com/538f2c018f62bb28bd8c580cf059491ac5d57f15/687474703a2f2f7777772e617564652e66722f696d616765732f4742495f434731312f6c6f676f2e706e67)

# Conseil Departemental des Jeunes de l'Aude

<http://cdj.aude.fr/>

Citizen Participation and Open Government Application

This is a fork of [CONSUL](http://consulproject.org/en/) the eParticipation website originally developed for the Madrid City government eParticipation website.

[![Build Status](https://travis-ci.org/CDJ11/CDJ.svg?branch=master)](https://travis-ci.org/CDJ11/CDJ)
[![Maintainability](https://api.codeclimate.com/v1/badges/5c7abb32f3c8f7cbd4ef/maintainability)](https://codeclimate.com/github/CDJ11/CDJ/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5c7abb32f3c8f7cbd4ef/test_coverage)](https://codeclimate.com/github/CDJ11/CDJ/test_coverage)

[![Crowdin](https://d322cqt584bo4o.cloudfront.net/consul/localized.svg)](https://crowdin.com/project/consul)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)

[![Accessibility conformance](https://img.shields.io/badge/accessibility-WAI:AA-green.svg)](https://www.w3.org/WAI/eval/Overview)

## À propos du Conseil Départemental des Jeunes (CDJ)

Voir la [page dédiée sur le site du département](https://www.aude.fr/670-conseil-departemental-des-jeunes.htm)

## État du projet

* Le site a été lancé en Janvier 2018 sur la base d'un [autre fork](https://github.com/CDJ11/CDJ_old) réalisé par les équipes du Département de l'Aude.
* La personalisation de la plateforme a (re)démarrée en Février 2018.

## Participer à l'amélioration du logiciel

* TODO - Aide à la traduction
* TODO - Beta test des nouvelles fonctionalités

## Informations pour les développeurs sur ce fork

### Workflow

* la branche `master` est la référence qui doit rester déployable en production à chaque instant
* les Pull Requests sont automatiquement fusionnées en faisant un **Squash and Merge** afin de garder un historique plus lisibles des évolutions qui ont eut lieux sur ce fork
  * [exemple de commit issu d'un "squash and merge"](https://github.com/CDJ11/CDJ/commit/1445a0e069b81983d85008e6941925d33bfeedf4)
* le fork est mis à jour en suivant [le processus décrit dans la doc officielle](https://consul_docs.gitbooks.io/docs/content/en/forks/update.html). Une documentation complémentaire spécifique aux particularités du présent projet est disponible dans le [dossier doc](https://github.com/CDJ11/CDJ/blob/master/doc/custom/monter-en-version.md).

### Traductions

* Les traductions sont personalisées pour le CDJ uniquement dans le dossier `config/locales/custom/'
  * ces fichiers sont prioritaires sur tous les autres
  * seules les clés à personaliser sont conservées dans ces fichiers
* Les traductions officielles `fr` de Consul peuvent être importées depuis `upstream` ou depuis [Crowdin](https://crowdin.com/project/consul/fr#) pour venir écraser les traductions existantes dans `config/locales/fr/`

### Documentation de Foundation

Le framework CSS utilisé est Foundation en version 6.2.4.

[Voir la documentation sur Github](https://github.com/zurb/foundation-sites/tree/v6.2.4/docs/pages)
car la documentation disponible sur le site web du projet correspond à une version
plus récente.

### Omniauth 

#### Facebook

Pour se connecter via facebook en local :

Utiliser ngrok : `./ngrok http 3000`

Dans l'[interface développeur de facebook](https://developers.facebook.com/apps) : 
- créer une application de test, si elle n'existe pas encore (credentials à renseigner dans `config/secrtes.yml`)
- renseigner l'url de callback à partir de l'url https fournie par ngrok dans Produits > Facebook login > Paramètres > champs "URI de redirection OAuth valides" -> ex `https://a171c66a.ngrok.io/users/auth/facebook/callback`
- renseigner le "Domaines de l’app" dans Paramètres > Général -> ex `a171c66a.ngrok.io`
- renseigner "URL du site" dans Paramètres > Général -> block Site web -> `https://a171c66a.ngrok.io/`

## Déploiements

Le projet utilise capistrano

```bash
# sur votre machine
# Au 1er déploiement pour créer le fichier de config
cap production puma:config 

# Par la suite
cap production deploy       # Déploiement simple sur l'environnement de production (avec les migrations)
cap production puma:restart # Relance l'instance puma
cap production deploy:seed  # Génération des seeds sur l'environnement de production
```

### Import de la base de donnée originelle du CDJ en production

Une première version du CDJ pré-existait, avec des données qu'il a fallu importer. Les migrations n'étant pas à jour sur le projet originel, il est nécessaire de faire l'import en plusieurs temps : 
- migrer jusqu'à une certaine version des migrations,
- faire l'import
- faire la suite des migrations jusqu'aux migrations actuelles
- lancer des scripts pour compléter les données

Pour des questions de droit casse-bonbons, la procédure d'installation est un peu bancale, et clairement améliorable. Vu que la procédure suivante est supposée n'être faite qu'une fois, à l'installation du projet, je n'ai pas poussé plus loin mes recherches.

**Pré-requis** : avoir en local la BDD à importer et  le fichier csv de complétion des utilisateurs (actuellement disponibles dans le dossier drive du projet, et gitignoré pour des questions de confidentialité des données). 

1. Copier l'export de la BDD, et le fichier csv de complétion des utilisateurs, de votre serveur local sur le serveur de prod :

```bash
scp  -P 124 chemin-vers-le-fichier.sql USER@ADRESSE-SERVEUR:/home/deploy/www/cdj_aude/current/doc/custom/ 
scp  -P 124 CDJ_completion_utilisateurs.csv USER@ADRESSE-SERVEUR:/home/deploy/www/cdj_aude/current/doc/custom/ 
```

2. Etapes de l'import :

```bash
# Sur serveur, avec le user mako, couper temporairement les connections à la db : 
sudo service postgresql restart
# En local
cap production deploy:prepare_import_db
# Sur serveur, avec un user root : 
cd /home/deploy/www/cdj_aude/current
psql cdj_aude_production < doc/custom/extract_db_insert_180326.sql
# En local
cap production deploy:finish_import_db
cap production delayed_job:restart
```

Certaines releases nécessitent des actions particulières suite à une montée de version.
Ces actions sont documentées dans [les releases](https://github.com/consul/consul/releases).

### en développement

Un script résume l'ensemble des étapes et peut être lancé pour effectuer toutes les étapes dans la foulée : 

`./lib/custom/import_db.sh`

## Changements principaux par rapport à Consul 

- Développement d'un module Actualité, page d'accueil par défaut des personnes connectées
- Les utilisateurs sont vérifiés par principe, dès leur inscription, sans avoir à vérifier de document officiel
- Les utilisateurs doivent renseigner + de données à l'inscriptions : nom, prénom, âge, adresse...
- Pas d'inscription en tant qu'organisation.
- Age maximum d'inscription à 26 ans - 1 jour.
- L'inscription via facebook ne fait que pré-remplir un profil utilisateur, au lieu de créer directement un compte
- Un compte utilisateur peut être lié/délié de facebook après coup.
- Les `Proposal` ont par défaut le nom de leur `author` comme responsible_name (et non `document_number`)
- Nouveau rôle : `Animator`, qui partage certaines des abilities des admin et des modérateurs. Représente un membre du CA du conseil des jeunes. Détails des droits dans ce [tableur](https://docs.google.com/spreadsheets/d/17lfoyj-qtRVrncjWBN9L-d2yKt1j9md-H_PhZUq_wD4/edit#gid=131811949). Les rôles `Manager`, `Moderator`, `Valuator`, `poll officer` sont inutilisés.
- Nouvelle organisation du back office : création d'un menu "Communication" reprenant des éléments du menu "Administration". Simplification des autres menus. Détails de l'armature dans ce [tableur](https://docs.google.com/spreadsheets/d/17lfoyj-qtRVrncjWBN9L-d2yKt1j9md-H_PhZUq_wD4/edit#gid=131811949)
- Limitation des votes aux votes en ligne. 


## Configuration for development and test environments

**NOTE**: For more detailed instructions check the [docs](https://consul_docs.gitbooks.io/docs/)

Prerequisites: install git, Ruby 2.3.2, `bundler` gem, Node.js and PostgreSQL (>=9.4).

```bash
git clone https://github.com/CDJ11/CDJ.git
cd consul
bundle install
cp config/database.yml.example config/database.yml
cp config/secrets.yml.example config/secrets.yml
bin/rake db:create
bin/rake db:migrate
bin/rake db:dev_seed
bin/rake db:custom_seed
RAILS_ENV=test rake db:setup
```

Run the app locally:

```bash
bin/rails s
```

Prerequisites for testing: install ChromeDriver >= 2.33

Run the tests with:

```bash
bin/rspec
```

You can use the default admin user from the seeds file:

 **user:** admin@consul.dev
 **pass:** 12345678

But for some actions like voting, you will need a verified user, the seeds file also includes one:

 **user:** verified@consul.dev
 **pass:** 12345678

## Configuration for production environments

See [installer](https://github.com/consul/installer)

## Documentation

Check the ongoing documentation at [https://consul_docs.gitbooks.io/docs/content/](https://consul_docs.gitbooks.io/docs/content/) to learn more about how to start your own CONSUL fork, install it, customize it and learn to use it from an administrator/maintainer perspective. You can contribute to it at [https://github.com/consul/docs](https://github.com/consul/docs)

## License

Code published under AFFERO GPL v3 (see [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt))

## Contributions

See [CONTRIBUTING.md](CONTRIBUTING.md)
