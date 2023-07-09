#!/bin/bash
read -r name mod1 mod2 <<<"$@"

# Make sure the arguments are passed
[ $# -ne 3 ] && {
  echo "Usage: $0 [name] [module1] [module2]"
  exit 1
}

# Ensure the second module exists
echo "Creating $mod2"
mkdir -p "$mod2"

# Change to the first module and pull the state file
cd "$mod1" || exit
echo "Pulling state for $mod1 into $name.tfstate"
terragrunt state pull >"$mod2/$name".tfstate
cp terragrunt.hcl "$mod2"/terragrunt.hcl

# Change to the second module to init and push the state
cd "$mod2" || exit
echo "Pushing state for $mod2 from $name.tfstate"
terragrunt init
terragrunt state push "$mod2/$name".tfstate

# Show the plan to ensure there are no changes
terragrunt plan
