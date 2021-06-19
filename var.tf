variable "access_key" { default = "AKIAR6MSGNQMXIEQ3RYJ" }
variable "secret_key" { default = "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" }
variable "public_key_pair" { default = "AAAAB3NzaC1yc2EAAAADAQABAAABAQC2llOuNWOEKjgaNX84ygpeIL5mGqgq0myvFZrSKgjJBfNOt0yFTIgJQtJokmQPav4e1l3oyuO51skldXYJTEgO8lSKaI95vbiIxre0VST1/0BC5XpZKeTexDEtVWvAhrOE2r70BA0PzBrkcCVF4Q+vIsq40Qu1v1KQytEmwuZnG/jrvz5Xw3IFiuUJCDdR66z/D2OrWDhygweXB4pMUIGRVJmvY0l/wg5IN667P0okXoM9VY1NmfTqApHri1Bzf7wkZOT+HZiD7tbd59jUAqzNZJMSW7Fp1prAFAKuiVoOI+PJgvVAB6peY5HIL1jc+X7WsaRRKszG9z3BbqNAV5op ec2-user" }
variable "region" { default = "us-west-1" }
variable "private_key" {default = "AAABAAPlFQfkT6kkFWpJtdsKREpZvHYFH406S+M4PMM67lELdXM6acF2Lni0GjTs2oGRsLYLsJkkqtLuCABqjwgHvonDFZaWQGlCaMtSId0Q6+breP10U7XPNPijisECz3ed5/pviB9Abt7lZbV1xvXEpUcBIP3sR6mq2SIJkYiYI74TS3KSA8JmbxujHNW4zS2xKhxavypH9Nkdpv45VyIrYnT+9DmUOwvLK6t98Gb4AKfivaZqMx0YLknZIaYXLC4uu/ENjAeOnD80DUbSObrh/nCOQQt/C9eWIRK8yVww9gA13pS/qoVwlBe/4Wj64CNc3yNa79/mKxZb2pdKMykULAEAAACBAOGrPg/gdHRJkk8MXvrynqBuDi/PHEwE6AKAERIieaaP2K4CPfBuoiaw4pCZKed/+dGcOvHLa1uLsRZY7mWmejNet2jyDTgwAuMPc7HCSHgd6yk4I0X8Vcx/pTIKm6Dcz2f8LAVCczpKkFLqixgYPCRcChc5PTQzw8UXl/21Q7lBAAAAgQDPIL2M4R2joHZ8MpCIdZQioPZNrMi33B4c6vQF/LJ7tuElE/mmtG1HbI3nZcNquEfYmufJat89Ej9DUIowgQsBTaU6p5kEzXU0Grjngdi6QvDhSqN7bSRkndlfSz2HK350uvuDA/iBmMY3BGkVgkQJf8Sf/BYRVju4i6mEWQZ+6QAAAIAK6Wa5Pr1+2W40Z364RJSbv+wglpl86Iu8PoX7bWyymMUDprKwQiGuM3s2ojwuncrg4HB9joHx8c4KXMuooyoPlljXFDSGKKPEafLCnbSCGK2n8tdYRy89kIqXZmMrQFl3VufO7j79S2//+jcEZATEPXz7uRI8JHIisDXzVJQDrg==Private-MAC: 1926a8754cd956535d506be3b785ea720f74fead"}
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "subnet_one_cidr" { default = ["10.0.6.0/24", "10.0.5.0/24"] }
variable "subnet_two_cidr" { default = ["10.0.2.0/24", "10.0.3.0/24"] }
variable "route_table_cidr" { default = "0.0.0.0/0" }
variable "host" {default = "aws_instance.my_web_instance.public_dns"}
variable "web_ports" { default = ["22", "80", "443", "3306"] }
variable "db_ports" { default = ["22", "3306"] }
variable "images" {
  type = map(string)
  default = {
    "us-east-1"      = "ami-02e98f78"
    "us-east-2"      = "ami-04328208f4f0cf1fe"
    "us-west-1"      = "ami-0799ad445b5727125"
    "us-west-2"      = "ami-032509850cf9ee54e"
    "ap-south-1"     = "ami-0937dcc711d38ef3f"
    "ap-northeast-2" = "ami-018a9a930060d38aa"
    "ap-southeast-1" = "ami-04677bdaa3c2b6e24"
    "ap-southeast-2" = "ami-0c9d48b5db609ad6e"
    "ap-northeast-1" = "ami-0d7ed3ddb85b521a6"
    "ca-central-1"   = "ami-0de8b8e4bc1f125fe"
    "eu-central-1"   = "ami-0eaec5838478eb0ba"
    "eu-west-1"      = "ami-0fad7378adf284ce0"
    "eu-west-2"      = "ami-0664a710233d7c148"
    "eu-west-3"      = "ami-0854d53ce963f69d8"
    "eu-north-1"     = "ami-6d27a913"
  }
}