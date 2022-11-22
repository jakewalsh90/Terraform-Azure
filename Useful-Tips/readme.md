## Readme

Within this file I have included smaller arguments, snippets, and useful tips I've learnt!

A list of examples is below:

1. [Using Count and Length to create multiple Resources - and then further actions based on Resources created using Count. ](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Useful-Tips#1-using-count-and-subsequently-length-to-create-additional-resources-based-on-those-created-using-count)

<hr>

#### 1. Using Count and Length together

This example uses Count to create a number of Subnets, and then uses Length within an NSG Resource block to apply that NSG to all created Subnets:

![Using Count with Length](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Useful-Tips/images/CountLength.png)

Once you have created the primary resource (using Count), you can then use length(original_resource_name) to create other resources/associations/actions that will be carried out based on the value used within Count. This saves you from using a Count number or variable in multiple locations, so results in cleaner code. A Code example is here: [Count-and-Length.tf](https://github.com/jakewalsh90/Terraform-Azure/blob/main/Useful-Tips/Count-and-length.tf)