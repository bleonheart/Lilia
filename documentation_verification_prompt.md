# Documentation Verification Prompt

## Purpose
This prompt is designed to systematically verify documentation files against their corresponding code implementations in the Lilia gamemode. Use this prompt for each documentation file listed in `documentation_verification_todo.md`.

## Input Parameters
- **Documentation File Path**: The full path to the markdown file being verified
- **Code Search Scope**: The corresponding code directory/file to examine
- **Verification Focus**: Specific aspects to verify (functions, hooks, configuration, etc.)

## Verification Process

### Step 1: Documentation Analysis
Read and analyze the specified documentation file:
1. Identify the main topics covered
2. Extract function signatures, hook names, and configuration options mentioned
3. Note any code examples or usage patterns described
4. Identify version information or changelog references

### Step 2: Code Implementation Search
Search the corresponding code files for:
1. Function definitions that match documented functions
2. Hook implementations mentioned in documentation
3. Configuration variables and their usage
4. Code examples that match documented usage

### Step 3: Accuracy Verification
Compare documentation against code:
1. **Function Signatures**: Verify parameter names, types, and return values
2. **Hook Usage**: Confirm hook names, parameters, and behavior
3. **Configuration Options**: Check default values and descriptions
4. **Code Examples**: Ensure examples are current and functional
5. **Version Information**: Verify version numbers and changelog accuracy

### Step 4: Completeness Assessment
Identify missing information:
1. Undocumented functions or features
2. Missing parameter descriptions
3. Incomplete code examples
4. Outdated configuration options

### Step 5: Documentation Updates
Fix identified issues:
1. Update function signatures and descriptions
2. Add missing parameter documentation
3. Include new functions or features
4. Remove obsolete information
5. Fix code examples and usage patterns

## Output Requirements
- **Summary of Changes**: Brief overview of what was verified and updated
- **Specific Fixes**: Detailed list of corrections made
- **Missing Documentation**: List of items that need documentation
- **Verification Status**: Mark as completed in todo list

## Quality Standards
- Documentation should be clear and accessible to developers
- Code examples must be functional and up-to-date
- Parameter descriptions should be accurate and complete
- Version information should reflect current implementation
- Cross-references should be accurate and functional

## Example Usage

### For Library Documentation (lia.*.md)
```
Documentation File: documentation/docs/libraries/lia.util.md
Code Scope: gamemode/core/libraries/util.lua
Verification Focus: utility functions, helper methods

Process one function at a time, verifying:
1. Function signature matches documentation
2. Parameter descriptions are accurate
3. Return values are properly documented
4. Usage examples work correctly
```

### For Module Documentation
```
Documentation File: documentation/docs/modules/administration/about.md
Code Scope: gamemode/modules/administration/
Verification Focus: module structure, main features, dependencies

Verify:
1. Module description matches implementation
2. Feature list is complete and current
3. Dependencies and requirements are accurate
4. Configuration options are documented
```

## Important Notes
- **One Library at a Time**: Process only one documentation file per verification run
- **Code First**: Always verify against actual code implementation
- **Conservative Updates**: Only update documentation when certain of accuracy
- **Track Changes**: Document all modifications made during verification
- **Test Examples**: Verify that code examples actually work

## Verification Checklist
- [ ] Documentation file read and analyzed
- [ ] Corresponding code files examined
- [ ] Function signatures verified
- [ ] Hook implementations confirmed
- [ ] Configuration options checked
- [ ] Code examples tested
- [ ] Missing information identified
- [ ] Documentation updated as needed
- [ ] Changes documented and summarized
