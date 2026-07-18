---

# Passing Arrays and Objects

The syntax is different depending on where the value comes from.

---

# Bicep Parameter File

Arrays use normal Bicep syntax.

Example:

```bicep
param allowedIps = [
  '10.0.0.1'
  '10.0.0.2'
  '10.0.0.3'
]
```

Objects:

```bicep
param tags = {
  Environment: 'Dev'
  Owner: 'Cloud Team'
}
```

---

# Azure DevOps Variable Library

Variable Groups store everything as **strings**.

For simple values:

```text
environment = dev
```

For arrays or objects, store them as JSON.

Array:

```text
["10.0.0.1","10.0.0.2","10.0.0.3"]
```

Object:

```text
{
  "Environment":"Dev",
  "Owner":"Cloud Team"
}
```

---

# Convert the JSON String Inside Bicep

If Azure DevOps passes a JSON string, convert it using `json()`.

Example:

```bicep
param allowedIps string

var allowedIpArray = json(allowedIps)
```

Now:

```bicep
allowedIpArray
```

is an actual Bicep array.

The same works for objects.

```bicep
param tags string

var resourceTags = json(tags)
```

---

# Example

### Variable Group

```text
allowedIps

["10.0.0.1","10.0.0.2"]
```

### YAML

```yaml
variables:
- group: NetworkVariables
```

Pass to Bicep:

```yaml
--parameters allowedIps="$(allowedIps)"
```

### Bicep

```bicep
param allowedIps string

var ipList = json(allowedIps)

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  ...
}
```

---

# Quick Reference

| Location | Array Format |
|-----------|--------------|
| Bicep Parameter File | `['a' 'b' 'c']` |
| Azure DevOps Variable | `["a","b","c"]` |
| Bicep after `json()` | Real array |

---

# Easy Way to Remember

```text
Bicep Parameters
=
Bicep syntax
```

```text
Azure DevOps Variable Groups
=
Everything is stored as text
```

```text
Need an array or object?
```

```text
Store it as JSON

↓

Pass it to Bicep

↓

Use json() to convert it back
```