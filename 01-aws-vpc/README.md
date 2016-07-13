Initial Infrastructure
======================
This first module is designed to get your familiar with the Terraform syntax,
command line, and recommended workflow. We will create a few resources in AWS
and then explore various scenarios to get us thinking critically about how
Terraform manages resources.

Planning
--------
The first phase of any Terraform process should be the "plan". Terraform plans
are no-op runs that sync the state with the remote(s) and output a list of
changes that will occur when applied. Plans can optionally be saved to an
executable file to guarantee the contents of the apply will exactly match the
plan. Run the following command:
```
    $ terraform plan 01-aws-vpc
```

You will notice Terraform uses the "+" to denote a new resource being added.
Terraform will similarly use a "-" to denote a resource that will be removed,
and a "~" to indicate a resource that will have changed attributes in place.

After the plan runs successfully, you might like to visualize the infrastructure
that you are building. We can use the `terraform graph` command to do that. Graphing
makes use of the `graphviz` package. This has been installed for you during Vagrant
provisioning.
```
   $ terraform graph 01-aws-vpc | dot -Tpng > graph.png
```

Open the `graph.png` file to see the dependency graph.

Applying
--------
As mentioned before, a Terraform plan is a no-op and never changes live
infrastructure. The Terraform apply is the process by which infrastructure is
changed and managed. Let's run the apply now:
```
    $ terraform apply 01-aws-vpc
```

This operation should be fairly quick since we are only creating a few
resources.

If you open the Amazon console and look under EC2 -> Key Pairs, you will see
a new keypair has been created named "environment_name". We will use this
keypair to connect to new EC2 instances created on Amazon in the next parts
of this tutorial.

Let's see what happens if we run the plan again:
```
    $ terraform plan 01-aws-vpc
```

You will notice that the output indicates no resources are to change. To further
illustrate the power of Terraform, run `terraform apply 01-aws-vpc` again.
Terraform will refresh the remote state (more on this later), and then 0
resources will be changed. Terraform is intelligent enough to maintain and
manage state.

Critical Thinking
-----------------
What will happen if we delete this keypair from EC2 outside of Terraform (via
the web interface)? Will Terraform re-create it? Will Terraform throw an error?
Will Terraform ignore it?

Go into the Amazon Key Pair page in the AWS Console and delete the key using
the Web UI. Back on your local terminal, run `terraform plan 01-aws-vpc`.
Viola! Terraform has intelligently detected that the keypair was removed
out-of-band and re-created it for us.
