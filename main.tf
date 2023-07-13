
data "sops_file" "secrets" {
    source_file = "secrets.enc.yaml"
}


# Ejemplos de output, no se verán en la terminal 
output "user" {
     value = data.sops_file.secrets.data["username"]
     sensitive = true
   }
output "password" {
     value = data.sops_file.secrets.data["password"]
     sensitive = true
}

# Ejemplos de archivos locales
# ${path.module} es una variable de Terraform que 
# nos permite referenciar el path local al modulo.
# Es similar a correr el comando pwd en linux.
resource "local_file" "db-user" {
     content = data.sops_file.secrets.data["username"]
     filename = "${path.module}/output/username.dec"
   }
resource "local_file" "db-password" {
     content = data.sops_file.secrets.data["password"]
     filename = "${path.module}/output/password.dec"
}
# Ejemplo usando un template file de entrada, definiendo variables
# que se usaran adentro del archivo de template para generar outputs.
resource "local_file" "template" {
  content = templatefile("${path.module}/template.tpl", {
     username = data.sops_file.secrets.data["username"]
     password = data.sops_file.secrets.data["password"]
   })
     filename = "${path.module}/output/admin-file.dec"
}
