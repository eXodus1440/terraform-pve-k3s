configuration = [
  {
    vmid       = "7000"
    ipaddr_id  = "125"
    k3s_role   = "master"
    node_count = "1"
    sockets    = "1"
    cores      = "1"
    memory     = "2048"
    disks      = [
      {
        size    = "20G"
        type    = "scsi"
        storage = "local-zfs"
      },
    ]
  },
  {
    vmid       = "8000"
    ipaddr_id  = "135"
    k3s_role   = "worker"
    node_count = "1"
    sockets    = "2"
    cores      = "2"
    memory     = "32768"
    disks      = [
      {
        size    = "20G"
        type    = "scsi"
        storage = "local-zfs"
      },
      {
        size    = "50G"
        type    = "scsi"
        storage = "local-zfs"
      },
    ]
  }
]
