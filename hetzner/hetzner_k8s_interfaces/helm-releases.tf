# Helm releases for the hetzner_k8s_interfaces module

resource "helm_release" "hccm" {
  name             = "hccm"
  repository       = "https://charts.hetzner.cloud"
  chart            = "hcloud-cloud-controller-manager"
  namespace        = "kube-system"
  create_namespace = true
  atomic           = true
  timeout          = 300

  set {
    name  = "networking.enabled"
    value = true
  }

  depends_on = [
    null_resource.module_depends_on
  ]
}

resource "helm_release" "hcloud_csi" {
  name             = "hcloud_csi"
  repository       = "https://charts.hetzner.cloud"
  chart            = "hcloud-csi"
  namespace        = "kube-system"
  create_namespace = true
  atomic           = true
  timeout          = 300

  depends_on = [
    kubernetes_secret.hcloud,
    null_resource.module_depends_on
  ]
}