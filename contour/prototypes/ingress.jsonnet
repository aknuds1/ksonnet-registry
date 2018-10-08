// @apiVersion 0.0.1
// @name com.github.pkg.contour-ingress
// @description A Contour/cert-manager ingress.
// @shortDescription A Contour/cert-manager ingress.
// @param namespace string Kubernetes namespace; default is 'default'
// @param name string Name of app to identify all K8s objects in this prototype
// @param hostname string Hostname for ingress
// @param clusterIssuer string cluster-issuer to use to issue certificates
// @param servicePort string Port of back-end service
local namespace = "import 'param://namespace'";
local appName = "import 'param://name'";
local hostname = "import 'param://hostname'";
local clusterIssuer = "import 'param://clusterIssuer'";
local servicePort = "import 'param://servicePort'";

{
  apiVersion: "extensions/v1beta1",
  kind: "Ingress",
  metadata: {
    name: appName,
    namespace: namespace,
    labels: {
      app: appName,
    },
    annotations: {
      "kubernetes.io/tls-acme": "true",
      "certmanager.k8s.io/cluster-issuer": clusterIssuer,
      "ingress.kubernetes.io/force-ssl-redirect": "true",
    },
  },
  spec: {
    tls: [
      {
        secretName: "%s-tls" % [appName,],
        hosts: [
          hostname,
        ],
      },
    ],
    rules: [
      {
        host: hostname,
        http: {
          paths: [
            {
              backend: {
                serviceName: appName,
                servicePort: servicePort,
              },
            }
          ],
        },
      },
    ],
  },
}
