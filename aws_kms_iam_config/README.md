# Configuración de AWS KMS e IAM para SOPS con Terraform

Este repositorio contiene archivos de Terraform para configurar una clave KMS en AWS y un rol IAM con permisos para usar esa clave con SOPS.

## Requisitos previos

 - Terraform instalado
 - AWS CLI configurado con las credenciales adecuadas

## Instrucciones

Inicialización de Terraform:

```
terraform init
```
Aplicar la configuración:

```
terraform apply
```
Destruir los recursos (cuando ya no sean necesarios):
```
terraform destroy
```
