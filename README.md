# Uso de SOPS con Terraform "sops_file"

Ejemplo del uso del modulo de Terraform
["sops_file"](https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file) para decifrar archivos sensibles y generar archivos temporales, como por ejemplo, para desplieges con Helm. 

Se requiere tener instalado y configurado el [AWS CLI](), tener un rol de IAM con permisos para uso de una clave KMS (para ver como crear y configurar la clave KMS y rol IAM, puede ver el README en el subdirectorio aws_kms_iam_config), y los binarios [terraform](https://developer.hashicorp.com/terraform/downloads), [SOPS](https://github.com/getsops/sops), y [direnv](https://direnv.net/docs/installation.html), para seguir el ejemplo. Como alternativa a KMS, el uso de AGE no difiere mucho del ejemplo dado, y es gratuito para usar con SOPS.

Se debe copiar el .envrc.local-sample al .envrc.local
```
cp .envrc.local-sample .envrc.local 
```
Se debe editar con los valores necesarios, notablemente el AWS_PROFILE y
AWS_REGION, que son necesarias para el uso de SOPS con KMS. La variable SOPS_KMS_ARN debe contener el arn de la clave KMS para la cual el perfil o rol tiene permisos de uso para cifrar y decifrar. Si estamos
usando SOPS con AGE, deberíamos entonces setear el SOPS_AGE_KEY_FILE o
similares. Similarmente para apuntar al ARN o al AGE se puede usar el archivo .sops.yaml. Por favor referirse a [la documentación de SOPS](https://github.com/getsops/sops) y elegir su modo preferido. 

Luego de hacer esto, se debe correr `direnv allow`.

## Generar los archivos

El ejemplo es con un secrets.dec.yaml con el contenido siguiente: 

```yaml
username: admin
password: password
```
Tranquilamente podríamos usar como alternativa, un archivo de tipo .json. Usar el formato .yaml o .json nos permite referenciar valores usando sus claves.

Antes de empezar necesitamos cifrar nuestros archivos que vamos a guardar. Se cifra de la siguiente manera, en este ejemplo, en secrets.enc.yaml, usando el comando sops:
```
sops -e secrets.dec.yaml >  secrets.enc.yaml
```
Normalmente NO vamos a versionar los valores sensibles decifrados, se incluye 
el archivo como modo de ejemplo.

Para generar los archivos corremos:

```
terraform init && terraform plan && terraform apply
```

Se pueden setear permisos para los archivos, usar, como alternativa, nombres de archivos seteados en
variables, generar claves KMS desde un modulo de AWS, teniendo los
suficientes permisos, entre otras mejoras. 

Hay muchas configuraciones posibles, lo que se desea 
lograr en este demo es simplemente mostrar como cifrar con SOPS usando
Terraform y AWS KMS.


## Outputs 

Por seguridad, Terraform actualmente no soporta output de variables sensibles a la terminal, pero se puede usar el
output para ver los valores o guardarlos en un archivo con `terraform output -json`o `terraform output variable -raw`.Terraform detecta que las variables decifradas son variables sensibles y si no se define 'sensitive = true" se arroja error en el plan o en el apply.

## Output File 

Para guardar lo decifrado en un archivo, se puede usar el resource local_file, y
pasarle los valores desde el modulo sops_file. 

### Template File

Usar un template es ideal cuando se estan generando archivos .yaml para usar con
Helm, por ejemplo. Esto nos permite pasarle al modulo un archivo template, el
cual usara un reemplazo de variables con el sintaxis ${variable}, la cual se
define en el resource local_file, adentro del apartado content. 
