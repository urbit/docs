{
  "apiVersion": "2019-12-01",
  "location": "eastus",
  "name": $SHIPNAME,
  "properties": {
    "containers": [
      {
        "name": $SHIPNAME,
        "properties": {
          "environmentVariables": [],
          "image": "tloncorp/urbit:latest",
          "ports": [
            {
              "port": 80
            },
            {
              "port": 34343,
              "protocol": "UDP"
            }
          ],
          "resources": {
            "requests": {
              "cpu": 1,
              "memoryInGB": 1.5
            }
          },
          "volumeMounts": [
            {
              "mountPath": "/urbit",
              "name": "piervolume"
            }
          ]
        }
      }
    ],
    "osType": "Linux",
    "restartPolicy": "Always",
    "ipAddress": {
      "type": "Public",
      "ports": [
        {
          "port": 80
        },
        {
          "port": 34343,
          "protocol": "UDP"
        }
      ],
      "dnsNameLabel": $SHIPNAME
    },
    "volumes": [
      {
        "name": "piervolume",
        "azureFile": {
          "sharename": $SHARENAME,
          "storageAccountName": $STORAGEACCOUNTNAME,
          "storageAccountKey": $STORAGEACCOUNTKEY
        }
      }
    ]
  },
  "tags": {},
  "type": "Microsoft.ContainerInstance/containerGroups"
}
