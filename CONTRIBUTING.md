# Contributing to the GCPowerShell Repository

If you wish to contribute to the GCPowerShell modules please do so. If it is a minor fix or typo just send a pull request. If you want to make large changes to the project create a new issue and explain your ideas.

I am open to adding more contributors to this project so if you send a pull request and it is merged, expect a contributor invite to follow. You do not have to accept.

*   [Style Guide](#style-guide)
*   [PowerShell Gallery](#powershell-gallery)
*   [Code of Conduct](#code-of-conduct)
*   [How to Contribute](#how-to-contribute)

## Style Guide

If you wish to contribute to the GCPowerShell repository please follow these style guidelines:

*   All public facing functions must have the noun prefixed with `GC`.
*   Tab is two spaces.
*   Opening bracket on the same line as the statement.
*   All variable names must be long and descriptive.
*   Use approved verbs (`Get-Verb` is your friend).
*   Always use [Comment Based Help](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help).
*   Do not add comments to code unless they explain some hidden reason for the codes existence.
*   Use valid [parameter attributes](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters).
*   Add `Write-Verbose` statements throughout your code.

## PowerShell Gallery

After changes to a module have been merged into the master branch Grant Carthew will publish the module to the [PowerShell Gallery](https://www.powershellgallery.com/items?q=grantcarthew).

## Code of Conduct

This repository has a [Code of Conduct](CODE_OF_CONDUCT.md) to help maintain a friendly community.

## How to Contribute

1.  Fork it!
2.  Create your feature branch: `git checkout -b my-new-feature`
3.  Commit your changes: `git commit -am 'Add some feature'`
4.  Push to the branch: `git push origin my-new-feature`
5.  Submit a pull request :D
