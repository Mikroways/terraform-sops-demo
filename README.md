# Uso de SOPS con Terraform "sops_file"

Ejemplo del uso del modulo de Terraform
["sops_file"](https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file) para decifrar archivos sensibles y generar archivos temporales, como por ejemplo, para desplieges con Helm. 

Se requiere tener instalado AWS CLI, tener un rol de IAM, uso de una clave KMS (alternativamente uso de AGE no difiere mucho del ejemplo dado), terraform, sops, direnv, para seguir el ejemplo. 

Se debe copiar el .envrc-sample al .envrc 
```
cp .envrc-sample .envrc 
```
Por defecto el .envrc-sample usa el rol eks-testing de mikroways para cifrar y
decifrar los archivos. 

Si se desea usar otros valores, se debe editar con los valores necesarios, notablemente el AWS_PROFILE y
AWS_REGION que son necesarias para el uso de SOPS con KMS. Nos podemos imaginar que
usando SOPS con AGE, deberíamos entonces setear el SOPS_AGE_KEY_FILE o
similares. Alternativamente para apuntar al ARN o al AGE; se puede usar el
archivo .sops.yaml, también incluido como alternativa. Por favor referirse a la
documentación de SOPS y elegir su preferida.

Luego, se debe correr `direnv allow`.

El ejemplo es con un secrets.dec.json con el contenido siguiente: 

```json
{
  username: admin,
  password: password
}
```
Antes de empezar guardamos el contenido en un archivo, ejemplo incluido,
secrets.dec.json, y lo ciframos en secrets.enc.json usando sops:
```
sops -e secrets.dec.json >  secrets.enc.json
```
Normalmente NO vamos a versionar los valores sensibles decifrados, se incluye 
el archivo como modo de ejemplo.

Se puede usar, como alternativa, nombres de archivos seteados en
variables, generar claves KMS desde un modulo de AWS, teniendo los
suficientes permisos, entre otras mejoras. 

Hay muchas configuraciones posibles, lo que se desea 
lograr en este demo es simplemente mostrar como cifrar con SOPS usando
Terraform y AWS KMS.


## Outputs 

Por seguridad, Terraform actualmente no soporta output de variables sensibles a la terminal, pero se puede usar el
output para ver los valores o guardarlos en un archivo con terraform output -json. Terraform detecta que son
variables decifradas y si no se define 'sensitive = true" se arroja error en el
plan o en el apply.

## File 

Para guardar lo decifrado en un archivo, se puede usar el resource local_file, y
pasarle los valores desde el modulo sops_file. 

### Template File

Usar un template es ideal cuando se estan generando archivos .yaml para usar con
Helm, por ejemplo. Esto nos permite pasarle al modulo un archivo template, el
cual usara un reemplazo de variables con el sintaxis ${variable}, la cual se
define en el resource local_file, adentro del apartado content. 


