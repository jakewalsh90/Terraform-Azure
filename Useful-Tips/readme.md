## Readme

Within this file I have included smaller arguments, snippets, and useful tips I've learnt!

A list of examples is below:

1. Using Count and Length to create multiple Resources - and then further actions based on Resources created using Count. 

### 1. Using Count and subsequently, Length to create additional Resources based on those created using Count.

    This example uses Count to create a number of Subnets, and then uses Length within an NSG Resource block to apply that NSG to all created Subnets:

    ![Using Count with Length](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Useful-Tips/images/CountLength.png)

