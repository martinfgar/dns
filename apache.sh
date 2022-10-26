#!/bin/bash

apt-get update

apt-get install -y apache2

echo "<h1>Hola desde apache!</h1>">>/var/www/html/index.html
