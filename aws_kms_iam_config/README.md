# Configuración de AWS KMS e IAM para SOPS 

Guía para configurar AWS KMS e IAM, permitiendo el uso de SOPS con Terraform.

- [Consola AWS](#desde-la-consola-aws)
- [Terraform](#con-terraform)

**Nota:** El uso de AWS KMS tiene costos asociados. Consulte la página de precios de AWS para obtener la información más actualizada.

## Desde la consola AWS

Instrucciones paso a paso para configurar AWS KMS e IAM directamente desde la consola de AWS.

### Configuración de AWS KMS

#### Crear clave KMS
En la barra de búsqueda de servicios de AWS, escriba "KMS" y seleccione "Key Management Service".
Haga clic en "Crear clave".
Elija "Simétrica" y haga clic en "Siguiente".
Proporcione un alias y una descripción para la clave.
Configure los permisos administrativos y de uso de la clave.
Cree la clave.

### Configuración del Rol IAM para SOPS

#### Crear un nuevo rol
Navegue al panel de IAM en la Consola de AWS.
Haga clic en "Roles" en la barra lateral izquierda, luego "Crear rol".
Elija "Servicio AWS" como el tipo de entidad de confianza y seleccione el servicio que utilizará este rol.
Adjunte políticas de permisos que otorguen acceso a la clave KMS creada anteriormente, en este paso necesitamos al menos kms:Decrypt, kms:Encrypt. Acuerdese que se pueden crear politicas en el dashboard de IAM.
Revise y cree el rol.

#### Modifique las relaciones de confianza (si es necesario)
Si necesita modificar la relación de confianza (por ejemplo, para permitir que otra cuenta de usuario de AWS asuma el rol), haga clic en el rol, navegue a la pestaña "Relaciones de confianza" y edite la política.


### Limpieza 

Es crucial realizar la limpieza después de terminar para evitar costos innecesarios.

#### Elimine la clave KMS 
Navegue al panel de KMS y programe la clave para su eliminación. Tenga en cuenta que AWS conserva la clave durante un período predeterminado (generalmente 7-30 días) antes de su eliminación real.

#### Elimine el rol IAM
Vaya al panel de IAM, haga clic en "Roles", seleccione el rol que creó y elimínelo, y si ha creado politicas, puede eliminar estas también.


## Con Terraform

Instrucciones para configurar AWS KMS e IAM utilizando archivos de Terraform incluidos en este repositorio.

Este repositorio contiene archivos de Terraform para configurar una clave KMS en AWS y un rol IAM con permisos para usar esa clave con SOPS.

### Requisitos previos

 - Terraform instalado
 - AWS CLI configurado con las credenciales adecuadas

### Instrucciones

Inicialización de Terraform:

```
terraform init
```
Revise los cambios propuestos:

```
terraform plan
```

Aplicar la configuración:

```
terraform apply
```
Destruir los recursos (para evitar costos innecesarios):
```
terraform destroy
```

