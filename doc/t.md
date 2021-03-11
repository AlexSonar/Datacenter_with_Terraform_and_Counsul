# This module encapsulates all the resources we need for our nomad cluster

  # A bit of extra cleverness if you have multiple subnets in different AZs:
  #   You can make this highly available by having 3 subnets (one in each of your region's Availability Zones) and then doing
  #
  #   availability_zone = var.azs[count.index % len(azs)]
  #
  # That way, you'll just loop over the subnets repeatedly and get an even distribution of instances
  # availability_zone       = element(split(",", var.azs), count.index)

