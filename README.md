# Plantilla para rails 4

Una pobre plantilla para iniciar un proyecto en rails, con autenticación, autorización, y que se vea relativamente bien (bootstrap).

## Ejemplo de uso

````bash
rails new [nombre_aplicación] -d postgresql -m https://raw.github.com/aldrinmartoq/amartoq-rails-bootstrap/master/template.rb

rails server
```

Luego, ir a http://localhost:3000/ e ingresar con usuario/clave admin@a0.cl/123.

## Features

1. Gemas incorporadas y configuradas, principalmente
  - bootstrap
  - simple_form
  - cancan
  - authlogic
  - quiet_assets
2. Repositorio en git, revisa el registro de 'git log' para ver cómo se implementó cada característica.
3. Modelo de usuario en base a email/password, con autenticación y autorización listas.
4. Controlador de inicio, incluyendo login y logout.
