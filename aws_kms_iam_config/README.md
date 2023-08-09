# Configuración de AWS KMS e IAM para SOPS 

Guía para configurar AWS KMS e IAM, permitiendo el uso de SOPS con Terraform. Es
importante asegurarse que su cuenta de AWS tenga permisos necesarios para
creación y administración de claves KMS, roles IAM y políticas de permisos.

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
Navegar al panel de IAM en la Consola de AWS.
Hacer clic en "Roles" en la barra lateral izquierda, luego "Crear rol".
Elegir "Servicio AWS" como el tipo de entidad de confianza. Podes elegir uno generico como EC2, ya que este rol se usará principalmente con SOPS y Terraform.
Adjuntar políticas de permisos, en este paso podemos crear politicas nuevas o usar unas existentes. Para una guía de cuales permisos son necesarios, podes ver el archivo main.tf y las políticas definidas ahí mismo. Siempre es ideal otorgar los mínimos permisos necesarios, en este caso para leer, listar, cifrar y decifrar.
Revise y cree el rol.

#### Modifique las relaciones de confianza (si es necesario)
Si necesita modificar la relación de confianza (por ejemplo, para permitir que otra cuenta de usuario de AWS asuma el rol), haga clic en el rol, navegue a la pestaña "Relaciones de confianza" y edite la política.


### Limpieza 

Es crucial realizar la limpieza después de terminar para evitar costos innecesarios.

#### Elimine la clave KMS 
Navegar al panel de KMS y programar la eliminación de la clave KMS. Tenga en cuenta que AWS conserva la clave durante un período predeterminado (generalmente 7-30 días) antes de su eliminación real.

#### Elimine el rol IAM
Vaya al panel de IAM, haga clic en "Roles", seleccione el rol que creó y
elimínelo, y podes eliminar las políticas creadas también. Sin embargo, para su
seguridad, estos recursos no
tienen costos asociados, los
costos se asocian mayormente a las claves KMS.

## Con Terraform

Instrucciones para configurar AWS KMS e IAM utilizando archivos de Terraform incluidos en este repositorio.

Este repositorio contiene archivos de Terraform para configurar una clave KMS en AWS y un rol IAM con permisos para usar esa clave con SOPS.

### Requisitos previos

 - [Terraform
   instalado](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
 - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configurado con las credenciales adecuadas

### Instrucciones

Copie el archivo terraform.tfvars.example a terraform.tfvars:
```
cp terraform.tfvars.example terraform.tfvars
```
Edite este archivo para agregar sus datos, estos son el ARN del usuario AWS con permisos para crear los recursos, y la región donde serán creados. Acordate que no se debe versionar este archivo. Por esto es
que esta agregado al archivo .gitignore para este subdirectorio.

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

