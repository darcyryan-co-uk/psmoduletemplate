
# PowerShell Module Builder Script

Welcome to the **PowerShell Module Builder**!
This script allows you to automatically generate a PowerShell module with customizable properties. 

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
    - [Basic Usage](#basic-usage)
    - [Parameters](#parameters)
- [Examples](#examples)

## Overview

The `Build.ps1` script simplifies the creation of PowerShell modules. It generates a structured directory for the module, creates a module manifest (`.psd1`) and module script (`.psm1`), and fills them with the necessary metadata based on user input parameters.

## Features

- Automatic Module Directory Creation: Creates the required module directories.
- Template-based File Generation: Replaces placeholders in template files with user-provided values.
- Customizable Module Metadata: Set values such as `Name`, `Description`, `Version`, `Author`, and more.
- Error Handling: Checks for existing module directories and stops execution if overwriting is detected.
- CSharp class support.

## Prerequisites

- Windows OS
- PowerShell 5.0 or later
- Administrative privileges (if needed for specific paths)

## Usage

To run the script, open a PowerShell terminal and execute the script with the desired parameters.

### Basic Usage

```powershell
.\Build.ps1 -Name "MyModule"
```

**Warning:** By default, the `-OutputDirectory` variable is set as the current working directory. This means that the module will be created within the parent directory of the current function. To specify a different path, use the `-OutputDirectory` parameter explicitly.

### Parameters

- `-Name`: **(Mandatory)** The name of the module. Must not contain spaces.
- `-Description`: A short description of the module. Defaults to an empty string.
- `-Version`: The version number of the module. Defaults to `1.0`.
- `-Author`: The author of the module. Defaults to the current user (`$env:UserDomain\$env:UserName`).
- `-Company`: The company associated with the module. Defaults to `DarcyRyan`.
- `-GUID`: A unique identifier for the module. Automatically generated if not specified.
- `-DateTime`: The creation date of the module. Defaults to the current date.
- `-OutputDirectory`: The directory where the module will be created. Defaults to the current directory.

```powershell
.\Build.ps1 -Name "SampleModule" -Description "A sample PowerShell module" -Version "1.0.1" -Author "John Doe" -Company "ExampleCorp" -OutputDirectory "C:\Modules"
```

## Examples

### Example 1: Creating a Simple Module

```powershell
.\Build.ps1 -Name "NetworkTools"
```

This command creates a `NetworkTools` module with the following default settings:

- Author: Current user (`$env:UserDomain\$env:UserName`)
- Company: DarcyRyan
- Version: 1.0
- Output Directory: Current directory

### Example 2: Creating a Module with Custom Metadata

```powershell
.\Build.ps1 -Name "AdminTools" -Description "Admin tools for network management" -Version "1.2.0" -Author "Joe Bloggs" -Company "DarcyRyan"
```

This creates a module named `AdminTools` with:

- Custom description: Admin tools for network management
- Version: 1.2.0
- Author: Joe Bloggs
- Company: DarcyRyan

### Example 3: Specifying an Output Directory

```powershell
.\Build.ps1 -Name "DataProcessing" -OutputDirectory "D:\PowerShell\Modules"
```

This command generates the `DataProcessing` module in the specified `D:\PowerShell\Modules` directory.

### Example 4: Using the `-OutputDirectory` Argument

To explicitly specify where the module should be created, use the `-OutputDirectory` argument:

```powershell
.\Build.ps1 -Name "MyModule" -OutputDirectory "C:\Git\MyModule"
```

This command will create the `MyModule` in the `C:\Git\MyModule` directory.