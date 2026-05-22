resource "mongodbatlas_project" "project" {
  name   = var.mongo_db_name
  org_id = var.mongo_org_id
}

resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id   = mongodbatlas_project.project.id
  name         = var.mongo_db_name
  cluster_type = "REPLICASET"

  replication_specs = [
    {
      region_configs = [
        {
          priority              = 7
          provider_name         = "TENANT"
          backing_provider_name = "AWS"
          region_name           = "EU_CENTRAL_1"

          electable_specs = {
            instance_size = "M0"
          }
        }
      ]
    }
  ]
}

resource "mongodbatlas_project_ip_access_list" "allow_all" {
  project_id = mongodbatlas_project.project.id
  cidr_block = "0.0.0.0/0"
}

resource "mongodbatlas_database_user" "db_user" {
  username           = var.mongo_username
  password           = var.mongo_password
  project_id         = mongodbatlas_project.project.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }

  lifecycle {
    ignore_changes = [password]
  }
}
