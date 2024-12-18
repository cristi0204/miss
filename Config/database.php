<?php
// Do not edit this file directly! It is automatically generated after every container start.
class DATABASE_CONFIG {
    public $default = [
        'datasource' => 'Database/MysqlExtended',
        'persistent' => false,
        'host' => '{{ MYSQL_HOST }}',
        'login' => '{{ MYSQL_LOGIN }}',
        'port' => {{ MYSQL_PORT }},
        'password' => {{ MYSQL_PASSWORD | str }},
        'database' => '{{ MYSQL_DATABASE }}',
        'prefix' => '',
        'encoding' => 'utf8',
        'settings' => [
            'time_zone' => '"+00:00"',
    {% if MYSQL_SETTINGS -%}
        {% for setting, value in MYSQL_SETTINGS.items() %}
            '{{ setting }}' => '{{ value }}',
        {% endfor %}
    {%- endif %}
        ],
{% if MYSQL_FLAGS %}
        'flags' => [
    {% for flag, value in MYSQL_FLAGS.items() %}
            '{{ flag }}' => '{{ value }}',
    {% endfor %}
        ]
{% endif %}
    ];
}
