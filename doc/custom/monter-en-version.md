# Recommendations pour les montées en versions 

## Créer une branche spécifique

Exemple pour la montée à 0.16 : 

```
git checkout -b consul016
g fetch --prune # si besoin
g fetch upstream
g merge v0.16
```

... Et commencer par résoudre tous les conflits :)

## Comparer les changements depuis la précédente version.

Par exemple, pour comparer la v0.15 et la v0.16, lors du passage à la v0.16 : 

[https://github.com/consul/consul/compare/v0.15...v0.16](https://github.com/consul/consul/compare/v0.15...v0.16)

Etre attentif à tout changement intervenu sur des fichiers qui ont été customisé.

Etre attentif à tout changement dans les menus admin, car certains nouveaux fichiers sont des copies, placés ailleurs, de fichiers existants.


| Fichier nouveau                                                 | Fichier source d'inspiration                    |
| ----------------------------------------------------------------|-------------------------------------------------|
| controllers/custom/admin/animators_controller.rb                | controllers/admin/administrators_controller.rb  |
| controllers/custom/communication/banners_controller.rb          | controllers/admin/banners_controller.rb         |
| controllers/custom/communication/base_controller.rb             | controllers/moderation/base_controller.rb       |
| controllers/custom/communication/dashboard_controller.rb        | controllers/moderation/dashboard_controller.rb  |
| controllers/custom/communication/emails_download_controller.rb  | controllers/admin/emails_download_controller.rb |
| controllers/custom/communication/newsletters_controller.rb      | controllers/admin/newsletters_controller.rb     |
| controllers/custom/communication/tags_controller.rb             | controllers/admin/tags_controller.rb            |


