# PayMaster модуль для NoDeny 49/50

Модуль для биллинговой системы NoDeny реализует протокол взаимодействия с [платежной системой PayMaster](http://www.paymaster.ua).

## Установка

- Скопировать скрипт result.pl в директорию /usr/local/www/apache22/cgi-bin/paymaster
- Установить секретный ключ SECRET в с крипте result.pl
- Скопировать файлы из директории www в /usr/local/www/apache22/data/paymaster
- Скопировать строку настройки из plugin_reestr.cfg в файл /usr/local/nodeny/web/plugin_reestr.cfg
- Исправить скрипт биллинга /usr/local/nodeny/web/paystype.pl аналогично вложенному,
  чтобы корректно отображались платежные категории
- Скопировать Spaymaster.pl в директорию /usr/local/nodeny/web
- Изменить MERCHANT_ID в скрипте Spaymaster.pl
- Изменить STAT_HOST в скрипте Spaymaster.pl на реальный хост статистики (например, stat.provider.ua)
- В административной панели биллинга добавить модуль Spaymaster
- В клиентской статистике должен появиться новый раздел

## Maintainers and Authors

Yuriy Kolodovskyy (https://github.com/kolodovskyy)

## License

MIT License. Copyright 2014 [Yuriy Kolodovskyy](http://twitter.com/kolodovskyy)
