# Outputs for the hetzner_k8s_interfaces module

output "kubernetes_secret_hcloud_id" {
  description = "ID of the Kubernetes secret for Hetzner Cloud"
  value       = kubernetes_secret.hcloud.id
}

output "helm_release_hccm_id" {
  description = "ID of the Hetzner Cloud Controller Manager Helm release"
  value       = helm_release.hccm.id
}

output "helm_release_hcloud_csi_id" {
  description = "ID of the Hetzner CSI Helm release"
  value       = helm_release.hcloud_csi.id
}