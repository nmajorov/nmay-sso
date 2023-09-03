# My sso image for development
RedHat SSO 7.6  cutomized  image for development

variables:

        KEYCLOAK_ADMIN   (admin by default)
        KEYCLOAK_PASSWORD (admin - if not specified)

it use posgresql database as backend database


        DB_ADDR  database address   for example  DB_ADDR="host.containers.internal:5432"
        DB_DATABASE    database to use  
        DB_SCHEMA     public by default
        DB_USER   database user    keycloak by default
        DB_PASSWORD     database password  keycloak by default

