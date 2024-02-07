#-----------------------
# EKS CLuster Definition
#-----------------------

resource "aws_eks_cluster" "ekssaha" {
  name     = "${var.eks_cluster}"
  role_arn = aws_iam_role.ekssaharole.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    subnet_ids              = [element(aws_subnet.private_subnet.*.id, 0), element(aws_subnet.private_subnet.*.id, 1), element(aws_subnet.private_subnet.*.id, 2)]
    #vpc_id                  = "aws_vpc.saha_vpc.id"
    security_group_ids      = ["${aws_security_group.k8s_sg.id}"]
#"aws_vpc" "saha_vpc"
}
  depends_on = [
    aws_iam_role_policy_attachment.ekssaharole-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.ekssaharole-AmazonEKSVPCResourceController,
  ]
}


#-------------------------
# IAM Role for EKS Cluster
#-------------------------

resource "aws_iam_role" "ekssaharole" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "ekssaharole-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ekssaharole.name
}

resource "aws_iam_role_policy_attachment" "ekssaharole-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.ekssaharole.name
}

#--------------------------------------
# Enabling IAM Role for Service Account
#--------------------------------------

data "tls_certificate" "ekstls" {
  url = aws_eks_cluster.ekssaha.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eksopidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.ekstls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.ekssaha.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "eksdoc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksopidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eksopidc.arn]
      type        = "Federated"
    }
  }
}


#--------------------
# EKS Cluster Add-Ons
#--------------------
resource "aws_eks_addon" "vpc-cni" {
  cluster_name                = aws_eks_cluster.ekssaha.name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.14.1-eksbuild.1"
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.ekssaha.name
  addon_name                  = "coredns"
  addon_version               = "v1.10.1-eksbuild.2"
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name                = aws_eks_cluster.ekssaha.name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.28.1-eksbuild.1"     
  
}
