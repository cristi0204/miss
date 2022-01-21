<?php
// Do not edit this file directly! It is automatically generated after every container start.
class EmailConfig
{
    public $default = [
        'transport' => 'Smtp',
        'host' => '{{ SMTP_HOST }}',
        'port' => 25,
        'timeout' => 30,
        'username' => '{{ SMTP_USERNAME }}',
        'password' => '{{ SMTP_PASSWORD }}',
        'client' => null,
        'log' => false,
        'tls' => true,
        'context' => ['ssl' => ['cafile' => '/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem']],
    ];
}
