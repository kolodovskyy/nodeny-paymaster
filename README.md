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
- Изменить STAT_URL в скрипте Spaymaster.pl на реальный хост статистики (например, http://stat.provider.ua, БЕЗ /cgi-bin/stat.pl)
- В административной панели биллинга добавить модуль Spaymaster
- В клиентской статистике должен появиться новый раздел

## Настройка PayMaster

- URL страницы успешной оплаты: оставить пустой
- Метод вызова URL страницы успешной оплаты: GET
- URL страницы неуспешной оплаты: оставить пустой
- Метод вызова URL страницы неуспешной оплаты: GET
- URL страницы результата: https://ADMINHOST/cgi-bin/paymaster/result.pl (ADMINHOST заменить на свой, например: admin.site.com.ua)
- Метод вызова URL страницы результата оплаты: POST
- Секретный ключ: сгенерировать случайный, который будет использоваться как SECRET
- Метод формирования контролькой подписи: MD5
- Отправлять предзапрос: НЕТ
- Проверять уникальность номера счета: НЕТ
- Повторно отправлять Payment Notification при сбоях: ДА
- Протокол совместимости: PayMaster
- Логотип: можно загрузить логотип провайдера

## Maintainers and Authors

Yuriy Kolodovskyy (https://github.com/kolodovskyy)

## License

MIT License. Copyright 2014 [Yuriy Kolodovskyy](http://twitter.com/kolodovskyy)
