#---------------------------
# Elastic Container Registry
#---------------------------

resource "aws_ecr_repository" "saha-ecr" {
  name                 = "saha-sandbox-ecr"
  image_tag_mutability = "MUTABLE"

}
