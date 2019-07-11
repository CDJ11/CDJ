# Mise en production

Rendre valides les profils admin auxquels il manque des infos

```ruby
u = User.where(email: 'patrice.gallardo@aude.fr').first
u.update(firstname: 'Patrice', lastname: 'Gallardo', date_of_birth: 20.years.ago, postal_code: '11000')
```
