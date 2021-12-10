terraform {
  backend "remote" {
    organization = "itau-gama"

    workspaces {
      name = "gama"
    }
  }
}